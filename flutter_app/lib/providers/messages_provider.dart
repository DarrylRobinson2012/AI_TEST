import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';

final messagesProvider = ChangeNotifierProvider<MessagesController>((ref) {
  return MessagesController();
});

class MessagesController extends ChangeNotifier {
  final List<MessageModel> _messages = [];
  List<MessageModel> get messages => List.unmodifiable(_messages);

  void send({required int senderId, required int receiverId, required String body}) {
    final id = (_messages.isEmpty ? 1 : _messages.last.id + 1);
    _messages.insert(0, MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      body: body,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }
}
