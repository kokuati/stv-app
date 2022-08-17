import 'package:saudetv/app/core/domain/adapter/login_source.dart';
import 'package:saudetv/app/core/domain/entities/user_entity.dart';
import 'package:saudetv/app/core/domain/usecases/get_user.dart';
import 'package:saudetv/app/core/domain/usecases/read_terminal.dart';
import 'package:saudetv/app/core/domain/usecases/read_user.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/modules/auth/presenter/page/login_page.dart';
import 'package:saudetv/app/modules/player/presenter/page/player_page.dart';

class SplashStore {
  final IReadUser readUser;
  final IReadTerminal readTerminal;
  final IGetUser getUser;
  final PageStore pageStore;

  SplashStore({
    required this.readUser,
    required this.readTerminal,
    required this.getUser,
    required this.pageStore,
  });

  Future<void> initializeApp() async {
    await pageStore.checkInternet();
    await Future.delayed(const Duration(seconds: 2));
    await pageStore.setDateUCT();
    final userResult = await readUser();
    userResult.fold((l) {
      pageStore.page.value = const LoginPage();
    }, (userEntity) async {
      if (pageStore.isConnect) {
        final getResult = await getUser(
            userEntity.user, userEntity.password, userEntity.terminal);
        getResult.fold((l) {
          pageStore.page.value = const LoginPage();
        }, (newUserEntity) async {
          terminal(newUserEntity);
        });
      } else {
        terminal(userEntity);
      }
    });
  }

  Future<void> terminal(UserEntity userEntity) async {
    final terminalResult = await readTerminal();
    terminalResult.fold((l) {
      pageStore.page.value = const LoginPage();
    }, (terminalEntity) {
      final LoginSource loginSource = LoginSource(userEntity, terminalEntity);
      pageStore.page.value = PlayerPage(loginSource: loginSource);
    });
  }
}
