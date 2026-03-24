import 'package:flutter/foundation.dart';
import 'package:mvvm_project/data/interfaces/repositories/iauth_repository.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<bool> loginWithGoogle() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        loading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final fb.OAuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final fb.UserCredential userCredential = await fb.FirebaseAuth.instance.signInWithCredential(credential);
      final fbUser = userCredential.user;

      if (fbUser != null) {
        // Map to our local user entity
        session = AuthSession(
          token: await fbUser.getIdToken() ?? 'google-token',
          user: User(
            id: fbUser.uid,
            userName: fbUser.displayName ?? fbUser.email ?? 'Google User',
            role: 'user', // Default group login as user
          ),
        );
        return true;
      }
      return false;
    } catch (e) {
      error = "Lỗi Google Sign-In: $e";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await repo.logout();
    await GoogleSignIn().signOut();
    session = null;
    error = null;
    notifyListeners();
  }

  // Google login is implemented above
  void clearError() {
    if (error != null) {
      error = null;
      notifyListeners();
    }
  }

  /// Restores an existing session (e.g. from Firebase Auth currentUser on cold start).
  void restoreSession(AuthSession s) {
    session = s;
    notifyListeners();
  }
}
