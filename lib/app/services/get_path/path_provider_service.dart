import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:saudetv/app/services/get_path/get_path_interface.dart';

class PathProviderService extends GetPathInterface {
  @override
  Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
}
