import 'dart:async';

import 'package:aluga_comigo/app/shared/domain/constants/app_colors.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/location_permission_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
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
import '../../../../shared/presenter/helpers/terms_acceptance_flow.dart';
import '../../../../shared/presenter/widgets/app_message_dialog.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../../chats/ui/controllers/chats_list_controller.dart';
import '../../../like/ui/controllers/likes_controller.dart';
import '../../../my_immobiles/ui/controllers/my_immobiles_controller.dart';
import '../../../notifications/ui/controllers/notifications_badge_controller.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  static const _exitConfirmWindow = Duration(seconds: 2);

  bool isMenuOpen = false;
  bool hasLocationPermission = false;
  bool isCheckingPermission = true;
  DateTime? _lastBackPressAt;

  late AnimationController _animationController;
  final _drawerKey = GlobalKey<SliderDrawerState>();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _ensureTermsAccepted();
      if (!mounted) return;
      _ensureSwipeTabForSession();
    });
  }

  Future<void> _ensureTermsAccepted() async {
    final accepted = await TermsAcceptanceFlow.ensureAcceptedIfNeeded(context);
    if (!accepted && mounted) {
      context.navigate('/auth/');
    }
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
    FeedSessionHelper.resetSessionScopedControllers();
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

  void _handleSystemBack() {
    final drawer = _drawerKey.currentState;
    if (drawer != null && drawer.isDrawerOpen) {
      drawer.closeSlider();
      return;
    }

    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) {
      rootNav.pop();
      return;
    }

    final now = DateTime.now();
    final lastPress = _lastBackPressAt;
    if (lastPress != null &&
        now.difference(lastPress) <= _exitConfirmWindow) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressAt = now;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Toque em voltar novamente se deseja sair',
            style: GoogleFonts.rubik(color: Colors.white),
          ),
          duration: _exitConfirmWindow,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildDrawer() {
    final isImmobileOwner =
        SessionService.customer?.typeUser == TypeUser.immobile;

    void closeAnd(void Function() action) {
      action();
      _drawerKey.currentState?.closeSlider();
    }

    return Container(
      color: const Color(0xFF2C29A3),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: SessionService.customer?.photos[0] ?? '',
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ),
            const Gap(12),
            const Divider(color: Colors.white, thickness: 1, height: 1),
            const Gap(8),
            if (!isImmobileOwner)
              _DrawerMenuItem(
                key: const ValueKey('drawer_menu_profile'),
                icon: Icons.person,
                label: 'Perfil',
                semanticsLabel: 'Menu perfil',
                onTap: () =>
                    closeAnd(() => context.pushNamed('/config/profile')),
              ),
            const Gap(8),
            _DrawerMenuItem(
              icon: Icons.shield,
              label: 'Segurança',
              onTap: () =>
                  closeAnd(() => context.pushNamed('/config/security')),
            ),
            const Gap(8),
            if (!isImmobileOwner) ...[
              _DrawerMenuItem(
                icon: Icons.list_alt,
                label: 'Missões',
                onTap: () => closeAnd(() => context.pushNamed('/quest/')),
              ),
              const Gap(8),
              _DrawerMenuItem(
                icon: Icons.photo_outlined,
                label: 'Histórico',
                onTap: () => closeAnd(() => context.pushNamed('/history/')),
              ),
              const Gap(8),
            ],
            if (SessionService.systemConfig.storeActive)
              _DrawerMenuItem(
                icon: Icons.store,
                label: 'Loja',
                onTap: () => closeAnd(() => context.pushNamed('/store/')),
              ),
            if (SessionService.systemConfig.storeActive) const Gap(8),
            const Spacer(),
            _DrawerMenuItem(
              icon: Icons.support_agent,
              label: 'Suporte',
              onTap: () => closeAnd(() => context.pushNamed('/tickets/')),
            ),
            const Gap(8),
            const Divider(color: Colors.white, thickness: 1, height: 1),
            const Gap(8),
            _DrawerMenuItem(
              key: const ValueKey('drawer_menu_logout'),
              icon: Icons.exit_to_app,
              label: 'Sair',
              onTap: () async {
                final confirmed = await showAppConfirmDialog(
                  context: context,
                  title: 'Deseja Sair?',
                  message: 'Ao confirmar você será deslogado do app.',
                  confirmKey: const ValueKey('drawer_logout_confirm'),
                );
                if (confirmed == true && mounted) {
                  await _logout();
                }
              },
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
    required String label,
    required int itemIndex,
    required int currentIndex,
    required String semanticsLabel,
  }) {
    final selected = currentIndex == itemIndex;
    return BottomNavigationBarItem(
      icon: Semantics(
        label: semanticsLabel,
        button: true,
        child: _BottomNavIconLabel(
          asset: asset,
          label: label,
          selected: selected,
        ),
      ),
      label: '',
    );
  }

  Widget _buildNavigationBar(int currentIndex) {
    final isImmobileOwner =
        SessionService.customer?.typeUser == TypeUser.immobile;

    final items = isImmobileOwner
        ? [
            _navBarItem(
              asset: IconsAsset.home,
              label: 'Imóveis',
              itemIndex: 0,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_feed_imoveis',
            ),
            _navBarItem(
              asset: IconsAsset.likes,
              label: 'Curtidas',
              itemIndex: 1,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_curtidas',
            ),
            _navBarItem(
              asset: IconsAsset.chat,
              label: 'Chat',
              itemIndex: 2,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_chats',
            ),
          ]
        : [
            _navBarItem(
              asset: IconsAsset.customer,
              label: 'Pessoas',
              itemIndex: 0,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_feed_pessoas',
            ),
            _navBarItem(
              asset: IconsAsset.home,
              label: 'Imóveis',
              itemIndex: 1,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_feed_imoveis',
            ),
            _navBarItem(
              asset: IconsAsset.likes,
              label: 'Curtidas',
              itemIndex: 2,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_curtidas',
            ),
            _navBarItem(
              asset: IconsAsset.chat,
              label: 'Chat',
              itemIndex: 3,
              currentIndex: currentIndex,
              semanticsLabel: 'nav_chats',
            ),
          ];

    return SnakeNavigationBar.color(
      snakeViewColor: Colors.white,
      shadowColor: const Color.fromARGB(255, 170, 110, 110),
      elevation: 10,
      height: 68,
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleSystemBack();
      },
      child: Scaffold(
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
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.semanticsLabel,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? label,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const Gap(2),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavIconLabel extends StatelessWidget {
  const _BottomNavIconLabel({
    required this.asset,
    required this.label,
    required this.selected,
  });

  final String asset;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryOrange : Colors.blueGrey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          asset,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const Gap(2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.rubik(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: color,
            height: 1,
          ),
        ),
      ],
    );
  }
}
