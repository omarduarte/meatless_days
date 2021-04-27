import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/theme_config.dart';
import '../../core/widgets/animated_flip_counter.dart';
import '../bloc/footprint_reduction/footprint_reduction_bloc.dart';
import '../bloc/footprint_reduction/footprint_reduction_state.dart';

const landscapeImage = 'assets/happy-sun.png';

class FootprintSavingsPage extends HookWidget {
  static ValueKey pageKey = ValueKey('FootprintSavingsPage');

  final Function onCalendarOpen;

  const FootprintSavingsPage({Key? key, required this.onCalendarOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Stack(alignment: Alignment.center, children: [
          InkWell(
            onTap: () => onCalendarOpen(),
            child: Container(
                padding: EdgeInsets.only(top: 48, right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 30,
                    color: pinkColor,
                  ),
                )),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 250), // Todo: fix this
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text('Footprint\nreport',
                      style: TextStyle(
                        color: borderColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                BlocBuilder<FootprintReductionBloc, FootprintReductionState>(
                  builder: (context, state) {
                    var amount;
                    var metric;
                    if (state is Updated) {
                      amount = state.reduction.amount;
                      metric = state.reduction.metric;
                    } else if (state is Calculating) {
                      amount = state.previousReduction.amount;
                      metric = state.previousReduction.metric;
                    } else {
                      amount = 0;
                      metric = 'grams';
                    }

                    return Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedFlipCounter(
                              value: amount,
                              duration: Duration(milliseconds: 600),
                              textColor: pinkColor,
                              size: 85),
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              '$metric of CO₂e\nreduced',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: borderColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Image.asset(
                landscapeImage,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
