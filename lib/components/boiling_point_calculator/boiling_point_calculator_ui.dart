import 'package:flutter/material.dart';
import 'boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/add_edit_substance_page.dart';
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

  void _showManageSubstancesDialog() {
    showDialog(
      context: context,
      builder: (context) => ManageSubstancesDialog(controller: _controller),
    );
  }

  void _navigateToAddEditSubstancePage() {
    _controller.cancelCustomSubstanceDialog();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSubstancePage(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(), // REMOVED from here
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // --- NEW POSITION ---

                    // Calculation Mode
                    _buildCalculationModeCard(),
                    const SizedBox(height: 20),

                    _buildHeader(), // INSERTED here
                    const SizedBox(height: 20), // Add spacing after the header
                    // Substance Selection
                    _buildSubstanceCard(),
                    const SizedBox(height: 20),

                    // Input Parameters
                    _buildInputParametersCard(),
                    const SizedBox(height: 20),

                    // Calculate Button
                    _buildCalculateButton(),
                    const SizedBox(height: 20),

                    // Result Display
                    _buildResultCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
          icon: const Icon(Icons.science_outlined),
          onPressed: _showManageSubstancesDialog,
          tooltip: 'Manage Substances',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.thermostat_auto,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Clausius-Clapeyron Equation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Calculate boiling points at different pressures',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationModeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calculate_outlined, // Updated icon
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Calculation Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCalculationToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationToggle() {
    return Container(
      width: double.infinity, // Force full width
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.surfaceColor,
      ),
      child: Row(
        children: [
          // Left Toggle: Calculate T₂
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(11),
                ),
                onTap: () => _controller.updateCalculationMode('t2'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _controller.calculationMode == 't2'
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(11),
                    ),
                    border: _controller.calculationMode != 't2'
                        ? Border.all(color: AppTheme.surfaceColor, width: 1)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.thermostat_auto,
                        color: _controller.calculationMode == 't2'
                            ? AppTheme.textOnPrimaryColor
                            : AppTheme.textSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calculate T₂',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _controller.calculationMode == 't2'
                                    ? AppTheme.textOnPrimaryColor
                                    : AppTheme.textPrimaryColor,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Final Temperature',
                              style: TextStyle(
                                fontSize: 10,
                                color: _controller.calculationMode == 't2'
                                    ? AppTheme.textOnPrimaryColor.withValues(
                                        alpha: 0.8,
                                      )
                                    : AppTheme.textSecondaryColor,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 28,
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
          ),

          // Right Toggle: Calculate P₂
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(11),
                ),
                onTap: () => _controller.updateCalculationMode('p2'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _controller.calculationMode == 'p2'
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(11),
                    ),
                    border: _controller.calculationMode != 'p2'
                        ? Border.all(color: AppTheme.surfaceColor, width: 1)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.speed,
                        color: _controller.calculationMode == 'p2'
                            ? AppTheme.textOnPrimaryColor
                            : AppTheme.textSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calculate P₂',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _controller.calculationMode == 'p2'
                                    ? AppTheme.textOnPrimaryColor
                                    : AppTheme.textPrimaryColor,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Final Pressure',
                              style: TextStyle(
                                fontSize: 10,
                                color: _controller.calculationMode == 'p2'
                                    ? AppTheme.textOnPrimaryColor.withValues(
                                        alpha: 0.8,
                                      )
                                    : AppTheme.textSecondaryColor,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstanceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Substance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  onPressed: _navigateToAddEditSubstancePage,
                  tooltip: 'Add Custom Substance',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: DropdownButton<String>(
                value: _controller.selectedSubstance,
                isExpanded: true,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                items: _controller.substances.map((substance) {
                  return DropdownMenuItem(
                    value: substance,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            substance == 'Other'
                                ? Icons.add_circle_outline
                                : Icons.science_outlined,
                            color: AppTheme.primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
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
                          if (_controller.substanceDatabase.isCustomSubstance(
                            substance,
                          ))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppTheme.successColor.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Custom',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    if (newValue == 'Other') {
                      _navigateToAddEditSubstancePage();
                    } else {
                      _controller.updateSelectedSubstance(newValue);
                    }
                  }
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputParametersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
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
            const SizedBox(height: 4),
            Text(
              'Substance properties and calculation input',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Substance Properties
            _buildParameterSection(
              title: 'Substance Properties',
              icon: Icons.thermostat_auto,
              children: [
                _buildParameterInput(
                  label: 'Enthalpy of Vaporization',
                  symbol: 'ΔHvap',
                  unit: 'kJ/mol',
                  controller: _controller.dhvapController,
                  icon: Icons.water_drop_outlined,
                ),
                const SizedBox(height: 12),
                _buildParameterInput(
                  label: 'Initial Boiling Point',
                  symbol: 'T₁',
                  unit: '°C',
                  controller: _controller.temp1Controller,
                  icon: Icons.thermostat_outlined,
                ),
                const SizedBox(height: 12),
                _buildParameterInput(
                  label: 'Standard Pressure',
                  symbol: 'P₁',
                  unit: 'mmHg',
                  controller: _controller.pressure1Controller,
                  icon: Icons.speed_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Calculation Input
            _buildParameterSection(
              title: 'Calculation Input',
              icon: Icons.input_rounded,
              children: [
                _buildParameterInput(
                  label: _controller.calculationMode == 't2'
                      ? 'Final Pressure'
                      : 'Final Temperature',
                  symbol: _controller.calculationMode == 't2' ? 'P₂' : 'T₂',
                  unit: _controller.calculationMode == 't2' ? 'mmHg' : '°C',
                  controller: _controller.calculationMode == 't2'
                      ? _controller.pressure2Controller
                      : _controller.temp2Controller,
                  icon: _controller.calculationMode == 't2'
                      ? Icons.speed_outlined
                      : Icons.thermostat_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildParameterInput({
    required String label,
    required String symbol,
    required String unit,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Icon and Label Section - Fixed width
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppTheme.primaryColor, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 40,
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),

          // Input Field - Flexible
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter value',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 40,
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),

          // Unit Section - Fixed width
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _controller.calculate(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textOnPrimaryColor,
          elevation: 4,
          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'CALCULATE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _controller.result.isEmpty
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.successColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: _controller.result.isEmpty
                      ? AppTheme.textSecondaryColor
                      : AppTheme.successColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'RESULT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _controller.result.isEmpty
                        ? AppTheme.textSecondaryColor
                        : AppTheme.successColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _controller.result.isEmpty
                    ? AppTheme.surfaceColor
                    : AppTheme.successColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _controller.result.isEmpty
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.successColor.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                _controller.result.isEmpty
                    ? 'Enter all parameters and click CALCULATE to see the result'
                    : _controller.result,
                style: TextStyle(
                  fontSize: _controller.result.isEmpty ? 15 : 18,
                  fontWeight: _controller.result.isEmpty
                      ? FontWeight.w400
                      : FontWeight.w700,
                  color: _controller.result.isEmpty
                      ? AppTheme.textSecondaryColor
                      : AppTheme.textPrimaryColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
