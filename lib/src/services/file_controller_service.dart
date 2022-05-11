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
    final String _getPath = await getPath();
    return '$_getPath$videoPath';
  }

  Future<void> createVideoFromBase64(String fileName, String base64) async {
    final String _getPath = await getPath();
    final Directory _videoPath = Directory('$_getPath$videoPath');
    final bool _videoPathExist = await _videoPath.exists();
    if (!_videoPathExist) {
      await _videoPath.create();
    }
    final decodedBytes = base64Decode(base64);
    var fileVideo = File("$_getPath$videoPath/$fileName");
    await fileVideo.writeAsBytes(decodedBytes);
  }

  Future<void> deleteVideo(String fileName) async {
    final String _getPath = await getPath();
    File file = File('$_getPath$videoPath/$fileName');
    file.delete();
  }

  Future<void> deleteVideoDirectory() async {
    final String _getPath = await getPath();
    final Directory _videoPath = Directory('$_getPath$videoPath');
    final bool _videoPathExist = await _videoPath.exists();
    if (_videoPathExist) {
      _videoPath.deleteSync(recursive: true);
    }
  }
}
