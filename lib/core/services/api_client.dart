import 'dart:convert';
import 'package:http/http.dart' as http;

/// عميل HTTP للـ Cloudflare Worker API فوق D1
/// يستبدل drift المحلي باتصالات سحابية
class ApiClient {
  // سيتم تحديثه تلقائياً من إعدادات التطبيق
  static const String defaultBaseUrl = 'https://quran-circles-api.almuhasab9-alt.workers.dev';
  static const String authBaseUrl = 'https://quran-auth-api.almuhasab9-alt.workers.dev';

  // التوكن المشترك لجميع الطلبات (يُعيّن بعد تسجيل الدخول)
  static String? authToken;

  final String baseUrl;
  final http.Client _client;

  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? defaultBaseUrl,
        _client = client ?? http.Client();

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (ApiClient.authToken != null)
          'Authorization': 'Bearer ${ApiClient.authToken}',
      };

  /// تسجيل الدخول عبر quran-auth-api — يخزن التوكن في ApiClient.authToken
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await _client.post(
      Uri.parse('$authBaseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode != 200) {
      throw ApiException('اسم المستخدم أو كلمة المرور غير صحيحة');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getList(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final res = await _client.get(uri, headers: _headers());
    if (res.statusCode != 200) {
      throw ApiException('GET $path failed: ${res.statusCode} ${res.body}');
    }
    final list = jsonDecode(res.body) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getOne(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final res = await _client.get(uri, headers: _headers());
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw ApiException('GET $path failed: ${res.statusCode} ${res.body}');
    }
    final decoded = jsonDecode(res.body);
    if (decoded == null) return null;
    return decoded as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw ApiException('POST $path failed: ${res.statusCode} ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final res = await _client.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) {
      throw ApiException('PUT $path failed: ${res.statusCode} ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> delete(String path) async {
    final res = await _client.delete(Uri.parse('$baseUrl$path'), headers: _headers());
    if (res.statusCode != 200) {
      throw ApiException('DELETE $path failed: ${res.statusCode} ${res.body}');
    }
  }

  void close() => _client.close();
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}
