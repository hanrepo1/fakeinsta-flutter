class User {
  int id;
  String username;
  String email;
  String? profilePicture;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        profilePicture: profilePicture ?? this.profilePicture,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    profilePicture: json["profilePicture"],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "profilePicture": profilePicture,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
