import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/weather_entity.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IWeatherRepository {
  Future<Either<HttpError, WeatherEntity>> getWeather(String lat, String lon);
}
