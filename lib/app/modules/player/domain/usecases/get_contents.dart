import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/contents_repository_i.dart';
import 'package:saudetv/app/modules/player/domain/usecases/read_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/save_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/save_video.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IGetContents {
  Future<Either<Errors, ContentsEntity>> call(
      String contentsID, String token, bool isConnect);
}

class GetContents extends IGetContents {
  final IContentsRepository contentsRepository;
  final IReadContents readContents;
  final ISaveContents saveContents;
  final ISaveVideo saveVideo;
  GetContents({
    required this.contentsRepository,
    required this.readContents,
    required this.saveContents,
    required this.saveVideo,
  });

  @override
  Future<Either<Errors, ContentsEntity>> call(
      String contentsID, String token, bool isConnect) async {
    final readResult = await readContents(contentsID);
    return readResult.fold((empty) async {
      final result = await _getContents(contentsID, token, isConnect);
      return result.fold((l) => left(l), (model) async {
        if (model.type == Type.video) {
          final videoResult = await saveVideo(model);
          return videoResult.fold((l) => left(l), (r) async {
            await saveContents(r);
            return right(r);
          });
        } else {
          await saveContents(model);
          return right(model);
        }
      });
    }, (readEntity) async {
      if (readEntity.type != Type.video && !_isSameDay(readEntity.updateData)) {
        final result = await _getContents(contentsID, token, isConnect);
        return result.fold((l) => left(l), (r) async {
          await saveContents(r);
          return right(r);
        });
      } else {
        return right(readEntity);
      }
    });
  }

  Future<Either<Errors, ContentsModel>> _getContents(
      String contentsID, String token, bool isConnect) async {
    if (isConnect) {
      final result = await contentsRepository.getContents(contentsID, token);
      return result.fold((error) {
        if (error.statusCode == 400 || error.statusCode == 404) {
          return left(ContentError(message: 'Conteudo inválidos'));
        } else {
          return left(ContentError(
              message: 'Ocorreu um erro. tente novamente mais tarde'));
        }
      }, (entity) async {
        return right(entity);
      });
    } else {
      return left(Empty(message: 'Sem conexão a internet'));
    }
  }

  bool _isSameDay(DateTime date) {
    DateTime toDate = DateTime.now();
    return toDate.year == date.year &&
        toDate.month == date.month &&
        toDate.day == date.day;
  }
}
