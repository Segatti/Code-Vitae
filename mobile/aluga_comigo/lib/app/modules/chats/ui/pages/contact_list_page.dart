import 'package:aluga_comigo/app/modules/auth/domain/enums/type_immobile.dart';
import 'package:aluga_comigo/app/modules/chats/data/models/match_contact_model.dart';
import 'package:aluga_comigo/app/modules/chats/chat_navigation.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/contact_list_controller.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class ContactListPage extends StatefulWidget {
  final int tabIndex;

  const ContactListPage({super.key, required this.tabIndex});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late final IContactListController controller;

  @override
  void initState() {
    super.initState();
    controller = inject<IContactListController>();
    controller.load(tabIndex: widget.tabIndex);
  }

  bool get _groupByAlphabet => widget.tabIndex == 0;

  String _contactTitle(CustomerModel customer) {
    return switch (customer) {
      PersonCustomerModel(:final name) => name,
      ImmobileCustomerModel(:final typeImmobile, :final shortDescription) =>
        shortDescription.isNotEmpty
            ? shortDescription
            : switch (typeImmobile) {
                TypeImmobile.house => 'Casa',
                TypeImmobile.apartment => 'Apartamento',
                TypeImmobile.none => 'Imóvel',
              },
    };
  }

  String? _contactSubtitle(CustomerModel customer) {
    return switch (customer) {
      PersonCustomerModel(:final dateBirth) => _ageLabel(dateBirth),
      ImmobileCustomerModel(:final cityState) =>
        cityState.isNotEmpty ? cityState : null,
    };
  }

  String? _ageLabel(String dateBirth) {
    if (dateBirth.isEmpty) return null;
    final date = dateBirth.toDate();
    if (date == null) return null;
    final now = DateTime.now();
    var age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return '$age anos';
  }

  Future<void> _onContactTap(MatchContactModel contact) async {
    if (controller.loadingList.contains('resolveChat')) return;

    final chat = await controller.resolveChat(contact.customer);
    if (!mounted) return;

    if (chat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a conversa com este contato.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    if (!context.mounted) return;
    await ChatNavigation.open(context, chat);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.loadingList.contains('loadContacts')) {
          return const Center(
            key: ValueKey('contact_list_loading'),
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            key: const ValueKey('contact_list_error'),
            child: Text(
              controller.errorMessage,
              style: GoogleFonts.rubik(color: Colors.black54),
            ),
          );
        }

        if (controller.contacts.isEmpty) {
          return Center(
            key: const ValueKey('contact_list_empty'),
            child: Text(
              'Nenhum match encontrado.',
              style: GoogleFonts.rubik(color: Colors.black54),
            ),
          );
        }

        return Column(
          key: const ValueKey('contact_list_body'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                height: 35,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
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
                    hintText: 'Pesquisar por nome',
                    hintStyle: GoogleFonts.rubik(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _groupByAlphabet
                    ? _buildAlphabetSections()
                    : _buildImmobileSections(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAlphabetSections() {
    final letters = <String>{};
    for (final contact in controller.contacts) {
      final title = _contactTitle(contact.customer);
      if (title.isNotEmpty) {
        letters.add(title[0].toUpperCase());
      }
    }
    final sortedLetters = letters.toList()..sort();

    return [
      for (final letter in sortedLetters) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letter,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sectionContacts = controller.contacts.where((contact) {
                final title = _contactTitle(contact.customer);
                return title.toUpperCase().startsWith(letter);
              });
              return Wrap(
                spacing: constraints.maxWidth * .1,
                runSpacing: 12,
                children: [
                  for (final contact in sectionContacts)
                    _ContactTile(
                      key: ValueKey('contact_list_tile_${contact.customer.id}'),
                      width: constraints.maxWidth * .45,
                      title: _contactTitle(contact.customer),
                      subtitle: _contactSubtitle(contact.customer),
                      photoUrl: contact.customer.photos.isNotEmpty
                          ? contact.customer.photos.first
                          : '',
                      onTap: () => _onContactTap(contact),
                    ),
                ],
              );
            },
          ),
        ),
        const Gap(16),
      ],
    ];
  }

  List<Widget> _buildImmobileSections() {
    final favorites = controller.contacts
        .where((c) => c.matchType == MatchType.favorite)
        .toList();
    final likes = controller.contacts
        .where((c) => c.matchType == MatchType.like)
        .toList();

    if (favorites.isEmpty && likes.isEmpty) {
      return [
        _sectionTitle('Contatos'),
        _contactWrap(controller.contacts),
        const Gap(16),
      ];
    }

    return [
      if (favorites.isNotEmpty) ...[
        _sectionTitle('Favoritos'),
        _contactWrap(favorites),
        const Gap(16),
      ],
      if (likes.isNotEmpty) ...[
        _sectionTitle('Curtidos'),
        _contactWrap(likes),
        const Gap(16),
      ],
    ];
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.rubik(fontSize: 22, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _contactWrap(List<MatchContactModel> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: constraints.maxWidth * .1,
            runSpacing: 12,
            children: [
              for (final contact in items)
                _ContactTile(
                  key: ValueKey('contact_list_tile_${contact.customer.id}'),
                  width: constraints.maxWidth * .45,
                  title: _contactTitle(contact.customer),
                  subtitle: _contactSubtitle(contact.customer),
                  photoUrl: contact.customer.photos.isNotEmpty
                      ? contact.customer.photos.first
                      : '',
                  onTap: () => _onContactTap(contact),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final double width;
  final String title;
  final String? subtitle;
  final String photoUrl;
  final VoidCallback onTap;

  const _ContactTile({
    super.key,
    required this.width,
    required this.title,
    this.subtitle,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'contact_list_tile',
      button: true,
      child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: photoUrl.isEmpty
                  ? Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person),
                    )
                  : CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: photoUrl,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(height: 1),
                    ),
                    if (subtitle != null) ...[
                      const Gap(6),
                      Text(
                        subtitle!,
                        style: GoogleFonts.rubik(
                          height: 1,
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
