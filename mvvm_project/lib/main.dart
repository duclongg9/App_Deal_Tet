import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_project/design_system/tet_theme.dart';
import 'package:mvvm_project/di.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureDatabaseFactory();
  runApp(const MyApp());
}

void _configureDatabaseFactory() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
    return;
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.windows:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      break;
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      // Keep the default sqflite implementation on mobile platforms.
      break;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(create: (_) => buildLoginVM()),
        ChangeNotifierProvider<TetBudgetViewModel>(create: (_) => buildTetBudgetVM()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TetTheme.light(),
        darkTheme: TetTheme.dark(),
        themeMode: ThemeMode.system,
        home: const LoginPage(),
      ),
    );
  }
}
