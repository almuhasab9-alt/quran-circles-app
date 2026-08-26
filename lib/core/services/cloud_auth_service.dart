import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// حساب مستخدم من السحابة
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
        id: j['id'] as String,
        username: j['username'] as String? ?? '',
        fullName: j['fullName'] as String? ?? '',
        role: j['role'] as String? ?? 'teacher',
        halaqaId: j['halaqaId'] as String? ?? '',
        active: j['active'] as bool? ?? true,
      );
}

class AuthResult {
  final bool ok;
  final String? error;
  final CloudAccount? user;
  const AuthResult({required this.ok, this.error, this.user});
}

/// خدمة المصادقة السحابية — Cloudflare Worker + D1
/// كلمات المرور مشفرة في السحابة (PBKDF2) ولا تُخزن محلياً أبداً.
///
/// **مهم لليمن:** بعض النطاقات المجانية (workers.dev) محجوبة من مزوّدي
/// الخدمة. لذلك نعتمد «قنوات اتصال متعددة» مع تبديل تلقائي (failover):
/// القناة الأولى مباشرة، والثالثة بروكسي سحابي عام (CORS Proxy) يلتفّ
/// حول حجب DNS — وكله يتم بدون أي إعداد من المستخدم وبدون VPN.
class CloudAuthService {
  /// القناة الأساسية (للتوافق مع النسخ القديمة)
  static const baseUrl = 'https://quran-auth-api.almuhasab9-alt.workers.dev';

  /// قنوات الاتصال بالخادم — تُجرَّب بالترتيب حتى تنجح إحداها:
  /// 1) العنوان المباشر للـ Worker
  /// 2) عنوان بديل بصيغة مختلفة (يتجاوز بعض حجب المضيفات الفرعية)
  /// 3) بروكسي سحابي عام (cors.sh) — يحلّ DNS من خوادمه خارج اليمن ويمرّر
  ///    كل الطلبات (GET/POST/PUT/DELETE) والترويسات (Authorization) كما هي
  static const List<String> _endpoints = [
    'https://quran-auth-api.almuhasab9-alt.workers.dev',
    'https://quran-auth-api.almuhasab9-alt.workers.dev.',
    'https://proxy.cors.sh/https://quran-auth-api.almuhasab9-alt.workers.dev',
  ];

  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';
  static const _kWorkingEndpoint = 'auth_working_endpoint';

  /// آخر قناة ناجحة — تُستخدم أولاً في الطلبات اللاحقة (أسرع)
  static String? _activeEndpoint;

  String? _token;
  CloudAccount? _current;

  CloudAccount? get currentUser => _current;
  String? get token => _token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// ترتيب القنوات للمحاولة: القناة الناجحة سابقاً أولاً ثم بقية القنوات.
  static Future<List<String>> _endpointOrder() async {
    var first = _activeEndpoint;
    if (first == null) {
      try {
        final p = await SharedPreferences.getInstance();
        first = p.getString(_kWorkingEndpoint);
        _activeEndpoint = first;
      } catch (_) {}
    }
    if (first == null || !_endpoints.contains(first)) {
      return List.of(_endpoints);
    }
    return [first, ..._endpoints.where((e) => e != first)];
  }

