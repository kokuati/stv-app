import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IDateUTCRepository {
  Future<Either<HttpError, DateTime>> getDateUTC();
}
