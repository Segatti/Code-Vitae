import 'dart:io';

import 'package:aluga_comigo/app/modules/auth/interactor/DTOs/user_signup_dto.dart';
import 'package:aluga_comigo/app/modules/auth/interactor/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/auth/interactor/models/select_item.dart';
import 'package:aluga_comigo/app/modules/auth/ui/widgets/pill_widget.dart';
import 'package:aluga_comigo/app/shared/data/services/camera_service.dart';
import 'package:aluga_comigo/app/shared/data/services/firebase_storage_service.dart';
import 'package:aluga_comigo/app/shared/ui/widgets/popups/loading_popup.dart';
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

import '../../../../shared/data/services/firebase_auth_service.dart';
import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../../shared/data/services/secure_storage_service.dart';
import 'card_auth_widget.dart';

class UserStepWidget extends StatefulWidget {
  final VoidCallback backPage;
  const UserStepWidget({super.key, required this.backPage});

  @override
  State<UserStepWidget> createState() => _UserStepWidgetState();
}

class _UserStepWidgetState extends State<UserStepWidget> {
  final PageController _controller = PageController();
  int indexCarousel = 0;
  UserSignupDTO _userSignupDTO = const UserSignupDTO();
  bool acceptTerms = false;
  bool haveError = false;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final service = Modular.get<CameraService>();

  Future<void> getImage(ImageSource imageSource) async {
    final result = await service.getImage(imageSource);
    if (result != null) {
      _userSignupDTO = _userSignupDTO.copyWith(
        photos: [result.path],
      );
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
    FocusManager.instance.primaryFocus?.unfocus();
    if (indexCarousel == 0) {
      widget.backPage();
    } else {
      _controller.previousPage(
          duration: Durations.medium1, curve: Curves.linear);
      indexCarousel--;
    }
    setState(() {});
  }

  void nextPage() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (indexCarousel < 3) {
      _controller.nextPage(duration: Durations.medium1, curve: Curves.linear);
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
                                    showAdaptiveDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) =>
                                          const LoadingPopup(),
                                    );
                                    final auth =
                                        Modular.get<FirebaseAuthService>();
                                    final database =
                                        Modular.get<FirebaseDatabaseService>();
                                    final databasePhoto =
                                        Modular.get<FirebaseStorageService>();
                                    final storage =
                                        Modular.get<SecureStorageService>();

                                    final response = await auth.createUser(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    response.fold(
                                      (l) {
                                        Navigator.pop(context);
                                        notificationError(
                                          "Error - ${l.code}",
                                          l.message ?? '',
                                        );
                                      },
                                      (r) async {
                                        await Future.wait([
                                          storage.setData(
                                            StorageKey.userEmail,
                                            _emailController.text,
                                          ),
                                          storage.setData(
                                            StorageKey.userPassword,
                                            _passwordController.text,
                                          ),
                                          databasePhoto.upload(
                                            FirebaseStorageTables.users,
                                            "${r.user!.uid}/1",
                                            File(_userSignupDTO.photos!.first),
                                          ),
                                          database.create(
                                            FirebaseDataTables.users,
                                            {
                                              r.user!.uid: _userSignupDTO.toMap(
                                                toDatabase: true,
                                              ),
                                            },
                                          ),
                                        ]);

                                        Modular.to
                                            .navigate("/start/customers/");
                                      },
                                    );
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 267,
          child: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CardAuthWidget(
                children: [
                  Text(
                    "Dados de acesso",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
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
                              _userSignupDTO = _userSignupDTO.copyWith(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

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
                ],
              ),
              CardAuthWidget(
                children: [
                  Text(
                    "Dados pessoais",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
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
                              _userSignupDTO = _userSignupDTO.copyWith(
                                name: _nameController.text,
                                phone: _phoneController.text,
                              );

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
                ],
              ),
              CardAuthWidget(
                children: [
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
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            PillWidget(
                              initialValue: _userSignupDTO.skills?.contains(
                                UserSkill.cucaMaster,
                              ),
                              selectItem: const SelectItem(
                                title: "Mestre Cuca",
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
                              initialValue: _userSignupDTO.skills?.contains(
                                UserSkill.ninjaInSweeping,
                              ),
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
                              initialValue: _userSignupDTO.skills?.contains(
                                UserSkill.laundryOperator,
                              ),
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
                              initialValue: _userSignupDTO.skills?.contains(
                                UserSkill.humanDishwasher,
                              ),
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
                          onPressed:
                              (_userSignupDTO.skills?.isNotEmpty ?? false)
                                  ? nextPage
                                  : null,
                          borderRadius: 50,
                          backgroundColor:
                              (_userSignupDTO.skills?.isNotEmpty ?? false)
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
              CardAuthWidget(
                children: [
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
                  (_userSignupDTO.photos?.isNotEmpty ?? false)
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
                                File(_userSignupDTO.photos!.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Gap(16),
                            GestureDetector(
                              onTap: () {
                                _userSignupDTO = _userSignupDTO.copyWith(
                                  photos: [],
                                );
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
                          onPressed:
                              (_userSignupDTO.photos?.isNotEmpty ?? false)
                                  ? nextPage
                                  : null,
                          borderRadius: 50,
                          backgroundColor:
                              (_userSignupDTO.photos?.isNotEmpty ?? false)
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
            ],
          ),
        ),
        const Gap(16),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            child: AnimatedSmoothIndicator(
              activeIndex: indexCarousel,
              count: 4,
              effect: const WormEffect(),
            ),
          ),
        )
      ],
    );
  }
}