  static Future<void> _markWorking(String endpoint) async {
    _activeEndpoint = endpoint;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kWorkingEndpoint, endpoint);
    } catch (_) {}
  }

  /// واجهة عامة لخدمات أخرى (المزامنة السحابية) لاستخدام قنوات الاتصال
  /// المتعددة مع التبديل التلقائي.
  Future<http.Response> apiRequest(
    String method,
    String path, {
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: 20),
  }) =>
      _request(method, path, headers: headers, body: body, timeout: timeout);

  /// تنفيذ طلب HTTP مع تبديل تلقائي بين القنوات عند فشل الشبكة
  /// (فشل DNS / انتهاء المهلة / رفض الاتصال). إن أجاب الخادم بأي رد
  /// (حتى 4xx) تُثبَّت القناة ويُعاد الرد كما هو.
  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final order = await _endpointOrder();
    Object? lastError;
    for (final base in order) {
      try {
        final uri = Uri.parse('$base$path');
        http.Response r;
        switch (method) {
          case 'GET':
            r = await http.get(uri, headers: headers).timeout(timeout);
            break;
          case 'POST':
            r = await http.post(uri, headers: headers, body: body).timeout(timeout);
            break;
          case 'PUT':
            r = await http.put(uri, headers: headers, body: body).timeout(timeout);
            break;
          case 'DELETE':
            r = await http.delete(uri, headers: headers).timeout(timeout);
            break;
          default:
            throw UnsupportedError(method);
        }
        await _markWorking(base);
        return r;
      } catch (e) {
        lastError = e; // قناة فاشلة — نجرّب التالية
        continue;
      }
    }
    throw lastError ?? Exception('كل قنوات الاتصال فشلت');
  }

  // ---------- الجلسة المحفوظة ----------
  Future<CloudAccount?> restoreSession() async {
    final p = await SharedPreferences.getInstance();
    _token = p.getString(_kToken);
    final userStr = p.getString(_kUser);
    if (_token == null || userStr == null) return null;
    try {
      _current = CloudAccount.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      // تحقق من صلاحية التوكن في الخلفية
      final r = await _request('GET', '/api/me', headers: _headers,
          timeout: const Duration(seconds: 12));
      if (r.statusCode != 200) {
        await signOut();
        return null;
      }
      return _current;
    } catch (_) {
      // في حال انقطاع الشبكة نسمح بالجلسة المحفوظة مؤقتاً
      return _current;
    }
  }

  // ---------- تسجيل الدخول ----------
  Future<AuthResult> signIn(String username, String password) async {
    try {
      final r = await _request('POST', '/api/login',
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username.trim(), 'password': password}));
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      if (r.statusCode != 200) {
        return AuthResult(ok: false, error: data['error'] as String? ?? 'فشل تسجيل الدخول');
      }
      _token = data['token'] as String;
      _current = CloudAccount.fromJson(data['user'] as Map<String, dynamic>);
      final p = await SharedPreferences.getInstance();
      await p.setString(_kToken, _token!);
      await p.setString(_kUser, jsonEncode(data['user']));
      return AuthResult(ok: true, user: _current);
    } catch (e) {
      return const AuthResult(ok: false, error: 'تعذر الاتصال بالخادم. تحقق من الإنترنت.');
    }
  }

  Future<void> signOut() async {
    _token = null;
    _current = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_kToken);
    await p.remove(_kUser);
  }

  // ---------- إدارة الحسابات (مشرف فقط) ----------
  Future<List<CloudAccount>> listAccounts() async {
    final r = await _request('GET', '/api/accounts', headers: _headers);
    if (r.statusCode != 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      throw Exception(data['error'] ?? 'فشل جلب الحسابات');
    }
    final list = (jsonDecode(r.body) as Map<String, dynamic>)['accounts'] as List;
    return list.map((e) => CloudAccount.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AuthResult> createTeacher({
    required String username,
    required String password,
    required String fullName,
    String halaqaId = '',
  }) async {
    try {
      final r = await _request('POST', '/api/accounts',
          headers: _headers,
          body: jsonEncode({
            'username': username,
            'password': password,
            'fullName': fullName,
            'halaqaId': halaqaId,
          }));
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      if (r.statusCode != 200) {
        return AuthResult(ok: false, error: data['error'] as String? ?? 'فشل إنشاء الحساب');
      }
      return AuthResult(ok: true, user: CloudAccount.fromJson(data['user'] as Map<String, dynamic>));
    } catch (_) {
      return const AuthResult(ok: false, error: 'تعذر الاتصال بالخادم');
    }
  }

  /// تعديل حساب: تغيير اسم مستخدم/كلمة مرور المشرف (يتطلب كلمة المرور الحالية)،
  /// أو تعديل بيانات معلم (اسم، حلقة، كلمة مرور جديدة، تفعيل).
  Future<AuthResult> updateAccount(
    String accountId, {
    String? newUsername,
    String? newPassword,
    String? currentPassword,
    String? fullName,
    String? halaqaId,
    bool? active,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (newUsername != null) body['newUsername'] = newUsername;
      if (newPassword != null) body['newPassword'] = newPassword;
      if (currentPassword != null) body['currentPassword'] = currentPassword;
      if (fullName != null) body['fullName'] = fullName;
      if (halaqaId != null) body['halaqaId'] = halaqaId;
      if (active != null) body['active'] = active;
      final r = await _request('PUT', '/api/accounts/$accountId',
          headers: _headers, body: jsonEncode(body));
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      if (r.statusCode != 200) {
        return AuthResult(ok: false, error: data['error'] as String? ?? 'فشل التعديل');
      }
      final updated = CloudAccount.fromJson(data['user'] as Map<String, dynamic>);
      // لو عدّل المشرف حسابه نحدّث الجلسة المحفوظة
      if (_current?.id == accountId) {
        _current = updated;
        final p = await SharedPreferences.getInstance();
        await p.setString(_kUser, jsonEncode(data['user']));
      }
      return AuthResult(ok: true, user: updated);
    } catch (_) {
      return const AuthResult(ok: false, error: 'تعذر الاتصال بالخادم');
    }
  }

  Future<AuthResult> deleteTeacher(String accountId) async {
    try {
      final r = await _request('DELETE', '/api/accounts/$accountId',
          headers: _headers);
      if (r.statusCode != 200) {
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        return AuthResult(ok: false, error: data['error'] as String? ?? 'فشل الحذف');
      }
      return const AuthResult(ok: true);
    } catch (_) {
      return const AuthResult(ok: false, error: 'تعذر الاتصال بالخادم');
    }
  }
}
