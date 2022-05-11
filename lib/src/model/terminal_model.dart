import 'dart:convert';

class TerminalModel {
  final String id;
  final List<String> plalist;
  final bool hasBar;
  final int updateStartHour;
  final int updateStartMinute;
  final int updateEndHour;
  final int updateEndMinute;
  final int updateTimeCourseMin;
  final String lat;
  final String lon;
  TerminalModel({
    required this.id,
    required this.plalist,
    required this.hasBar,
    required this.updateStartHour,
    required this.updateStartMinute,
    required this.updateEndHour,
    required this.updateEndMinute,
    required this.updateTimeCourseMin,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plalist': plalist,
      'hasBar': hasBar,
      'updateStartHour': updateStartHour,
      'updateStartMinute': updateStartMinute,
      'updateEndHour': updateEndHour,
      'updateEndMinute': updateEndMinute,
      'updateTimeCourseMin': updateTimeCourseMin,
      'lat': lat,
      'lon': lon,
    };
  }

  factory TerminalModel.fromMap(Map<String, dynamic> map) {
    return TerminalModel(
      id: map['id'] ?? '',
      plalist: List<String>.from(map['plalist']),
      hasBar: map['hasBar'] ?? false,
      updateStartHour: map['updateStartHour']?.toInt() ?? 0,
      updateStartMinute: map['updateStartMinute']?.toInt() ?? 0,
      updateEndHour: map['updateEndHour']?.toInt() ?? 0,
      updateEndMinute: map['updateEndMinute']?.toInt() ?? 0,
      updateTimeCourseMin: map['updateTimeCourseMin']?.toInt() ?? 0,
      lat: map['lat'] ?? '',
      lon: map['lon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TerminalModel.fromJson(String source) =>
      TerminalModel.fromMap(json.decode(source));
}
