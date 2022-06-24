import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/contents_repository_i.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ISaveContents {
  Future<Either<Errors, bool>> call(ContentsEntity entity);
}

class SaveContents implements ISaveContents {
  final IContentsRepository repository;

  SaveContents({required this.repository});

  @override
  Future<Either<ContentError, bool>> call(ContentsEntity entity) async {
    final result = await repository.saveContents(entity);
    return result.fold((error) {
      return left(ContentError(message: 'Não foi possivel salvar'));
    }, (entity) => right(entity));
  }
}
