import 'package:flutter/cupertino.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/fundo.png'),
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
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                  ),
                  BoxShadow(
                    color: Color(0xFFFAFAFA),
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
            const Text(
              'Morty Verso',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF000000),
                decoration: TextDecoration.none,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
