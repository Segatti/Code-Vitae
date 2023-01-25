import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/app_store.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AppStore store;

  final Color fontWhite = const Color(0xFFFFFFFF);
  final Color fontBlack = const Color(0xFF000000);

  final Color logoBackgroundWhite = const Color(0xFFFAFAFA);
  final Color logoBackgroundBlack = const Color(0x40000000);

  @override
  void initState() {
    store = Modular.get<AppStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await Future.delayed(const Duration(seconds: 3))
        .then((value) => Modular.to.navigate('/navigation/morty_verso/'));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(store.themeIsDark
                ? 'assets/images/fundo_dark.png'
                : 'assets/images/fundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: store.themeIsDark
                          ? logoBackgroundWhite
                          : logoBackgroundBlack,
                    ),
                    BoxShadow(
                      color: store.themeIsDark
                          ? logoBackgroundBlack
                          : logoBackgroundWhite,
                      spreadRadius: -2.0,
                      blurRadius: 5.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  padding: const EdgeInsets.all(PaddingPattern.small),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              const SizedBox(height: PaddingPattern.small),
              Observer(builder: (context) {
                return Text(
                  'Morty Verso',
                  style: TextStyle(
                    fontSize: 17,
                    color: store.themeIsDark ? fontWhite : fontBlack,
                    decoration: TextDecoration.none,
                    fontFamily: 'SF Pro',
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
