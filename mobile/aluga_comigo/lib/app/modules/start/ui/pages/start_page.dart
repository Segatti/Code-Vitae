import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  int indexNavigationBar = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.short4,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (_animationController.isDismissed) {
      _animationController.forward();
      setState(() {
        isMenuOpen = true;
      });
    } else {
      _animationController.reverse();
      setState(() {
        isMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
            height: 1,
          ),
        ),
        leading: TweenAnimationBuilder(
          tween: ColorTween(
            begin: Colors.grey,
            end: isMenuOpen ? Colors.blue : Colors.grey,
          ),
          duration: Durations.short4,
          builder: (_, color, __) => IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              size: 35,
              progress: _animationController,
              color: color,
            ),
            onPressed: _onPressed,
          ),
        ),
        centerTitle: true,
        title: SvgPicture.asset(
          "assets/icons/logo.svg",
          width: 40,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_active_outlined,
              size: 35,
              color: Colors.grey,
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: const RouterOutlet(),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        padding: const EdgeInsets.all(16),
        snakeViewColor: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        snakeShape: SnakeShape.circle,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: indexNavigationBar,
        onTap: (index) => setState(() => indexNavigationBar = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.house,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
