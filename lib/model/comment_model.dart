class Comment {
  int id;
  int userId;
  String comment;
  int postId;
  DateTime createdAt;

  Comment(
    {
      required this.id, 
      required this.userId, 
      required this.comment,
      required this.postId,
      required this.createdAt,
    }
  );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["userId"],
        comment: json["caption"],
        postId: json["postId"],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        'caption': comment,
        'postId': postId,
        'createdAt': createdAt.toIso8601String(),
      };
}