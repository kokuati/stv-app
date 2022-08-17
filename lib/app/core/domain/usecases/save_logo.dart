import 'dart:convert';
import 'dart:io';

import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/services/get_path/get_path_interface.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ISaveLogo {
  Future<Either<Errors, String>> call(String logo);
}

class SaveLogo extends ISaveLogo {
  final GetPathInterface getPath;
  SaveLogo({
    required this.getPath,
  });

  @override
  Future<Either<Errors, String>> call(String logo) async {
    try {
      final Directory appDocDir = await getPath.getAppDocumentsDirectory();
      final String base64 = logo.substring(logo.lastIndexOf(',') + 1);
      final decodedBytes = base64Decode(base64);
      final type = logo.substring((logo.indexOf('/') + 1), (logo.indexOf(';')));
      var fileLogo = File("${appDocDir.path}/logo.$type");
      await fileLogo.writeAsBytes(decodedBytes);
      return right(fileLogo.path);
    } catch (e) {
      return left(Empty());
    }
  }
}
