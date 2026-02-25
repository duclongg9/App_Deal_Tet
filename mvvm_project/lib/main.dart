import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_project/di.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureDatabaseFactory();
  runApp(const MyApp());
}

void _configureDatabaseFactory() {
  if (kIsWeb) return;

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFC2185B);
    const accent = Color(0xFFF57C00);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(create: (_) => buildLoginVM()),
        ChangeNotifierProvider<TetBudgetViewModel>(create: (_) => buildTetBudgetVM()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary, secondary: accent),
          useMaterial3: true,
          textTheme: GoogleFonts.beVietnamProTextTheme(),
          scaffoldBackgroundColor: const Color(0xFFFFF7F2),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.pink.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.pink.shade100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: primary, width: 1.4),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            fillColor: Colors.white,
            filled: true,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink.shade50),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              foregroundColor: Colors.white,
              backgroundColor: primary,
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
