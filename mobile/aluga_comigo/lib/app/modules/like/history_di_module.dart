import 'package:aluga_comigo/app/modules/like/data/datasources/history_datasource.dart';
import 'package:aluga_comigo/app/modules/like/data/repositories/history_repository.dart';
import 'package:aluga_comigo/app/modules/like/domain/usecases/get_rejected_history.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/history_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HistoryDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IHistoryDatasource>(HistoryDatasource.new);
    c.addSingleton<IHistoryRepository>(HistoryRepository.new);
    c.addSingleton<IGetRejectedHistory>(GetRejectedHistory.new);
    c.addLazySingleton<IHistoryController>(HistoryController.new);
  }
}
