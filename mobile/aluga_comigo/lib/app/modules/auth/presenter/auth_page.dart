import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/data/services/secure_storage_service.dart';
import '../../../shared/data/services/session_service.dart';
import '../../../shared/domain/helpers/start_navigation_helper.dart';
import '../../../shared/presenter/widgets/popups/loading_popup.dart';
import '../../../shared/presenter/widgets/primary_button.dart';
import '../../../shared/presenter/widgets/secondary_button.dart';
import '../../auth/domain/enums/type_user.dart';
import '../domain/entities/inputs/login_input.dart';
import 'controllers/auth_controller.dart';
import 'widgets/login_card_widget.dart';
import 'widgets/signup_card_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Duration initialDuration = const Duration(milliseconds: 500);
  bool? haveAccount;
  Color color = const Color(0xFF2C29A3);
  final PageController _controller = PageController();
  bool showAnimation = true;
  final controller = inject<IAuthController>();
  final storage = inject<SecureStorageService>();

  void backPage() {
    setState(() {
      color = const Color(0xFF2C29A3);
    });
    _controller.previousPage(duration: Durations.short4, curve: Curves.linear);
  }

  void nextPage() {
    _controller.nextPage(duration: Durations.short4, curve: Curves.linear);
  }

  void notificationError(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(color: Colors.red, width: 5),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  message,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        color: color,
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      margin: .symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            "assets/icons/logoNew.png",
                            height: 120.h(),
                          ),
                          Padding(
                            padding: .only(right: 12.w()),
                            child: RepaintBoundary(
                              child: AnimatedTextKit(
                                repeatForever: true,
                                pause: const Duration(milliseconds: 1000),
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'uma Casa?',
                                    speed: const Duration(milliseconds: 160),
                                    textStyle: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 32.sp(),
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TyperAnimatedText(
                                    'um Apê?',
                                    speed: const Duration(milliseconds: 210),
                                    textStyle: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 32.sp(),
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap(32.h()),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DelayedDisplay(
                                delay: Duration(
                                  milliseconds: (showAnimation)
                                      ? initialDuration.inMilliseconds + 500
                                      : 0,
                                ),
                                slidingBeginOffset: const Offset(0.0, -0.35),
                                child: PrimaryButtonWidget(
                                  onTap: () {
                                    setState(() {
                                      haveAccount = true;
                                    });
                                    nextPage();
                                  },
                                  title: "Ja tenho conta",
                                ),
                              ),
                              const SizedBox(height: 16),
                              DelayedDisplay(
                                delay: Duration(
                                  milliseconds: (showAnimation)
                                      ? initialDuration.inMilliseconds + 500
                                      : 0,
                                ),
                                slidingBeginOffset: const Offset(0.0, -0.35),
                                child: SecondaryButtonWidget(
                                  onTap: () {
                                    setState(() {
                                      haveAccount = false;
                                      color = const Color(0xFFDF924B);
                                    });
                                    nextPage();
                                  },
                                  title: "Quero me cadastrar",
                                ),
                              ),
                            ],
                          ),
                        ),
                        (haveAccount ?? true)
                            ? LoginCardWidget(
                                backPage: backPage,
                                login: (email, password) async {
                                  showAdaptiveDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const LoadingPopup(),
                                  );

                                  var input = LoginInput(email, password);

                                  var result = await controller.login(input);

                                  if (!context.mounted) return;

                                  if (result) {
                                    context.navigate(
                                      StartNavigationHelper.homeRouteFor(
                                        SessionService.customer?.typeUser ??
                                            TypeUser.none,
                                      ),
                                    );
                                  } else {
                                    if (context.mounted) Navigator.pop(context);
                                    notificationError(
                                      "Falha no Login",
                                      controller.errorMessage,
                                    );
                                  }
                                },
                              )
                            : SignupCardWidget(
                                backPage: backPage,
                                signup: (input) async {
                                  showAdaptiveDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const LoadingPopup(),
                                  );

                                  var result = await controller.signup(input);
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  if (result) {
                                    context.navigate(
                                      StartNavigationHelper.homeRouteFor(
                                        SessionService.customer?.typeUser ??
                                            TypeUser.none,
                                      ),
                                    );
                                  } else {
                                    notificationError(
                                      "Falha no Cadastro",
                                      controller.errorMessage,
                                    );
                                  }
                                },
                              ),
                      ],
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
