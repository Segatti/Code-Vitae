import 'package:aluga_comigo/app/shared/data/services/secure_storage_service.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/data/services/firebase_auth_service.dart';

class LoginCardWidget extends StatelessWidget {
  final VoidCallback backPage;
  const LoginCardWidget({super.key, required this.backPage});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    Future login(String email, String password) async {
      final service = Modular.get<FirebaseAuthService>();
      final storage = Modular.get<SecureStorageService>();
      final response = await service.login(email, password);
      response.fold(
        (l) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text("Error - ${l.code}"),
              children: [
                Center(
                  child: Text(l.message.toString()),
                ),
              ],
            ),
          );
        },
        (r) async {
          await storage.setData(StorageKey.userEmail, email);
          await storage.setData(StorageKey.userPassword, password);
          Modular.to.navigate("/start/customers/");
        },
      );
    }

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
                    controller: password,
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
