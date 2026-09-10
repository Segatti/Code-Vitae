import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chat_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({
    super.key,
    required this.chat,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final IChatController controller;

  @override
  void initState() {
    super.initState();
    controller = inject<IChatController>();
    controller.initialize(widget.chat.id);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final messages = controller.messages;
        final isSending = controller.loadingList.contains('sendMessage');

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
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.chat.otherPhoto.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.chat.otherPhoto,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 40,
                          width: 40,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.person),
                        ),
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    widget.chat.otherName,
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(16),
              ],
            ),
          ),
          body: Column(
            children: [
              const Divider(height: 2, thickness: 2, color: Colors.black26),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: controller.loadingList.contains('loadMessages') &&
                              messages.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              reverse: true,
                              itemCount: messages.length,
                              padding: const EdgeInsets.only(bottom: 100),
                              itemBuilder: (context, index) {
                                final reversedIndex =
                                    messages.length - 1 - index;
                                final message = messages[reversedIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        mainAxisAlignment:
                                            message.isFromUser
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: message.isFromUser
                                            ? [
                                                Text(
                                                  _formatTime(
                                                    message.createdAt,
                                                  ),
                                                ),
                                                const Gap(8),
                                                _messageBubble(
                                                  message.content,
                                                  constraints.maxWidth * .8,
                                                  isUser: true,
                                                ),
                                              ]
                                            : [
                                                _messageBubble(
                                                  message.content,
                                                  constraints.maxWidth * .8,
                                                  isUser: false,
                                                ),
                                                const Gap(8),
                                                Text(
                                                  _formatTime(
                                                    message.createdAt,
                                                  ),
                                                ),
                                              ],
                                      );
                                    },
                                  ),
                                );
                              },
                              separatorBuilder: (_, _) => const Gap(16),
                            ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          top: 8,
                          right: 8,
                          left: 16,
                        ),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white24,
                              offset: Offset(-10, -10),
                              blurRadius: 40,
                            ),
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(10, 10),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.messageController,
                                decoration: const InputDecoration(
                                  hintText: "Mensagem",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 8),
                                ),
                                onFieldSubmitted: (_) async {
                                  await controller.sendMessage(
                                    widget.chat.id,
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: isSending
                                  ? null
                                  : () async {
                                      await controller.sendMessage(
                                        widget.chat.id,
                                      );
                                    },
                              icon: Icon(
                                isSending ? Icons.hourglass_empty : Icons.send,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _messageBubble(
    String text,
    double maxWidth, {
    required bool isUser,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUser ? Colors.blue : Colors.amber,
          width: 2,
        ),
      ),
      child: Text(
        text,
        maxLines: null,
        style: GoogleFonts.rubik(),
      ),
    );
  }
}
