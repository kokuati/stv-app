import 'dart:io';

import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/contents_repository_i.dart';
import 'package:saudetv/app/modules/player/domain/usecases/read_contents.dart';

abstract class IDeleteContents {
  Future<bool> call(String contentsID);
}

class DeleteContents extends IDeleteContents {
  final IReadContents readContents;
  final IContentsRepository repository;
  DeleteContents({
    required this.readContents,
    required this.repository,
  });

  @override
  Future<bool> call(String contentsID) async {
    final readResult = await readContents(contentsID);
    return readResult.fold((l) => true, (contentsEntity) async {
      if (contentsEntity.type == Type.video) {
        await _deleteVideo(contentsEntity);
      }
      final delContentsResult = await repository.deleteContents(contentsID);
      return delContentsResult.fold((l) => false, (r) => true);
    });
  }

  Future<void> _deleteVideo(ContentsEntity contentsEntity) async {
    final Directory videoDirectory = Directory('${contentsEntity.contents}');
    final bool videoPathExist = await videoDirectory.exists();
    if (videoPathExist) {
      videoDirectory.deleteSync(recursive: true);
    }
  }
}
