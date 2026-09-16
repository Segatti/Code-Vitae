import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../models/quest_progress_model.dart';

abstract interface class IQuestDatasource {
  Future<List<QuestProgressModel>> getQuests();
  Future<void> claimReward(String questId);
}

class QuestDatasource implements IQuestDatasource {
  final SupabaseDatabaseService database;

  const QuestDatasource(this.database);

  @override
  Future<List<QuestProgressModel>> getQuests() async {
    final rows = await database.getUserQuests();
    return rows.map(QuestProgressModel.fromMap).toList();
  }

  @override
  Future<void> claimReward(String questId) async {
    await database.claimQuestReward(questId);
    final map = await database.getUserInventory();
    SessionService.setInventory(UserInventory.fromMap(map));
  }
}
