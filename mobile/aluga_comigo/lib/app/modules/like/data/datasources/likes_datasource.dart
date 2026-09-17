import 'package:aluga_comigo/app/shared/data/services/session_service.dart';

import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../models/incoming_like_model.dart';

abstract interface class ILikesDatasource {
  Future<List<IncomingLikeModel>> getIncomingLikes();
}

class LikesDatasource implements ILikesDatasource {
  final SupabaseDatabaseService database;

  const LikesDatasource(this.database);

  @override
  Future<List<IncomingLikeModel>> getIncomingLikes() async {
    final session = SessionService.customer;
    if (session == null) return [];

    if (session.typeUser == TypeUser.person) {
      final rows = await database.listIncomingPersonPeerMatches(session.id);
      return rows.map(IncomingLikeModel.fromMap).toList();
    }

    if (session.typeUser == TypeUser.immobile) {
      final owned = await database.listOwnedImmobiles(session.id);
      final merged = <IncomingLikeModel>[];
      for (final immobileRow in owned) {
        final immobileId = immobileRow['id']?.toString() ?? '';
        if (immobileId.isEmpty) continue;
        final rows = await database.listIncomingPersonMatches(immobileId);
        merged.addAll(
          rows.map(
            (row) => IncomingLikeModel.fromMap({
              ...row,
              'immobileId': immobileId,
              'immobile': immobileRow,
            }),
          ),
        );
      }
      return merged;
    }

    return [];
  }
}
