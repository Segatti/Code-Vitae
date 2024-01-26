import 'package:flutter/material.dart';
import 'package:timer_watch/widgets/menu_item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        controller: PageController(viewportFraction: .8),
        children: [
          MenuItem(
            title: "Treinos",
            onTap: () => Navigator.of(context).pushNamed("/trainings"),
            icon: Icons.fitness_center,
          ),
          MenuItem(
            title: "Desafios",
            onTap: () => Navigator.of(context).pushNamed("/challenges"),
            icon: Icons.military_tech,
          ),
          MenuItem(
            title: "Configurações",
            onTap: () => Navigator.of(context).pushNamed("/config"),
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }
}
