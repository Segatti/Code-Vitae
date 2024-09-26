import 'dart:io';

import 'package:aluga_comigo/app/modules/auth/domain/entities/inputs/signup_input.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/data/services/camera_service.dart';
import '../../domain/enums/type_immobile.dart';
import 'card_auth_widget.dart';

class ImmobileStepWidget extends StatefulWidget {
  final VoidCallback backPage;
  final Function(SignupInput input) signup;
  const ImmobileStepWidget({
    super.key,
    required this.backPage,
    required this.signup,
  });

  @override
  State<ImmobileStepWidget> createState() => _ImmobileStepWidgetState();
}

class _ImmobileStepWidgetState extends State<ImmobileStepWidget> {
  final _controller = CarouselSliderController();
  var indexCarousel = 0;
  final _immobileInput = SignupImmobileInput();
  var acceptTerms = false;
  var haveError = false;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _valueController = TextEditingController();
  final service = Modular.get<CameraService>();

  Future<void> getImage(ImageSource imageSource) async {
    final result = await service.getImage(imageSource);
    if (result != null) {
      _immobileInput.photo = result.path;
      setState(() {});
    }
  }

  void notificationError(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(
                color: Colors.red,
                width: 5,
              ),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  message,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://drive.google.com/file/d/1Ob1x0-bLgEiZs7RYAqF7NfY2sNR51rBc/view?usp=drive_link"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
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
                                  onPressed: () async {
                                    if (acceptTerms == true) {
                                      await widget.signup(_immobileInput);
                                    }
                                  },
                                  borderRadius: 50,
                                  backgroundColor: (acceptTerms == true)
                                      ? Colors.green
                                      : Colors.grey,
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
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          onChanged: (_) {
                            if (haveError) {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  haveError = false;
                                });
                              }
                            }
                          },
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? text) {
                            String data = text?.trim() ?? '';
                            if (data.isEmpty) {
                              return "* Campo obrigatório";
                            }
                            if (!data.contains("@")) {
                              return "Insira um email valido";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            isDense: true,
                            hintText: 'Email',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            suffixIcon: JustTheTooltip(
                              backgroundColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              content: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  'Deve ser um email válido!',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              isModal: true,
                              child: const Icon(Icons.help),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _passwordController,
                          onChanged: (_) {
                            if (haveError) {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  haveError = false;
                                });
                              }
                            }
                          },
                          validator: (text) {
                            String data = text?.trim() ?? '';
                            if (data.isEmpty) {
                              return "* Campo obrigatório";
                            }
                            if (data.length < 7) {
                              return "Mínimo 7 caracteres";
                            }
                            return null;
                          },
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            hintText: 'Senha',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            suffixIcon: JustTheTooltip(
                              backgroundColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              content: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  'Mínimo 7 caracteres',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              isModal: true,
                              child: const Icon(Icons.help),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
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
                        child: ChicletAnimatedButton(
                          onPressed: backPage,
                          borderRadius: 50,
                          backgroundColor: Colors.red,
                          child: Text(
                            "Voltar",
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
                            if (_formKey.currentState?.validate() ?? false) {
                              _immobileInput.email = _emailController.text;
                              _immobileInput.password =
                                  _passwordController.text;
                              nextPage();
                            } else {
                              setState(() {
                                haveError = true;
                              });
                            }
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
                    key: _formKey2,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          onChanged: (_) {
                            if (haveError) {
                              if (_formKey2.currentState?.validate() ?? false) {
                                setState(() {
                                  haveError = false;
                                });
                              }
                            }
                          },
                          validator: (text) {
                            String data = text?.trim() ?? '';
                            if (data.isEmpty) {
                              return "* Campo obrigatório";
                            }
                            return null;
                          },
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nome Completo',
                            isDense: true,
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            suffixIcon: JustTheTooltip(
                              backgroundColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              content: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  'Campo obrigatório',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              isModal: true,
                              child: const Icon(Icons.help),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _phoneController,
                          onChanged: (_) {
                            if (haveError) {
                              if (_formKey2.currentState?.validate() ?? false) {
                                setState(() {
                                  haveError = false;
                                });
                              }
                            }
                          },
                          keyboardType: TextInputType.phone,
                          validator: (text) {
                            String data = text?.trim() ?? '';
                            if (data.isEmpty) {
                              return "* Campo obrigatório";
                            }
                            if (data.length != 11) {
                              return "Número invalido. Ex: XX 9XXXX XXXX";
                            }
                            return null;
                          },
                          maxLength: 11,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            fillColor: Colors.white,
                            counter: const SizedBox.shrink(),
                            hintText: 'Telefone',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            suffixIcon: JustTheTooltip(
                              backgroundColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              content: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  '(DDD) 9XXXX XXXX',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              isModal: true,
                              child: const Icon(Icons.help),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: ChicletAnimatedButton(
                          onPressed: backPage,
                          borderRadius: 50,
                          backgroundColor: Colors.red,
                          child: Text(
                            "Voltar",
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
                            if (_formKey2.currentState?.validate() ?? false) {
                              _immobileInput.name = _nameController.text;
                              _immobileInput.phone = _phoneController.text;
                              nextPage();
                            } else {
                              setState(() {
                                haveError = true;
                              });
                            }
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
                    key: _formKey3,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _cepController,
                          onChanged: (_) {
                            if (haveError) {
                              if (_formKey3.currentState?.validate() ?? false) {
                                setState(() {
                                  haveError = false;
                                });
                              }
                            }
                          },
                          keyboardType: TextInputType.number,
                          validator: (text) {
                            String data = text?.trim() ?? '';
                            if (data.isEmpty) {
                              return "* Campo obrigatório";
                            }
                            if (data.length != 8) {
                              return "Número invalido. Ex: XXXXX-XXX";
                            }
                            return null;
                          },
                          maxLength: 8,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            fillColor: Colors.white,
                            counter: const SizedBox.shrink(),
                            hintText: 'CEP',
                            hintStyle: GoogleFonts.rubik(
                              fontSize: 18,
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            suffixIcon: JustTheTooltip(
                              backgroundColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              content: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  'XXXXX-XXX',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              isModal: true,
                              child: const Icon(Icons.help),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 24.0, bottom: 8.0, top: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _valueController,
                                onChanged: (_) {
                                  if (haveError) {
                                    if (_formKey3.currentState?.validate() ??
                                        false) {
                                      setState(() {
                                        haveError = false;
                                      });
                                    }
                                  }
                                },
                                keyboardType: TextInputType.number,
                                validator: (text) {
                                  String data = text?.trim() ?? '';
                                  if (data.isEmpty) {
                                    return "* Campo obrigatório";
                                  }
                                  if (double.parse(data) <= 0) {
                                    return "Número invalido.";
                                  }
                                  return null;
                                },
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  isDense: true,
                                  fillColor: Colors.white,
                                  counter: const SizedBox.shrink(),
                                  hintText: 'Valor',
                                  hintStyle: GoogleFonts.rubik(
                                    fontSize: 18,
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 0,
                                  ),
                                  suffixIcon: JustTheTooltip(
                                    backgroundColor: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    content: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        'R\$ XXXX,XX',
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    isModal: true,
                                    child: const Icon(Icons.help),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 24.0, bottom: 8.0, top: 8.0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: DropdownButtonFormField<TypeImmobile>(
                                isExpanded: true,
                                isDense: true,
                                validator: (value) {
                                  if (value == null) {
                                    return "* Campo obrigatório";
                                  } else {
                                    return null;
                                  }
                                },
                                alignment: Alignment.center,
                                hint: Text(
                                  'Tipo',
                                  style: GoogleFonts.rubik(
                                    fontSize: 18,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  errorStyle: const TextStyle(
                                    fontSize: 0,
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    left: 24.0,
                                    bottom: 8.0,
                                    top: 8.0,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(40),
                                value: _immobileInput.typeImmobile,
                                onChanged: (value) {
                                  if (haveError) {
                                    if (_formKey3.currentState?.validate() ??
                                        false) {
                                      setState(() {
                                        haveError = false;
                                      });
                                    }
                                  }
                                  setState(() {
                                    _immobileInput.typeImmobile =
                                        value ?? TypeImmobile.none;
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: ChicletAnimatedButton(
                          onPressed: backPage,
                          borderRadius: 50,
                          backgroundColor: Colors.red,
                          child: Text(
                            "Voltar",
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
                            if ((_formKey3.currentState?.validate() ?? false) &&
                                _immobileInput.typeImmobile !=
                                    TypeImmobile.none) {
                              _immobileInput.cep = _cepController.text;
                              _immobileInput.value = num.tryParse(
                                    _valueController.text,
                                  ) ??
                                  0;
                              nextPage();
                            } else {
                              setState(() {
                                haveError = true;
                              });
                            }
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
                  (_immobileInput.photo.isNotEmpty)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 80,
                              height: 80,
                              child: Image.file(
                                File(_immobileInput.photo),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Gap(16),
                            GestureDetector(
                              onTap: () {
                                _immobileInput.photo = "";
                                setState(() {});
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                getImage(ImageSource.camera);
                              },
                              child: Container(
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
                            ),
                            GestureDetector(
                              onTap: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Container(
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
                            ),
                          ],
                        ),
                  const Spacer(),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: ChicletAnimatedButton(
                          onPressed: backPage,
                          borderRadius: 50,
                          backgroundColor: Colors.red,
                          child: Text(
                            "Voltar",
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
                          onPressed: (_immobileInput.photo.isNotEmpty)
                              ? nextPage
                              : null,
                          borderRadius: 50,
                          backgroundColor: (_immobileInput.photo.isNotEmpty)
                              ? Colors.green
                              : Colors.grey,
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
