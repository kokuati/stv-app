import 'package:intl/intl.dart';

class TimeCuston {
  String timeToString(DateTime timeNow) {
    return DateFormat("HH:mm").format(timeNow);
  }

  String abbreWeek(DateTime timeNow) {
    int week = timeNow.weekday;
    if (week == 1) {
      return 'Seg.';
    } else if (week == 2) {
      return 'Terç.';
    } else if (week == 3) {
      return 'Qua.';
    } else if (week == 4) {
      return 'Qui.';
    } else if (week == 5) {
      return 'Sex.';
    } else if (week == 6) {
      return 'Sáb.';
    } else {
      return 'Dom.';
    }
  }

  String systemDayAndMonth(DateTime timeNow) {
    String day = '';
    String month = '';
    if (timeNow.day > 9) {
      day = '${timeNow.day}';
    } else {
      day = '0${timeNow.day}';
    }
    if (timeNow.month > 9) {
      month = '${timeNow.month}';
    } else {
      month = '0${timeNow.month}';
    }
    return '$day/$month';
  }

  bool isSameDay(DateTime timeNow, DateTime date) {
    return timeNow.year == date.year &&
        timeNow.month == date.month &&
        timeNow.day == date.day;
  }
}
