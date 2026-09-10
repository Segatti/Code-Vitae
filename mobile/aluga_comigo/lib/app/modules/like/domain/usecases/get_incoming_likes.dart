import 'package:result_dart/result_dart.dart';

import '../../data/models/incoming_like_model.dart';
import '../../data/repositories/likes_repository.dart';

abstract interface class IGetIncomingLikes {
  AsyncResult<List<IncomingLikeModel>> call();
}

class GetIncomingLikes implements IGetIncomingLikes {
  final ILikesRepository repository;

  const GetIncomingLikes(this.repository);

  @override
  AsyncResult<List<IncomingLikeModel>> call() {
    return repository.getIncomingLikes();
  }
}
