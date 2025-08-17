import 'package:flutter/material.dart';

class OverlayHelper {
  OverlayEntry? _overlayEntry;
  bool isShowing = false;

  Future<void> create({
    required BuildContext context,
    required Widget child,
    required Offset position,
    bool canCloseClickOutside = false,
    Color? colorBackground,
    Size? size,
  }) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    // Se for usar o responsive_framework, tem que usar o data com .abs()
    // var offset = renderBox.localToGlobal(Offset.zero);
    Offset data = renderBox.globalToLocal(Offset.zero);
    data = Offset(data.dx.abs(), data.dy.abs());
    data += position;
    // print(offset);
    // print(pos);
    // offset += position;
    // print(offset);
    final Size screen = MediaQuery.sizeOf(context);
    // print(screen);
    // var diff = screen.height < offset.dy + (size?.height ?? 0)
    //     ? screen.height - (offset.dy + (size?.height ?? 0))
    //     : 0;

    final num diff = screen.height < data.dy + (size?.height ?? 0)
        ? screen.height - (data.dy + (size?.height ?? 0))
        : 0;

    // print(diff);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Stack(
        children: <Widget>[
          if (canCloseClickOutside)
            GestureDetector(
              onTap: () => hide(),
              child: Container(
                width: screen.width,
                height: screen.height,
                color: colorBackground ?? Colors.black26,
              ),
            ),
          Positioned(
            top: data.dy - diff.abs(),
            left: data.dx,
            child: Material(
              color: Colors.transparent,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void show(BuildContext context, {bool root = true}) {
    if (_overlayEntry == null || isShowing) return;
    isShowing = true;
    Overlay.of(context, rootOverlay: root).insert(_overlayEntry!);
  }

  void hide() {
    if (_overlayEntry == null || !isShowing) return;
    isShowing = false;
    _overlayEntry?.remove();
  }
}
