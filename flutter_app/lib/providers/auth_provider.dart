import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController();
});

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _name;
  int? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get name => _name;
  int? get userId => _userId;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoggedIn = true;
    _email = email;
    _name = email.split('@').first;
    _userId = 1;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoggedIn = true;
    _email = email;
    _name = name;
    _userId = 1;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _email = null;
    _name = null;
    _userId = null;
    notifyListeners();
  }
}
