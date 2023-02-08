import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/general/text_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late CupertinoThemeData theme;

  final Color logoBackgroundWhite = const Color(0xFFFAFAFA);
  final Color logoBackgroundBlack = const Color(0x40000000);

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    await Future.delayed(const Duration(seconds: 3))
        .then((value) => Modular.to.navigate('/navigation/morty_verso'));
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(theme.brightness == Brightness.dark
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
                    color: theme.brightness == Brightness.dark
                        ? logoBackgroundWhite
                        : logoBackgroundBlack,
                  ),
                  BoxShadow(
                    color: theme.brightness == Brightness.dark
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
            const TextWidget(
              text: 'Morty Verso',
              fontSize: 17,
            ),
          ],
        ),
      ),
    );
  }
}
