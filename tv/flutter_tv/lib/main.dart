import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/app_module.dart';

import 'app/app_widget.dart';

void main() async {
  // await dotenv.load(fileName: ".env");
  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
