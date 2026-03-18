import 'package:flutter/material.dart';

/// Tết Wallet Design Tokens v1.1
abstract final class TetColors {
  // Brand Colors
  static const deepCrimson = Color(0xFF8B0000); // Deep rich crimson
  static const festiveRed = Color(0xFFD32F2F);
  static const primary50 = Color(0xFFFFF1F2);
  static const primary500 = Color(0xFFD32F2F);
  static const primary600 = Color(0xFFB71C1C);
  static const primary700 = Color(0xFF7F0000);
  
  static const accentGold = Color(0xFFFFD700); // Pure Gold
  static const goldFoil = Color(0xFFD4AF37); // Gold Foil
  
  static const success = Color(0xFF00C853);
  static const danger = Color(0xFFFF1744);

  // Background & UI
  static const bgMain = Color(0xFFFDFDFD);
  static const bgCard = Color(0xFFFFFFFF);
  static const border = Color(0xFFEEEEEE);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF757575);
  static const textMuted = Color(0xFFBDBDBD);

  static const darkBgMain = Color(0xFF121212);
  static const darkBgCard = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFFFFFFF);
}

abstract final class TetGradients {
  static const wallet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B0000), Color(0xFFD32F2F)],
  );

  static const tet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB22222), Color(0xFFFF4B2B)],
  );

  static const premiumGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFFFD700)],
  );

  static const softBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F8)],
  );
  
  static const glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white70, Colors.white10],
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
