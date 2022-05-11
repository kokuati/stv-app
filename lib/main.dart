import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/src/datasources/local_datasource.dart';
import 'package:saudetv/src/datasources/remolte_datasource_dio.dart';
import 'package:saudetv/src/datasources/weather_datasource.dart';
import 'package:saudetv/src/page/page.dart';
import 'package:saudetv/src/repositories/repository.dart';
import 'package:saudetv/src/services/check_internet_service.dart';
import 'package:saudetv/src/services/file_controller_service.dart';
import 'package:saudetv/src/stores/core_store.dart';
import 'package:saudetv/src/stores/login_store.dart';
import 'package:saudetv/src/stores/player_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CheckInternetService>(
            create: (context) => CheckInternetServiceConnectivityPlus()),
        Provider<FileControllerService>(
            create: (context) => FileControllerService(videoPath: '/videos')),
        Provider<ILocalDatasourece>(
            create: (context) => LocalDatasourece('terminalKey')),
        Provider<IRemolteDatasource>(
            create: (context) =>
                DioRemolteDatasource(baseURL: 'http://18.231.152.148:3000')),
        Provider<IWeatherDatasource>(
            create: (context) => DioWeatherDatasource(
                keyAPI: '35ed945a96f02ff1bd8703face65996f')),
        Provider<IRepository>(
            create: (context) => Repository(
                fileControllerService: context.read(),
                localDatasourece: context.read(),
                remolteDatasource: context.read(),
                weatherDatasource: context.read())),
        Provider<CoreStore>(
            create: (context) => CoreStore(
                  checkInternetService: context.read(),
                  fileControllerService: context.read(),
                  repository: context.read(),
                )),
        Provider<LoginStore>(
            create: (context) => LoginStore(
                coreStore: context.read(), repository: context.read())),
        Provider<PlayerStore>(
            create: (context) => PlayerStore(coreStore: context.read())),
      ],
      child: MaterialApp(
        title: 'Saude TV',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Pages(),
      ),
    );
  }
}
