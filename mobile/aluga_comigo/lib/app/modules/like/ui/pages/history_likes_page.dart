import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/modules/like/data/models/rejected_history_item.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/history_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../../../shared/presenter/widgets/tabs.dart';
import '../widgets/history_flip_dialog.dart';

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
    tabSelected = 0;
    controller.initialize();
  }

  List<RejectedHistoryItem> _itemsForTab() {
    return switch (tabSelected) {
      0 => controller.persons,
      _ => controller.immobiles,
    };
  }

  String _itemTitle(CustomerModel customer) {
    if (tabSelected == 1) {
      return switch (customer) {
        ImmobileCustomerModel(:final typeImmobile) =>
          typeImmobile.title.isNotEmpty ? typeImmobile.title : 'Imóvel',
        PersonCustomerModel(:final name) => name,
      };
    }
    return switch (customer) {
      PersonCustomerModel(:final name) => name,
      ImmobileCustomerModel(:final shortDescription) =>
        shortDescription.isNotEmpty ? shortDescription : 'Imóvel',
    };
  }

  String? _itemSubtitle(CustomerModel customer) {
    if (tabSelected != 1) return null;
    return switch (customer) {
      ImmobileCustomerModel(:final price) => price.toMoney(useFree: false),
      _ => null,
    };
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
                          'Suas curtidas, favoritos e rejeições',
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
                              'Nenhuma interação nesta aba.',
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
                                        subtitle: _itemSubtitle(item.customer),
                                        photoUrl:
                                            item.customer.photos.isNotEmpty
                                            ? item.customer.photos.first
                                            : '',
                                        matchType: item.matchType,
                                        rejectedAt: item.rejectedAt,
                                        width: constraints.maxWidth * .3,
                                        onTap: () async {
                                          final updated =
                                              await HistoryFlipDialog.show(
                                                context,
                                                item,
                                              );
                                          if (updated == true && mounted) {
                                            controller.initialize();
                                          }
                                        },
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
  final String? subtitle;
  final String photoUrl;
  final MatchType matchType;
  final DateTime? rejectedAt;
  final double width;
  final VoidCallback? onTap;

  const _HistoryCard({
    required this.title,
    this.subtitle,
    required this.photoUrl,
    required this.matchType,
    required this.rejectedAt,
    required this.width,
    this.onTap,
  });

  static String _actionIconAsset(MatchType type) {
    return switch (type) {
      MatchType.like => IconsAsset.like,
      MatchType.favorite => IconsAsset.favorite,
      MatchType.unlike => IconsAsset.unlike,
      MatchType.none => IconsAsset.unlike,
    };
  }

  static Color _actionBadgeColor(MatchType type) {
    return switch (type) {
      MatchType.like => Colors.green.shade600,
      MatchType.favorite => Colors.amber.shade800,
      MatchType.unlike => Colors.red.shade700,
      MatchType.none => Colors.grey.shade600,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = rejectedAt == null
        ? ''
        : DateFormat('dd/MM/yy').format(rejectedAt!.toLocal());

    return SizedBox(
      width: width,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _actionBadgeColor(matchType),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          _actionIconAsset(matchType),
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(6),
          Text(
            title,
            maxLines: subtitle == null ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const Gap(2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
          if (dateLabel.isNotEmpty)
            Text(
              dateLabel,
              style: GoogleFonts.rubik(fontSize: 11, color: Colors.black45),
            ),
        ],
      ),
    );
  }
}
