import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    String? result = await _authService.login(username, password);
    _isLoading = false;

    if (result != null) {
      _errorMessage = result;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }
}