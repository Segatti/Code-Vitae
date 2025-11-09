import 'package:aluga_comigo/app/modules/auth/domain/enums/user_desired_immobile.dart';
import 'package:aluga_comigo/app/modules/auth/domain/enums/user_life_style.dart';
import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/customer_model.dart';

class CustomerProfileCard extends StatelessWidget {
  final PersonCustomerModel customer;
  final int Function(String) calculateAge;
  final String Function(UserSkill) getSkillName;
  final VoidCallback? onBackPressed;

  const CustomerProfileCard({
    super.key,
    required this.customer,
    required this.calculateAge,
    required this.getSkillName,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.white24,
            offset: Offset(-10, -10),
            blurRadius: 40,
          ),
          BoxShadow(
            color: Colors.black26,
            offset: Offset(10, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Descrição completa",
              style: GoogleFonts.rubik(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(4),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(8),
                      Text(
                        customer.longDescription.isNotEmpty
                            ? customer.longDescription
                            : customer.shortDescription,
                        maxLines: null,
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(8),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(8),
            Row(
              children: [
                const Text("Tarefas Domésticas"),
                const Gap(16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.orange,
                    fixedSize: const Size(100, 0),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Ver",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (customer.desiredImmobile != UserDesiredImmobile.none) ...[
              const Gap(8),
              Row(
                children: [
                  const Text("Imóvel desejado"),
                  const Gap(8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      customer.desiredImmobile.title,
                      style: GoogleFonts.rubik(),
                    ),
                  ),
                ],
              ),
            ],
            if (customer.priceMaxImmobile > 0) ...[
              const Gap(8),
              Row(
                children: [
                  const Text("Buscando imóvel até"),
                  const Gap(8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      customer.priceMaxImmobile.toMoney(),
                      style: GoogleFonts.rubik(),
                    ),
                  ),
                ],
              ),
            ],
            if (customer.lifeStyle != UserLifeStyle.none) ...[
              const Gap(8),
              Row(
                children: [
                  const Text("Estilo de vida"),
                  const Gap(8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      customer.lifeStyle.title,
                      style: GoogleFonts.rubik(),
                    ),
                  ),
                ],
              ),
            ],
            const Gap(8),
            const Row(
              children: [
                Expanded(child: Divider(thickness: 2)),
                Gap(8),
                Text("Habilidades"),
                Gap(8),
                Expanded(child: Divider(thickness: 2)),
              ],
            ),
            if (customer.skills.isNotEmpty) ...[
              const Gap(8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: customer.skills
                      .where((skill) => skill != UserSkill.none)
                      .map((skill) {
                        final skillName = getSkillName(skill);
                        if (skillName.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(skillName),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
            ],
            const Gap(16),
            if (onBackPressed != null)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: const BorderSide(width: 3, color: Colors.orange),
                      ),
                      onPressed: onBackPressed,
                      child: Text(
                        "Voltar",
                        style: GoogleFonts.rubik(
                          color: Colors.grey,
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
    );
  }
}
