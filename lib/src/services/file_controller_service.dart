import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileControllerService {
  String videoPath;
  FileControllerService({
    required this.videoPath,
  });
  Future<String> getPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<String> getVideoPath() async {
    final String path = await getPath();
    return '$path$videoPath';
  }

  Future<void> createVideoFromBase64(String fileName, String base64) async {
    final String path = await getPath();
    final Directory videoDirectory = Directory('$path$videoPath');
    final bool videoPathExist = await videoDirectory.exists();
    if (!videoPathExist) {
      await videoDirectory.create();
    }
    final decodedBytes = base64Decode(base64);
    var fileVideo = File("$path$videoPath/$fileName");
    await fileVideo.writeAsBytes(decodedBytes);
  }

  Future<void> deleteVideo(String fileName) async {
    final String path = await getPath();
    File file = File('$path$videoPath/$fileName');
    file.delete();
  }

  Future<void> deleteVideoDirectory() async {
    final String path = await getPath();
    final Directory videoDirectory = Directory('$path$videoPath');
    final bool videoPathExist = await videoDirectory.exists();
    if (videoPathExist) {
      videoDirectory.deleteSync(recursive: true);
    }
  }
}
