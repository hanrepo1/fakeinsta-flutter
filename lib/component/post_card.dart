import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_flutter/model/comment_model.dart';
import 'package:insta_flutter/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';

import '../constants/shared_pref.dart';
import '../interactions/like_button.dart';
import '../model/post_model.dart';
import '../model/user_model.dart';
import '../viewmodel/user_view_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final int index;
  final Function(int) toggleCommentVisibility;

  const PostCard({
    super.key,
    required this.post,
    required this.index,
    required this.toggleCommentVisibility,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  User? user;
  User? userLogin;
  bool isLoading = true;
  bool isCaptionExpanded = false;
  bool isCommentVisible = false;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      _fetchUserData();
      _loadUserPref();
    });
  }

  Future<void> _fetchUserData() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await userViewModel.getUserById(widget.post.userId);
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _loadUserPref() async {
    String? existUser = await SharedPref.getUserPref();
    if (existUser != null && existUser .isNotEmpty) {
      setState(() {
        userLogin = User.fromJson(jsonDecode(existUser));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 8.0),
                          Text("Loading...", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    : _buildUserRow(user?.username ?? "Unknown", user?.profilePicture),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
                    child: Image.network(
                      widget.post.imageUrl,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LikeButton(post: widget.post),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      setState(() {
                        postViewModel.fetchComments(widget.post.id);
                        isCommentVisible = !isCommentVisible;
                      });
                      widget.toggleCommentVisibility(widget.index);
                    },
                  ),
                  Text(
                    widget.post.commentCount.toString(),
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
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCaptionExpanded = !isCaptionExpanded;
                    });
                  },
                  child: Text(
                    isCaptionExpanded
                        ? widget.post.caption
                        : widget.post.caption.length > 100
                            ? '${widget.post.caption.substring(0, 100)}...'
                            : widget.post.caption,
                    maxLines: isCaptionExpanded ? null : 1,
                    overflow: isCaptionExpanded ? null : TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isCommentVisible) // Show comment section if visible
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: postViewModel.comments.length,
                      itemBuilder: (context, index) {
                        if (postViewModel.comments.isEmpty) {
                          return const Center(child: Text('No comments available.'));
                        } else {
                          String comment = postViewModel.comments[index].comment;
                          return ListTile(
                            title: Text(comment.length > 50 ? '${comment.substring(0, 50)}...' : comment),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Full Comment'),
                                  content: Text(comment),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            if (commentController.text.isNotEmpty) {
                              bool success = await postViewModel.createComment(userLogin!.id, widget.post.id, commentController.text);
                              if (success) {
                                String? updateResult = await postViewModel.updatePost(widget.post, "Comment");
                                if (updateResult == null) {
                                  commentController.clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(updateResult),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(postViewModel.errorMessage!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Row _buildUserRow(String username, String? profilePicture) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            profilePicture ?? 'assets/images/avatar1.jpg',
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset(
                'assets/images/avatar1.jpg',
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}