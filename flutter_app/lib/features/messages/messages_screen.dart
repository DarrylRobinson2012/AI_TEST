import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/messages_provider.dart';
import '../../providers/auth_provider.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _controller = TextEditingController();
  final _receiverIdController = TextEditingController(text: '2');

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider).messages;
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _receiverIdController,
                    decoration: const InputDecoration(labelText: 'To (user id)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final body = _controller.text.trim();
                    if (body.isEmpty) return;
                    final receiverId = int.tryParse(_receiverIdController.text.trim()) ?? 2;
                    ref.read(messagesProvider).send(
                          senderId: auth.userId ?? 1,
                          receiverId: receiverId,
                          body: body,
                        );
                    _controller.clear();
                  },
                  child: const Text('Send'),
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (_, i) {
                  final m = messages[i];
                  final isMine = m.senderId == (auth.userId ?? 1);
                  return Align(
                    alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMine ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(m.body),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: messages.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
