import 'package:equatable/equatable.dart';
import 'package:meatless_days/domain/entities/onboarding/emissions_report.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object> get props => [];
}

class AppLoading extends OnboardingState {}

class NewUser extends OnboardingState {}

class SurveyStarted extends OnboardingState {}

class SurveySubmitting extends OnboardingState {}

class EmissionsReportGenerated extends OnboardingState {
  final EmissionsReport emissionsReport;

  EmissionsReportGenerated({required this.emissionsReport});
}

class Complete extends OnboardingState {}
