// vaccum_unit_constants.dart
// This file contains colors, styles, and design constants

import 'package:flutter/material.dart';

class VaccumUnitConstants {
  // Colors
  static const Color primaryColor = Color(0xFF2E5BFF); // Blue
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color backgroundColor = Color(0xFFF0F4F8); // Light grey-blue
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1A1A2E); // Dark text

  // Text Styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: textColor,
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: textColor,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Sizes and Padding
  static const double cardBorderRadius = 25;
  static const double inputBorderRadius = 15;

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    vertical: 30,
    horizontal: 24,
  );
}
