import 'package:dio/dio.dart';

abstract class IWeatherDatasource {
  Future<Map> getWeather(String lat, String lon);
}

class DioWeatherDatasource implements IWeatherDatasource {
  final String keyAPI;
  DioWeatherDatasource({
    required this.keyAPI,
  });
  final String baseURL = 'https://api.openweathermap.org/data/2.5/weather';
  @override
  Future<Map> getWeather(String lat, String lon) async {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );

    Dio dio = Dio(baseOptions);

    try {
      final response =
          await dio.get("?lat=$lat&lon=$lon&appid=$keyAPI&units=metric");
      return response.data;
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}
