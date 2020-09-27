class TimeConverter {
  static final num ONE_MINUTE = 60000;
  static final num ONE_HOUR = 3600000;
  static final num ONE_DAY = 86400000;
  static final num ONE_WEEK = 604800000;

  static final String JUST_NOW = "Just Now";
  static final String ONE_MINUTE_AGO = "minutes ago";
  static final String TODAY = "Today,";
  static final String YESTERDAY = "Yesterday,";
  static final String ONE_HOUR_AGO = "An hour ago";
  static final String ONE_DAY_AGO = "Days ago";
  static final String ONE_MONTH_AGO = "Before the month";
  static final String ONE_YEAR_AGO = "years ago";

  static String convert(DateTime time) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch;
    if (delta < ONE_MINUTE) {
      return JUST_NOW;
    } else if (delta < ONE_HOUR) {
      return toMinutes(delta) + " " + ONE_MINUTE_AGO;
    } else if (delta < ONE_DAY) {
      return TODAY +
          " " +
          time.hour.toString() +
          ":" +
          minuteHandler(time.minute);
    } else if (delta < ONE_DAY * 2) {
      return YESTERDAY +
          " " +
          time.hour.toString() +
          ":" +
          minuteHandler(time.minute);
    } else {
      return time.day.toString() +
          "/" +
          time.month.toString() +
          "/" +
          time.year.toString() +
          " " +
          time.hour.toString() +
          ":" +
          minuteHandler(time.minute);
    }
  }

  static String toMinutes(num delta) {
    return (delta / ONE_MINUTE).toString();
  }

  static String minuteHandler(int minute) {
    return minute < 10 ? "0" + minute.toString() : minute.toString();
  }
}
