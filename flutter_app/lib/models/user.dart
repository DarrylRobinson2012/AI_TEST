class UserModel {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String bio;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone = '',
    this.bio = '',
    this.isAdmin = false,
  });
}
