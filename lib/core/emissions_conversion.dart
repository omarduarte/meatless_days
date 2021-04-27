import 'package:meatless_days/core/weight.dart';
import 'package:meatless_days/domain/entities/onboarding/food_options.dart';

const KgIn1LiterOfMilk = 1.03;
const eggWeightInGrams = 50;

Weight emissionsFromUnit(FoodOption foodOption, double units) {
  switch (foodOption) {
    case FoodOption.beef:
      return Weight((27 * units).toInt()); // from grams
    case FoodOption.pork:
      return Weight((12.1 * units).toInt()); // from grams
    case FoodOption.chicken:
      return Weight((6.9 * units).toInt()); // from grams
    case FoodOption.cheese:
      return Weight((13.5 * units).toInt()); // from grams
    case FoodOption.milk:
      return Weight(
          (1.9 * (KgIn1LiterOfMilk * units / 1000)).toInt()); // from Liters
    case FoodOption.eggs:
      return Weight((4.8 * units * eggWeightInGrams).toInt());
    default:
      throw Exception('Invalid food option');
  }
}
