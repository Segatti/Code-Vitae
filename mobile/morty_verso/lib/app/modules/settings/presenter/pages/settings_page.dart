import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
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
    return BasePageWidget(
      child: Column(
        children: [
          Center(
            // TODO: Seguir esse exemplo
            child: Text(
              'Project Morty Verso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CupertinoTheme.of(context).textTheme.textStyle.color,
              ),
            ),
          ),
          const SizedBox(height: PaddingPattern.small),
          const Center(
            child: Text(
              'Developed by: Vittor Feitosa',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: PaddingPattern.small),
          const Center(
            child: Text(
              'Made by fan for fan',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: PaddingPattern.big),
          Row(
            children: const [
              Expanded(
                  child:
                      ElevatedButton(onPressed: null, child: Text('Language'))),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  store.changeTheme();
                },
                child: const Text('Change Theme'),
              )),
            ],
          ),
          const SizedBox(height: PaddingPattern.big),
          Row(
            children: [
              Text(
                "Version: ${dotenv.env['VERSION']}",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
