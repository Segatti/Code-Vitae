import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SliderDrawer(
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
                      onPressed: () {
                        Modular.to.pushNamed("/config/profile");
                      },
                      tooltip: "Perfil",
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        Modular.to.pushNamed("/config/security");
                      },
                      tooltip: "Segurança",
                      icon: const Icon(
                        Icons.shield,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        Modular.to.pushNamed("/quest/");
                      },
                      tooltip: "Missões",
                      icon: const Icon(
                        Icons.list_alt,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      tooltip: "Histórico",
                      onPressed: () {
                        Modular.to.pushNamed(
                          "/start/likes/history",
                          forRoot: true,
                        );
                      },
                      icon: const Icon(
                        Icons.photo_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        Modular.to.pushNamed("/store/");
                      },
                      tooltip: "Loja",
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DefaultTextStyle(
                                style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(16),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xFFDF924B),
                                              width: 5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Deseja Sair?",
                                          style: GoogleFonts.rubik(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Gap(16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Ao confirmar você será deslogado do app.",
                                              style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  const Color(0xFFDF924B),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              "Cancelar",
                                              style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFF2C29A3),
                                                width: 5,
                                              ),
                                            ),
                                            onPressed: () {
                                              Modular.to.navigate("/auth/");
                                            },
                                            child: Text(
                                              "Confirmar",
                                              style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
                              shadowColor:
                                  const Color.fromARGB(255, 170, 110, 110),
                              elevation: 10,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
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
                                  case 2:
                                    Modular.to.navigate("/start/likes/");
                                    break;
                                  case 3:
                                    Modular.to.navigate("/start/chats/");
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
        ),
      ),
    );
  }
}
