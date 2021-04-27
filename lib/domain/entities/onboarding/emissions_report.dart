import 'equivalent_emissions.dart';
import 'food_emission.dart';

class EmissionsReport {
  final int amountInKg;
  final List<FoodEmission> foodEmissions;
  final EquivalentEmmisions equivalent;

  const EmissionsReport({
    required this.amountInKg,
    required this.equivalent,
    required this.foodEmissions,
  });
}

