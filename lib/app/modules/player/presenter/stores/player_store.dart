import 'package:flutter/material.dart';
import 'package:saudetv/app/core/domain/adapter/login_source.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/usecases/delete_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/get_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/update_terminal.dart';
import 'package:saudetv/app/types/time.dart';

import '../page/others_page.dart';
import '../page/rss_page.dart';
import '../page/video_page.dart';

class PlayerStore {
  final IGetContents getContents;
  final IUpdateTerminal updateTerminal;
  final IDeleteContents deleteContents;
  final PageStore pageStore;

  PlayerStore({
    required this.getContents,
    required this.updateTerminal,
    required this.deleteContents,
    required this.pageStore,
  });

  late LoginSource _loginSource;
  final List<ContentsEntity> _contentsList = [];
  final List<String> _deleteContentsList = [];
  DateTime _upDateTime = DateTime.now();
  int _contentsIndex = 0;
  bool _lateUpDate = false;
  bool _isUpdate = false;
  bool _isInitialize = false;
  bool _isDelete = false;

  LoginSource get loginSource => _loginSource;

  void setLoginSource(LoginSource loginSource) {
    _loginSource = loginSource;
  }

  void _setContentsPage(ContentsEntity contentsEntity) async {
    if (contentsEntity.type == Type.video) {
      pageStore.page.value = Container(color: Colors.black);
      await Future.delayed(const Duration(milliseconds: 100));
      pageStore.page.value = VideoPage(
        contentsEntity: contentsEntity,
      );
    } else if (contentsEntity.type == Type.rss) {
      if (TimeCuston()
          .isSameDay(pageStore.dateUTC, contentsEntity.updateData)) {
        pageStore.page.value = RssPage(
          contentsEntity: contentsEntity,
        );
      } else {
        nextContents();
      }
    } else {
      pageStore.page.value = OthersPage(
        contentsEntity: contentsEntity,
      );
    }
  }

  Future<void> nextContents() async {
    final int numberOfContents = _contentsList.length;
    if ((numberOfContents - 1) > _contentsIndex) {
      _contentsIndex++;
    } else {
      _contentsIndex = 0;
    }
    _setContentsPage(_contentsList[_contentsIndex]);
  }

  Future<void> initialize(LoginSource loginSource) async {
    _isInitialize = true;
    setLoginSource(loginSource);
    await pageStore.setDateUCT();
    _upDateTime = pageStore.dateUTC
        .add(Duration(minutes: loginSource.terminalEntity.updateTimeCourseMin));
    for (var contents in loginSource.terminalEntity.contentsList) {
      await pageStore.checkInternet();
      final contentsResult = await getContents(contents,
          loginSource.userEntity.token, pageStore.isConnect, pageStore.dateUTC);
      contentsResult.fold((l) => l, (contentsEntity) {
        _contentsList.add(contentsEntity);
        if (_contentsList.length == 1) {
          _setContentsPage(_contentsList[0]);
        }
      });
    }
    _upDateScheme();
    _isInitialize = false;
  }

  Future<void> upDateContents() async {
    if (_deleteContentsList.isNotEmpty) {
      await _delContents();
    }
    if (_lateUpDate) {
      await pageStore.checkInternet();
      if (pageStore.isConnect) {
        await _upDateScheme();
      }
    } else {
      final bool goUpDate = pageStore.dateUTC.isAfter(_upDateTime);
      if (goUpDate) {
        _upDateTime = pageStore.dateUTC.add(
            Duration(minutes: _loginSource.terminalEntity.updateTimeCourseMin));
        final bool timeToUpDate = _updateTime(pageStore.dateUTC);
        if (!_isUpdate && !_isInitialize && !_isDelete && timeToUpDate) {
          await pageStore.checkInternet();
          if (pageStore.isConnect) {
            await _upDateScheme();
          } else {
            _lateUpDate = true;
          }
        }
      }
    }
  }

  Future<void> _upDateScheme() async {
    _lateUpDate = false;
    _isUpdate = true;
    await pageStore.setDateUCT();
    final terminalResult = await updateTerminal(loginSource);
    await terminalResult.fold((l) => null, (newLoginSource) async {
      List<ContentsEntity> newContentsList = [];
      for (var contents in newLoginSource.terminalEntity.contentsList) {
        await pageStore.checkInternet();
        final contentsResult = await getContents(
            contents,
            loginSource.userEntity.token,
            pageStore.isConnect,
            pageStore.dateUTC);
        contentsResult.fold((l) => null, (contentsEntity) {
          newContentsList.add(contentsEntity);
        });
      }
      if (newContentsList.isNotEmpty) {
        _contentsList.clear();
        _contentsList.addAll(newContentsList);
      }
      for (var contents in loginSource.terminalEntity.contentsList) {
        if (!newLoginSource.terminalEntity.contentsList.contains(contents)) {
          _deleteContentsList.add(contents);
        }
      }
      setLoginSource(newLoginSource);
    });
    _isUpdate = false;
  }

  Future<void> _delContents() async {
    if (!_isUpdate && !_isDelete) {
      _isDelete = true;
      List deletedContent = [];
      for (var contents in _deleteContentsList) {
        if (await deleteContents(contents)) {
          deletedContent.add(contents);
        }
      }
      if (deletedContent.length == _deleteContentsList.length) {
        _deleteContentsList.clear();
      } else {
        for (var element in deletedContent) {
          _deleteContentsList.remove(element);
        }
      }
      _isDelete = false;
    }
  }

  void addDeleteContentsList(String contentsID) {
    _deleteContentsList.add(contentsID);
  }

  bool _updateTime(DateTime timeNow) {
    final updateStartSis = DateTime(
      timeNow.year,
      timeNow.month,
      timeNow.day,
      loginSource.terminalEntity.updateStartHour,
      loginSource.terminalEntity.updateStartMinute,
    );
    final updateEndSis = DateTime(
      timeNow.year,
      timeNow.month,
      timeNow.day,
      loginSource.terminalEntity.updateEndHour,
      loginSource.terminalEntity.updateEndMinute,
    );

    DateTime updateStart = DateTime(
      timeNow.year,
      timeNow.month,
      timeNow.day,
      7,
      0,
    );
    DateTime updateEnd = DateTime(
      timeNow.year,
      timeNow.month,
      timeNow.day,
      19,
      0,
    );
    if (updateStartSis.isBefore(updateEndSis)) {
      if ((updateStartSis.hour + updateStartSis.minute) != 0) {
        updateStart = updateStartSis;
      }
      if ((updateEndSis.hour + updateEndSis.minute) != 0) {
        updateEnd = updateEndSis;
      }
    }
    if (timeNow.isAfter(updateStart) && timeNow.isBefore(updateEnd)) {
      return true;
    } else {
      return false;
    }
  }
}
