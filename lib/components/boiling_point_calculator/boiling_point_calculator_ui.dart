// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';

class BoilingPointCalculatorPage extends StatefulWidget {
  const BoilingPointCalculatorPage({super.key});

  @override
  State<BoilingPointCalculatorPage> createState() =>
      _BoilingPointCalculatorPageState();
}

class _BoilingPointCalculatorPageState
    extends State<BoilingPointCalculatorPage> {
  late final BoilingPointController _controller;

  final List<TextInputFormatter> _decimalInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
  ];

  @override
  void initState() {
    super.initState();
    _controller = BoilingPointController(onUpdate: _onLogicUpdate);
    _controller.loadSavedSubstances();
    _controller.loadDefaultValues(); // Load default values for water
  }

  void _onLogicUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ OPTIMIZED: Using CustomTextField
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    String? suffixText,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: hint ?? '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: _decimalInputFormatter,
          prefixIcon: Icon(icon),
          suffixIcon: suffixText != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    suffixText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                )
              : null,
          borderRadius: 8.0,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
          enabled: enabled,
          readOnly: !enabled,
        ),
      ],
    );
  }

  /// ✅ OPTIMIZED: Using CustomDropdown for substance selection
  Widget _buildSubstanceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Substance',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomDropdown<String>(
          value: _controller.selectedSubstance,
          items: _controller.substances.map((String substance) {
            return DropdownMenuItem<String>(
              value: substance,
              child: Text(
                substance,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            _controller.selectSubstance(value);
            _controller
                .loadSubstanceDefaults(); // Load defaults when substance changes
          },
          backgroundColor: Colors.grey.shade50,
          borderRadius: 8.0,
        ),
      ],
    );
  }

  /// ✅ OPTIMIZED: Using CustomButton for action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Save & Use',
            onPressed: () {
              if (_controller.otherSubstanceController.text.trim().isNotEmpty) {
                _controller.saveNewSubstance(
                  _controller.otherSubstanceController.text.trim(),
                );
                _controller.otherSubstanceController.clear();
              }
            },
            backgroundColor: Colors.grey.shade300,
            textColor: Colors.black87,
            borderRadius: 8.0,
            height: 48,
            uppercase: false,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            text: 'Use Only',
            onPressed: () {
              _controller.selectedSubstance = _controller
                  .otherSubstanceController
                  .text
                  .trim();
              _controller.onUpdate?.call();
            },
            backgroundColor: AppTheme.primaryColor,
            borderRadius: 8.0,
            height: 48,
            uppercase: false,
          ),
        ),
      ],
    );
  }

  /// ✅ NEW: Calculation mode selector
  Widget _buildCalculationMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calculate',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment<String>(value: 't2', label: Text('T₂ (Final Temp)')),
            ButtonSegment<String>(
              value: 'p2',
              label: Text('P₂ (Final Pressure)'),
            ),
          ],
          selected: {_controller.calculationMode},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _controller.calculationMode = newSelection.first;
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _controller.calculationMode == 't2'
              ? 'Calculate final boiling point T₂ at pressure P₂'
              : 'Calculate final pressure P₂ at boiling point T₂',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Boiling Point Calculator'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Substance Selection - OPTIMIZED
            _buildSubstanceDropdown(),

            /// Show "Other" input
            if (_controller.selectedSubstance == 'Other') ...[
              const SizedBox(height: 16),
              CustomTextField(
                controller: _controller.otherSubstanceController,
                hintText: 'Enter new substance name',
                prefixIcon: const Icon(Icons.edit_outlined),
                borderRadius: 8.0,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                fillColor: Colors.grey.shade50,
              ),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
            const SizedBox(height: 24),

            /// 🔹 Calculation Mode
            _buildCalculationMode(),
            const SizedBox(height: 24),

            /// 🔹 Required Inputs
            Text(
              'Required Inputs',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Enthalpy of Vaporization ΔHvap',
              controller: _controller.dhvapController,
              icon: Icons.whatshot_outlined,
              hint: '40.65',
              suffixText: 'kJ/mol',
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Initial Pressure P₁',
              controller: _controller.pressure1Controller,
              icon: Icons.compress_outlined,
              hint: '760',
              suffixText: 'Torr',
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Initial Boiling Point T₁',
              controller: _controller.temp1Controller,
              icon: Icons.thermostat_outlined,
              hint: '100.0',
              suffixText: '°C',
            ),
            const SizedBox(height: 16),

            /// 🔹 Target Input (changes based on calculation mode)
            if (_controller.calculationMode == 't2')
              _buildInputField(
                label: 'Final Pressure P₂',
                controller: _controller.pressure2Controller,
                icon: Icons.compress_outlined,
                hint: '100',
                suffixText: 'Torr',
              )
            else
              _buildInputField(
                label: 'Final Boiling Point T₂',
                controller: _controller.temp2Controller,
                icon: Icons.thermostat_outlined,
                hint: '50.0',
                suffixText: '°C',
              ),

            const SizedBox(height: 24),

            /// 🔹 Result Display
            if (_controller.result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(30),
                  border: Border.all(
                    color: AppTheme.primaryColor.withAlpha(100),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _controller.calculationMode == 't2'
                          ? 'Final Boiling Point T₂'
                          : 'Final Pressure P₂',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _controller.result,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (_controller.calculationMode == 't2')
                      const Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      )
                    else
                      const Text(
                        'Torr',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            /// 🔹 Calculate Button - OPTIMIZED
            CustomButton(
              text: 'Calculate',
              onPressed: _controller.calculateBoilingPoint,
              backgroundColor: AppTheme.primaryColor,
              borderRadius: 12.0,
              height: 54,
              fontSize: 16,
              uppercase: true,
            ),
            const SizedBox(height: 16),

            /// 🔹 Information Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Calculation Info',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uses Clausius-Clapeyron equation:\n'
                    'ln(P₂/P₁) = (ΔHvap/R) × (1/T₁ - 1/T₂)\n'
                    'where R = 8.314 J/mol·K and temperatures in Kelvin',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
