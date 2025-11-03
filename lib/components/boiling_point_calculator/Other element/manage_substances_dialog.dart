import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

// ✅ NEW IMPORT: Required for navigating to the full page editor
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/add_edit_substance_page.dart';

// --------------------------------------------------------------------------
// Manage Substances Dialog (For Viewing/Deleting/Launching Edit)
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

  // ✅ UPDATED METHOD TO NAVIGATE TO FULL PAGE FOR EDITING
  void _handleEdit(String substanceName) {
    // 1. Tell the controller which substance to edit (loads data into text controllers)
    widget.controller.startEditingCustomSubstance(substanceName);

    // 2. Close the current dialog.
    if (mounted && context.mounted) {
      Navigator.of(context).pop();

      // 3. Push the new full page for editing.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddEditSubstancePage(controller: widget.controller),
        ),
      );
    }
  }

  // --- Deletion Handlers ---

  Future<void> _handleDeleteSubstance(String substanceName) async {
    // 1. Delete substance
    await widget.controller.deleteCustomSubstance(substanceName);

    // 2. Update result area if the deleted substance was selected
    if (widget.controller.selectedSubstance == substanceName) {
      // Fall back to 'Water' or the first available substance
      widget.controller.updateSelectedSubstance(
        widget.controller.substances.first,
      );
    }

    if (mounted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$substanceName deleted successfully.'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  void _showDeleteConfirmation(String substanceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete the custom substance "$substanceName"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              _handleDeleteSubstance(substanceName);
            },
            child: Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text(
          'Are you sure you want to delete ALL custom substances? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close confirmation dialog
              await widget.controller.substanceDatabase.clearCustomSubstances();
              if (mounted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All custom substances cleared.'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
                // Also close the main manage dialog if it's empty now
                if (widget.controller.substanceDatabase
                    .getCustomSubstanceNames()
                    .isEmpty) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
  // --- End Deletion Handlers ---

  @override
  Widget build(BuildContext context) {
    final customSubstances = widget.controller.substanceDatabase
        .getCustomSubstanceNames();

    return AlertDialog(
      title: const Text('Manage Custom Substances'),
      contentPadding: const EdgeInsets.only(top: 20, left: 24, right: 24),
      actionsPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customSubstances.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'You have not added any custom substances yet.',
                  style: TextStyle(color: AppTheme.textSecondaryColor),
                ),
              )
            else
              Text(
                'Substances:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            if (customSubstances.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: customSubstances.length,
                  itemBuilder: (context, index) {
                    final substanceName = customSubstances[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.dividerColor,
                            width: index < customSubstances.length - 1 ? 1 : 0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(substanceName),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                color: AppTheme.primaryColor,
                              ),
                              // ⚠️ EDIT ACTION CALLS NEW HANDLE METHOD
                              onPressed: () => _handleEdit(substanceName),
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
            // ✅ ADD NEW SUBSTANCE BUTTON - NOW NAVIGATES
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 1. Close the current dialog
                  Navigator.of(context).pop();

                  // 2. Set controller to 'Add' mode
                  widget.controller.cancelCustomSubstanceDialog();

                  // 3. Push the new full page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditSubstancePage(controller: widget.controller),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Custom Substance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.textOnPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
