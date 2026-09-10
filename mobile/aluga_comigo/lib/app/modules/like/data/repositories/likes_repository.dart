import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../../shared/domain/extends/result.dart';
import '../datasources/likes_datasource.dart';
import '../models/incoming_like_model.dart';

abstract interface class ILikesRepository {
  AsyncResult<List<IncomingLikeModel>> getIncomingLikes();
}

class LikesRepository implements ILikesRepository {
  final ILikesDatasource datasource;

  const LikesRepository(this.datasource);

  @override
  AsyncResult<List<IncomingLikeModel>> getIncomingLikes() {
    return datasource.getIncomingLikes().toAsyncResult();
  }
}
