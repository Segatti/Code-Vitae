import 'package:aluga_comigo/app/modules/chats/interactor/enums/message_type.dart';
import 'package:aluga_comigo/app/modules/chats/interactor/models/contact.dart';
import 'package:aluga_comigo/app/modules/chats/interactor/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String idChat;
  final Contact contact;
  const ChatPage({
    super.key,
    required this.idChat,
    required this.contact,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late List<Message> messages;

  @override
  void initState() {
    super.initState();
    messages = [
      Message(
        isFromUser: false,
        type: MessageType.text,
        dateTime: DateTime(2024, 3, 10),
        value: "Olá",
      ),
      Message(
        isFromUser: true,
        type: MessageType.text,
        dateTime: DateTime(2024, 3, 10),
        value:
            "Oi, Tudo bem?????????????????????????????????????????????????????????????????????????????",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
              child: CachedNetworkImage(
                imageUrl: widget.contact.photo!,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                widget.contact.name ?? '',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Gap(16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  color: Colors.grey,
                  child: Center(
                    child: Text(
                      "Perfil",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(16),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(
            height: 2,
            thickness: 2,
            color: Colors.black26,
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ListView.separated(
                    reverse: true,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == 0 ? 100 : 0,
                        left: 16,
                        right: 16,
                      ),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: messages[index].isFromUser!
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: messages[index].isFromUser!
                              ? [
                                  const Text("10:30"),
                                  const Gap(8),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth * .8,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      messages[index].value ?? '',
                                      maxLines: null,
                                      style: GoogleFonts.rubik(),
                                    ),
                                  ),
                                ]
                              : [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth * .8,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.amber,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      messages[index].value ?? '',
                                      maxLines: null,
                                      style: GoogleFonts.rubik(),
                                    ),
                                  ),
                                  const Gap(8),
                                  const Text("10:30"),
                                ],
                        );
                      }),
                    ),
                    separatorBuilder: (context, index) => const Gap(16),
                    itemCount: messages.length,
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
                            decoration: const InputDecoration(
                              hintText: "Mensagem",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 8,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send,
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
  }
}
