// lib/components/tools/tools_page.dart
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
      backgroundColor: CardColors.scaffoldBackground,
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildToolsGrid(context),
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
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF666666), Color(0xFF333333)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ENGINEERING TOOLS',
              style: TextStyle(
                color: CardColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Professional\nEngineering Toolkit',
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Advanced calculators and sensors for engineering professionals',
          style: TextStyle(
            color: CardColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildToolsGrid(BuildContext context) {
    final tools = [
      {
        'icon': Icons.terrain_rounded,
        'title': 'Altimeter',
        'subtitle': 'Elevation & Atmospheric Pressure',
        'colorScheme': CardColors.blueScheme,
        'page': const AltimeterPage(),
      },
      {
        'icon': Icons.speed_rounded,
        'title': 'Vacuum Converter',
        'subtitle': 'Vacuum Pressure Units',
        'colorScheme': CardColors.redScheme,
        'page': const VaccumUnitPage(),
      },
      {
        'icon': Icons.compress_rounded,
        'title': 'Pressure Converter',
        'subtitle': 'Engineering Pressure Units',
        'colorScheme': CardColors.purpleScheme,
        'page': const PressureUnitPage(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _buildToolCard(
          context,
          icon: tool['icon'] as IconData,
          title: tool['title'] as String,
          subtitle: tool['subtitle'] as String,
          colorScheme: tool['colorScheme'] as CardColorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => tool['page'] as Widget),
            );
          },
        );
      },
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required CardColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    int alpha(double opacity) => (opacity * 255).toInt();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.gradient[0],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CardColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadowColor,
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withAlpha(alpha(0.3)),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: colorScheme.shadowColor.withAlpha(alpha(0.1)),
                blurRadius: 5,
                spreadRadius: -2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.shadowColor.withAlpha(alpha(0.1)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(alpha(0.02)),
                        Colors.transparent,
                        colorScheme.shadowColor.withAlpha(alpha(0.05)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(alpha(0.08)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.accentColor.withAlpha(alpha(0.3)),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.accentColor.withAlpha(
                              alpha(0.2),
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: colorScheme.accentColor,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: TextStyle(
                        color: CardColors.textPrimary.withAlpha(alpha(0.95)),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: CardColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(alpha(0.1)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.accentColor.withAlpha(alpha(0.4)),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.accentColor.withAlpha(
                              alpha(0.2),
                            ),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.accentColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
