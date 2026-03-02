import 'package:flutter/material.dart';

/// Tết Wallet Design Tokens v1.1
abstract final class TetColors {
  static const primary500 = Color(0xFF6C63FF);
  static const primary600 = Color(0xFF5A52E0);
  static const accentGold = Color(0xFFF9A826);
  static const success = Color(0xFF22C55E);
  static const danger = Color(0xFFEF4444);

  static const bgMain = Color(0xFFFBFBFD);
  static const bgCard = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E7EB);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);

  // Demo bug token: poor text contrast over soft gradient backgrounds.
  static const textPrimaryBug = Color(0xFF1F2937);

  static const darkBgMain = Color(0xFF0F172A);
  static const darkBgCard = Color(0xFF1E293B);
  static const darkTextPrimary = Color(0xFFF1F5F9);
}

abstract final class TetGradients {
  static const wallet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7F5AF0), Color(0xFF2CB67D)],
  );

  static const tet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
  );

  static const premium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF9A826), Color(0xFFFFB703)],
  );

  static const softBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF6F6), Color(0xFFFFF1F2)],
  );
}

abstract final class TetSpacing {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
}

abstract final class TetRadius {
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const full = 999.0;
}

abstract final class TetShadows {
  static const sm = [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 6, offset: Offset(0, 2))];
  static const md = [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 20, offset: Offset(0, 6))];
  static const lg = [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.12), blurRadius: 30, offset: Offset(0, 10))];
}
