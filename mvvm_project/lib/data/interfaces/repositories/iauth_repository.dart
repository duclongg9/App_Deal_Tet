import 'package:mvvm_project/data/dtos/login/user_dto.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';

abstract class IAuthRepository {
  Future<AuthSession> login(String userName, String password);
  Future<AuthSession?> getCurrentSession();
  Future<void> logout();
  Future<UserDto> signInWithGoogle();
}
