import 'package:flutter/material.dart';

import 'post_view_model.dart';
import 'story_view_model.dart';

class CombinedViewModel extends ChangeNotifier {
  final PostViewModel postViewModel = PostViewModel();
  final StoryViewModel storyViewModel = StoryViewModel();

  CombinedViewModel() {
    postViewModel.fetchPosts();
    storyViewModel.fetchStory();
  }

  // Expose methods and properties as needed
}