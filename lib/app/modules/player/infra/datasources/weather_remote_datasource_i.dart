import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/modules/player/infra/models/weather_model.dart';

abstract class IWeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String lat, String lon);
}
