import 'package:aluga_comigo/app/modules/config/ui/controllers/profile_controller.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/presenter/formatters/money_formatter.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../auth/domain/enums/user_desired_immobile.dart';
import '../../../auth/domain/enums/user_life_style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Modular.get<IProfileController>();
  DateTime date = DateTime.now();

  @override
  void initState() {
    controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _showDialog(Widget child) async {
    await showCupertinoModalPopup<void>(
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
                      controller.customer = controller.customer!.copyWith(
                        dateBirth: DateFormat("dd/MM/yyyy").format(date),
                      );
                      Navigator.of(context).pop();
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

    controller.updatePage();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        if (controller.loadingList.contains('getCustomer') ||
            controller.customer == null) {
          return const Center(child: CircularProgressIndicator());
        }
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
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Remove o foco quando toca fora dos campos
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              children: [
                const Divider(height: 2, thickness: 2),
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
                              for (var photo
                                  in controller.customer?.photos ?? [])
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
                                      imageUrl: photo,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          SizedBox.shrink(),
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
                                        controller: TextEditingController(
                                          text: controller.customer?.name ?? "",
                                        ),
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
                                    "Sexo",
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
                                            title: const Text('Qual seu sexo?'),
                                            actions: [
                                              CupertinoActionSheetAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      });
                                                  controller.customer =
                                                      controller.customer!
                                                          .copyWith(
                                                            gender: "Homem",
                                                          );
                                                  controller.updatePage();
                                                },
                                                child: Text("Homem"),
                                              ),
                                              CupertinoActionSheetAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      });
                                                  controller.customer =
                                                      controller.customer!
                                                          .copyWith(
                                                            gender: "Mulher",
                                                          );
                                                  controller.updatePage();
                                                },
                                                child: Text("Mulher"),
                                              ),
                                              CupertinoActionSheetAction(
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      });
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: const Color(0xFFEFEFEF),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller.customer!.gender,
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
                                            initialDateTime:
                                                controller
                                                    .customer!
                                                    .dateBirth
                                                    .isNotEmpty
                                                ? DateFormat(
                                                    "dd/MM/yyyy",
                                                  ).parse(
                                                    controller
                                                        .customer!
                                                        .dateBirth,
                                                  )
                                                : DateTime.now().subYears(19),
                                            maximumDate: DateTime.now()
                                                .subYears(18),
                                            mode: CupertinoDatePickerMode.date,
                                            onDateTimeChanged: (newDate) {
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: const Color(0xFFEFEFEF),
                                        ),
                                        child: Text(
                                          controller.customer!.dateBirth,
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
                                      controller: TextEditingController(
                                        text:
                                            controller
                                                .customer
                                                ?.shortDescription ??
                                            "",
                                      ),
                                      style: GoogleFonts.rubik(
                                        height: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      onChanged: (value) {
                                        controller.customer = controller
                                            .customer!
                                            .copyWith(shortDescription: value);
                                      },
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
                                        text:
                                            controller
                                                .customer
                                                ?.longDescription ??
                                            "",
                                      ),
                                      style: GoogleFonts.rubik(
                                        height: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      onChanged: (value) {
                                        controller.customer = controller
                                            .customer!
                                            .copyWith(longDescription: value);
                                      },
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
                                              'Qual tipo de Imóvel você deseja?',
                                            ),
                                            actions: [
                                              for (var desiredImmobile
                                                  in UserDesiredImmobile
                                                      .values) ...[
                                                if (desiredImmobile !=
                                                    UserDesiredImmobile
                                                        .none) ...[
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                            (_) {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                          );
                                                      controller
                                                          .customer = controller
                                                          .customer!
                                                          .copyWith(
                                                            desiredImmobile:
                                                                desiredImmobile,
                                                          );
                                                      controller.updatePage();
                                                    },
                                                    child: Text(
                                                      desiredImmobile.title,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                              CupertinoActionSheetAction(
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      });
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: const Color(0xFFEFEFEF),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller
                                                    .customer!
                                                    .desiredImmobile
                                                    .title,
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
                                        inputFormatters: [MoneyFormatter()],
                                        controller: TextEditingController(
                                          text:
                                              (controller
                                                      .customer!
                                                      .priceMaxImmobile >
                                                  0)
                                              ? controller
                                                        .customer
                                                        ?.priceMaxImmobile
                                                        .toMoney() ??
                                                    ""
                                              : 2000.toMoney(),
                                        ),
                                        onChanged: (value) {
                                          var data = value.moneyToNumber() ?? 0;
                                          print(data);
                                          if (data > 0) {
                                            controller.customer = controller
                                                .customer!
                                                .copyWith(
                                                  priceMaxImmobile: data
                                                      .toDouble(),
                                                );
                                          }
                                        },
                                        style: GoogleFonts.rubik(
                                          height: 1,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                          // prefixText: "R\$ ",
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
                                              'Qual seu estilo de vida?',
                                            ),
                                            actions: [
                                              for (var lifeStyle
                                                  in UserLifeStyle.values) ...[
                                                if (lifeStyle !=
                                                    UserLifeStyle.none) ...[
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                            (_) {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                          );
                                                      controller.customer =
                                                          controller.customer!
                                                              .copyWith(
                                                                lifeStyle:
                                                                    lifeStyle,
                                                              );
                                                      controller.updatePage();
                                                    },
                                                    child: Text(
                                                      lifeStyle.title,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                              CupertinoActionSheetAction(
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      });
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: const Color(0xFFEFEFEF),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller
                                                    .customer!
                                                    .lifeStyle
                                                    .title,
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
                                isLoading: controller.loadingList.contains(
                                  'updateProfile',
                                ),
                                onTap: () {
                                  controller.updateProfile();
                                },
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
          ),
        );
      },
    );
  }
}
