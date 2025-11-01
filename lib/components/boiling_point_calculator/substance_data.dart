import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'boiling_point_constants.dart'; // Import constants for default values

// 1. Substance Model Class - RESTORED
class Substance {
  final String name;
  final double normalBoilingPoint; // °C
  final double enthalpyVaporization; // kJ/mol
  final double standardPressure; // mmHg
  final bool isCustom;
  final String? customId;

  Substance({
    required this.name,
    required this.normalBoilingPoint,
    required this.enthalpyVaporization,
    this.standardPressure = BoilingPointConstants.standardPressure,
    this.isCustom = false,
    this.customId,
  });

  Substance copyWith({
    String? name,
    double? normalBoilingPoint,
    double? enthalpyVaporization,
    double? standardPressure,
    bool? isCustom,
    String? customId,
  }) {
    return Substance(
      name: name ?? this.name,
      normalBoilingPoint: normalBoilingPoint ?? this.normalBoilingPoint,
      enthalpyVaporization: enthalpyVaporization ?? this.enthalpyVaporization,
      standardPressure: standardPressure ?? this.standardPressure,
      isCustom: isCustom ?? this.isCustom,
      customId: customId ?? this.customId,
    );
  }

  // Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'normalBoilingPoint': normalBoilingPoint,
      'enthalpyVaporization': enthalpyVaporization,
      'standardPressure': standardPressure,
      'isCustom': isCustom,
      'customId': customId,
    };
  }

  // Create from map for deserialization
  factory Substance.fromMap(Map<String, dynamic> map) {
    return Substance(
      name: map['name'] as String,
      normalBoilingPoint: (map['normalBoilingPoint'] as num).toDouble(),
      enthalpyVaporization: (map['enthalpyVaporization'] as num).toDouble(),
      standardPressure: (map['standardPressure'] as num).toDouble(),
      isCustom: map['isCustom'] as bool,
      customId: map['customId'] as String?,
    );
  }
}

// 2. Substance Database Class
class SubstanceDatabase with ChangeNotifier {
  // Common substances database (read-only)
  static final Map<String, Substance> _commonSubstances = {
    'Water': Substance(
      name: 'Water',
      normalBoilingPoint: 100.0,
      enthalpyVaporization: 40.65,
    ),
    'Ethanol': Substance(
      name: 'Ethanol',
      normalBoilingPoint: 78.4,
      enthalpyVaporization: 38.56,
    ),
    'Methanol': Substance(
      name: 'Methanol',
      normalBoilingPoint: 64.7,
      enthalpyVaporization: 35.21,
    ),
    'Acetone': Substance(
      name: 'Acetone',
      normalBoilingPoint: 56.1,
      enthalpyVaporization: 29.1,
    ),
    'Benzene': Substance(
      name: 'Benzene',
      normalBoilingPoint: 80.1,
      enthalpyVaporization: 30.72,
    ),
    'Toluene': Substance(
      name: 'Toluene',
      normalBoilingPoint: 110.6,
      enthalpyVaporization: 33.18,
    ),
  };

  // User-defined substances
  final Map<String, Substance> _userSubstances = {};

  // SharedPreferences key
  static const String _userSubstancesKey = 'user_substances';

  // Initialize the database and load user substances
  Future<void> initialize() async {
    await _loadUserSubstances();
  }

