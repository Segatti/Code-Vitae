import 'package:modular_test/modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morty_verso/app/core/core_module.dart';
 
void main() {

  setUpAll(() {
    initModule(CoreModule());
  });
}