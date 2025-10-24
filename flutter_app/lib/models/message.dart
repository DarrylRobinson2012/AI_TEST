class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String body;
  final bool read;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.body,
    this.read = false,
    required this.createdAt,
  });
}
