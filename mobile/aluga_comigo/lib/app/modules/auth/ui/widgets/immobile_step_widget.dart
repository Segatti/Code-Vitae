import 'package:carousel_slider/carousel_slider.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:styled_text/styled_text.dart';

import '../../interactor/DTOs/immobile_signup_dto.dart';
import '../../interactor/enums/type_immobile.dart';
import 'card_auth_widget.dart';

class ImmobileStepWidget extends StatefulWidget {
  final VoidCallback backPage;
  const ImmobileStepWidget({super.key, required this.backPage});

  @override
  State<ImmobileStepWidget> createState() => _ImmobileStepWidgetState();
}

class _ImmobileStepWidgetState extends State<ImmobileStepWidget> {
  final CarouselController _controller = CarouselController();
  int indexCarousel = 0;
  ImmobileSignupDTO _immobileSignupDTO = const ImmobileSignupDTO();
  bool acceptTerms = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

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
                                child: ChicletAnimatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  borderRadius: 50,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    "Cancelar",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: ChicletAnimatedButton(
                                  onPressed: () {
                                    print("criar conta");
                                  },
                                  borderRadius: 50,
                                  backgroundColor: Colors.green,
                                  child: Text(
                                    "Confirmar",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
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
              height: 270.0,
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 24.0,
                              bottom: 8.0,
                              top: 8.0,
                            ),
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
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
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
                          onPressed: () {
                            _immobileSignupDTO = _immobileSignupDTO.copyWith(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            nextPage();
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
                          controller: _nameController,
                          keyboardType: TextInputType.text,
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
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
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
                          onPressed: () {
                            _immobileSignupDTO = _immobileSignupDTO.copyWith(
                              name: _nameController.text,
                              phone: _phoneController.text,
                            );
                            nextPage();
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
                  Text(
                    "Dados do Imóvel",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _cepController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Cep',
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
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _valueController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Valor',
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
                              ),
                              const Gap(16),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: DropdownButton<TypeImmobile>(
                                    itemHeight: 50,
                                    isExpanded: true,
                                    hint: Center(
                                      child: Text(
                                        "Tipo",
                                        style: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    underline: const SizedBox.shrink(),
                                    borderRadius: BorderRadius.circular(40),
                                    value: _immobileSignupDTO.typeImmobile,
                                    onChanged: (value) {
                                      setState(() {
                                        _immobileSignupDTO =
                                            _immobileSignupDTO.copyWith(
                                          typeImmobile:
                                              value ?? TypeImmobile.none,
                                        );
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem(
                                        value: TypeImmobile.house,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Casa",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: TypeImmobile.apartment,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Apartamento",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  const Spacer(),
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
                          onPressed: () {
                            _immobileSignupDTO = _immobileSignupDTO.copyWith(
                              cep: _cepController.text,
                              value: num.tryParse(_valueController.text),
                            );
                            nextPage();
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
                    "Uma fotinha do imóvel!",
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
