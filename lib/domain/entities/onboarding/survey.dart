import 'food_options.dart';

class Survey {
  final Map<FoodOption, double> values;

  Survey(this.values);

  double getConsumption(FoodOption option) {
    return values[option]!;
  }
}
