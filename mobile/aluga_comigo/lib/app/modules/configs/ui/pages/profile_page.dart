import 'package:aluga_comigo/app/shared/ui/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime date = DateTime.now();

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: child),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PrimaryButtonWidget(
                    height: 50,
                    borderRadius: 10,
                    onTap: () {
                      Navigator.of(context).pop();
                      // Salvar
                    },
                    title: "Confirmar",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.grey,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Perfil',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Visualizar",
                style: GoogleFonts.rubik(
                  color: const Color(0xFF2C29A3),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(
            height: 2,
            thickness: 2,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(32),
                  SizedBox(
                    height: 155,
                    child: ListView(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      children: [
                        const Gap(16),
                        Container(
                          width: 115,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white24,
                                offset: Offset(-5, -5),
                                blurRadius: 20,
                              ),
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(5, 5),
                                blurRadius: 20,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4WP2MsbDRCViQDfYrBBElK0lOlMdPdtlvnw&usqp=CAU",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Gap(16),
                        Container(
                          height: 155,
                          width: 115,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white24,
                                offset: Offset(-5, -5),
                                blurRadius: 20,
                              ),
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(5, 5),
                                blurRadius: 20,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD9D9D9),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF7C7C7C),
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                      ],
                    ),
                  ),
                  const Gap(32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Nome",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFEFEFEF),
                                ),
                                child: TextFormField(
                                  controller:
                                      TextEditingController(text: "Vittor"),
                                  style: GoogleFonts.rubik(
                                    height: 1,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Text(
                              "Data de Nascimento",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _showDialog(
                                    CupertinoDatePicker(
                                      initialDateTime: date,
                                      maximumDate: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() => date = newDate);
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFEFEFEF),
                                  ),
                                  child: Text(
                                    date.format("dd/MM/yyyy"),
                                    style: GoogleFonts.rubik(
                                      height: 1,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Descrição Breve",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFEFEFEF),
                              ),
                              child: TextFormField(
                                controller:
                                    TextEditingController(text: "Gosto de..."),
                                style: GoogleFonts.rubik(
                                  height: 1,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                maxLines: null,
                                maxLength: 200,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Descrição Completa",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFEFEFEF),
                              ),
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: "Gosto de casa organizada"),
                                style: GoogleFonts.rubik(
                                  height: 1,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Text(
                              "Imóvel desejado",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => CupertinoActionSheet(
                                      title: const Text(
                                          'Qual tipo de Imóvel você deseja?'),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Casa'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Apartamento'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child:
                                              const Text('Casa ou Apartamento'),
                                        ),
                                        CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFEFEFEF),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Casa",
                                          style: GoogleFonts.rubik(
                                            height: 1,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Gap(16),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Text(
                              "Buscando Imóvel até",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFEFEFEF),
                                ),
                                child: TextFormField(
                                  controller:
                                      TextEditingController(text: "1500,00"),
                                  style: GoogleFonts.rubik(
                                    height: 1,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    prefixText: "R\$ ",
                                    prefixStyle: GoogleFonts.rubik(
                                      height: 1,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Text(
                              "Estilo de Vida",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => CupertinoActionSheet(
                                      title: const Text(
                                          'Qual seu estilo de vida?'),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Festeiro'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Só fico em casa'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child:
                                              const Text('Focado no trabalho'),
                                        ),
                                        CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFEFEFEF),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Festeiro",
                                          style: GoogleFonts.rubik(
                                            height: 1,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Gap(16),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        PrimaryButtonWidget(
                          title: "Habilidades",
                          onTap: () {},
                          color: const Color(0xFF2C29A3),
                          borderRadius: 10,
                        ),
                        const Gap(16),
                        PrimaryButtonWidget(
                          title: "Tarefas Domésticas",
                          onTap: () {},
                          color: const Color(0xFF2C29A3),
                          borderRadius: 10,
                        ),
                        const Gap(16),
                        PrimaryButtonWidget(
                          title: "Salvar",
                          onTap: () {},
                          borderRadius: 10,
                        ),
                        const Gap(16),
                      ],
                    ),
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
