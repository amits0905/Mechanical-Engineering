// lib/utils/calculator_page.dart
import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator.dart';
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

          // Calculator Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _calculatorItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.88,
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
              'ENGINEERING CALCULATORS',
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
          'Professional\nCalculation Tools',
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w800,
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
        backgroundColor: CardColors.darkGreyGradient[0],
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
/// Available Calculators
/// --------------------
final List<_CalculatorItem> _calculatorItems = [
  _CalculatorItem(
    title: 'Boiling Point',
    subtitle: 'Calculate at different pressures',
    icon: Icons.thermostat_rounded,
    colorScheme: CardColors.redScheme,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BoilingPointCalculatorPage(),
        ),
      );
    },
  ),
  _CalculatorItem(
    title: 'Flow Rate',
    subtitle: 'Pipe friction & flow rate',
    icon: Icons.waves_rounded,
    colorScheme: CardColors.blueScheme,
    isComingSoon: true,
  ),
  _CalculatorItem(
    title: 'Vacuum Evacuation',
    subtitle: 'Time to reach target vacuum',
    icon: Icons.timer_rounded,
    colorScheme: CardColors.purpleScheme,
    isComingSoon: true,
  ),
];

/// --------------------
/// Calculator Card Widget
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
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.shadowColor.withAlpha(26), // 0.1 opacity
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
                        Colors.white.withAlpha(5), // 0.02 opacity
                        Colors.transparent,
                        colorScheme.shadowColor.withAlpha(13), // 0.05 opacity
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
                        color: Colors.white.withAlpha(20), // 0.08 opacity
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.accentColor.withAlpha(
                            77,
                          ), // 0.3 opacity
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.accentColor.withAlpha(
                              51,
                            ), // 0.2 opacity
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
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: TextStyle(
                        color: CardColors.textPrimary.withAlpha(
                          243,
                        ), // 0.95 opacity
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: CardColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (isComingSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20), // 0.08 opacity
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: CardColors.borderMedium,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadowColor.withAlpha(
                                26,
                              ), // 0.1 opacity
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'COMING SOON',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withAlpha(179), // 0.7 opacity
                            letterSpacing: 0.8,
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(26), // 0.1 opacity
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colorScheme.accentColor.withAlpha(
                                  102,
                                ), // 0.4 opacity
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.accentColor.withAlpha(
                                    51,
                                  ), // 0.2 opacity
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
