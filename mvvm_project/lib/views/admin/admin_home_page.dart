import 'package:flutter/material.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/views/home/home_header.dart';
import 'package:mvvm_project/views/home/home_menu_button.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:mvvm_project/views/usermangement/user_management_header.dart';
import 'package:mvvm_project/views/usermangement/user_management_page.dart';
import 'package:provider/provider.dart';

import '../api_images/api_images_page.dart';

class AdminHomePage extends StatelessWidget {
  final String userName;

  const AdminHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      body: SafeArea(
        child: Column(
          children: [
            UserManagementHeader(
              title: 'Hệ thống quản lý cá nhân',
              subtitle: 'Xin chào $userName',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 20),
                  HomeMenuButton(
                    icon: Icons.manage_accounts,
                    title: 'Quản lý người dùng',
                    iconColor: const Color(0xFF1976D2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserManagementPage()),
                      );
                    },
                  ),
                  HomeMenuButton(
                    icon: Icons.event_note,
                    title: 'Quản lý nhắc việc',
                    iconColor: const Color(0xFFF9A825),
                    onTap: () => _showSoon(context),
                  ),
                  HomeMenuButton(
                    icon: Icons.shopping_cart,
                    title: 'Đặt hàng',
                    iconColor: const Color(0xFF1E88E5),
                    onTap: () => _showSoon(context),
                  ),
                  HomeMenuButton(
                    icon: Icons.map,
                    title: 'Xem Bản Đồ',
                    iconColor: const Color(0xFFE53935),
                    onTap: () => _showSoon(context),
                  ),
                  HomeMenuButton(
                    icon: Icons.image,
                    title: 'Xem ảnh qua API',
                    iconColor: const Color(0xFF42A5F5),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApiImagesPage(),
                        ),
                      );
                    },
                  ),
                  HomeMenuButton(
                    icon: Icons.flutter_dash,
                    title: 'Tổng quan Flutter',
                    iconColor: const Color(0xFF1E88E5),
                    onTap: () => _showSoon(context),
                  ),
                  HomeMenuButton(
                    icon: Icons.power_settings_new,
                    title: 'Đăng xuất',
                    iconColor: const Color(0xFFE53935),
                    onTap: () async {
                      await context.read<LoginViewModel>().logout();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng sẽ được cập nhật trong phiên bản tiếp theo.')),
    );
  }
}
