import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/core/domain/repositories/core_repository_i.dart';
import 'package:saudetv/app/core/domain/repositories/date_utc_repository_i.dart';
import 'package:saudetv/app/core/domain/repositories/terminal_repository_i.dart';
import 'package:saudetv/app/core/domain/repositories/user_repository_i.dart';
import 'package:saudetv/app/core/domain/usecases/get_date_utc.dart';
import 'package:saudetv/app/core/domain/usecases/get_terminal.dart';
import 'package:saudetv/app/core/domain/usecases/internet_is_connected.dart';
import 'package:saudetv/app/core/domain/usecases/read_terminal.dart';
import 'package:saudetv/app/core/domain/usecases/read_user.dart';
import 'package:saudetv/app/core/domain/usecases/save_terminal.dart';
import 'package:saudetv/app/core/domain/usecases/save_user.dart';
import 'package:saudetv/app/core/external/datasources/date_utc_remote_datasource.dart';
import 'package:saudetv/app/core/external/datasources/terminal_local_datasource.dart';
import 'package:saudetv/app/core/external/datasources/terminal_remote_datasource.dart';
import 'package:saudetv/app/core/external/datasources/user_local_datasource.dart';
import 'package:saudetv/app/core/infra/datasources/terminal_local_datasource_i.dart';
import 'package:saudetv/app/core/infra/datasources/terminal_remote_datasource_i.dart';
import 'package:saudetv/app/core/infra/datasources/user_local_datasource_i.dart';
import 'package:saudetv/app/core/infra/datasources/user_remote_datasource_i.dart';
import 'package:saudetv/app/core/infra/repositories/core_repository.dart';
import 'package:saudetv/app/core/infra/repositories/date_utc_repository.dart';
import 'package:saudetv/app/core/infra/repositories/terminal_repository.dart';
import 'package:saudetv/app/core/infra/repositories/user_repository.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/core/presenter/stores/splash_store.dart';
import 'package:saudetv/app/core/domain/usecases/get_user.dart';
import 'package:saudetv/app/modules/auth/domain/usecases/login.dart';
import 'package:saudetv/app/core/external/datasources/user_remote_datasource.dart';
import 'package:saudetv/app/modules/auth/presenter/stores/login_store.dart';
import 'package:saudetv/app/modules/player/domain/repositories/contents_repository_i.dart';
import 'package:saudetv/app/modules/player/domain/repositories/video_repository_i.dart';
import 'package:saudetv/app/modules/player/domain/repositories/weather_repository_i.dart';
import 'package:saudetv/app/modules/player/domain/usecases/delete_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/get_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/get_weather.dart';
import 'package:saudetv/app/modules/player/domain/usecases/read_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/save_contents.dart';
import 'package:saudetv/app/modules/player/domain/usecases/save_video.dart';
import 'package:saudetv/app/modules/player/domain/usecases/update_terminal.dart';
import 'package:saudetv/app/modules/player/external/datasources/contents_local_datasource.dart';
import 'package:saudetv/app/modules/player/external/datasources/contents_remote_datasource.dart';
import 'package:saudetv/app/modules/player/external/datasources/video_remote_datasource.dart';
import 'package:saudetv/app/modules/player/external/datasources/weather_remote_datasource.dart';
import 'package:saudetv/app/modules/player/infra/datasources/contents_local_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/contents_remote_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/video_remote_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/weather_remote_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/repositories/contents_repository.dart';
import 'package:saudetv/app/modules/player/infra/repositories/video_repository.dart';
import 'package:saudetv/app/modules/player/infra/repositories/weather_repository.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';
import 'package:saudetv/app/services/check_internet/check_internet_interface.dart';
import 'package:saudetv/app/services/check_internet/connectivity_plus_service.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';
import 'package:saudetv/app/services/client_http/dio_client_http.dart';
import 'package:saudetv/app/services/get_path/get_path_interface.dart';
import 'package:saudetv/app/services/get_path/path_provider_service.dart';
import 'package:saudetv/app/services/local_storage/local_storage_interface.dart';
import 'package:saudetv/app/services/local_storage/shared_preferences_service.dart';
import 'package:saudetv/app/core/presenter/pages/page.dart';
import 'package:saudetv/app/types/aws_signature.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/core/domain/usecases/logout.dart';
import 'app/core/external/datasources/core_local_datasource.dart';
import 'app/core/infra/datasources/core_local_datasource_i.dart';
import 'app/core/presenter/pages/config_page.dart';
import 'app/modules/auth/presenter/page/login_page.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://5a052cdb7c34455f8ac8f99b8b259d5f@o1367830.ingest.sentry.io/6668895';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://dev.api.saudetvpainel.com.br:3000';
    const String awsUrl = 'https://saude-tv-development.s3.amazonaws.com';
    const String weatherUrl = 'https://api.openweathermap.org/data/2.5/weather';
    const String weatherToken =
        '<tirar_esta_parte>a964d0a1f5ddd3285f0d9f124018af1f';
    const String videoPath = 'video';
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.accept): const ActivateIntent(),
      },
      child: MultiProvider(
        providers: [
          //services
          Provider<ClientHttpInterface>(
              create: (context) => DioClientHttp(Dio())),
          Provider<ILocalStorage>(
              create: (context) => SharedPreferencesService()),
          Provider<CheckInternetInterface>(
              create: (context) => ConnectivityPlusService()),
          Provider<GetPathInterface>(
              create: (context) => PathProviderService()),
          Provider<AWSSignature>(create: (context) => AWSSignature()),
          //DataSources
          Provider<IWeatherRemoteDataSource>(
              create: (context) => WeatherRemoteDataSource(
                    baseURL: weatherUrl,
                    token: weatherToken,
                    clientHttp: context.read(),
                  )),
          Provider<IUserLocalDataSource>(
              create: (context) => UserLocalDataSource(
                    localStorage: context.read(),
                  )),
          Provider<IUserRemoteDataSource>(
              create: (context) => UserRemoteDataSource(
                    baseURL: baseUrl,
                    clientHttp: context.read(),
                  )),
          Provider<ITerminalLocalDataSource>(
              create: (context) => TerminalLocalDataSource(
                    localStorage: context.read(),
                  )),
          Provider<ITerminalRemoteDataSource>(
              create: (context) => TerminalRemoteDataSource(
                    baseURL: baseUrl,
                    clientHttp: context.read(),
                  )),
          Provider<IContentsLocalDataSource>(
              create: (context) => ContentsLocalDataSource(
                    localStorage: context.read(),
                  )),
          Provider<IContentsRemoteDataSource>(
              create: (context) => ContentsRemoteDataSource(
                    baseURL: baseUrl,
                    clientHttp: context.read(),
                  )),
          Provider<IVideoRemoteDataSource>(
              create: (context) => VideoRemoteDataSource(
                    baseURL: awsUrl,
                    clientHttp: context.read(),
                    signature: context.read(),
                  )),
          Provider<DateUTCRemoteDataSource1>(
              create: (context) =>
                  DateUTCRemoteDataSource1(clientHttp: context.read())),
          Provider<DateUTCRemoteDataSource2>(
              create: (context) =>
                  DateUTCRemoteDataSource2(clientHttp: context.read())),
          Provider<ICoreLocalDataSource>(
              create: (context) =>
                  CoreLocalDataSource(localStorage: context.read())),

          //Repositories
          Provider<IWeatherRepository>(
              create: (context) => WeatherRepository(
                    remoteDataSource: context.read(),
                  )),
          Provider<IUserRepository>(
              create: (context) => UserRepository(
                    localDataSource: context.read(),
                    remoteDataSource: context.read(),
                  )),
          Provider<ITerminalRepository>(
              create: (context) => TerminalRepository(
                    localDataSource: context.read(),
                    remoteDataSource: context.read(),
                  )),
          Provider<IContentsRepository>(
              create: (context) => ContentsRepository(
                    localDataSource: context.read(),
                    remoteDataSource: context.read(),
                  )),
          Provider<IVideoRepository>(
              create: (context) =>
                  VideoRepository(remoteDataSource: context.read())),
          Provider<IDateUTCRepository>(
              create: (context) => DateUTCRepository(
                  remoteDataSource1: context.read(),
                  remoteDataSource2: context.read())),
          Provider<ICoreRepository>(
              create: (context) =>
                  CoreRepository(coreLocalDataSource: context.read())),
          //Usecases
          Provider<IInternetIsConnected>(
              create: (context) => InternetIsConnected(
                    chackInternetInterface: context.read(),
                  )),
          Provider<ISaveUser>(
              create: (context) => SaveUser(
                    repository: context.read(),
                  )),
          Provider<ISaveTerminal>(
              create: (context) => SaveTerminal(
                    repository: context.read(),
                  )),
          Provider<ISaveContents>(
              create: (context) => SaveContents(
                    repository: context.read(),
                  )),
          Provider<ISaveVideo>(
              create: (context) => SaveVideo2(
                    videoPath: videoPath,
                    getPath: context.read(),
                    repository: context.read(),
                  )),
          Provider<IReadUser>(
              create: (context) => ReadUser(
                    repository: context.read(),
                  )),
          Provider<IReadTerminal>(
              create: (context) => ReadTerminal(
                    repository: context.read(),
                  )),
          Provider<IReadContents>(
              create: (context) => ReadContents(
                    repository: context.read(),
                  )),
          Provider<IGetUser>(
              create: (context) => GetUser(
                    repository: context.read(),
                    saveUser: context.read(),
                  )),
          Provider<IGetWeather>(
              create: (context) => GetWeather(
                    repository: context.read(),
                  )),
          Provider<IGetTerminal>(
              create: (context) => GetTerminal(
                    saveTerminal: context.read(),
                    terminalRepository: context.read(),
                  )),
          Provider<IGetContents>(
              create: (context) => GetContents(
                    contentsRepository: context.read(),
                    readContents: context.read(),
                    saveContents: context.read(),
                    saveVideo: context.read(),
                    getUser: context.read(),
                    readUser: context.read(),
                  )),
          Provider<IGetDateUTC>(
            create: (context) => GetDateUTC(repository: context.read()),
          ),
          Provider<IUpdateTerminal>(
              create: (context) => UpdateTerminal(
                    getUser: context.read(),
                    getTerminal: context.read(),
                  )),
          Provider<IDeleteContents>(
              create: (context) => DeleteContents(
                    readContents: context.read(),
                    repository: context.read(),
                  )),
          Provider<ILogin>(
              create: (context) => Login(
                    checkInternet: context.read(),
                    getUser: context.read(),
                    getTerminal: context.read(),
                  )),
          Provider<ILogoutUserCase>(
              create: (context) => LogoutUserCase(
                    coreRepository: context.read(),
                    getPath: context.read(),
                    videoPath: videoPath,
                  )),
          //Stores
          Provider<PageStore>(
              create: (context) => PageStore(
                    isConnected: context.read(),
                    getDateUTC: context.read(),
                  )),
          Provider<SplashStore>(
              create: (context) => SplashStore(
                    pageStore: context.read(),
                    readUser: context.read(),
                    readTerminal: context.read(),
                    getUser: context.read(),
                    logoutUserCase: context.read(),
                  )),
          Provider<LoginStore>(
              create: (context) => LoginStore(
                    loginUsecase: context.read(),
                    pageStore: context.read(),
                    splashStore: context.read(),
                  )),
          Provider<PlayerStore>(
              create: (context) => PlayerStore(
                    getContents: context.read(),
                    updateTerminal: context.read(),
                    deleteContents: context.read(),
                    pageStore: context.read(),
                  )),
        ],
        child: MaterialApp(
          title: 'Saude TV',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          //home: const Pages(),
          initialRoute: '/',
          routes: {
            '/': (context) => const ConfigPage(),
            '/page': (context) => const Pages(),
            '/login': (context) => const LoginPage(),
          },
        ),
      ),
    );
  }
}
