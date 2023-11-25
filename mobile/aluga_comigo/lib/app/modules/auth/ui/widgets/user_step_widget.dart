import 'package:aluga_comigo/app/modules/auth/interactor/DTOs/user_signup_dto.dart';
import 'package:aluga_comigo/app/modules/auth/interactor/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/auth/interactor/models/select_item.dart';
import 'package:aluga_comigo/app/modules/auth/ui/widgets/pill_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:styled_text/styled_text.dart';

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
  UserSignupDTO _userSignupDTO = const UserSignupDTO();
  bool acceptTerms = false;

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
    if (indexCarousel < 3) {
      _controller.nextPage();
      indexCarousel++;
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return Dialog(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF2C29A3),
                          width: 5,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          StyledText(
                            text:
                                "Ao confirmar você está aceitando os <orange>termos de uso do app</orange>!",
                            style: GoogleFonts.rubik(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            tags: {
                              "orange": StyledTextTag(
                                style: const TextStyle(
                                  color: Color(0xFFDF924B),
                                ),
                              )
                            },
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFF2C29A3),
                                        width: 4,
                                      ),
                                    ),
                                    child: Text(
                                      "Leia aqui os Termos de Uso",
                                      style: GoogleFonts.rubik(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                acceptTerms = !acceptTerms;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  value: acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      acceptTerms = value ?? false;
                                    });
                                  },
                                ),
                                const Text(
                                  "Declaro que tenho 18 anos ou mais.",
                                ),
                              ],
                            ),
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
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
                                        const MaterialStatePropertyAll(
                                            Colors.red),
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
                                  onPressed: () {
                                    print("criar conta");
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
                                        const MaterialStatePropertyAll(
                                            Colors.green),
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
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      );
    }
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
              CardAuthWidget(
                children: [
                  const Spacer(),
                  Text(
                    "Habilidades",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            PillWidget(
                              selectItem: const SelectItem(
                                title: "Metre Cuca",
                                value: UserSkill.cucaMaster,
                              ),
                              onTap: (isSelected, value) {
                                List<UserSkill> skills =
                                    _userSignupDTO.skills ?? [];
                                if (isSelected) {
                                  skills.add(value.value as UserSkill);
                                } else {
                                  skills.remove(value.value as UserSkill);
                                }
                                setState(() {
                                  _userSignupDTO = _userSignupDTO.copyWith(
                                    skills: skills,
                                  );
                                });
                              },
                            ),
                            PillWidget(
                              selectItem: const SelectItem(
                                title: "Ninja em varrer",
                                value: UserSkill.ninjaInSweeping,
                              ),
                              onTap: (isSelected, value) {
                                List<UserSkill> skills =
                                    _userSignupDTO.skills ?? [];
                                if (isSelected) {
                                  skills.add(value.value as UserSkill);
                                } else {
                                  skills.remove(value.value as UserSkill);
                                }
                                setState(() {
                                  _userSignupDTO = _userSignupDTO.copyWith(
                                    skills: skills,
                                  );
                                });
                              },
                            ),
                            PillWidget(
                              selectItem: const SelectItem(
                                title: "Operador de roupa suja",
                                value: UserSkill.laundryOperator,
                              ),
                              onTap: (isSelected, value) {
                                List<UserSkill> skills =
                                    _userSignupDTO.skills ?? [];
                                if (isSelected) {
                                  skills.add(value.value as UserSkill);
                                } else {
                                  skills.remove(value.value as UserSkill);
                                }
                                setState(() {
                                  _userSignupDTO = _userSignupDTO.copyWith(
                                    skills: skills,
                                  );
                                });
                              },
                            ),
                            PillWidget(
                              selectItem: const SelectItem(
                                title: "Lava-louça humano",
                                value: UserSkill.humanDishwasher,
                              ),
                              onTap: (isSelected, value) {
                                List<UserSkill> skills =
                                    _userSignupDTO.skills ?? [];
                                if (isSelected) {
                                  skills.add(value.value as UserSkill);
                                } else {
                                  skills.remove(value.value as UserSkill);
                                }
                                setState(() {
                                  _userSignupDTO = _userSignupDTO.copyWith(
                                    skills: skills,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
              CardAuthWidget(
                children: [
                  const Spacer(),
                  Text(
                    "Uma fotinha básica!",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Color(0xFF4B98DF),
                            size: 50,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Icon(
                            Icons.photo_camera_back_rounded,
                            color: Color(0xFF4B98DF),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
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
            count: 4,
            effect: const WormEffect(),
          )
        ],
      ),
    );
  }
}
