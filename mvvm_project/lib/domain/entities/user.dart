class User {
  final String id;
  final String userName;
  final String role;

  const User({
    required this.id,
    required this.userName,
    required this.role,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
}
