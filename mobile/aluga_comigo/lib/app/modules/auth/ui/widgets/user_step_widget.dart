import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'card_auth_widget.dart';

class UserStepWidget extends StatefulWidget {
  final VoidCallback backPage;
  const UserStepWidget({super.key, required this.backPage});

  @override
  State<UserStepWidget> createState() => _UserStepWidgetState();
}

class _UserStepWidgetState extends State<UserStepWidget> {
  final CarouselController _controller = CarouselController();
  int indexCarousel = 0;

  void backPage() {
    if (indexCarousel == 0) {
      widget.backPage();
    } else {
      _controller.previousPage();
      indexCarousel--;
    }
    setState(() {});
  }

  void nextPage() {
    _controller.nextPage();
    indexCarousel++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 330.0,
              aspectRatio: 1,
              enableInfiniteScroll: false,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              viewportFraction: 1,
              animateToClosest: true,
            ),
            items: [
              CardAuthWidget(
                children: [
                  const Spacer(),
                  Text(
                    "Dados de acesso",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  const Spacer(),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Senha',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: backPage,
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
                      const Gap(8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: nextPage,
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
                                const MaterialStatePropertyAll(Colors.green),
                          ),
                          child: const Text(
                            "Confirmar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              Visibility(
                visible: true,
                child: CardAuthWidget(
                  children: [
                    const Spacer(),
                    Text(
                      "Dados pessoais",
                      textScaler: const TextScaler.linear(1),
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(16),
                    const Spacer(),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Nome Completo',
                              hintStyle: GoogleFonts.rubik(
                                fontSize: 18,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 24.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                          const Gap(16),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Telefone',
                              hintStyle: GoogleFonts.rubik(
                                fontSize: 18,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 24.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: backPage,
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
                        const Gap(8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: nextPage,
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
                                  const MaterialStatePropertyAll(Colors.green),
                            ),
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              CardAuthWidget(
                children: [
                  const Spacer(),
                  Text(
                    "Dados pessoais",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  const Spacer(),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nome Completo',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Telefone',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: backPage,
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
                      const Gap(8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: nextPage,
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
                                const MaterialStatePropertyAll(Colors.green),
                          ),
                          child: const Text(
                            "Confirmar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
          const Gap(16),
          AnimatedSmoothIndicator(
            activeIndex: indexCarousel,
            count: 5,
            effect: const WormEffect(),
          )
        ],
      ),
    );
  }
}
