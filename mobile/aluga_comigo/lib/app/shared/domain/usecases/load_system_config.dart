import 'package:result_dart/result_dart.dart';

import '../entities/system_config.dart';
import '../repositories/system_config_repository.dart';

abstract interface class ILoadSystemConfig {
  AsyncResult<SystemConfig> call();
}

class LoadSystemConfig implements ILoadSystemConfig {
  final ISystemConfigRepository repository;

  const LoadSystemConfig(this.repository);

  @override
  AsyncResult<SystemConfig> call() => repository.loadSystemConfig();
}
