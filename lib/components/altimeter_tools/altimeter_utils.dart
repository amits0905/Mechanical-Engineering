// lib/components/altimeter_tools/altimeter_utils.dart

import 'dart:math' as math;
import 'altimeter_constants.dart';

/// Utility class for altimeter calculations and validations
class AltimeterUtils {
  /// Calculates altitude from pressure using barometric formula
  static double calculateAltitudeFromPressure(double pressureHpa) {
    if (pressureHpa <= 0) return 0.0;

    return kAltitudeConstant1 *
        (1.0 - math.pow(pressureHpa / kSeaLevelPressure, kAltitudeConstant2));
  }

  /// Converts elevation to different units
  static double convertElevation(double meters, String targetUnit) {
    switch (targetUnit) {
      case 'ft':
        return meters * kMetersToFeet;
      case 'm':
      default:
        return meters;
    }
  }

  /// Converts pressure to different units
  static double convertPressure(double mbar, String targetUnit) {
    switch (targetUnit) {
      case 'torr':
      case 'mmHg':
        return mbar * kMbarToTorr;
      case 'psi':
        return mbar * kMbarToPsi;
      case 'atm':
        return mbar * kMbarToAtm;
      case 'mbar':
      default:
        return mbar;
    }
  }

  /// Validates if barometer reading is realistic
  static bool isValidPressureReading(double pressure) {
    return pressure > 300.0 &&
        pressure < 1100.0; // Reasonable atmospheric pressure range
  }

  /// Checks if pressure reading is likely from emulator (exactly sea level pressure)
  static bool isEmulatorPressure(double pressure) {
    return (pressure - kSeaLevelPressure).abs() < kEmulatorPressureThreshold;
  }
}
