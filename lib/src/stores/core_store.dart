import 'dart:io';
import 'package:flutter/material.dart';
import 'package:saudetv/src/errors/errors.dart';
import 'package:saudetv/src/model/terminal_model.dart';
import 'package:saudetv/src/model/weather_model.dart';
import 'package:saudetv/src/page/login_page.dart';
import 'package:saudetv/src/page/player_page.dart';
import 'package:saudetv/src/page/splash_page.dart';
import 'package:saudetv/src/repositories/repository.dart';
import 'package:saudetv/src/services/check_internet_service.dart';
import 'package:saudetv/src/services/file_controller_service.dart';

class CoreStore {
  CheckInternetService checkInternetService;
  FileControllerService fileControllerService;
  IRepository repository;

  CoreStore({
    required this.checkInternetService,
    required this.fileControllerService,
    required this.repository,
  });

  ValueNotifier<Widget> page = ValueNotifier(const SplashPage());
  ValueNotifier<bool> isConnect = ValueNotifier(true);
  ValueNotifier<int> indexVideo = ValueNotifier(0);
  ValueNotifier<WeatherModel> weatherModel =
      ValueNotifier(WeatherModel(id: 0, icon: '', tempMin: '', tempMax: ''));
  late TerminalModel _terminalModel;
  bool _runVideoUpdate = false;
  List<String> _videosList = [];
  List<String> _videosToDelete = [];
  int _timeCourse = 60;
  bool _bottonBar = false;
  String _videoPath = '';

  TerminalModel get terminalModel => _terminalModel;

  void setTerminalModel(TerminalModel terminalModel) {
    _terminalModel = terminalModel;
  }

  List<String> get videosList => _videosList;

  void setVideosList(List<String> videosList) {
    _videosList = videosList;
  }

  int get timeCourse => _timeCourse;

  bool get bottonBar => _bottonBar;

  String get videoPath => _videoPath;

  Future<void> checkInternet() async {
    isConnect.value = await checkInternetService.checkInternet();
  }

  Future<TerminalModel> getTerminalModel() async {
    final result = await repository.getTerminalModel();
    return result.fold((l) {
      throw l;
    }, (r) => r);
  }

  Future<List<String>> buildVideosList(TerminalModel terminalModel) async {
    final List videoList = terminalModel.plalist;
    final List<String> resultList = [];
    for (var video in videoList) {
      final bool videoExist = await File("$_videoPath/$video.mp4").exists();
      if (videoExist) {
        resultList.add(video);
      }
    }
    return resultList;
  }

  Future<void> initializeApp() async {
    await checkInternet();
    try {
      _videoPath = await fileControllerService.getVideoPath();
      _terminalModel = await getTerminalModel();
      _videosList = await buildVideosList(_terminalModel);
      _timeCourse = _terminalModel.updateTimeCourseMin;
      _bottonBar = _terminalModel.hasBar;
      if (isConnect.value) {
        weatherModel.value = await getWeather(_terminalModel);
      }
      page.value = const PlayerPage();
    } catch (e) {
      page.value = const LoginPage();
    }
  }

  Future<bool> startTerminal(TerminalModel terminalModel) async {
    _terminalModel = terminalModel;
    _videosList = _terminalModel.plalist;
    _timeCourse = _terminalModel.updateTimeCourseMin;
    _bottonBar = _terminalModel.hasBar;
    final List<String> delList = [];
    await fileControllerService.deleteVideoDirectory();
    for (var videoId in _videosList) {
      final resultVideo = await repository.downloadVideo(videoId);
      resultVideo.fold((l) {
        delList.add(videoId);
      }, (r) => null);
    }
    if (delList.isNotEmpty) {
      for (var videoId in delList) {
        _terminalModel.plalist.remove(videoId);
        _videosList.remove(videoId);
      }
    }
    await repository.saveTerminalModel(_terminalModel);
    if (isConnect.value) {
      weatherModel.value = await getWeather(_terminalModel);
    }
    return true;
  }

  Future<void> videoUpdate() async {
    final dayTime = DateTime.now();
    final updateStart = DateTime(dayTime.year, dayTime.month, dayTime.day,
        _terminalModel.updateStartHour, _terminalModel.updateStartMinute);
    final updateEnd = DateTime(dayTime.year, dayTime.month, dayTime.day,
        _terminalModel.updateEndHour, _terminalModel.updateEndMinute);
    if (dayTime.isAfter(updateStart) && dayTime.isBefore(updateEnd)) {
      if (!_runVideoUpdate) {
        _runVideoUpdate = true;
        final oldTimeCourse = _timeCourse;
        final oldBottonBar = _bottonBar;
        await checkInternet();
        if (isConnect.value) {
          final resultTerminal =
              await repository.getTerminalInfo(_terminalModel.id);
          resultTerminal.fold((l) {
            if (l is TerminalError) {
              if (l.statusCode == 404 || l.statusCode == 400) {
                page.value = const LoginPage();
              }
            }
          }, (terminalModel) async {
            final List<String> newList = terminalModel.plalist;
            final List<String> delList = [];
            for (var videoId in newList) {
              bool videoHasOnCache = _videosList.contains(videoId);
              if (!videoHasOnCache) {
                final resultVideo = await repository.downloadVideo(videoId);
                resultVideo.fold((l) {
                  delList.add(videoId);
                }, (r) => null);
              }
            }
            for (var videoId in _videosList) {
              bool videoHasOnServer = newList.contains(videoId);
              if (!videoHasOnServer) {
                final int indexTheVideo =
                    _videosList.indexWhere((element) => element == videoId);
                if (indexTheVideo == indexVideo.value) {
                  _videosToDelete.add(videoId);
                } else {
                  await fileControllerService.deleteVideo('$videoId.mp4');
                }
              }
            }
            if (delList.isNotEmpty) {
              for (var videoId in delList) {
                terminalModel.plalist.remove(videoId);
              }
            }
            _videosList = terminalModel.plalist;
            _terminalModel = terminalModel;
            await repository.saveTerminalModel(terminalModel);
          });
          weatherModel.value = await getWeather(terminalModel);
        }
        _runVideoUpdate = false;
        if (oldTimeCourse != _terminalModel.updateTimeCourseMin) {
          page.value = const SplashPage();
        }
        if (oldBottonBar != _terminalModel.hasBar) {
          page.value = const SplashPage();
        }
      }
    }
  }

  Future<void> deleteVideosLate() async {
    if (_videosToDelete.isNotEmpty) {
      for (var videoId in _videosToDelete) {
        fileControllerService.deleteVideo('$videoId.mp4');
      }
      _videosToDelete = [];
    }
  }

  Future<WeatherModel> getWeather(TerminalModel terminalModel) async {
    if (terminalModel.lat.isNotEmpty &&
        terminalModel.lon.isNotEmpty &&
        _bottonBar) {
      final result = await repository.getWeatherModel(
          terminalModel.lat, terminalModel.lon);
      return result.fold(
          (l) => WeatherModel(id: 0, icon: '', tempMin: '', tempMax: ''),
          (r) => r);
    } else {
      return WeatherModel(id: 0, icon: '', tempMin: '', tempMax: '');
    }
  }
}
