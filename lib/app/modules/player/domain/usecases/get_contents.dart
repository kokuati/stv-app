import 'package:saudetv/app/core/domain/usecases/get_user.dart';
import 'package:saudetv/app/core/domain/usecases/read_user.dart';
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
      String contentsID, String token, bool isConnect, DateTime dateUTC);
}

class GetContents extends IGetContents {
  final IContentsRepository contentsRepository;
  final IReadUser readUser;
  final IGetUser getUser;
  final IReadContents readContents;
  final ISaveContents saveContents;
  final ISaveVideo saveVideo;
  GetContents({
    required this.contentsRepository,
    required this.readUser,
    required this.getUser,
    required this.readContents,
    required this.saveContents,
    required this.saveVideo,
  });

  @override
  Future<Either<Errors, ContentsEntity>> call(
      String contentsID, String token, bool isConnect, DateTime dateUTC) async {
    final readResult = await readContents(contentsID);
    return readResult.fold((empty) async {
      final result = await _getContents(contentsID, isConnect);
      return result.fold((l) => left(l), (model) async {
        if (model.type == Type.video) {
          final videoResult = await saveVideo(model, dateUTC);
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
      if (readEntity.type != Type.video) {
        final result = await _getContents(contentsID, isConnect);
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
      String contentsID, bool isConnect) async {
    if (isConnect) {
      final readResult = await readUser();
      return readResult.fold((l) {
        return left(ContentError(
            message: 'Ocorreu um erro. tente novamente mais tarde'));
      }, (readEntity) async {
        final result =
            await contentsRepository.getContents(contentsID, readEntity.token);
        return result.fold((error) async {
          if (error.statusCode == 400 || error.statusCode == 404) {
            final userResult = await getUser(
                readEntity.user, readEntity.password, readEntity.terminal);
            return userResult.fold(
                (l) => left(ContentError(
                    message: 'Ocorreu um erro. tente novamente mais tarde')),
                (newEntiy) async {
              final newResult = await contentsRepository.getContents(
                  contentsID, newEntiy.token);
              return newResult.fold(
                  (l) => left(ContentError(
                      message: 'Ocorreu um erro. tente novamente mais tarde')),
                  (entity) => right(entity));
            });
          } else {
            return left(ContentError(
                message: 'Ocorreu um erro. tente novamente mais tarde'));
          }
        }, (entity) async {
          return right(entity);
        });
      });
    } else {
      return left(Empty(message: 'Sem conexão a internet'));
    }
  }
}
