class Post {
  final int id;
  final String username;
  final String profilePicture;
  final String imageUrl;
  final String caption;
  int likeCount;
  int commentCount;

  Post(
    {
      required this.id, 
      required this.username, 
      required this.profilePicture, 
      required this.imageUrl, 
      required this.caption,
      required this.likeCount,
      required this.commentCount,
    }
  );
}