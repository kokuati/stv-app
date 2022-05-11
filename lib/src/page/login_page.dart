import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/src/stores/core_store.dart';
import 'package:saudetv/src/stores/login_store.dart';
import 'package:saudetv/src/widget/login/internet_box_alert.dart';
import 'package:saudetv/src/widget/login/login_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerTerminal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final loginStore = context.read<LoginStore>();
    final coreStore = context.read<CoreStore>();
    return Scaffold(
      body: Container(
        color: const Color(0xFF008E82),
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ValueListenableBuilder(
                    valueListenable: loginStore.islogged,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return value
                          ? const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : LoginField(
                              controllerTerminal: controllerTerminal,
                              loginFunction: () {
                                loginStore.login(loginStore.terminal);
                              },
                              loginIsVald: loginStore.loginIsVald,
                              onChanged: loginStore.setTerminal,
                            );
                    }),
                ValueListenableBuilder(
                  valueListenable: coreStore.isConnect,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Positioned(
                        top: height * 0.05,
                        right: width * 0.05,
                        child: value
                            ? const SizedBox()
                            : InterntBoxAlert(
                                heightScreen: height,
                                widthScreen: width,
                              ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
