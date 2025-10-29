// vaccumunitpage.dart
// This file contains ONLY the UI - the visual parts!

import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/vacuum_tools/vaccum_unit_converter_logic.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

// Import our new logic and constants files
import 'vaccum_unit_constants.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart'; // Import the custom widgets

class VaccumUnitPage extends StatefulWidget {
  const VaccumUnitPage({super.key});

  @override
  State<VaccumUnitPage> createState() => _VacuumUnitPageState();
}

class _VacuumUnitPageState extends State<VaccumUnitPage> {
  // Controllers and state variables
  final TextEditingController _valueController = TextEditingController();
  String? _fromUnit = 'Torr';
  String? _toUnit = 'mbar';
  double? _result;

  // Conversion function - now much simpler!
  void _convertUnits() {
    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Get input value
    final input = double.tryParse(_valueController.text.replaceAll(',', '.'));

    if (input == null) {
      _showError('Please enter a valid number');
      return;
    }

    // Use our logic class to do the conversion
    final result = VaccumUnitConverter.convert(
      input: input,
      fromUnit: _fromUnit!,
      toUnit: _toUnit!,
    );

    if (result == null) {
      _showError('Conversion error. Check unit selection.');
    } else {
      setState(() => _result = result);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _result = null;
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaccumUnitConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Vaccum Unit Converter'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Card(
              elevation: 10,
              shadowColor: VaccumUnitConstants.primaryColor.withAlpha(
                (0.5 * 255).round(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  VaccumUnitConstants.cardBorderRadius,
                ),
              ),
              color: VaccumUnitConstants.cardColor,
              child: Padding(
                padding: VaccumUnitConstants.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),
                    _buildLabel('Value to Convert'),
                    const SizedBox(height: 8),
                    _buildInputField(), // ✅ Now using CustomTextField
                    const SizedBox(height: 24),
                    _buildUnitSelectionRow(),
                    const SizedBox(height: 28),
                    _buildConvertButton(),
                    const SizedBox(height: 30),
                    if (_result != null) _buildResultDisplay(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: VaccumUnitConstants.primaryColor.withAlpha(
              (0.1 * 255).round(),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.speed_rounded,
            color: VaccumUnitConstants.primaryColor,
            size: 32,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          'Vaccum Unit Conversion',
          style: VaccumUnitConstants.headerTextStyle,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: VaccumUnitConstants.labelTextStyle);
  }

  // ✅ UPDATED: Using ConversionTextField (which extends CustomTextField)
  Widget _buildInputField() {
    return ConversionTextField(
      controller: _valueController,
      hintText: '0.0',
      primaryColor: VaccumUnitConstants.primaryColor,
      backgroundColor: VaccumUnitConstants.backgroundColor,
      fontSize: 28.0,
    );
  }

  // ✅ ALTERNATIVE: Using CustomTextField directly (if you prefer)
  /*
  Widget _buildInputField() {
    return CustomTextField(
      controller: _valueController,
      hintText: '0.0',
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: VaccumUnitConstants.primaryColor,
      ),
      fillColor: VaccumUnitConstants.backgroundColor.withAlpha(
        (0.5 * 255).round(),
      ),
      borderRadius: 15.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }
  */

  Widget _buildDropdown(
    String? value,
    String label,
    ValueChanged<String?> onChanged,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: VaccumUnitConverter.units.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(
                  unit,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: VaccumUnitConstants.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: VaccumUnitConstants.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelectionRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          _fromUnit,
          'From Unit',
          (val) => setState(() => _fromUnit = val),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
          child: InkWell(
            onTap: _swapUnits,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VaccumUnitConstants.accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: VaccumUnitConstants.accentColor.withAlpha(
                      (0.3 * 255).round(),
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        _buildDropdown(
          _toUnit,
          'To Unit',
          (val) => setState(() => _toUnit = val),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: VaccumUnitConstants.primaryColor.withAlpha(
              (0.3 * 255).round(),
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: _convertUnits,
        style: ElevatedButton.styleFrom(
          backgroundColor: VaccumUnitConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: const Text(
          'CALCULATE',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildResultDisplay() {
    final resultText = VaccumUnitConverter.formatResult(_result!);

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: VaccumUnitConstants.primaryColor.withAlpha((0.8 * 255).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: VaccumUnitConstants.primaryColor.withAlpha(
            (0.3 * 255).round(),
          ),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conversion Result',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: VaccumUnitConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: resultText,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: VaccumUnitConstants.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ' $_toUnit',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: VaccumUnitConstants.primaryColor.withAlpha(
                        (0.8 * 255).round(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
