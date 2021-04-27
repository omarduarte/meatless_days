import 'package:meatless_days/domain/entities/calendar/check_in_day.dart';

abstract class CalendarState {}

class Empty extends CalendarState {}

class Updating extends CalendarState {}

class Updated extends CalendarState {
  final List<CheckedInDay> checkins;

  Updated({required this.checkins});
}
