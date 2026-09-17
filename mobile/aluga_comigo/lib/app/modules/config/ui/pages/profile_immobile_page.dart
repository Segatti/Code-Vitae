import 'package:aluga_comigo/app/modules/config/ui/controllers/profile_controller.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/presenter/formatters/money_formatter.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/primary_button.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/domain/enums/type_immobile.dart';
import '../../../customer/data/models/customer_model.dart';
import '../widgets/profile_immobile_extended_fields.dart';
import '../widgets/profile_photos_editor.dart';
import '../../../customer/presenter/widgets/house_flip_card.dart';

class ProfileImmobilePage extends StatefulWidget {
  final String? profileId;

  const ProfileImmobilePage({super.key, this.profileId});

  @override
  State<ProfileImmobilePage> createState() => _ProfileImmobilePageState();
}

class _ProfileImmobilePageState extends State<ProfileImmobilePage> {
  final controller = inject<IProfileController>();
  DateTime date = DateTime.now();

  final _priceController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  String? _formBoundCustomerId;

  void _bindFormFields(ImmobileCustomerModel customer) {
    if (_formBoundCustomerId == customer.id) return;
    _formBoundCustomerId = customer.id;
    _priceController.text =
        customer.price > 0 ? customer.price.toMoney() : '';
    _shortDescriptionController.text = customer.shortDescription;
    _longDescriptionController.text = customer.longDescription;
  }

  @override
  void initState() {
    super.initState();
    controller.initialize(profileId: widget.profileId);
    controller.addListener(_handleError);
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

    final customer = controller.customer;
    if (customer is! ImmobileCustomerModel) return;

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
    _priceController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
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

        final customer = controller.customer;
        if (customer is! ImmobileCustomerModel) {
          return const Center(
            child: Text('Não foi possível carregar o perfil do imóvel.'),
          );
        }

        _bindFormFields(customer);

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
                    widget.profileId != null
                        ? 'Detalhes do imóvel'
                        : 'Perfil',
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
                        ProfilePhotosEditor(controller: controller),
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
                                                  controller.patchImmobile(
                                                    (c) => c.copyWith(
                                                      typeImmobile:
                                                          TypeImmobile.house,
                                                    ),
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
                                                  controller.patchImmobile(
                                                    (c) => c.copyWith(
                                                      typeImmobile:
                                                          TypeImmobile
                                                              .apartment,
                                                    ),
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
                                        controller: _priceController,
                                        onChanged: (value) {
                                          final data =
                                              value.moneyToNumber() ?? 0;
                                          controller.patchImmobile(
                                            (c) => c.copyWith(
                                              price: data.toDouble(),
                                            ),
                                          );
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
                                      controller: _shortDescriptionController,
                                      style: GoogleFonts.rubik(
                                        height: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      onChanged: (value) {
                                        controller.patchImmobile(
                                          (c) => c.copyWith(
                                            shortDescription: value,
                                          ),
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
                                      controller: _longDescriptionController,
                                      style: GoogleFonts.rubik(
                                        height: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      onChanged: (value) {
                                        controller.patchImmobile(
                                          (c) => c.copyWith(
                                            longDescription: value,
                                          ),
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
                              ProfileImmobileExtendedFields(
                                controller: controller,
                                customer: customer,
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
