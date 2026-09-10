import 'package:aluga_comigo/app/modules/auth/auth_di_module.dart';
import 'package:aluga_comigo/app/modules/chats/chats_di_module.dart';
import 'package:aluga_comigo/app/modules/customer/customer_di_module.dart';
import 'package:aluga_comigo/app/modules/like/history_module.dart';
import 'package:aluga_comigo/app/modules/like/likes_di_module.dart';
import 'package:aluga_comigo/app/modules/start/start_module.dart';
import 'package:aluga_comigo/app/modules/store/store_module.dart';
import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/auth/auth_module.dart';
import 'modules/config/config_module.dart';
import 'modules/intro/intro_module.dart';
import 'modules/quest/quest_module.dart';

class AppModule extends Module {
  @override
  void register(ModularContext c) {
    // DI compartilhado — registrar uma única vez aqui
    c.module(CoreModule());
    c.module(AuthDiModule());
    c.module(CustomerDiModule());
    c.module(LikesDiModule());
    c.module(ChatsDiModule());
    c.module(IntroModule());
    c.module(AuthModule());
    c.module(StartModule());
    c.module(HistoryModule());
    c.module(ConfigModule());
    c.module(QuestModule());
    c.module(StoreModule());
  }
}
