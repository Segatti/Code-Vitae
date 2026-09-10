import 'package:aluga_comigo/app/modules/auth/domain/enums/type_user.dart';
import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chats_list_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/pages/contact_list_page.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../shared/presenter/widgets/tabs.dart';

class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  final controller = inject<IChatsListController>();
  int tabSelected = 0;

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  List<Chat> _filteredChats() {
    final isPerson =
        SessionService.customer?.typeUser == TypeUser.person;
    if (tabSelected == 0) {
      return isPerson ? [] : controller.chats;
    }
    return isPerson ? controller.chats : [];
  }

  String _formatLastMessageAt(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inHours < 1) return 'Há ${diff.inMinutes} min';
    if (diff.inDays < 1) return DateFormat('HH:mm').format(dateTime);
    if (diff.inDays < 7) return 'Há ${diff.inDays} dia(s)';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final chats = _filteredChats();
        final isLoading = controller.loadingList.contains('loadChats');

        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  TabsWidget(
                    values: const ["Pessoas", "Imóveis"],
                    valueSelected: tabSelected,
                    onChange: (value) => setState(() {
                      tabSelected = value;
                    }),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      padding: const EdgeInsetsDirectional.only(
                        bottom: 0,
                        top: 8,
                        end: 8,
                        start: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
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
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3A3A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          fillColor: Colors.grey,
                                          filled: true,
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "Pesquisar por nome",
                                          hintStyle: GoogleFonts.rubik(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: isLoading && chats.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : chats.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'Nenhuma conversa ainda',
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: chats.length,
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  final chat = chats[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      context.pushNamed(
                                                        './chat',
                                                        arguments: {
                                                          'chat': chat,
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 55,
                                                      color: Colors.white,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .symmetric(
                                                        horizontal: 8,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              10,
                                                            ),
                                                            child: chat.otherPhoto
                                                                    .isNotEmpty
                                                                ? CachedNetworkImage(
                                                                    imageUrl: chat
                                                                        .otherPhoto,
                                                                    width: 50,
                                                                    height: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    child: const Icon(
                                                                      Icons
                                                                          .person,
                                                                    ),
                                                                  ),
                                                          ),
                                                          const Gap(8),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        chat.otherName,
                                                                        style: GoogleFonts
                                                                            .rubik(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      _formatLastMessageAt(
                                                                        chat.lastMessageAt,
                                                                      ),
                                                                      style: GoogleFonts
                                                                          .rubik(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        chat.lastMessagePreview
                                                                                .isNotEmpty
                                                                            ? chat.lastMessagePreview
                                                                            : 'Nova conversa',
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .rubik(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black54,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(
                                                  height: 1,
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) {
                                    return const FractionallySizedBox(
                                      heightFactor: 0.9,
                                      child: ContactListPage(),
                                    );
                                  },
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Iniciar Conversa",
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(90),
          ],
        );
      },
    );
  }
}
