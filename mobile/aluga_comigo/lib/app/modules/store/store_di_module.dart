import 'package:aluga_comigo/app/modules/store/data/datasources/iap_datasource.dart';
import 'package:aluga_comigo/app/modules/store/data/datasources/purchase_supabase_datasource.dart';
import 'package:aluga_comigo/app/modules/store/data/repositories/purchase_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StoreDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IIapDatasource>(IapDatasource.new);
    c.addSingleton<IPurchaseSupabaseDatasource>(PurchaseSupabaseDatasource.new);
    c.addSingleton<IPurchaseRepository>(PurchaseRepository.new);
  }
}
