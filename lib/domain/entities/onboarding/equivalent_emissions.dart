import 'package:intl/intl.dart';

final formatter = NumberFormat("#,###", "en_US");

const carKmPerKgEmitted = 3 * (19 / 27);

class EquivalentEmmisions {
  final String name;
  final String caption;
  final String amount;

  const EquivalentEmmisions(
      {required this.name, required this.caption, required this.amount});

  factory EquivalentEmmisions.car(int totalEmissions) {
    return EquivalentEmmisions(
        name: 'Car',
        caption: 'Same as driving a petrol car for',
        amount: '${formatter.format(carKmPerKgEmitted * totalEmissions)} km');
  }
}
