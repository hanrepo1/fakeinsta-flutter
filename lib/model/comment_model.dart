class Comment {
  int id;
  int userId;
  String caption;
  int postId;
  DateTime createdAt;

  Comment(
    {
      required this.id, 
      required this.userId, 
      required this.caption,
      required this.postId,
      required this.createdAt,
    }
  );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["userId"],
        caption: json["caption"],
        postId: json["postId"],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        'caption': caption,
        'postId': postId,
        'createdAt': createdAt.toIso8601String(),
      };
}