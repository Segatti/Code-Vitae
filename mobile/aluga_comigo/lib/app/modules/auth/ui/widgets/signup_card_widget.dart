import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/ui/widgets/terciary_button.dart';

class SignupCardWidget extends StatelessWidget {
  final VoidCallback backPage;
  const SignupCardWidget({super.key, required this.backPage});

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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
