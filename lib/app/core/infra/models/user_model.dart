// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:saudetv/app/core/domain/entities/user_entity.dart';

class UserModel implements UserEntity {
  @override
  final String user;
  @override
  final String password;
  @override
  final List<String> terminalList;
  @override
  final String terminal;
  @override
  final String token;
  UserModel({
    required this.user,
    required this.password,
    required this.terminalList,
    required this.terminal,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'password': password,
      'terminalList': terminalList,
      'terminal': terminal,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user: map['user'] ?? '',
      password: map['password'] ?? '',
      terminalList: List<String>.from(map['terminalList']),
      terminal: map['terminal'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool terminalIsValid() {
    return terminalList.contains(terminal);
  }
}
