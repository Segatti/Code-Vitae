import 'package:aluga_comigo/app/modules/auth/domain/enums/type_user.dart';
import 'package:aluga_comigo/app/modules/store/interactor/enums/store_item_category.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/modules/store/interactor/models/store_catalog.dart';
import 'package:aluga_comigo/app/modules/store/interactor/models/store_product.dart';
import 'package:aluga_comigo/app/modules/store/ui/controllers/store_controller.dart';
import 'package:aluga_comigo/app/modules/store/ui/widgets/store_category_section.dart';
import 'package:aluga_comigo/app/modules/store/ui/widgets/store_first_purchase_offer.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:aluga_comigo/app/shared/data/services/analytics_service.dart';
import 'package:aluga_comigo/app/shared/domain/analytics/analytics_events.dart';
import 'package:aluga_comigo/app/shared/domain/constants/privacy_policy_catalog.dart';
import 'package:aluga_comigo/app/shared/domain/constants/terms_of_use_catalog.dart';
import 'package:aluga_comigo/app/shared/presenter/pages/privacy_policy_page.dart';
import 'package:aluga_comigo/app/shared/presenter/pages/terms_of_use_page.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/app_message_dialog.dart';
import 'package:material_ui/material_ui.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late final IStoreController controller;

  @override
  void initState() {
    super.initState();
    controller = inject<IStoreController>();
    controller.addListener(_onControllerUpdate);
    controller.initialize();
    inject<IAnalyticsService>().logEvent(AnalyticsEvents.storeView);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    final message = controller.purchaseSuccessMessage;
    if (message == null || !mounted) return;
    controller.purchaseSuccessMessage = null;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmPurchase(StoreProduct product) async {
    final isFirstOffer = product.id == StoreCatalog.firstPurchaseOffer.id;
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: isFirstOffer ? 'Oferta de primeira compra' : 'Confirmar compra',
      message: isFirstOffer
          ? 'Você recebe 7 dias de PowerUp, 5 Super Star e 5 Super Chat por '
              '${controller.priceFor(product)} (de ${product.compareAtPriceLabel}).\n\n'
              'Válido apenas uma vez, para quem nunca comprou na loja. '
              'Pagamento via Google Play ou App Store.'
          : '${product.label} — ${controller.priceFor(product)}\n\n'
              'O pagamento é processado pela loja do seu celular '
              '(Google Play ou App Store).',
      confirmLabel: isFirstOffer ? 'Garantir oferta' : 'Comprar agora',
    );

    if (confirmed == true && mounted) {
      await controller.purchase(product);
      if (!mounted) return;
      if (controller.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(controller.errorMessage)));
      }
    }
  }

  bool get _isImmobileOwner =>
      SessionService.customer?.typeUser == TypeUser.immobile;

  @override
  Widget build(BuildContext context) {
    final config = SessionService.systemConfig;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, size: 40, color: Colors.grey),
        ),
        titleSpacing: 0,
        title: Text(
          'Loja',
          style: GoogleFonts.rubik(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.loadingList.contains('initialize')) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!config.storeActive) {
            return Column(
              children: [
                const Divider(height: 2, thickness: 2),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'A loja está temporariamente indisponível.',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              const Divider(height: 2, thickness: 2),
              if (controller.errorMessage.isNotEmpty &&
                  !controller.storeAvailable)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    controller.errorMessage,
                    style: GoogleFonts.rubik(color: Colors.orange.shade800),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Destaque-se no match',
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        'Créditos e PowerUp para aparecer mais no feed, '
                        'conversar com destaque e ser lembrado por quem importa.',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: const Color(0xFF666666),
                          height: 1.35,
                        ),
                      ),
                      const Gap(16),
                      if (controller.firstPurchaseOfferEligible) ...[
                        StoreFirstPurchaseOffer(
                          product: StoreCatalog.firstPurchaseOffer,
                          priceLabel: controller.priceFor(
                            StoreCatalog.firstPurchaseOffer,
                          ),
                          compareAtPriceLabel: controller.compareAtPriceFor(
                            StoreCatalog.firstPurchaseOffer,
                          ),
                          isPurchasing: controller.purchasingProductId ==
                              StoreCatalog.firstPurchaseOffer.id,
                          onTap: () => _confirmPurchase(
                            StoreCatalog.firstPurchaseOffer,
                          ),
                        ),
                        const Gap(20),
                      ],
                      _BalancePanel(
                        showSuperStar: !_isImmobileOwner,
                        superStarBalance: controller.inventory.superStarBalance,
                        superChatBalance: controller.inventory.superChatBalance,
                        hasActivePowerUp:
                            SessionService.customer?.hasActivePowerUp ?? false,
                        powerUpUntil: SessionService.customer?.powerUpUntil,
                      ),
                      const Gap(24),
                      if (config.storePowerUpActive) ...[
                        StoreCategorySection(
                          category: StoreItemCategory.powerUp,
                          products: StoreCatalog.powerUpProducts,
                          priceFor: controller.priceFor,
                          purchasingProductId: controller.purchasingProductId,
                          onProductTap: _confirmPurchase,
                        ),
                      ],
                      if (!_isImmobileOwner &&
                          config.storeSuperStarActive) ...[
                        if (config.storePowerUpActive) const Gap(20),
                        StoreCategorySection(
                          category: StoreItemCategory.superStar,
                          products: StoreCatalog.superStarProducts,
                          priceFor: controller.priceFor,
                          purchasingProductId: controller.purchasingProductId,
                          onProductTap: _confirmPurchase,
                        ),
                      ],
                      if (config.storeSuperChatActive) ...[
                        if (config.storePowerUpActive ||
                            (!_isImmobileOwner &&
                                config.storeSuperStarActive))
                          const Gap(20),
                        StoreCategorySection(
                          category: StoreItemCategory.superChat,
                          products: StoreCatalog.superChatProducts,
                          priceFor: controller.priceFor,
                          purchasingProductId: controller.purchasingProductId,
                          onProductTap: _confirmPurchase,
                        ),
                      ],
                      if (!config.storePowerUpActive &&
                          !config.storeSuperChatActive &&
                          (_isImmobileOwner || !config.storeSuperStarActive))
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Text(
                            'Nenhuma categoria disponível no momento.',
                            style: GoogleFonts.rubik(color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const Gap(8),
                      Text(
                        'Compras seguras via Google Play ou App Store. '
                        'Créditos entram na sua conta assim que o pagamento '
                        'é confirmado. Reembolsos seguem as regras da loja '
                        'e o Código de Defesa do Consumidor quando aplicável.',
                        style: GoogleFonts.rubik(
                          fontSize: 11,
                          color: const Color(0xFF999999),
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(12),
                      TextButton(
                        onPressed: controller.loadingList.contains('restore')
                            ? null
                            : controller.restorePurchases,
                        child: controller.loadingList.contains('restore')
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                'Restaurar compras',
                                style: GoogleFonts.rubik(
                                  fontSize: 13,
                                  color: const Color(0xFF2C29A3),
                                ),
                              ),
                      ),
                      Text(
                        'Créditos consumíveis podem não ser restaurados em '
                        'todos os casos; use esta opção se a loja indicar '
                        'compras pendentes de entrega.',
                        style: GoogleFonts.rubik(
                          fontSize: 10,
                          color: const Color(0xFF999999),
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => TermsOfUsePage(
                                  version: TermsOfUseCatalog.defaultVersion,
                                ),
                              ),
                            ),
                            child: Text(
                              'Termos de uso',
                              style: GoogleFonts.rubik(fontSize: 12),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => PrivacyPolicyPage(
                                  version: PrivacyPolicyCatalog.defaultVersion,
                                ),
                              ),
                            ),
                            child: Text(
                              'Privacidade',
                              style: GoogleFonts.rubik(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BalancePanel extends StatelessWidget {
  final bool showSuperStar;
  final int superStarBalance;
  final int superChatBalance;
  final bool hasActivePowerUp;
  final DateTime? powerUpUntil;

  const _BalancePanel({
    required this.showSuperStar,
    required this.superStarBalance,
    required this.superChatBalance,
    required this.hasActivePowerUp,
    this.powerUpUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu saldo',
            style: GoogleFonts.rubik(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF777777),
            ),
          ),
          const Gap(10),
          Row(
            children: [
              if (showSuperStar)
                Expanded(
                  child: _BalanceTile(
                    assetPath: IconsAsset.superStar1,
                    label: 'Super Star',
                    value: superStarBalance,
                  ),
                ),
              if (showSuperStar) const Gap(10),
              Expanded(
                child: _BalanceTile(
                  assetPath: IconsAsset.superChat1,
                  label: 'Super Chat',
                  value: superChatBalance,
                ),
              ),
            ],
          ),
          const Gap(10),
          _PowerUpStatusTile(
            hasActivePowerUp: hasActivePowerUp,
            powerUpUntil: powerUpUntil,
          ),
        ],
      ),
    );
  }
}

class _PowerUpStatusTile extends StatelessWidget {
  final bool hasActivePowerUp;
  final DateTime? powerUpUntil;

  const _PowerUpStatusTile({
    required this.hasActivePowerUp,
    this.powerUpUntil,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = hasActivePowerUp
        ? const Color(0xFFDF924B)
        : const Color(0xFF777777);
    final statusLabel = hasActivePowerUp ? 'PowerUp ativo' : 'PowerUp inativo';
    final until = powerUpUntil;
    final expiresLabel = hasActivePowerUp && until != null
        ? 'Termina em ${DateFormat('dd/MM/yyyy \'às\' HH:mm').format(until.toLocal())}'
        : 'Compre um pacote para prioridade no feed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasActivePowerUp
              ? const Color(0xFFDF924B)
              : const Color(0xFFACACAC),
          width: hasActivePowerUp ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: SvgPicture.asset(IconsAsset.powerup1),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      statusLabel,
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    if (hasActivePowerUp) ...[
                      const Gap(6),
                      Icon(Icons.bolt_rounded, size: 16, color: statusColor),
                    ],
                  ],
                ),
                Text(
                  expiresLabel,
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    color: const Color(0xFF666666),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final String assetPath;
  final String label;
  final int value;

  const _BalanceTile({
    required this.assetPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFACACAC)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: SvgPicture.asset(assetPath),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    color: const Color(0xFF777777),
                  ),
                ),
                Text(
                  '$value crédito${value == 1 ? '' : 's'}',
                  style: GoogleFonts.rubik(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C29A3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
