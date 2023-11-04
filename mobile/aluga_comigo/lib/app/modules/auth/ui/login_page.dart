import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/ui/widgets/primary_button.dart';
import '../../../shared/ui/widgets/secondary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Duration initialDuration = const Duration(milliseconds: 500);

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
                    width: 135,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DelayedDisplay(
                          delay: initialDuration,
                          slidingBeginOffset: const Offset(0.0, -0.35),
                          child: Text(
                            "Aluga",
                            textScaleFactor: 1,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 32,
                              color: const Color(0xFF2C29A3),
                            ),
                          ),
                        ),
                        DelayedDisplay(
                          delay: Duration(
                            milliseconds: initialDuration.inMilliseconds + 500,
                          ),
                          slidingBeginOffset: const Offset(0.0, -0.35),
                          child: Text(
                            "Comigo",
                            textScaleFactor: 1,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 32,
                              color: const Color(0xFFDF924B),
                            ),
                          ),
                        ),
                        DelayedDisplay(
                          delay: Duration(
                            milliseconds: initialDuration.inMilliseconds + 1000,
                          ),
                          slidingBeginOffset: const Offset(0.0, -0.35),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(milliseconds: 250),
                            animatedTexts: [
                              RotateAnimatedText(
                                transitionHeight: 40,
                                alignment: Alignment.centerLeft,
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
                                transitionHeight: 40,
                                'um Apê?',
                                alignment: Alignment.centerLeft,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DelayedDisplay(
                    delay: Duration(
                      milliseconds: initialDuration.inMilliseconds + 2500,
                    ),
                    slidingBeginOffset: const Offset(0.0, -0.35),
                    child: SizedBox(
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
