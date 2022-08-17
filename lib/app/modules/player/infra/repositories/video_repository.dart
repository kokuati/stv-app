import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/repositories/video_repository_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/video_remote_datasource_i.dart';
import 'package:saudetv/app/types/either.dart';

class VideoRepository extends IVideoRepository {
  final IVideoRemoteDataSource remoteDataSource;
  VideoRepository({
    required this.remoteDataSource,
  });

  @override
  Future<Either<HttpError, bool>> getVideo(
      String link,
      String region,
      String service,
      String accessKey,
      String secretKey,
      String videoPath,
      DateTime dateUTC) async {
    try {
      return right(await remoteDataSource.getVideo(
          link, region, service, accessKey, secretKey, videoPath, dateUTC));
    } catch (e) {
      if (e is int) {
        return left(HttpError(statusCode: e));
      } else {
        return left(HttpError(statusCode: 0));
      }
    }
  }
}
