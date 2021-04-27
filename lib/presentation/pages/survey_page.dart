import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meatless_days/core/theme_config.dart';
import 'package:meatless_days/domain/entities/onboarding/food_options.dart';
import 'package:meatless_days/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:meatless_days/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:meatless_days/presentation/bloc/onboarding/onboarding_state.dart';
import 'package:meatless_days/presentation/widgets/onboarding/food_survey_card.dart';

final double maxNumberOfPortions = 20;

final String mountainsAssetPath = 'assets/mountains.png';

final Map<FoodOption, double> initialState = foodOptions.fold(
    {},
    (value, element) => ({
          ...value,
          element.foodOption:
              element.portion.portionSize * maxNumberOfPortions * 0.5
        }));

class SurveyPage extends HookWidget {
  static ValueKey pageKey = ValueKey('SurveyPage');

  const SurveyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foodConsumption = useState(initialState);

    void onGenerateReport() {
      BlocProvider.of<OnboardingBloc>(context)
          .add(SubmitSurveyEvent(foodConsumption.value));
    }

    return Scaffold(
      body: Container(
          color: backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(alignment: Alignment.topLeft, children: [
                Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3),
                    color: Colors.white,
                    // Todo: fix blinking, need to convert to stateful widget and preload
                    // https://stackoverflow.com/questions/51343735/flutter-image-preload
                    child: Image.asset(mountainsAssetPath)),
                Container(
                    padding: EdgeInsets.only(
                        left: 20,
                        bottom: 80,
                        top: MediaQuery.of(context).size.height / 5,
                        right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Let\'s first check\nwhat you eat',
                          style: TextStyle(
                            color: borderColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'This helps us estimate your footprint from animal protein',
                            style: TextStyle(
                              color: borderColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ))
              ]),
              ...foodOptions
                  .map((food) => Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: FoodSurveryCard(
                          food: food,
                          maxNumberOfPortions: maxNumberOfPortions,
                          consumption: foodConsumption.value[food.foodOption]!,
                          setConsumption: (double consumption) {
                            foodConsumption.value = {
                              ...foodConsumption.value,
                              food.foodOption: consumption
                            };
                          },
                          key: Key(food.name),
                        ),
                      ))
                  .toList(),
              Container(
                margin: EdgeInsets.only(top: 70, bottom: 90),
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return TextButton(
                      onPressed: (state is SurveySubmitting)
                          ? null
                          : () => onGenerateReport(),
                      child: Text(
                        (state is SurveySubmitting)
                            ? 'Creating report...'
                            : 'Create Emissions Report',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(pinkColor)),
                    );
                  },
                ),
                height: 50,
              )
            ],
          )),
    );
  }
}
