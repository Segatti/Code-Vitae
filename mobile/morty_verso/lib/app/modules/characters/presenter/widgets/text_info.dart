import 'package:flutter/cupertino.dart';
import 'package:morty_verso/app/core/utils/strings.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';

class TextInfo extends StatefulWidget {
  final String keyValue;
  final String value;
  final bool top;
  final bool bottom;
  const TextInfo({
    super.key,
    required this.keyValue,
    required this.value,
    this.top = false,
    this.bottom = false,
  });

  @override
  State<TextInfo> createState() => _TextInfoState();
}

class _TextInfoState extends State<TextInfo> {
  late CupertinoThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return Row(
      children: [
        Expanded(child: LayoutBuilder(
          builder: (_, constrains) {
            return Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? CupertinoColors.lightBackgroundGray
                    : CupertinoColors.darkBackgroundGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.top ? 13 : 0),
                  bottomLeft: Radius.circular(widget.bottom ? 13 : 0),
                  topRight: Radius.circular(widget.top ? 13 : 0),
                  bottomRight: Radius.circular(widget.bottom ? 13 : 0),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.top ? 13 : 0),
                      bottomLeft: Radius.circular(widget.bottom ? 13 : 0),
                      topRight: Radius.circular(widget.top ? 13 : 0),
                      bottomRight: Radius.circular(widget.bottom ? 13 : 0),
                    ),
                    child: Container(
                      width: constrains.maxWidth * 0.3,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      color: theme.brightness == Brightness.light
                          ? CupertinoColors.darkBackgroundGray
                          : CupertinoColors.white,
                      child: Text(
                        widget.keyValue,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.brightness == Brightness.light
                              ? CupertinoColors.white
                              : CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(widget.top ? 13 : 0),
                        bottomRight: Radius.circular(widget.bottom ? 13 : 0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: PaddingPattern.medium,
                          top: 12,
                          bottom: 12,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            validText(widget.value),
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.textTheme.textStyle.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )),
      ],
    );
  }
}
