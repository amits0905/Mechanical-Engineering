// File: pressure_unit_page.dart
import 'package:flutter/material.dart';
import 'pressure_unit_page_ui.dart';
import 'pressure_unit_constants.dart';
import 'pressure_conversion_service.dart';

class PressureUnitPage extends StatefulWidget {
  const PressureUnitPage({super.key});

  @override
  State<PressureUnitPage> createState() => _PressureUnitPageState();
}

class _PressureUnitPageState extends State<PressureUnitPage> {
  final TextEditingController _valueController = TextEditingController();
  String? _fromUnit = PressureUnitConstants.pressureUnits.first;
  String? _toUnit = PressureUnitConstants.pressureUnits[1]; // Default to Bar
  double? _result;

  void _convertUnits() {
    final input = PressureConversionService.validateAndParseInput(
      _valueController.text,
    );

    if (input == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(PressureUnitConstants.invalidInputMessage),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = PressureConversionService.convertPressure(
      input: input,
      fromUnit: _fromUnit!,
      toUnit: _toUnit!,
    );

    setState(() => _result = result);
  }

  void _swapUnits() {
    final swapped = PressureConversionService.swapUnits(_fromUnit!, _toUnit!);
    setState(() {
      _fromUnit = swapped['fromUnit'];
      _toUnit = swapped['toUnit'];
    });
  }

  void _setFromUnit(String? value) {
    setState(() => _fromUnit = value);
  }

  void _setToUnit(String? value) {
    setState(() => _toUnit = value);
  }

  @override
  Widget build(BuildContext context) {
    return PressureUnitUI(
      valueController: _valueController,
      fromUnit: _fromUnit,
      toUnit: _toUnit,
      result: _result,
      units: PressureUnitConstants.pressureUnits,
      onFromUnitChanged: _setFromUnit,
      onToUnitChanged: _setToUnit,
      onConvertPressed: _convertUnits,
      onSwapUnitsPressed: _swapUnits,
    );
  }
}
