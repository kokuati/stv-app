import 'package:flutter/material.dart';

import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/core/presenter/stores/splash_store.dart';
import 'package:saudetv/app/modules/auth/domain/usecases/login.dart';
import 'package:saudetv/app/modules/player/presenter/page/player_page.dart';

class LoginStore {
  final ILogin loginUsecase;
  final PageStore pageStore;
  final SplashStore splashStore;

  LoginStore({
    required this.loginUsecase,
    required this.pageStore,
    required this.splashStore,
  });

  String _email = '';
  String _password = '';
  String _terminal = '';
  String _erroMS = '';
  ValueNotifier<bool> islogged = ValueNotifier(false);
  ValueNotifier<int> textfield = ValueNotifier(0);

  String get email => _email;
  String get password => _password;
  String get terminal => _terminal;
  String get erroMS => _erroMS;

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setTerminal(String terminal) {
    _terminal = terminal;
  }

  void setErroMS(String erroMS) {
    _erroMS = erroMS;
  }

  Future<void> login() async {
    islogged.value = true;
    if (terminal.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        pageStore.isConnect) {
      final result = await loginUsecase.call(email, password, terminal);
      result.fold((error) {
        setErroMS(error.message);
      }, (loginSource) {
        pageStore.page.value = PlayerPage(loginSource: loginSource);
        splashStore.pageState.value = 'primeira';
      });
    } else {
      pageStore.isConnect
          ? setErroMS('Campo não preenchido')
          : setErroMS('Sem conexão com a internet');
    }
    islogged.value = false;
  }
}
