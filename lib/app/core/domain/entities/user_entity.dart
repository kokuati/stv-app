class UserEntity {
  final String user;
  final String password;
  final List<String> terminalList;
  final String terminal;
  final String token;

  UserEntity({
    required this.user,
    required this.password,
    required this.terminalList,
    required this.terminal,
    required this.token,
  });

  bool terminalIsValid() {
    return terminalList.contains(terminal);
  }
}
