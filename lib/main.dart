import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meatless_days/presentation/bloc/footprint_reduction/footprint_reduction_bloc.dart';
import 'package:meatless_days/presentation/bloc/footprint_reduction/footprint_reduction_event.dart';

import 'injector_container.dart' as di;
import 'presentation/bloc/onboarding/onboarding_bloc.dart';
import 'presentation/bloc/onboarding/onboarding_event.dart';
import 'presentation/bloc/onboarding/onboarding_state.dart';
import 'presentation/pages/calendar_page.dart';
import 'presentation/pages/first_emissions_report_page.dart';
import 'presentation/pages/intro_page.dart';
import 'presentation/pages/report_page.dart';
import 'presentation/pages/survey_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // Todo: persist onboarding state in DB

    return MaterialApp(
        title: 'Go meatless',
        home: MultiBlocProvider(providers: [
          BlocProvider<OnboardingBloc>(
            create: (BuildContext context) =>
                di.sl<OnboardingBloc>()..add(AppLoadingEvent()),
          ),
          BlocProvider<FootprintReductionBloc>(
            create: (BuildContext context) => di.sl<FootprintReductionBloc>(),
          )
        ], child: AppNavigator()));
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({
    Key? key,
  }) : super(key: key);

  MaterialPageRoute _buildCalendarPage(BuildContext context) {
    return MaterialPageRoute(
        builder: (inner) => CalendarPage(onClose: () {
              Navigator.of(inner).maybePop();
              BlocProvider.of<FootprintReductionBloc>(context)
                  .add(TriggerReductionCalculation());
            }));
  }

  void _openCalendar(BuildContext context) {
    Navigator.push(context, _buildCalendarPage(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, onboarding) {
      return Navigator(
        pages: [
          if (onboarding is AppLoading)
            //TODO: make this prettier, loading Icon perhaps
            MaterialPage(child: Scaffold(), key: ValueKey('LoadingPage')),
          if (onboarding is NewUser)
            MaterialPage(child: IntroPage(), key: IntroPage.pageKey),
          if (onboarding is SurveyStarted || onboarding is SurveySubmitting)
            MaterialPage(child: SurveyPage(), key: SurveyPage.pageKey),
          if (onboarding is EmissionsReportGenerated)
            MaterialPage(
                child: FirstEmmisionsReportPage(
                    report: onboarding.emissionsReport,
                    onCalendarOpen: () => _openCalendar(context)),
                key: FirstEmmisionsReportPage.pageKey),
          if (onboarding is Complete)
            MaterialPage(
                child: FootprintSavingsPage(
                    onCalendarOpen: () => _openCalendar(context)),
                key: FootprintSavingsPage.pageKey),
        ],
        // transitionDelegate: NoAnimationTransitionDelegate(),
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      );
    });
  }
}
