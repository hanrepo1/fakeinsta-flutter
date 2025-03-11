class CommentDTO {
  int userId;
  int postId;
  String comment;

  CommentDTO({
    required this.userId,
    required this.postId,
    required this.comment,
  });
}