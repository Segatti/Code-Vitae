import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

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
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        key: _drawerKey,
        useGestures: false,
        sliderOpenSize: 80,
        isDraggable: false,
        appBar: SliderAppBar(
          drawerIconSize: 35,
          appBarColor: Colors.white,
          drawerIconColor: const Color.fromRGBO(158, 158, 158, 1),
          title: SvgPicture.asset(
            "assets/icons/logo.svg",
            width: 40,
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_active_outlined,
              size: 35,
              color: Colors.grey,
            ),
          ),
        ),
        slider: Container(
          color: const Color(0xFF2C29A3),
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 16,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.abc,
                    size: 35,
                  ),
                ),
                const Gap(6),
                const SizedBox(
                  width: 35,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                const Gap(16),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const Gap(16),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shield,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const Gap(16),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.list_alt,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const Gap(16),
                IconButton(
                  tooltip: "Teste",
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const Gap(16),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 35,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Column(
          children: [
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            Expanded(
              child: Stack(
                children: [
                  const RouterOutlet(),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: SnakeNavigationBar.color(
                          snakeViewColor: Colors.transparent,
                          shadowColor: const Color.fromARGB(255, 170, 110, 110),
                          elevation: 10,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          snakeShape: SnakeShape.circle,
                          selectedItemColor: Colors.amber,
                          unselectedItemColor: Colors.blueGrey,
                          currentIndex: indexNavigationBar,
                          onTap: (index) {
                            setState(() => indexNavigationBar = index);
                            switch (index) {
                              case 0:
                                Modular.to.navigate("/start/customers/");
                                break;
                              case 1:
                                Modular.to.navigate("/start/houses/");
                                break;
                              default:
                            }
                          },
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
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
