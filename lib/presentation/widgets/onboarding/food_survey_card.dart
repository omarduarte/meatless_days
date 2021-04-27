import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meatless_days/core/theme_config.dart';
import 'package:meatless_days/domain/entities/onboarding/food.dart';

final List<Color> gradientSteps = [
  gradGreen,
  gradYellow,
  blueColor,
  pinkColor,
];

List<Color> _getGradient(double consumption, double portionSize) {
  final int position =
      (consumption / portionSize) ~/ (gradientSteps.length + 1);

  return [
    gradientSteps[
        position > gradientSteps.length - 1 ? position - 1 : position],
    gradientSteps[position >= gradientSteps.length - 1 ? 0 : position + 1]
  ];
}

typedef SetConsumption = Function(double consumption);

class FoodSurveryCard extends StatelessWidget {
  final SurveyItem food;
  final double consumption;
  final SetConsumption setConsumption;
  final double maxNumberOfPortions;

  const FoodSurveryCard({
    required this.food,
    required this.consumption,
    required this.setConsumption,
    required this.maxNumberOfPortions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      child: AnimatedContainer(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 17,
                  offset: Offset(3, 5),
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.3, 1],
                colors: _getGradient(consumption, food.portion.portionSize))),
        padding: EdgeInsets.all(20),
        duration: Duration(milliseconds: 550),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                food.name,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: Text(
                      food.portion.formatConsumption(consumption),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${food.portion.formatMetric(consumption)}\nper week',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white70,
              ),
              width: 80,
              height: 30,
              child: Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(food.portion.getEquivalence(consumption),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: borderColor)),
                ),
              ),
            ),
            Slider(
              min: 0.0,
              max: food.portion.portionSize * maxNumberOfPortions,
              activeColor: Colors.grey.shade300,
              inactiveColor: borderColor,
              value: consumption,
              onChanged: (value) {
                setConsumption(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension FoodSize on Portion {
  String formatConsumption(double consumption) {
    if (portionSize < 1) {
      return consumption.toStringAsFixed(2);
    } else if (consumption < 1000) {
      return consumption.toInt().toString();
    }
    double kiloPortions = (consumption / 1000);
    return kiloPortions.toStringAsFixed(2);
  }

  String formatMetric(double consumption) {
    if (consumption < 1000) {
      return metric;
    } else {
      return 'kilo$metric';
    }
  }
}
