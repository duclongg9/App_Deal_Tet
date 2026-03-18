import 'package:flutter/foundation.dart';
import 'package:mvvm_project/data/interfaces/repositories/iauth_repository.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';
import 'package:mvvm_project/domain/entities/user.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthRepository repo;

  LoginViewModel(this.repo);

  bool loading = false;
  String? error;
  AuthSession? session;

  Future<bool> login(String userName, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      session = await repo.login(userName, password);
      return true;
    } catch (e) {
      session = null;
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await repo.logout();
    session = null;
    error = null;
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final userDto = await repo.signInWithGoogle();
      
      // Map UserDto to domain User and create session
      session = AuthSession(
        token: 'firebase-token-${userDto.id}', // Use a placeholder or actual token if available
        user: User(
          id: userDto.id,
          userName: userDto.userName,
          role: userDto.role,
        ),
      );
      
      return true;
    } catch (e) {
      session = null;
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  void clearError() {
    if (error != null) {
      error = null;
      notifyListeners();
    }
  }
}
