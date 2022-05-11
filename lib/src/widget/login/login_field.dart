import 'package:flutter/material.dart';
import 'package:saudetv/src/widget/login/login_textfield.dart';
import 'package:saudetv/src/widget/login/password_box_alert.dart';

class LoginField extends StatelessWidget {
  final TextEditingController controllerTerminal;
  final Function(String) onChanged;
  final Function() loginFunction;
  final bool loginIsVald;
  const LoginField({
    Key? key,
    required this.controllerTerminal,
    required this.onChanged,
    required this.loginFunction,
    required this.loginIsVald,
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
            text: 'TERMINAL',
            height: height,
            width: width,
            controller: controllerTerminal,
            onChanged: onChanged,
          ),
          loginIsVald
              ? SizedBox(
                  height: height * 0.095,
                )
              : SizedBox(
                  height: height * 0.095,
                  child: Column(children: [
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.topCenter,
                      child: PasswordBoxAlert(
                        heightScreen: height,
                        widthScreen: width,
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
