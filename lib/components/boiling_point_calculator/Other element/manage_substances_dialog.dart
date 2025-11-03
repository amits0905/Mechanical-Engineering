// manage_substances_dialog.dart
import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_constants.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/add_edit_substance_page.dart';

class ManageSubstancesDialog extends StatelessWidget {
  final BoilingPointController controller;

  const ManageSubstancesDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Listen to the controller's SubstanceDatabase for updates
    final database = controller.substanceDatabase;

    return ListenableBuilder(
      listenable: database,
      builder: (context, child) {
        // Get all available substances and filter to ONLY include custom ones.
        final allSubstances = database.getAvailableSubstances();
        final customSubstances = allSubstances
            .where(database.isCustomSubstance)
            .toList();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              BoilingPointConstants.cardBorderRadius,
            ),
          ),
          // Title reflects the focus on user-managed substances
          title: const Text('Manage Custom Substances'),
          content: SizedBox(
            width: double.maxFinite,
            // Constraints to prevent the dialog from being too tall
            height: MediaQuery.of(context).size.height * 0.6,
            child: customSubstances.isEmpty
                ? const Center(
                    child: Text(
                      'No custom substances found.\nTap "ADD NEW" to create one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView(
                    children: [
                      // List only custom substances
                      ...customSubstances.map(
                        (name) =>
                            _buildSubstanceTile(context, name, isCustom: true),
                      ),
                    ],
                  ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Clear state for new substance before navigating
                controller.prepareForAdding();
                _navigateToAddEdit(context);
              },
              child: const Text('ADD NEW'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build each item in the list
  Widget _buildSubstanceTile(
    BuildContext context,
    String name, {
    required bool isCustom,
  }) {
    // Since this dialog only shows custom substances, we assume edit/delete icons are always present.
    return ListTile(
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {
              // Pre-populate controller for editing
              controller.prepareForEditing(name);
              _navigateToAddEdit(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () {
              _confirmDelete(context, name);
            },
          ),
        ],
      ),
      onTap: () {
        // Set the substance on tap and close the dialog
        controller.updateSelectedSubstance(name);
        Navigator.of(context).pop();
      },
    );
  }

  // Utility to navigate to the Add/Edit page
  void _navigateToAddEdit(BuildContext context) {
    // Close the dialog before navigating to a new route
    Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSubstancePage(controller: controller),
      ),
    );
  }

  // Deletion confirmation dialog
  void _confirmDelete(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete the custom substance "$name"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform the deletion
                await controller.substanceDatabase.removeUserSubstance(name);

                // Check context and close the confirmation dialog
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
