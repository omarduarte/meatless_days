import 'package:meatless_days/core/emissions_conversion.dart';
import 'package:meatless_days/domain/entities/onboarding/emissions_report.dart';
import 'package:meatless_days/domain/entities/onboarding/equivalent_emissions.dart';
import 'package:meatless_days/domain/entities/onboarding/food_emission.dart';
import 'package:meatless_days/domain/entities/onboarding/food_options.dart';
import 'package:meatless_days/domain/entities/onboarding/survey.dart';
import 'package:meatless_days/domain/repositories/survey_repository.dart';
import 'package:meatless_days/domain/usecases/use_case.dart';

const weeksInYear = 52.1429;

class GenerateEmissionsReportParams extends Params {
  final Map<FoodOption, double> survey;

  GenerateEmissionsReportParams(this.survey);
}

class GenerateEmissionsReport
    extends UseCase<EmissionsReport, GenerateEmissionsReportParams> {
  final SurveyRepository surveyReporitory;

  GenerateEmissionsReport({required this.surveyReporitory});

  @override
  Future<EmissionsReport> call(GenerateEmissionsReportParams params) async {
    Survey survey = Survey(params.survey);

    await surveyReporitory.save(survey);

    List<FoodEmission> yearlyEmissionsBreakdown =
        _toYearlyEmissionsBreakdown(survey)
          ..sort((a, b) => b.amountInKg - a.amountInKg);

    int totalEmissions =
        yearlyEmissionsBreakdown.fold(0, (total, e) => total + e.amountInKg);

    return Future.value(EmissionsReport(
      amountInKg: totalEmissions,
      equivalent: EquivalentEmmisions.car(totalEmissions),
      foodEmissions: yearlyEmissionsBreakdown,
    ));
  }
}

List<FoodEmission> _toYearlyEmissionsBreakdown(Survey survey) {
  return survey.values.entries.map<FoodEmission>((foodToConsumption) {
    final yearlyEmissions =
        (emissionsFromUnit(foodToConsumption.key, foodToConsumption.value)
                    .inKg() *
                weeksInYear)
            .toInt();
    return FoodEmission(
      source: foodToConsumption.key.toFoodName(),
      amountInKg: yearlyEmissions,
    );
  }).toList();
}

extension _enumFromString on FoodOption {
  String toFoodName() {
    return this.toString().split(".").last;
  }
}
