import 'user_model.dart';

class Post {
  int id;
  int userId;
  String imageUrl;
  String caption;
  int likeCount;
  int commentCount;
  DateTime createdAt;

  Post(
    {
      required this.id, 
      required this.userId, 
      required this.imageUrl, 
      required this.caption,
      required this.likeCount,
      required this.commentCount,
      required this.createdAt,
    }
  );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userId: json["userId"],
        imageUrl: json["imageUrl"],
        caption: json["caption"],
        likeCount: json["likeCount"],
        commentCount: json["commentCount"],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "imageUrl": imageUrl,
        'caption': caption,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'createdAt': createdAt.toIso8601String(),
      };
}