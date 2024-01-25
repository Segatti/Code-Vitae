import 'package:flutter/material.dart';
import 'package:timer_watch/views/menu_page.dart';
import 'package:timer_watch/views/splash_page.dart';

class Routes {
  static Route<dynamic> generate(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashPage());
      case '/menu':
        return MaterialPageRoute(builder: (context) => const MenuPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Pagina não encontrada"),
        ),
      );
    });
  }
}
