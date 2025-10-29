// lib/components/dashboard/dashboard.dart
import 'package:flutter/material.dart';
import 'package:mechanicalengineering/theme/card_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CardColors.dashboardBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            const SizedBox(height: 32),

            // Stats Overview
            _buildStatsOverview(),
            const SizedBox(height: 32),

            // Quick Actions Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6, // Adjusted for better proportions
                children: [
                  _DashboardCard(
                    title: 'Altimeter',
                    subtitle: 'Elevation & Pressure',
                    status: 'READY',
                    colorScheme: CardColors.blueScheme,
                  ),
                  _DashboardCard(
                    title: 'Vacuum Converter',
                    subtitle: 'Pressure Units',
                    status: 'READY',
                    colorScheme: CardColors.redScheme,
                  ),
                  _DashboardCard(
                    title: 'Pressure Converter',
                    subtitle: 'Engineering Pressure Units',
                    status: 'READY',
                    colorScheme: CardColors.purpleScheme,
                  ),
                  _DashboardCard(
                    title: 'Flow Calculator',
                    subtitle: 'Pipe Flow Rates',
                    status: 'READY',
                    colorScheme: CardColors.blueScheme,
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
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: CardColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ENGINEERING DASHBOARD',
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
          'Engineering\nControl Center',
          style: TextStyle(
            color: CardColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
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
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          value: '12',
          label: 'Active Tools',
          color: CardColors.blueAccent,
        ),
        _buildStatCard(
          value: '24',
          label: 'Calculations',
          color: CardColors.redAccent,
        ),
        _buildStatCard(
          value: '8',
          label: 'Projects',
          color: CardColors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: CardColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: CardColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------
/// Dashboard Card Widget
/// -----------------------------
class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final CardColorScheme colorScheme;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.status,
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
              backgroundColor: colorScheme.gradient[0],
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorScheme.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CardColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadowColor,
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Color(0xFF00FF00),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
