import 'package:flutter/material.dart';

class ErrorBoxAlert extends StatelessWidget {
  final double heightScreen;
  final double widthScreen;
  final String errorMessage;
  const ErrorBoxAlert({
    Key? key,
    required this.heightScreen,
    required this.widthScreen,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.key_off,
            color: const Color.fromARGB(255, 89, 0, 0),
            size: heightScreen * 0.035,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            errorMessage,
            style: TextStyle(
              inherit: false,
              color: const Color.fromARGB(255, 89, 0, 0),
              fontSize: heightScreen * 0.022,
              fontFamily: 'Segoe',
            ),
          )
        ],
      ),
    );
  }
}
