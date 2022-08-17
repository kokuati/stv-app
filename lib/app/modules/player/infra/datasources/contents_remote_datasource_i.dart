import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';

abstract class IContentsRemoteDataSource {
  Future<ContentsModel> getContents(String contentsID, String token);
}
