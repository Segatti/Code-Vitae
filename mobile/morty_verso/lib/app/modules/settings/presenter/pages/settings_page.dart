import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/general/text_widget.dart';

import '../../../../core/presenter/widgets/view/base_page_widget.dart';
import '../stores/settings_store.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late DotEnv env;
  late SettingsStore store;
  late CupertinoThemeData theme;

  @override
  void initState() {
    _init();
    store = Modular.get<SettingsStore>();
    super.initState();
  }

  Future _init() async {
    await DotEnv().load(fileName: ".env");
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return BasePageWidget(
      title: 'Settings',
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: theme.textTheme.textStyle.color!.withOpacity(.25),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Column(
                children: [
                  CupertinoListTile(
                    title: const TextWidget(text: 'Dark Mode', fontSize: 17),
                    backgroundColor: theme.barBackgroundColor,
                    trailing: CupertinoSwitch(
                      value: store.appStore.themeIsDark,
                      onChanged: (bool value) {
                        store.changeTheme();
                      },
                    ),
                    onTap: () {
                      store.changeTheme();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: PaddingPattern.medium),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              vertical: PaddingPattern.medium,
            ),
            decoration: BoxDecoration(
                color: theme.barBackgroundColor,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: theme.textTheme.textStyle.color!.withOpacity(.25),
                    offset: const Offset(0, 0),
                    blurRadius: 4,
                  )
                ]),
            child: Column(
              children: const [
                TextWidget(
                  text: 'Credits',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: PaddingPattern.small),
                TextWidget(
                  text: 'Developer: Vittor Feitosa',
                  fontSize: 12,
                ),
                SizedBox(height: PaddingPattern.small),
                TextWidget(
                  text: 'API: https://rickandmortyapi.com/',
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
