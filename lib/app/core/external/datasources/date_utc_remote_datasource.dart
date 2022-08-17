import 'package:dio/dio.dart';
import 'package:saudetv/app/core/infra/datasources/date_utc_remote_datasource_i.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';

class DateUTCRemoteDataSource1 extends IDateUTCRemoteDataSource {
  final ClientHttpInterface clientHttp;
  DateUTCRemoteDataSource1({
    required this.clientHttp,
  });

  final String baseURL =
      'http://worldtimeapi.org/api/timezone/America/Sao_Paulo';

  @override
  Future<DateTime> getDateUTC() async {
    try {
      final response = await clientHttp.get(baseURL);
      final data = response.data;
      final utcDate = data['utc_datetime'];
      final year = int.parse(utcDate.substring(0, 4));
      final month = int.parse(utcDate.substring(5, 7));
      final day = int.parse(utcDate.substring(8, 10));
      final hour = int.parse(utcDate.substring(11, 13));
      final minute = int.parse(utcDate.substring(14, 16));
      final second = int.parse(utcDate.substring(17, 19));
      return DateTime.utc(year, month, day, hour, minute, second);
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}

class DateUTCRemoteDataSource2 extends IDateUTCRemoteDataSource {
  final ClientHttpInterface clientHttp;
  DateUTCRemoteDataSource2({
    required this.clientHttp,
  });

  final String baseURL = 'http://worldclockapi.com/api/json/utc/now';

  @override
  Future<DateTime> getDateUTC() async {
    try {
      final response = await clientHttp.get(baseURL);
      final data = response.data;
      final utcDate = data['currentDateTime'];
      final year = int.parse(utcDate.substring(0, 4));
      final month = int.parse(utcDate.substring(5, 7));
      final day = int.parse(utcDate.substring(8, 10));
      final hour = int.parse(utcDate.substring(11, 13));
      final minute = int.parse(utcDate.substring(14, 16));
      return DateTime.utc(year, month, day, hour, minute);
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}
