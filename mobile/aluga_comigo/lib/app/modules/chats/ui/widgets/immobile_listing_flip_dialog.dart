import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/house_flip_card.dart';
import 'package:aluga_comigo/app/shared/domain/helpers/maps_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class ImmobileListingFlipDialog extends StatelessWidget {
  final ImmobileCustomerModel immobile;
  final String? ownerDisplayName;

  const ImmobileListingFlipDialog({
    super.key,
    required this.immobile,
    this.ownerDisplayName,
  });

  static Future<void> show(
    BuildContext context,
    ImmobileCustomerModel immobile, {
    String? ownerDisplayName,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ImmobileListingFlipDialog(
        immobile: immobile,
        ownerDisplayName: ownerDisplayName,
      ),
    );
  }

  Future<bool> _onVerMais(BuildContext context, FlipCardController c) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return false;
    }
    c.toggleCard();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.62;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: maxHeight,
              width: double.infinity,
              child: HouseFlipCard(
                immobile: immobile,
                height: maxHeight,
                ownerDisplayName: ownerDisplayName,
                onVerMaisPressed: (c) => _onVerMais(context, c),
                onVerNoMapaPressed: () {
                  MapsHelper.openLocation(
                    cep: immobile.cep,
                    cityState: immobile.cityState,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                immobile.shortDescription.isNotEmpty
                    ? immobile.shortDescription
                    : 'Imóvel',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
