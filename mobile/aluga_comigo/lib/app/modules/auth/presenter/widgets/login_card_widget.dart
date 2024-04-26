import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginCardWidget extends StatefulWidget {
  final Function backPage;
  final Function(String email, String password) login;
  const LoginCardWidget({
    super.key,
    required this.backPage,
    required this.login,
  });

  @override
  State<LoginCardWidget> createState() => _LoginCardWidgetState();
}

class _LoginCardWidgetState extends State<LoginCardWidget> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool haveError = false;

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
                          onPressed: () => widget.backPage(),
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
                            if (_formKey.currentState?.validate() ?? false) {
                              widget.login(email.text, password.text);
                            }
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
