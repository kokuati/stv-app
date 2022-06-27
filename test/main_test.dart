import 'package:dio/dio.dart';
import 'package:saudetv/app/modules/player/external/datasources/contents_remote_datasource.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';
import 'package:saudetv/app/services/client_http/dio_client_http.dart';

void main() async {
  const String baseUrl = 'http://api.saudetvpainel.com.br/api';
  final ClientHttpInterface clientHttp = DioClientHttp(Dio());
  ContentsRemoteDataSource dataSource =
      ContentsRemoteDataSource(baseURL: baseUrl, clientHttp: clientHttp);
  const String contentsID = '62a57e56a637692da8a154d5';
  const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmE1NzkzZTBmZDVlODAzZGQyZDY1MGYiLCJpYXQiOjE2NTYxMDE5MjR9.mV2tUP-OnmtOFsIFtl-UpMMgRebvrGRU12CZj3_mgYA';

  try {
    final result = await dataSource.getContents(contentsID, token);
    //print(result.contents);
    final List list = result.contents;
    //print(list.length);
  } catch (e) {
    //print(e);
  }
}
