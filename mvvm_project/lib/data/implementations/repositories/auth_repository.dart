import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvvm_project/data/dtos/login/login_request_dto.dart';
import 'package:mvvm_project/data/dtos/login/login_response_dto.dart';
import 'package:mvvm_project/data/interfaces/api/iauth_api.dart';
import 'package:mvvm_project/data/interfaces/mapper/imapper.dart';
import 'package:mvvm_project/data/interfaces/repositories/iauth_repository.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';

class AuthRepository implements IAuthRepository {
  final IAuthApi api;
  final IMapper<LoginResponseDto, AuthSession> mapper;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepository({required this.api, required this.mapper});

  @override
  Future<AuthSession> login(String userName, String password) async {
    final req = LoginRequestDto(userName: userName, password: password);
    final dto = await api.login(req);
    return mapper.map(dto);
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    final dto = await api.getCurrentSession();
    if (dto == null) return null;
    return mapper.map(dto);
  }

  @override
  Future<void> logout() async {
    await api.logout();
    await _auth.signOut();
  }
}
