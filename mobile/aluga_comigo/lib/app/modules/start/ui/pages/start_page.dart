import 'package:aluga_comigo/app/shared/domain/constants/app_colors.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/location_permission_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/domain/constants/icons_asset.dart';
import '../../../auth/domain/enums/type_immobile.dart';
import '../../../customer/data/models/customer_model.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  int indexNavigationBar = 0;
  bool hasLocationPermission = false;
  bool isCheckingPermission = true;

  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.short4,
    );
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      hasLocationPermission = status.isGranted;
      isCheckingPermission = false;
    });

    // Verificar perfil após a verificação de permissão
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkProfileComplete();
      });
    }
  }

  bool _isProfileComplete(CustomerModel? model) {
    if (model == null) return false;

    switch (model) {
      case PersonCustomerModel _:
        return model.name.isNotEmpty &&
        model.dateBirth.isNotEmpty &&
        model.photos.isNotEmpty &&
        (model.shortDescription.isNotEmpty ||
            model.longDescription.isNotEmpty) &&
        model.cityState.isNotEmpty &&
        model.phone.isNotEmpty &&
        model.gender.isNotEmpty;
      case ImmobileCustomerModel _:
        return model.cep.isNotEmpty &&
        model.price > 0 &&
        model.photos.isNotEmpty &&
        (model.shortDescription.isNotEmpty ||
            model.longDescription.isNotEmpty) &&
        model.cityState.isNotEmpty &&
        model.phone.isNotEmpty &&
        model.typeImmobile != TypeImmobile.none;
    }
  }

  Future<void> _showIncompleteProfileDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Color(0XFFDF924B),
                ),
                const Gap(16),
                Text(
                  "Perfil Incompleto",
                  style: GoogleFonts.rubik(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(16),
                Text(
                  "Você precisa completar seu perfil para visualizar os detalhes dos outros usuários.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(fontSize: 16, color: Colors.black54),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Cancelar",
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Modular.to.pushNamed("/config/profile");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFDF924B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Preencher",
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkProfileComplete() {
    if (SessionService.customer == null) return;

    if (!_isProfileComplete(SessionService.customer!)) {
      _showIncompleteProfileDialog();
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      hasLocationPermission = status.isGranted;
    });

    // Verificar perfil após conceder permissão
    if (mounted && hasLocationPermission) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkProfileComplete();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDrawer() {
    return Container(
      color: const Color(0xFF2C29A3),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: SessionService.customer?.photos[0] ?? "",
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person, color: Colors.white, size: 35),
                ),
              ),
            ),
            const Gap(6),
            const SizedBox(
              width: 35,
              child: Divider(color: Colors.white, thickness: 1),
            ),
            const Gap(16),
            IconButton(
              onPressed: () {
                Modular.to.pushNamed("/config/profile");
              },
              tooltip: "Perfil",
              icon: const Icon(Icons.person, color: Colors.white, size: 35),
            ),
            const Gap(16),
            IconButton(
              onPressed: () {
                Modular.to.pushNamed("/config/security");
              },
              tooltip: "Segurança",
              icon: const Icon(Icons.shield, color: Colors.white, size: 35),
            ),
            const Gap(16),
            IconButton(
              onPressed: () {
                Modular.to.pushNamed("/quest/");
              },
              tooltip: "Missões",
              icon: const Icon(Icons.list_alt, color: Colors.white, size: 35),
            ),
            const Gap(16),
            IconButton(
              tooltip: "Histórico",
              onPressed: () {
                Modular.to.pushNamed("/start/likes/history", forRoot: true);
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
              icon: const Icon(Icons.store, color: Colors.white, size: 35),
            ),
            const Spacer(),
            const SizedBox(
              width: 35,
              child: Divider(color: Colors.white, thickness: 1),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      backgroundColor: const Color(0xFFDF924B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                        borderRadius: BorderRadius.circular(10),
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
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const Divider(indent: 16, endIndent: 16),
        Expanded(
          child: Stack(
            children: [
              const RouterOutlet(),
              Positioned(
                right: 0,
                left: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SnakeNavigationBar.color(
                    snakeViewColor: Colors.white,
                    shadowColor: const Color.fromARGB(255, 170, 110, 110),
                    elevation: 10,
                    height: 60,
                    backgroundColor: Colors.white,
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
                        case 2:
                          Modular.to.navigate("/start/likes/");
                          break;
                        case 3:
                          Modular.to.navigate("/start/chats/");
                          break;
                        default:
                      }
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          IconsAsset.customer,
                          width: 35,
                          height: 35,
                          colorFilter: indexNavigationBar == 0
                              ? ColorFilter.mode(
                                  AppColors.primaryOrange,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          IconsAsset.home,
                          width: 35,
                          height: 35,
                          colorFilter: indexNavigationBar == 1
                              ? ColorFilter.mode(
                                  AppColors.primaryOrange,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          IconsAsset.likes,
                          width: 35,
                          height: 35,
                          colorFilter: indexNavigationBar == 2
                              ? ColorFilter.mode(
                                  AppColors.primaryOrange,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          IconsAsset.chat,
                          width: 35,
                          height: 35,
                          colorFilter: indexNavigationBar == 3
                              ? ColorFilter.mode(
                                  AppColors.primaryOrange,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliderAppBar(
      config: SliderAppBarConfig(
        drawerIconSize: 35,
        backgroundColor: Colors.white,
        drawerIconColor: const Color.fromRGBO(158, 158, 158, 1),
        title: SvgPicture.asset("assets/icons/logo.svg", width: 40),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_active_outlined,
            size: 35,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCheckingPermission) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!hasLocationPermission) {
      return LocationPermissionWidget(
        onRequestPermission: _requestLocationPermission,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SliderDrawer(
          key: _drawerKey,
          sliderOpenSize: 80,
          isDraggable: false,
          appBar: _buildAppBar(),
          slider: _buildDrawer(),
          child: _buildBody(),
        ),
      ),
    );
  }
}
