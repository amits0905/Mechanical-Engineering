// File: pressure_unit_constants.dart
import 'package:flutter/material.dart';

class PressureUnitConstants {
  // Color Constants
  static const Color primaryColor = Color(0xFF2E5BFF);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF0F4F8);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1A1A2E);

  // Unit Constants
  static const List<String> pressureUnits = [
    'Pascal',
    'Bar',
    'Torr',
    'atm',
    'psi',
    'mmHg',
    'kPa',
  ];

  // Conversion factors to Pascal (base unit)
  static const Map<String, double> conversionToPascal = {
    'Pascal': 1.0,
    'Bar': 100000.0,
    'Torr': 133.322,
    'atm': 101325.0,
    'psi': 6894.76,
    'mmHg': 133.322,
    'kPa': 1000.0,
  };

  // Text Constants
  static const String appBarTitle = 'Pressure Unit Converter';
  static const String pageTitle = 'Pressure Conversion';
  static const String valueLabel = 'Value to Convert';
  static const String fromUnitLabel = 'From Unit';
  static const String toUnitLabel = 'To Unit';
  static const String convertButtonText = 'CALCULATE';
  static const String resultTitle = 'Conversion Result';
  static const String invalidInputMessage = 'Please enter a valid number';

  // Layout Constants
  static const double defaultPadding = 20.0;
  static const double cardPaddingVertical = 30.0;
  static const double cardPaddingHorizontal = 24.0;
  static const double elementSpacing = 8.0;
  static const double sectionSpacing = 24.0;
  static const double largeSectionSpacing = 28.0;

  // Border Radius
  static const double smallBorderRadius = 12.0;
  static const double mediumBorderRadius = 15.0;
  static const double largeBorderRadius = 20.0;
  static const double extraLargeBorderRadius = 25.0;

  // Text Sizes
  static const double smallTextSize = 15.0;
  static const double mediumTextSize = 16.0;
  static const double largeTextSize = 18.0;
  static const double extraLargeTextSize = 22.0;
  static const double inputTextSize = 28.0;
  static const double resultValueTextSize = 32.0;
  static const double resultUnitTextSize = 24.0;

  // Icon Sizes
  static const double headerIconSize = 32.0;
  static const double swapIconSize = 24.0;

  // Shadows
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: primaryColor.withValues(
        alpha: 0.3,
      ), // FIXED: withValues instead of withOpacity
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get accentShadow => [
    BoxShadow(
      color: accentColor.withValues(
        alpha: 0.3,
      ), // FIXED: withValues instead of withOpacity
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Input Decoration
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: backgroundColor.withValues(
      alpha: 0.5,
    ), // FIXED: withValues instead of withOpacity
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(mediumBorderRadius),
      borderSide: BorderSide.none,
    ),
    hintText: '0.0',
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: inputTextSize),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  );

  // Dropdown Decoration
  static InputDecoration get dropdownDecoration => InputDecoration(
    filled: true,
    fillColor: backgroundColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(smallBorderRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(smallBorderRadius),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(smallBorderRadius),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
  );
}
