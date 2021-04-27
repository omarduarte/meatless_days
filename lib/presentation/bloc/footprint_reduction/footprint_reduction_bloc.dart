import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meatless_days/domain/entities/footprint_reduction/reduction.dart';
import 'package:meatless_days/domain/usecases/footprint_reduction/calculate_reductions.dart';
import 'package:meatless_days/presentation/bloc/footprint_reduction/footprint_reduction_event.dart';
import 'package:meatless_days/presentation/bloc/footprint_reduction/footprint_reduction_state.dart';

class FootprintReductionBloc
    extends Bloc<FootprintReductionEvent, FootprintReductionState> {
  final CalculateReductions calculateReductions;
  late Reduction _previousAmount = Reduction(amount: 0, metric: 'grams');

  FootprintReductionBloc({required this.calculateReductions}) : super(Empty());

  @override
  Stream<FootprintReductionState> mapEventToState(
      FootprintReductionEvent event) async* {
    if (event is TriggerReductionCalculation) {
      yield Calculating(previousReduction: _previousAmount);

      final result = await calculateReductions();

      yield Updated(reduction: result);
    }
  }
}
