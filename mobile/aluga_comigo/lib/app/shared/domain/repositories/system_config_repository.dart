import 'package:result_dart/result_dart.dart';

import '../entities/system_config.dart';

abstract interface class ISystemConfigRepository {
  AsyncResult<SystemConfig> loadSystemConfig();
}
