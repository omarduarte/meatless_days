import 'package:meatless_days/domain/entities/footprint_reduction/reduction.dart';

abstract class FootprintReductionState {}

class Empty extends FootprintReductionState {}

class Calculating extends FootprintReductionState {
  final Reduction previousReduction;

  Calculating({required this.previousReduction});
}

class Updated extends FootprintReductionState {
  final Reduction reduction;

  Updated({required this.reduction});
}
