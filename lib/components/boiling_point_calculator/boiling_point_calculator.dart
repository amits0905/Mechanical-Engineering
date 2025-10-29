import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math; // Import for logarithmic and exponential functions

class BoilingPointCalculatorPage extends StatefulWidget {
  const BoilingPointCalculatorPage({super.key});

  @override
  State<BoilingPointCalculatorPage> createState() =>
      _BoilingPointCalculatorPageState();
}

class _BoilingPointCalculatorPageState
    extends State<BoilingPointCalculatorPage> {
  // SET DEFAULT VALUE: 'Water' is now selected upon initialization.
  String? selectedSubstance = 'Water';

  List<String> substances = [
    'Water',
    'Ethanol',
    'Acetone',
    'Benzene',
    'Methanol',
    'Other',
  ];

  // --- Calculation Constants and State ---
  String result = '';
  static const double R = 8.314; // Universal Gas Constant in J/(mol·K)
  static const double cToK = 273.15; // Celsius to Kelvin offset

  final TextEditingController otherSubstanceController =
      TextEditingController();
  final TextEditingController dhvapController = TextEditingController();
  final TextEditingController pressure1Controller = TextEditingController();
  final TextEditingController temp1Controller = TextEditingController();
  final TextEditingController pressure2Controller = TextEditingController();
  final TextEditingController temp2Controller = TextEditingController();

  final List<TextInputFormatter> decimalInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedSubstances();
  }

  Future<void> _loadSavedSubstances() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('custom_substances') ?? [];
    setState(() {
      substances = [
        'Water',
        'Ethanol',
        'Acetone',
        'Benzene',
        'Methanol',
        ...saved,
        'Other',
      ];
    });
  }

  Future<void> _saveNewSubstance(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('custom_substances') ?? [];
    if (!saved.contains(name)) {
      saved.add(name);
      await prefs.setStringList('custom_substances', saved);
    }
    await _loadSavedSubstances();
    setState(() {
      selectedSubstance = name;
    });
  }

  @override
  void dispose() {
    dhvapController.dispose();
    pressure1Controller.dispose();
    temp1Controller.dispose();
    pressure2Controller.dispose();
    temp2Controller.dispose();
    otherSubstanceController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: decimalInputFormatter,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  // --- CORE CALCULATION LOGIC ---
  void _calculateBoilingPoint() {
    // Convert inputs to double, using null to indicate missing input
    double? dhvap = double.tryParse(dhvapController.text); // kJ/mol
    double? p1 = double.tryParse(pressure1Controller.text); // Torr
    double? t1 = double.tryParse(temp1Controller.text); // °C
    double? p2 = double.tryParse(pressure2Controller.text); // Torr
    double? t2 = double.tryParse(temp2Controller.text); // °C

    // Convert T to Kelvin (K) for calculation
    double? t1K = t1 != null ? t1 + cToK : null;
    double? t2K = t2 != null ? t2 + cToK : null;

    final nullCount = [dhvap, p1, t1, p2, t2].where((x) => x == null).length;

    if (nullCount != 1) {
      setState(() {
        result = 'Error: Leave exactly ONE field blank to solve.';
      });
      return;
    }

    try {
      if (t2K == null) {
        // Solve for T2 (Final Boiling Point)
        final dhvapJ = dhvap! * 1000;
        final t2Reciprocal =
            (1 / t1K!) + ((R / dhvapJ) * (math.log(p1! / p2!)));
        final t2Calculated =
            (1 / t2Reciprocal) - cToK; // Use a non-nullable local variable
        t2 = t2Calculated; // Update the nullable variable

        temp2Controller.text = t2Calculated.toStringAsFixed(2);
        setState(() {
          result =
              'T₂ = ${t2Calculated.toStringAsFixed(2)} °C (Final Boiling Point)';
        });
      } else if (p2 == null) {
        // Solve for P2 (Final Pressure)
        final dhvapJ = dhvap! * 1000;
        final exponent = -(dhvapJ / R) * ((1 / t2K) - (1 / t1K!));
        final p2Calculated = p1! * math.exp(exponent);
        p2 = p2Calculated;

        pressure2Controller.text = p2Calculated.toStringAsFixed(2);
        setState(() {
          result =
              'P₂ = ${p2Calculated.toStringAsFixed(2)} Torr (Final Pressure)';
        });
      } else if (dhvap == null) {
        // Solve for DHvap (Enthalpy of Vaporization)
        final dhvapJ = -(R * math.log(p2 / p1!)) / ((1 / t2K) - (1 / t1K!));
        final dhvapCalculated = dhvapJ / 1000;
        dhvap = dhvapCalculated;

        dhvapController.text = dhvapCalculated.toStringAsFixed(2);
        setState(() {
          result =
              'ΔHvap = ${dhvapCalculated.toStringAsFixed(2)} kJ/mol (Enthalpy of Vaporization)';
        });
      } else if (p1 == null) {
        // Solve for P1 (Initial Pressure)
        final dhvapJ = dhvap * 1000;
        final exponent = -(dhvapJ / R) * ((1 / t2K) - (1 / t1K!));
        final p1Calculated = p2 / math.exp(exponent);
        p1 = p1Calculated;

        pressure1Controller.text = p1Calculated.toStringAsFixed(2);
        setState(() {
          result =
              'P₁ = ${p1Calculated.toStringAsFixed(2)} Torr (Initial Pressure)';
        });
      } else if (t1K == null) {
        // Solve for T1 (Initial Boiling Point)
        final dhvapJ = dhvap * 1000;
        final t1Reciprocal = (1 / t2K) - ((R / dhvapJ) * (math.log(p2 / p1)));
        final t1Calculated = (1 / t1Reciprocal) - cToK;
        t1 = t1Calculated;

        temp1Controller.text = t1Calculated.toStringAsFixed(2);
        setState(() {
          result =
              'T₁ = ${t1Calculated.toStringAsFixed(2)} °C (Initial Boiling Point)';
        });
      }
    } catch (e) {
      setState(() {
        result =
            'Calculation Error: Check inputs for valid values (e.g., non-zero pressures).';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boiling Point Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Substance',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.science_outlined, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              initialValue: selectedSubstance,
              items: substances.map((String substance) {
                return DropdownMenuItem<String>(
                  value: substance,
                  child: Text(substance),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubstance = value;
                });
              },
            ),

            if (selectedSubstance == 'Other') ...[
              const SizedBox(height: 16),
              TextField(
                controller: otherSubstanceController,
                decoration: const InputDecoration(
                  labelText: 'Enter new substance name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.save_alt),
                      label: const Text("Save & Use"),
                      onPressed: () {
                        if (otherSubstanceController.text.trim().isNotEmpty) {
                          _saveNewSubstance(
                            otherSubstanceController.text.trim(),
                          );
                          otherSubstanceController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text("Use Only"),
                      onPressed: () {
                        setState(() {
                          selectedSubstance = otherSubstanceController.text
                              .trim();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              'Clausius-Clapeyron Equation: Leave one field blank to solve.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildInputField(
              label: 'ΔHvap (kJ/mol)',
              controller: dhvapController,
              icon: Icons.whatshot_outlined,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Initial Pressure P₁ (Torr)',
              controller: pressure1Controller,
              icon: Icons.compress_outlined,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Initial Boiling Point T₁ (°C)',
              controller: temp1Controller,
              icon: Icons.thermostat_outlined,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Final Pressure P₂ (Torr)',
              controller: pressure2Controller,
              icon: Icons.compress_outlined,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Final Boiling Point T₂ (°C)',
              controller: temp2Controller,
              icon: Icons.thermostat_outlined,
            ),
            const SizedBox(height: 32),

            // --- Result Display ---
            Text(
              result,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.science),
                label: const Text('Calculate'),
                onPressed:
                    _calculateBoilingPoint, // Call the calculation function
              ),
            ),
          ],
        ),
      ),
    );
  }
}
