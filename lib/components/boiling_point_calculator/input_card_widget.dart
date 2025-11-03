import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

class InputCardWidget extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final bool readOnly;
  final IconData icon;

  const InputCardWidget({
    super.key,
    required this.label,
    required this.unit,
    required this.controller,
    this.readOnly = false, // Default to false now
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor, // Removed readOnly color differentiation
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(
            alpha: 0.3,
          ), // Always use primary color
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Removed the Auto badge completely
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _buildTextField()),
              _buildUnitWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      readOnly: readOnly, // Still pass the parameter but it will be false
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor, // Always use primary text color
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildUnitWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        border: Border(
          left: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
        ),
      ),
      child: Text(
        unit,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
