import 'package:material_ui/material_ui.dart';

import '../../presenter/widgets/scrolls/custom_scroll_behavior.dart';

extension WidgetExtension on Widget {
  Widget visibleWhen(bool condition) {
    return Visibility(visible: condition, child: this);
  }

  Widget move(Offset offset) {
    return Transform.translate(offset: offset, child: this);
  }

  Widget repaintBoundary() {
    return RepaintBoundary(child: this);
  }

  // Widget withObserver() {
  //   return Observer(
  //     builder: (_) {
  //       return this;
  //     },
  //   );
  // }

  Widget mouseHover(Function(bool hover) onHover, {bool canHover = true}) {
    return MouseRegion(
      onEnter: (_) {
        onHover(true);
      },
      onExit: (_) {
        onHover(false);
      },
      child: this,
    );
  }

  Widget mouseClick(VoidCallback onTap, {bool canClick = true}) {
    return MouseRegion(
      cursor: (canClick) ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: () {
          if (canClick) {
            onTap();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: this,
      ),
    );
  }

  Widget dragScroll() {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: this,
    );
  }
}

extension TextExtension<T extends Text> on T {
  Text copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) => Text(
    data ?? this.data ?? "",
    style: style ?? this.style,
    strutStyle: strutStyle ?? this.strutStyle,
    textAlign: textAlign ?? this.textAlign,
    locale: locale ?? this.locale,
    maxLines: maxLines ?? this.maxLines,
    overflow: overflow ?? this.overflow,
    semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    softWrap: softWrap ?? this.softWrap,
    textDirection: textDirection ?? this.textDirection,
    textScaler: textScaler ?? this.textScaler,
    textWidthBasis: textWidthBasis ?? this.textWidthBasis,
    textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    selectionColor: selectionColor ?? this.selectionColor,
  );

  T withoutScale() => copyWith(textScaler: TextScaler.noScaling) as T;
}
