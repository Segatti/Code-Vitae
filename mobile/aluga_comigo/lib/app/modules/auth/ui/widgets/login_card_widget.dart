import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginCardWidget extends StatelessWidget {
  final VoidCallback backPage;
  const LoginCardWidget({super.key, required this.backPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2C29A3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      width: 330,
      child: Form(
        child: Column(
          children: [
            Text(
              "Login",
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(16),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                hintStyle: GoogleFonts.rubik(
                  fontSize: 18,
                ),
                contentPadding:
                    const EdgeInsets.only(left: 24.0, bottom: 8.0, top: 8.0),
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
                contentPadding:
                    const EdgeInsets.only(left: 24.0, bottom: 8.0, top: 8.0),
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
                  child: ElevatedButton(
                    onPressed: backPage,
                    style: ButtonStyle(
                      textStyle: MaterialStatePropertyAll(
                        GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    child: const Text("Voltar"),
                  ),
                ),
                const Gap(8),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    child: const Text("Entrar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
