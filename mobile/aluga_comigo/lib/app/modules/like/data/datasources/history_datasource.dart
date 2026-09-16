import 'package:aluga_comigo/app/shared/data/services/session_service.dart';

import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/domain/entities/failures.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../models/rejected_history_item.dart';

abstract interface class IHistoryDatasource {
  Future<({List<RejectedHistoryItem> persons, List<RejectedHistoryItem> immobiles})>
      getRejectedHistory();
}

class HistoryDatasource implements IHistoryDatasource {
  final SupabaseDatabaseService database;

  const HistoryDatasource(this.database);

  @override
  Future<({List<RejectedHistoryItem> persons, List<RejectedHistoryItem> immobiles})>
      getRejectedHistory() async {
    final session = SessionService.customer;
    if (session == null) {
      return (
        persons: <RejectedHistoryItem>[],
        immobiles: <RejectedHistoryItem>[],
      );
    }

    return switch (session.typeUser) {
      TypeUser.person => await _loadForPerson(session.id),
      TypeUser.immobile => await _loadForImmobile(session.id),
      TypeUser.none => (
          persons: <RejectedHistoryItem>[],
          immobiles: <RejectedHistoryItem>[],
        ),
    };
  }

  Future<({
    List<RejectedHistoryItem> persons,
    List<RejectedHistoryItem> immobiles,
  })> _loadForPerson(String personId) async {
    FailureDatasource? firstError;
    var persons = <RejectedHistoryItem>[];
    var immobiles = <RejectedHistoryItem>[];

    try {
      persons = (await database.listRejectedPeersByPerson(personId))
          .map(RejectedHistoryItem.fromMap)
          .toList();
    } on FailureDatasource catch (error) {
      firstError ??= error;
    }

    try {
      immobiles = (await database.listRejectedImmobilesByPerson(personId))
          .map(RejectedHistoryItem.fromMap)
          .toList();
    } on FailureDatasource catch (error) {
      firstError ??= error;
    }

    if (firstError != null && persons.isEmpty && immobiles.isEmpty) {
      throw firstError;
    }

    return (persons: persons, immobiles: immobiles);
  }

  Future<({
    List<RejectedHistoryItem> persons,
    List<RejectedHistoryItem> immobiles,
  })> _loadForImmobile(String immobileId) async {
    final persons = (await database.listRejectedPersonsByImmobile(immobileId))
        .map(RejectedHistoryItem.fromMap)
        .toList();
    return (persons: persons, immobiles: <RejectedHistoryItem>[]);
  }
}