  // Load user substances from SharedPreferences
  Future<void> _loadUserSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userSubstancesKey);
    _userSubstances.clear();

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      for (var jsonMap in jsonList) {
        try {
          final substance = Substance.fromMap(jsonMap as Map<String, dynamic>);
          _userSubstances[substance.name] = substance;
        } catch (e) {
          if (kDebugMode) {
            print('Error decoding substance: $e');
          }
        }
      }
    }
  }

  // Save user substances to SharedPreferences
  Future<void> _saveUserSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _userSubstances.values.map((sub) => sub.toMap()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_userSubstancesKey, jsonString);
  }

  // Get all available substances (common + custom)
  List<String> getAvailableSubstances() {
    final allNames = [..._commonSubstances.keys, ..._userSubstances.keys];
    return allNames.toList(); // FIX: Added return statement
  }

  // Get only custom substances
  List<String> getCustomSubstances() {
    return _userSubstances.keys.toList(); // FIX: Added return statement
  }

  // Get only common substances
  List<String> getCommonSubstances() {
    return _commonSubstances.keys.toList(); // FIX: Added return statement
  }

  // Get a substance by name
  Substance? getSubstance(String name) {
    if (_commonSubstances.containsKey(name)) {
      return _commonSubstances[name];
    }
    return _userSubstances[name]; // FIX: Added return statement
  }

  // Check if a substance exists
  bool containsSubstance(String name) {
    return _commonSubstances.containsKey(name) ||
        _userSubstances.containsKey(name); // FIX: Added return statement
  }

  // Check if a substance name exists in the database
  bool substanceNameExists(String name) {
    return containsSubstance(name); // FIX: Added return statement
  }

  // Check if a substance is custom
  bool isCustomSubstance(String name) {
    return _userSubstances.containsKey(name); // FIX: Added return statement
  }

  // Get the default substance
  String getDefaultSubstance() {
    return 'Water'; // FIX: Added return statement
  }

  // Add a user-defined substance
  Future<void> addUserSubstance(Substance substance) async {
    // ... (implementation remains the same)
    final customSubstance = substance.copyWith(
      isCustom: true,
      customId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _userSubstances[customSubstance.name] = customSubstance;
    await _saveUserSubstances();
    notifyListeners();
  }

  // Update a user-defined substance
  Future<void> updateUserSubstance(
    String oldName,
    Substance updatedSubstance,
  ) async {
    // ... (implementation remains the same)
    if (_userSubstances.containsKey(oldName)) {
      final customId = _userSubstances[oldName]!.customId;

      // Remove the old entry if the name changed
      if (oldName != updatedSubstance.name) {
        _userSubstances.remove(oldName);
      }

      final newSubstance = updatedSubstance.copyWith(
        isCustom: true,
        customId: customId,
      );
      _userSubstances[newSubstance.name] = newSubstance;
      await _saveUserSubstances();
      notifyListeners();
    }
  }

  // Remove a user-defined substance
  Future<void> removeUserSubstance(String name) async {
    if (_userSubstances.containsKey(name)) {
      _userSubstances.remove(name);
      await _saveUserSubstances();
      notifyListeners();
    }
  }

  // Clear all custom substances
  Future<void> clearCustomSubstances() async {
    _userSubstances.clear();
    await _saveUserSubstances();
    notifyListeners();
  }

  // Get substance data in map format (for backward compatibility)
  Map<String, double>? getSubstanceDataMap(String substance) {
    final sub = getSubstance(substance);
    if (sub == null) return null;

    return {
      'normalBoilingPoint': sub.normalBoilingPoint,
      'enthalpyVaporization': sub.enthalpyVaporization,
      'standardPressure': sub.standardPressure,
    };
  }

  // Get substance defaults for UI (for backward compatibility)
  Map<String, Map<String, double>> getSubstanceDefaults() {
    final Map<String, Map<String, double>> defaults = {};

    for (final substance in _commonSubstances.values) {
      defaults[substance.name] = {
        'dhvap': substance.enthalpyVaporization,
        'temp1': substance.normalBoilingPoint,
        'pressure1': substance.standardPressure,
      };
    }

    // Add custom substances
    for (final substance in _userSubstances.values) {
      defaults[substance.name] = {
        'dhvap': substance.enthalpyVaporization,
        'temp1': substance.normalBoilingPoint,
        'pressure1': substance.standardPressure,
      };
    }

    return defaults; // FIX: Added return statement
  }
}
