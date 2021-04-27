import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meatless_days/domain/entities/onboarding/emissions_report.dart';
import 'package:meatless_days/domain/entities/onboarding/equivalent_emissions.dart';
import 'package:meatless_days/domain/entities/onboarding/food_emission.dart';
import 'package:meatless_days/domain/usecases/onboarding/generate_emissions_report.dart';
import 'package:meatless_days/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:meatless_days/presentation/bloc/onboarding/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GenerateEmissionsReport generateEmissionsReport;

  OnboardingBloc({required this.generateEmissionsReport}) : super(AppLoading());

  @override
  Stream<OnboardingState> mapEventToState(OnboardingEvent event) async* {
    switch (event.runtimeType) {
      case AppLoadingEvent:
        // Todo: do something different based on persisted state
        await Future.delayed(Duration(milliseconds: 100));
        yield NewUser();
        break;
      case StartSurveyEvent:
        yield SurveyStarted();
        break;
      case SubmitSurveyEvent:
        yield SurveySubmitting();

        final survey = (event as SubmitSurveyEvent).surveyPayload;

        final params = GenerateEmissionsReportParams(survey);
        final report = await generateEmissionsReport(params);

        yield EmissionsReportGenerated(emissionsReport: report);
        break;
      case CompleteEvent:
        yield Complete();
        break;
      default:
        yield AppLoading();
    }
  }
}

const mockReport = EmissionsReport(
    amountInKg: 4560,
    equivalent: EquivalentEmmisions(
        name: 'car',
        caption: 'Same as driving a petrol car for',
        amount: '3,500km'),
    foodEmissions: [
      FoodEmission(source: 'Cheese', amountInKg: 2900),
      FoodEmission(source: 'Beef', amountInKg: 852),
      FoodEmission(source: 'Chicken', amountInKg: 345),
      FoodEmission(source: 'Pork', amountInKg: 255),
      FoodEmission(source: 'Milk', amountInKg: 250),
    ]);
