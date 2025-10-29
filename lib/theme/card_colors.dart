import 'package:flutter/material.dart';

class CardColors {
  // Card background gradients - Engineering Blue Theme
  static const List<Color> darkBlueGradient = [
    Color(0xFF1E3A5F),
    Color(0xFF0F1F38),
  ];
  static const List<Color> mediumBlueGradient = [
    Color(0xFF2D4F7C),
    Color(0xFF1A2F4F),
  ];
  static const List<Color> lightBlueGradient = [
    Color(0xFF3A6395),
    Color(0xFF243B5C),
  ];

  // Accent colors for engineering tools
  static const Color orangeAccent = Color(0xFFFF7B42);
  static const Color tealAccent = Color(0xFF00C9B7);
  static const Color yellowAccent = Color(0xFFFFD166);

  // BACKWARD COMPATIBILITY - Keep old names for your existing dashboard code
  static const Color redAccent = orangeAccent;
  static const Color blueAccent = tealAccent;
  static const Color purpleAccent = yellowAccent;

  // Shadow colors (using .withValues instead of .withOpacity)
  static Color get orangeShadow => orangeAccent.withValues(alpha: 0.3);
  static Color get tealShadow => tealAccent.withValues(alpha: 0.3);
  static Color get yellowShadow => yellowAccent.withValues(alpha: 0.3);

  // BACKWARD COMPATIBILITY - Shadow colors
  static Color get redShadow => orangeShadow;
  static Color get blueShadow => tealShadow;
  static Color get purpleShadow => yellowShadow;

  // Background colors
  static const Color scaffoldBackground = Color(0xFF0A1429);
  static const Color dashboardBackground = Color(0xFF0F1C35);
  static const Color appBarBackground = Color(0xFF152642);

  // Text colors
  static const Color textPrimary = Colors.white;
  static Color get textSecondary => Colors.white.withValues(alpha: 0.8);
  static const Color textMuted = Color(0xFF94A3B8);

  // Border colors
  static Color get borderLight => Colors.white.withValues(alpha: 0.15);
  static Color get borderMedium => Colors.white.withValues(alpha: 0.25);

  // NEW color schemes
  static CardColorScheme get orangeScheme => CardColorScheme(
    gradient: darkBlueGradient,
    accentColor: orangeAccent,
    shadowColor: orangeShadow,
  );

  static CardColorScheme get tealScheme => CardColorScheme(
    gradient: mediumBlueGradient,
    accentColor: tealAccent,
    shadowColor: tealShadow,
  );

  static CardColorScheme get yellowScheme => CardColorScheme(
    gradient: lightBlueGradient,
    accentColor: yellowAccent,
    shadowColor: yellowShadow,
  );

  // BACKWARD COMPATIBILITY - Old scheme names
  static CardColorScheme get redScheme => orangeScheme;
  static CardColorScheme get blueScheme => tealScheme;
  static CardColorScheme get purpleScheme => yellowScheme;
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
