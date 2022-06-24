import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? textInputType;
  final Function(String)? onChanged;
  final bool? enabled;
  final String? initialText;
  final double heightFilde;
  final Color? color;

  const LoginTextField({
    Key? key,
    required this.text,
    required this.width,
    required this.height,
    this.controller,
    this.obscure = false,
    this.textInputType,
    this.onChanged,
    this.enabled,
    this.initialText,
    this.heightFilde = 80,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            inherit: false,
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'Segoe'),
      ),
      SizedBox(
        height: height * 0.01296296296,
      ),
      Container(
        width: width * 0.3125,
        height: height * 0.06296296296,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.2),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: textInputType,
          onChanged: onChanged,
          enabled: enabled,
          initialValue: initialText,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15.00,
              fontWeight: FontWeight.w700,
              fontFamily: 'Segoe',
              decoration: TextDecoration.none),
          decoration: const InputDecoration(
            hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 15.00,
                fontWeight: FontWeight.w700,
                fontFamily: 'Segoe',
                decoration: TextDecoration.none),
            border: InputBorder.none,
          ),
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}
