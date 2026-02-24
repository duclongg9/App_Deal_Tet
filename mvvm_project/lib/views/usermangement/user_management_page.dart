import 'package:flutter/material.dart';
import 'package:mvvm_project/domain/entities/user_profile.dart';
import 'package:mvvm_project/views/usermangement/user_detail_page.dart';
import 'package:mvvm_project/views/usermangement/user_form_page.dart';
import 'package:mvvm_project/views/usermangement/user_item_card.dart';
import 'package:mvvm_project/views/usermangement/user_management_header.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<UserProfile> _users = [
    UserProfile(
      id: '1',
      fullName: 'Nguyễn Văn A',
      birthDate: DateTime(1990, 1, 1),
      address: '123 Đường A, Phường B, Quận T',
    ),
    UserProfile(
      id: '2',
      fullName: 'Trần Thị B',
      birthDate: DateTime(1992, 3, 10),
      address: '21 Nguyễn Trãi, Hà Nội',
    ),
    UserProfile(
      id: '3',
      fullName: 'Lê Văn C',
      birthDate: DateTime(1995, 8, 8),
      address: '30 Xã Đàn, Hà Nội',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      body: SafeArea(
        child: Column(
          children: [
            UserManagementHeader(
              title: 'Quản lý người dùng',
              subtitle: 'Danh sách • Thêm/Sửa/Xóa',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: _users.length,
                itemBuilder: (_, index) {
                  final user = _users[index];
                  return UserItemCard(
                    user: user,
                    onTap: () => _openDetail(user),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openDetail(UserProfile user) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => UserDetailPage(user: user)),
    );

    if (result == null) return;

    if (result == 'delete') {
      setState(() => _users.removeWhere((item) => item.id == user.id));
      return;
    }

    if (result is UserProfile) {
      final idx = _users.indexWhere((item) => item.id == result.id);
      if (idx >= 0) {
        setState(() => _users[idx] = result);
      }
    }
  }

  Future<void> _addUser() async {
    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (_) => const UserFormPage()),
    );

    if (result != null) {
      setState(() => _users.add(result));
    }
  }
}
