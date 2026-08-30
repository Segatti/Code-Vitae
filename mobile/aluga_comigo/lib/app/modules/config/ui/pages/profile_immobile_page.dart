import 'dart:io';

import 'package:aluga_comigo/app/modules/config/ui/controllers/profile_controller.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/presenter/formatters/money_formatter.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/domain/enums/type_immobile.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/presenter/widgets/house_flip_card.dart';

class ProfileImmobilePage extends StatefulWidget {
  const ProfileImmobilePage({super.key});

  @override
  State<ProfileImmobilePage> createState() => _ProfileImmobilePageState();
}

class _ProfileImmobilePageState extends State<ProfileImmobilePage> {
  final controller = inject<IProfileController>();
  DateTime date = DateTime.now();

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

  @override
  void dispose() {
    controller.removeListener(_handleError);
    controller.dispose();
    super.dispose();
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
                                    "Tipo de Imóvel",
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
                                              'Qual tipo de Imóvel você deseja alugar?',
                                            ),
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
                                                  controller.customer = customer
                                                      .copyWith(
                                                        typeImmobile:
                                                            TypeImmobile.house,
                                                      );
                                                  controller.updatePage();
                                                },
                                                child: Text(
                                                  TypeImmobile.house.title,
                                                ),
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
                                                  controller.customer = customer
                                                      .copyWith(
                                                        typeImmobile:
                                                            TypeImmobile
                                                                .apartment,
                                                      );
                                                  controller.updatePage();
                                                },
                                                child: Text(
                                                  TypeImmobile.apartment.title,
                                                ),
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
                                                customer.typeImmobile.title,
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
                                    "Preço do Aluguel",
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
                                          text: (customer.price > 0)
                                              ? customer.price.toMoney()
                                              : '',
                                        ),
                                        onChanged: (value) {
                                          var data = value.moneyToNumber() ?? 0;
                                          if (data > 0) {
                                            controller.customer = customer
                                                .copyWith(
                                                  price: data.toDouble(),
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
                                        controller.customer = customer.copyWith(
                                          shortDescription: value,
                                        );
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
                                        controller.customer = customer.copyWith(
                                          longDescription: value,
                                        );
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
