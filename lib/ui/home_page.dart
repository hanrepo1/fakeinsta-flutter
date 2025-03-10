import 'package:flutter/material.dart';
import 'package:insta_flutter/interactions/like_button.dart';
import 'package:provider/provider.dart';
import 'package:insta_flutter/viewmodel/post_view_model.dart';

import '../viewmodel/story_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCommentVisible = false;
  int? selectedPostIndex;

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
    final postViewModel = Provider.of<PostViewModel>(context);
    final storyViewModel = Provider.of<StoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fake Instagram UI'),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ListView.builder(
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
                  }
                ),
              ],
            ),
          ),
          const Divider(),
          Stack(
            children: [
              ListView.builder(
                itemCount: postViewModel.posts.length,
                itemBuilder: (context, index) {
                  final post = postViewModel.posts[index];
                  return Card(
                    margin: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  post.profilePicture,
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/avatar1.jpg',
                                      width: 20.0,
                                      height: 20.0,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(post.username, style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 400,
                              child: Image.network(
                                post.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(Icons.refresh, size: 50.0),
                                        onPressed: () {
                                          // Retry logic here
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LikeButton(post: post),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.comment),
                              onPressed: () => toggleCommentVisibility(index),
                            ),
                            Text(
                              post.commentCount.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.send),
                            const Spacer(),
                            const Icon(Icons.bookmark_border),
                            const SizedBox(width: 12),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            post.caption.length > 100 ? post.caption.substring(0, 100) + '...' : post.caption,
                            maxLines: post.caption.length > 100 ? 1 : null, // Limit to 1 line if caption is long
                            overflow: post.caption.length > 100 ? TextOverflow.ellipsis : null, // Add ellipsis if caption is long
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (isCommentVisible)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCommentVisible = false;
                      selectedPostIndex = null;
                    });
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.black54,
                    child: AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8.0),
                              height: 5.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                  const SizedBox(width: 45),
                                  const Text(
                                    'Comments',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        isCommentVisible = false;
                                        selectedPostIndex = null;
                                        });
                                      },
                                    ),
                                  ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('Comment $index'),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}