import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mvvm_project/design_system/tet_theme.dart';
import 'package:mvvm_project/di.dart';
import 'package:mvvm_project/firebase_options.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:mvvm_project/viewmodels/saved/saved_deals_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:mvvm_project/views/onboarding/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Already initialized - safe to ignore
  }
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
        // TetBudgetViewModel is rebuilt when user's login session changes.
        ChangeNotifierProxyProvider<LoginViewModel, TetBudgetViewModel>(
          create: (_) => buildTetBudgetVM('anonymous'),
          update: (_, loginVM, previous) {
            final userId = loginVM.session?.user.id ?? 'anonymous';
            if (previous?.firestoreUserId == userId) return previous!;
            return buildTetBudgetVM(userId);
          },
        ),
        // SavedDealsViewModel loads from Firestore when user session changes.
        ChangeNotifierProxyProvider<LoginViewModel, SavedDealsViewModel>(
          create: (_) => SavedDealsViewModel(),
          update: (_, loginVM, previous) {
            final vm = previous ?? SavedDealsViewModel();
            final userId = loginVM.session?.user.id;
            if (userId != null) {
              vm.loadForUser(userId);
            }
            return vm;
          },
        ),
        ChangeNotifierProvider<NotificationsViewModel>(
            create: (_) => NotificationsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TetTheme.light(),
        darkTheme: TetTheme.dark(),
        themeMode: ThemeMode.system,
        home: const SplashPage(),
      ),
    );
  }
}
