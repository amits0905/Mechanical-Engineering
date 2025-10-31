import 'package:flutter/material.dart';
import 'boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';

class BoilingPointCalculatorUI extends StatefulWidget {
  const BoilingPointCalculatorUI({super.key});

  @override
  State<BoilingPointCalculatorUI> createState() =>
      _BoilingPointCalculatorUIState();
}

class _BoilingPointCalculatorUIState extends State<BoilingPointCalculatorUI> {
  final BoilingPointController _controller = BoilingPointController();

  @override
  void initState() {
    super.initState();
    _controller.onUpdate = _updateState;
    _controller.loadDefaultValues();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showManageSubstancesDialog() {
    showDialog(
      context: context,
      builder: (context) => ManageSubstancesDialog(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Boiling Point Calculator'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textOnPrimaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.science),
            onPressed: _showManageSubstancesDialog,
            tooltip: 'Manage Custom Substances',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Calculation Type Toggle
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Calculation Type',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 12),
                          ToggleButtons(
                            isSelected: [
                              _controller.calculationMode == 't2',
                              _controller.calculationMode == 'p2',
                            ],
                            onPressed: (index) {
                              setState(() {
                                _controller.calculationMode = index == 0
                                    ? 't2'
                                    : 'p2';
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            constraints: const BoxConstraints(
                              minHeight: 44,
                              minWidth: 120,
                            ),
                            selectedColor: AppTheme.textOnPrimaryColor,
                            fillColor: AppTheme.primaryColor,
                            color: AppTheme.textSecondaryColor,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Find Boiling Point',
                                  style: TextStyle(
                                    fontWeight:
                                        _controller.calculationMode == 't2'
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Find Pressure',
                                  style: TextStyle(
                                    fontWeight:
                                        _controller.calculationMode == 'p2'
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Substance Selection
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Substance',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppTheme.textPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              if (_controller.isCurrentSubstanceCustom)
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: AppTheme.primaryColor,
                                  ),
                                  onPressed: () =>
                                      _controller.startEditingSubstance(
                                        _controller.selectedSubstance,
                                      ),
                                  tooltip: 'Edit Custom Substance',
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.dividerColor),
                            ),
                            child: DropdownButton<String>(
                              value: _controller.selectedSubstance,
                              isExpanded: true,
                              underline: const SizedBox(),
                              borderRadius: BorderRadius.circular(12),
                              items: _controller.substances
                                  .map(
                                    (substance) => DropdownMenuItem(
                                      value: substance,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                substance,
                                                style: TextStyle(
                                                  color:
                                                      AppTheme.textPrimaryColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if (_controller.substanceDatabase
                                                .isCustomSubstance(substance))
                                              Icon(
                                                Icons.person,
                                                size: 16,
                                                color: AppTheme.primaryColor,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _controller.selectSubstance,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Input Fields
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Input Parameters',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildNumberInput(
                            label: 'Enthalpy of Vaporization (kJ/mol)',
                            controller: _controller.dhvapController,
                          ),
                          const SizedBox(height: 16),
                          _buildNumberInput(
                            label: 'Initial Pressure (mmHg)',
                            controller: _controller.pressure1Controller,
                          ),
                          const SizedBox(height: 16),
                          _buildNumberInput(
                            label: 'Initial Boiling Point (°C)',
                            controller: _controller.temp1Controller,
                          ),
                          const SizedBox(height: 16),
                          if (_controller.calculationMode == 't2')
                            _buildNumberInput(
                              label: 'Final Pressure (mmHg)',
                              controller: _controller.pressure2Controller,
                            )
                          else
                            _buildNumberInput(
                              label: 'Final Boiling Point (°C)',
                              controller: _controller.temp2Controller,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Calculate Button
                  CustomButton(
                    text: 'Calculate',
                    onPressed: _controller.calculateBoilingPoint,
                    backgroundColor: AppTheme.primaryColor,
                    textColor: AppTheme.textOnPrimaryColor,
                    borderRadius: 16,
                    height: 56,
                    fontSize: 16,
                  ),

                  const SizedBox(height: 20),

                  // Results
                  if (_controller.result.isNotEmpty &&
                      !_controller.result.startsWith('Error'))
                    Card(
                      elevation: 0,
                      color: AppTheme.successColor.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppTheme.successColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Calculation Result',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _controller.result,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (_controller.result.isNotEmpty &&
                      _controller.result.startsWith('Error'))
                    Card(
                      elevation: 0,
                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppTheme.errorColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Error',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppTheme.errorColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _controller.result,
                              style: TextStyle(
                                color: AppTheme.errorColor,
                                fontSize: 14,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Custom Substance Dialog
            if (_controller.showCustomSubstanceDialog)
              CustomSubstanceDialog(controller: _controller),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
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
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          fillColor: AppTheme.surfaceColor,
          borderRadius: 12,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.dividerColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Custom Substance Dialog
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
              label: 'Enthalpy of Vaporization (kJ/mol)',
              controller: widget.controller.dhvapController,
            ),
            const SizedBox(height: 12),
            _buildPropertyField(
              label: 'Normal Boiling Point (°C)',
              controller: widget.controller.temp1Controller,
            ),
            const SizedBox(height: 12),
            _buildPropertyField(
              label: 'Standard Pressure (mmHg)',
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

  Widget _buildPropertyField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          fillColor: AppTheme.surfaceColor,
          borderRadius: 8,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ],
    );
  }
}

// Manage Substances Dialog
class ManageSubstancesDialog extends StatefulWidget {
  final BoilingPointController controller;

  const ManageSubstancesDialog({super.key, required this.controller});

  @override
  State<ManageSubstancesDialog> createState() => _ManageSubstancesDialogState();
}

class _ManageSubstancesDialogState extends State<ManageSubstancesDialog> {
  Future<void> _handleDeleteSubstance(
    String substanceName,
    BuildContext dialogContext,
  ) async {
    await widget.controller.deleteCustomSubstance(substanceName);
    if (mounted && dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
      if (widget.controller.customSubstances.isEmpty) {
        // Close manage dialog if no substances left
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _handleClearAllSubstances(BuildContext dialogContext) async {
    await widget.controller.substanceDatabase.clearCustomSubstances();
    if (mounted && dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
      if (context.mounted) {
        Navigator.of(context).pop(); // Close manage dialog
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
