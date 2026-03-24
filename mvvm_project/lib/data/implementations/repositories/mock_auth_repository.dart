import 'package:mvvm_project/data/dtos/login/user_dto.dart';
import 'package:mvvm_project/data/interfaces/repositories/iauth_repository.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';
import 'package:mvvm_project/domain/entities/user.dart';

class MockAuthRepository implements IAuthRepository {
  @override
  Future<AuthSession> login(String userName, String password) async {
    final displayName = userName.trim().isEmpty ? 'guest' : userName.trim();
    return AuthSession(
      token: 'ui-only-token',
      user: User(id: '1', userName: displayName, role: 'user'),
    );
  }

  @override
  Future<AuthSession?> getCurrentSession() async => null;

  @override
  Future<void> logout() async {}
}
