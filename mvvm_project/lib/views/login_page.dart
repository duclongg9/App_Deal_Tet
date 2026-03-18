import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/views/admin/admin_home_page.dart';
import 'package:mvvm_project/views/main/main_layout_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: TetColors.bgMain,
      body: Stack(
        children: [
          // Premium Floral Accents
          Positioned(
            top: -60,
            right: -40,
            child: _buildFloralAccent(size: 200, color: TetColors.festiveRed.withOpacity(0.08)),
          ),
          Positioned(
            top: 20,
            left: -30,
            child: _buildFloralAccent(size: 120, color: TetColors.accentGold.withOpacity(0.12)),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  
                  // App Branding
                  Container(
                    padding: const EdgeInsets.all(TetSpacing.s4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: TetColors.festiveRed.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text('🧧', style: TextStyle(fontSize: 60)),
                  ),
                  const SizedBox(height: TetSpacing.s5),
                  const Text(
                    'Chào Xuân 2026',
                    style: TextStyle(
                      color: TetColors.festiveRed,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: TetSpacing.s2),
                  const Text(
                    'Đăng nhập để bắt đầu săn deal và\nquản lý ngân sách Tết của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TetColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Legacy Login Form
                  _buildTextField(
                    controller: _userController,
                    hint: 'Tên đăng nhập',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: TetSpacing.s4),
                  _buildTextField(
                    controller: _passController,
                    hint: 'Mật khẩu',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscureText,
                    onToggleVisibility: () => setState(() => _obscureText = !_obscureText),
                  ),
                  const SizedBox(height: TetSpacing.s6),
                  
                  // Login Button
                  _buildPrimaryButton(
                    onTap: vm.loading ? null : () => _handleLegacyLogin(context),
                    label: 'Đăng Nhập',
                    isLoading: vm.loading,
                  ),
                  
                  const SizedBox(height: TetSpacing.s6),
                  const Text('— HOẶC —', style: TextStyle(color: TetColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: TetSpacing.s6),

                  // Google Sign-In Button
                  _GoogleSignInButton(
                    onPressed: vm.loading ? null : () => _handleGoogleLogin(context),
                    isLoading: vm.loading,
                  ),
                  
                  const SizedBox(height: TetSpacing.s8),
                  
                  // Error Message
                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: TetSpacing.s4),
                      child: Text(
                        vm.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: TetColors.danger, fontWeight: FontWeight.w600),
                      ),
                    ),
                    
                  const Text(
                    'Bằng cách tiếp tục, bạn đồng ý với Điều khoản của chúng tôi',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TetColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Loading Overlay
          if (vm.loading)
             Container(
               color: Colors.white.withOpacity(0.8),
               child: const Center(
                 child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(TetColors.festiveRed),
                 ),
               ),
             ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: TetColors.festiveRed.withOpacity(0.5)),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: TetColors.textMuted),
                onPressed: onToggleVisibility,
              )
            : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(TetRadius.lg), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({required VoidCallback? onTap, required String label, bool isLoading = false}) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: TetGradients.tet,
        borderRadius: BorderRadius.circular(TetRadius.lg),
        boxShadow: [BoxShadow(color: TetColors.festiveRed.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TetRadius.lg),
          child: Center(
            child: isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildFloralAccent({required double size, required Color color}) {
    return Icon(Icons.filter_vintage, size: size, color: color);
  }

  Future<void> _handleLegacyLogin(BuildContext context) async {
    final vm = context.read<LoginViewModel>();
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên đăng nhập và mật khẩu')));
      return;
    }

    final ok = await vm.login(username, password);
    if (!ok || !context.mounted) return;

    _navigateAfterLogin(context, vm, username);
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final vm = context.read<LoginViewModel>();
    final ok = await vm.loginWithGoogle();
    if (!ok || !context.mounted) return;

    _navigateAfterLogin(context, vm, vm.session?.user.userName ?? 'Khách');
  }

  void _navigateAfterLogin(BuildContext context, LoginViewModel vm, String inputUsername) {
    if (vm.session != null) {
      // Special Logic: 'longpham' always goes to Tet App
      // Others follow role logic
      final isLongPham = inputUsername.toLowerCase() == 'longpham' || vm.session!.user.userName.toLowerCase() == 'longpham';
      
      final nextPage = (vm.session!.user.isAdmin && !isLongPham)
          ? AdminHomePage(userName: vm.session!.user.userName)
          : MainLayoutPage(userName: vm.session!.user.userName);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => nextPage));
    }
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GoogleSignInButton({this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(TetRadius.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(TetColors.festiveRed)))
              else ...[
                Image.network(
                  'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                  height: 24, width: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.login, color: Colors.blue),
                ),
                const SizedBox(width: TetSpacing.s4),
                const Text('Google Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TetColors.textPrimary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
