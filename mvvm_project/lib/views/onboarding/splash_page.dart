import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';
import 'package:mvvm_project/domain/entities/user.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:mvvm_project/views/main/main_layout_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    _controller.forward();

    // Restore existing Firebase session or go to Login
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      final fbUser = fb.FirebaseAuth.instance.currentUser;
      if (fbUser != null) {
        // Restore session in LoginViewModel so views have a logged-in user
        final loginVM = context.read<LoginViewModel>();
        if (loginVM.session == null) {
          loginVM.restoreSession(AuthSession(
            token: await fbUser.getIdToken() ?? 'restored-token',
            user: User(
              id: fbUser.uid,
              userName: fbUser.displayName ?? fbUser.email ?? 'User',
              role: 'user',
            ),
          ));
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => MainLayoutPage(
                userName: fbUser.displayName ?? fbUser.email ?? 'User',
              ),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: TetGradients.wallet,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative Peach Blossoms (Animated placeholders using Icons for now)
            Positioned(
              top: 60,
              left: -20,
              child: _buildDecorativeFlower(size: 150, opacity: 0.2),
            ),
            Positioned(
              bottom: -40,
              right: -30,
              child: _buildDecorativeFlower(size: 200, opacity: 0.15),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: TetGradients.premiumGold,
                        boxShadow: [
                          BoxShadow(
                            color: TetColors.accentGold.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.celebration, // Represents the Lantern/Festival
                          size: 70,
                          color: TetColors.deepCrimson,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Tết Deal 2026',
                        style: TextStyle(
                          color: TetColors.accentGold,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          fontFamily: 'Serif', 
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'SĂN DEAL XUÂN - QUẢN NGÂN SÁCH',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Bottom Loading Indicator
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TetColors.accentGold),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeFlower({required double size, required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Icon(
        Icons.filter_vintage,
        size: size,
        color: TetColors.accentGold,
      ),
    );
  }
}
