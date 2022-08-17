import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/contents_repository_i.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IReadContents {
  Future<Either<Errors, ContentsEntity>> call(String contentsID);
}

class ReadContents implements IReadContents {
  final IContentsRepository repository;

  ReadContents({required this.repository});

  @override
  Future<Either<ContentError, ContentsEntity>> call(String contentsID) async {
    final result = await repository.readContents(contentsID);
    return result.fold((error) {
      return left(ContentError(message: 'Conteudo não encontrado'));
    }, (entity) {
      return right(entity);
    });
  }
}
