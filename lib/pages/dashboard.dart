// lib/components/dashboard/dashboard.dart
import 'package:flutter/material.dart';
import 'package:mechanicalengineering/theme/card_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CardColors.dashboardBackground,
      appBar: AppBar(
        title: const Text('Engineering Dashboard'),
        backgroundColor: CardColors.appBarBackground,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            const SizedBox(height: 24),

            // Stats Overview
            _buildStatsOverview(),
            const SizedBox(height: 24),

            // Quick Actions Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    title: 'Altimeter',
                    subtitle: 'Elevation & Pressure',
                    icon: Icons.terrain_rounded,
                    colorScheme: CardColors.blueScheme,
                  ),
                  _DashboardCard(
                    title: 'Vacuum Converter',
                    subtitle: 'Pressure Units',
                    icon: Icons.speed_rounded,
                    colorScheme: CardColors.redScheme,
                  ),
                  _DashboardCard(
                    title: 'Pressure Converter',
                    subtitle: 'Engineering Pressure Units',
                    icon: Icons.compress_rounded,
                    colorScheme: CardColors.purpleScheme,
                  ),
                  _DashboardCard(
                    title: 'Flow Calculator',
                    subtitle: 'Pipe Flow Rates',
                    icon: Icons.water_drop_rounded,
                    colorScheme: CardColors.blueScheme,
                  ),
                  _DashboardCard(
                    title: 'Thermal Tools',
                    subtitle: 'Heat Transfer',
                    icon: Icons.thermostat_rounded,
                    colorScheme: CardColors.redScheme,
                  ),
                  _DashboardCard(
                    title: 'Material Data',
                    subtitle: 'Properties Database',
                    icon: Icons.science_rounded,
                    colorScheme: CardColors.purpleScheme,
                  ),
                ],
              ),
            ),
          ],
        ),
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
              'ENGINEERING DASHBOARD',
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
          'Engineering\nControl Center',
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitor and manage your engineering tools',
          style: TextStyle(
            color: CardColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      decoration: BoxDecoration(
        color: CardColors.appBarBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CardColors.borderLight, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            value: '12',
            label: 'Active Tools',
            icon: Icons.engineering_rounded,
            color: CardColors.blueAccent,
          ),
          _buildStatItem(
            value: '24',
            label: 'Calculations',
            icon: Icons.calculate_rounded,
            color: CardColors.redAccent,
          ),
          _buildStatItem(
            value: '8',
            label: 'Projects',
            icon: Icons.folder_rounded,
            color: CardColors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withAlpha((0.3 * 255).toInt()),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: CardColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// -----------------------------
/// Dashboard Card Widget
/// -----------------------------
class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final CardColorScheme colorScheme;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $title'),
              duration: const Duration(seconds: 1),
              backgroundColor: CardColors.mediumGreyGradient[0],
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.gradient[0],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CardColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadowColor,
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -15,
                bottom: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.shadowColor.withAlpha(
                      (0.1 * 255).toInt(),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.08 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.shadowColor.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadowColor.withAlpha(
                              (0.2 * 255).toInt(),
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: colorScheme.accentColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'READY',
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.8 * 255).toInt()),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
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
