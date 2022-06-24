import 'dart:io';

abstract class GetPathInterface {
  Future<Directory> getAppDocumentsDirectory();
}
