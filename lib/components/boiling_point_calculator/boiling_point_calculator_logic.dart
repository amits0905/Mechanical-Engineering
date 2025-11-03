import 'package:flutter/material.dart';
import 'package:mechanicalengineering/components/boiling_point_calculator/Other element/substance_data.dart';
import 'boiling_point_constants.dart';

class BoilingPointController with ChangeNotifier {
  // Controllers
  final TextEditingController dhvapController = TextEditingController();
  final TextEditingController pressure1Controller = TextEditingController();
  final TextEditingController temp1Controller = TextEditingController();
  final TextEditingController pressure2Controller = TextEditingController();
  final TextEditingController temp2Controller = TextEditingController();
  final TextEditingController customSubstanceNameController =
      TextEditingController();

  // State
  String selectedSubstance = 'Water';
  String calculationMode = 't2'; // 't2' or 'p2'
  String result = '';
  bool showCustomSubstanceDialog = false;
  String? editingSubstanceName; // null when adding, not null when editing

  final SubstanceDatabase substanceDatabase = SubstanceDatabase();

  List<String> get substances => [
    // FIX: Removed 'Other' from this list to prevent dropdown assertion errors
    ...substanceDatabase.getAvailableSubstances(),
  ];

  Map<String, Map<String, double>> get substanceDefaults =>
      substanceDatabase.getSubstanceDefaults();

  VoidCallback? onUpdate;

  BoilingPointController({this.onUpdate}) {
    // Initialize the database and load user substances
    _initializeDatabase();
    // Listen to substance database changes
    substanceDatabase.addListener(_onSubstanceDatabaseChanged);
  }

  Future<void> _initializeDatabase() async {
    await substanceDatabase.initialize();

    // Set initial substance after database is loaded
    selectedSubstance = substanceDatabase.getDefaultSubstance();

    // FIX: If the old value "Other" is loaded from persistence, reset it to a valid substance.
    if (selectedSubstance == 'Other') {
      selectedSubstance = 'Water';
    }

    loadSubstanceDefaults();
    onUpdate?.call();
  }

  void _onSubstanceDatabaseChanged() {
    onUpdate?.call();
  }

  void loadDefaultValues() {
    loadSubstanceDefaults();
  }

  void loadSubstanceDefaults() {
    final defaults = substanceDefaults[selectedSubstance];
    if (defaults != null) {
      dhvapController.text = defaults['dhvap']!.toStringAsFixed(
        BoilingPointConstants.enthalpyPrecision,
      );
      temp1Controller.text = defaults['temp1']!.toStringAsFixed(
        BoilingPointConstants.temperaturePrecision,
      );
      pressure1Controller.text = defaults['pressure1']!.toStringAsFixed(
        BoilingPointConstants.pressurePrecision,
      );

      // Clear result when substance changes
      result = '';
      onUpdate?.call();
    }
  }

  void updateSelectedSubstance(String name) {
    selectedSubstance = name;
    loadSubstanceDefaults();
    // loadSubstanceDefaults calls onUpdate?.call()
  }

  // Prepares the controller state for adding a new custom substance
  void prepareForAdding() {
    editingSubstanceName = null;
    customSubstanceNameController.clear();
    // Clear input fields for the user to enter new data
    dhvapController.clear();
    temp1Controller.clear();
    pressure1Controller.clear();
    onUpdate?.call();
  }

  // Prepares the controller state for editing an existing custom substance
  void prepareForEditing(String substanceName) {
    final substance = substanceDatabase.getSubstance(substanceName);
    if (substance != null) {
      editingSubstanceName = substanceName;
      // Load raw values into controllers
      customSubstanceNameController.text = substance.name;
      dhvapController.text = substance.enthalpyVaporization.toString();
      temp1Controller.text = substance.normalBoilingPoint.toString();
      pressure1Controller.text = substance.standardPressure.toString();
    }
    // Update the selected substance so the main UI displays it upon returning
    selectedSubstance = substanceName;
    onUpdate?.call();
  }

  // FIX: Simplified to remove 'Other' handling, as adding a custom substance is now done via a dedicated button/page.
  void selectSubstance(String? substance) {
    if (substance != null) {
      updateSelectedSubstance(substance);
    }
  }

