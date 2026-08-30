import 'package:cupertino_ui/cupertino_ui.dart';

abstract class IThemeRepository {
  Future<Brightness> getTheme();
  Future<void> setTheme(Brightness brightness);
}
