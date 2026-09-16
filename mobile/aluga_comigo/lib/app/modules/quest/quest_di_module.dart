import 'package:aluga_comigo/app/modules/quest/data/datasources/quest_datasource.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuestDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IQuestDatasource>(QuestDatasource.new);
  }
}
