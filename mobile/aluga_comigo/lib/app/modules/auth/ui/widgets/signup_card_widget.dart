import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/ui/widgets/terciary_button.dart';
import 'user_step_widget.dart';

class SignupCardWidget extends StatefulWidget {
  final VoidCallback backPage;
  const SignupCardWidget({super.key, required this.backPage});

  @override
  State<SignupCardWidget> createState() => _SignupCardWidgetState();
}

class _SignupCardWidgetState extends State<SignupCardWidget> {
  bool? isUserAccount;
  final PageController _controller = PageController();

  void backPage() {
    _controller.previousPage(
      duration: Durations.short4,
      curve: Curves.linear,
    );
  }

  void nextPage() {
    _controller.nextPage(
      duration: Durations.short4,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF2C29A3),
                ),
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  top: 16,
                  bottom: 32,
                ),
                child: Column(
                  children: [
                    Text(
                      "O que você busca?",
                      textScaler: const TextScaler.linear(1),
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(16),
                    TerciaryButtonWidget(
                      onTap: () {
                        setState(() {
                          isUserAccount = true;
                        });
                        nextPage();
                      },
                      title: "Encontrar pessoa/casa",
                      colorTitle: Colors.black,
                      colorInside: Colors.white,
                    ),
                    const Gap(16),
                    TerciaryButtonWidget(
                      onTap: () {
                        setState(() {
                          isUserAccount = false;
                        });
                        nextPage();
                      },
                      title: "Alugar minha casa",
                      colorTitle: Colors.black,
                      colorInside: Colors.white,
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.backPage,
                            style: ButtonStyle(
                              textStyle: MaterialStatePropertyAll(
                                GoogleFonts.rubik(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              minimumSize: const MaterialStatePropertyAll(
                                Size(double.infinity, 50),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                            ),
                            child: const Text(
                              "Voltar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        (isUserAccount ?? true)
            ? UserStepWidget(backPage: backPage)
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF2C29A3),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                width: 330,
                child: Column(
                  children: [
                    Text(
                      "Imovel",
                      textScaler: const TextScaler.linear(1),
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(16),
                    TerciaryButtonWidget(
                      onTap: () {},
                      title: "Encontrar pessoa/casa",
                      colorTitle: Colors.black,
                      colorInside: Colors.white,
                    ),
                    const Gap(16),
                    TerciaryButtonWidget(
                      onTap: () {},
                      title: "Alugar minha casa",
                      colorTitle: Colors.black,
                      colorInside: Colors.white,
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              backPage();
                            },
                            style: ButtonStyle(
                              textStyle: MaterialStatePropertyAll(
                                GoogleFonts.rubik(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              minimumSize: const MaterialStatePropertyAll(
                                Size(double.infinity, 50),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                            ),
                            child: const Text(
                              "Voltar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
