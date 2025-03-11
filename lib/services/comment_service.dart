import 'dart:developer';

import 'package:insta_flutter/dto/comment_DTO.dart';
import 'package:insta_flutter/model/comment_model.dart';

import 'http_service.dart';

class CommentService {
  static final CommentService _singleton = CommentService._internal();

  final _httpService = HTTPService();

  Comment? comment;

  factory CommentService() {
    return _singleton;
  }

  CommentService._internal();

  Future<String?> createPost(CommentDTO commentDTO) async {
    try {
      final body = {
        "userId": commentDTO.userId,
        "postId": commentDTO.postId,
        "comment": commentDTO.comment,
      };
      var response = await _httpService.post("/comments/createComment", queryParameters: body);
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

  Future<List<Comment>?> getAllComments(int id) async {
    try {
      var response = await _httpService.get("/comments/getAllComments/$id");
      if (response?.status == 200 && response?.content != null) {
        List content = response!.content;
        List<Comment> listPosts = content.map((e) => Comment.fromJson(e)).toList();
        return listPosts;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}