import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: const Center(
        child: Text('Giao diện quản lý người dùng sẽ được cập nhật ở đây.'),
      ),
    );
  }
}
