import 'package:aluga_comigo/app/modules/start/start_module.dart';
import 'package:aluga_comigo/app/modules/store/store_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/auth/auth_module.dart';
import 'modules/configs/config_module.dart';
import 'modules/intro/intro_module.dart';
import 'modules/quests/quest_module.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r.module('/', module: IntroModule());
    r.module('/auth', module: AuthModule());
    r.module('/start', module: StartModule());
    r.module('/config', module: ConfigModule());
    r.module('/quest', module: QuestModule());
    r.module('/store', module: StoreModule());
  }
}
