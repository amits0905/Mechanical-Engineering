import 'package:flutter/material.dart';
// import 'boiling_point_calculator_logic.dart'; // Controller
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';

class CustomSubstanceDialog extends StatefulWidget {
  final BoilingPointController controller;

  const CustomSubstanceDialog({super.key, required this.controller});

  @override
  State<CustomSubstanceDialog> createState() => _CustomSubstanceDialogState();
}

class _CustomSubstanceDialogState extends State<CustomSubstanceDialog> {
  Future<void> _handleEditSubstance() async {
    await widget.controller.editCustomSubstance();
    if (mounted && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleAddSubstance() async {
    await widget.controller.addCustomSubstance();
    if (mounted && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.controller.editingSubstanceName != null;
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    // Adaptive width
    final dialogWidth = isMobile
        ? mediaQuery.size.width * 0.9
        : 400.0; // Full width on small screens, fixed 400 on desktop

    return Dialog(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: mediaQuery.size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Substance' : 'Add Custom Substance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: widget.controller.customSubstanceNameController,
                  labelText: 'Substance Name',
                  fillColor: AppTheme.surfaceColor,
                  borderRadius: 12,
                ),
                const SizedBox(height: 16),
                Text(
                  'Substance Properties:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPropertyField(
                  label: 'Enthalpy of Vaporization (ΔHvap)',
                  unit: 'kJ/mol',
                  controller: widget.controller.dhvapController,
                ),
                const SizedBox(height: 12),
                _buildPropertyField(
                  label: 'Initial Boiling Point (T₁)',
                  unit: '°C',
                  controller: widget.controller.temp1Controller,
                ),
                const SizedBox(height: 12),
                _buildPropertyField(
                  label: 'Standard Pressure (P₁)',
                  unit: 'mmHg',
                  controller: widget.controller.pressure1Controller,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            widget.controller.cancelCustomSubstanceDialog,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: isEditing ? 'Update' : 'Add',
                        onPressed: isEditing
                            ? _handleEditSubstance
                            : _handleAddSubstance,
                        backgroundColor: AppTheme.primaryColor,
                        textColor: AppTheme.textOnPrimaryColor,
                        borderRadius: 12,
                        height: 48,
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

  // --------------------------------------------------------------------------
  // Helper method for property fields
  // --------------------------------------------------------------------------
  Widget _buildPropertyField({
    required String label,
    required String unit,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.dividerColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    hintText: 'Enter value',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final parsed = double.tryParse(value);
                      if (parsed != null) {
                        final formatted = parsed.toStringAsFixed(2);
                        if (formatted != value && !value.endsWith('.')) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (controller.text == value) {
                              controller.text = formatted;
                              controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: formatted.length),
                              );
                            }
                          });
                        }
                      }
                    }
                  },
                ),
              ),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
