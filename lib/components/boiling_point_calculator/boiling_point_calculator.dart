import 'dart:math';
import 'boiling_point_constants.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/substance_data.dart';

class BoilingPointCalculator {
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
    required SubstanceDatabase substanceDatabase,
    required String substance,
    required double initialPressure,
    required double finalPressure,
    required double initialBoilingPoint,
  }) {
    if (!substanceDatabase.containsSubstance(substance)) {
      throw Exception(BoilingPointConstants.substanceNotFound);
    }

    final sub = substanceDatabase.getSubstance(substance)!;
    final double deltaHvap =
        sub.enthalpyVaporization * 1000; // Convert to J/mol
    final double t1 = celsiusToKelvin(initialBoilingPoint);

    // Using Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    // Rearranged to solve for T2: 1/T2 = 1/T1 - (R/ΔHvap) * ln(P2/P1)
    final double pressureRatio = finalPressure / initialPressure;

    if (pressureRatio <= 0) {
      throw Exception(BoilingPointConstants.invalidPressureRatio);
    }

    final double lnPressureRatio = log(pressureRatio);
    final double inverseT2 =
        (1 / t1) -
        (BoilingPointConstants.gasConstant / deltaHvap) * lnPressureRatio;

    if (inverseT2 <= 0) {
      throw Exception(BoilingPointConstants.infiniteTemperature);
    }

    final double t2 = 1 / inverseT2;
    return kelvinToCelsius(t2);
  }

  // Calculate final pressure given temperature change
  static double calculateFinalPressure({
    required SubstanceDatabase substanceDatabase,
    required String substance,
    required double initialPressure,
    required double initialBoilingPoint,
    required double finalBoilingPoint,
  }) {
    if (!substanceDatabase.containsSubstance(substance)) {
      throw Exception(BoilingPointConstants.substanceNotFound);
    }

    final sub = substanceDatabase.getSubstance(substance)!;
    final double deltaHvap =
        sub.enthalpyVaporization * 1000; // Convert to J/mol
    final double t1 = celsiusToKelvin(initialBoilingPoint);
    final double t2 = celsiusToKelvin(finalBoilingPoint);

    // Using Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    final double pressureRatio = exp(
      (deltaHvap / BoilingPointConstants.gasConstant) * (1 / t1 - 1 / t2),
    );
    final double finalPressure = initialPressure * pressureRatio;

    return finalPressure;
  }

  // Get substance data (for backward compatibility)
  static Map<String, double>? getSubstanceData(
    SubstanceDatabase substanceDatabase,
    String substance,
  ) {
    return substanceDatabase.getSubstanceDataMap(substance);
  }

  // List all available substances (for backward compatibility)
  static List<String> getAvailableSubstances(
    SubstanceDatabase substanceDatabase,
  ) {
    return substanceDatabase.getAvailableSubstances();
  }

  // Validate inputs
  static void validateInputs({
    required double initialPressure,
    required double finalPressure,
    required double initialBoilingPoint,
    required double finalBoilingPoint,
  }) {
    if (initialPressure <= 0) {
      throw Exception(BoilingPointConstants.positivePressureRequired);
    }
    if (finalPressure <= 0) {
      throw Exception(BoilingPointConstants.positivePressureRequired);
    }
    if (initialBoilingPoint <= BoilingPointConstants.absoluteZeroCelsius) {
      throw Exception(BoilingPointConstants.aboveAbsoluteZero);
    }
    if (finalBoilingPoint <= BoilingPointConstants.absoluteZeroCelsius) {
      throw Exception(BoilingPointConstants.aboveAbsoluteZero);
    }
  }
}
