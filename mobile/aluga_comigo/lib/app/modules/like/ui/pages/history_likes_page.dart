import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/likes_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/presenter/widgets/tabs.dart';

class HistoryLikesPage extends StatefulWidget {
  const HistoryLikesPage({super.key});

  @override
  State<HistoryLikesPage> createState() => _HistoryLikesPageState();
}

class _HistoryLikesPageState extends State<HistoryLikesPage> {
  final controller = inject<ILikesController>();
  int tabSelected = 0;

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  List<CustomerModel> _itemsForTab() {
    return switch (tabSelected) {
      0 => controller.persons,
      _ => controller.immobiles,
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
          'Historico',
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
          if (controller.loadingList.contains('loadLikes')) {
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
                              'Nenhum registro nesta aba.',
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
                                        photoUrl: item.photos.isNotEmpty
                                            ? item.photos.first
                                            : '',
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
  final String photoUrl;
  final double width;

  const _HistoryCard({
    required this.photoUrl,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: photoUrl.isEmpty
            ? Container(color: Colors.grey.shade300)
            : CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(color: Colors.grey.shade300),
              ),
      ),
    );
  }
}
