import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Xin chào bạn đến với hệ thống quản lý cá nhân',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
