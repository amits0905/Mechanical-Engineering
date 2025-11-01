import 'package:flutter/material.dart';
import 'boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';
// 👈 UPDATED IMPORTS: Importing both separated dialogs
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/custom_substance_widgets.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/manage_substances_dialog.dart';

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

  // This method now uses the imported ManageSubstancesDialog
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
        title: const Text(
          'Boiling Point Calculator',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textOnPrimaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _showManageSubstancesDialog,
            tooltip: 'Manage Custom Substances',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Calculation Type Toggle
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.dividerColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.calculationMode = 't2';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _controller.calculationMode == 't2'
                                    ? AppTheme.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thermostat_outlined,
                                    size: 18,
                                    color: _controller.calculationMode == 't2'
                                        ? AppTheme.textOnPrimaryColor
                                        : AppTheme.textSecondaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Temperature',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: _controller.calculationMode == 't2'
                                          ? AppTheme.textOnPrimaryColor
                                          : AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.calculationMode = 'p2';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _controller.calculationMode == 'p2'
                                    ? AppTheme.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.speed_outlined,
                                    size: 18,
                                    color: _controller.calculationMode == 'p2'
                                        ? AppTheme.textOnPrimaryColor
                                        : AppTheme.textSecondaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pressure',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: _controller.calculationMode == 'p2'
                                          ? AppTheme.textOnPrimaryColor
                                          : AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Substance Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.science_outlined,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Select Substance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const Spacer(),
                          if (_controller.isCurrentSubstanceCustom)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 14,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Custom',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.dividerColor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _controller.selectedSubstance,
                          isExpanded: true,
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          items: _controller.substances
                              .map(
                                (substance) => DropdownMenuItem(
                                  value: substance,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          substance,
                                          style: TextStyle(
                                            color: AppTheme.textPrimaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (_controller.substanceDatabase
                                          .isCustomSubstance(substance))
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            size: 14,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _controller.selectSubstance,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Input Fields
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.dividerColor.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_note_outlined,
                                size: 20,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Input Parameters',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildModernInput(
                          label: 'Enthalpy of Vaporization (ΔHvap)',
                          unit: 'kJ/mol',
                          icon: Icons.bolt_outlined,
                          controller: _controller.dhvapController,
                        ),
                        const SizedBox(height: 16),
                        _buildModernInput(
                          label: 'Initial Pressure (P₁)',
                          unit: 'mmHg',
                          icon: Icons.compress_outlined,
                          controller: _controller.pressure1Controller,
                        ),
                        const SizedBox(height: 16),
                        _buildModernInput(
                          label: 'Initial Boiling Point (T₁)',
                          unit: '°C',
                          icon: Icons.thermostat_outlined,
                          controller: _controller.temp1Controller,
                        ),
                        const SizedBox(height: 16),
                        if (_controller.calculationMode == 't2')
                          _buildModernInput(
                            label: 'Final Pressure (P₂)',
                            unit: 'mmHg',
                            icon: Icons.compress_outlined,
                            controller: _controller.pressure2Controller,
                          )
                        else
                          _buildModernInput(
                            label: 'Final Boiling Point (T₂)',
                            unit: '°C',
                            icon: Icons.thermostat_outlined,
                            controller: _controller.temp2Controller,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Calculate Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: 'Calculate Result',
                      onPressed: _controller.calculateBoilingPoint,
                      backgroundColor: AppTheme.primaryColor,
                      textColor: AppTheme.textOnPrimaryColor,
                      borderRadius: 16,
                      height: 56,
                      fontSize: 16,
                      uppercase: false,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Results
                  if (_controller.result.isNotEmpty &&
                      !_controller.result.startsWith('Error'))
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.successColor.withValues(alpha: 0.15),
                            AppTheme.successColor.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.successColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Result',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              _controller.result,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.successColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_controller.result.isNotEmpty &&
                      _controller.result.startsWith('Error'))
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.errorColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withValues(
                                alpha: 0.15,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              color: AppTheme.errorColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _controller.result.replaceFirst('Error: ', ''),
                              style: TextStyle(
                                color: AppTheme.errorColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Custom Substance Dialog (Now imported)
            if (_controller.showCustomSubstanceDialog)
              CustomSubstanceDialog(controller: _controller),
          ],
        ),
      ),
    );
  }

  // The helper method remains here as it is only used by the main UI
  Widget _buildModernInput({
    required String label,
    required String unit,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textSecondaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto-format to 2 decimal places when user finishes typing
                    if (value.isNotEmpty) {
                      final parsed = double.tryParse(value);
                      if (parsed != null) {
                        // Format to 2 decimal places for consistency
                        final formatted = parsed.toStringAsFixed(2);
                        // Only update if formatting changed the value
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
                width: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
