import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:insta_flutter/interactions/like_button.dart';
import 'package:provider/provider.dart';
import 'package:insta_flutter/viewmodel/post_view_model.dart';

import '../component/post_card.dart';
import '../constants/shared_pref.dart';
import '../model/user_model.dart';
import '../viewmodel/story_view_model.dart';
import '../viewmodel/user_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCommentVisible = false;
  bool isLoading = false;
  int? selectedPostIndex;

  User? user;

  @override
  void initState() {
    super.initState();
    _loadUserPref();
    _fetchData();
  }

  Future<void> _loadUserPref() async {
    String? existUser  = await SharedPref.getUserPref();
    if (existUser  != null && existUser .isNotEmpty) {
      setState(() {
        user = User.fromJson(jsonDecode(existUser ));
      });
    }
  }

  Future<void> _fetchData() async {
    final storyViewModel = Provider.of<StoryViewModel>(context, listen: false);
    await storyViewModel.fetchStory();
    log("story: "+storyViewModel.story.length.toString());

    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    await postViewModel.fetchPosts();
    log("post: "+postViewModel.posts.length.toString());

    setState(() {
      isLoading = false;
    });
  }

  void toggleCommentVisibility(int index) {
    setState(() {
      if (selectedPostIndex == index) {
        isCommentVisible = !isCommentVisible;
      } else {
        isCommentVisible = true;
        selectedPostIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storyViewModel = Provider.of<StoryViewModel>(context);
    final postViewModel = Provider.of<PostViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fake Instagram UI'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        if (storyViewModel.story.isEmpty)
                          Center(child: Text('No stories available.'))
                        else
                          Container(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: storyViewModel.story.length,
                              itemBuilder: (context, index) {
                                final story = storyViewModel.story[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.red, width: 2),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(story.imageUrl),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        story.username,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        const Divider(),
                      ],
                    ),
            ),
            if (postViewModel.posts.isEmpty)
              SliverToBoxAdapter(
                child: Center(child: Text('No posts available.')),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = postViewModel.posts[index];
                    return PostCard(
                      post: post,
                      index: index,
                      toggleCommentVisibility: toggleCommentVisibility,
                    );
                  },
                  childCount: postViewModel.posts.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}