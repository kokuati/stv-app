import 'package:flutter/material.dart';

class InterntBoxAlert extends StatelessWidget {
  final double heightScreen;
  final double widthScreen;
  const InterntBoxAlert({
    Key? key,
    required this.heightScreen,
    required this.widthScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightScreen * 0.07,
      width: widthScreen * 0.16,
      decoration: BoxDecoration(
        color: const Color.fromARGB(185, 158, 158, 158),
        borderRadius: BorderRadius.circular(
          heightScreen * 0.025,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.black,
            size: heightScreen * 0.04,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'Sem Internet',
            style: TextStyle(
              inherit: false,
              color: Colors.black,
              fontSize: heightScreen * 0.025,
              fontFamily: 'Segoe',
            ),
          )
        ],
      ),
    );
  }
}
