import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/my_immobiles/ui/controllers/my_immobiles_controller.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/power_up_prompt_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class MyImmobilesListPage extends StatefulWidget {
  const MyImmobilesListPage({super.key});

  @override
  State<MyImmobilesListPage> createState() => _MyImmobilesListPageState();
}

class _MyImmobilesListPageState extends State<MyImmobilesListPage> {
  late final IMyImmobilesController controller;

  @override
  void initState() {
    super.initState();
    controller = inject<IMyImmobilesController>();
    final accountId = SessionService.customer?.id ?? '';
    if (accountId.isNotEmpty) {
      controller.initialize(accountId);
    }
  }

  String _title(ImmobileCustomerModel immobile) {
    if (immobile.shortDescription.isNotEmpty) {
      return immobile.shortDescription;
    }
    return immobile.typeImmobile.title.isNotEmpty
        ? immobile.typeImmobile.title
        : 'Imóvel';
  }

  void _openEdit(ImmobileCustomerModel immobile) {
    context.pushNamed(
      '/config/profile/immobile',
      arguments: {'immobileId': immobile.id},
    );
  }

  bool get _hasActivePowerUp =>
      SessionService.customer?.hasActivePowerUp ?? false;

  Future<void> _onAddImmobileTap() async {
    final accountId = SessionService.customer?.id ?? '';
    if (accountId.isEmpty) return;

    if (controller.immobiles.isNotEmpty && !_hasActivePowerUp) {
      await PowerUpPromptHelper.promptForAdditionalImmobileListing(context);
      return;
    }

    final created = await controller.createListing(accountId);
    if (!mounted || created == null) return;

    await controller.initialize(accountId);
    if (!mounted) return;
    _openEdit(created);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.loadingList.contains('loadImmobiles')) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.immobiles.isEmpty) {
          return Center(child: Text(controller.errorMessage));
        }

        final items = controller.immobiles;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Meus imóveis para alugar',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PrimaryButtonWidget(
                  title: 'Adicionar imóvel',
                  isLoading: controller.loadingList.contains('createListing'),
                  onTap: () => _onAddImmobileTap(),
                ),
              ),
              if (controller.errorMessage.isNotEmpty) ...[
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    controller.errorMessage,
                    style: GoogleFonts.rubik(color: Colors.red.shade700),
                  ),
                ),
              ],
              const Gap(12),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Nenhum imóvel cadastrado.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(color: Colors.black54),
                  ),
                )
              else
                ...items.map(
                  (immobile) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _ImmobileListTile(
                      title: _title(immobile),
                      subtitle: immobile.cityState,
                      priceLabel: immobile.price > 0
                          ? immobile.price.toMoney(useFree: false)
                          : null,
                      photoUrl: immobile.photos.isNotEmpty
                          ? immobile.photos.first
                          : '',
                      onTap: () => _openEdit(immobile),
                    ),
                  ),
                ),
              const Gap(90),
            ],
          ),
        );
      },
    );
  }
}

class _ImmobileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? priceLabel;
  final String photoUrl;
  final VoidCallback onTap;

  const _ImmobileListTile({
    required this.title,
    required this.subtitle,
    this.priceLabel,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: photoUrl.isEmpty
                    ? Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.home_outlined),
                      )
                    : CachedNetworkImage(
                        imageUrl: photoUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rubik(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const Gap(4),
                      Text(
                        subtitle,
                        style: GoogleFonts.rubik(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                    if (priceLabel != null) ...[
                      const Gap(4),
                      Text(
                        priceLabel!,
                        style: GoogleFonts.rubik(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2C29A3),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
