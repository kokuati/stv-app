import 'dart:io';

import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/repositories/video_repository_i.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/services/get_path/get_path_interface.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ISaveVideo {
  Future<Either<Errors, ContentsModel>> call(
      ContentsModel model, DateTime dateUTC);
}

class SaveVideo extends ISaveVideo {
  String videoPath;
  GetPathInterface getPath;
  IVideoRepository repository;
  SaveVideo({
    required this.videoPath,
    required this.getPath,
    required this.repository,
  });

  @override
  Future<Either<Errors, ContentsModel>> call(
      ContentsModel model, DateTime dateUTC) async {
    try {
      final Directory appDocDir = await getPath.getAppDocumentsDirectory();
      final Directory videoDir = Directory('${appDocDir.path}/$videoPath');
      final bool videoPathExist = await videoDir.exists();
      if (!videoPathExist) {
        await videoDir.create();
      }
      final link = model.contents;
      const region = 'us-east-1';
      const service = 's3';
      const accessKey = 'AKIATRFGPUANBE5JVM65';
      const secretKey = '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';
      final savePath = "${videoDir.path}/${model.id}.mp4";
      final wasDowload = await repository.getVideo(
          link, region, service, accessKey, secretKey, savePath, dateUTC);
      return wasDowload.fold((l) {
        return left(Empty(message: 'Não foi possivel salvar o video'));
      }, (r) {
        if (r) {
          return right(ContentsModel(
              id: model.id,
              type: model.type,
              contents: savePath,
              updateData: model.updateData));
        } else {
          return left(Empty(message: 'Não foi possivel salvar o video'));
        }
      });
    } catch (e) {
      return left(Empty(message: 'Não foi possivel salvar o video'));
    }
  }
}
