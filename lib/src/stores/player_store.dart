import 'dart:async';
import 'package:intl/intl.dart';
import 'package:saudetv/src/stores/core_store.dart';

class PlayerStore {
  CoreStore coreStore;
  PlayerStore({
    required this.coreStore,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String getVideo(int index) {
    final videoId = coreStore.videosList[index];
    return '${coreStore.videoPath}/$videoId.mp4';
  }

  Future<void> nextVideo() async {
    final int numberOfVideos = coreStore.videosList.length;
    final int currentVideo = coreStore.indexVideo.value;
    _isLoading = true;
    coreStore.indexVideo.value = 1000;
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoading = false;
    if ((numberOfVideos - 1) == currentVideo) {
      coreStore.indexVideo.value = 0;
    } else {
      coreStore.indexVideo.value = currentVideo + 1;
    }
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
