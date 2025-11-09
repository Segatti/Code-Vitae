import 'dart:io';

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
import '../../../auth/domain/enums/user_housework.dart';
import '../../../auth/domain/enums/user_life_style.dart';
import '../../../auth/domain/enums/user_skill.dart';
import '../../../auth/domain/models/select_item.dart';
import '../../../auth/presenter/widgets/pill_widget.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/presenter/widgets/house_flip_card.dart';

class ProfileImmobilePage extends StatefulWidget {
  const ProfileImmobilePage({super.key});

  @override
  State<ProfileImmobilePage> createState() => _ProfileImmobilePageState();
}

class _ProfileImmobilePageState extends State<ProfileImmobilePage> {
  final controller = Modular.get<IProfileController>();
  DateTime date = DateTime.now();

  int _calculateAge(String dateBirth) {
    if (dateBirth.isEmpty) return 0;
    final date = dateBirth.toDate();
    if (date == null) return 0;
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  String _getSkillName(UserSkill skill) {
    switch (skill) {
      case UserSkill.cucaMaster:
        return "Mestre cuca";
      case UserSkill.ninjaInSweeping:
        return "Ninja na vassoura";
      case UserSkill.humanDishwasher:
        return "Lava-louças humano";
      case UserSkill.laundryOperator:
        return "Operador de lavanderia";
      case UserSkill.none:
        return "";
    }
  }

  @override
  void initState() {
    controller.initialize();
    // Listener para mostrar mensagens de erro
    controller.addListener(_handleError);
    super.initState();
  }

  void _handleError() {
    final errorMsg = controller.errorMessage;
    if (errorMsg != null && errorMsg.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && controller.errorMessage == errorMsg) {
          _showErrorDialog(errorMsg);
        }
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'Atenção',
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Gap(8),
                Text(
                  message,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                PrimaryButtonWidget(
                  title: 'OK',
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.errorMessage = null;
                    controller.updatePage();
                  },
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    if (controller.customer == null) return;

    final customer = controller.customer! as ImmobileCustomerModel;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: HouseFlipCard(immobile: customer),
            ),
            const Gap(16),
            Row(
              children: [
                const Gap(16),
                Expanded(
                  child: PrimaryButtonWidget(
                    title: "Fechar",
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Gap(16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillsDialog() {
    if (controller.customer == null) return;

    final currentSkills = List<UserSkill>.from(controller.customer!.skills);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SkillsDialog(
        initialSkills: currentSkills,
        getSkillName: _getSkillName,
        onSave: (selectedSkills) async {
          controller.customer = controller.customer!.copyWith(
            skills: selectedSkills,
          );
          await controller.updateProfile();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showHouseworksDialog() {
    if (controller.customer == null) return;

    final currentHouseworks = List<UserHousework>.from(
      controller.customer!.houseworks,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _HouseworksDialog(
        initialHouseworks: currentHouseworks,
        onSave: (selectedHouseworks) async {
          controller.customer = controller.customer!.copyWith(
            houseworks: selectedHouseworks,
          );
          await controller.updateProfile();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_handleError);
    controller.dispose();
    super.dispose();
  }

  Future<void> _showDialog(Widget child) async {
    if (controller.customer == null) return;

    final customer = controller.customer! as ImmobileCustomerModel;

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
                      controller.customer = customer.copyWith(
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

        final customer = controller.customer as ImmobileCustomerModel;
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
                  onPressed: () {
                    _showProfileDialog();
                  },
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
                              // Botão de adicionar foto (sempre primeiro)
                              if (controller.canAddMorePhotos)
                                GestureDetector(
                                  onTap: () {
                                    controller.selectPhotos();
                                  },
                                  child: Container(
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
                                ),
                              if (controller.canAddMorePhotos) const Gap(16),
                              // Fotos salvas
                              for (
                                var i = 0;
                                i < (controller.customer?.photos.length ?? 0);
                                i++
                              ) ...[
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
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
                                              controller.customer!.photos[i],
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                    // Ícone X para deletar (sempre visível)
                                    Positioned(
                                      top: -8,
                                      right: -8,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.removePhoto(i);
                                        },
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(16),
                              ],
                              // Fotos selecionadas antes de salvar
                              for (
                                var i = 0;
                                i < controller.selectedPhotos.length;
                                i++
                              ) ...[
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
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
                                        child: Image.file(
                                          File(
                                            controller.selectedPhotos[i].path,
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                    // Ícone X para deletar foto selecionada
                                    Positioned(
                                      top: -8,
                                      right: -8,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.removeSelectedPhoto(i);
                                        },
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(16),
                              ],
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
                                onTap: () {
                                  _showSkillsDialog();
                                },
                                color: const Color(0xFF2C29A3),
                                borderRadius: 10,
                              ),
                              const Gap(16),
                              PrimaryButtonWidget(
                                title: "Tarefas Domésticas",
                                onTap: () {
                                  _showHouseworksDialog();
                                },
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

class _SkillsDialog extends StatefulWidget {
  final List<UserSkill> initialSkills;
  final String Function(UserSkill) getSkillName;
  final Future<void> Function(List<UserSkill>) onSave;
  final VoidCallback onCancel;

  const _SkillsDialog({
    required this.initialSkills,
    required this.getSkillName,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_SkillsDialog> createState() => _SkillsDialogState();
}

class _SkillsDialogState extends State<_SkillsDialog> {
  late List<UserSkill> selectedSkills;

  @override
  void initState() {
    super.initState();
    selectedSkills = List<UserSkill>.from(widget.initialSkills);
  }

  @override
  Widget build(BuildContext context) {
    final availableSkills = UserSkill.values
        .where((skill) => skill != UserSkill.none)
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione suas habilidades',
              style: GoogleFonts.rubik(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            const Gap(24),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableSkills.map((skill) {
                    final isSelected = selectedSkills.contains(skill);
                    return PillWidget(
                      initialValue: isSelected,
                      selectItem: SelectItem(
                        title: widget.getSkillName(skill),
                        value: skill,
                      ),
                      onTap: (isSelected, value) {
                        setState(() {
                          if (isSelected) {
                            selectedSkills.add(value.value as UserSkill);
                          } else {
                            selectedSkills.remove(value.value as UserSkill);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: PrimaryButtonWidget(
                    title: "Fechar",
                    onTap: widget.onCancel,
                    color: Colors.grey,
                    borderRadius: 10,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: PrimaryButtonWidget(
                    title: "Salvar",
                    onTap: () async {
                      await widget.onSave(selectedSkills);
                    },
                    borderRadius: 10,
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

class _HouseworksDialog extends StatefulWidget {
  final List<UserHousework> initialHouseworks;
  final Future<void> Function(List<UserHousework>) onSave;
  final VoidCallback onCancel;

  const _HouseworksDialog({
    required this.initialHouseworks,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_HouseworksDialog> createState() => _HouseworksDialogState();
}

class _HouseworksDialogState extends State<_HouseworksDialog> {
  late List<UserHousework> selectedHouseworks;

  @override
  void initState() {
    super.initState();
    selectedHouseworks = List<UserHousework>.from(widget.initialHouseworks);
  }

  @override
  Widget build(BuildContext context) {
    final availableHouseworks = UserHousework.values
        .where((housework) => housework != UserHousework.none)
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione suas tarefas domésticas',
              style: GoogleFonts.rubik(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            const Gap(24),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableHouseworks.map((housework) {
                    final isSelected = selectedHouseworks.contains(housework);
                    return PillWidget(
                      initialValue: isSelected,
                      selectItem: SelectItem(
                        title: housework.title,
                        value: housework,
                      ),
                      onTap: (isSelected, value) {
                        setState(() {
                          if (isSelected) {
                            selectedHouseworks.add(
                              value.value as UserHousework,
                            );
                          } else {
                            selectedHouseworks.remove(
                              value.value as UserHousework,
                            );
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: PrimaryButtonWidget(
                    title: "Fechar",
                    onTap: widget.onCancel,
                    color: Colors.grey,
                    borderRadius: 10,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: PrimaryButtonWidget(
                    title: "Salvar",
                    onTap: () async {
                      await widget.onSave(selectedHouseworks);
                    },
                    borderRadius: 10,
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
