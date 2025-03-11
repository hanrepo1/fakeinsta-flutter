import '../model/post_model.dart';
import '../model/user_model.dart';

class CommentDTO {
  User userId;
  Post postId;
  String comment;

  CommentDTO({
    required this.userId,
    required this.postId,
    required this.comment,
  });
}