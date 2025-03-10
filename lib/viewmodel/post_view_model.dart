import 'package:flutter/material.dart';
import 'package:insta_flutter/model/post_model.dart';

class PostViewModel extends ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  void fetchPosts() {
    // Simulate fetching data from an API
    _posts = [
      Post(id: 1, profilePicture: 'http://gambar', username: 'user1', imageUrl: 'https://www.google.com', caption: 'First Post!', likeCount: 0, commentCount: 0),
      Post(id: 2, profilePicture: 'http://gambar', username: 'user2', imageUrl: 'https://www.google.com', caption: 'Hello World!', likeCount: 0, commentCount: 0),
      // Add more posts as needed
    ];
    notifyListeners();
  }
}