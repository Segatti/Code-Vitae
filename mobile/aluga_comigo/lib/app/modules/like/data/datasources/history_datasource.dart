import 'package:aluga_comigo/app/shared/data/services/session_service.dart';

import '../../../../shared/data/services/supabase_database_service.dart';
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
      TypeUser.person => (
          persons: <RejectedHistoryItem>[],
          immobiles: (await database.listRejectedImmobilesByPerson(session.id))
              .map(RejectedHistoryItem.fromMap)
              .toList(),
        ),
      TypeUser.immobile => (
          persons: (await database.listRejectedPersonsByImmobile(session.id))
              .map(RejectedHistoryItem.fromMap)
              .toList(),
          immobiles: <RejectedHistoryItem>[],
        ),
      TypeUser.none => (
          persons: <RejectedHistoryItem>[],
          immobiles: <RejectedHistoryItem>[],
        ),
    };
  }
}
