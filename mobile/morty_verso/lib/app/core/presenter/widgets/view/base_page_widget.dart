import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/app_store.dart';

import '../../../domain/patterns/padding_pattern.dart';

class BasePageWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets? padding;
  const BasePageWidget({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  State<BasePageWidget> createState() => _BasePageWidgetState();
}

class _BasePageWidgetState extends State<BasePageWidget> {
  late AppStore store;
  late CupertinoThemeData theme;
  late TextStyle textStyleTheme;

  @override
  void initState() {
    store = Modular.get<AppStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    textStyleTheme = theme.textTheme.textStyle;

    return Observer(builder: (context) {
      return CupertinoPageScaffold(
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (_, __) => <Widget>[
              CupertinoSliverNavigationBar(
                previousPageTitle: 'Back',
                border: const Border(
                  bottom: BorderSide(
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
                trailing: widget.trailing,
                stretch: true,
                largeTitle: Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: textStyleTheme.fontFamily,
                  ),
                ),
              ),
            ],
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(store.themeIsDark
                      ? 'assets/images/body_background_dark.png'
                      : 'assets/images/body_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: PaddingPattern.small,
                    vertical: PaddingPattern.medium,
                  ),
              child: SafeArea(
                child: SizedBox(
                  width: double.maxFinite,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
