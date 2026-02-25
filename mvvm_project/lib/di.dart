import 'package:flutter/foundation.dart';
import 'package:mvvm_project/data/implementations/api/auth_api.dart';
import 'package:mvvm_project/data/implementations/api/mock_tet_budget_api.dart';
import 'package:mvvm_project/data/implementations/local/app_database.dart';
import 'package:mvvm_project/data/implementations/mapper/auth_mapper.dart';
import 'package:mvvm_project/data/implementations/mapper/tet_budget_mapper.dart';
import 'package:mvvm_project/data/implementations/repositories/auth_repository.dart';
import 'package:mvvm_project/data/implementations/repositories/tet_budget_repository.dart';
import 'package:mvvm_project/data/implementations/repositories/web_auth_repository.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';

LoginViewModel buildLoginVM() {
  if (kIsWeb) {
    return LoginViewModel(WebAuthRepository());
  }


  return LoginViewModel(
    AuthRepository(
      api: AuthApi(AppDatabase.instance),
      mapper: AuthSessionMapper(),
    ),
  );
}

TetBudgetViewModel buildTetBudgetVM() {
  return TetBudgetViewModel(
    TetBudgetRepository(
      api: MockTetBudgetApi(),
      mapper: TetBudgetMapper(),
    ),
  );
}
