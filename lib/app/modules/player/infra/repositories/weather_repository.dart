import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/weather_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/weather_repository_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/weather_remote_datasource_i.dart';
import 'package:saudetv/app/types/either.dart';

class WeatherRepository extends IWeatherRepository {
  final IWeatherRemoteDataSource remoteDataSource;
  WeatherRepository({
    required this.remoteDataSource,
  });

  @override
  Future<Either<HttpError, WeatherEntity>> getWeather(
      String lat, String lon) async {
    try {
      return right(await remoteDataSource.getWeather(lat, lon));
    } catch (e) {
      if (e is int) {
        return left(HttpError(statusCode: e));
      } else {
        return left(HttpError(statusCode: 0));
      }
    }
  }
}
