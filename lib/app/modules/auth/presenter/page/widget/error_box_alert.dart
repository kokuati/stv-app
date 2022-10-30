import 'package:flutter/material.dart';

class ErrorBoxAlert extends StatelessWidget {
  final String errorMessage;
  const ErrorBoxAlert({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.key_off,
            color: Colors.red[800],
            size: height * 0.035,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            errorMessage,
            style: TextStyle(
              inherit: false,
              fontWeight: FontWeight.w600,
              color: Colors.red[800],
              fontSize: height * 0.025,
              fontFamily: 'Segoe',
            ),
          )
        ],
      ),
    );
  }
}
