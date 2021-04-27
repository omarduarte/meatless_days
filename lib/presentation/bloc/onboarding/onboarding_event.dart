import 'package:equatable/equatable.dart';
import 'package:meatless_days/domain/entities/onboarding/food_options.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class AppLoadingEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}

class StartSurveyEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}

class SubmitSurveyEvent extends OnboardingEvent {
  final Map<FoodOption, double> surveyPayload;

  SubmitSurveyEvent(this.surveyPayload);

  @override
  List<Object?> get props => [surveyPayload];
}

class CompleteEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}
