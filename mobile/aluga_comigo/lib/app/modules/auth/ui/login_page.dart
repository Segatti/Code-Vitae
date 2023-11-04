import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/ui/widgets/primary_button.dart';
import '../../../shared/ui/widgets/secondary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          color: const Color(0xFF2C29A3),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 170,
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aluga",
                          textScaleFactor: 1,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: const Color(0xFF2C29A3),
                          ),
                        ),
                        Text(
                          "Comigo",
                          textScaleFactor: 1,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: const Color(0xFFDF924B),
                          ),
                        ),
                        AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(milliseconds: 500),
                          animatedTexts: [
                            RotateAnimatedText(
                              transitionHeight: 64,
                              alignment: Alignment.topLeft,
                              'uma Casa?',
                              textStyle: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.black,
                              ),
                            ),
                            RotateAnimatedText(
                              transitionHeight: 64,
                              'um Apê?',
                              alignment: Alignment.topLeft,
                              textStyle: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PrimaryButtonWidget(
                          onTap: () {},
                          title: "Ja tenho conta",
                        ),
                        const SizedBox(height: 16),
                        SecondaryButtonWidget(
                          onTap: () {},
                          title: "Quero me cadastrar",
                          colorTitle: Colors.black,
                          colorInside: Colors.white,
                          borderWidth: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
