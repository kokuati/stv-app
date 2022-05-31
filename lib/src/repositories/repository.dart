import 'package:dartz/dartz.dart';

import 'package:saudetv/src/datasources/local_datasource.dart';
import 'package:saudetv/src/datasources/remolte_datasource_dio.dart';
import 'package:saudetv/src/datasources/weather_datasource.dart';
import 'package:saudetv/src/errors/errors.dart';
import 'package:saudetv/src/model/terminal_model.dart';
import 'package:saudetv/src/model/weather_model.dart';
import 'package:saudetv/src/services/file_controller_service.dart';

abstract class IRepository {
  Future<Either<Errors, TerminalModel>> getTerminalInfo(String terminal);
  Future<Either<Errors, bool>> downloadVideo(String idContent);
  Future<Either<Errors, bool>> saveTerminalModel(TerminalModel terminalModel);
  Future<Either<Errors, TerminalModel>> getTerminalModel();
  Future<Either<Errors, WeatherModel>> getWeatherModel(String lat, String lon);
}

class Repository extends IRepository {
  final IRemolteDatasource remolteDatasource;
  final ILocalDatasourece localDatasourece;
  final IWeatherDatasource weatherDatasource;
  final FileControllerService fileControllerService;
  Repository({
    required this.remolteDatasource,
    required this.localDatasourece,
    required this.weatherDatasource,
    required this.fileControllerService,
  });

  @override
  Future<Either<Errors, WeatherModel>> getWeatherModel(lat, lon) async {
    try {
      final getData = await weatherDatasource.getWeather(lat, lon);
      final WeatherModel result = WeatherModel(
          id: getData["weather"][0]["id"],
          icon: '${getData["weather"][0]["icon"].substring(0, 2)}d',
          tempMax: getData["main"]["temp_max"].toString().substring(0, 2),
          tempMin: getData["main"]["temp_min"].toString().substring(0, 2));
      return Right(result);
    } catch (e) {
      return Left(WeatherError());
    }
  }

  @override
  Future<Either<Errors, TerminalModel>> getTerminalModel() async {
    try {
      final result = await localDatasourece.getTerminal();
      if (result.isNotEmpty) {
        return Right(TerminalModel.fromJson(result));
      } else {
        return Left(TerminalEmpty());
      }
    } catch (e) {
      return Left(TerminalEmpty());
    }
  }

  @override
  Future<Either<Errors, bool>> saveTerminalModel(
      TerminalModel terminalModel) async {
    final json = terminalModel.toJson();
    try {
      final result = await localDatasourece.saveTerminal(json);
      if (result) {
        return Right(result);
      } else {
        return left(SaveError());
      }
    } catch (e) {
      return left(SaveError());
    }
  }

  @override
  Future<Either<Errors, TerminalModel>> getTerminalInfo(String terminal) async {
    try {
      final getData = await remolteDatasource.getTerminalInfo(terminal);
      final List<String> videoList = [];
      for (var item in getData["data"]["playlists"][0]["contents"]) {
        videoList.add(item);
      }
      //print('add na api  barra, lat  e lon');
      final TerminalModel result = TerminalModel(
        id: terminal,
        plalist: videoList,
        hasBar: false,
        lat: '-23.5521',
        lon: '-46.6605',
        updateTimeCourseMin: int.parse(getData["data"]["refreshHour"]),
        updateStartHour:
            int.parse(getData["data"]["startHour"].substring(0, 2)),
        updateStartMinute:
            int.parse(getData["data"]["startHour"].substring(3, 5)),
        updateEndHour: int.parse(getData["data"]["endHour"].substring(0, 2)),
        updateEndMinute: int.parse(getData["data"]["endHour"].substring(3, 5)),
      );
      return Right(result);
    } catch (e) {
      if (e is int) {
        return Left(TerminalError(statusCode: e));
      } else {
        return Left(TerminalError(statusCode: 0));
      }
    }
  }

  @override
  Future<Either<Errors, bool>> downloadVideo(String idContent) async {
    try {
      final base64 = await remolteDatasource.getContents(idContent);
      await fileControllerService.createVideoFromBase64(
          '$idContent.mp4', base64);
      return const Right(true);
    } catch (e) {
      if (e is int) {
        return Left(ContentsError(statusCode: e));
      } else {
        return Left(ContentsError(statusCode: 0));
      }
    }
  }
}
