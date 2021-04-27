
import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMMMMEEEEd();

extension DateTimeCompare on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return this.isSameDay(now);
  }

  String toFormattedString() {
    if (this.isToday()) {
      return 'Today';
    }
    return dateFormatter.format(this);
  }

  bool isSameDay(DateTime dt) {
    return this.year == dt.year && this.month == dt.month && this.day == dt.day;
  }
}