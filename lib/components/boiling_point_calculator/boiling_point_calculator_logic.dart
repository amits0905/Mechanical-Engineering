import 'package:flutter/material.dart';

class BoilingPointController with ChangeNotifier {
  // Controllers
  final TextEditingController dhvapController = TextEditingController();
  final TextEditingController pressure1Controller = TextEditingController();
  final TextEditingController temp1Controller = TextEditingController();
  final TextEditingController pressure2Controller = TextEditingController();
  final TextEditingController temp2Controller = TextEditingController();
  final TextEditingController otherSubstanceController =
      TextEditingController();

  // State
  String selectedSubstance = 'Water';
  String calculationMode = 't2'; // 't2' or 'p2'
  String result = '';
  final List<String> substances = [
    'Water',
    'Ethanol',
    'Methanol',
    'Acetone',
    'Benzene',
    'Toluene',
    'Other',
  ];

  // Default values for common substances (ΔHvap in kJ/mol, T1 in °C, P1 in Torr)
  final Map<String, Map<String, double>> substanceDefaults = {
    'Water': {'dhvap': 40.70, 'temp1': 100.0, 'pressure1': 760.0},
    'Ethanol': {'dhvap': 38.56, 'temp1': 78.37, 'pressure1': 760.0},
    'Methanol': {'dhvap': 35.21, 'temp1': 64.7, 'pressure1': 760.0},
    'Acetone': {'dhvap': 29.1, 'temp1': 56.1, 'pressure1': 760.0},
    'Benzene': {'dhvap': 30.72, 'temp1': 80.1, 'pressure1': 760.0},
    'Toluene': {'dhvap': 33.18, 'temp1': 110.6, 'pressure1': 760.0},
  };

  VoidCallback? onUpdate;

  BoilingPointController({this.onUpdate});

  void loadDefaultValues() {
    loadSubstanceDefaults();
  }

  void loadSubstanceDefaults() {
    if (substanceDefaults.containsKey(selectedSubstance)) {
      final defaults = substanceDefaults[selectedSubstance]!;
      dhvapController.text = defaults['dhvap']!.toStringAsFixed(2);
      temp1Controller.text = defaults['temp1']!.toStringAsFixed(1);
      pressure1Controller.text = defaults['pressure1']!.toStringAsFixed(0);

      // Clear result when substance changes
      result = '';
      onUpdate?.call();
    }
  }

  void selectSubstance(String? substance) {
    if (substance != null) {
      selectedSubstance = substance;
      onUpdate?.call();
    }
  }

  void saveNewSubstance(String name) {
    if (!substances.contains(name) && name.isNotEmpty) {
      substances.insert(substances.length - 1, name);
      selectedSubstance = name;
      onUpdate?.call();
    }
  }

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
        result = t2Celsius.toStringAsFixed(
          2,
        ); // ✅ Fixed: removed unnecessary string interpolation
      } else {
        if (t2 == null) {
          result = 'Error: Please enter final temperature T₂';
          onUpdate?.call();
          return;
        }
        // Calculate P2 using Clausius-Clapeyron equation
        final p2 = calculateP2(dhvap, p1, t1, t2);
        result = p2.toStringAsFixed(
          2,
        ); // ✅ Fixed: removed unnecessary string interpolation
      }

      onUpdate?.call();
    } catch (e) {
      result = 'Error: Invalid calculation';
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

  void loadSavedSubstances() {
    // Implementation for loading saved substances from storage
  }

  @override // ✅ Fixed: Added @override annotation
  void dispose() {
    dhvapController.dispose();
    pressure1Controller.dispose();
    temp1Controller.dispose();
    pressure2Controller.dispose();
    temp2Controller.dispose();
    otherSubstanceController.dispose();
    super.dispose(); // ✅ Fixed: Added super.dispose()
  }
}
