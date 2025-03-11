import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:insta_flutter/constants/consts.dart';
import 'package:insta_flutter/services/api_response.dart';

class HTTPService {
  static final HTTPService _instance = HTTPService._internal();
  final Dio _dio;

  factory HTTPService() {
    return _instance;
  }

  HTTPService._internal() : _dio = Dio() {
    setup();
  }

  void setup({String? bearerToken}) {
    final headers = {
      "Content-Type": "application/json",
    };

    if (bearerToken != null) {
      headers["Authorization"] = "Bearer $bearerToken";
    }

    _dio.options = BaseOptions(
      baseUrl: API_BASE_URL,
      headers: headers,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );
  }

  Future<ApiResponse?> post(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: queryParameters != null ? jsonEncode(queryParameters) : null,);
      return _handleResponse(response);
    } catch (e) {
      log('Error: $e');
      return _handleError(e);
    }
  }

  Future<ApiResponse?> postData(String path, {FormData? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } catch (e) {
      log('Error: $e');
      return _handleError(e);
    }
  }

  Future<ApiResponse?> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      log('Error: $e');
      return _handleError(e);
    }
  }

  Future<ApiResponse?> put(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse(response);
    } catch (e) {
      log('Error: $e');
      return _handleError(e);
    }
  }

  Future<ApiResponse?> delete(String path, {Map<String, dynamic>? queryParameters}) async {
  try {
    final response = await _dio.delete(path, queryParameters: queryParameters);
    return _handleResponse(response);
  } catch (e) {
    log('Error: $e');
    return _handleError(e);
  }
}

  ApiResponse _handleResponse(Response response) {
    return ApiResponse.fromJson(response.data);
  }

  ApiResponse _handleError(dynamic error) {
    if (error is DioException) {
      return ApiResponse(
        success: false,
        status: error.response?.statusCode ?? 500,
        content: null,
        timestamp: DateTime.now().toIso8601String(),
      );
    } else {
      return ApiResponse(
        success: false,
        status: 500,
        content: null,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }
}