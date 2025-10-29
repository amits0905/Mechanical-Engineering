// lib/components/altimeter_tools/altimeter_styles.dart

import 'package:flutter/material.dart';

// --- Color Constants ---
class AppColors {
  static const Color primary = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF0F172A);
  static const Color label = Color(0xFF64748B);
  static const Color accent = Color(0xFF8B5CF6);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Dropdown colors
  static const Color dropdownBackground = Colors.white;
  static const Color dropdownBorder = Color(0xFFCBD5E1);
  static const Color dropdownText = Color(0xFF475569);

  // Alpha variations
  static Color get primary10 => primary.withAlpha(26);
  static Color get primary30 => primary.withAlpha(77);
  static Color get primary50 => primary.withAlpha(128);
}

// --- Text Styles ---
class TextStyles {
  static const TextStyle header = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.5,
  );

  static const TextStyle subheader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: -0.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.label,
    letterSpacing: 0.1,
  );

  static const TextStyle value = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,
    letterSpacing: 0.8,
  );
}

// --- Shadows ---
class AppShadows {
  static final BoxShadow primary = BoxShadow(
    color: AppColors.primary30,
    blurRadius: 15,
    offset: const Offset(0, 8),
  );

  static final BoxShadow card = BoxShadow(
    color: const Color(0xFF0F172A).withAlpha(8),
    blurRadius: 10,
    offset: const Offset(0, 4),
    spreadRadius: -2,
  );
}

// --- Border Radius ---
class BorderRadii {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 24.0;
  static const double xxLarge = 25.0;
}

// --- Spacing ---
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
