import '../../../../shared/domain/entities/failures.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/domain/helpers/chat_mapper.dart';
import '../../../../shared/domain/helpers/peer_chat_mapper.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../../shared/domain/typedefs/json.dart';
import '../../domain/entities/chat.dart';
import '../models/match_contact_model.dart';

abstract interface class IMatchContactDatasource {
  Future<List<MatchContactModel>> listMatchContacts({
    required TypeUser sessionType,
    required int tabIndex,
  });

  Future<Chat?> getOrCreateChatForContact(CustomerModel customer);

  Future<CustomerModel> getContactProfile(String accountId);
}

class MatchContactDatasource implements IMatchContactDatasource {
  final SupabaseDatabaseService database;

  const MatchContactDatasource(this.database);

  @override
  Future<List<MatchContactModel>> listMatchContacts({
    required TypeUser sessionType,
    required int tabIndex,
  }) async {
    final session = SessionService.customer!;
    final sessionId = session.id;

    final rows = switch ((sessionType, tabIndex)) {
      (TypeUser.immobile, 0) =>
        await database.listMutualPersonContactsForImmobile(sessionId),
      (TypeUser.person, 1) => await database.listOutgoingPersonImmobileMatches(
        sessionId,
      ),
      (TypeUser.person, 0) => await database.listMutualPeerPersonContacts(
        sessionId,
      ),
      _ => <Map<String, dynamic>>[],
    };

    return rows.map(MatchContactModel.fromMap).toList();
  }

  @override
  Future<Chat?> getOrCreateChatForContact(CustomerModel customer) async {
    final session = SessionService.customer!;
    final userId = session.id;

    try {
      if (session.typeUser == TypeUser.person &&
          customer is PersonCustomerModel) {
        final row = await database.getOrCreatePersonPeerChat(
          otherPersonId: customer.id,
        );
        final map = PeerChatMapper.fromRow(row, userId);
        return _chatFromMap(map);
      }

      final pair = switch (session.typeUser) {
        TypeUser.person when customer is ImmobileCustomerModel => (
          personId: userId,
          immobileId: customer.id,
        ),
        TypeUser.immobile when customer is PersonCustomerModel => (
          personId: customer.id,
          immobileId: userId,
        ),
        _ => null,
      };

      if (pair == null) return null;

      final row = await database.getOrCreatePersonImmobileChat(
        personId: pair.personId,
        immobileId: pair.immobileId,
      );
      final map = ChatMapper.fromRow(row, userId);
      return _chatFromMap(map);
    } on FailureDatasource {
      return null;
    }
  }

  @override
  Future<CustomerModel> getContactProfile(String accountId) async {
    final response = await database.readProfile(accountId);
    return response.fold(
      (failure) => throw FailureDatasource(message: failure.message),
      (Json row) {
        if (row.isEmpty) {
          throw FailureDatasource(message: 'Perfil não encontrado');
        }
        return CustomerModel.fromMap(row);
      },
    );
  }

  Chat _chatFromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id']?.toString() ?? '',
      personId: map['personId']?.toString() ?? '',
      immobileId: map['immobileId']?.toString() ?? '',
      peerPersonId: map['peerPersonId']?.toString() ?? '',
      personName: map['personName']?.toString() ?? '',
      personPhoto: map['personPhoto']?.toString() ?? '',
      immobileName: map['immobileName']?.toString() ?? '',
      immobilePhoto: map['immobilePhoto']?.toString() ?? '',
      otherName: map['otherName']?.toString() ?? '',
      otherPhoto: map['otherPhoto']?.toString() ?? '',
      lastMessagePreview: map['lastMessagePreview']?.toString() ?? '',
      lastMessageAt: map['lastMessageAt'] == null
          ? null
          : DateTime.tryParse(map['lastMessageAt'].toString()),
      isPersonPeerChat: map['isPersonPeerChat'] == true,
    );
  }
}
