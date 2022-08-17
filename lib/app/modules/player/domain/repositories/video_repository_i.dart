import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IVideoRepository {
  Future<Either<HttpError, bool>> getVideo(
      String link,
      String region,
      String service,
      String accessKey,
      String secretKey,
      String videoPath,
      DateTime dateUTC);
}
