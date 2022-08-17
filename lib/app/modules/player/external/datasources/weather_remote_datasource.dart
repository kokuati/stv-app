import 'package:dio/dio.dart';
import 'package:saudetv/app/modules/player/infra/datasources/weather_remote_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/models/weather_model.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';

class WeatherRemoteDataSource extends IWeatherRemoteDataSource {
  final String baseURL;
  final String token;
  final ClientHttpInterface clientHttp;
  WeatherRemoteDataSource({
    required this.baseURL,
    required this.clientHttp,
    required this.token,
  });

  @override
  Future<WeatherModel> getWeather(String lat, String lon) async {
    clientHttp.setBaseUrl(baseURL);
    clientHttp.setConnectTimeout(5000);
    clientHttp.setReceiveTimeout(5000);
    try {
      final response =
          await clientHttp.get("?lat=$lat&lon=$lon&appid=$token&units=metricD");
      final data = response.data;
      return WeatherModel(
          id: data["weather"][0]["id"],
          icon: '${data["weather"][0]["icon"].substring(0, 2)}d',
          tempMax: data["main"]["temp_max"].toString().substring(0, 2),
          tempMin: data["main"]["temp_min"].toString().substring(0, 2));
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}
