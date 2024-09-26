import 'package:aluga_comigo/app/modules/chats/interactor/enums/home_type.dart';
import 'package:aluga_comigo/app/modules/chats/interactor/models/contact.dart';
import 'package:aluga_comigo/app/modules/chats/ui/pages/contact_list_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/presenter/widgets/tabs.dart';

class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  int tabSelected = 0;

  @override
  Widget build(BuildContext context) {
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
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
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
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelStyle: GoogleFonts.rubik(
                                        color: Colors.white,
                                      ),
                                      hintText: "Pesquisar por nome",
                                      hintStyle: GoogleFonts.rubik(
                                        color: Colors.white,
                                      ),
                                      focusColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: tabSelected == 0 ? 10 : 5,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      Modular.to.pushNamed(
                                        "./chat",
                                        arguments: {
                                          "idChat": "1",
                                          "contact": Contact(
                                            name: "Vittor",
                                            birthday: DateTime.now(),
                                            homeType: HomeType.house,
                                            photo:
                                                "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
                                          ),
                                        },
                                        forRoot: true,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 55,
                                      color: Colors.white,
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4WP2MsbDRCViQDfYrBBElK0lOlMdPdtlvnw&usqp=CAU",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const Gap(8),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Ana",
                                                            style: GoogleFonts
                                                                .rubik(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const Gap(8),
                                                          Visibility(
                                                            visible: true,
                                                            child: Text(
                                                              "NOVO",
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .purple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Gap(8),
                                                    Text(
                                                      "Há 5 minutos",
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.black54,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Como vamos dividir as tarefas de casa? Eu gosto...",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.rubik(
                                                          fontSize: 12,
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
                                  ),
                                  separatorBuilder: (context, index) =>
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
                                });
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
  }
}
