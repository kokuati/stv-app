abstract class IVideoRemoteDataSource {
  Future<bool> getVideo(String link, String region, String service,
      String accessKey, String secretKey, String videoPath, DateTime dateUTC);
}
