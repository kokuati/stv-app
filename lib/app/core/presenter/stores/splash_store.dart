import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:saudetv/app/core/domain/adapter/login_source.dart';
import 'package:saudetv/app/core/domain/entities/user_entity.dart';
import 'package:saudetv/app/core/domain/usecases/get_user.dart';
import 'package:saudetv/app/core/domain/usecases/logout.dart';
import 'package:saudetv/app/core/domain/usecases/read_terminal.dart';
import 'package:saudetv/app/core/domain/usecases/read_user.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/modules/player/presenter/page/player_page.dart';

class SplashStore {
  final IReadUser readUser;
  final IReadTerminal readTerminal;
  final IGetUser getUser;
  final PageStore pageStore;

  final ILogoutUserCase logoutUserCase;

  SplashStore({
    required this.readUser,
    required this.readTerminal,
    required this.getUser,
    required this.pageStore,
    required this.logoutUserCase,
  });

  ValueNotifier<String> pageState = ValueNotifier('splash');

  Future<void> logout() async {
    final result = await logoutUserCase();
    result.fold(
      (l) => log(l.toString()),
      (r) {
        if (r) {
          pageState.value = 'login';
        } else {
          log('Erro no logout');
        }
      },
    );
  }

  Future<void> initializeApp() async {
    await pageStore.checkInternet();
    await Future.delayed(const Duration(seconds: 2));
    await pageStore.setDateUCT();
    final userResult = await readUser();
    userResult.fold(
      (l) {
        pageState.value = 'login';
      },
      (userEntity) async {
        if (pageStore.isConnect) {
          final getResult = await getUser(
              userEntity.user, userEntity.password, userEntity.terminal);
          getResult.fold(
            (l) {
              if (l.message == 'Usuário e/ou senha inválidos') {
                pageState.value = 'login';
              } else {
                terminal(userEntity);
              }
            },
            (newUserEntity) async {
              terminal(newUserEntity);
            },
          );
        } else {
          terminal(userEntity);
        }
      },
    );
  }

  Future<void> terminal(UserEntity userEntity) async {
    final terminalResult = await readTerminal();
    terminalResult.fold(
      (l) {
        pageState.value = 'login';
      },
      (terminalEntity) {
        final LoginSource loginSource = LoginSource(userEntity, terminalEntity);
        pageStore.page.value = PlayerPage(loginSource: loginSource);
        pageState.value = 'page';
      },
    );
  }
}
