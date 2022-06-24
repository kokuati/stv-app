class TerminalEntity {
  final String id;
  final List<String> contentsList;
  final bool hasBar;
  final int updateStartHour;
  final int updateStartMinute;
  final int updateEndHour;
  final int updateEndMinute;
  final int updateTimeCourseMin;
  final String lat;
  final String lon;

  TerminalEntity(
    this.id,
    this.contentsList,
    this.hasBar,
    this.updateStartHour,
    this.updateStartMinute,
    this.updateEndHour,
    this.updateEndMinute,
    this.updateTimeCourseMin,
    this.lat,
    this.lon,
  );
}
