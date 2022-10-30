import 'package:saudetv/app/core/errors/errors.dart';

import '../../../types/either.dart';

abstract class ICoreRepository {
  Future<Either<Errors, bool>> deleteAll();
}
