import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mechanicalengineering/components/boiling_point_calculator/boiling_point_constants.dart';

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
      enthalpyVaporization: 40.66, // kJ/mol
    ),
    'Ethanol': Substance(
      name: 'Ethanol',
      normalBoilingPoint: 78.37,
      enthalpyVaporization: 38.56,
    ),
    'Methanol': Substance(
      name: 'Methanol',
      normalBoilingPoint: 64.7,
      enthalpyVaporization: 35.21,
    ),
    'Acetone': Substance(
      name: 'Acetone',
      normalBoilingPoint: 56.0,
      enthalpyVaporization: 29.1,
    ),
    'Benzene': Substance(
      name: 'Benzene',
      normalBoilingPoint: 80.1,
      enthalpyVaporization: 30.72,
    ),
  };

  // User-defined custom substances (read/write from SharedPreferences)
  Map<String, Substance> _userSubstances = {};

  static const String _userSubstancesKey = 'customSubstances';

  // Initialization method to load data
  Future<void> initialize() async {
    await _loadUserSubstances();
    // Notify listeners after loading data
    notifyListeners();
  }

  // Load custom substances from local storage
  Future<void> _loadUserSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userSubstancesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _userSubstances = {
        for (var map in jsonList.map((j) => Substance.fromMap(j)))
          map.name: map,
      };
    }
  }

  // Save custom substances to local storage
  Future<void> _saveUserSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _userSubstances.values.map((sub) => sub.toMap()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_userSubstancesKey, jsonString);
    notifyListeners();
  }

  // Get all available substances (common + custom)
  List<String> getAvailableSubstances() {
    final allNames = [..._commonSubstances.keys, ..._userSubstances.keys];
    return allNames.toList();
  }

  // ✅ FIX: Added method to get only custom substance names
  List<String> getCustomSubstanceNames() {
    return _userSubstances.keys.toList();
  }

  // Get only common substances
  List<String> getCommonSubstances() {
    return _commonSubstances.keys.toList();
  }

  // Get a substance by name
  Substance? getSubstance(String name) {
    if (_commonSubstances.containsKey(name)) {
      return _commonSubstances[name];
    }
    if (_userSubstances.containsKey(name)) {
      return _userSubstances[name];
    }
    return null;
  }

  // Check if a substance is custom
  bool isCustomSubstance(String name) {
    return _userSubstances.containsKey(name);
  }

  // Check if a substance name already exists (common or custom)
  bool containsSubstance(String name) {
    return _commonSubstances.containsKey(name) ||
        _userSubstances.containsKey(name);
  }

  bool substanceNameExists(String name) {
    // Case-insensitive check
    final lowerName = name.toLowerCase();

    // Check common substances
    if (_commonSubstances.keys.any((key) => key.toLowerCase() == lowerName)) {
      return true;
    }

    // Check custom substances
    if (_userSubstances.keys.any((key) => key.toLowerCase() == lowerName)) {
      return true;
    }

    return false;
  }

  // Add a new custom substance
  Future<void> addUserSubstance(Substance substance) async {
    if (containsSubstance(substance.name)) {
      throw Exception('Substance "${substance.name}" already exists.');
    }
    _userSubstances[substance.name] = substance.copyWith(isCustom: true);
    await _saveUserSubstances();
  }

  // Update an existing custom substance
  Future<void> updateUserSubstance(
    String oldName,
    Substance newSubstance,
  ) async {
    if (!_userSubstances.containsKey(oldName)) {
      throw Exception(
        'Cannot update: Substance "$oldName" not found in custom list.',
      );
    }

    // Check for name change conflict
    if (oldName != newSubstance.name && containsSubstance(newSubstance.name)) {
      throw Exception('Substance name "${newSubstance.name}" already exists.');
    }

    // 1. Remove the old entry
    _userSubstances.remove(oldName);

    // 2. Add the new entry (re-saves it as custom)
    _userSubstances[newSubstance.name] = newSubstance.copyWith(isCustom: true);

    await _saveUserSubstances();
  }

  // Remove a custom substance
  Future<void> removeUserSubstance(String name) async {
    if (_userSubstances.containsKey(name)) {
      _userSubstances.remove(name);
      await _saveUserSubstances();
    }
  }

  // Clear all custom substances
  Future<void> clearCustomSubstances() async {
    _userSubstances.clear();
    await _saveUserSubstances();
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
    return defaults;
  }

  // Get a default substance to select when a custom substance is deleted
  String getDefaultSubstance() {
    return _commonSubstances.keys.first;
  }
}
