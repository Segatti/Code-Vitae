import 'package:aluga_comigo/app/modules/auth/ui/widgets/login_card_widget.dart';
import 'package:aluga_comigo/app/modules/auth/ui/widgets/signup_card_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/ui/widgets/primary_button.dart';
import '../../../shared/ui/widgets/secondary_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Duration initialDuration = const Duration(milliseconds: 500);
  bool? haveAccount;
  bool isChooisePage = true;

  void backPage() {
    setState(() {
      isChooisePage = true;
    });
  }

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DelayedDisplay(
                          delay: initialDuration,
                          slidingBeginOffset: const Offset(0.0, -0.35),
                          child: Text(
                            "Aluga",
                            textScaler: const TextScaler.linear(1),
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
                            textScaler: const TextScaler.linear(1),
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
                            pause: const Duration(milliseconds: 1000),
                            animatedTexts: [
                              TyperAnimatedText(
                                'uma Casa?',
                                speed: const Duration(milliseconds: 80),
                                textStyle: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 32,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = Colors.black,
                                ),
                              ),
                              TyperAnimatedText(
                                'um Apê?',
                                speed: const Duration(milliseconds: 102),
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
                  const SizedBox(height: 32),
                  AnimatedCrossFade(
                    crossFadeState: isChooisePage
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DelayedDisplay(
                            delay: Duration(
                              milliseconds:
                                  initialDuration.inMilliseconds + 2500,
                            ),
                            slidingBeginOffset: const Offset(0.0, -0.35),
                            child: PrimaryButtonWidget(
                              onTap: () {
                                setState(() {
                                  haveAccount = true;
                                  isChooisePage = false;
                                });
                              },
                              title: "Ja tenho conta",
                            ),
                          ),
                          const SizedBox(height: 16),
                          DelayedDisplay(
                            delay: Duration(
                              milliseconds:
                                  initialDuration.inMilliseconds + 2500,
                            ),
                            slidingBeginOffset: const Offset(0.0, -0.35),
                            child: SecondaryButtonWidget(
                              onTap: () {
                                setState(() {
                                  haveAccount = false;
                                  isChooisePage = false;
                                });
                              },
                              title: "Quero me cadastrar",
                              colorTitle: Colors.black,
                              colorInside: Colors.white,
                              borderWidth: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: (haveAccount ?? true)
                        ? LoginCardWidget(
                            backPage: backPage,
                          )
                        : SignupCardWidget(
                            backPage: backPage,
                          ),
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
