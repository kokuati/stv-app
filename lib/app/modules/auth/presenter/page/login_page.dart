import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/modules/auth/presenter/stores/login_store.dart';
import 'package:saudetv/app/modules/player/presenter/page/player_page.dart';

import 'widget/bottun_text_field.dart';
import 'widget/error_box_alert.dart';
import 'widget/main_text_field.dart';

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
  FocusNode focusUser = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusTerminal = FocusNode();

  @override
  void initState() {
    final pageStore = context.read<PageStore>();
    pageStore.page.addListener(() {
      if (pageStore.page.value is PlayerPage) {
        Navigator.popAndPushNamed(context, '/page');
      }
    });
    super.initState();
  }

  void _goToForm(bool isKeyboard, LoginStore loginStore) {
    if (!isKeyboard && loginStore.textfield.value != 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      loginStore.textfield.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final loginStore = context.read<LoginStore>();
    _goToForm(isKeyboard, loginStore);
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Stack(
            children: [
              Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                child: Image(
                  height: height,
                  image: const AssetImage('images/fundo_login.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                color: const Color.fromARGB(140, 0, 0, 0),
              ),
              SizedBox(
                height: height,
                width: width,
                child: ValueListenableBuilder(
                    valueListenable: loginStore.islogged,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Container(
                          alignment: Alignment.center,
                          child: value
                              ? const SizedBox(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : ValueListenableBuilder(
                                  valueListenable: loginStore.textfield,
                                  builder: (BuildContext context, int value,
                                      Widget? child) {
                                    if (value == 1) {
                                      focusUser.requestFocus();
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: height * 0.2,
                                          ),
                                          MainTextField(
                                            height: height * 0.06,
                                            width: width * 0.3,
                                            fieldTitle: 'EMAIL',
                                            controller: controllerUser,
                                            focusNode: focusUser,
                                            onChanged: loginStore.setEmail,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            onSubmitted: (p0) async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              loginStore.textfield.value = 2;
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    if (value == 2) {
                                      focusPassword.requestFocus();
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: height * 0.2,
                                          ),
                                          MainTextField(
                                            height: height * 0.06,
                                            width: width * 0.3,
                                            fieldTitle: 'SENHA',
                                            controller: controllerPassword,
                                            focusNode: focusPassword,
                                            onChanged: loginStore.setPassword,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            onSubmitted: (p0) async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              loginStore.textfield.value = 3;
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    if (value == 3) {
                                      focusTerminal.requestFocus();
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: height * 0.2,
                                          ),
                                          MainTextField(
                                            height: height * 0.06,
                                            width: width * 0.3,
                                            fieldTitle: 'TERMINAL',
                                            controller: controllerTerminal,
                                            focusNode: focusTerminal,
                                            onChanged: loginStore.setTerminal,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.done,
                                            onSubmitted: (p0) async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              loginStore.login();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    return _forme(context);
                                  },
                                ));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forme(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final loginStore = context.read<LoginStore>();

    return Column(
      children: [
        SizedBox(
          height: height * 0.04,
        ),
        Image(
          image: const AssetImage('images/saudetv.png'),
          height: height * 0.19,
        ),
        SizedBox(
          height: height * 0.03,
        ),
        const Text(
          'ASSUMA O CONTROLE DA SUA TV',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        SizedBox(
          height: height * 0.05,
        ),
        ButtonTextField(
          height: height * 0.06,
          width: width * 0.3,
          fieldTitle: 'EMAIL',
          controller: controllerUser,
          onTap: () {
            loginStore.textfield.value = 1;
          },
        ),
        SizedBox(
          height: height * 0.03,
        ),
        ButtonTextField(
          height: height * 0.06,
          width: width * 0.3,
          fieldTitle: 'SENHA',
          controller: controllerPassword,
          onTap: () {
            loginStore.textfield.value = 2;
          },
        ),
        SizedBox(
          height: height * 0.03,
        ),
        ButtonTextField(
          height: height * 0.06,
          width: width * 0.3,
          fieldTitle: 'TERMINAL',
          controller: controllerTerminal,
          onTap: () {
            loginStore.textfield.value = 3;
          },
        ),
        loginStore.erroMS.isEmpty
            ? SizedBox(
                height: height * 0.055,
              )
            : Container(
                height: height * 0.055,
                alignment: Alignment.center,
                child: ErrorBoxAlert(
                  errorMessage: loginStore.erroMS,
                ),
              ),
        GestureDetector(
          onTap: loginStore.login,
          child: Container(
            height: height * 0.09537037037,
            width: width * 0.1973958333,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xB3343360),
              borderRadius: BorderRadius.circular(height * 0.01),
            ),
            child: const Text(
              'ENTRAR',
              textAlign: TextAlign.center,
              style: TextStyle(
                inherit: false,
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }
}
