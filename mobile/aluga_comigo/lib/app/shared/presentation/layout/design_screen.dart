import 'dart:math' as math;
import 'dart:ui' show Size;

import '../../../../design_screen_config.dart';

/// Medidas são anotadas no **celular de referência** (largura × altura em px lógicos).
///
/// Ex.: `200.w()` → ocupa a mesma **proporção** da largura da tela em qualquer aparelho.
///
/// Ajuste o referencial com `--dart-define`:
/// `DESIGN_SCREEN_WIDTH` e `DESIGN_SCREEN_HEIGHT` = `MediaQuery.sizeOf(context)` no seu aparelho de dev.
abstract final class DesignScreen {
  static double _scaleW = 1;
  static double _scaleH = 1;

  static double get scaleWidth => _scaleW;
  static double get scaleHeight => _scaleH;
  static double get scaleMin => math.min(_scaleW, _scaleH);

  static void updateFrom(Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    _scaleW = size.width / DesignScreenConfig.referenceWidth;
    _scaleH = size.height / DesignScreenConfig.referenceHeight;
  }
}
