
import 'package:flutter/cupertino.dart';

import '../../repositories/theme_repository.dart';

abstract class IUCSetTheme {
  Future<void> call(Brightness brightness);
}

class UCSetTheme implements IUCSetTheme {
  final IThemeRepository themeRepository;

  UCSetTheme(this.themeRepository);

  @override
  Future<void> call(Brightness brightness) async {
    await themeRepository.setTheme(brightness);
  }
}
