import 'package:dio/dio.dart';

abstract class IRemolteDatasource {
  Future<Map> getTerminalInfo(String terminal);
  Future<String> getContents(String idContent);
}

class DioRemolteDatasource extends IRemolteDatasource {
  String baseURL;

  DioRemolteDatasource({
    required this.baseURL,
  });

  @override
  Future<Map> getTerminalInfo(String terminal) async {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );

    Dio dio = Dio(baseOptions);

    try {
      final response = await dio.get("/v1/terminals/$terminal");
      return response.data;
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }

  @override
  Future<String> getContents(String idContent) async {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: 50000,
      receiveTimeout: 500000,
    );

    Dio dio = Dio(baseOptions);

    try {
      final response = await dio.get("/v1/contents/$idContent");
      final data = response.data;
      final String file = data["data"]["file"];
      return file.substring(file.lastIndexOf(',') + 1);
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}
