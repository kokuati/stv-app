import 'package:flutter/material.dart';
import 'package:saudetv/app/modules/auth/presenter/page/widget/error_box_alert.dart';
import 'package:saudetv/app/modules/auth/presenter/page/widget/login_textfield.dart';

class LoginField extends StatelessWidget {
  final TextEditingController controllerUser;
  final TextEditingController controllerPassword;
  final TextEditingController controllerTerminal;
  final Function(String) onChangedUser;
  final Function(String) onChangedPassword;
  final Function(String) onChangedTerminal;
  final Function() loginFunction;
  final bool loginIsVald;
  final String errorMessage;
  const LoginField({
    Key? key,
    required this.controllerUser,
    required this.controllerPassword,
    required this.controllerTerminal,
    required this.onChangedUser,
    required this.onChangedPassword,
    required this.onChangedTerminal,
    required this.loginFunction,
    required this.loginIsVald,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoginTextField(
            text: 'EMAIL',
            height: height,
            width: width,
            controller: controllerUser,
            onChanged: onChangedUser,
          ),
          SizedBox(
            height: height * 0.055,
          ),
          LoginTextField(
            text: 'SENHA',
            height: height,
            width: width,
            controller: controllerPassword,
            onChanged: onChangedPassword,
          ),
          SizedBox(
            height: height * 0.055,
          ),
          LoginTextField(
            text: 'TERMINAL',
            height: height,
            width: width,
            controller: controllerTerminal,
            onChanged: onChangedTerminal,
          ),
          loginIsVald
              ? SizedBox(
                  height: height * 0.055,
                )
              : SizedBox(
                  height: height * 0.055,
                  child: Column(children: [
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.topCenter,
                      child: ErrorBoxAlert(
                        heightScreen: height,
                        widthScreen: width,
                        errorMessage: errorMessage,
                      ),
                    ))
                  ]),
                ),
          GestureDetector(
            onTap: loginFunction,
            child: Container(
              height: height * 0.09537037037,
              width: width * 0.1973958333,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF3BC3FF),
                borderRadius: BorderRadius.circular(height * 0.01),
              ),
              child: const Text(
                'Entrar',
                textAlign: TextAlign.center,
                style: TextStyle(
                    inherit: false,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Segoe'),
              ),
            ),
          )
        ]);
  }
}
