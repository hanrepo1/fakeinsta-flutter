import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_flutter/model/post_model.dart';

import '../dto/post_DTO.dart';
import '../model/user_model.dart';
import '../services/post_service.dart';

class PostViewModel extends ChangeNotifier {
  final PostService _postService = PostService(); // Create an instance of PostService
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;

    try {
      List<Post>? fetchedPosts = await _postService.getAllPosts();
      if (fetchedPosts != null) {
        _posts = fetchedPosts;
      } else {
        _errorMessage = "Failed to fetch posts.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPost(int userId, String imageUrl, String caption, int likeCount, int commentCount, File image) async {
    _isLoading = true;
    notifyListeners();

    PostDTO postDTO = PostDTO(userId: userId, imageUrl: "", caption: caption, likeCount: likeCount, commentCount: commentCount);

    try {
      String? result = await _postService.createPost(postDTO, image);
      if (result == null) {
        await fetchPosts();
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<String?> updatePost(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? result = await _postService.updatePost(id);
      if (result == null) {
        await fetchPosts();
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return _errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}