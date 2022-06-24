import 'package:dio/dio.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/infra/datasources/contents_remote_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';

class ContentsRemoteDataSource extends IContentsRemoteDataSource {
  final String baseURL;
  final ClientHttpInterface clientHttp;
  ContentsRemoteDataSource({
    required this.baseURL,
    required this.clientHttp,
  });
  @override
  Future<ContentsModel> getContents(String contentsID, String token) async {
    clientHttp.setBaseUrl(baseURL);
    clientHttp.setConnectTimeout(500000);
    clientHttp.setReceiveTimeout(500000);
    clientHttp.setHeaders({'Authorization': "Bearer $token"});

    try {
      final response = await clientHttp.get("/v1/contents/$contentsID");
      final data = response.data;
      final Type contentsType = fromType(data["data"]["type"]);
      dynamic contentsInfo = '';
      if (contentsType == Type.video) {
        contentsInfo = data["data"]["file"];
      } else if (contentsType == Type.rss) {
        contentsInfo = data["data"]["rss"];
      }
      final ContentsModel model = ContentsModel(
        id: contentsID,
        type: contentsType,
        contents: contentsInfo,
        updateData: DateTime.now(),
      );
      return model;
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }

  Type fromType(String type) {
    switch (type) {
      case 'VIDEO':
        return Type.video;
      case 'INSTAGRAN':
        return Type.intagran;
      case 'RSS':
        return Type.rss;
      case 'OUTROS':
        return Type.outros;
      default:
        return Type.outros;
    }
  }
}
