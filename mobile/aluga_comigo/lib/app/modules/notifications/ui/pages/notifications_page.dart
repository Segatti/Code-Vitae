import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/like/data/datasources/likes_datasource.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/data/services/supabase_database_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final DateTime? date;
  final IconData icon;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.date,
  });
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final ILikesDatasource _likesDatasource;
  late final SupabaseDatabaseService _database;

  List<_NotificationItem> items = [];
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _likesDatasource = inject<ILikesDatasource>();
    _database = inject<SupabaseDatabaseService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      errorMessage = '';
    });

    try {
      final notifications = <_NotificationItem>[];
      final likes = await _likesDatasource.getIncomingLikes();

      for (final like in likes) {
        final name = _customerName(like.customer);
        final label = like.matchType.name == 'favorite'
            ? 'deu Super Star em você'
            : 'curtiu você';
        notifications.add(
          _NotificationItem(
            title: name,
            subtitle: label,
            icon: like.matchType.name == 'favorite'
                ? Icons.star
                : Icons.favorite,
          ),
        );
      }

      final session = SessionService.customer;
      if (session != null) {
        final chats = await _database.listChatsForUser(session.id);
        for (final chat in chats) {
          final lastMessage = chat['lastMessagePreview']?.toString() ?? '';
          if (lastMessage.isEmpty) continue;
          final dateRaw = chat['lastMessageAt']?.toString();
          notifications.add(
            _NotificationItem(
              title: chat['otherName']?.toString() ?? 'Nova mensagem',
              subtitle: lastMessage,
              icon: Icons.chat_bubble_outline,
              date: dateRaw == null ? null : DateTime.tryParse(dateRaw),
            ),
          );
        }
      }

      items = notifications;
    } catch (_) {
      errorMessage = 'Erro ao carregar notificações';
      items = [];
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  String _customerName(CustomerModel customer) {
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
          icon: const Icon(Icons.chevron_left, size: 40, color: Colors.grey),
        ),
        titleSpacing: 0,
        title: Text(
          'Notificações',
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 2, thickness: 2),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : items.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhuma notificação por enquanto.',
                              style: GoogleFonts.rubik(color: Colors.black54),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Gap(12),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF2C29A3),
                                  child: Icon(item.icon, color: Colors.white),
                                ),
                                title: Text(
                                  item.title,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  item.subtitle,
                                  style: GoogleFonts.rubik(fontSize: 13),
                                ),
                                trailing: item.date == null
                                    ? null
                                    : Text(
                                        DateFormat('dd/MM HH:mm')
                                            .format(item.date!.toLocal()),
                                        style: GoogleFonts.rubik(
                                          fontSize: 11,
                                          color: Colors.black45,
                                        ),
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
