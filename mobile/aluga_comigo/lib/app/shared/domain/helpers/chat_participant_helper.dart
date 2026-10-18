import '../typedefs/json.dart';

abstract final class ChatParticipantHelper {
  static String _norm(String id) => id.trim();

  static bool _sameId(String a, String b) =>
      _norm(a).isNotEmpty && _norm(a) == _norm(b);

  /// ID da conta com quem o usuário [currentAccountId] conversa.
  static String otherParticipantId({
    required String currentAccountId,
    required String personId,
    required String immobileId,
    required String peerPersonId,
    required bool isPersonPeerChat,
  }) {
    final current = _norm(currentAccountId);
    if (isPersonPeerChat) {
      final peer = _norm(peerPersonId);
      if (peer.isNotEmpty && peer != current) return peer;
      return '';
    }

    final person = _norm(personId);
    final immobile = _norm(immobileId);

    if (_sameId(person, current)) return immobile;
    if (_sameId(immobile, current)) return person;

    if (person.isNotEmpty && person != current) return person;
    if (immobile.isNotEmpty && immobile != current) return immobile;
    return _norm(peerPersonId);
  }

  static Json personImmobileDisplayFromRow(Json row, String currentAccountId) {
    final personId = row['person_id']?.toString() ?? '';
    final immobileId = row['immobile_id']?.toString() ?? '';
    final ownerAccountId = row['immobile_owner_account_id']?.toString() ?? '';
    final ownerName = row['immobile_owner_name']?.toString() ?? '';
    final ownerPhoto = row['immobile_owner_photo']?.toString() ?? '';
    final personName = row['person_name']?.toString() ?? '';
    final personPhoto = row['person_photo']?.toString() ?? '';
    final listingName = row['immobile_name']?.toString() ?? '';
    final listingPhoto = row['immobile_photo']?.toString() ?? '';

    // Pessoa interessada: contato é o dono/responsável do anúncio, não o título.
    if (_sameId(personId, currentAccountId)) {
      if (ownerName.trim().isNotEmpty) {
        return {
          'otherName': ownerName,
          'otherPhoto': ownerPhoto.isNotEmpty ? ownerPhoto : listingPhoto,
        };
      }
      return {
        'otherName': listingName,
        'otherPhoto': listingPhoto,
      };
    }

    // Dono do anúncio (ou legado: immobile_id = conta): contato é a pessoa.
    if (_sameId(ownerAccountId, currentAccountId) ||
        _sameId(immobileId, currentAccountId)) {
      return {
        'otherName': personName,
        'otherPhoto': personPhoto,
      };
    }

    if (personId.isNotEmpty && !_sameId(personId, currentAccountId)) {
      return {
        'otherName': personName,
        'otherPhoto': personPhoto,
      };
    }

    return {
      'otherName': listingName,
      'otherPhoto': listingPhoto,
    };
  }

  static Json peerDisplayFromRow(Json row, String currentAccountId) {
    final lowId = row['person_low_id']?.toString() ?? '';
    final highId = row['person_high_id']?.toString() ?? '';

    if (_sameId(lowId, currentAccountId)) {
      return {
        'peerPersonId': highId,
        'otherName': row['person_high_name']?.toString() ?? '',
        'otherPhoto': row['person_high_photo']?.toString() ?? '',
      };
    }
    if (_sameId(highId, currentAccountId)) {
      return {
        'peerPersonId': lowId,
        'otherName': row['person_low_name']?.toString() ?? '',
        'otherPhoto': row['person_low_photo']?.toString() ?? '',
      };
    }

    final otherId = !_sameId(lowId, currentAccountId)
        ? lowId
        : (!_sameId(highId, currentAccountId) ? highId : highId);
    if (_sameId(otherId, highId)) {
      return {
        'peerPersonId': highId,
        'otherName': row['person_high_name']?.toString() ?? '',
        'otherPhoto': row['person_high_photo']?.toString() ?? '',
      };
    }
    return {
      'peerPersonId': lowId,
      'otherName': row['person_low_name']?.toString() ?? '',
      'otherPhoto': row['person_low_photo']?.toString() ?? '',
    };
  }
}
