import 'dart:convert';

import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';

class TerminalModel implements TerminalEntity {
  @override
  final String id;
  @override
  final List<String> contentsList;
  @override
  final bool hasBar;
  @override
  final int updateStartHour;
  @override
  final int updateStartMinute;
  @override
  final int updateEndHour;
  @override
  final int updateEndMinute;
  @override
  final int updateTimeCourseMin;
  @override
  final String lat;
  @override
  final String lon;
  TerminalModel({
    required this.id,
    required this.contentsList,
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
    return <String, dynamic>{
      'id': id,
      'contentsList': contentsList,
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
      contentsList: List<String>.from(map['contentsList']),
      hasBar: map['hasBar'] ?? true,
      updateStartHour: map['updateStartHour'] ?? 0,
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
      TerminalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
