import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
    this.standardPressure = 760.0,
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
  static Substance fromMap(Map<String, dynamic> map) {
    return Substance(
      name: map['name'],
      normalBoilingPoint: map['normalBoilingPoint'] is int
          ? (map['normalBoilingPoint'] as int).toDouble()
          : map['normalBoilingPoint'],
      enthalpyVaporization: map['enthalpyVaporization'] is int
          ? (map['enthalpyVaporization'] as int).toDouble()
          : map['enthalpyVaporization'],
      standardPressure: map['standardPressure'] is int
          ? (map['standardPressure'] as int).toDouble()
          : (map['standardPressure'] ?? 760.0),
      isCustom: map['isCustom'] ?? false,
      customId: map['customId'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Substance &&
        other.name == name &&
        other.normalBoilingPoint == normalBoilingPoint &&
        other.enthalpyVaporization == enthalpyVaporization &&
        other.standardPressure == standardPressure &&
        other.isCustom == isCustom;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      normalBoilingPoint,
      enthalpyVaporization,
      standardPressure,
      isCustom,
    );
  }
}

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
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? substancesJson = prefs.getString(_userSubstancesKey);

      if (substancesJson != null && substancesJson.isNotEmpty) {
        final List<dynamic> substancesList =
            (json.decode(substancesJson) as List<dynamic>);

        _userSubstances.clear();
        for (final substanceMap in substancesList) {
          final substance = Substance.fromMap(
            Map<String, dynamic>.from(substanceMap),
          );
          _userSubstances[substance.name] = substance;
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user substances: $e');
    }
  }

  // Save user substances to SharedPreferences
  Future<void> _saveUserSubstances() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> substancesList = _userSubstances.values
          .map((substance) => substance.toMap())
          .toList();

      final String substancesJson = json.encode(substancesList);
      await prefs.setString(_userSubstancesKey, substancesJson);
    } catch (e) {
      print('Error saving user substances: $e');
    }
  }

  // Get all available substances (common + custom)
  List<String> getAvailableSubstances() {
    final List<String> allSubstances = [
      ..._commonSubstances.keys,
      ..._userSubstances.keys,
    ];
    allSubstances.sort((a, b) => a.compareTo(b));
    return allSubstances;
  }

  // Get only custom substances
  List<String> getCustomSubstances() {
    final List<String> customSubstances = _userSubstances.keys.toList();
    customSubstances.sort((a, b) => a.compareTo(b));
    return customSubstances;
  }

  // Get only common substances
  List<String> getCommonSubstances() {
    final List<String> commonSubstances = _commonSubstances.keys.toList();
    commonSubstances.sort((a, b) => a.compareTo(b));
    return commonSubstances;
  }

  // Get substance data
  Substance? getSubstance(String name) {
    return _commonSubstances[name] ?? _userSubstances[name];
  }

  // Check if substance exists
  bool containsSubstance(String name) {
    return _commonSubstances.containsKey(name) ||
        _userSubstances.containsKey(name);
  }

  // Check if substance is custom
  bool isCustomSubstance(String name) {
    return _userSubstances.containsKey(name);
  }

  // Add user-defined substance
  Future<void> addUserSubstance(Substance substance) async {
    final customSubstance = substance.copyWith(
      isCustom: true,
      customId: 'custom_${DateTime.now().millisecondsSinceEpoch}',
    );

    _userSubstances[substance.name] = customSubstance;
    await _saveUserSubstances();
    notifyListeners();
  }

  // Update user-defined substance
  Future<void> updateUserSubstance(
    String oldName,
    Substance updatedSubstance,
  ) async {
    if (_userSubstances.containsKey(oldName)) {
      _userSubstances.remove(oldName);
      _userSubstances[updatedSubstance.name] = updatedSubstance.copyWith(
        isCustom: true,
        customId:
            updatedSubstance.customId ??
            'custom_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _saveUserSubstances();
      notifyListeners();
    }
  }

  // Remove user-defined substance
  Future<void> removeUserSubstance(String name) async {
    if (_userSubstances.containsKey(name)) {
      _userSubstances.remove(name);
      await _saveUserSubstances();
      notifyListeners();
    }
  }

  // Check if substance name already exists
  bool substanceNameExists(String name) {
    return _commonSubstances.containsKey(name) ||
        _userSubstances.containsKey(name);
  }

  // Get default substance (for initial selection)
  String getDefaultSubstance() {
    return 'Water';
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

  // Clear all custom substances
  Future<void> clearCustomSubstances() async {
    _userSubstances.clear();
    await _saveUserSubstances();
    notifyListeners();
  }

  // Get substance count
  int get totalSubstanceCount =>
      _commonSubstances.length + _userSubstances.length;
  int get customSubstanceCount => _userSubstances.length;
}
