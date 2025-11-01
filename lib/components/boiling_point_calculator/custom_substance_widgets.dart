import 'package:flutter/material.dart';
import 'boiling_point_calculator_logic.dart'; // Must be imported for the Controller
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';

// --------------------------------------------------------------------------
// Custom Substance Dialog (For Adding/Editing)
// --------------------------------------------------------------------------

class CustomSubstanceDialog extends StatefulWidget {
  final BoilingPointController controller;

  const CustomSubstanceDialog({super.key, required this.controller});

  @override
  State<CustomSubstanceDialog> createState() => _CustomSubstanceDialogState();
}

class _CustomSubstanceDialogState extends State<CustomSubstanceDialog> {
  // Methods for handling updates and additions remain the same
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

    return Dialog(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                    onPressed: widget.controller.cancelCustomSubstanceDialog,
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
    );
  }

  // The helper method for the input fields also moves here
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                    // Auto-format to 2 decimal places when user finishes typing
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

// --------------------------------------------------------------------------
// Manage Substances Dialog (For Viewing/Deleting)
// --------------------------------------------------------------------------

class ManageSubstancesDialog extends StatefulWidget {
  final BoilingPointController controller;

  const ManageSubstancesDialog({super.key, required this.controller});

  @override
  State<ManageSubstancesDialog> createState() => _ManageSubstancesDialogState();
}

class _ManageSubstancesDialogState extends State<ManageSubstancesDialog> {
  // Methods for handling delete and clear all remain the same
  Future<void> _handleDeleteSubstance(
    String substanceName,
    BuildContext dialogContext,
  ) async {
    await widget.controller.deleteCustomSubstance(substanceName);
    // Logic to close the current dialog and potentially the parent dialog
    if (mounted && dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
      if (widget.controller.customSubstances.isEmpty) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _handleClearAllSubstances(BuildContext dialogContext) async {
    await widget.controller.substanceDatabase.clearCustomSubstances();
    // Logic to close the dialogs
    if (mounted && dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // Helper methods for showing confirmations remain the same
  void _showDeleteConfirmation(String substanceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Substance'),
        content: Text('Are you sure you want to delete "$substanceName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleDeleteSubstance(substanceName, context),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Substances'),
        content: const Text(
          'Are you sure you want to delete all custom substances? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleClearAllSubstances(context),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (implementation of ManageSubstancesDialog build method)
    final customSubstances = widget.controller.customSubstances;

    return Dialog(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Manage Custom Substances',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Your custom substances (${customSubstances.length})',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (customSubstances.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 48,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No custom substances yet',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add substances using the "Other" option',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: customSubstances.length,
                  itemBuilder: (context, index) {
                    final substanceName = customSubstances[index];
                    final substance = widget.controller.substanceDatabase
                        .getSubstance(substanceName);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.science,
                          color: AppTheme.primaryColor,
                        ),
                        title: Text(
                          substanceName,
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: substance != null
                            ? Text(
                                'BP: ${substance.normalBoilingPoint}°C • ΔHvap: ${substance.enthalpyVaporization} kJ/mol',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                widget.controller.startEditingSubstance(
                                  substanceName,
                                );
                              },
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 18,
                                color: AppTheme.errorColor,
                              ),
                              onPressed: () =>
                                  _showDeleteConfirmation(substanceName),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            if (customSubstances.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _showClearAllConfirmation,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: BorderSide(color: AppTheme.errorColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Clear All Custom Substances'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
