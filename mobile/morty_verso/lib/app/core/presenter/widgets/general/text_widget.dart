import 'package:flutter/cupertino.dart';

class TextWidget extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  const TextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight,
    this.fontStyle,
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  late CupertinoThemeData theme;
  late TextStyle themeTextStyle;

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    themeTextStyle = theme.textTheme.textStyle;

    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        fontStyle: widget.fontStyle,
        color: themeTextStyle.color,
        fontFamily: themeTextStyle.fontFamily,
      ),
    );
  }
}
