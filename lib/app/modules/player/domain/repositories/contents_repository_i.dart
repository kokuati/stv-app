import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IContentsRepository {
  Future<Either<Errors, bool>> saveContents(ContentsEntity entity);
  Future<Either<Errors, ContentsEntity>> readContents(String contentsID);
  Future<Either<Errors, bool>> deleteContents(String contentsID);
  Future<Either<HttpError, ContentsModel>> getContents(
      String contentsID, String token);
}
