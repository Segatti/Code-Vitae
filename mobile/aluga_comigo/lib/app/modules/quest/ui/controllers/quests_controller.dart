import 'package:material_ui/material_ui.dart';

import '../../data/datasources/quest_datasource.dart';
import '../../data/models/quest_progress_model.dart';

abstract interface class IQuestsController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<QuestProgressModel> quests = [];

  Future<void> initialize();
  Future<bool> claimReward(String questId);
}

class QuestsController extends IQuestsController {
  final IQuestDatasource _datasource;

  QuestsController(this._datasource);

  @override
  Future<void> initialize() async {
    loadingList.add('loadQuests');
    notifyListeners();

    try {
      quests = await _datasource.getQuests();
      errorMessage = '';
    } catch (_) {
      errorMessage = 'Erro ao carregar missões';
      quests = [];
    } finally {
      loadingList.remove('loadQuests');
      notifyListeners();
    }
  }

  @override
  Future<bool> claimReward(String questId) async {
    loadingList.add('claimReward');
    notifyListeners();

    try {
      await _datasource.claimReward(questId);
      await initialize();
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível receber o prêmio';
      notifyListeners();
      return false;
    } finally {
      loadingList.remove('claimReward');
    }
  }
}
