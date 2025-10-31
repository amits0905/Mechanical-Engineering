import 'package:flutter/material.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart'; // Import custom widgets
import 'pressure_unit_constants.dart';

class PressureUnitUI extends StatelessWidget {
  const PressureUnitUI({
    super.key,
    required this.valueController,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    required this.units,
    required this.onFromUnitChanged,
    required this.onToUnitChanged,
    required this.onConvertPressed,
    this.onSwapUnitsPressed,
  });

  final TextEditingController valueController;
  final String? fromUnit;
  final String? toUnit;
  final double? result;
  final List<String> units;
  final ValueChanged<String?> onFromUnitChanged;
  final ValueChanged<String?> onToUnitChanged;
  final VoidCallback onConvertPressed;
  final VoidCallback? onSwapUnitsPressed;

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PressureUnitConstants.primaryColor.withAlpha(
              (0.1 * 255).round(),
            ),
            borderRadius: BorderRadius.circular(
              PressureUnitConstants.mediumBorderRadius,
            ),
          ),
          child: Icon(
            Icons.speed_rounded,
            color: PressureUnitConstants.primaryColor,
            size: PressureUnitConstants.headerIconSize,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          PressureUnitConstants.pageTitle,
          style: TextStyle(
            fontSize: PressureUnitConstants.extraLargeTextSize,
            fontWeight: FontWeight.w800,
            color: PressureUnitConstants.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: PressureUnitConstants.smallTextSize,
        color: PressureUnitConstants.textColor,
      ),
    );
  }

  Widget _buildInputField() {
    return ConversionTextField(
      controller: valueController,
      hintText: '0.0',
      primaryColor: PressureUnitConstants.primaryColor,
      backgroundColor: PressureUnitConstants.backgroundColor,
      fontSize: PressureUnitConstants.inputTextSize,
    );
  }

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
          const SizedBox(height: PressureUnitConstants.elementSpacing),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: units.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(
                  unit,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: PressureUnitConstants.dropdownDecoration,
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
          fromUnit,
          PressureUnitConstants.fromUnitLabel,
          onFromUnitChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
          child: InkWell(
            onTap: onSwapUnitsPressed,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PressureUnitConstants.accentColor,
                shape: BoxShape.circle,
                boxShadow: PressureUnitConstants.accentShadow,
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: PressureUnitConstants.swapIconSize,
              ),
            ),
          ),
        ),
        _buildDropdown(
          toUnit,
          PressureUnitConstants.toUnitLabel,
          onToUnitChanged,
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return CustomButton(
      text: PressureUnitConstants.convertButtonText,
      onPressed: onConvertPressed,
      backgroundColor: PressureUnitConstants.primaryColor,
      textColor: Colors.white,
      borderRadius: PressureUnitConstants.mediumBorderRadius,
      height: 56,
      fontSize: PressureUnitConstants.largeTextSize,
      uppercase: true,
    );
  }

  Widget _buildResultDisplay() {
    if (result == null) return const SizedBox.shrink();

    final resultText = _formatResult(result!);

    return Container(
      padding: EdgeInsets.all(PressureUnitConstants.largeBorderRadius),
      decoration: BoxDecoration(
        color: PressureUnitConstants.primaryColor.withAlpha(
          (0.08 * 255).round(),
        ),
        borderRadius: BorderRadius.circular(
          PressureUnitConstants.largeBorderRadius,
        ),
        border: Border.all(
          color: PressureUnitConstants.primaryColor.withAlpha(
            (0.3 * 255).round(),
          ),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PressureUnitConstants.resultTitle,
            style: TextStyle(
              fontSize: PressureUnitConstants.mediumTextSize,
              fontWeight: FontWeight.w700,
              color: PressureUnitConstants.textColor,
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
                    style: TextStyle(
                      fontSize: PressureUnitConstants.resultValueTextSize,
                      fontWeight: FontWeight.w900,
                      color: PressureUnitConstants.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ' $toUnit',
                    style: TextStyle(
                      fontSize: PressureUnitConstants.resultUnitTextSize,
                      fontWeight: FontWeight.w600,
                      color: PressureUnitConstants.primaryColor.withAlpha(
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

  String _formatResult(double value) {
    if (value == 0) return '0';
    if (value.abs() < 0.000001) return value.toStringAsExponential(6);
    if (value.abs() < 0.1) return value.toStringAsPrecision(6);

    String result = value.toStringAsFixed(6);
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0*$'), '');
      result = result.replaceAll(RegExp(r'\.$'), '');
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PressureUnitConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          PressureUnitConstants.appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: PressureUnitConstants.defaultPadding,
          vertical: PressureUnitConstants.defaultPadding,
        ),
        child: Card(
          elevation: 10,
          shadowColor: PressureUnitConstants.primaryColor.withAlpha(
            (0.15 * 255).round(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              PressureUnitConstants.extraLargeBorderRadius,
            ),
          ),
          color: PressureUnitConstants.cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: PressureUnitConstants.cardPaddingVertical,
              horizontal: PressureUnitConstants.cardPaddingHorizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                _buildLabel(PressureUnitConstants.valueLabel),
                const SizedBox(height: PressureUnitConstants.elementSpacing),
                _buildInputField(),
                const SizedBox(height: PressureUnitConstants.sectionSpacing),
                _buildUnitSelectionRow(),
                const SizedBox(
                  height: PressureUnitConstants.largeSectionSpacing,
                ),
                _buildConvertButton(),
                const SizedBox(height: 30),
                if (result != null) _buildResultDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
