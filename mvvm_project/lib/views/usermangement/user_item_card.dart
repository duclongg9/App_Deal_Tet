import 'package:flutter/material.dart';
import 'package:mvvm_project/domain/entities/user_profile.dart';

class UserItemCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onTap;

  const UserItemCard({
    super.key,
    required this.user,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFEDF5FF),
          child: Text(
            user.initials,
            style: const TextStyle(
              color: Color(0xFF1976D2),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          '${_formatDate(user.birthDate)} • ${user.address}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF42A5F5)),
      ),
    );
  }
}
