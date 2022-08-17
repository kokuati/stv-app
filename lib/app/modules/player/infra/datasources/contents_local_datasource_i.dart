import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';

abstract class IContentsLocalDataSource {
  Future<ContentsModel> readContents(String contentsID);
  Future<bool> saveContents(ContentsModel model);
  Future<bool> deleteContents(String contentsID);
}
