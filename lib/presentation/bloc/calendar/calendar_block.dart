import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meatless_days/domain/entities/calendar/check_in_day.dart';
import 'package:meatless_days/domain/entities/calendar/diet.dart';
import 'package:meatless_days/domain/usecases/calendar/delete_checkin.dart';
import 'package:meatless_days/domain/usecases/calendar/get_checkins.dart';
import 'package:meatless_days/domain/usecases/calendar/save_checkin.dart';
import 'package:meatless_days/presentation/bloc/calendar/calendar_event.dart';
import 'package:meatless_days/presentation/bloc/calendar/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetCheckins getCheckins;
  final SaveCheckin saveCheckin;
  final DeleteCheckin deleteCheckin;

  CalendarBloc({
    required this.getCheckins,
    required this.saveCheckin,
    required this.deleteCheckin,
  }) : super(Empty());

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    switch (event.runtimeType) {
      case GetCheckinsEvent:
        yield Updating();

        final checkins = await this.getCheckins();

        yield Updated(checkins: checkins);
        break;

      // Todo: figure out if code repetition is worth the domain leaking in the presentation
      case SaveVeganDayEvent:
        yield Updating();

        final checkin = CheckedInDay(
          day: (event as SaveVeganDayEvent).day,
          diet: Diet.vegan,
        );

        final checkins = await saveCheckin(SaveCheckinParams(
          checkin: checkin,
        ));

        yield Updated(checkins: checkins);
        break;

      case SaveMeatlessDayEvent:
        yield Updating();

        final checkin = CheckedInDay(
          day: (event as SaveMeatlessDayEvent).day,
          diet: Diet.meatless,
        );

        final checkins = await saveCheckin(SaveCheckinParams(
          checkin: checkin,
        ));

        yield Updated(checkins: checkins);
        break;

      case SaveAnimalProteinDayEvent:
        yield Updating();

        final day = (event as SaveAnimalProteinDayEvent).day;

        final checkins =
            await deleteCheckin(DeleteCheckinParams(checkInDay: day));

        yield Updated(checkins: checkins);
        break;
    }
  }
}
