import 'dart:convert';

import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';

class ContentsModel implements ContentsEntity {
  @override
  final String id;
  @override
  final Type type;
  @override
  final dynamic contents;
  @override
  final DateTime updateData;
  ContentsModel({
    required this.id,
    required this.type,
    required this.contents,
    required this.updateData,
  });

  Map<String, dynamic> toMap() {
    String toType(Type type) {
      switch (type) {
        case Type.video:
          return 'VIDEO';
        case Type.rss:
          return 'RSS';
        case Type.intagran:
          return 'INSTAGRAN';
        case Type.outros:
          return 'OUTROS';
        default:
          return 'OUTROS';
      }
    }

    return <String, dynamic>{
      'id': id,
      'type': toType(type),
      'contents': contents,
      'updateData': updateData.millisecondsSinceEpoch,
    };
  }

  factory ContentsModel.fromMap(Map<String, dynamic> map) {
    Type fromType(String type) {
      switch (type) {
        case 'VIDEO':
          return Type.video;
        case 'INSTAGRAN':
          return Type.intagran;
        case 'RSS':
          return Type.rss;
        case 'OUTROS':
          return Type.outros;
        default:
          return Type.outros;
      }
    }

    return ContentsModel(
      id: map['id'] ?? '',
      type: fromType(map['type']),
      contents: map['contents'] ?? '',
      updateData:
          DateTime.fromMillisecondsSinceEpoch(map['updateData']?.toInt() ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContentsModel.fromJson(String source) =>
      ContentsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
