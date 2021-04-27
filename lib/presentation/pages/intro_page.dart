import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme_config.dart';
import '../bloc/onboarding/onboarding_bloc.dart';
import '../bloc/onboarding/onboarding_event.dart';

class IntroPage extends StatelessWidget {
  static ValueKey pageKey = ValueKey('ExplainerPage');

  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onGetStarted() {
      BlocProvider.of<OnboardingBloc>(context).add(StartSurveyEvent());
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20),
        color: pinkColor,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Go\nMeatless',
                style: TextStyle(
                    fontFamily: 'Benne',
                    height: 0.9,
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Footprint tracker for future ex-omnivores')),
            TextButton(
                onPressed: () => onGetStarted(),
                child: Text(
                  'Get Started',
                  style: TextStyle(color: pinkColor),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white))),
          ],
        ),
      ),
    );
  }
}
