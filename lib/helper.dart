String minuteToHourStr(int minute, [bool showMinute = false]) {
  int hour = (minute / 60).floor();
  int min = (minute % 60).floor();

  if (!showMinute)
    return minute % 60 == 0 ? '${hour}sa' : '${hour}sa ${min}dk';
  else
    return '${hour}sa ${min}dk';
}
