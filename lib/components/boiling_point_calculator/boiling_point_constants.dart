class BoilingPointConstants {
  // Scientific Constants
  static const double gasConstant = 8.314; // J/mol·K
  static const double absoluteZeroCelsius = -273.15;

  // Default Pressure
  static const double standardPressure = 760.0; // mmHg

  // UI Constants
  static const double cardBorderRadius = 16.0;
  static const double inputFieldBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double elementSpacing = 16.0;
  static const double buttonHeight = 44.0;

  // Validation Limits
  static const double minPressure = 0.001; // mmHg
  static const double maxPressure = 10000.0; // mmHg
  static const double minTemperature = -200.0; // °C
  static const double maxTemperature = 500.0; // °C

  // Calculation Precision
  static const int temperaturePrecision = 1;
  static const int pressurePrecision = 1;
  static const int enthalpyPrecision = 2;

  // Error Messages
  static const String substanceNotFound = 'Substance not found in database';
  static const String invalidPressureRatio = 'Pressure ratio must be positive';
  static const String infiniteTemperature =
      'Calculation error: resulting temperature would be infinite';
  static const String positivePressureRequired = 'Pressure must be positive';
  static const String aboveAbsoluteZero =
      'Temperature must be above absolute zero';
}
