import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_flutter/dto/comment_DTO.dart';
import 'package:insta_flutter/model/comment_model.dart';
import 'package:insta_flutter/model/post_model.dart';

import '../dto/post_DTO.dart';
import '../model/user_model.dart';
import '../services/post_service.dart';

class PostViewModel extends ChangeNotifier {
  final PostService _postService = PostService(); // Create an instance of PostService
  List<Post> _posts = [];
  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Post> get posts => _posts;
  List<Comment> get comments => _comments;
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

  Future<String?> updatePost(Post post, String marker) async {
    _isLoading = true;
    notifyListeners();

    try {
      PostDTO postDTO;
      if (marker == "Comment") {
        postDTO = PostDTO(userId: post.userId, imageUrl: post.imageUrl, caption: post.caption, likeCount: post.likeCount, commentCount: post.commentCount+1);
      } else {
        postDTO = PostDTO(userId: post.userId, imageUrl: post.imageUrl, caption: post.caption, likeCount: post.likeCount+1, commentCount: post.commentCount);
      }
      

      String? result = await _postService.updatePost(post.id, postDTO);
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

  Future<bool> createComment(int userId, int postId, String comment) async {
    _isLoading = true;
    notifyListeners();

    CommentDTO commentDTO = CommentDTO(userId: userId, postId: postId, comment: comment);

    try {
      String? result = await _postService.createComment(commentDTO);
      if (result == null) {
        await fetchComments(postId);
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

  Future<void> fetchComments(int postId) async {
    _isLoading = true;

    try {
      List<Comment>? fetchedComments = await _postService.getAllCommentsById(postId);
      if (fetchedComments != null) {
        _comments = fetchedComments;
      } else {
        _errorMessage = "Failed to fetch comments.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}