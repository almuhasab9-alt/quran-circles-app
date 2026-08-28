import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_config.dart';

/// حساب مستخدم من السحابة (Firebase Firestore)
///
/// نفس الواجهة التي كانت عليها خدمة Cloudflare السابقة حرفياً، حتى لا تتغيّر
/// أي شاشة في التطبيق. الحسابات تُخزَّن في مجموعة `accounts` في Firestore،
/// وكلمات المرور تُخزَّن مشفرة (salted SHA-256) ولا تُخزَّن محلياً أبداً.
class CloudAccount {
  final String id;
  final String username;
  final String fullName;
  final String role; // supervisor | teacher
  final String halaqaId;
  final bool active;
  const CloudAccount({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.halaqaId,
    required this.active,
  });
  bool get isSupervisor => role == 'supervisor';
  bool get isTeacher => role == 'teacher';

  factory CloudAccount.fromJson(Map<String, dynamic> j) => CloudAccount(
        id: (j['id'] as String?) ?? '',
        username: j['username'] as String? ?? '',
        fullName: j['fullName'] as String? ?? '',
        role: j['role'] as String? ?? 'teacher',
        halaqaId: j['halaqaId'] as String? ?? '',
        active: j['active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullName': fullName,
        'role': role,
        'halaqaId': halaqaId,
        'active': active,
      };
}

class AuthResult {
  final bool ok;
  final String? error;
  final CloudAccount? user;
  const AuthResult({required this.ok, this.error, this.user});
}

/// خدمة المصادقة السحابية — Firebase Firestore
///
/// استُبدلت بخدمة Cloudflare (workers.dev) المحظورة في اليمن. تستخدم نفس
/// أسماء الدوال والخصائص حرفياً (signIn/restoreSession/listAccounts/...)
/// حتى لا يتأثر أي كود في الشاشات أو الخدمات الأخرى.
///
/// ملاحظة معمارية: لا نستخدم Firebase Auth لأنه يتطلب بريداً إلكترونياً،
/// بينما التطبيق يعتمد (اسم مستخدم + كلمة مرور). بدلاً من ذلك تُخزَّن
/// الحسابات في مجموعة `accounts` في Firestore مع تشفير كلمات المرور.
class CloudAuthService {
  /// معرف الوثيقة داخل مجموعة `accounts` يطابق معرف الحساب نفسه (id).
  static const String _col = 'accounts';

  static const _kUser = 'auth_user';

  CloudAccount? _current;

  CloudAccount? get currentUser => _current;

  /// التوكن لم يعد مستخدماً مع Firestore (المصادقة تتم عبر قواعد الأمان)،
  /// لكنه يبقى كخاصية للتوافق مع الكود القديم (يعيد قيمة غير فارغة عند الدخول).
  String? get token => _current == null ? null : 'fb:${_current!.id}';

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// هل Firebase جاهز (تم تمرير ملف الإعدادات)؟ إن لم يكن فالدوال تفشل
  /// برسالة عربية واضحة بدلاً من إيقاف التطبيق.
  bool get _ready => FirebaseConfig.isConfigured;

  Future<AuthResult> _notReady() async => const AuthResult(
      ok: false,
      error: 'قاعدة Firebase غير مهيأة بعد — أضِف ملف google-services.json ثم أعد البناء');

  // ------------------------------------------------------------------
  // تشفير كلمات المرور: salt عشوائي + SHA-256 (يُخزَّن "salt:hash")
  // ------------------------------------------------------------------
  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt::$password');
    return sha256.convert(bytes).toString();
  }

  static String _newSalt() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static bool _verifyPassword(String password, String stored) {
    final i = stored.indexOf(':');
    if (i <= 0) return false;
    final salt = stored.substring(0, i);
    final hash = stored.substring(i + 1);
    return _hashPassword(password, salt) == hash;
  }

