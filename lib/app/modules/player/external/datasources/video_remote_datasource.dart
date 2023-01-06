import 'package:dio/dio.dart';

import 'package:saudetv/app/modules/player/infra/datasources/video_remote_datasource_i.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';
import 'package:saudetv/app/types/aws_signature.dart';

class VideoRemoteDataSource extends IVideoRemoteDataSource {
  final String baseURL;
  final ClientHttpInterface clientHttp;
  final AWSSignature signature;
  VideoRemoteDataSource({
    required this.baseURL,
    required this.clientHttp,
    required this.signature,
  });

  @override
  Future<bool> getVideo(
      String link,
      String region,
      String service,
      String accessKey,
      String secretKey,
      String videoPath,
      DateTime dateUTC) async {
    final host = baseURL.substring(8);
    final url = link.substring(baseURL.length);
    final headers = signature.call(
        host, url, dateUTC, region, service, accessKey, secretKey);
    clientHttp.setBaseUrl(baseURL);
    clientHttp.setConnectTimeout((60000 * 100));
    clientHttp.setReceiveTimeout((60000 * 100));
    clientHttp.setHeaders(headers);
    try {
      final response = await clientHttp.download(url, videoPath);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }

  @override
  Future<bool> getVideo2(String videoID, String videoPath) async {
    clientHttp.setBaseUrl(
        'https://d2pq3l6f7cd6kz.cloudfront.net/contents/62beec1d8c2d825eafa5edf3/');
    clientHttp.setConnectTimeout((60000 * 100));
    clientHttp.setReceiveTimeout((60000 * 100));
    try {
      final response = await clientHttp.download('$videoID.mp4', videoPath);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}
