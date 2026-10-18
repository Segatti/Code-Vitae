import '../models/system_config_entry_model.dart';
import '../services/supabase_database_service.dart';

abstract interface class ISystemConfigDatasource {
  Future<List<SystemConfigEntryModel>> listConfigEntries();
}

class SystemConfigDatasource implements ISystemConfigDatasource {
  final SupabaseDatabaseService database;

  const SystemConfigDatasource(this.database);

  @override
  Future<List<SystemConfigEntryModel>> listConfigEntries() async {
    final rows = await database.listConfigSystemEntries();
    return rows.map(SystemConfigEntryModel.fromMap).toList();
  }
}
