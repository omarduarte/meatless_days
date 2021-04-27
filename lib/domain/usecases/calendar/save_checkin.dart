import '../../entities/calendar/check_in_day.dart';
import '../../repositories/calendar_repository.dart';
import '../use_case.dart';

class SaveCheckinParams extends Params {
  final CheckedInDay checkin;

  SaveCheckinParams({required this.checkin});
}

class SaveCheckin implements UseCase<List<CheckedInDay>, SaveCheckinParams> {
  final CalendarRepository repository;

  SaveCheckin({required this.repository});

  @override
  Future<List<CheckedInDay>> call(SaveCheckinParams params) async {
    CheckedInDay toCheckIn = params.checkin;

    final previousCheckinsOnSameDay = await repository.getForDay(toCheckIn.day);

    if (previousCheckinsOnSameDay != null) {
      await repository.delete(previousCheckinsOnSameDay);
    }

    return repository.saveCheckin(params.checkin);
  }
}
