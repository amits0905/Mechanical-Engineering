// lib/components/altimeter_tools/altimeter_constants.dart

/// Constants for elevation units
const List<String> kElevationUnits = [
  'm', // Meters
  'ft', // Feet
];

/// Constants for vacuum/pressure units
const List<String> kVacuumUnits = [
  'mbar', // Millibar
  'torr', // Torr
  'mmHg', // Millimeters of Mercury
];

/// Sensor constants
const double kSeaLevelPressure = 1013.25; // hPa
const double kBarometerTimeoutSeconds = 2;
const double kEmulatorPressureThreshold = 0.1;

/// Calculation constants
const double kMetersToFeet = 3.28084;
const double kMbarToTorr = 0.750062;
const double kMbarToPsi = 0.0145038;
const double kMbarToAtm = 1 / 1013.25;

/// Altitude calculation constants
const double kAltitudeConstant1 = 44330.0;
const double kAltitudeConstant2 = 0.1903;
