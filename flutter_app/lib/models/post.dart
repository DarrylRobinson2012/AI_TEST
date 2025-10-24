class PostModel {
  final int id;
  final int authorId;
  final String title;
  final String body;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.body,
    required this.createdAt,
  });
}
