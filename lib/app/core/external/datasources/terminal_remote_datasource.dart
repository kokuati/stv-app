import 'package:dio/dio.dart';
import 'package:saudetv/app/core/infra/datasources/terminal_remote_datasource_i.dart';
import 'package:saudetv/app/core/infra/models/terminal_model.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';

class TerminalRemoteDataSource extends ITerminalRemoteDataSource {
  final String baseURL;
  final ClientHttpInterface clientHttp;
  TerminalRemoteDataSource({
    required this.baseURL,
    required this.clientHttp,
  });

  @override
  Future<TerminalModel> getTerminal(String terminalID, String token) async {
    clientHttp.setBaseUrl(baseURL);
    clientHttp.setConnectTimeout(500000);
    clientHttp.setReceiveTimeout(500000);
    clientHttp.setHeaders({'Authorization': "Bearer $token"});

    try {
      final response = await clientHttp.get("/v1/terminals/$terminalID");
      final data = response.data;
      final List<String> contentsList = [];
      for (var item in data["data"]["playlists"][0]["contents"]) {
        contentsList.add(item);
      }
      final TerminalModel model = TerminalModel(
          id: terminalID,
          contentsList: contentsList,
          hasBar: true,
          updateStartHour: int.parse(data["data"]["startHour"].substring(0, 2)),
          updateStartMinute:
              int.parse(data["data"]["startHour"].substring(3, 5)),
          updateEndHour: int.parse(data["data"]["endHour"].substring(0, 2)),
          updateEndMinute: int.parse(data["data"]["endHour"].substring(3, 5)),
          updateTimeCourseMin: int.parse(data["data"]["refreshTime"]),
          lat: '-23.5521',
          lon: '-46.6605');
      return model;
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}
