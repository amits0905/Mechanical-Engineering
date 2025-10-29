import 'package:flutter/material.dart';

/// Enhanced Centralized Theme Management for the Mechanical Engineering App
class AppTheme {
  // ========= 🎨 Enhanced Brand Colors =========
  static const Color primaryColor = Color(0xFF1976D2); // Blue 700
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color secondaryColor = Color(0xFF00ACC1); // Cyan 600
  static const Color secondaryDark = Color(0xFF0097A7);
  static const Color accentColor = Color(0xFFFF7043); // Deep Orange 400
  static const Color accentDark = Color(0xFFF4511E);

  // ========= 🖋 Enhanced Text Colors =========
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF616161);
  static const Color textTertiaryColor = Color(0xFF9E9E9E);
  static const Color textOnPrimaryColor = Colors.white;
  static const Color textOnSecondaryColor = Colors.white;

  // ========= 🧱 Enhanced Surface & Background =========
  static const Color scaffoldBackgroundColor = Color(0xFFF8F9FB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F7);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color outlineColor = Color(0xFFE0E0E0);

  // ========= ⚠️ Semantic Colors =========
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // ========= 🌈 Enhanced Gradients =========
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF7043), Color(0xFFF4511E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFF8F9FB), Color(0xFFE8EAF6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ========= 🎯 Modern Shadows =========
  static final List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: const Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: const Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> strongShadow = [
    BoxShadow(
      color: const Color.fromRGBO(0, 0, 0, 0.16),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // ========= 🧩 Enhanced Typography =========
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.3,
      letterSpacing: -0.25,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, color: textSecondaryColor, height: 1.5),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
    ),
  );

  // ========= 🎨 Enhanced Button Styles =========
  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
              animationDuration: const Duration(milliseconds: 200),
            ).copyWith(
              elevation: WidgetStateProperty.resolveWith<double>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.pressed)) return 0;
                if (states.contains(WidgetState.hovered)) return 4;
                return 2;
              }),
            ),
      );

  static final OutlinedButtonThemeData outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: primaryColor),
          elevation: 0,
        ),
      );

  static final FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: surfaceVariant,
      foregroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: textTheme.labelLarge?.copyWith(color: primaryColor),
    ),
  );

  // ========= 🌞 Enhanced Light Theme =========
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    primaryColor: primaryColor,

    // Enhanced Color Scheme
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: textOnPrimaryColor,
      secondary: secondaryColor,
      onSecondary: textOnSecondaryColor,
      surface: surfaceColor,
      onSurface: textPrimaryColor,
      surfaceContainerHighest: surfaceVariant,
      error: errorColor,
      outline: outlineColor,
    ),

    // Enhanced App Bar - UPDATED COLOR
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor, // Now uses the blue primary color
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      toolbarHeight: 64,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),

    // Enhanced Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: dividerColor),
        gapPadding: 4,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: textTheme.bodyMedium?.copyWith(color: textSecondaryColor),
      hintStyle: textTheme.bodyMedium?.copyWith(color: textTertiaryColor),
    ),

    // Button Themes
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    filledButtonTheme: filledButtonTheme,

    // Enhanced Card Theme - FIXED: Using CardThemeData
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: dividerColor, width: 1),
      ),
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
    ),

    // Enhanced Dialog Theme - FIXED: Using DialogThemeData
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColor,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
        height: 1.5,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textTertiaryColor,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Tab Bar Theme - FIXED: Using TabBarThemeData
    tabBarTheme: TabBarThemeData(
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: primaryColor,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      unselectedLabelColor: textSecondaryColor,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        color: textSecondaryColor,
        height: 1.5,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariant,
      selectedColor: Color.alphaBlend(
        primaryColor.withAlpha(0x1A),
        surfaceVariant,
      ),
      secondarySelectedColor: Color.alphaBlend(
        secondaryColor.withAlpha(0x1A),
        surfaceVariant,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(color: textPrimaryColor),
      secondaryLabelStyle: textTheme.bodyMedium?.copyWith(color: primaryColor),
      brightness: Brightness.light,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    textTheme: textTheme,

    // Visual Density
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Page Transitions
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // ========= 🌙 Dark Theme (Bonus) =========
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryLight,
    colorScheme: const ColorScheme.dark(
      primary: primaryLight,
      secondary: secondaryColor,
      surface: Color(0xFF1E1E1E),
      surfaceContainerHighest: Color(0xFF2D2D2D),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),

    // FIXED: Using CardThemeData
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),

    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}
