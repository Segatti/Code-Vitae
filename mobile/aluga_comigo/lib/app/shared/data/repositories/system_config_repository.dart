import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../domain/entities/system_config.dart';
import '../../domain/helpers/system_config_parser.dart';
import '../../domain/repositories/system_config_repository.dart' as domain;
import '../datasources/system_config_datasource.dart';

class SystemConfigRepository implements domain.ISystemConfigRepository {
  final ISystemConfigDatasource datasource;

  const SystemConfigRepository(this.datasource);

  @override
  AsyncResult<SystemConfig> loadSystemConfig() async {
    return datasource
        .listConfigEntries()
        .then((models) {
          final entries = models.map((m) => m.toEntity()).toList();
          if (entries.isEmpty) return SystemConfig.defaults();
          return SystemConfigParser.fromEntries(entries);
        })
        .toAsyncResult();
  }
}
