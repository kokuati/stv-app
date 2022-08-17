class ContentsEntity {
  final String id;
  final Type type;
  final dynamic contents;
  final DateTime updateData;
  ContentsEntity({
    required this.id,
    required this.type,
    required this.contents,
    required this.updateData,
  });
}

enum Type { video, rss, intagran, outros }
