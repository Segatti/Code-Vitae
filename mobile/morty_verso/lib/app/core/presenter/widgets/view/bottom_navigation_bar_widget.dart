import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/stores/bottom_navigation_bar_store.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int initialValue;
  const BottomNavigationBarWidget({super.key, required this.initialValue});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late BottomNavigationBarStore store;

  @override
  void initState() {
    store = Modular.get<BottomNavigationBarStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return SafeArea(
        child: BottomNavigationBar(
          backgroundColor: Colors.grey,
          currentIndex: store.currentIndex,
          selectedItemColor: Colors.white,
          onTap: (value) {
            store.setCurrentIndex(value);

            Modular.to.navigate(store.routes[value]);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.cyclone,
              ),
              label: 'Morty Verso',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings',
            ),
          ],
        ),
      );
    });
  }
}
