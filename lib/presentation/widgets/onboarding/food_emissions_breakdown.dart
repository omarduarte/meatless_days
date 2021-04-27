import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meatless_days/core/utils/formatting.dart';

import '../../../core/theme_config.dart';
import '../../../domain/entities/onboarding/food_emission.dart';

class FoodEmissionsBreakdown extends StatelessWidget {
  final List<FoodEmission> emissions;

  const FoodEmissionsBreakdown({
    Key? key,
    required this.emissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalEmissions =
        emissions.fold<int>(0, (prev, e) => prev + e.amountInKg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Text('Emissions Breakdown',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
        ),
        Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth()
            },
            children: emissions
                .map((e) => TableRow(
                      children: <Widget>[
                        Text(e.source.toCapitalCase(),
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        Slider(
                            value: e.amountInKg / totalEmissions,
                            activeColor: backgroundColor,
                            inactiveColor: borderColor,
                            onChanged: (_) => null),
                        Text('${formatter.format(e.amountInKg)} kg',
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400))
                      ],
                    ))
                .toList())
      ],
    );
  }
}

extension Capitalize on String {
  String toCapitalCase() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
