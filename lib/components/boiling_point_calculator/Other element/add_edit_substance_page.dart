import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

class AddEditSubstancePage extends StatefulWidget {
  final BoilingPointController controller;

  const AddEditSubstancePage({super.key, required this.controller});

  @override
  State<AddEditSubstancePage> createState() => _AddEditSubstancePageState();
}

class _AddEditSubstancePageState extends State<AddEditSubstancePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) {
      return; // Prevent multiple saves
    }

    setState(() {
      _isSaving = true;
    });

    final isEditing = widget.controller.editingSubstanceName != null;

    try {
      if (isEditing) {
        await widget.controller.editCustomSubstance();
      } else {
        await widget.controller.addCustomSubstance();
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Substance ${isEditing ? 'updated' : 'added'} successfully!',
          ),
          backgroundColor: AppTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _handleCancel() {
    if (!_isSaving) {
      widget.controller.cancelCustomSubstanceDialog();
      Navigator.of(context).pop(false);
    }
  }

  String? _validateNumber(String? value, String fieldName, bool allowZero) {
    if (value == null || value.trim().isEmpty) {
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
    if (value == null || value.trim().isEmpty) {
      return 'Substance name is required.';
    }

    if (value.trim().length > 50) {
      return 'Substance name is too long (max 50 characters).';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.controller.editingSubstanceName != null;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final padding = isMobile ? 16.0 : 32.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Substance' : 'Add Custom Substance'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textOnPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, title: 'Input Parameters'),
                      const SizedBox(height: 24),
                      _buildPropertyField(
                        label: 'Substance Name',
                        unit: '',
                        controller:
                            widget.controller.customSubstanceNameController,
                        validator: _validateName,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: AppTheme.dividerColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildModernPropertyField(
                              label: 'Enthalpy of Vaporization (ΔHvap)',
                              unit: 'kJ/mol',
                              controller: widget.controller.dhvapController,
                              validator: (v) => _validateNumber(
                                v,
                                'Enthalpy of Vaporization',
                                false,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildModernPropertyField(
                              label: 'Initial Boiling Point (T₁)',
                              unit: '°C',
                              controller: widget.controller.temp1Controller,
                              validator: (v) => _validateNumber(
                                v,
                                'Initial Boiling Point',
                                true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildModernPropertyField(
                              label: 'Standard Pressure (P₁)',
                              unit: 'mmHg',
                              controller: widget.controller.pressure1Controller,
                              validator: (v) => _validateNumber(
                                v,
                                'Standard Pressure',
                                false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildButtonsSection(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildButtonsSection(bool isEditing) {
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isSaving
                  ? 'Saving...'
                  : isEditing
                  ? 'Update Substance'
                  : 'Add Substance',
              style: TextStyle(
                color: AppTheme.textOnPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isSaving ? null : _handleCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: AppTheme.primaryColor),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

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
        const SizedBox(height: 8),
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
                      color: AppTheme.textSecondaryColor.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                    ),
                    errorMaxLines: 2,
                    errorStyle: const TextStyle(fontSize: 12, height: 1.2),
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

  Widget _buildModernPropertyField({
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF1a1a1a),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 100,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1a1a1a),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  hintText: '0.0',
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                  errorStyle: TextStyle(height: 0, fontSize: 0),
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: Text(
                unit,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.only(top: 4),
          child: Builder(
            builder: (context) {
              final error = validator(controller.text);
              if (error != null) {
                return Text(
                  error,
                  style: const TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 12,
                    height: 1.2,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
