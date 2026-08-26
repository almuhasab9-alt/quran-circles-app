import 'api_client.dart';

/// حساب دخول من نظام المصادقة السحابي (quran-auth-api)
class AccountInfo {
  final String id;
  final String username;
  final String fullName;
  final String role; // supervisor | teacher
  final String halaqaId;
  final bool active;

  const AccountInfo({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.halaqaId,
    required this.active,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> j) => AccountInfo(
        id: (j['id'] ?? '') as String,
        username: (j['username'] ?? '') as String,
        fullName: (j['fullName'] ?? '') as String,
        role: (j['role'] ?? 'teacher') as String,
        halaqaId: (j['halaqaId'] ?? '') as String,
        active: (j['active'] ?? true) as bool,
      );

  bool get isSupervisor => role == 'supervisor';
}

/// الوصول إلى حسابات الدخول — مشرف فقط (الخادم يفرض ذلك بـ 403 لغيره)
class AccountsRepository {
  final ApiClient api;
  AccountsRepository(this.api);

  Future<List<AccountInfo>> list() async {
    final r = await api.getAccounts();
    final items = (r['accounts'] as List? ?? []);
    return items
        .map((e) => AccountInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTeacher(String username, String password, String fullName) =>
      api.createAccount(username, password, fullName);

  /// تغيير كلمة المرور. currentPassword مطلوب فقط عند تغيير كلمة المرور لنفسك.
  Future<void> changePassword(String id, String newPassword, {String? currentPassword}) =>
      api.updateAccount(id, {
        'newPassword': newPassword,
        if (currentPassword != null && currentPassword.isNotEmpty)
          'currentPassword': currentPassword,
      });

  /// تغيير اسم المستخدم. currentPassword مطلوب فقط عند تغيير اسمك أنت.
  Future<void> changeUsername(String id, String newUsername, {String? currentPassword}) =>
      api.updateAccount(id, {
        'newUsername': newUsername,
        if (currentPassword != null && currentPassword.isNotEmpty)
          'currentPassword': currentPassword,
      });

  Future<void> changeFullName(String id, String fullName) =>
      api.updateAccount(id, {'fullName': fullName});

  /// تفعيل/تعطيل حساب (لا يمكن تطبيقه على حسابك أنت — الخادم يرفضه)
  Future<void> setActive(String id, bool active) =>
      api.updateAccount(id, {'active': active});
}
