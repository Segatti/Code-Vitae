import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/app_store.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/characters_navigation');
    AppStore store = Modular.get<AppStore>();

    store.startStore();

    return Observer(builder: (_) {
      return MaterialApp.router(
        title: 'Morty Verso',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.light, fontFamily: 'Roboto'),
        darkTheme: ThemeData(brightness: Brightness.dark, fontFamily: 'Roboto'),
        themeMode: store.themeIsDark ? ThemeMode.dark : ThemeMode.light,
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
      );
    });
  }
}
