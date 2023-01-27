import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late CupertinoThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        onTap: (value) {
          switch (value) {
            case 0:
              Modular.to.navigate('/navigation/profile');
              break;
            case 1:
              Modular.to.navigate('/navigation/morty_verso');
              break;
            case 2:
              Modular.to.navigate('/navigation/settings/');
              break;
            default:
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tropicalstorm),
            label: 'Morty Verso',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear),
            label: 'Settings',
          ),
        ],
      ),
      backgroundColor: theme.barBackgroundColor,
      tabBuilder: (_, __) => const RouterOutlet(),
    );
  }
}
