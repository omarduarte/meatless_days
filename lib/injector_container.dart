// Service locator
import 'package:get_it/get_it.dart';
import 'package:meatless_days/domain/repositories/calendar_repository.dart';
import 'package:meatless_days/domain/repositories/survey_repository.dart';
import 'package:meatless_days/domain/usecases/calendar/delete_checkin.dart';
import 'package:meatless_days/domain/usecases/calendar/get_checkins.dart';
import 'package:meatless_days/domain/usecases/calendar/save_checkin.dart';
import 'package:meatless_days/domain/usecases/footprint_reduction/calculate_reductions.dart';
import 'package:meatless_days/domain/usecases/onboarding/generate_emissions_report.dart';
import 'package:meatless_days/presentation/bloc/calendar/calendar_block.dart';
import 'package:meatless_days/presentation/bloc/footprint_reduction/footprint_reduction_bloc.dart';
import 'package:meatless_days/presentation/bloc/onboarding/onboarding_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // * Blocs
  sl.registerFactory(() => OnboardingBloc(generateEmissionsReport: sl()));
  sl.registerFactory(() => CalendarBloc(
        getCheckins: sl(),
        saveCheckin: sl(),
        deleteCheckin: sl(),
      ));

  sl.registerFactory(() => FootprintReductionBloc(calculateReductions: sl()));

  // * Use cases
  sl.registerLazySingleton(
      () => GenerateEmissionsReport(surveyReporitory: sl()));

  sl.registerLazySingleton(() => GetCheckins(repository: sl()));
  sl.registerLazySingleton(() => SaveCheckin(repository: sl()));
  sl.registerLazySingleton(() => DeleteCheckin(repository: sl()));

  sl.registerLazySingleton(() =>
      CalculateReductions(surveyRepository: sl(), calendarRepository: sl()));

  // * Repositories

  sl.registerLazySingleton<SurveyRepository>(() => MockSurveyRepository());
  sl.registerLazySingleton<CalendarRepository>(() => MockCalendarRepository());
}
