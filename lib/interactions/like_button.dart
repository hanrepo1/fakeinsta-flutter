import 'package:flutter/material.dart';

import '../model/post_model.dart';

class LikeButton extends StatefulWidget {
  final Post post;

  const LikeButton({super.key, required this.post});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.black,
          ),
          onPressed: () {
            setState(() {
              isLiked = !isLiked;
              if (isLiked) {
                widget.post.likeCount++;
              } else {
                widget.post.likeCount--;
              }
            });
          },
        ),
        Text(
          widget.post.likeCount.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}