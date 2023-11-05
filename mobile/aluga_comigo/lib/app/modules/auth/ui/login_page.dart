import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/ui/widgets/primary_button.dart';
import '../../../shared/ui/widgets/secondary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration initialDuration = const Duration(milliseconds: 500);
  bool? haveAccount;

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
                  SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DelayedDisplay(
                          delay: Duration(
                            milliseconds: initialDuration.inMilliseconds + 2500,
                          ),
                          slidingBeginOffset: const Offset(0.0, -0.35),
                          child: PrimaryButtonWidget(
                            onTap: () {
                              setState(() {
                                haveAccount = true;
                              });
                            },
                            title: "Ja tenho conta",
                          ),
                        ),
                        const SizedBox(height: 16),
                        DelayedDisplay(
                          delay: Duration(
                            milliseconds: initialDuration.inMilliseconds + 2500,
                          ),
                          slidingBeginOffset: const Offset(0.0, -0.35),
                          child: SecondaryButtonWidget(
                            onTap: () {
                              setState(() {
                                haveAccount = false;
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
                  // AnimatedCrossFade(
                  //     crossFadeState: haveAccount ?? true
                  //         ? CrossFadeState.showFirst
                  //         : CrossFadeState.showSecond,
                  //     duration: const Duration(milliseconds: 500),
                  //     firstChild: Container(
                  //       width: 350,
                  //       padding: const EdgeInsets.only(
                  //         bottom: 32,
                  //         left: 32,
                  //         right: 32,
                  //         top: 16,
                  //       ),
                  //       // margin: EdgeInsets.all(16),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20),
                  //         color: const Color(0xFF2C29A3),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black.withOpacity(.25),
                  //             offset: const Offset(20, 20),
                  //             blurRadius: 40,
                  //           ),
                  //           BoxShadow(
                  //             color: Colors.white.withOpacity(.25),
                  //             offset: const Offset(-20, -20),
                  //             blurRadius: 40,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Form(
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               "Login",
                  //               textScaleFactor: 1,
                  //               style: GoogleFonts.rubik(
                  //                 color: Colors.white,
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w400,
                  //               ),
                  //             ),
                  //             TextFormField(
                  //               decoration: InputDecoration(
                  //                 hintText: "Ex: aluga@comigo.com",
                  //                 labelText: "Email",
                  //               ),
                  //             ),
                  //             TextFormField(
                  //               decoration: InputDecoration(
                  //                 hintText: "*****",
                  //                 labelText: "Senha",
                  //               ),
                  //               obscureText: true,
                  //             ),
                  //             ElevatedButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   haveAccount = null;
                  //                 });
                  //               },
                  //               child: Text("Voltar"),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     secondChild: Container(
                  //       child: Form(
                  //         child: Column(
                  //           children: [
                  //             Text("O que você busca?"),
                  //             ElevatedButton(
                  //               child: Text(
                  //                 "Encontrar pessoa/casa",
                  //               ),
                  //               onPressed: () {},
                  //             ),
                  //             ElevatedButton(
                  //               child: Text(
                  //                 "Alugar meu imóvel",
                  //               ),
                  //               onPressed: () {},
                  //             ),
                  //             ElevatedButton(
                  //               child: Text(
                  //                 "Voltar",
                  //               ),
                  //               onPressed: () {},
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
