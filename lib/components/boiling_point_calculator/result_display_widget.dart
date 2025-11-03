import 'package:flutter/material.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

class ResultDisplayWidget extends StatelessWidget {
  final String result;

  const ResultDisplayWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: result.isEmpty
            ? AppTheme.surfaceColor
            : AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: result.isEmpty
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : AppTheme.successColor.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                color: result.isEmpty
                    ? AppTheme.textSecondaryColor
                    : AppTheme.successColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'RESULT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: result.isEmpty
                      ? AppTheme.textSecondaryColor
                      : AppTheme.successColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.isEmpty
                ? 'Enter values and press CALCULATE to see the result'
                : result,
            style: TextStyle(
              fontSize: result.isEmpty ? 15 : 18,
              fontWeight: result.isEmpty ? FontWeight.w400 : FontWeight.w700,
              color: result.isEmpty
                  ? AppTheme.textSecondaryColor
                  : AppTheme.textPrimaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
