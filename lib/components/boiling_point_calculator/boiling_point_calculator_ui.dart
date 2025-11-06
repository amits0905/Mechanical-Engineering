import 'package:flutter/material.dart';
import 'boiling_point_calculator_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
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
  final _formKey = GlobalKey<FormState>();

  bool highlightT2 = false;
  bool highlightP2 = false;

  @override
  void initState() {
    super.initState();
    _controller.onUpdate = _updateState;
    _controller.loadDefaultValues();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  void _showManageSubstancesDialog() {
    showDialog(
      context: context,
      builder: (context) => ManageSubstancesDialog(controller: _controller),
    );
  }

  void _navigateToAddEditSubstancePage() {
    _controller.prepareForAdding();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSubstancePage(controller: _controller),
      ),
    );
  }

  void _onCalculatePressed() {
    FocusScope.of(context).unfocus();

    // Reset highlighting
    setState(() {
      highlightT2 = false;
      highlightP2 = false;
    });

    final t2Text = _controller.temp2Controller.text.trim();
    final p2Text = _controller.pressure2Controller.text.trim();

    // ✅ Case: Both filled -> highlight both and show error
    if (t2Text.isNotEmpty && p2Text.isNotEmpty) {
      setState(() {
        highlightT2 = true;
        highlightP2 = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only one of T₂ or P₂ should be filled.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Validate form normally
    if (_formKey.currentState?.validate() ?? false) {
      _controller.calculate(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSubstanceCard(),
                const SizedBox(height: 20),
                _buildInputParametersCard(),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildCalculateButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
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
      elevation: 2,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.list),
          tooltip: 'Manage Substances',
          onPressed: _showManageSubstancesDialog,
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
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.08),
            AppTheme.primaryColor.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.thermostat_auto, color: AppTheme.primaryColor, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clausius–Clapeyron Equation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimate boiling points under varying pressures\nln(P₂/P₁) = (ΔHvap/R) × (1/T₁ - 1/T₂)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstanceCard() {
    final List<String> availableSubstances = _controller.substances;

    return _buildCard(
      title: 'Substance Selection',
      icon: Icons.science_outlined,
      trailing: TextButton.icon(
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: const Text('Add Custom'),
        onPressed: _navigateToAddEditSubstancePage,
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _controller.selectedSubstance,
        isExpanded: true,
        decoration: _inputDecoration(
          hint: 'Select a substance',
          icon: Icons.search,
        ),
        menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
        borderRadius: BorderRadius.circular(12),
        selectedItemBuilder: (context) {
          return availableSubstances.map<Widget>((String s) {
            final isCustom = _controller.substanceDatabase.isCustomSubstance(s);
            return Text(
              s,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCustom ? FontWeight.bold : FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            );
          }).toList();
        },
        items: availableSubstances.isEmpty
            ? null
            : availableSubstances.map((s) {
                final isCustom = _controller.substanceDatabase
                    .isCustomSubstance(s);
                return DropdownMenuItem(
                  value: s,
                  child: Row(
                    children: [
                      Icon(
                        s == 'Water' ? Icons.water_drop : Icons.science,
                        color: AppTheme.primaryColor.withValues(
                          alpha: isCustom ? 0.8 : 1.0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s,
                          style: TextStyle(
                            fontWeight: isCustom
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: AppTheme.textPrimaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCustom) _buildTag('Custom', AppTheme.primaryColor),
                    ],
                  ),
                );
              }).toList(),
        onChanged: (val) {
          if (val != null) _controller.updateSelectedSubstance(val);
        },
      ),
    );
  }

  Widget _buildInputParametersCard() {
    return _buildCard(
      title: 'Input Parameters',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Substance Properties', Icons.science, [
            _buildParameterField(
              'ΔHvap',
              'Enthalpy of Vaporization',
              'kJ/mol',
              _controller.dhvapController,
              Icons.water_drop,
              validator: _validateEnthalpy,
              tooltip: 'Typically 20-100 kJ/mol for common substances',
            ),
            _buildParameterField(
              'T₁',
              'Initial Boiling Point',
              '°C',
              _controller.temp1Controller,
              Icons.thermostat,
              validator: _validateTemperature,
              tooltip: 'Normal boiling point at standard pressure',
            ),
            _buildParameterField(
              'P₁',
              'Standard Pressure',
              'mmHg',
              _controller.pressure1Controller,
              Icons.speed,
              validator: _validatePressure,
              tooltip: 'Standard atmospheric pressure: 760 mmHg',
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection(
            'Final Parameters',
            Icons.calculate,
            [
              _buildParameterField(
                'T₂',
                'Final Temperature',
                '°C',
                _controller.temp2Controller,
                Icons.thermostat,
                validator: _validateTemperature,
                tooltip:
                    'Temperature range: -273 - 500°C (Leave blank to calculate)',
                highlight: highlightT2,
              ),
              _buildParameterField(
                'P₂',
                'Final Pressure',
                'mmHg',
                _controller.pressure2Controller,
                Icons.compress,
                validator: _validatePressure,
                tooltip:
                    'Pressure range: 0.1 - 2000 mmHg (Leave blank to calculate)',
                highlight: highlightP2,
              ),
            ],
            subtitle: '1 Parameter needs to be fill by user',
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _onCalculatePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textOnPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.calculate_rounded),
        label: const Text(
          'CALCULATE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
    Color? iconColor,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? AppTheme.primaryColor.withValues(alpha: 0.1),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? AppTheme.primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildParameterField(
    String label,
    String hint,
    String suffix,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
    String? tooltip,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          border: Border.all(
            color: highlight ? Colors.redAccent : Colors.transparent,
            width: highlight ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: highlight
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          decoration: _inputDecoration(
            label: label,
            hint: hint,
            suffix: suffix,
            icon: icon,
            tooltip: tooltip,
          ),
          validator: (value) {
            if (label == 'T₂' || label == 'P₂') {
              if (value == null || value.isEmpty) return null;
            }
            return validator?.call(value);
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? label,
    String? hint,
    String? suffix,
    IconData? icon,
    String? tooltip,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffix,
      prefixIcon: icon != null
          ? Icon(icon, color: AppTheme.primaryColor)
          : null,
      suffixIcon: tooltip != null
          ? Tooltip(message: tooltip, child: const Icon(Icons.info_outline))
          : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  String? _validateEnthalpy(String? value) {
    final v = double.tryParse(value ?? '');
    if (v == null || v <= 0) return 'Enter a valid ΔHvap';
    return null;
  }

  String? _validateTemperature(String? value) {
    final v = double.tryParse(value ?? '');
    if (v == null || v < -273 || v > 500) return 'Temperature out of range';
    return null;
  }

  String? _validatePressure(String? value) {
    final v = double.tryParse(value ?? '');
    if (v == null || v <= 0 || v > 2000) return 'Pressure out of range';
    return null;
  }

  Widget _buildSection(
    String title,
    IconData icon,
    List<Widget> children, {
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryColor),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(children: children),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
