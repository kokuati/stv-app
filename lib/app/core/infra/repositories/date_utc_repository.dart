import 'package:saudetv/app/core/domain/repositories/date_utc_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/external/datasources/date_utc_remote_datasource.dart';
import 'package:saudetv/app/types/either.dart';

class DateUTCRepository extends IDateUTCRepository {
  final DateUTCRemoteDataSource1 remoteDataSource1;
  final DateUTCRemoteDataSource2 remoteDataSource2;
  DateUTCRepository({
    required this.remoteDataSource1,
    required this.remoteDataSource2,
  });

  @override
  Future<Either<HttpError, DateTime>> getDateUTC() async {
    try {
      final dateUtc = await remoteDataSource2.getDateUTC();
      return right(dateUtc);
    } catch (erro) {
      try {
        final dateUtc2 = await remoteDataSource1.getDateUTC();
        return right(dateUtc2);
      } catch (e) {
        if (e is int) {
          return left(HttpError(statusCode: e));
        } else {
          return left(HttpError(statusCode: 0));
        }
      }
    }
  }
}
