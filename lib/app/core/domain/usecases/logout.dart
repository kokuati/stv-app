import 'dart:io';

import 'package:saudetv/app/core/domain/repositories/core_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/services/get_path/get_path_interface.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ILogoutUserCase {
  Future<Either<Errors, bool>> call();
}

class LogoutUserCase extends ILogoutUserCase {
  final String videoPath;
  final GetPathInterface getPath;
  final ICoreRepository coreRepository;
  LogoutUserCase({
    required this.videoPath,
    required this.getPath,
    required this.coreRepository,
  });
  @override
  Future<Either<Errors, bool>> call() async {
    try {
      final Directory appDocDir = await getPath.getAppDocumentsDirectory();
      final Directory videoDir = Directory('${appDocDir.path}/$videoPath');
      final bool videoPathExist = await videoDir.exists();
      if (videoPathExist) {
        videoDir.deleteSync(recursive: true);
      }
      return await coreRepository.deleteAll();
    } catch (e) {
      return left(Empty(message: e.toString()));
    }
  }
}
