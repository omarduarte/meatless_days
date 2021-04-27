abstract class CalendarEvent {}

class GetCheckinsEvent extends CalendarEvent {}

class SaveVeganDayEvent extends CalendarEvent {
  final DateTime day;

  SaveVeganDayEvent({required this.day});
}

class SaveMeatlessDayEvent extends CalendarEvent {
  final DateTime day;

  SaveMeatlessDayEvent({required this.day});
}

class SaveAnimalProteinDayEvent extends CalendarEvent {
  final DateTime day;

  SaveAnimalProteinDayEvent({required this.day});
}
