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

    final rows = switch (session.typeUser) {
      TypeUser.person =>
        await database.listIncomingPersonPeerMatches(session.id),
      TypeUser.immobile => await database.listIncomingPersonMatches(session.id),
      TypeUser.none => <Map<String, dynamic>>[],
    };

    return rows.map(IncomingLikeModel.fromMap).toList();
  }
}
