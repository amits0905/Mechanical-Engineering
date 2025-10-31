import 'dart:math';

class BoilingPointCalculator {
  // Constants
  static const double gasConstant = 8.314; // J/mol·K

  // Substance database
  static final Map<String, Map<String, double>> substances = {
    'Ethanol': {
      'normalBoilingPoint': 78.4, // °C
      'enthalpyVaporization': 38.56, // kJ/mol
    },
    'Water': {'normalBoilingPoint': 100.0, 'enthalpyVaporization': 40.65},
    'Methanol': {'normalBoilingPoint': 64.7, 'enthalpyVaporization': 35.21},
    'Acetone': {'normalBoilingPoint': 56.1, 'enthalpyVaporization': 29.1},
  };

  // Convert Celsius to Kelvin
  static double celsiusToKelvin(double celsius) {
    return celsius + 273.15;
  }

  // Convert Kelvin to Celsius
  static double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  // Calculate final boiling point given pressure change
  static double calculateFinalBoilingPoint({
    required String substance,
    required double initialPressure,
    required double finalPressure,
    required double initialBoilingPoint,
  }) {
    if (!substances.containsKey(substance)) {
      throw Exception('Substance "$substance" not found in database');
    }

    final double deltaHvap =
        substances[substance]!['enthalpyVaporization']! *
        1000; // Convert to J/mol
    final double t1 = celsiusToKelvin(initialBoilingPoint);

    // Using Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    // Rearranged to solve for T2: 1/T2 = 1/T1 - (R/ΔHvap) * ln(P2/P1)
    final double pressureRatio = finalPressure / initialPressure;

    if (pressureRatio <= 0) {
      throw Exception('Pressure ratio must be positive');
    }

    final double lnPressureRatio = log(pressureRatio);
    final double inverseT2 =
        (1 / t1) - (gasConstant / deltaHvap) * lnPressureRatio;

    if (inverseT2 <= 0) {
      throw Exception(
        'Calculation error: resulting temperature would be infinite',
      );
    }

    final double t2 = 1 / inverseT2;
    return kelvinToCelsius(t2);
  }

  // Calculate final pressure given temperature change
  static double calculateFinalPressure({
    required String substance,
    required double initialPressure,
    required double initialBoilingPoint,
    required double finalBoilingPoint,
  }) {
    if (!substances.containsKey(substance)) {
      throw Exception('Substance "$substance" not found in database');
    }

    final double deltaHvap =
        substances[substance]!['enthalpyVaporization']! *
        1000; // Convert to J/mol
    final double t1 = celsiusToKelvin(initialBoilingPoint);
    final double t2 = celsiusToKelvin(finalBoilingPoint);

    // Using Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    final double pressureRatio = exp(
      (deltaHvap / gasConstant) * (1 / t1 - 1 / t2),
    );
    final double finalPressure = initialPressure * pressureRatio;

    return finalPressure;
  }

  // Get substance data
  static Map<String, double>? getSubstanceData(String substance) {
    return substances[substance];
  }

  // List all available substances
  static List<String> getAvailableSubstances() {
    return substances.keys.toList();
  }

  // Validate inputs
  static void validateInputs({
    required double initialPressure,
    required double finalPressure,
    required double initialBoilingPoint,
    required double finalBoilingPoint,
  }) {
    if (initialPressure <= 0) {
      throw Exception('Initial pressure must be positive');
    }
    if (finalPressure <= 0) {
      throw Exception('Final pressure must be positive');
    }
    if (initialBoilingPoint <= -273.15) {
      throw Exception('Initial boiling point must be above absolute zero');
    }
    if (finalBoilingPoint <= -273.15) {
      throw Exception('Final boiling point must be above absolute zero');
    }
  }
}
