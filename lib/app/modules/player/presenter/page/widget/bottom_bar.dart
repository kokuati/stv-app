import 'package:flutter/material.dart';
import 'package:saudetv/app/modules/player/domain/entities/weather_entity.dart';
import 'package:timer_builder/timer_builder.dart';

class BottonBar extends StatelessWidget {
  final Function getSystemTime;
  final Function getSystemWeek;
  final Function getSystemDay;
  final ValueNotifier<WeatherEntity> weatherEntity;
  const BottonBar({
    Key? key,
    required this.getSystemTime,
    required this.getSystemWeek,
    required this.getSystemDay,
    required this.weatherEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      height: heightScreen * 0.11111111,
      width: widthScreen,
      decoration: const BoxDecoration(
        color: Color.fromARGB(40, 255, 255, 255),
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
                  color: Color.fromARGB(255, 40, 40, 40),
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
                    color: Color.fromARGB(255, 40, 40, 40),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Segoe'),
              ),
              Text(
                "${getSystemDay()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    inherit: false,
                    color: Color.fromARGB(255, 40, 40, 40),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Segoe'),
              )
            ],
          ),
          SizedBox(
            width: (widthScreen * 0.055),
          ),
          ValueListenableBuilder(
              valueListenable: weatherEntity,
              builder: (BuildContext context, WeatherEntity weatherEntity,
                  Widget? child) {
                return weatherEntity.tempMax.isNotEmpty &&
                        weatherEntity.tempMin.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${weatherEntity.tempMin}˚",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                inherit: false,
                                color: Color.fromARGB(255, 40, 40, 40),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Segoe'),
                          ),
                          Text(
                            "${weatherEntity.tempMax}˚",
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
                    : const SizedBox();
              }),
          SizedBox(
            width: (widthScreen * 0.013),
          ),
          ValueListenableBuilder(
              valueListenable: weatherEntity,
              builder: (BuildContext context, WeatherEntity weatherEntity,
                  Widget? child) {
                return weatherEntity.tempMax.isNotEmpty &&
                        weatherEntity.tempMin.isNotEmpty
                    ? Image.asset(
                        'images/${weatherEntity.icon}.png',
                        height: heightScreen * 0.055,
                      )
                    : const SizedBox();
              }),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: (widthScreen * 0.03),
          ),
        ],
      ),
    );
  }
}
