import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';

import '../../../shared/data/services/aluga_comigo_api_client.dart';
import '../../../shared/data/services/secure_storage_service.dart';
import '../../../shared/data/services/session_service.dart';
import '../../../shared/domain/helpers/start_navigation_helper.dart';
import '../../auth/domain/enums/type_user.dart';
import '../../auth/data/models/user_model.dart';
import '../../auth/domain/entities/inputs/login_input.dart';
import '../../auth/domain/usecases/login_user.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool showTitle = true;
  double borderLogo = 30;
  double widthContainer = 160;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        showTitle = false;
        borderLogo = 80;
        widthContainer = 100;
      });
      Future.delayed(const Duration(seconds: 1), () async {
        if (!mounted) return;
        await _ensureBackendHealthy();
        if (!mounted) return;
        await _navigateAfterSplash();
      });
    });
  }

  Future<void> _ensureBackendHealthy() async {
    final api = inject<AlugaComigoApiClient>();
    while (mounted) {
      if (await api.checkHealth()) return;
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              content: const Text(
                'Servidor em manutenção, tente novamente mais tarde...',
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (await api.checkHealth()) {
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    }
                  },
                  child: const Text('Recarregar'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _navigateAfterSplash() async {
    final storage = inject<SecureStorageService>();
    final loginUser = inject<ILoginUser>();
    final showIntro = await storage.getData(StorageKey.intro);
    if (!mounted) return;
    if (showIntro == "false") {
      var data = await storage.getData(StorageKey.user);
      if (!mounted) return;
      if (data != null) {
        final user = UserModel.fromJson(data);
        final userLogged = await loginUser(
          LoginInput(user.email, user.password),
        );
        if (!mounted) return;
        userLogged.fold(
          (error) {
            context.navigate("/auth/");
          },
          (user) {
            context.navigate(
              StartNavigationHelper.homeRouteFor(
                SessionService.customer?.typeUser ?? TypeUser.none,
              ),
            );
          },
        );
      } else {
        context.navigate("/auth/");
      }
    } else {
      context.navigate("/intro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container(color: const Color(0xFF2C29A3))),
              const Divider(color: Colors.white, height: 2),
              Expanded(child: Container(color: const Color(0xFFDF924B))),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: RepaintBoundary(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderLogo),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(20, 20),
                      blurRadius: 40,
                      color: Colors.black.withValues(alpha: .25),
                    ),
                    BoxShadow(
                      offset: const Offset(-20, -20),
                      blurRadius: 40,
                      color: Colors.white.withValues(alpha: .25),
                    ),
                  ],
                ),
                height: widthContainer,
                width: widthContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/logo.svg"),
                    Visibility(
                      visible: showTitle,
                      child: StyledText(
                        text: "Aluga<orange>Comigo</orange>",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          color: const Color(0xFF2C29A3),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        tags: {
                          'orange': StyledTextTag(
                            style: const TextStyle(color: Color(0xFFDF924B)),
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
