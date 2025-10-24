import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';

final postsProvider = ChangeNotifierProvider<PostsController>((ref) {
  return PostsController()..loadInitial();
});

class PostsController extends ChangeNotifier {
  final List<PostModel> _posts = [];
  List<PostModel> get posts => List.unmodifiable(_posts);

  void loadInitial() {
    if (_posts.isNotEmpty) return;
    final now = DateTime.now();
    _posts.addAll([
      PostModel(id: 1, authorId: 0, title: 'Welcome to Water Training', body: 'Book swimming lessons, aqua therapy, and performance training.', createdAt: now.subtract(const Duration(hours: 2))),
      PostModel(id: 2, authorId: 0, title: 'Water Safety Basics', body: 'Always swim with a buddy and know your limits.', createdAt: now.subtract(const Duration(days: 1))),
    ]);
    notifyListeners();
  }

  void addPost(String title, String body) {
    final id = (_posts.isEmpty ? 1 : _posts.last.id + 1);
    _posts.insert(0, PostModel(id: id, authorId: 0, title: title, body: body, createdAt: DateTime.now()));
    notifyListeners();
  }
}
