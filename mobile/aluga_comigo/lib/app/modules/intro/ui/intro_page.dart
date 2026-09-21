import 'package:aluga_comigo/app/shared/data/services/secure_storage_service.dart';
import 'package:aluga_comigo/app/shared/domain/constants/app_colors.dart';
import 'package:aluga_comigo/app/shared/domain/constants/lotties_asset.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int index = 0;

  static const _titles = [
    'O aluguel apertou no final do mês?',
    'Precisando de alguem para dividir o aluguel?',
    'Aqui você encontra a pessoa ideal para alugar com você!\nUma casa ou um apê',
  ];

  static const _icons = [
    LottiesAsset.intro1,
    LottiesAsset.intro2,
    LottiesAsset.intro3,
  ];

  bool get _isLast => index >= _titles.length - 1;

  @override
  void initState() {
    super.initState();
    for (final path in _icons) {
      AssetLottie(path).load();
    }
  }

  void _nextIntro() {
    if (_isLast) return;
    setState(() => index++);
  }

  Future<void> _finishIntro() async {
    final storage = inject<SecureStorageService>();
    await storage.setData(StorageKey.intro, false.toString());
    if (!mounted) return;
    context.navigate('/auth/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: Column(
          spacing: 32.h(),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300.h(),
              width: 300.w(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Lottie.asset(
                  _icons[index],
                  key: ValueKey<String>(_icons[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 300.w(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  _titles[index],
                  key: ValueKey<int>(index),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    color: AppColors.primaryOrange,
                    fontSize: index == 2 ? 24.sp() : 32.sp(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              key: const ValueKey('intro_next_button'),
              onTap: _isLast ? _finishIntro : _nextIntro,
              child: Container(
                width: 80.w(),
                height: 80.h(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withValues(alpha: .5),
                ),
                child: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