  // Add new custom substance
  Future<void> addCustomSubstance() async {
    final name = customSubstanceNameController.text.trim();
    final dhvap = double.tryParse(dhvapController.text);
    final temp1 = double.tryParse(temp1Controller.text);
    final pressure1 = double.tryParse(pressure1Controller.text);

    if (name.isEmpty) {
      result = 'Error: Substance name cannot be empty';
      onUpdate?.call();
      return;
    }

    if (dhvap == null || temp1 == null || pressure1 == null) {
      result = 'Error: Please enter valid values for all fields';
      onUpdate?.call();
      return;
    }

    if (substanceDatabase.substanceNameExists(name)) {
      result = 'Error: Substance "$name" already exists';
      onUpdate?.call();
      return;
    }

    final newSubstance = Substance(
      name: name,
      normalBoilingPoint: temp1,
      enthalpyVaporization: dhvap,
      standardPressure: pressure1,
      isCustom: true,
    );

    await substanceDatabase.addUserSubstance(newSubstance);
    selectedSubstance = name;
    showCustomSubstanceDialog = false;
    editingSubstanceName = null;
    result = 'Substance added successfully';
    onUpdate?.call();
  }

  // Edit existing custom substance
  Future<void> editCustomSubstance() async {
    final newName = customSubstanceNameController.text.trim();
    final dhvap = double.tryParse(dhvapController.text);
    final temp1 = double.tryParse(temp1Controller.text);
    final pressure1 = double.tryParse(pressure1Controller.text);

    if (newName.isEmpty) {
      result = 'Error: Substance name cannot be empty';
      onUpdate?.call();
      return;
    }

    if (dhvap == null || temp1 == null || pressure1 == null) {
      result = 'Error: Please enter valid values for all fields';
      onUpdate?.call();
      return;
    }

    if (newName != editingSubstanceName &&
        substanceDatabase.substanceNameExists(newName)) {
      result = 'Error: Substance "$newName" already exists';
      onUpdate?.call();
      return;
    }

    final updatedSubstance = Substance(
      name: newName,
      normalBoilingPoint: temp1,
      enthalpyVaporization: dhvap,
      standardPressure: pressure1,
      isCustom: true,
    );

    await substanceDatabase.updateUserSubstance(
      editingSubstanceName!,
      updatedSubstance,
    );
    selectedSubstance = newName;
    showCustomSubstanceDialog = false;
    editingSubstanceName = null;
    result = 'Substance updated successfully';
    onUpdate?.call();
  }

  // Delete custom substance
  Future<void> deleteCustomSubstance(String substanceName) async {
    if (substanceDatabase.isCustomSubstance(substanceName)) {
      await substanceDatabase.removeUserSubstance(substanceName);
      // If the deleted substance was selected, switch to default
      if (selectedSubstance == substanceName) {
        selectedSubstance = substanceDatabase.getDefaultSubstance();
        loadSubstanceDefaults();
      }
      onUpdate?.call();
    }
  }

  // Cancel custom substance dialog
  void cancelCustomSubstanceDialog() {
    showCustomSubstanceDialog = false;
    editingSubstanceName = null;
    customSubstanceNameController.clear();
    // Reload defaults based on the currently selected substance
    loadSubstanceDefaults();
    onUpdate?.call();
  }

  // Check if current substance is custom
  bool get isCurrentSubstanceCustom {
    return substanceDatabase.isCustomSubstance(selectedSubstance);
  }

  void updateCalculationMode(String mode) {
    calculationMode = mode;
    result = ''; // Clear result on mode change
    onUpdate?.call();
  }

  void calculate(BuildContext context) {
    // Input validation and parsing
    final dhvap = double.tryParse(dhvapController.text);
    final p1 = double.tryParse(pressure1Controller.text);
    final t1 = double.tryParse(temp1Controller.text);

    if (dhvap == null || p1 == null || t1 == null) {
      result = 'Error: Missing substance property value.';
      onUpdate?.call();
      return;
    }

    try {
      if (calculationMode == 't2') {
        final p2 = double.tryParse(pressure2Controller.text);
        if (p2 == null) {
          result = 'Error: Final Pressure (P₂) is required.';
          onUpdate?.call();
          return;
        }
        final t2Kelvin = _calculateT2Kelvin(dhvap, p1, t1, p2);
        final t2Celsius = _kelvinToCelsius(t2Kelvin);

        result =
            'Final Boiling Point: ${t2Celsius.toStringAsFixed(BoilingPointConstants.temperaturePrecision)} °C';
      } else {
        final t2 = double.tryParse(temp2Controller.text);
        if (t2 == null) {
          result = 'Error: Final Boiling Point (T₂) is required.';
          onUpdate?.call();
          return;
        }

        final p2 = _calculateP2(dhvap, p1, t1, t2);
        result =
            'Final Pressure: ${p2.toStringAsFixed(BoilingPointConstants.pressurePrecision)} mmHg';
      }
    } catch (e) {
      result =
          'Error: Invalid calculation - ${e.toString().replaceAll('Exception: ', '')}';
    } finally {
      onUpdate?.call();
    }
  }

