import 'package:flutter/material.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

class CalculationToggle extends StatelessWidget {
  final String calculationMode;
  final Function(String) onModeChanged;

  const CalculationToggle({
    super.key,
    required this.calculationMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ToggleButtons(
        isSelected: [calculationMode == 't2', calculationMode == 'p2'],
        onPressed: (index) {
          onModeChanged(index == 0 ? 't2' : 'p2');
        },
        borderRadius: BorderRadius.circular(16),
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        fillColor: AppTheme.primaryColor,
        color: AppTheme.textSecondaryColor,
        selectedColor: AppTheme.textOnPrimaryColor,
        constraints: const BoxConstraints(minHeight: 52),
        children: const [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Calculate T₂\n(Final Temperature)',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Calculate P₂\n(Final Pressure)',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
