import 'package:mvvm_project/data/implementations/api/mock_tet_budget_api.dart';
import 'package:mvvm_project/data/implementations/mapper/tet_budget_mapper.dart';
import 'package:mvvm_project/data/implementations/repositories/mock_auth_repository.dart';
import 'package:mvvm_project/data/implementations/repositories/tet_budget_repository.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';

LoginViewModel buildLoginVM() {
  return LoginViewModel(MockAuthRepository());
}

TetBudgetViewModel buildTetBudgetVM() {
  return TetBudgetViewModel(
    TetBudgetRepository(
      api: MockTetBudgetApi(),
      mapper: TetBudgetMapper(),
    ),
  );
}
