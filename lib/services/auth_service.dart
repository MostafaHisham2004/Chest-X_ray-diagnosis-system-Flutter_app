import '../models/app_user.dart';
import 'api_client.dart';

class AuthSession {
  final String token;
  final String role;
  final AppUser user;

  const AuthSession({
    required this.token,
    required this.role,
    required this.user,
  });
}

class AuthService {
  final ApiClient _api;

  AuthService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final body = await _api.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    return _sessionFromBody(body);
  }

  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    String? medicalHistory,
  }) async {
    final body = await _api.post('/auth/signup', body: {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'dob': dob,
      if (medicalHistory != null) 'medical_history': medicalHistory,
    });
    return _sessionFromBody(body);
  }

  Future<AppUser> fetchMe(String token) async {
    final body = await _api.get('/auth/me', token: token);
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final userJson = data['user'] as Map<String, dynamic>? ?? {};
    final role = data['role'] as String? ?? userJson['role'] as String? ?? 'patient';
    return AppUser.fromJson({...userJson, 'role': role});
  }

  AuthSession _sessionFromBody(Map<String, dynamic> body) {
    final data = body['data'] as Map<String, dynamic>? ?? body;
    final token = data['token'] as String? ?? '';
    final role = data['role'] as String? ?? 'patient';
    final userJson = data['user'] as Map<String, dynamic>? ?? {};
    if (token.isEmpty || userJson.isEmpty) {
      throw const ApiException('Authentication response was incomplete.');
    }
    final user = AppUser.fromJson({...userJson, 'role': role});
    return AuthSession(token: token, role: role, user: user);
  }
}
