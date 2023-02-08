import 'package:flutter/cupertino.dart';

import '../../repositories/theme_repository.dart';

abstract class IUCGetTheme {
  Future<CupertinoThemeData> call();
}

class UCGetTheme implements IUCGetTheme {
  final IThemeRepository themeRepository;

  UCGetTheme(this.themeRepository);

  final CupertinoThemeData themeLight = const CupertinoThemeData(
    brightness: Brightness.light,
    textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(color: CupertinoColors.black, fontFamily: 'SF Pro')),
  );
  final CupertinoThemeData themeDark = const CupertinoThemeData(
    brightness: Brightness.dark,
    textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(color: CupertinoColors.white, fontFamily: 'SF Pro')),
  );

  @override
  Future<CupertinoThemeData> call() async {
    final response = await themeRepository.getTheme();
    return response == Brightness.light ? themeLight : themeDark;
  }
}
