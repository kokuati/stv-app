import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/weather_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/weather_repository_i.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IGetWeather {
  Future<Either<Errors, WeatherEntity>> call(String lat, String lon);
}

class GetWeather extends IGetWeather {
  final IWeatherRepository repository;
  GetWeather({
    required this.repository,
  });

  @override
  Future<Either<Errors, WeatherEntity>> call(String lat, String lon) async {
    final result = await repository.getWeather(lat, lon);
    return result.fold((l) => left(l), (r) => right(r));
  }
}
