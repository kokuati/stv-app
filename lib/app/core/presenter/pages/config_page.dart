import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/core/presenter/pages/splash_page.dart';
import 'package:saudetv/app/core/presenter/stores/splash_store.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  void initState() {
    final splashStore = context.read<SplashStore>();
    splashStore.pageState.addListener(() {
      if (splashStore.pageState.value == 'login') {
        Navigator.pushNamed(context, '/login');
      }
      if (splashStore.pageState.value == 'page') {
        Navigator.pushNamed(context, '/page');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final splashStore = context.read<SplashStore>();
    return ValueListenableBuilder(
      valueListenable: splashStore.pageState,
      builder: (BuildContext context, String value, Widget? child) {
        if (value == 'splash') {
          return const SplashPage();
        } else {
          return _body(context);
        }
      },
    );
  }

  Widget _body(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final splashStore = context.read<SplashStore>();
    String pageState = splashStore.pageState.value;
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Image(
              height: height,
              image: const AssetImage('images/fundo_confg.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            color: const Color.fromARGB(140, 0, 0, 0),
          ),
          Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageState != 'login'
                    ? ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xB3343360)),
                            fixedSize: MaterialStateProperty.all(
                                Size(height * 0.1, height * 0.1))),
                        onPressed: (() {
                          Navigator.pushNamed(context, '/page');
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_arrow_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            const Text(
                              'PLAYER',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                inherit: false,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                pageState != 'login'
                    ? SizedBox(
                        width: width * 0.05,
                      )
                    : const SizedBox(),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xB3343360)),
                      fixedSize: MaterialStateProperty.all(
                          Size(height * 0.1, height * 0.1))),
                  onPressed: (() {
                    pageState == 'login'
                        ? Navigator.pushNamed(context, '/login')
                        : splashStore.logout();
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        pageState == 'login' ? Icons.login : Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Text(
                        pageState == 'login' ? 'LOGIN' : 'LOGOUT',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          inherit: false,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
