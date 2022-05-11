import 'package:flutter/material.dart';
import 'package:saudetv/src/page/player_page.dart';
import 'package:saudetv/src/repositories/repository.dart';
import 'package:saudetv/src/stores/core_store.dart';

class LoginStore {
  IRepository repository;
  CoreStore coreStore;
  LoginStore({
    required this.repository,
    required this.coreStore,
  });

  String _terminal = '';
  bool _terminalIsVald = true;
  ValueNotifier<bool> islogged = ValueNotifier(false);

  bool get loginIsVald => _terminalIsVald;
  String get terminal => _terminal;

  void setTerminal(String terminal) {
    _terminal = terminal;
  }

  Future<void> login(String terminal) async {
    if (terminal.isNotEmpty) {
      await coreStore.checkInternet();
      if (coreStore.isConnect.value) {
        islogged.value = true;
        final resultTerminal = await repository.getTerminalInfo(terminal);
        resultTerminal.fold((l) {
          _terminalIsVald = false;
          islogged.value = false;
        }, (terminalModel) async {
          final bool resultStart = await coreStore.startTerminal(terminalModel);
          islogged.value = false;
          if (resultStart) {
            coreStore.page.value = const PlayerPage();
          }
        });
      }
    }
  }
}
