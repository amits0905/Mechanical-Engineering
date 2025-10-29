// File: pressure_conversion_service.dart
import 'pressure_unit_constants.dart';

class PressureConversionService {
  /// Converts pressure value from one unit to another
  static double? convertPressure({
    required double input,
    required String fromUnit,
    required String toUnit,
  }) {
    if (fromUnit == toUnit) {
      return input;
    }

    try {
      // Convert to Pascal first, then to target unit
      double valueInPascal =
          input * PressureUnitConstants.conversionToPascal[fromUnit]!;
      double convertedValue =
          valueInPascal / PressureUnitConstants.conversionToPascal[toUnit]!;

      return convertedValue;
    } catch (e) {
      return null;
    }
  }

  /// Validates if the input string is a valid number
  static double? validateAndParseInput(String input) {
    return double.tryParse(input);
  }

  /// Swaps the from and to units
  static Map<String, String> swapUnits(String fromUnit, String toUnit) {
    return {'fromUnit': toUnit, 'toUnit': fromUnit};
  }
}
