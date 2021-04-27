import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/theme_config.dart';
import '../../core/widgets/animated_flip_counter.dart';
import '../../domain/entities/onboarding/emissions_report.dart';
import '../bloc/onboarding/onboarding_bloc.dart';
import '../bloc/onboarding/onboarding_event.dart';
import '../widgets/onboarding/emission_equivalence.dart';
import '../widgets/onboarding/food_emissions_breakdown.dart';

const landscapeImage = 'assets/empty-landscape.png';

class FirstEmmisionsReportPage extends HookWidget {
  static ValueKey pageKey = ValueKey('FirstEmmisionsReportPage');

  final EmissionsReport report;
  final Function onCalendarOpen;

  const FirstEmmisionsReportPage(
      {Key? key, required this.onCalendarOpen, required this.report})
      : super(key: key);

  double _getInitialSpinAmont() {
    final amountOfDigits = report.amountInKg.toString().length;
    return double.parse('1' * amountOfDigits); // Hack to hellp
  }

  @override
  Widget build(BuildContext context) {
    final spinningAmount = useState(_getInitialSpinAmont());

    // Hack to make spinning wheel start working better
    Future.delayed(Duration(microseconds: 150),
        () => spinningAmount.value = report.amountInKg.toDouble());

    // Allows us to change the background to the same
    // background color of the first and last element in the ListView.
    // Start with top-element color
    final backColor = useState(pinkColor);

    void _startFirstCheckin() {
      onCalendarOpen();
      BlocProvider.of<OnboardingBloc>(context).add(CompleteEvent());
    }

    return Scaffold(
      body: Container(
        color: backColor.value,
        child: NotificationListener(
          onNotification: (t) {
            if (t is ScrollUpdateNotification) {
              if (t.metrics.extentAfter > t.metrics.extentBefore) {
                backColor.value = pinkColor;
              } else {
                backColor.value = Colors.white;
              }
            }
            return true;
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: EdgeInsets.only(top: 120, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text('Emissions from animal protein',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedFlipCounter(
                              value: spinningAmount.value.toInt(),
                              duration: Duration(seconds: 3),
                              textColor: Colors.white24,
                              size: 85),
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'kg of CO₂e\nper year',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(alignment: Alignment.bottomCenter, children: [
                Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: pinkColor,
                    child: Image.asset(
                      landscapeImage,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    color: blueColor,
                    padding: EdgeInsets.all(72),
                  )
                ]),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: EquivalentEmissionCard(
                      emission: report.equivalent,
                    ))
              ]),
              Container(
                  padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                  color: blueColor,
                  child: Column(children: [
                    FoodEmissionsBreakdown(
                      emissions: report.foodEmissions,
                    ),
                  ])),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [blueColor, Colors.white],
                      stops: [0.9, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text('Start tracking your footprint reduction',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: borderColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          )),
                    ),
                    TextButton(
                      onPressed: () => _startFirstCheckin(),
                      child: Text(
                        'Add meatless day',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(pinkColor)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
