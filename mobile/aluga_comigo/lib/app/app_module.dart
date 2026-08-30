import 'package:aluga_comigo/app/modules/start/start_module.dart';
import 'package:aluga_comigo/app/modules/store/store_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/auth/auth_module.dart';
import 'modules/config/config_module.dart';
import 'modules/intro/intro_module.dart';
import 'modules/quest/quest_module.dart';

class AppModule extends Module {
  @override
  void register(ModularContext c) {
    c.module(IntroModule());
    c.module(AuthModule());
    c.module(StartModule());
    c.module(ConfigModule());
    c.module(QuestModule());
    c.module(StoreModule());
  }
}