  // ------------------------------------------------------------------
  // استعادة الجلسة المحفوظة محلياً + التحقق من أن الحساب ما زال نشطاً
  // ------------------------------------------------------------------
  Future<CloudAccount?> restoreSession() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kUser);
    if (raw == null) return null;
    try {
      final acc = CloudAccount.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (!_ready) {
        // بلا إنترنت/إعداد: نعيد الحساب المحفوظ كما هو (وضع عدم الاتصال)
        _current = acc;
        return acc;
      }
      // التحقق من السحابة: قد يكون الحساب عُطِّل أو حُذف من جهاز آخر
      final snap = await _db.collection(_col).doc(acc.id).get();
      if (!snap.exists) {
        await signOut();
        return null;
      }
      final fresh = CloudAccount.fromJson({...snap.data()!, 'id': snap.id});
      if (!fresh.active) {
        await signOut();
        return null;
      }
      _current = fresh;
      await p.setString(_kUser, jsonEncode(fresh.toJson()));
      return fresh;
    } catch (_) {
      // تعذّر الاتصال — استخدم النسخة المحفوظة (وضع عدم الاتصال)
      try {
        final acc = CloudAccount.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        _current = acc;
        return acc;
      } catch (_) {
        return null;
      }
    }
  }

  // ------------------------------------------------------------------
  // تسجيل الدخول: بحث بالاسم ثم التحقق من كلمة المرور
  // ------------------------------------------------------------------
  Future<AuthResult> signIn(String username, String password) async {
    if (!_ready) return _notReady();
    final u = username.trim().toLowerCase();
    if (u.isEmpty || password.isEmpty) {
      return const AuthResult(ok: false, error: 'أدخل اسم المستخدم وكلمة المرور');
    }
    try {
      final q = await _db
          .collection(_col)
          .where('username', isEqualTo: u)
          .limit(1)
          .get();
      if (q.docs.isEmpty) {
        return const AuthResult(ok: false, error: 'اسم المستخدم غير موجود');
      }
      final doc = q.docs.first;
      final data = doc.data();
      final stored = data['passwordHash'] as String? ?? '';
      if (!_verifyPassword(password, stored)) {
        return const AuthResult(ok: false, error: 'كلمة المرور غير صحيحة');
      }
      final acc = CloudAccount.fromJson({...data, 'id': doc.id});
      if (!acc.active) {
        return const AuthResult(ok: false, error: 'هذا الحساب موقوف — راجع المشرف');
      }
      _current = acc;
      final p = await SharedPreferences.getInstance();
      await p.setString(_kUser, jsonEncode(acc.toJson()));
      return AuthResult(ok: true, user: acc);
    } on FirebaseException catch (e) {
      return AuthResult(ok: false, error: 'تعذر الاتصال بقاعدة البيانات (${e.code})');
    } catch (_) {
      return const AuthResult(ok: false, error: 'تعذر الاتصال بقاعدة البيانات');
    }
  }

  Future<void> signOut() async {
    _current = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_kUser);
  }

  // ------------------------------------------------------------------
  // إدارة الحسابات (للمشرف)
  // ------------------------------------------------------------------
  Future<List<CloudAccount>> listAccounts() async {
    if (!_ready) return const [];
    final snap = await _db.collection(_col).get();
    final list = snap.docs
        .map((d) => CloudAccount.fromJson({...d.data(), 'id': d.id}))
        .toList();
    // ترتيب في الذاكرة: المشرف أولاً ثم المعلمون أبجدياً — لا فهرس مطلوب
    list.sort((a, b) {
      if (a.isSupervisor != b.isSupervisor) return a.isSupervisor ? -1 : 1;
      return a.username.compareTo(b.username);
    });
    return list;
  }

  /// إنشاء حساب معلم جديد (اسم مستخدم فريد + كلمة مرور مشفرة)
  Future<AuthResult> createTeacher({
    required String username,
    required String password,
    required String fullName,
    String halaqaId = '',
  }) async {
    if (!_ready) return _notReady();
    final u = username.trim().toLowerCase();
    if (u.isEmpty || password.length < 6) {
      return const AuthResult(ok: false, error: 'اسم المستخدم مطلوب وكلمة المرور 6 أحرف على الأقل');
    }
    try {
      final dup = await _db.collection(_col).where('username', isEqualTo: u).limit(1).get();
      if (dup.docs.isNotEmpty) {
        return const AuthResult(ok: false, error: 'اسم المستخدم مستخدم مسبقاً');
      }
      final ref = _db.collection(_col).doc();
      final salt = _newSalt();
      await ref.set({
        'username': u,
        'fullName': fullName.trim(),
        'role': 'teacher',
        'halaqaId': halaqaId,
        'active': true,
        'passwordHash': '$salt:${_hashPassword(password, salt)}',
        'createdAt': FieldValue.serverTimestamp(),
      });
      final acc = CloudAccount(
          id: ref.id, username: u, fullName: fullName.trim(),
          role: 'teacher', halaqaId: halaqaId, active: true);
      return AuthResult(ok: true, user: acc);
    } catch (_) {
      return const AuthResult(ok: false, error: 'فشل إنشاء الحساب — تحقق من الاتصال');
    }
  }

  /// تعديل حساب (المشرف لأي حساب، أو المستخدم لنفسه مع كلمة المرور الحالية)
  Future<AuthResult> updateAccount(
    String accountId, {
    String? newUsername,
    String? newPassword,
    String? currentPassword,
    String? fullName,
    String? halaqaId,
    bool? active,
  }) async {
    if (!_ready) return _notReady();
    try {
      final ref = _db.collection(_col).doc(accountId);
      final snap = await ref.get();
      if (!snap.exists) {
        return const AuthResult(ok: false, error: 'الحساب غير موجود');
      }
      final data = snap.data()!;
      final isSelf = _current?.id == accountId;

      // تغيير بياناتي يتطلب التحقق من كلمة المرور الحالية
      if (isSelf && currentPassword != null) {
        final stored = data['passwordHash'] as String? ?? '';
        if (!_verifyPassword(currentPassword, stored)) {
          return const AuthResult(ok: false, error: 'كلمة المرور الحالية غير صحيحة');
        }
      }

      final update = <String, dynamic>{};
      if (fullName != null) update['fullName'] = fullName.trim();
      if (halaqaId != null) update['halaqaId'] = halaqaId;
      if (active != null) update['active'] = active;

      if (newUsername != null && newUsername.trim().isNotEmpty) {
        final u = newUsername.trim().toLowerCase();
        final dup = await _db
            .collection(_col)
            .where('username', isEqualTo: u)
            .limit(1)
            .get();
        if (dup.docs.isNotEmpty && dup.docs.first.id != accountId) {
          return const AuthResult(ok: false, error: 'اسم المستخدم مستخدم مسبقاً');
        }
        update['username'] = u;
      }
      if (newPassword != null && newPassword.isNotEmpty) {
        if (newPassword.length < 6) {
          return const AuthResult(ok: false, error: 'كلمة المرور الجديدة 6 أحرف على الأقل');
        }
        final salt = _newSalt();
        update['passwordHash'] = '$salt:${_hashPassword(newPassword, salt)}';
      }
      if (update.isEmpty) {
        final acc = CloudAccount.fromJson({...data, 'id': snap.id});
        return AuthResult(ok: true, user: acc);
      }
      await ref.update(update);
      final fresh = await ref.get();
      final acc = CloudAccount.fromJson({...fresh.data()!, 'id': fresh.id});
      // حدّث النسخة المحلية إن كان التعديل على حسابي الحالي
      if (isSelf) {
        _current = acc;
        final p = await SharedPreferences.getInstance();
        await p.setString(_kUser, jsonEncode(acc.toJson()));
      }
      return AuthResult(ok: true, user: acc);
    } catch (_) {
      return const AuthResult(ok: false, error: 'فشل حفظ التعديلات — تحقق من الاتصال');
    }
  }

  Future<AuthResult> deleteTeacher(String accountId) async {
    if (!_ready) return _notReady();
    try {
      await _db.collection(_col).doc(accountId).delete();
      return const AuthResult(ok: true);
    } catch (_) {
      return const AuthResult(ok: false, error: 'فشل الحذف — تحقق من الاتصال');
    }
  }

  // ------------------------------------------------------------------
  // إنشاء حساب المشرف الافتراضي تلقائياً عند أول تشغيل (admin / admin123)
  // يُستدعى من شاشة الدخول عندما تكون قاعدة الحسابات فارغة تماماً.
  // ------------------------------------------------------------------
  Future<AuthResult> ensureSupervisorExists() async {
    if (!_ready) return _notReady();
    try {
      final snap = await _db.collection(_col).limit(1).get();
      if (snap.docs.isNotEmpty) return const AuthResult(ok: true);
      final salt = _newSalt();
      final ref = _db.collection(_col).doc();
      await ref.set({
        'username': 'admin',
        'fullName': 'المشرف العام',
        'role': 'supervisor',
        'halaqaId': '',
        'active': true,
        'passwordHash': '$salt:${_hashPassword('admin123', salt)}',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return const AuthResult(ok: true);
    } catch (_) {
      return const AuthResult(ok: false, error: 'تعذر تهيئة حساب المشرف');
    }
  }
}
