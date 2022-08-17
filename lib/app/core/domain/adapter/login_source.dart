import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';
import 'package:saudetv/app/core/domain/entities/user_entity.dart';

class LoginSource {
  final UserEntity userEntity;
  final TerminalEntity terminalEntity;

  LoginSource(this.userEntity, this.terminalEntity);
}
