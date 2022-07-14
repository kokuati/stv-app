void main() async {
  const model =
      'https://s2.glbimg.com/spRhXuG-cOuC81yzUQD-RpokDsg=/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2022/m/A/DfMB1UROyzmKEBjtSJjw/prfrr.jpeg';

  bool isImage(String urlImage) {
    const List<String> imageType = [
      'JPEG',
      'PNG',
      'GIF',
      'WebP',
      'BMP',
      'WBMP'
    ];
    final String type = urlImage.substring(urlImage.lastIndexOf('.') + 1);
    return imageType.contains(type.toUpperCase());
  }

  final object = isImage(model);

  print(object);
}
