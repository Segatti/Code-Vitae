import 'package:aluga_comigo/app/shared/data/services/secure_storage_service.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/data/services/firebase_auth_service.dart';
import '../../../../shared/ui/widgets/popups/loading_popup.dart';

class LoginCardWidget extends StatefulWidget {
  final VoidCallback backPage;
  const LoginCardWidget({super.key, required this.backPage});

  @override
  State<LoginCardWidget> createState() => _LoginCardWidgetState();
}

class _LoginCardWidgetState extends State<LoginCardWidget> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool haveError = false;

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

  Future login(String email, String password) async {
    final service = Modular.get<FirebaseAuthService>();
    final storage = Modular.get<SecureStorageService>();
    if (_formKey.currentState?.validate() ?? false) {
      showAdaptiveDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const LoadingPopup(),
      );
      final response = await service.login(email, password);
      response.fold(
        (l) {
          Navigator.pop(context);
          notificationError(
            "Error - ${l.code}",
            l.message ?? '',
          );
        },
        (r) async {
          await storage.setData(StorageKey.userEmail, email);
          await storage.setData(StorageKey.userPassword, password);
          Modular.to.navigate("/start/customers/");
        },
      );
    } else {
      setState(() {
        haveError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Login",
                    textScaler: const TextScaler.linear(1),
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: email,
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
                    controller: password,
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
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: ChicletAnimatedButton(
                          onPressed: widget.backPage,
                          borderRadius: 50,
                          backgroundColor: Colors.red,
                          child: Text(
                            "Voltar",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: ChicletAnimatedButton(
                          onPressed: () {
                            login(email.text, password.text);
                          },
                          borderRadius: 50,
                          backgroundColor: Colors.green,
                          child: Text(
                            "Entrar",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
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
          ),
        ],
      ),
    );
  }
}
