// lib/components/vacuum_tools/vaccum_unit_converter.dart
// This file contains ONLY the calculation logic - NO UI!

class VaccumUnitConverter {
  // List of all available units
  static const List<String> units = [
    'Torr',
    'mbar',
    'Pa',
    'Pascal',
    'atm',
    'psi',
    'mmHg',
  ];

  // Conversion factors to Pascal
  static final Map<String, double> _toPascal = {
    'Torr': 133.322, // 1 Torr = 133.322 Pa
    'mbar': 100.0, // 1 mbar = 100 Pa
    'Pa': 1.0,
    'Pascal': 1.0,
    'atm': 101325.0,
    'psi': 6894.76,
    'mmHg': 133.322,
  };

  // The main conversion function
  static double? convert({
    required double input,
    required String fromUnit,
    required String toUnit,
  }) {
    // If same unit, return same value
    if (fromUnit == toUnit) {
      return input;
    }

    try {
      // Convert to Pascal first
      double valueInPa = input * _toPascal[fromUnit]!;
      // Convert from Pascal to target unit
      double converted = valueInPa / _toPascal[toUnit]!;
      return converted;
    } catch (e) {
      return null; // Return null if error
    }
  }

  // Format the result for display
  static String formatResult(double result) {
    // Use scientific notation for very large or small numbers
    if (result >= 1000 || (result > 0 && result < 0.001)) {
      return result.toStringAsExponential(4);
    } else {
      return result.toStringAsFixed(6);
    }
  }
}
