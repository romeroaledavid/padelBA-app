import 'package:flutter/material.dart';

// ===================== COLORS =====================
class AppColors {
  static const navy      = Color(0xFF050D1A);
  static const navy2     = Color(0xFF0A1628);
  static const navy3     = Color(0xFF0F1F38);
  static const blue      = Color(0xFF1565E8);
  static const blueBright= Color(0xFF2D7FFF);
  static const yellow    = Color(0xFFF5C518);
  static const green     = Color(0xFF22C55E);
  static const red       = Color(0xFFEF4444);
  static const white30   = Color(0x4DFFFFFF);
  static const white10   = Color(0x1AFFFFFF);
  static const white05   = Color(0x0DFFFFFF);

  static Color categoryColor(int cat) {
    switch (cat) {
      case 1: return const Color(0xFFFFD700);
      case 2: return const Color(0xFFFFF176);
      case 3: return const Color(0xFF2D7FFF);
      case 4: return const Color(0xFF22C55E);
      case 5: return const Color(0xFFFF7A00);
      case 6: return const Color(0xFFAB5CF7);
      case 7: return const Color(0xFFEF4444);
      case 8: return const Color(0xFF9CA3AF);
      default: return const Color(0xFF9CA3AF);
    }
  }
}

