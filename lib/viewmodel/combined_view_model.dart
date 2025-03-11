import 'package:flutter/material.dart';
import 'package:insta_flutter/viewmodel/auth_view_model.dart';
import 'package:insta_flutter/viewmodel/user_view_model.dart';

import 'post_view_model.dart';
import 'story_view_model.dart';

class CombinedViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel = AuthViewModel();
  final UserViewModel userViewModel = UserViewModel();
  final PostViewModel postViewModel = PostViewModel();
  final StoryViewModel storyViewModel = StoryViewModel();
  

  CombinedViewModel() {
    postViewModel.fetchPosts();
    storyViewModel.fetchStory();
    notifyListeners();
  }

  // Expose methods and properties as needed
}