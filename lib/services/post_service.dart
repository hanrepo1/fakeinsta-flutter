import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:insta_flutter/dto/post_DTO.dart';
import 'package:insta_flutter/model/post_model.dart';

import 'http_service.dart';

class PostService {
  static final PostService _singleton = PostService._internal();

  final _httpService = HTTPService();

  Post? post;

  factory PostService() {
    return _singleton;
  }

  PostService._internal();

  Future<String?> createPost(PostDTO postDTO, File imageFile) async {
    try {
      String? imageUrl = await uploadPhoto(imageFile);
      if (imageUrl == null) {
        return 'Failed to upload image.';
      }

      final body = {
        "userId": postDTO.userId, 
        "imageUrl": imageUrl, 
        "caption": postDTO.caption,
        "likeCount": postDTO.likeCount,
        "commentCount": postDTO.commentCount,
      };
      log("userId: "+postDTO.userId.toString());
      log("imageUrl: "+imageUrl);
      log("caption: "+postDTO.caption);
      log("likeCount: "+postDTO.likeCount.toString());
      log("commentCount: "+postDTO.commentCount.toString());

      var response = await _httpService.post("/posts/createPost", queryParameters: body);
      log(response.toString());
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

  Future<String?> uploadPhoto(File imageFile) async {
    final Dio dio;
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      });
      
      final response = await _httpService.postData(
        '/posts/uploadPhoto',
        data: formData,
      );
    
      if (response?.status == 200) {
        // Assuming the response contains the URL in the body
        return response?.content; // Adjust this based on your API response structure
      } else {
        log('Failed to upload image: ${response?.status}- '+'${response?.content}' );
        return null;
      }
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }

  Future<List<Post>?> getUserPosts(int id) async {
    try {
      var response = await _httpService.get("/posts/getUserPosts/$id");
      if (response?.status == 200 && response?.content != null) {
        List content = response!.content;
        List<Post> listPosts = content.map((e) => Post.fromJson(e)).toList();
        return listPosts;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<Post>?> getAllPosts() async {
    try {
      var response = await _httpService.get("/posts/getAllPosts");
      if (response?.status == 200 && response?.content != null) {
        List content = response!.content;
        List<Post> listPosts = content.map((e) => Post.fromJson(e)).toList();
        return listPosts;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<String?> updatePost(int id) async {
    try {
      var response = await _httpService.put("/posts/updatePost/$id", {});
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