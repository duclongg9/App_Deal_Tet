import 'package:flutter/material.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/views/admin/admin_home_page.dart';
import 'package:mvvm_project/views/home/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController(text: 'longpham');
  final _passCtrl = TextEditingController(text: '12345');
  bool _obscure = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE0E8), Color(0xFFFFF8E1)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('🧧 App Deal Tết', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(
                        'Đăng nhập để quản lý chi tiêu Tết thông minh',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tài khoản mẫu: admin / FU@2026 hoặc longpham / 12345',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _userCtrl,
                        enabled: !vm.loading,
                        decoration: const InputDecoration(hintText: 'Tên đăng nhập'),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passCtrl,
                        enabled: !vm.loading,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          suffixIcon: IconButton(
                            onPressed: vm.loading ? null : () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          ),
                        ),
                        onSubmitted: (_) => _handleLogin(),
                      ),
                      if (vm.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: vm.loading ? null : _handleLogin,
                          child: vm.loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Vào app ngay', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final vm = context.read<LoginViewModel>();
    final ok = await vm.login(_userCtrl.text.trim(), _passCtrl.text);
    if (!ok || !mounted) return;

    final nextPage = vm.session!.user.isAdmin
        ? AdminHomePage(userName: vm.session!.user.userName)
        : HomePage(userName: vm.session!.user.userName);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }
}
