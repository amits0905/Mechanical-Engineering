import 'package:flutter/material.dart';
import 'boiling_point_calculator.dart';
import 'package:mechanicalengineering/theme/card_colors.dart';

class BoilingPointCalculatorUI extends StatefulWidget {
  const BoilingPointCalculatorUI({super.key});

  @override
  State<BoilingPointCalculatorUI> createState() =>
      _BoilingPointCalculatorUIState();
}

class _BoilingPointCalculatorUIState extends State<BoilingPointCalculatorUI> {
  String selectedSubstance = 'Ethanol';
  double initialPressure = 760.0;
  double finalPressure = 400.0;
  double initialBoilingPoint = 78.4;
  double finalBoilingPoint = 50.0;

  double? calculatedBoilingPoint;
  double? calculatedPressure;
  String? errorMessage;
  bool calculateTemperature = true;

  void calculate() {
    setState(() {
      try {
        if (calculateTemperature) {
          calculatedBoilingPoint =
              BoilingPointCalculator.calculateFinalBoilingPoint(
                substance: selectedSubstance,
                initialPressure: initialPressure,
                finalPressure: finalPressure,
                initialBoilingPoint: initialBoilingPoint,
              );
          calculatedPressure = null;
        } else {
          calculatedPressure = BoilingPointCalculator.calculateFinalPressure(
            substance: selectedSubstance,
            initialPressure: initialPressure,
            initialBoilingPoint: initialBoilingPoint,
            finalBoilingPoint: finalBoilingPoint,
          );
          calculatedBoilingPoint = null;
        }
        errorMessage = null;
      } catch (e) {
        calculatedBoilingPoint = null;
        calculatedPressure = null;
        errorMessage = e.toString();
      }
    });
  }

  void updateInitialBoilingPoint() {
    final data = BoilingPointCalculator.getSubstanceData(selectedSubstance);
    if (data != null) {
      setState(() {
        initialBoilingPoint = data['normalBoilingPoint']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CardColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Boiling Point Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Calculation Type Toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Calculation Type',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ToggleButtons(
                        isSelected: [
                          calculateTemperature,
                          !calculateTemperature,
                        ],
                        onPressed: (index) {
                          setState(() {
                            calculateTemperature = index == 0;
                          });
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Find Boiling Point'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Find Pressure'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Substance Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Substance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: selectedSubstance,
                        isExpanded: true,
                        items: BoilingPointCalculator.getAvailableSubstances()
                            .map(
                              (substance) => DropdownMenuItem(
                                value: substance,
                                child: Text(substance),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubstance = value!;
                            updateInitialBoilingPoint();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Fields
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Input Parameters',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Initial Pressure
                      _buildNumberInput(
                        label: 'Initial Pressure (mmHg)',
                        value: initialPressure,
                        onChanged: (value) =>
                            setState(() => initialPressure = value),
                      ),

                      const SizedBox(height: 16),

                      // Initial Boiling Point
                      _buildNumberInput(
                        label: 'Initial Boiling Point (°C)',
                        value: initialBoilingPoint,
                        onChanged: (value) =>
                            setState(() => initialBoilingPoint = value),
                      ),

                      const SizedBox(height: 16),

                      // Conditional Input based on calculation type
                      if (calculateTemperature)
                        _buildNumberInput(
                          label: 'Final Pressure (mmHg)',
                          value: finalPressure,
                          onChanged: (value) =>
                              setState(() => finalPressure = value),
                        )
                      else
                        _buildNumberInput(
                          label: 'Final Boiling Point (°C)',
                          value: finalBoilingPoint,
                          onChanged: (value) =>
                              setState(() => finalBoilingPoint = value),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculate,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Calculate'),
                ),
              ),

              const SizedBox(height: 16),

              // Results
              if (calculatedBoilingPoint != null || calculatedPressure != null)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Calculation Result',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.green[800]),
                        ),
                        const SizedBox(height: 8),
                        if (calculatedBoilingPoint != null)
                          Text(
                            'Final Boiling Point: ${calculatedBoilingPoint!.toStringAsFixed(1)}°C',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.green[800]),
                          ),
                        if (calculatedPressure != null)
                          Text(
                            'Final Pressure: ${calculatedPressure!.toStringAsFixed(1)} mmHg',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.green[800]),
                          ),
                      ],
                    ),
                  ),
                ),

              if (errorMessage != null)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Error',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.red[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20), // Extra space at bottom for scrolling
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(text: value.toString()),
      onChanged: (text) {
        final newValue = double.tryParse(text);
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}
