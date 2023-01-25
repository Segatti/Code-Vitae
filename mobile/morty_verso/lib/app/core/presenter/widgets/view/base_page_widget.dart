import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/app_store.dart';

import '../../../domain/patterns/padding_pattern.dart';

class BasePageWidget extends StatefulWidget {
  final Widget child;
  const BasePageWidget({
    super.key,
    required this.child,
  });

  @override
  State<BasePageWidget> createState() => _BasePageWidgetState();
}

class _BasePageWidgetState extends State<BasePageWidget> {
  late AppStore store;
  @override
  void initState() {
    store = Modular.get<AppStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(store.themeIsDark
                ? 'assets/images/body_background_dark.png'
                : 'assets/images/body_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingPattern.small,
          vertical: PaddingPattern.medium,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            child: widget.child,
          ),
        ),
      );
    });
  }
}
