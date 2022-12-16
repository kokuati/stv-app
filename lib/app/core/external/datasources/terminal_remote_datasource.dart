import 'dart:developer';

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
    //clientHttp.setConnectTimeout(500);
    //clientHttp.setReceiveTimeout(500);
    clientHttp.setHeaders({'Authorization': "Bearer $token"});
    log('inicio terminal - $terminalID');
    try {
      final response = await clientHttp.get("/v1/terminals/$terminalID");
      final data = response.data;
      log('terminal - data: $data');
      final List<String> contentsList = [];
      final int courseMin =
          ((int.parse(data["data"]["refreshTime"])) / 60).round();
      for (var item in data["data"]["contents"]) {
        contentsList.add(item);
      }
      log('terminal - Lista de conteudo $contentsList');
      final TerminalModel model = TerminalModel(
        id: terminalID,
        contentsList: contentsList,
        hasBar: false,
        updateStartHour: int.parse(data["data"]["startHour"].substring(0, 2)),
        updateStartMinute: int.parse(data["data"]["startHour"].substring(3, 5)),
        updateEndHour: int.parse(data["data"]["endHour"].substring(0, 2)),
        updateEndMinute: int.parse(data["data"]["endHour"].substring(3, 5)),
        updateTimeCourseMin: courseMin,
        lat: data["data"]["location"]["lat"].toString(),
        lon: data["data"]["location"]["lng"].toString(),
      );
      return model;
    } on DioError catch (e) {
      log('terminal - erro: ${e.response!.statusCode!}');
      throw e.response!.statusCode!;
    } catch (e) {
      log('terminal - erro: $e');
      throw 0;
    }
  }
}
