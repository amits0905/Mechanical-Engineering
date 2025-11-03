// default_substances.dart

// Note: This import assumes substance_data.dart is in the same directory
// to use the definition of the Substance class.
import 'substance_data.dart';

/// A static, uneditable map of common organic and inorganic substances
/// used as the default data source for the calculator.
final Map<String, Substance> defaultFixedSubstances = {
  // -----------------------------------------------------------------------
  // --- NON-ORGANIC (INORGANIC) SUBSTANCES ---
  // -----------------------------------------------------------------------
  'Water': Substance(
    name: 'Water',
    normalBoilingPoint: 100.0,
    enthalpyVaporization: 40.65, // kJ/mol
    standardPressure: 760.0, // mmHg
  ),
  'Ammonia': Substance(
    name: 'Ammonia',
    normalBoilingPoint: -33.34,
    enthalpyVaporization: 23.35,
    standardPressure: 760.0,
  ),
  'Nitrogen': Substance(
    name: 'Nitrogen',
    normalBoilingPoint: -195.8,
    enthalpyVaporization: 5.58,
    standardPressure: 760.0,
  ),
  'Oxygen': Substance(
    name: 'Oxygen',
    normalBoilingPoint: -183.0,
    enthalpyVaporization: 6.82,
    standardPressure: 760.0,
  ),
  'Hydrogen Chloride': Substance(
    name: 'Hydrogen Chloride',
    normalBoilingPoint: -85.05,
    enthalpyVaporization: 16.15,
    standardPressure: 760.0,
  ),
  'Sulfur Dioxide': Substance(
    name: 'Sulfur Dioxide',
    normalBoilingPoint: -10.0,
    enthalpyVaporization: 24.9,
    standardPressure: 760.0,
  ),
  'Carbon Dioxide': Substance(
    name: 'Carbon Dioxide',
    normalBoilingPoint: -78.5, // Sublimes, but used for calculation
    enthalpyVaporization: 25.2,
    standardPressure: 760.0,
  ),
  'Mercury': Substance(
    name: 'Mercury',
    normalBoilingPoint: 356.7,
    enthalpyVaporization: 59.1,
    standardPressure: 760.0,
  ),
  // -----------------------------------------------------------------------
  // --- ORGANIC SUBSTANCES (Alcohols, Hydrocarbons, Ketones) ---
  // -----------------------------------------------------------------------
  'Ethanol': Substance(
    name: 'Ethanol',
    normalBoilingPoint: 78.3,
    enthalpyVaporization: 38.56,
    standardPressure: 760.0,
  ),
  'Benzene': Substance(
    name: 'Benzene',
    normalBoilingPoint: 80.1,
    enthalpyVaporization: 30.72,
    standardPressure: 760.0,
  ),
  'Methanol': Substance(
    name: 'Methanol',
    normalBoilingPoint: 64.7,
    enthalpyVaporization: 35.30,
    standardPressure: 760.0,
  ),
  'Acetone': Substance(
    name: 'Acetone',
    normalBoilingPoint: 56.5,
    enthalpyVaporization: 29.1,
    standardPressure: 760.0,
  ),
  'Toluene': Substance(
    name: 'Toluene',
    normalBoilingPoint: 110.6,
    enthalpyVaporization: 33.18,
    standardPressure: 760.0,
  ),
  'Butane': Substance(
    name: 'Butane',
    normalBoilingPoint: -0.5,
    enthalpyVaporization: 22.4,
    standardPressure: 760.0,
  ),
  'Heptane': Substance(
    name: 'Heptane',
    normalBoilingPoint: 98.4,
    enthalpyVaporization: 31.69,
    standardPressure: 760.0,
  ),
  'Pentane': Substance(
    name: 'Pentane',
    normalBoilingPoint: 36.1,
    enthalpyVaporization: 25.8,
    standardPressure: 760.0,
  ),
};
