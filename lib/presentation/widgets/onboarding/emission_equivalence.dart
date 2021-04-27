import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/theme_config.dart';
import '../../../domain/entities/onboarding/equivalent_emissions.dart';

class EquivalentEmissionCard extends StatelessWidget {
  final EquivalentEmmisions emission;

  const EquivalentEmissionCard({Key? key, required this.emission})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 17,
                offset: Offset(3, 5),
                spreadRadius: 0)
          ],
          color: Colors.white),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              padding: EdgeInsets.only(top: 40, bottom: 40),
              width: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                'assets/${emission.name.toLowerCase()}.png',
                fit: BoxFit.fitHeight,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(emission.caption,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Text(emission.amount,
                  style: TextStyle(
                    color: pinkColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          )
        ],
      ),
    )));
  }
}
