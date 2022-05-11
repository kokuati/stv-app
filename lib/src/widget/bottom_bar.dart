import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class BottonBar extends StatelessWidget {
  final Function getSystemTime;
  final Function getSystemWeek;
  final Function getSystemDay;
  final String weatherMax;
  final String weatherMin;
  final String weatherIcon;
  const BottonBar({
    Key? key,
    required this.getSystemTime,
    required this.getSystemWeek,
    required this.getSystemDay,
    required this.weatherMax,
    required this.weatherMin,
    required this.weatherIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      height: heightScreen * 0.1240740741,
      width: widthScreen,
      decoration: const BoxDecoration(
        color: Color(0xFF008E82),
      ),
      child: Row(
        children: [
          SizedBox(
            width: (widthScreen * 0.03),
          ),
          TimerBuilder.periodic(const Duration(minutes: 1), builder: (context) {
            return Text(
              "${getSystemTime()}",
              textAlign: TextAlign.end,
              style: const TextStyle(
                  inherit: false,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Segoe'),
            );
          }),
          SizedBox(
            width: (widthScreen * 0.055),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${getSystemWeek()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    inherit: false,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Segoe'),
              ),
              Text(
                "${getSystemDay()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    inherit: false,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Segoe'),
              )
            ],
          ),
          SizedBox(
            width: (widthScreen * 0.055),
          ),
          weatherMax.isNotEmpty && weatherMin.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "$weatherMin˚",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          inherit: false,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Segoe'),
                    ),
                    Text(
                      "$weatherMax˚",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          inherit: false,
                          color: Color(0xFFF94D4D),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Segoe'),
                    )
                  ],
                )
              : const SizedBox(),
          SizedBox(
            width: (widthScreen * 0.013),
          ),
          weatherMax.isNotEmpty && weatherMin.isNotEmpty
              ? Image.asset(
                  'images/$weatherIcon.png',
                  height: heightScreen * 0.055,
                )
              : const SizedBox(),
          const Expanded(child: SizedBox()),
          Image.asset(
            'images/saudetv.png',
            width: widthScreen * 0.13,
          ),
          SizedBox(
            width: (widthScreen * 0.03),
          ),
        ],
      ),
    );
  }
}
