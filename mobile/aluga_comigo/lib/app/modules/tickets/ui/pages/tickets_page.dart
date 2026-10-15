import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/enums/ticket_category.dart';
import '../../domain/enums/ticket_reaction.dart';
import '../../domain/enums/ticket_status.dart';
import '../controllers/tickets_controller.dart';
import '../widgets/ticket_category_chip.dart';
import '../widgets/ticket_reaction_buttons.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  late final ITicketsController controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    controller = inject<ITicketsController>();
    _scrollController = ScrollController()..addListener(_onScroll);
    controller.initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      controller.loadMore();
    }
  }

  Future<void> _openCreate() async {
    final created = await context.pushNamed<bool>('/tickets/new');
    if (created == true && mounted) {
      await controller.refresh();
    }
  }

  Future<void> _openDetail(String ticketId) async {
    await context.pushNamed(
      '/tickets/detail',
      arguments: {'ticketId': ticketId},
    );
    if (mounted) {
      await controller.refresh();
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
          'Suporte',
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        backgroundColor: const Color(0xFF2C29A3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const Divider(height: 2, thickness: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar tickets...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
              onChanged: controller.updateSearch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<TicketCategory?>(
                        initialValue: controller.categoryFilter,
                        decoration: InputDecoration(
                          labelText: 'Categoria',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<TicketCategory?>(
                            value: null,
                            child: Text('Todas'),
                          ),
                          for (final category in TicketCategory.values)
                            DropdownMenuItem(
                              value: category,
                              child: Text(category.label),
                            ),
                        ],
                        onChanged: controller.setCategoryFilter,
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: DropdownButtonFormField<TicketStatus?>(
                        initialValue: controller.statusFilter,
                        decoration: InputDecoration(
                          labelText: 'Situação',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<TicketStatus?>(
                            value: null,
                            child: Text('Todos'),
                          ),
                          DropdownMenuItem(
                            value: TicketStatus.open,
                            child: Text('Abertos'),
                          ),
                          DropdownMenuItem(
                            value: TicketStatus.closed,
                            child: Text('Finalizados'),
                          ),
                        ],
                        onChanged: controller.setStatusFilter,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (controller.loadingList.contains('loadTickets') &&
                    controller.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty &&
                    controller.items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        controller.errorMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(color: Colors.black54),
                      ),
                    ),
                  );
                }

                if (controller.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum ticket encontrado.',
                      style: GoogleFonts.rubik(color: Colors.black54),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                    itemCount: controller.items.length +
                        (controller.loadingList.contains('loadMoreTickets')
                            ? 1
                            : 0),
                    separatorBuilder: (_, _) => const Gap(8),
                    itemBuilder: (context, index) {
                      if (index >= controller.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final ticket = controller.items[index];
                      final dateLabel = DateFormat('dd/MM/yyyy HH:mm')
                          .format(ticket.createdAt.toLocal());

                      return Material(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _openDetail(ticket.id),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ticket.title,
                                        style: GoogleFonts.rubik(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TicketCategoryChip(
                                      category: ticket.category,
                                    ),
                                  ],
                                ),
                                if (!ticket.status.isOpen) ...[
                                  const Gap(6),
                                  Text(
                                    'Finalizado',
                                    style: GoogleFonts.rubik(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                ],
                                const Gap(6),
                                Text(
                                  ticket.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Gap(8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dateLabel,
                                        style: GoogleFonts.rubik(
                                          fontSize: 12,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    TicketReactionButtons(
                                      userReaction: ticket.userReaction,
                                      onLike: () => controller.toggleReaction(
                                        ticket.id,
                                        TicketReaction.like,
                                      ),
                                      onDislike: () => controller.toggleReaction(
                                        ticket.id,
                                        TicketReaction.dislike,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
