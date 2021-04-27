import 'food.dart';

enum FoodOption { beef, chicken, cheese, pork, milk, eggs }

final List<SurveyItem> foodOptions = [chicken, beef, pork, cheese, egg, milk];

final Map<FoodOption, String> foodLabels = {
  FoodOption.beef: 'Beef',
  FoodOption.pork: 'Pork',
  FoodOption.chicken: 'Chicken',
  FoodOption.cheese: 'Cheese',
  FoodOption.milk: 'Dairy Milk',
  FoodOption.eggs: 'Eggs',
};

final milk = SurveyItem(
  foodOption: FoodOption.milk,
  name: 'Milk',
  portion: Portion(portionEmoji: '🥛', metric: 'liters', portionSize: 0.2),
);

final beef = SurveyItem(
  foodOption: FoodOption.beef,
  name: 'Beef',
  portion: Portion(portionEmoji: '🍔', metric: 'grams', portionSize: 150),
);

final pork = SurveyItem(
  foodOption: FoodOption.pork,
  name: 'Pork',
  portion: Portion(portionEmoji: '🌭', metric: 'grams', portionSize: 50),
);

final chicken = SurveyItem(
  foodOption: FoodOption.chicken,
  name: 'Chicken',
  portion: Portion(portionEmoji: '🍗', metric: 'grams', portionSize: 115),
);

final cheese = SurveyItem(
    foodOption: FoodOption.cheese,
    name: 'Cheese',
    portion: Portion(portionEmoji: '🍕', metric: 'grams', portionSize: 35));

final egg = SurveyItem(
    foodOption: FoodOption.eggs,
    name: 'Eggs',
    portion: Portion(portionEmoji: '🥚', metric: 'eggs', portionSize: 1));
