// File: main.dart

import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/app_shell.dart';
import 'package:mechanicalengineering/theme/app_theme.dart'; // ✅ Import your theme file

void main() {
  runApp(const MechanicalEngineering());
}

class MechanicalEngineering extends StatelessWidget {
  const MechanicalEngineering({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanical Engineering',
      debugShowCheckedModeBanner: false,

      // ✅ Apply the centralized app theme from app_theme.dart
      theme: AppTheme.lightTheme,

      // ✅ Define the root of your app (main app structure)
      home: const AppShell(),
    );
  }
}
