String completedInTime(DateTime CompletedOn, DateTime allotedOn) {
  Duration duration = CompletedOn.difference(allotedOn);
  int hours = duration.inHours;
  int days = (hours / 24).ceil();
  int rem_hour = (hours % 24);
  // if (days > 0)
  return "Time Taken $days days and $rem_hour hours";
  // else
  //   return "";
}
