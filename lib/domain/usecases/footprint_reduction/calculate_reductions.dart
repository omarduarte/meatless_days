import 'package:meatless_days/core/emissions_conversion.dart';
import 'package:meatless_days/core/weight.dart';
import 'package:meatless_days/domain/entities/calendar/check_in_day.dart';
import 'package:meatless_days/domain/entities/calendar/diet.dart';
import 'package:meatless_days/domain/entities/footprint_reduction/reduction.dart';
import 'package:meatless_days/domain/entities/onboarding/food_options.dart';
import 'package:meatless_days/domain/entities/onboarding/survey.dart';
import 'package:meatless_days/domain/repositories/calendar_repository.dart';
import 'package:meatless_days/domain/repositories/survey_repository.dart';
import 'package:meatless_days/domain/usecases/use_case.dart';

const daysInWeek = 7;

class CalculateReductions implements NoArgUseCase<Reduction> {
  final CalendarRepository calendarRepository;
  final SurveyRepository surveyRepository;

  CalculateReductions(
      {required this.calendarRepository, required this.surveyRepository});

  @override
  Future<Reduction> call() async {
    Survey survey = await surveyRepository.getSurvey();
    List<CheckedInDay> checkins = await calendarRepository.getCheckedinDays();

    int veganDaysSoFar =
        checkins.where((checkin) => checkin.diet == Diet.vegan).length;
    int meatlessDaysSoFar =
        checkins.where((checkin) => checkin.diet == Diet.meatless).length;

    Weight veganReductions = Weight(
        _animalProteinEmissions(survey).amountInGrams *
            veganDaysSoFar ~/
            daysInWeek);
    Weight meatlessReduction = Weight(
        _emissionsWithoutDairyAndEggs(survey).amountInGrams *
            meatlessDaysSoFar ~/
            daysInWeek);

    Weight total = veganReductions + meatlessReduction;

    if (total.amountInGrams < 1000) {
      return Reduction(amount: total.amountInGrams, metric: 'grams');
    } else if (total.inKg() < 1000) {
      return Reduction(amount: total.inKg().toInt(), metric: 'kg');
    } else {
      return Reduction(amount: total.inTon().toInt(), metric: 'tonnes');
    }
  }

  Weight _emissionsWithoutDairyAndEggs(Survey survey) {
    final dairyAndEggs = [
      FoodOption.milk,
      FoodOption.cheese,
      FoodOption.eggs,
    ];

    final optionsConsumed = FoodOption.values
        .where((foodOption) => !dairyAndEggs.contains(foodOption))
        .toList();

    return _getWeeklyEmissionsFor(optionsConsumed, survey);
  }

  Weight _animalProteinEmissions(Survey survey) {
    return _getWeeklyEmissionsFor([...FoodOption.values], survey);
  }

  Weight _getWeeklyEmissionsFor(List<FoodOption> options, Survey survey) {
    return options.fold(Weight(0), (accWeight, option) {
      final consumption = survey.getConsumption(option);
      return accWeight + emissionsFromUnit(option, consumption);
    });
  }
}