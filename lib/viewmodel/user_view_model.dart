import 'package:flutter/material.dart';

import '../dto/register_DTO.dart';
import '../model/user_model.dart';
import '../services/user_service.dart';

class UserViewModel with ChangeNotifier {
  final UserService _userService = UserService();
  String? _errorMessage;
  bool _isLoading = false;
  User? _user;
  List<User>? _users;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  User? get user => _user;
  List<User>? get users => _users;

  Future<bool> register(String username, String email, String password) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    RegisterDTO registerDTO = RegisterDTO(username: username, email: email, password: password);

    String? result = await _userService.register(registerDTO);
    _isLoading = false;

    if (result != null) {
      _errorMessage = result;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    _user = await _userService.getProfile();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    _users = await _userService.getAllUser ();
    _isLoading = false;
    notifyListeners();
  }

  Future<User?> getUserById(int id) async {
    _isLoading = true;
    
    User? newUser = await _userService.getUserById(id);
    
    _isLoading = false;
    notifyListeners();

    return newUser;
  }

  Future<void> deleteUser (int id) async {
    _isLoading = true;
    notifyListeners();

    String? result = await _userService.deleteUser (id);
    if (result != null) {
      _errorMessage = result;
    }

    _isLoading = false;
    notifyListeners();
  }
}