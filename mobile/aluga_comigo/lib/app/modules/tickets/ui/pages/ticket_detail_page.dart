import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/ticket_comment.dart';
import '../../domain/enums/ticket_reaction.dart';
import '../../domain/enums/ticket_status.dart';
import '../controllers/ticket_detail_controller.dart';
import '../controllers/tickets_controller.dart';
import '../widgets/ticket_category_chip.dart';
import '../widgets/ticket_reaction_buttons.dart';

class TicketDetailPage extends StatefulWidget {
  const TicketDetailPage({super.key, required this.ticketId});

  final String ticketId;

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late final ITicketDetailController controller;
  late final ITicketsController listController;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = inject<ITicketDetailController>();
    listController = inject<ITicketsController>();
    controller.load(widget.ticketId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _toggleReaction(TicketReaction reaction) async {
    await listController.toggleReaction(widget.ticketId, reaction);
    await controller.load(widget.ticketId);
  }

  Future<void> _sendComment() async {
    await controller.sendComment(_commentController.text);
    if (!mounted) return;
    if (controller.errorMessage.isEmpty) {
      _commentController.clear();
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
          'Ticket',
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.loading && controller.detail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty && controller.detail == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  controller.errorMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final detail = controller.detail;
          if (detail == null) {
            return const SizedBox.shrink();
          }

          final ticket = detail.ticket;
          final isOpen = ticket.status.isOpen;

          return Column(
            children: [
              const Divider(height: 2, thickness: 2),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ticket.title,
                            style: GoogleFonts.rubik(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TicketCategoryChip(category: ticket.category),
                      ],
                    ),
                    const Gap(8),
                    _StatusBanner(status: ticket.status),
                    const Gap(12),
                    Text(
                      ticket.description,
                      style: GoogleFonts.rubik(fontSize: 15, height: 1.4),
                    ),
                    const Gap(12),
                    TicketReactionButtons(
                      userReaction: ticket.userReaction,
                      onLike: () => _toggleReaction(TicketReaction.like),
                      onDislike: () => _toggleReaction(TicketReaction.dislike),
                    ),
                    const Gap(20),
                    Text(
                      'Comentários',
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    if (detail.comments.isEmpty)
                      Text(
                        'Nenhum comentário ainda.',
                        style: GoogleFonts.rubik(color: Colors.black54),
                      )
                    else
                      for (final comment in detail.comments)
                        _CommentBubble(comment: comment),
                    if (controller.errorMessage.isNotEmpty) ...[
                      const Gap(8),
                      Text(
                        controller.errorMessage,
                        style: GoogleFonts.rubik(color: Colors.red.shade700),
                      ),
                    ],
                  ],
                ),
              ),
              if (isOpen)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Escreva um comentário...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        const Gap(8),
                        IconButton.filled(
                          onPressed: controller.submittingComment
                              ? null
                              : _sendComment,
                          icon: controller.submittingComment
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send),
                        ),
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

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    if (status.isOpen) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        'Ticket finalizado — novos comentários estão desabilitados.',
        style: GoogleFonts.rubik(
          fontSize: 13,
          color: Colors.orange.shade900,
        ),
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  const _CommentBubble({required this.comment});

  final TicketComment comment;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('dd/MM/yyyy HH:mm').format(
      comment.createdAt.toLocal(),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.body,
            style: GoogleFonts.rubik(fontSize: 14),
          ),
          const Gap(4),
          Text(
            dateLabel,
            style: GoogleFonts.rubik(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
