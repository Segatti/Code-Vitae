import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/my_immobiles/domain/usecases/list_owned_immobiles.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class OfferImmobilePickerSheet extends StatefulWidget {
  final String excludeListingId;

  const OfferImmobilePickerSheet({
    super.key,
    this.excludeListingId = '',
  });

  static Future<ImmobileCustomerModel?> show(
    BuildContext context, {
    String excludeListingId = '',
  }) {
    return showModalBottomSheet<ImmobileCustomerModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OfferImmobilePickerSheet(excludeListingId: excludeListingId),
    );
  }

  @override
  State<OfferImmobilePickerSheet> createState() =>
      _OfferImmobilePickerSheetState();
}

class _OfferImmobilePickerSheetState extends State<OfferImmobilePickerSheet> {
  late final IListOwnedImmobiles _listOwnedImmobiles;
  var _loading = true;
  List<ImmobileCustomerModel> _listings = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _listOwnedImmobiles = inject<IListOwnedImmobiles>();
    _load();
  }

  Future<void> _load() async {
    final accountId = SessionService.customer?.id ?? '';
    final result = await _listOwnedImmobiles(accountId);
    if (!mounted) return;
    result.fold(
      (list) {
        setState(() {
          _listings = list
              .where((i) => i.id != widget.excludeListingId)
              .toList();
          _loading = false;
        });
      },
      (_) {
        setState(() {
          _error = 'Erro ao carregar imóveis';
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.55;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Oferecer imóvel',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(12),
            SizedBox(
              height: maxHeight,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _listings.isEmpty
                          ? Center(
                              child: Text(
                                'Nenhum outro imóvel disponível',
                                style: GoogleFonts.rubik(color: Colors.black54),
                              ),
                            )
                          : ListView.separated(
                              itemCount: _listings.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = _listings[index];
                                final photo = item.photos.isNotEmpty
                                    ? item.photos.first
                                    : '';
                                return ListTile(
                                  onTap: () => Navigator.of(context).pop(item),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: photo.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: photo,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 48,
                                            height: 48,
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.home),
                                          ),
                                  ),
                                  title: Text(
                                    item.shortDescription.isNotEmpty
                                        ? item.shortDescription
                                        : 'Imóvel',
                                    style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.cityState,
                                    style: GoogleFonts.rubik(fontSize: 12),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
