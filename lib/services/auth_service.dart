import 'dart:developer';

import 'package:insta_flutter/constants/shared_pref.dart';
import 'package:insta_flutter/dto/register_DTO.dart';
import 'package:insta_flutter/services/http_service.dart';
import 'package:insta_flutter/services/user_service.dart';

import '../model/user_model.dart';


class AuthService {
  static final AuthService _singleton = AuthService._internal();

  final _httpService = HTTPService();

  User? user;

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  Future<String?> login(String username, String password) async {
    var response;
    try {
      final body = {
        "username": username,
        "password": password,
      };
      response = await _httpService.post("/auth/token", queryParameters: body);
      log("token : ${response?.content}");
      if (response?.status == 200 && response?.content != null) {
        String accessToken = response?.content;

        await SharedPref.storeAccessToken(accessToken);

        HTTPService().setup(bearerToken: accessToken);
        await getProfile();

        return null;
      } else {
        return response?.content ?? "Login failed. Please try again.";
      }
    } catch (e) {
      log(e.toString());
      return response.toString();
    }
  }

  Future<User?> getProfile() async {
    try {
      var response = await _httpService.get("/user/me");
      if (response?.status == 200 && response?.content != null) {
        user = User.fromJson(response!.content);
        await SharedPref.storeUserPref(user!);
        return user;
      }
    } catch (e) {
      log("getprofile: "+e.toString());
    }

    return null;
  }
}
