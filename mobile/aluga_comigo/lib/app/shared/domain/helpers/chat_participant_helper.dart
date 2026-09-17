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

    if (_sameId(personId, currentAccountId)) {
      return {
        'otherName': row['immobile_name']?.toString() ?? '',
        'otherPhoto': row['immobile_photo']?.toString() ?? '',
      };
    }
    if (_sameId(immobileId, currentAccountId)) {
      return {
        'otherName': row['person_name']?.toString() ?? '',
        'otherPhoto': row['person_photo']?.toString() ?? '',
      };
    }

    if (!_sameId(immobileId, currentAccountId) && immobileId.isNotEmpty) {
      return {
        'otherName': row['immobile_name']?.toString() ?? '',
        'otherPhoto': row['immobile_photo']?.toString() ?? '',
      };
    }
    return {
      'otherName': row['person_name']?.toString() ?? '',
      'otherPhoto': row['person_photo']?.toString() ?? '',
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
