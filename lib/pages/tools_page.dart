import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/altimeter_tools/altimeter_page.dart';
import 'package:mechanicalengineering/components/pressure_unit/pressure_unit_page.dart';
import 'package:mechanicalengineering/components/vacuum_tools/vaccumunitpage.dart';
import 'package:mechanicalengineering/theme/card_colors.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CardColors.dashboardBackground,
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildToolsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Vertical line
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: CardColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            // ENGINEERING TOOLS text
            Text(
              'ENGINEERING TOOLS',
              style: TextStyle(
                color: CardColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Professional\nEngineering Toolkit',
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Advanced calculators and sensors for engineering\nprofessionals',
          style: TextStyle(
            color: CardColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildToolsList(BuildContext context) {
    final tools = [
      {
        'title': 'Altimeter',
        'subtitle': 'Elevation & Atmospheric Pressure',
        'colorScheme': CardColors.blueScheme,
        'page': const AltimeterPage(),
        'icon': Icons.terrain,
      },
      {
        'title': 'Vacuum Converter',
        'subtitle': 'Vacuum Pressure Units',
        'colorScheme': CardColors.redScheme,
        'page': const VaccumUnitPage(),
        'icon': Icons.compress,
      },
      {
        'title': 'Pressure Converter',
        'subtitle': 'Engineering Pressure Units',
        'colorScheme': CardColors.purpleScheme,
        'page': const PressureUnitPage(),
        'icon': Icons.speed,
      },
    ];

    return Column(
      children: [
        ...tools.map(
          (tool) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildListToolCard(
              context,
              title: tool['title'] as String,
              subtitle: tool['subtitle'] as String,
              colorScheme: tool['colorScheme'] as CardColorScheme,
              icon: tool['icon'] as IconData,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tool['page'] as Widget,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required CardColorScheme colorScheme,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorScheme.gradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CardColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadowColor,
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon section
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.accentColor, size: 24),
                ),
                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: CardColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: CardColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status and arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF00).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF00FF00).withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'READY',
                        style: TextStyle(
                          color: Color(0xFF00FF00),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.accentColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
