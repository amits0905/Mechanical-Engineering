// lib/components/altimeter_tools/altimeter_controller.dart

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'altimeter_constants.dart';
import 'altimeter_utils.dart';

/// Controller for managing altimeter data and business logic
class AltimeterController extends ChangeNotifier {
  // --- Private Fields ---
  double _rawElevationMeters = 0.0;
  double _rawPressureHpa = 0.0;
  double _rawVacuumMbar = 0.0;
  bool _loading = false;
  String? _errorMessage;
  Position? _locationData;
  bool _isBarometerAvailable = false;
  bool _isUsingSimulatedData = false;
  String _elevationUnit = 'm';
  String _vacuumUnit = 'mbar';
  StreamSubscription<BarometerEvent>? _barometerSubscription;

  // --- Public Getters ---
  double get rawElevationMeters => _rawElevationMeters;
  double get rawPressureHpa => _rawPressureHpa;
  double get rawVacuumMbar => _rawVacuumMbar;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  Position? get locationData => _locationData;
  bool get isBarometerAvailable => _isBarometerAvailable;
  bool get isUsingSimulatedData => _isUsingSimulatedData;
  String get elevationUnit => _elevationUnit;
  String get vacuumUnit => _vacuumUnit;

  double get displayedElevation =>
      AltimeterUtils.convertElevation(_rawElevationMeters, _elevationUnit);

  double get displayedVacuum =>
      AltimeterUtils.convertPressure(_rawVacuumMbar, _vacuumUnit);

  double? get latitude => _locationData?.latitude;
  double? get longitude => _locationData?.longitude;

  // --- Public Methods ---

  /// Clears the current error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sets the elevation unit and notifies listeners
  void setElevationUnit(String newUnit) {
    if (kElevationUnits.contains(newUnit)) {
      _elevationUnit = newUnit;
      notifyListeners();
    }
  }

  /// Sets the vacuum unit and notifies listeners
  void setVacuumUnit(String newUnit) {
    if (kVacuumUnits.contains(newUnit)) {
      _vacuumUnit = newUnit;
      notifyListeners();
    }
  }

  /// Main method to fetch location and sensor data
  Future<void> requestLocationAndFetchData() async {
    try {
      _setLoading(true);

      await _fetchLocationData();
      await _fetchBarometerData();

      _errorMessage = null;
    } catch (e) {
      _setError("Error: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  // --- Private Methods ---

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Fetches current location data
  Future<void> _fetchLocationData() async {
    // Check location service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check and request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    // Get current position
    _locationData = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Fetches barometer data with fallback to simulated data
  Future<void> _fetchBarometerData() async {
    try {
      final barometerData = await _getBarometerDataWithTimeout();

      if (barometerData != null &&
          AltimeterUtils.isValidPressureReading(barometerData.pressure)) {
        _processRealBarometerData(barometerData.pressure);
      } else {
        _useSimulatedData();
      }
    } catch (e) {
      debugPrint('Barometer error: $e');
      _useSimulatedData();
    }
  }

  /// Gets barometer data with timeout
  Future<BarometerEvent?> _getBarometerDataWithTimeout() async {
    try {
      final completer = Completer<BarometerEvent>();
      StreamSubscription<BarometerEvent>? subscription;

      subscription = barometerEventStream().listen(
        (event) {
          if (!completer.isCompleted) {
            completer.complete(event);
            subscription?.cancel();
          }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
            subscription?.cancel();
          }
        },
        cancelOnError: true,
      );

      return await completer.future.timeout(
        const Duration(seconds: 2), // Fixed: Use direct Duration
      );
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Processes real barometer data
  void _processRealBarometerData(double pressure) {
    _rawPressureHpa = pressure;

    if (AltimeterUtils.isEmulatorPressure(pressure)) {
      debugPrint('⚠ Emulator detected - using simulated data');
      _useSimulatedData();
      return;
    }

    _isBarometerAvailable = true;
    _isUsingSimulatedData = false;

    _rawElevationMeters = AltimeterUtils.calculateAltitudeFromPressure(
      pressure,
    );
    _rawVacuumMbar = pressure;

    debugPrint(
      '✓ Real Barometer: ${_rawPressureHpa}hPa, Altitude: ${_rawElevationMeters}m',
    );
  }

  /// Uses simulated data when barometer is unavailable
  void _useSimulatedData() {
    _isBarometerAvailable = false;
    _isUsingSimulatedData = true;

    // Use realistic simulated values
    _rawPressureHpa = 1007.0;
    _rawElevationMeters = AltimeterUtils.calculateAltitudeFromPressure(
      _rawPressureHpa,
    );
    _rawVacuumMbar = _rawPressureHpa;

    debugPrint(
      '📊 Using simulated data: ${_rawElevationMeters}m, ${_rawPressureHpa}hPa',
    );
  }

  @override
  void dispose() {
    _barometerSubscription?.cancel();
    super.dispose();
  }
}
