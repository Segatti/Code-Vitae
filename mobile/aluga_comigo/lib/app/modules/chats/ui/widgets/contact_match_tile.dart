import 'package:aluga_comigo/app/modules/auth/domain/enums/type_immobile.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Card de contato na bottom sheet «Iniciar conversa».
class ContactMatchTile extends StatelessWidget {
  const ContactMatchTile({
    super.key,
    required this.customer,
    required this.onTap,
  });

  final CustomerModel customer;
  final VoidCallback onTap;

  static const _accentBlue = Color(0xFF2C29A3);

  static String sortKey(CustomerModel customer) {
    return switch (customer) {
      PersonCustomerModel(:final name) => name,
      ImmobileCustomerModel(:final contactName) =>
        contactName.isNotEmpty ? contactName : _immobileListingLabel(customer),
    };
  }

  static String _immobileListingLabel(ImmobileCustomerModel immobile) {
    if (immobile.shortDescription.isNotEmpty) {
      return immobile.shortDescription;
    }
    return switch (immobile.typeImmobile) {
      TypeImmobile.house => 'Casa',
      TypeImmobile.apartment => 'Apartamento',
      TypeImmobile.none => 'Imóvel',
    };
  }

  static String? _personAgeLabel(String dateBirth) {
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

  static String? _immobileListingHint(ImmobileCustomerModel immobile) {
    final parts = <String>[];
    if (immobile.shortDescription.isNotEmpty) {
      parts.add(immobile.shortDescription);
    } else {
      final type = immobile.typeImmobile.title;
      if (type.isNotEmpty) parts.add(type);
    }
    if (immobile.cityState.isNotEmpty) {
      parts.add(immobile.cityState);
    }
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = customer.photos.isNotEmpty ? customer.photos.first : '';

    return Semantics(
      label: 'contact_list_tile',
      button: true,
      child: Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: photoUrl.isEmpty
                      ? Container(
                          height: 84,
                          width: 84,
                          color: Colors.grey.shade200,
                          child: Icon(
                            customer is PersonCustomerModel
                                ? Icons.person
                                : Icons.home_work_outlined,
                            color: Colors.grey.shade500,
                            size: 36,
                          ),
                        )
                      : CachedNetworkImage(
                          height: 84,
                          width: 84,
                          fit: BoxFit.cover,
                          imageUrl: photoUrl,
                        ),
                ),
                const Gap(12),
                Expanded(child: _buildTexts()),
                const Icon(
                  Icons.chat_bubble_outline,
                  color: _accentBlue,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTexts() {
    return switch (customer) {
      PersonCustomerModel(:final name, :final dateBirth) => _textColumn(
          title: name.isNotEmpty ? name : 'Pessoa',
          subtitle: _personAgeLabel(dateBirth),
        ),
      ImmobileCustomerModel immobile => _textColumn(
          title: immobile.contactName.isNotEmpty
              ? immobile.contactName
              : _immobileListingLabel(immobile),
          subtitle: _immobileListingHint(immobile),
          price: immobile.price,
        ),
    };
  }

  Widget _textColumn({
    required String title,
    String? subtitle,
    double price = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null && subtitle.isNotEmpty) ...[
          const Gap(4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.rubik(
              fontSize: 13,
              color: Colors.black54,
              height: 1.2,
            ),
          ),
        ],
        if (price > 0) ...[
          const Gap(6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              price.toMoney(useFree: false),
              style: GoogleFonts.rubik(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _accentBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
