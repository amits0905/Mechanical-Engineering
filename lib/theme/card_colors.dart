// lib/theme/card_colors.dart
import 'package:flutter/material.dart';

class CardColors {
  // Card background gradients
  static const List<Color> darkGreyGradient = [
    Color(0xFF404040),
    Color(0xFF262626),
  ];
  static const List<Color> mediumGreyGradient = [
    Color(0xFF4A4A4A),
    Color(0xFF2D2D2D),
  ];
  static const List<Color> lightGreyGradient = [
    Color(0xFF363636),
    Color(0xFF1F1F1F),
  ];

  // Accent colors for icons and shadows
  static const Color redAccent = Color(0xFFFF6B6B);
  static const Color blueAccent = Color(0xFF00D4FF);
  static const Color purpleAccent = Color(0xFFA78BFA);

  // Shadow colors with opacity
  static Color get redShadow => redAccent.withValues(alpha: 0.3);
  static Color get blueShadow => blueAccent.withValues(alpha: 0.3);
  static Color get purpleShadow => purpleAccent.withValues(alpha: 0.3);

  // Background colors
  static const Color scaffoldBackground = Color(0xFF1A1A1A);
  static const Color dashboardBackground = Color(0xFF121212);
  static const Color appBarBackground = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimary = Colors.white;
  static Color get textSecondary => Colors.white.withValues(alpha: 0.6);
  static const Color textMuted = Color(0xFF999999);

  // Border colors
  static Color get borderLight => Colors.white.withValues(alpha: 0.1);
  static Color get borderMedium => Colors.white.withValues(alpha: 0.15);

  // Utility methods for getting card color schemes
  static CardColorScheme get redScheme => CardColorScheme(
    gradient: darkGreyGradient,
    accentColor: redAccent,
    shadowColor: redShadow,
  );

  static CardColorScheme get blueScheme => CardColorScheme(
    gradient: mediumGreyGradient,
    accentColor: blueAccent,
    shadowColor: blueShadow,
  );

  static CardColorScheme get purpleScheme => CardColorScheme(
    gradient: lightGreyGradient,
    accentColor: purpleAccent,
    shadowColor: purpleShadow,
  );
}

class CardColorScheme {
  final List<Color> gradient;
  final Color accentColor;
  final Color shadowColor;

  const CardColorScheme({
    required this.gradient,
    required this.accentColor,
    required this.shadowColor,
  });
}
