import 'package:aluga_comigo/app/modules/store/interactor/enums/store_item_category.dart';
import 'package:aluga_comigo/app/modules/store/interactor/models/store_catalog.dart';
import 'package:aluga_comigo/app/modules/store/interactor/models/store_product.dart';
import 'package:aluga_comigo/app/modules/store/ui/controllers/store_controller.dart';
import 'package:aluga_comigo/app/modules/store/ui/widgets/store_category_section.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.label),
        content: Text(
          'Confirmar compra por ${controller.priceFor(product)}?',
          style: GoogleFonts.rubik(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Comprar'),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BalanceChip(
                      icon: Icons.star,
                      label: 'Super Star',
                      value: controller.inventory.superStarBalance,
                    ),
                    _BalanceChip(
                      icon: Icons.chat_bubble,
                      label: 'Super Chat',
                      value: controller.inventory.superChatBalance,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      StoreCategorySection(
                        category: StoreItemCategory.powerUp,
                        backgroundColor: const Color(0xFFFFF3E0),
                        headerColor: const Color(0xFFDF924B),
                        headerTextColor: Colors.white,
                        descriptionTextColor: const Color(0xFF5D4037),
                        products: StoreCatalog.powerUpProducts,
                        priceFor: controller.priceFor,
                        purchasingProductId: controller.purchasingProductId,
                        onProductTap: _confirmPurchase,
                      ),
                      const Gap(32),
                      StoreCategorySection(
                        category: StoreItemCategory.superStar,
                        backgroundColor: const Color(0xFFFFDC64),
                        headerColor: const Color(0xFFFFC850),
                        headerTextColor: Colors.black,
                        products: StoreCatalog.superStarProducts,
                        priceFor: controller.priceFor,
                        purchasingProductId: controller.purchasingProductId,
                        onProductTap: _confirmPurchase,
                      ),
                      const Gap(32),
                      StoreCategorySection(
                        category: StoreItemCategory.superChat,
                        backgroundColor: const Color(0xFF605DDE),
                        headerColor: const Color(0xFF5350C3),
                        headerTextColor: Colors.white,
                        products: StoreCatalog.superChatProducts,
                        priceFor: controller.priceFor,
                        purchasingProductId: controller.purchasingProductId,
                        onProductTap: _confirmPurchase,
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

class _BalanceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _BalanceChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2C29A3)),
        const Gap(6),
        Text(
          '$label: $value',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
