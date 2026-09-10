import 'package:aluga_comigo/app/modules/like/data/datasources/likes_datasource.dart';
import 'package:aluga_comigo/app/modules/like/data/repositories/likes_repository.dart';
import 'package:aluga_comigo/app/modules/like/domain/usecases/get_incoming_likes.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/likes_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LikesDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<ILikesDatasource>(LikesDatasource.new);
    c.addSingleton<ILikesRepository>(LikesRepository.new);
    c.addSingleton<IGetIncomingLikes>(GetIncomingLikes.new);
    c.addSingleton<ILikesController>(LikesController.new);
  }
}
