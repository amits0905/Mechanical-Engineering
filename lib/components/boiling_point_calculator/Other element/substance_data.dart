// substance_data.dart
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'default_substances.dart'; // <-- NEW IMPORT

/// The data model for a single substance.
class Substance {
  final String name;
  final double normalBoilingPoint; // T1 in °C
  final double enthalpyVaporization; // ΔHvap in kJ/mol
  final double standardPressure; // P1 in mmHg
  final bool isCustom;

  const Substance({
    required this.name,
    required this.normalBoilingPoint,
    required this.enthalpyVaporization,
    required this.standardPressure,
    this.isCustom = false,
  });

  // Factory constructor for creating an instance from a map (used for storage)
  factory Substance.fromJson(Map<String, dynamic> json) {
    return Substance(
      name: json['name'] as String,
      normalBoilingPoint: json['normalBoilingPoint'] as double,
      enthalpyVaporization: json['enthalpyVaporization'] as double,
      standardPressure: json['standardPressure'] as double,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  // Convert the instance to a map (used for storage)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'normalBoilingPoint': normalBoilingPoint,
      'enthalpyVaporization': enthalpyVaporization,
      'standardPressure': standardPressure,
      'isCustom': isCustom,
    };
  }
}

// Helper extension to add copyWith to the Substance class (best practice)
extension SubstanceCopyWith on Substance {
  Substance copyWith({
    String? name,
    double? normalBoilingPoint,
    double? enthalpyVaporization,
    double? standardPressure,
    bool? isCustom,
  }) {
    return Substance(
      name: name ?? this.name,
      normalBoilingPoint: normalBoilingPoint ?? this.normalBoilingPoint,
      enthalpyVaporization: enthalpyVaporization ?? this.enthalpyVaporization,
      standardPressure: standardPressure ?? this.standardPressure,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

/// Manages the list of known and user-defined substances.
class SubstanceDatabase with ChangeNotifier {
  static const String _customSubstancesKey = 'customSubstances';

  // Fixed, non-editable database of common substances
  static final Map<String, Substance> _fixedSubstances =
      defaultFixedSubstances; // <-- REFERENCE THE NEW FILE

  // User-defined custom substances
  final Map<String, Substance> _customSubstances = {};

  // --- Initialization and Persistence ---

  Future<void> initialize() async {
    await _loadCustomSubstances();
  }

  // Load custom substances from local storage
  Future<void> _loadCustomSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final customSubstancesString = prefs.getString(_customSubstancesKey);
    _customSubstances.clear();

    if (customSubstancesString != null) {
      final List<dynamic> jsonList = jsonDecode(customSubstancesString);
      for (var json in jsonList) {
        final substance = Substance.fromJson(json as Map<String, dynamic>);
        _customSubstances[substance.name] = substance;
      }
    }
    notifyListeners();
  }

  // Save custom substances to local storage
  Future<void> _saveCustomSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _customSubstances.values
        .map((substance) => substance.toJson())
        .toList();
    final customSubstancesString = jsonEncode(jsonList);
    await prefs.setString(_customSubstancesKey, customSubstancesString);
  }

  // --- Public Getters ---

  /// Returns a combined list of all substance names (fixed + custom).
  UnmodifiableListView<String> getAvailableSubstances() {
    return UnmodifiableListView([
      ..._fixedSubstances.keys,
      ..._customSubstances.keys,
    ]);
  }

  /// Returns the default substance name for initial loading.
  String getDefaultSubstance() {
    return 'Water';
  }

  /// Returns the Substance object for a given name.
  Substance? getSubstance(String name) {
    if (_fixedSubstances.containsKey(name)) {
      return _fixedSubstances[name];
    }
    return _customSubstances[name];
  }

  /// Returns the data in a simplified map format for UI controllers.
  Map<String, double>? getSubstanceDataMap(String name) {
    final substance = getSubstance(name);
    if (substance != null) {
      return {
        'dhvap': substance.enthalpyVaporization,
        'temp1': substance.normalBoilingPoint,
        'pressure1': substance.standardPressure,
      };
    }
    return null;
  }

  /// Returns a map of all substances in the map format.
  Map<String, Map<String, double>> getSubstanceDefaults() {
    final Map<String, Map<String, double>> defaults = {};
    for (final name in getAvailableSubstances()) {
      final data = getSubstanceDataMap(name);
      if (data != null) {
        defaults[name] = data;
      }
    }
    return defaults;
  }

  /// Checks if the substance name exists in either fixed or custom lists.
  bool containsSubstance(String name) {
    return _fixedSubstances.containsKey(name) ||
        _customSubstances.containsKey(name);
  }

  /// Checks if a substance is custom (and therefore editable/deletable).
  bool isCustomSubstance(String name) {
    return _customSubstances.containsKey(name);
  }

  /// Checks if a substance name is already taken.
  bool substanceNameExists(String name) {
    return containsSubstance(name);
  }

  // --- Custom Substance Management ---

  /// Adds a new user-defined substance.
  Future<void> addUserSubstance(Substance substance) async {
    if (_fixedSubstances.containsKey(substance.name)) {
      throw Exception('Cannot overwrite fixed substance: ${substance.name}');
    }
    _customSubstances[substance.name] = substance.copyWith(isCustom: true);
    await _saveCustomSubstances();
    notifyListeners();
  }

  /// Updates an existing user-defined substance.
  Future<void> updateUserSubstance(
    String oldName,
    Substance newSubstance,
  ) async {
    if (oldName != newSubstance.name) {
      _customSubstances.remove(oldName);
    }
    _customSubstances[newSubstance.name] = newSubstance.copyWith(
      isCustom: true,
    );
    await _saveCustomSubstances();
    notifyListeners();
  }

  /// Removes a user-defined substance.
  Future<void> removeUserSubstance(String name) async {
    if (_customSubstances.remove(name) != null) {
      await _saveCustomSubstances();
      notifyListeners();
    }
  }
}
