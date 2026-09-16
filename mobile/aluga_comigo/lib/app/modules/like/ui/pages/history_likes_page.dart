import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/like/data/models/rejected_history_item.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/history_controller.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../../../shared/presenter/widgets/tabs.dart';
import '../../../auth/domain/enums/type_user.dart';

class HistoryLikesPage extends StatefulWidget {
  const HistoryLikesPage({super.key});

  @override
  State<HistoryLikesPage> createState() => _HistoryLikesPageState();
}

class _HistoryLikesPageState extends State<HistoryLikesPage> {
  late final IHistoryController controller;
  late int tabSelected;

  @override
  void initState() {
    super.initState();
    controller = inject<IHistoryController>();
    tabSelected = SessionService.customer?.typeUser == TypeUser.person ? 1 : 0;
    controller.initialize();
  }

  List<RejectedHistoryItem> _itemsForTab() {
    return switch (tabSelected) {
      0 => controller.persons,
      _ => controller.immobiles,
    };
  }

  String _itemTitle(CustomerModel customer) {
    return switch (customer) {
      PersonCustomerModel(:final name) => name,
      ImmobileCustomerModel(:final shortDescription) =>
        shortDescription.isNotEmpty ? shortDescription : 'Imóvel',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.grey,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Histórico',
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
          if (controller.loadingList.contains('loadHistory')) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage));
          }

          final items = _itemsForTab();

          return Column(
            children: [
              const Divider(height: 2, thickness: 2),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(16),
                        Text(
                          'Perfis que você rejeitou',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const Gap(12),
                        TabsWidget(
                          values: const ['Pessoas', 'Imóveis'],
                          valueSelected: tabSelected,
                          onChange: (value) => setState(() {
                            tabSelected = value;
                          }),
                        ),
                        const Gap(16),
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text(
                              'Nenhuma rejeição nesta aba.',
                              style: GoogleFonts.rubik(color: Colors.black54),
                            ),
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  spacing: constraints.maxWidth * .1 / 2,
                                  runSpacing: 16,
                                  children: [
                                    for (final item in items)
                                      _HistoryCard(
                                        title: _itemTitle(item.customer),
                                        photoUrl: item.customer.photos.isNotEmpty
                                            ? item.customer.photos.first
                                            : '',
                                        rejectedAt: item.rejectedAt,
                                        width: constraints.maxWidth * .3,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        const Gap(16),
                      ],
                    ),
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

class _HistoryCard extends StatelessWidget {
  final String title;
  final String photoUrl;
  final DateTime? rejectedAt;
  final double width;

  const _HistoryCard({
    required this.title,
    required this.photoUrl,
    required this.rejectedAt,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = rejectedAt == null
        ? ''
        : DateFormat('dd/MM/yy').format(rejectedAt!.toLocal());

    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            width: width,
            height: width * 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  photoUrl.isEmpty
                      ? Container(color: Colors.grey.shade300)
                      : CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              Container(color: Colors.grey.shade300),
                        ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (dateLabel.isNotEmpty)
            Text(
              dateLabel,
              style: GoogleFonts.rubik(
                fontSize: 11,
                color: Colors.black45,
              ),
            ),
        ],
      ),
    );
  }
}
