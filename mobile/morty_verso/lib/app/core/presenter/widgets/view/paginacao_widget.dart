import 'package:flutter/cupertino.dart';

import '../../../domain/patterns/padding_pattern.dart';

class PaginacaoWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String numberPage;
  final Function? onTapPrevButton;
  final Function? onTapNextButton;
  const PaginacaoWidget({
    super.key,
    required this.scrollController,
    this.onTapPrevButton,
    this.onTapNextButton,
    this.numberPage = "???",
  });

  @override
  State<PaginacaoWidget> createState() => _PaginacaoWidgetState();
}

class _PaginacaoWidgetState extends State<PaginacaoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: CupertinoColors.black.withOpacity(.25),
          height: 1,
          width: double.maxFinite,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingPattern.small,
            vertical: PaddingPattern.medium,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                color: CupertinoColors.activeBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingPattern.big,
                ),
                onPressed: widget.onTapPrevButton != null
                    ? () => widget.onTapPrevButton!()
                    : null,
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.chevron_left),
                    Text('Prev'),
                  ],
                ),
              ),
              Text(widget.numberPage),
              CupertinoButton(
                color: CupertinoColors.activeBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingPattern.big,
                ),
                onPressed: widget.onTapNextButton != null
                    ? () => widget.onTapNextButton!()
                    : null,
                child: const Row(
                  children: [
                    Text('Next'),
                    Icon(CupertinoIcons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
