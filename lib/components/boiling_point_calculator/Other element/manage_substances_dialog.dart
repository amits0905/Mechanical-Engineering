import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

// Note: It's assumed CustomSubstanceDialog is imported by the UI file,
// and this file only needs the Controller and common UI components.

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
  @override
  void initState() {
    super.initState();
    // Ensure the state updates if the controller changes the substance list
    widget.controller.onUpdate = _updateState;
  }

  // Local state update method
  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleDeleteSubstance(
    String substanceName,
    BuildContext dialogContext,
  ) async {
    await widget.controller.deleteCustomSubstance(substanceName);
    // Logic to close the current confirmation dialog and update the list
    if (mounted && dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
      // If the list becomes empty, also close the Manage dialog
      if (widget.controller.customSubstances.isEmpty) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _handleClearAllSubstances(BuildContext dialogContext) async {
    await widget.controller.substanceDatabase.clearCustomSubstances();
    // Logic to close both confirmation and management dialogs
    if (mounted && dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

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
                                // Close the Manage dialog before showing the Edit dialog
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
