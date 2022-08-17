// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserEntity {
  final String user;
  final String password;
  final List<String> terminalList;
  final String terminal;
  final String token;
  final String logo;

  UserEntity({
    required this.user,
    required this.password,
    required this.terminalList,
    required this.terminal,
    required this.token,
    required this.logo,
  });

  bool terminalIsValid() {
    return terminalList.contains(terminal);
  }
}
