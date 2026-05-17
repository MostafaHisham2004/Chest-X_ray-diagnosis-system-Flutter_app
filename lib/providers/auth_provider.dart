import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  AuthStatus status = AuthStatus.initial;
  AppUser? user;
  String? token;
  String? role;
  String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isAdmin => user?.isAdmin ?? false;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _run(() => _authService.login(email: email, password: password));
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    String gender = 'other',
    String? dob,
  }) async {
    return _run(() => _authService.signup(
          name: name,
          email: email,
          password: password,
          gender: gender,
          dob: dob ?? DateTime.now().toIso8601String().split('T').first,
        ));
  }

  Future<void> refreshProfile() async {
    if (token == null) return;
    try {
      final refreshed = await _authService.fetchMe(token!);
      user = refreshed;
      role = refreshed.role;
      notifyListeners();
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<bool> _run(Future<AuthSession> Function() action) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final session = await action();
      token = session.token;
      role = session.role;
      user = session.user;
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      status = AuthStatus.error;
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      status = AuthStatus.error;
      errorMessage = 'Unable to reach the server. Check your connection.';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    token = null;
    role = null;
    user = null;
    errorMessage = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
