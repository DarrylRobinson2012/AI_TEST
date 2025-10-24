import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/posts_provider.dart';
import '../../providers/auth_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider).posts;
    final auth = ref.watch(authProvider);
    final isAdmin = false; // Extend authProvider for admin if needed
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Feed'),
        actions: [
          IconButton(onPressed: () => context.go('/calendar'), icon: const Icon(Icons.calendar_month)),
          IconButton(onPressed: () => context.go('/messages'), icon: const Icon(Icons.message)),
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person)),
          if (auth.isLoggedIn)
            IconButton(
              onPressed: () => ref.read(authProvider).logout(),
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const _CreatePostDialog(),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) {
          final p = posts[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(p.body),
                  const SizedBox(height: 8),
                  Text(DateFormat('yMMMd jm').format(p.createdAt), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: posts.length,
      ),
    );
  }
}

class _CreatePostDialog extends ConsumerStatefulWidget {
  const _CreatePostDialog();

  @override
  ConsumerState<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends ConsumerState<_CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Post'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              TextFormField(controller: _body, decoration: const InputDecoration(labelText: 'Body'), maxLines: 5, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref.read(postsProvider).addPost(_title.text.trim(), _body.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Publish'),
        ),
      ],
    );
  }
}
