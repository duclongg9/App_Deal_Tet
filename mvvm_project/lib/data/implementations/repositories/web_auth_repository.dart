import 'package:mvvm_project/data/dtos/login/user_dto.dart';
import 'package:mvvm_project/data/interfaces/repositories/iauth_repository.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';
import 'package:mvvm_project/domain/entities/user.dart';

class WebAuthRepository implements IAuthRepository {
  static const Map<String, _SeedUser> _users = {
    'admin': _SeedUser(password: 'FU@2026', role: 'admin'),
    'longpham': _SeedUser(password: '12345', role: 'user'),
  };

  AuthSession? _session;

  @override
  Future<AuthSession> login(String userName, String password) async {
    final normalizedUser = userName.trim();
    final user = _users[normalizedUser];

    if (user == null || user.password != password) {
      throw Exception('Invalid username or password');
    }

    final authSession = AuthSession(
      token: 'web-session-$normalizedUser',
      user: User(id: normalizedUser, userName: normalizedUser, role: user.role),
    );

    _session = authSession;
    return authSession;
  }

  @override
  Future<AuthSession?> getCurrentSession() async => _session;

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  Future<UserDto> signInWithGoogle() async {
    // For web/mock purposes, we can return a default user or throw UnimplementedError
    // if you don't want to support it here.
    return const UserDto(
      id: 'web-google-id',
      userName: 'Web Google User',
      role: 'user',
    );
  }
}

class _SeedUser {
  final String password;
  final String role;

  const _SeedUser({required this.password, required this.role});
}