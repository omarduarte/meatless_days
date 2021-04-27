import 'food_options.dart';

class SurveyItem {
  final FoodOption foodOption;
  final String name;
  final Portion portion;

  const SurveyItem({
    required this.foodOption,
    required this.name,
    required this.portion,
  });
}

class Portion {
  final String metric;
  final String portionEmoji;
  final double portionSize;

  const Portion({
    required this.metric,
    required this.portionEmoji,
    required this.portionSize,
  });

  String getEquivalence(double consumption) {
    int portions = consumption ~/ portionSize;
    return '$portions $portionEmoji';
  }
}
