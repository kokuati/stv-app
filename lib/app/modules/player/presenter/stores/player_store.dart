import 'package:flutter/material.dart';
import 'package:saudetv/app/core/domain/adapter/login_source.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/entities/weather_entity.dart';
import 'package:saudetv/app/modules/player/domain/usecases/delete_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/get_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/get_weather.dart';
import 'package:saudetv/app/modules/player/domain/usecases/update_terminal.dart';
import 'package:saudetv/app/modules/player/presenter/page/contents_pages/circular_pregress_page.dart';
import 'package:saudetv/app/modules/player/presenter/page/contents_pages/others_page.dart';
import 'package:saudetv/app/modules/player/presenter/page/contents_pages/rss_page.dart';
import 'package:saudetv/app/modules/player/presenter/page/contents_pages/video_page.dart';
import 'package:intl/intl.dart';

class PlayerStore {
  final IGetContents getContents;
  final IGetWeather getWeather;
  final IUpdateTerminal updateTerminal;
  final IDeleteContents deleteContents;
  final PageStore pageStore;

  PlayerStore({
    required this.getContents,
    required this.getWeather,
    required this.updateTerminal,
    required this.deleteContents,
    required this.pageStore,
  });

  ValueNotifier<Widget> contentsPage =
      ValueNotifier(const CircularProgressPage());
  ValueNotifier<bool> hasBar = ValueNotifier(true);
  ValueNotifier<WeatherEntity> weatherEntity =
      ValueNotifier(WeatherEntity(id: 0, icon: '', tempMin: '', tempMax: ''));
  late LoginSource _loginSource;
  List<ContentsEntity> _contentsList = [];
  final List<String> _deleteContentsList = [];
  int _contentsIndex = 0;
  bool _lateUpDate = false;
  bool _isUpdate = false;
  bool _isDelete = false;

  LoginSource get loginSource => _loginSource;
  List<ContentsEntity> get contentsList => _contentsList;
  List<String> get deleteContentsList => _deleteContentsList;
  bool get lateUpDate => _lateUpDate;

  void setLoginSource(LoginSource loginSource) {
    _loginSource = loginSource;
  }

  Future<void> setContentsPage(ContentsEntity contentsEntity) async {
    if (contentsEntity.type == Type.video) {
      hasBar.value = true;
      contentsPage.value = Container(color: Colors.black);
      await Future.delayed(const Duration(milliseconds: 500));
      contentsPage.value = VideoPage(
        contentsEntity: contentsEntity,
      );
    } else if (contentsEntity.type == Type.rss) {
      hasBar.value = false;
      contentsPage.value = Container(color: Colors.black);
      await Future.delayed(const Duration(milliseconds: 500));
      contentsPage.value = RssPage(
        contentsEntity: contentsEntity,
      );
    } else {
      contentsPage.value = Container(color: Colors.black);
      await Future.delayed(const Duration(milliseconds: 500));
      contentsPage.value = OthersPage(
        contentsEntity: contentsEntity,
      );
    }
  }

  Future<void> setWeatherEntity(LoginSource loginSource) async {
    final result = await getWeather(
        loginSource.terminalEntity.lat, loginSource.terminalEntity.lon);
    result.fold((l) {
      weatherEntity.value =
          WeatherEntity(id: 0, icon: '', tempMin: '', tempMax: '');
    }, (r) {
      weatherEntity.value = r;
    });
  }

  Future<void> nextContents() async {
    final int numberOfContents = _contentsList.length;
    if ((numberOfContents - 1) == _contentsIndex) {
      _contentsIndex = 0;
    } else {
      _contentsIndex++;
    }
    await setContentsPage(contentsList[_contentsIndex]);
  }

  Future<void> initialize(LoginSource loginSource) async {
    setLoginSource(loginSource);
    setWeatherEntity(loginSource);
    hasBar.value = loginSource.terminalEntity.hasBar;
    for (var contents in loginSource.terminalEntity.contentsList) {
      await pageStore.checkInternet();
      final contentsResult = await getContents(
          contents, loginSource.userEntity.token, pageStore.isConnect.value);
      contentsResult.fold((l) => null, (contentsEntity) {
        _contentsList.add(contentsEntity);
      });
    }
    setContentsPage(contentsList[0]);
    upDateContents();
  }

  Future<void> upDateContents() async {
    print(_isUpdate);
    print(_lateUpDate);
    if (!_isUpdate) {
      _isUpdate = true;
      print(_isUpdate);
      await pageStore.checkInternet();
      if (pageStore.isConnect.value && !_isDelete) {
        _lateUpDate = false;
        print(_lateUpDate);
        final terminalResult = await updateTerminal(loginSource);
        print(terminalResult);
        terminalResult.fold((l) => null, (newLoginSource) async {
          List<ContentsEntity> newContentsList = [];
          for (var contents in newLoginSource.terminalEntity.contentsList) {
            await pageStore.checkInternet();
            final contentsResult = await getContents(contents,
                loginSource.userEntity.token, pageStore.isConnect.value);
            contentsResult.fold((l) => null, (contentsEntity) {
              newContentsList.add(contentsEntity);
            });
          }
          if (newContentsList.isNotEmpty) {
            _contentsList = newContentsList;
          }
          for (var contents in loginSource.terminalEntity.contentsList) {
            if (!newLoginSource.terminalEntity.contentsList
                .contains(contents)) {
              deleteContentsList.add(contents);
            }
          }
          setWeatherEntity(newLoginSource);
          setLoginSource(newLoginSource);
        });
      } else {
        _lateUpDate = true;
      }
      _isUpdate = false;
    }
  }

  Future<void> delContents() async {
    if (!_isUpdate && !_isDelete) {
      _isDelete = true;
      List<String> list = [];
      for (var contents in _deleteContentsList) {
        if (await deleteContents(contents)) {
          list.add(contents);
        }
      }
      for (var element in list) {
        _deleteContentsList.remove(element);
      }
      _isDelete = false;
      if (_lateUpDate) {
        upDateContents();
      }
    }
  }

  void addDeleteContentsList(String contentsID) {
    _deleteContentsList.add(contentsID);
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("HH:mm").format(now);
  }

  String getSystemWeek() {
    int week = DateTime.now().weekday;
    if (week == 1) {
      return 'Seg.';
    } else if (week == 2) {
      return 'Terç.';
    } else if (week == 3) {
      return 'Qua.';
    } else if (week == 4) {
      return 'Qui.';
    } else if (week == 5) {
      return 'Sex.';
    } else if (week == 6) {
      return 'Sáb.';
    } else {
      return 'Dom.';
    }
  }

  String getSystemDay() {
    var now = DateTime.now();
    String day = '';
    String month = '';
    if (now.day > 9) {
      day = '${now.day}';
    } else {
      day = '0${now.day}';
    }
    if (now.month > 9) {
      month = '${now.month}';
    } else {
      month = '0${now.month}';
    }
    return '$day/$month';
  }
}
