import 'package:swipable_stack/swipable_stack.dart';

/// Após remover o card da lista, o topo da fila deve ser o índice 0.
class SwipableStackHelper {
  SwipableStackHelper._();

  static void resetToFront(SwipableStackController controller) {
    controller.currentIndex = 0;
  }
}
