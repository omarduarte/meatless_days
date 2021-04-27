import 'package:meatless_days/domain/entities/calendar/check_in_day.dart';
import 'package:meatless_days/domain/repositories/calendar_repository.dart';
import 'package:meatless_days/domain/usecases/use_case.dart';

class DeleteCheckinParams extends Params {
  final DateTime checkInDay;

  DeleteCheckinParams({required this.checkInDay});
}

class DeleteCheckin implements UseCase<void, DeleteCheckinParams> {
  final CalendarRepository repository;

  DeleteCheckin({required this.repository});

  @override
  Future<List<CheckedInDay>> call(DeleteCheckinParams params) async {
    CheckedInDay? toDelete = await repository.getForDay(params.checkInDay);

    if (toDelete != null) {
      return await repository.delete(toDelete);
    } else {
      throw Exception('Attempting to inexisting day');
    }
  }
}
