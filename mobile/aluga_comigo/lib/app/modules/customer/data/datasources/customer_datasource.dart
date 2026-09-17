import 'package:aluga_comigo/app/shared/data/services/session_service.dart';

import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/domain/entities/failures.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../domain/constants/swipe_feed_constants.dart';
import '../../domain/entities/match_customer_response.dart';
import '../../domain/entities/mutual_match.dart';
import '../../domain/enums/match_type.dart';
import '../models/customer_model.dart';

abstract interface class ICustomerDatasource {
  Future<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    List<String> alreadyLoadedIds = const [],
  });
  Future<MatchCustomerResponse> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  );
  Future<MatchCustomerResponse> matchImmobileWithSuperChat({
    required ImmobileCustomerModel immobile,
    required String message,
  });
}

class CustomerDatasource implements ICustomerDatasource {
  final SupabaseDatabaseService database;
  final SecureStorageService storage;

  const CustomerDatasource(this.database, this.storage);

  @override
  Future<MatchCustomerResponse> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    final session = SessionService.customer!;
    final sessionId = session.id;

    if (matchType == MatchType.favorite) {
      final isPersonToImmobile =
          session.typeUser == TypeUser.person &&
          customer.typeUser == TypeUser.immobile;
      final consumed = isPersonToImmobile
          ? await database.consumeSuperChat()
          : await database.consumeSuperStar();
      if (!consumed) {
        throw FailureDatasource(
          message: isPersonToImmobile
              ? 'Você não tem Super Chat. Compre na loja.'
              : 'Você não tem Super Star. Compre na loja.',
        );
      }
      final inventory = await database.getUserInventory();
      SessionService.setInventory(UserInventory.fromMap(inventory));
    }

    switch (session.typeUser) {
      case TypeUser.person:
        switch (customer.typeUser) {
          case TypeUser.person:
            await database.createPersonPeerMatch(
              fromPersonId: sessionId,
              toPersonId: customer.id,
              matchType: matchType.name,
            );
            await database.updateLastMatchPersonPeer(sessionId, customer.id);
          case TypeUser.immobile:
            await database.createPersonMatch(
              personId: sessionId,
              immobileId: customer.id,
              matchType: matchType.name,
            );
            await database.updateLastMatchPerson(sessionId, customer.id);
          case TypeUser.none:
            throw FailureDatasource(message: 'Perfil inválido para match.');
        }
      case TypeUser.immobile:
        if (customer.typeUser != TypeUser.person) {
          throw FailureDatasource(
            message: 'Responda interessados pela aba de curtidas.',
          );
        }
        await database.createImmobileMatch(
          immobileId: sessionId,
          personId: customer.id,
          matchType: matchType.name,
        );
        await database.updateLastMatchImmobile(sessionId, customer.id);
      case TypeUser.none:
        break;
    }

    final json = await storage.getData(StorageKey.user);
    final user = UserModel.fromJson(json!);
    final newUser = user.copyWith(lastMatch: customer.id);
    await storage.setData(StorageKey.user, newUser.toJson());

    switch (session) {
      case PersonCustomerModel():
        SessionService.setCustomer(session.copyWith(lastMatch: customer.id));
      case ImmobileCustomerModel():
        SessionService.setCustomer(session.copyWith(lastMatch: customer.id));
    }

    if (matchType == MatchType.like || matchType == MatchType.favorite) {
      await database.incrementQuestProgress(matchType.name);
      final isMutual = await _isMutualMatch(session, customer);
      if (isMutual) {
        return MatchCustomerResponse(
          mutualMatch: MutualMatch(matchedCustomer: customer),
        );
      }
    }

    return const MatchCustomerResponse();
  }

  Future<bool> _isMutualMatch(
    CustomerModel session,
    CustomerModel customer,
  ) async {
    return switch ((session.typeUser, customer.typeUser)) {
      (TypeUser.person, TypeUser.person) =>
        database.hasMutualPersonPeerMatch(
          personId: session.id,
          otherPersonId: customer.id,
        ),
      (TypeUser.person, TypeUser.immobile) =>
        database.hasMutualPersonImmobileMatch(
          personId: session.id,
          immobileId: customer.id,
        ),
      (TypeUser.immobile, TypeUser.person) =>
        database.hasMutualPersonImmobileMatch(
          personId: customer.id,
          immobileId: session.id,
        ),
      _ => false,
    };
  }

  @override
  Future<MatchCustomerResponse> matchImmobileWithSuperChat({
    required ImmobileCustomerModel immobile,
    required String message,
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw FailureDatasource(message: 'Digite uma mensagem.');
    }

    final mutual = await matchCustomer(immobile, MatchType.favorite);

    final session = SessionService.customer!;
    final chatRow = await database.getOrCreatePersonImmobileChat(
      personId: session.id,
      immobileId: immobile.id,
    );
    await database.sendMessage(
      chatId: chatRow['id']?.toString() ?? '',
      senderId: session.id,
      content: trimmed,
      messageType: 'superChat',
    );

    return mutual;
  }

  ({String city, String state}) _locationFromSession(CustomerModel session) {
    final parts = session.cityState.split(' - ');
    return (
      city: parts.isNotEmpty ? parts.first.trim() : '',
      state: parts.length > 1 ? parts[1].trim() : '',
    );
  }

  @override
  Future<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    List<String> alreadyLoadedIds = const [],
  }) async {
    final session = SessionService.customer!;
    final excludeId = session.id;
    final location = _locationFromSession(session);

    if (location.city.isEmpty) {
      return [];
    }

    if (session.typeUser == TypeUser.immobile) {
      return [];
    }

    final matchedIds = switch (typeUser) {
      TypeUser.person => await database.listPersonPeerMatchedTargetIds(
        session.id,
      ),
      TypeUser.immobile => await database.listPersonMatchedImmobileIds(
        session.id,
      ),
      TypeUser.none => <String>[],
    };

    final excludeIds = {
      ...matchedIds,
      ...alreadyLoadedIds,
    }.where((id) => id.isNotEmpty).toList();

    final rows = switch (typeUser) {
      TypeUser.person => await database.listPersons(
        excludeId: excludeId,
        excludeIds: excludeIds,
        city: location.city,
        state: location.state,
        limit: SwipeFeedConstants.pageSize,
      ),
      TypeUser.immobile => await database.listImmobiles(
        excludeId: excludeId,
        excludeIds: excludeIds,
        city: location.city,
        state: location.state,
        limit: SwipeFeedConstants.pageSize,
      ),
      TypeUser.none => <Map<String, dynamic>>[],
    };

    return rows
        .map<CustomerModel>((row) => CustomerModel.fromMap(row))
        .toList();
  }
}
