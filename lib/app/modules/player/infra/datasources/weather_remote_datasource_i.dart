import 'package:saudetv/app/modules/player/infra/models/weather_model.dart';

abstract class IWeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String lat, String lon);
}
