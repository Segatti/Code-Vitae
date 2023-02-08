import 'package:flutter/cupertino.dart';

abstract class IThemeRepository {
  Future<Brightness> getTheme();
  Future<void> setTheme(Brightness brightness);
}