  // --- Core Calculation Logic (Kept private) ---

  double _celsiusToKelvin(double celsius) {
    return celsius + 273.15;
  }

  double _kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  // Calculate T2 (Kelvin)
  double _calculateT2Kelvin(
    double dhvap,
    double p1,
    double t1Celsius,
    double p2,
  ) {
    // 1. Convert to J/mol and Kelvin
    final dhvapJ = dhvap * 1000;
    final t1Kelvin = _celsiusToKelvin(t1Celsius);

    // ✅ Wrap throw statements in braces
    if (p1 <= 0 || p2 <= 0) {
      throw Exception(BoilingPointConstants.positivePressureRequired);
    }
    if (t1Kelvin <= 0) {
      throw Exception(BoilingPointConstants.aboveAbsoluteZero);
    }

    // Rearranged Clausius-Clapeyron equation to solve for 1/T2:
    // 1/T2 = 1/T1 - (R / ΔHvap) * ln(P2/P1)
    final term2 =
        (BoilingPointConstants.gasConstant / dhvapJ) * _safeLog(p2 / p1);
    final oneOverT2 = (1 / t1Kelvin) - term2;

    if (oneOverT2 <= 0) {
      throw Exception(BoilingPointConstants.infiniteTemperature);
    }

    final t2Kelvin = 1 / oneOverT2;

    if (t2Kelvin <= 0) {
      throw Exception(BoilingPointConstants.aboveAbsoluteZero);
    }

    return t2Kelvin;
  }

  // Calculate P2
  double _calculateP2(
    double dhvap,
    double p1,
    double t1Celsius,
    double t2Celsius,
  ) {
    // 1. Convert to J/mol and Kelvin
    final dhvapJ = dhvap * 1000;
    final t1Kelvin = _celsiusToKelvin(t1Celsius);
    final t2Kelvin = _celsiusToKelvin(t2Celsius);

    if (p1 <= 0) {
      throw Exception(BoilingPointConstants.positivePressureRequired);
    }
    if (t1Kelvin <= 0 || t2Kelvin <= 0) {
      throw Exception(BoilingPointConstants.aboveAbsoluteZero);
    }

    // Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    final exponent =
        (dhvapJ / BoilingPointConstants.gasConstant) *
        (1 / t1Kelvin - 1 / t2Kelvin);
    final p2 = p1 * _safeExp(exponent);

    if (p2.isNaN || !p2.isFinite || p2 <= 0) {
      throw Exception('Invalid pressure calculation');
    }

    return p2;
  }

  // Custom log/exp approximations (since dart:math is not guaranteed)
  double _safeLog(double x) {
    if (x <= 0) {
      throw Exception('Log of non-positive number');
    }
    if (x == 1) return 0;

    int n = 0;
    double y = x;
    while (y >= 2) {
      y /= 2;
      n++;
    }
    while (y < 1) {
      y *= 2;
      n--;
    }

    y -= 1; // y is now between -1 and 1
    double result = y - (y * y) / 2 + (y * y * y) / 3 - (y * y * y * y) / 4;
    result += n * 0.69314718056; // ln(2)

    if (result.isNaN || !result.isFinite) {
      throw Exception('Log calculation failed');
    }
    return result;
  }

  double _safeExp(double x) {
    if (x > 700) {
      throw Exception('Exponent too large');
    }
    if (x < -700) return 0;

    double sum = 1.0;
    double term = 1.0;
    for (int n = 1; n < 20; n++) {
      term *= x / n;
      sum += term;
    }

    if (sum.isNaN || !sum.isFinite) {
      throw Exception('Exp calculation failed');
    }
    return sum;
  }
}
