import 'package:flutter/cupertino.dart';

import '../../domain/repositories/theme_repository.dart';
import '../../domain/services/local_storage_service.dart';

class ThemeRepository implements IThemeRepository {
  final ILocalStorageService storageDatasource;

  const ThemeRepository(this.storageDatasource);

  @override
  Future<Brightness> getTheme() async {
    final response = await storageDatasource.get('theme');
    return response == 'dark' ? Brightness.dark : Brightness.light;
  }

  @override
  Future<void> setTheme(Brightness brightness) async {
    storageDatasource.set('theme', brightness.name);
  }
}
