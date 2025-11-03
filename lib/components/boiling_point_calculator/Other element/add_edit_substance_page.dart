import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';

class AddEditSubstancePage extends StatefulWidget {
  final BoilingPointController controller;

  const AddEditSubstancePage({super.key, required this.controller});

  @override
  State<AddEditSubstancePage> createState() => _AddEditSubstancePageState();
}

class _AddEditSubstancePageState extends State<AddEditSubstancePage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final isEditing = widget.controller.editingSubstanceName != null;

    try {
      // 1. Add or Update substance (saves to SharedPreferences)
      if (isEditing) {
        await widget.controller.editCustomSubstance();
      } else {
        await widget.controller.addCustomSubstance();
      }

      // 2. Success: Redirect back to "boilingpoint" interface using Navigator.pop()
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${isEditing ? 'Updated' : 'Added'} substance successfully!',
            ),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  // --------------------------------------------------------------------------
  // Validators
  // --------------------------------------------------------------------------
  String? _validateNumber(String? value, String fieldName, bool allowZero) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number.';
    }
    if (!allowZero && number <= 0) {
      return '$fieldName must be positive.';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Substance Name is required.';
    }
    return null;
  }
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.controller.editingSubstanceName != null;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Substance' : 'Add Custom Substance'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textOnPrimaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Substance Name Input
                _buildPropertyField(
                  label: 'Substance Name',
                  unit: '',
                  controller: widget.controller.customSubstanceNameController,
                  validator: _validateName,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                // Property Header
                Text(
                  'Substance Properties (Initial Conditions):',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Enthalpy of Vaporization Input
                _buildPropertyField(
                  label: 'Enthalpy of Vaporization (ΔHvap)',
                  unit: 'kJ/mol',
                  controller: widget.controller.dhvapController,
                  validator: (v) =>
                      _validateNumber(v, 'Enthalpy of Vaporization', false),
                ),
                const SizedBox(height: 16),

                // Initial Boiling Point Input
                _buildPropertyField(
                  label: 'Initial Boiling Point (T₁)',
                  unit: '°C',
                  controller: widget.controller.temp1Controller,
                  validator: (v) =>
                      _validateNumber(v, 'Initial Boiling Point', true),
                ),
                const SizedBox(height: 16),

                // Standard Pressure Input
                _buildPropertyField(
                  label: 'Standard Pressure (P₁)',
                  unit: 'mmHg',
                  controller: widget.controller.pressure1Controller,
                  validator: (v) =>
                      _validateNumber(v, 'Standard Pressure', false),
                ),
                const SizedBox(height: 32),

                // Save Button using CustomButton
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    onPressed: _handleSave,
                    text: isEditing ? 'Update Substance' : 'Add Substance',
                    backgroundColor: AppTheme.primaryColor,
                    textColor: AppTheme.textOnPrimaryColor,
                    borderRadius: 12,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      widget.controller.cancelCustomSubstanceDialog();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for property fields
  Widget _buildPropertyField({
    required String label,
    required String unit,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = const TextInputType.numberWithOptions(
      decimal: true,
    ),
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
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
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
                  keyboardType: keyboardType,
                  validator: validator,
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    hintText: 'Enter value',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w400,
                    ),
                    errorMaxLines: 2,
                  ),
                ),
              ),
              if (unit.isNotEmpty)
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                    ),
                  ),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13,
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
