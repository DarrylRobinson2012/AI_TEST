import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final profileProvider = ChangeNotifierProvider<ProfileController>((ref) {
  return ProfileController();
});

class ProfileController extends ChangeNotifier {
  UserModel _user = const UserModel(id: 1, email: 'user@example.com', name: 'User');
  UserModel get user => _user;

  void update({String? name, String? phone, String? bio}) {
    _user = UserModel(
      id: _user.id,
      email: _user.email,
      name: name ?? _user.name,
      phone: phone ?? _user.phone,
      bio: bio ?? _user.bio,
      isAdmin: _user.isAdmin,
    );
    notifyListeners();
  }
}
