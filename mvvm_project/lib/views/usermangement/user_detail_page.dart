import 'package:flutter/material.dart';
import 'package:mvvm_project/domain/entities/user_profile.dart';
import 'package:mvvm_project/views/usermangement/user_form_page.dart';
import 'package:mvvm_project/views/usermangement/user_management_header.dart';

class UserDetailPage extends StatelessWidget {
  final UserProfile user;

  const UserDetailPage({super.key, required this.user});

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      body: SafeArea(
        child: Column(
          children: [
            UserManagementHeader(
              title: 'Chi tiết người dùng',
              subtitle: 'Xem thông tin • Sửa • Xóa',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(label: 'Ngày sinh:', value: _formatDate(user.birthDate)),
                    const SizedBox(height: 12),
                    _InfoRow(label: 'Địa chỉ:', value: user.address),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context, 'delete'),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Xóa'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFD32F2F),
                              side: const BorderSide(color: Color(0xFFD32F2F)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final edited = await Navigator.push<UserProfile>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserFormPage(initialValue: user),
                                ),
                              );

                              if (!context.mounted || edited == null) return;
                              Navigator.pop(context, edited);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Sửa'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

