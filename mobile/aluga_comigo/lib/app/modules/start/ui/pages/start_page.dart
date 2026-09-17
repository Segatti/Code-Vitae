import 'dart:async';

import 'package:aluga_comigo/app/shared/domain/constants/app_colors.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/location_permission_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_auth_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/domain/constants/icons_asset.dart';
import '../../../../shared/domain/helpers/start_navigation_helper.dart';
import '../../../../shared/presenter/helpers/feed_session_helper.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../../my_immobiles/ui/controllers/my_immobiles_controller.dart';
import '../../../chats/ui/controllers/chats_list_controller.dart';
import '../../../like/ui/controllers/likes_controller.dart';
import '../../../notifications/ui/controllers/notifications_badge_controller.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  bool hasLocationPermission = false;
  bool isCheckingPermission = true;

  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final GlobalKey<RouterOutletState> _routerOutletKey =
      GlobalKey<RouterOutletState>();

  late final INotificationsBadgeController _notificationsBadge;

  @override
  void initState() {
    super.initState();
    _notificationsBadge = inject<INotificationsBadgeController>();
    _notificationsBadge.startWatching();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.short4,
    );
    _checkLocationPermission();
    _loadInventory();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ensureSwipeTabForSession(),
    );
  }

  void _ensureSwipeTabForSession() {
    if (!mounted) return;
    final type = SessionService.customer?.typeUser ?? TypeUser.none;
    if (type != TypeUser.immobile) return;

    final path = context.routeState(listen: false).uri.path;
    if (StartNavigationHelper.isImmobileOwnerSwipeRoute(path)) {
      const route = '/start/my-immobiles/';
      _routerOutletKey.currentState?.navigate(route);
      _reloadTabData(route);
    }
  }

  Future<void> _loadInventory() async {
    try {
      final database = inject<SupabaseDatabaseService>();
      final map = await database.getUserInventory();
      SessionService.setInventory(UserInventory.fromMap(map));
    } catch (_) {}
  }

  Future<void> _logout() async {
    final auth = inject<SupabaseAuthService>();
    final storage = inject<SecureStorageService>();
    await auth.signOut();
    await storage.deleteData(StorageKey.user);
    FeedSessionHelper.resetSwipeFeeds();
    SessionService.clearCustomer();
    if (!mounted) return;
    Navigator.of(context).pop();
    context.navigate('/auth/');
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      hasLocationPermission = status.isGranted;
      isCheckingPermission = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      hasLocationPermission = status.isGranted;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDrawer() {
    final isImmobileOwner =
        SessionService.customer?.typeUser == TypeUser.immobile;

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
            if (!isImmobileOwner) ...[
              IconButton(
                onPressed: () {
                  context.pushNamed("/config/profile");
                },
                tooltip: "Perfil",
                icon: const Icon(Icons.person, color: Colors.white, size: 35),
              ),
              const Gap(16),
            ],
            IconButton(
              onPressed: () {
                context.pushNamed("/config/security");
              },
              tooltip: "Segurança",
              icon: const Icon(Icons.shield, color: Colors.white, size: 35),
            ),
            if (!isImmobileOwner) ...[
              const Gap(16),
              IconButton(
                onPressed: () {
                  context.pushNamed("/quest/");
                },
                tooltip: "Missões",
                icon: const Icon(Icons.list_alt, color: Colors.white, size: 35),
              ),
              const Gap(16),
              IconButton(
                tooltip: "Histórico",
                onPressed: () {
                  context.pushNamed("/history/");
                },
                icon: const Icon(
                  Icons.photo_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ],
            const Gap(16),
            IconButton(
              onPressed: () {
                context.pushNamed("/store/");
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
                                    onPressed: _logout,
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

  int _navigationIndexFromPath(String path) {
    final type = SessionService.customer?.typeUser ?? TypeUser.none;
    return StartNavigationHelper.navigationIndexForPath(path, type);
  }

  void _navigateToTab(int index) {
    // Bottom nav sits beside [RouterOutlet] in the Stack — `context.navigate`
    // would hit the root delegate and replace the whole app. Target the outlet.
    final type = SessionService.customer?.typeUser ?? TypeUser.none;
    final routes = StartNavigationHelper.tabRoutesFor(type);
    if (index < 0 || index >= routes.length) return;
    final route = routes[index];
    _routerOutletKey.currentState?.navigate(route);
    _reloadTabData(route);
  }

  void _reloadTabData(String route) {
    if (route.startsWith('/start/likes')) {
      unawaited(inject<ILikesController>().initialize());
    } else if (route.startsWith('/start/chats')) {
      unawaited(inject<IChatsListController>().initialize());
    } else if (route.startsWith('/start/my-immobiles')) {
      final accountId = SessionService.customer?.id ?? '';
      if (accountId.isNotEmpty) {
        unawaited(inject<IMyImmobilesController>().initialize(accountId));
      }
    }
  }

  BottomNavigationBarItem _navBarItem({
    required String asset,
    required int itemIndex,
    required int currentIndex,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        asset,
        width: 35,
        height: 35,
        colorFilter: currentIndex == itemIndex
            ? ColorFilter.mode(AppColors.primaryOrange, BlendMode.srcIn)
            : null,
      ),
    );
  }

  Widget _buildNavigationBar(int currentIndex) {
    final isImmobileOwner =
        SessionService.customer?.typeUser == TypeUser.immobile;

    final items = isImmobileOwner
        ? [
            _navBarItem(
              asset: IconsAsset.home,
              itemIndex: 0,
              currentIndex: currentIndex,
            ),
            _navBarItem(
              asset: IconsAsset.likes,
              itemIndex: 1,
              currentIndex: currentIndex,
            ),
            _navBarItem(
              asset: IconsAsset.chat,
              itemIndex: 2,
              currentIndex: currentIndex,
            ),
          ]
        : [
            _navBarItem(
              asset: IconsAsset.customer,
              itemIndex: 0,
              currentIndex: currentIndex,
            ),
            _navBarItem(
              asset: IconsAsset.home,
              itemIndex: 1,
              currentIndex: currentIndex,
            ),
            _navBarItem(
              asset: IconsAsset.likes,
              itemIndex: 2,
              currentIndex: currentIndex,
            ),
            _navBarItem(
              asset: IconsAsset.chat,
              itemIndex: 3,
              currentIndex: currentIndex,
            ),
          ];

    return SnakeNavigationBar.color(
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
      currentIndex: currentIndex,
      onTap: (index) {
        if (currentIndex != index) {
          _navigateToTab(index);
        }
      },
      items: items,
    );
  }

  Widget _buildBody() {
    final routerDelegate = Router.of(context).routerDelegate;

    return Column(
      children: [
        const Divider(indent: 16, endIndent: 16),
        Expanded(
          child: Stack(
            children: [
              RouterOutlet(key: _routerOutletKey),
              Positioned(
                right: 0,
                left: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListenableBuilder(
                    listenable: routerDelegate,
                    builder: (context, _) {
                      final currentIndex = _navigationIndexFromPath(
                        context.routeState().uri.path,
                      );
                      return _buildNavigationBar(currentIndex);
                    },
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
        trailing: ListenableBuilder(
          listenable: _notificationsBadge,
          builder: (context, _) {
            final count = _notificationsBadge.unreadCount;
            return IconButton(
              onPressed: () => context.pushNamed('/notifications/'),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: 35,
                    color: Colors.grey,
                  ),
                  if (count > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 18),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
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
