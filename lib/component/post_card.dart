import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../interactions/like_button.dart';
import '../model/post_model.dart';
import '../model/user_model.dart';
import '../viewmodel/user_view_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final int index;
  final Function(int) toggleCommentVisibility;

  const PostCard({
    Key? key,
    required this.post,
    required this.index,
    required this.toggleCommentVisibility,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    user = await userViewModel.getUserById(widget.post.userId);
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Card(
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
                onPressed: () => widget.toggleCommentVisibility(widget.index),
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
            child: Text(
              widget.post.caption.length > 100 ? '${widget.post.caption.substring(0, 100)}...' : widget.post.caption,
              maxLines: widget.post.caption.length > 100 ? 1 : null,
              overflow: widget.post.caption.length > 100 ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
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