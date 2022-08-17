import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/auth/presenter/page/widget/login_field.dart';
import 'package:saudetv/app/modules/auth/presenter/stores/login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerTerminal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final loginStore = context.read<LoginStore>();
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
            child: ValueListenableBuilder(
                valueListenable: loginStore.islogged,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      value
                          ? const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : LoginField(
                              controllerTerminal: controllerTerminal,
                              controllerPassword: controllerPassword,
                              controllerUser: controllerUser,
                              loginFunction: () {
                                loginStore.login();
                              },
                              loginIsVald: loginStore.erroMS.isEmpty,
                              onChangedPassword: loginStore.setPassword,
                              onChangedTerminal: loginStore.setTerminal,
                              onChangedUser: loginStore.setEmail,
                              errorMessage: loginStore.erroMS,
                            ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
