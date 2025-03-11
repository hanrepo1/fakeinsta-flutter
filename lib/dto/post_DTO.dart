import '../model/user_model.dart';

class PostDTO {
  int userId;
  String imageUrl;
  String caption;
  int likeCount;
  int commentCount;

  PostDTO({
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
  });

}