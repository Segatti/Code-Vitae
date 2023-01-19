import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/presenter/widgets/view/app_bar_widget.dart';
import '../../../../core/presenter/widgets/view/base_page_widget.dart';
import '../../../../core/presenter/widgets/view/bottom_navigation_bar_widget.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/home');
    return Scaffold(
      appBar: const AppBarWidget(title: 'Dimension A-0'),
      body: BasePageWidget(
          child: Row(
        children: const [
          Expanded(
            child: RouterOutlet(),
          ),
        ],
      )),
      bottomNavigationBar: const BottomNavigationBarWidget(
        initialValue: 0,
      ),
    );
  }
}
