import 'dart:convert';

import 'package:saudetv/app/modules/player/domain/entities/weather_entity.dart';

class WeatherModel implements WeatherEntity {
  @override
  final int id;
  @override
  final String icon;
  @override
  final String tempMin;
  @override
  final String tempMax;
  WeatherModel({
    required this.id,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'icon': icon});
    result.addAll({'tempMin': tempMin});
    result.addAll({'tempMax': tempMax});

    return result;
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      id: map['id']?.toInt() ?? 0,
      icon: map['icon'] ?? '',
      tempMin: map['tempMin'] ?? '',
      tempMax: map['tempMax'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source));
}
