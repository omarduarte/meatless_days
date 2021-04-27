import 'package:meatless_days/domain/entities/calendar/check_in_day.dart';
import 'package:meatless_days/core/utils/extensions.dart';

abstract class CalendarRepository {
  Future<CheckedInDay?> getForDay(DateTime dt);
  Future<List<CheckedInDay>> getCheckedinDays();
  Future<List<CheckedInDay>> saveCheckin(CheckedInDay checkin);
  Future<List<CheckedInDay>> delete(CheckedInDay checkedInDay);
}

class MockCalendarRepository implements CalendarRepository {
  List<CheckedInDay> _checkins = [];

  @override
  Future<List<CheckedInDay>> getCheckedinDays() {
    return Future.value([..._checkins]);
  }

  Future<CheckedInDay?> getForDay(DateTime dt) {
    int index = _checkins.indexWhere((checkin) => checkin.day.isSameDay(dt));
    return index == -1 ? Future.value(null) : Future.value(_checkins[index]);
  }

  @override
  Future<List<CheckedInDay>> saveCheckin(CheckedInDay checkin) {
    _checkins = [..._checkins, checkin];
    _checkins.sort((d1, d2) => d2.day.compareTo(d1.day));
    return Future.value(_checkins);
  }

  @override
  Future<List<CheckedInDay>> delete(CheckedInDay toRemove) {
    _checkins.removeWhere((checkin) => checkin.day.isSameDay(toRemove.day));
    return Future.value(_checkins);
  }
}
