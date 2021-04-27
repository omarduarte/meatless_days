import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/theme_config.dart';
import '../../core/utils/extensions.dart';
import '../../domain/entities/calendar/check_in_day.dart';
import '../../domain/entities/calendar/diet.dart';
import '../../injector_container.dart' as di;
import '../bloc/calendar/calendar_block.dart';
import '../bloc/calendar/calendar_event.dart';
import '../bloc/calendar/calendar_state.dart';
import '../widgets/onboarding/day_type_radio_button.dart';

final Color meatlessColor = blueColor;
final Color veganColor = pinkColor;
final Color meatAndDairyColor = Colors.black54;

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key, required this.onClose}) : super(key: key);
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>(
        create: (BuildContext context) => di.sl<CalendarBloc>(),
        child:
            BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
          return _CalendarPageWrapper(onClose: onClose);
        }));
  }
}

class _CalendarPageWrapper extends HookWidget {
  final Function onClose;

  const _CalendarPageWrapper({Key? key, required this.onClose})
      : super(key: key);

  EventList<Event> _toMarkedDates(List<CheckedInDay> checkins) {
    return EventList(
        events: checkins.fold(
            {},
            (acc, element) => {
                  ...acc,
                  element.day: [element.toEvent()]
                }));
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState(today());

    useEffect(() {
      BlocProvider.of<CalendarBloc>(context).add(GetCheckinsEvent());
    }, []);

    _checkIntoSelectedDay(Diet diet) {
      if (diet == Diet.vegan) {
        BlocProvider.of<CalendarBloc>(context)
            .add(SaveVeganDayEvent(day: selectedDay.value));
      } else if (diet == Diet.meatless) {
        BlocProvider.of<CalendarBloc>(context)
            .add(SaveMeatlessDayEvent(day: selectedDay.value));
      } else if (diet == Diet.animal) {
        BlocProvider.of<CalendarBloc>(context)
            .add(SaveAnimalProteinDayEvent(day: selectedDay.value));
      }
    }

    int _radioValue(List<CheckedInDay> checkins) {
      try {
        // Todo: fix this ugliness
        CheckedInDay foundCheckin = checkins
            .firstWhere((checkin) => selectedDay.value.isSameDay(checkin.day));
        return foundCheckin.diet == Diet.vegan
            ? CheckinRadioProps.veganDay
            : CheckinRadioProps.meatlessDay;
      } catch (e) {
        return CheckinRadioProps.meatAndDairyDay;
      }
    }

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return Scaffold(
        body: ListView(
          children: [
            Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => onClose(),
                      child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: pinkColor,
                            ),
                          )),
                    ),
                    Text('Meatless day\ncheck-in',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: borderColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ))
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 24, left: 20, right: 20),
              child: CalendarCarousel<Event>(
                // State
                selectedDateTime: selectedDay.value,
                onDayPressed: (DateTime date, List<Event> events) {
                  selectedDay.value = date;
                },

                // Layout
                height: 450.0,

                // Gets the dates that are marked with dots in the calendar
                markedDatesMap:
                    (state is Updated) ? _toMarkedDates(state.checkins) : null,

                // Scroll configuration - Calendar scrolls vertically without this
                isScrollable: true,
                scrollDirection: Axis.horizontal,
                customGridViewPhysics: NeverScrollableScrollPhysics(),

                // Whole Calendar Config
                firstDayOfWeek: 1,
                showOnlyCurrentMonthDate: true,
                weekendTextStyle:
                    TextStyle(fontSize: 14.0, color: Colors.black54),
                weekdayTextStyle: TextStyle(fontSize: 14.0, color: borderColor),

                // Header config
                iconColor: pinkColor,
                headerTextStyle: TextStyle(
                    fontSize: 20.0,
                    color: pinkColor,
                    fontWeight: FontWeight.w700),

                // Day cell config
                daysHaveCircularBorder: true,

                todayBorderColor: Colors.transparent,
                todayButtonColor: Colors.transparent,
                todayTextStyle: TextStyle(color: pinkColor),

                selectedDayBorderColor: pinkColor,
                selectedDayButtonColor: Colors.white,
                selectedDayTextStyle: TextStyle(
                    color:
                        selectedDay.value.isToday() ? pinkColor : borderColor),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        selectedDay.value.toFormattedString(),
                        style: TextStyle(color: borderColor, fontSize: 20),
                      ),
                    ),
                    ...[
                      CheckinRadioProps(
                        color: veganColor,
                        radioValue: CheckinRadioProps.veganDay,
                        label: 'Vegan day',
                      ),
                      CheckinRadioProps(
                        color: meatlessColor,
                        radioValue: CheckinRadioProps.meatlessDay,
                        label: 'Meatless day',
                      ),
                      CheckinRadioProps(
                        color: meatAndDairyColor,
                        radioValue: CheckinRadioProps.meatAndDairyDay,
                        label: 'Animal protein day',
                      ),
                    ]
                        .map((radioProps) => Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: DayTypeRadioButton(
                              activeColor: radioProps.color,
                              activeRadioValue: _radioValue(
                                  (state is Updated) ? state.checkins : []),
                              radioValue: radioProps.radioValue,
                              label: radioProps.label,
                              onSelection: () {
                                _checkIntoSelectedDay(radioProps.toDiet());
                              },
                            )))
                        .toList(),
                  ],
                ))
          ],
        ),
      );
    });
  }
}

DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

class CheckinRadioProps {
  final Color color;
  final int radioValue;
  final String label;

  static final int veganDay = 0;
  static final int meatlessDay = 1;
  static final int meatAndDairyDay = 2;

  CheckinRadioProps({
    required this.color,
    required this.radioValue,
    required this.label,
  });

  bool isMeatAndDairyDay() {
    return this.radioValue == meatAndDairyDay;
  }

  Diet toDiet() {
    if (this.radioValue == veganDay) {
      return Diet.vegan;
    } else if (this.radioValue == meatlessDay) {
      return Diet.meatless;
    } else if (this.radioValue == meatAndDairyDay) {
      return Diet.animal;
    }
    throw Exception('Invalid diet');
  }
}

extension CalendarEventDay on CheckedInDay {
  Color get dayMarkColor {
    switch (this.diet) {
      case Diet.meatless:
        return meatlessColor;
      case Diet.vegan:
        return veganColor;
      case Diet.animal:
        return meatAndDairyColor;
      default:
        throw UnimplementedError('Invalid diet');
    }
  }

  Event toEvent() {
    return Event(
      date: this.day,
      dot: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: this.dayMarkColor,
        ),
      ),
    );
  }
}
