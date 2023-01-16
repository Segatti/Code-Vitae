import 'package:modular_test/modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morty_verso/app/modules/planets/planets_module.dart';
 
void main() {

  setUpAll(() {
    initModule(PlanetsModule());
  });
}