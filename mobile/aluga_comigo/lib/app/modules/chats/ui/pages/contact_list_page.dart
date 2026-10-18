import 'package:aluga_comigo/app/modules/chats/data/models/match_contact_model.dart';
import 'package:aluga_comigo/app/modules/chats/chat_navigation.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/contact_list_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/contact_match_tile.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                _groupByAlphabet
                    ? 'Escolha uma pessoa para conversar'
                    : 'Escolha um imóvel para conversar',
                style: GoogleFonts.rubik(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  style: GoogleFonts.rubik(color: Colors.black87),
                  cursorColor: const Color(0xFF2C29A3),
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFEFEFEF),
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pesquisar por nome',
                    hintStyle: GoogleFonts.rubik(color: Colors.black45),
                  ),
                ),
              ),
            ),
            const Gap(8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
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
      final title = ContactMatchTile.sortKey(contact.customer);
      if (title.isNotEmpty) {
        letters.add(title[0].toUpperCase());
      }
    }
    final sortedLetters = letters.toList()..sort();

    return [
      for (final letter in sortedLetters) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            letter,
            style: GoogleFonts.rubik(
              color: const Color(0xFF2C29A3),
              fontSize: 28,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _contactList(
          controller.contacts.where((contact) {
            final title = ContactMatchTile.sortKey(contact.customer);
            return title.toUpperCase().startsWith(letter);
          }),
        ),
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
        _contactList(controller.contacts),
      ];
    }

    return [
      if (favorites.isNotEmpty) ...[
        _sectionTitle('Favoritos'),
        _contactList(favorites),
      ],
      if (likes.isNotEmpty) ...[
        _sectionTitle('Curtidos'),
        _contactList(likes),
      ],
    ];
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2C29A3),
        ),
      ),
    );
  }

  Widget _contactList(Iterable<MatchContactModel> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (final contact in items) ...[
            ContactMatchTile(
              key: ValueKey('contact_list_tile_${contact.customer.id}'),
              customer: contact.customer,
              onTap: () => _onContactTap(contact),
            ),
            const Gap(10),
          ],
        ],
      ),
    );
  }
}
