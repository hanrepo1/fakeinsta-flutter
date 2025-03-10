import 'package:flutter/material.dart';
import 'package:insta_flutter/model/story_model.dart';

class StoryViewModel extends ChangeNotifier {
  List<Story> _story = [];

  List<Story> get story => _story;

  void fetchStory() {
    // Simulate fetching data from an API
    _story = [
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'Your Story',
      ),
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'zbabey',
      ),
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'missjackson',
      ),
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'brettlink',
      ),
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'caseyy',
      ),
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'aaaaaa',
      ),
      Story(
        imageUrl: 'https://placehold.co/64x64',
        username: 'bbbbbbb',
      ),
    ];
    notifyListeners();
  }
}
