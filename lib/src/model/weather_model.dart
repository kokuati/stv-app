import 'dart:convert';

class WeatherModel {
  final int id;
  final String icon;
  final String tempMin;
  final String tempMax;
  WeatherModel({
    required this.id,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'tempMin': tempMin,
      'tempMax': tempMax,
    };
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
