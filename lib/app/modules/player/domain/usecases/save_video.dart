import 'dart:convert';
import 'dart:io';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/services/get_path/get_path_interface.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ISaveVideo {
  Future<Either<Errors, ContentsModel>> call(ContentsModel model);
}

class SaveVideo extends ISaveVideo {
  String videoPath;
  GetPathInterface getPath;
  SaveVideo({
    required this.videoPath,
    required this.getPath,
  });

  @override
  Future<Either<Errors, ContentsModel>> call(ContentsModel model) async {
    try {
      final Directory appDocDir = await getPath.getAppDocumentsDirectory();
      final Directory videoDir = Directory('${appDocDir.path}/$videoPath');
      final bool videoPathExist = await videoDir.exists();
      if (!videoPathExist) {
        await videoDir.create();
      }
      final String base64 =
          model.contents.substring(model.contents.lastIndexOf(',') + 1);
      final decodedBytes = base64Decode(base64);
      var fileVideo = File("${videoDir.path}/${model.id}.mp4");
      await fileVideo.writeAsBytes(decodedBytes);
      return right(ContentsModel(
          id: model.id,
          type: model.type,
          contents: fileVideo.path,
          updateData: model.updateData));
    } catch (e) {
      return left(Empty(message: 'Não foi possivel salvar o video'));
    }
  }
}
