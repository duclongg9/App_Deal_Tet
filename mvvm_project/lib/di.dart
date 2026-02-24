import 'package:mvvm_project/data/implementations/repositories/mock_auth_repository.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';

LoginViewModel buildLoginVM() {
  return LoginViewModel(MockAuthRepository());
}
