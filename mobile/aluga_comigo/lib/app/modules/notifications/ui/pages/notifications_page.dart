import 'package:aluga_comigo/app/modules/notifications/domain/entities/app_notification.dart';
import 'package:aluga_comigo/app/modules/notifications/ui/controllers/notifications_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final INotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = inject<INotificationsController>();
    controller.initialize();
  }

  IconData _iconFor(AppNotificationType type) {
    return switch (type) {
      AppNotificationType.like => Icons.favorite,
      AppNotificationType.superStar => Icons.star,
      AppNotificationType.superChat => Icons.chat_bubble,
      AppNotificationType.questCompleted => Icons.emoji_events_outlined,
    };
  }

  Color _iconColorFor(AppNotificationType type) {
    return switch (type) {
      AppNotificationType.like => const Color(0xFF2C29A3),
      AppNotificationType.superStar => Colors.amber.shade800,
      AppNotificationType.superChat => const Color(0xFFFFC850),
      AppNotificationType.questCompleted => Colors.green.shade700,
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
          style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 2, thickness: 2),
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (controller.loadingList.contains('loadNotifications')) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage));
                }

                if (controller.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma notificação por enquanto.',
                      style: GoogleFonts.rubik(color: Colors.black54),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _iconColorFor(item.type),
                        child: Icon(_iconFor(item.type), color: Colors.white),
                      ),
                      title: Text(
                        item.title,
                        style: GoogleFonts.rubik(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        item.body,
                        style: GoogleFonts.rubik(fontSize: 13),
                      ),
                      trailing: item.createdAt == null
                          ? null
                          : Text(
                              DateFormat(
                                'dd/MM HH:mm',
                              ).format(item.createdAt!.toLocal()),
                              style: GoogleFonts.rubik(
                                fontSize: 11,
                                color: Colors.black45,
                              ),
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
