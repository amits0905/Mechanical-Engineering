// lib/utils/calculator_page.dart
import 'package:flutter/material.dart';
// import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_ui.dart'; // Add this import
import 'package:mechanicalengineering/theme/card_colors.dart';

/// --------------------
/// Calculator Page Root
/// --------------------
class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CardColors.scaffoldBackground,
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Calculator Grid - Fixed height issue
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _calculatorItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1, // Better aspect ratio for content
            ),
            itemBuilder: (context, index) {
              final item = _calculatorItems[index];
              return _CalculatorCard(
                title: item.title,
                subtitle: item.subtitle,
                icon: item.icon,
                colorScheme: item.colorScheme,
                onTap: item.onTap != null
                    ? () => item.onTap!(context)
                    : () => _showComingSoonSnackbar(context, item.title),
                isComingSoon: item.isComingSoon,
              );
            },
          ),
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
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: CardColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ENGINEERING CALCULATORS',
              style: TextStyle(
                color: CardColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Professional\nCalculation Tools',
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Advanced calculators for engineering professionals',
          style: TextStyle(
            color: CardColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String calculatorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$calculatorName - Coming Soon!'),
        duration: const Duration(seconds: 2),
        backgroundColor: CardColors.dashboardBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// --------------------
/// Calculator Item Model
/// --------------------
class _CalculatorItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final CardColorScheme colorScheme;
  final bool isComingSoon;
  final void Function(BuildContext context)? onTap;

  const _CalculatorItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorScheme,
    this.isComingSoon = false,
    this.onTap,
  });
}

/// --------------------
/// Available Calculators - FIXED: Remove const from constructor call
/// --------------------
final List<_CalculatorItem> _calculatorItems = [
  _CalculatorItem(
    // Removed 'const' keyword here
    title: 'Boiling Point',
    subtitle: 'Calculate at different pressures',
    icon: Icons.thermostat_rounded,
    colorScheme: CardColors.redScheme,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BoilingPointCalculatorUI(),
        ), // Use UI widget here
      );
    },
  ),
  _CalculatorItem(
    // Removed 'const' keyword here
    title: 'Flow Rate',
    subtitle: 'Pipe friction & flow rate',
    icon: Icons.waves_rounded,
    colorScheme: CardColors.blueScheme,
    isComingSoon: true,
  ),
  _CalculatorItem(
    // Removed 'const' keyword here
    title: 'Vacuum Evacuation',
    subtitle: 'Time to reach target vacuum',
    icon: Icons.timer_rounded,
    colorScheme: CardColors.purpleScheme,
    isComingSoon: true,
  ),
];

/// --------------------
/// Calculator Card Widget - Optimized height
/// --------------------
class _CalculatorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final CardColorScheme colorScheme;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const _CalculatorCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorScheme,
    this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isComingSoon
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isComingSoon ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorScheme.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
                color: Colors.black.withAlpha(77), // 0.3 opacity
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: colorScheme.shadowColor.withAlpha(26), // 0.1 opacity
                blurRadius: 5,
                spreadRadius: -2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decorative circle
              Positioned(
                right: -15,
                bottom: -15,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.shadowColor.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Overlay gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(5),
                        Colors.transparent,
                        colorScheme.shadowColor.withAlpha(13),
                      ],
                    ),
                  ),
                ),
              ),

              // Content - Optimized padding and spacing
              Padding(
                padding: const EdgeInsets.all(14.0), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(8), // Smaller padding
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colorScheme.accentColor.withAlpha(77),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.accentColor.withAlpha(51),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: colorScheme.accentColor,
                        size: 20, // Smaller icon
                      ),
                    ),

                    const SizedBox(height: 10), // Reduced spacing
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        color: CardColors.textPrimary.withAlpha(243),
                        fontSize: 15, // Slightly smaller font
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 3), // Reduced spacing
                    // Subtitle
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: CardColors.textSecondary,
                        fontSize: 11, // Slightly smaller font
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Bottom section
                    if (isComingSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: CardColors.borderMedium,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadowColor.withAlpha(26),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          'COMING SOON',
                          style: TextStyle(
                            fontSize: 8, // Smaller font
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withAlpha(179),
                            letterSpacing: 0.7,
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: colorScheme.accentColor.withAlpha(102),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.accentColor.withAlpha(51),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: colorScheme.accentColor,
                              size: 14, // Smaller icon
                            ),
                          ),
                        ],
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
