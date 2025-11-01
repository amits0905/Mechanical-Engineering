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
    ...substanceDatabase.getAvailableSubstances(),
    'Other',
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

  void selectSubstance(String? substance) {
    if (substance != null) {
      if (substance == 'Other') {
        // Show custom substance dialog
        showCustomSubstanceDialog = true;
        editingSubstanceName = null;
        customSubstanceNameController.clear();
        onUpdate?.call();
      } else {
        selectedSubstance = substance;
        loadSubstanceDefaults();
      }
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
    );

    await substanceDatabase.addUserSubstance(newSubstance);
    selectedSubstance = name;
    showCustomSubstanceDialog = false;
    result = 'Custom substance "$name" added successfully';
    onUpdate?.call();
  }

  // Edit existing custom substance
  Future<void> editCustomSubstance() async {
    if (editingSubstanceName == null) return;

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

      result = 'Substance "$substanceName" deleted successfully';
      onUpdate?.call();
    }
  }

  // Start editing a custom substance
  void startEditingSubstance(String substanceName) {
    if (substanceDatabase.isCustomSubstance(substanceName)) {
      final substance = substanceDatabase.getSubstance(substanceName);
      if (substance != null) {
        editingSubstanceName = substanceName;
        customSubstanceNameController.text = substance.name;
        dhvapController.text = substance.enthalpyVaporization.toStringAsFixed(
          BoilingPointConstants.enthalpyPrecision,
        );
        temp1Controller.text = substance.normalBoilingPoint.toStringAsFixed(
          BoilingPointConstants.temperaturePrecision,
        );
        pressure1Controller.text = substance.standardPressure.toStringAsFixed(
          BoilingPointConstants.pressurePrecision,
        );
        showCustomSubstanceDialog = true;
        onUpdate?.call();
      }
    }
  }

  // Cancel custom substance dialog
  void cancelCustomSubstanceDialog() {
    showCustomSubstanceDialog = false;
    editingSubstanceName = null;
    customSubstanceNameController.clear();
    onUpdate?.call();
  }

  // Get only custom substances for management
  List<String> get customSubstances => substanceDatabase.getCustomSubstances();

  // Check if current selected substance is custom
  bool get isCurrentSubstanceCustom =>
      substanceDatabase.isCustomSubstance(selectedSubstance);

  // Calculate boiling point or pressure based on mode
  void calculateBoilingPoint() {
    try {
      final dhvap = double.tryParse(dhvapController.text);
      final p1 = double.tryParse(pressure1Controller.text);
      final t1 = double.tryParse(temp1Controller.text);
      final p2 = double.tryParse(pressure2Controller.text);
      final t2 = double.tryParse(temp2Controller.text);

      // Validate inputs
      if (dhvap == null || p1 == null || t1 == null) {
        result = 'Error: Please fill all required fields';
        onUpdate?.call();
        return;
      }

      if (calculationMode == 't2') {
        if (p2 == null) {
          result = 'Error: Please enter final pressure P₂';
          onUpdate?.call();
          return;
        }
        // Calculate T2 using Clausius-Clapeyron equation
        final t2Kelvin = calculateT2(dhvap, p1, t1, p2);
        final t2Celsius = t2Kelvin - 273.15;
        result = 'Final Boiling Point: ${t2Celsius.toStringAsFixed(2)}°C';
      } else {
        if (t2 == null) {
          result = 'Error: Please enter final temperature T₂';
          onUpdate?.call();
          return;
        }
        // Calculate P2 using Clausius-Clapeyron equation
        final p2 = calculateP2(dhvap, p1, t1, t2);
        result = 'Final Pressure: ${p2.toStringAsFixed(2)} mmHg';
      }

      onUpdate?.call();
    } catch (e) {
      result = 'Error: Invalid calculation - ${e.toString()}';
      onUpdate?.call();
    }
  }

  double calculateT2(double dhvap, double p1, double t1, double p2) {
    // Convert ΔHvap from kJ/mol to J/mol
    final dhvapJ = dhvap * 1000;
    // Convert T1 from Celsius to Kelvin
    final t1Kelvin = t1 + 273.15;
    // Gas constant R = 8.314 J/mol·K

    // Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    final lnP2P1 = _safeLog(p2 / p1);

    final t2Kelvin = 1 / (1 / t1Kelvin - lnP2P1 / (dhvapJ / 8.314));

    if (t2Kelvin.isNaN || !t2Kelvin.isFinite || t2Kelvin <= 0) {
      throw Exception('Invalid temperature calculation');
    }

    return t2Kelvin;
  }

  double calculateP2(double dhvap, double p1, double t1, double t2) {
    // Convert ΔHvap from kJ/mol to J/mol
    final dhvapJ = dhvap * 1000;
    // Convert temperatures from Celsius to Kelvin
    final t1Kelvin = t1 + 273.15;
    final t2Kelvin = t2 + 273.15;

    // Clausius-Clapeyron equation: ln(P2/P1) = (ΔHvap/R) * (1/T1 - 1/T2)
    final exponent = (dhvapJ / 8.314) * (1 / t1Kelvin - 1 / t2Kelvin);
    final p2 = p1 * _safeExp(exponent);

    if (p2.isNaN || !p2.isFinite || p2 <= 0) {
      throw Exception('Invalid pressure calculation');
    }

    return p2;
  }

  double _safeLog(double x) {
    if (x <= 0) throw Exception('Log of non-positive number');
    if (x == 1) return 0;
    if (x < 1e-10) throw Exception('Number too small for log');
    if (x > 1e10) throw Exception('Number too large for log');

    // Simple approximation for natural log
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

    y -= 1;
    double result = y - (y * y) / 2 + (y * y * y) / 3 - (y * y * y * y) / 4;
    result += n * 0.69314718056; // ln(2)

    return result;
  }

  double _safeExp(double x) {
    if (x > 100) return double.infinity;
    if (x < -100) return 0.0;

    double result = 1.0;
    double term = 1.0;

    for (int i = 1; i < 50; i++) {
      term *= x / i;
      result += term;
      if (term.abs() < 1e-15) break;
    }

    return result;
  }

  @override
  void dispose() {
    substanceDatabase.removeListener(_onSubstanceDatabaseChanged);
    dhvapController.dispose();
    pressure1Controller.dispose();
    temp1Controller.dispose();
    pressure2Controller.dispose();
    temp2Controller.dispose();
    customSubstanceNameController.dispose();
    super.dispose();
  }
}
