import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/shared_pref.dart';
import '../dto/register_DTO.dart';
import '../model/user_model.dart';
import 'http_service.dart';

class UserService {
  static final UserService _singleton = UserService._internal();

  final _httpService = HTTPService();

  User? user;
  Map<int, User?> _userCache = {};

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  Future<String?> register(RegisterDTO registerDTO) async {
    try {
      final body = {
        "username": registerDTO.username,
        "email": registerDTO.email,
        "password": registerDTO.password,
      };
      var response = await _httpService.post("/user/createUser", queryParameters: body);
      if (response?.status == 201 && response?.content != null) {
        return null;
      } else {
        return response?.content ??
            "${response?.status} - Please try again later.";
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<User?> getProfile() async {
    try {
      var response = await _httpService.get("/user/me");
      if (response?.status == 200 && response?.content != null) {
        log(response?.content);
        user = User.fromJson(response!.content);
        await SharedPref.storeUserPref(user!);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<User>?> getAllUser() async {
    try {
      var response = await _httpService.get("/user/getAllUser");
      if (response?.status == 200 && response?.content != null) {
        List content = response!.content;
        List<User> listUser = content.map((e) => User.fromJson(e)).toList();
        return listUser;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<User?> getUserById(int id) async {
    if (_userCache.containsKey(id)) {
      return _userCache[id];
    }

    try {
      var response = await _httpService.get("/user/getUserById/$id");
      if (response?.status == 200 && response?.content != null) {
        User user = User.fromJson(response!.content);
        _userCache[id] = user;
        log(user.username);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<String?> deleteUser(int id) async {
    try {
      var response = await _httpService.put("/user/deleteUser/$id", {});
      if (response?.status == 200 && response?.content != null) {
        return null;
      } else {
        return response?.content ??
            "${response?.status} - Please try again later.";
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}