import 'package:aluga_comigo/app/modules/chats/interactor/enums/home_type.dart';
import 'package:aluga_comigo/app/modules/chats/interactor/models/contact.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [
    Contact(
      name: "Vittor",
      birthday: DateTime(2000),
      homeType: HomeType.house,
      photo:
          "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
    ),
    Contact(
      name: "Vitória",
      birthday: DateTime(2000),
      homeType: HomeType.apartment,
      photo:
          "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
    ),
    Contact(
      name: "Ana",
      birthday: DateTime(2010),
      homeType: HomeType.both,
      photo:
          "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
    ),
    Contact(
      name: "Julio",
      birthday: DateTime(2015),
      homeType: HomeType.apartment,
      photo:
          "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
    ),
    Contact(
      name: "Hitsume",
      birthday: DateTime(2010),
      homeType: HomeType.both,
      photo:
          "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
    ),
    Contact(
      name: "Caio",
      birthday: DateTime(2015),
      homeType: HomeType.apartment,
      photo:
          "https://clinicaunix.com.br/wp-content/uploads/2019/12/5-pontos-saude-do-homem.jpg",
    ),
  ];
  Set<String> listAZ = {};

  @override
  void initState() {
    super.initState();
    for (var item in contacts.sortedBy((e) => e.name!)) {
      listAZ.add(item.name![0].toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
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
          child: ListView(
            children: [
              for (var item in listAZ)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item,
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 36,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Wrap(
                          spacing: constraints.maxWidth * .1,
                          children: [
                            for (var contact in contacts.where(
                                (e) => e.name!.toUpperCase().startsWith(item)))
                              Container(
                                width: constraints.maxWidth * .45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        imageUrl: contact.photo!,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            contact.name!,
                                            style: GoogleFonts.rubik(
                                              color: Colors.black,
                                              height: 1,
                                            ),
                                          ),
                                          const Gap(8),
                                          Text(
                                            (DateTime.now()
                                                        .difference(
                                                            contact.birthday!)
                                                        .inDays /
                                                    365)
                                                .floor()
                                                .toString(),
                                            style: GoogleFonts.rubik(
                                              color: Colors.black,
                                              height: 1,
                                            ),
                                          ),
                                          const Gap(8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  contact.homeType!.text,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black,
                                                    height: 1,
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
                          ],
                        );
                      }),
                    ),
                    const Gap(16),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
