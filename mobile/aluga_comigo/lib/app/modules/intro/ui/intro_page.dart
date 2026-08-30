import 'package:aluga_comigo/app/shared/data/services/secure_storage_service.dart';
import 'package:aluga_comigo/app/shared/domain/constants/app_colors.dart';
import 'package:aluga_comigo/app/shared/domain/constants/lotties_asset.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int index = 0;
  PageController pageController = PageController();
  List<Color> cores = [
    const Color(0xFFDF924B).withValues(alpha: .8),
    const Color(0xFF2C29A3).withValues(alpha: .8),
    const Color(0xFFA7A7A7).withValues(alpha: .8),
  ];

  List<String> titles = [
    "O aluguel apertou no final do mês?",
    "Precisando de alguem para dividir o aluguel?",
    "Aqui você encontra a pessoa ideal para alugar com você!\nUma casa ou um apê",
  ];
  List<String> icons = [
    LottiesAsset.intro1,
    LottiesAsset.intro2,
    LottiesAsset.intro3,
  ];

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
        child: AnimatedCrossFade(
          duration: const Duration(seconds: 1),
          firstChild: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 64),
                    Lottie.asset(icons[index], height: 300, width: 300),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 300,
                      child: Text(
                        titles[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                          color: AppColors.primaryOrange,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index++;
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue.withValues(alpha: .5),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          secondChild: AnimatedCrossFade(
            duration: const Duration(seconds: 1),
            firstChild: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      Lottie.asset(icons[index], height: 300, width: 300),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 300,
                        child: Text(
                          titles[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                            color: AppColors.primaryOrange,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              index++;
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue.withValues(
                                alpha: .5,
                              ),
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            secondChild: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Lottie.asset(icons[index], fit: BoxFit.fill),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 300,
                        child: Text(
                          titles[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                            color: AppColors.primaryOrange,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () async {
                            final storage = Modular.get<SecureStorageService>();
                            await storage.setData(
                              StorageKey.intro,
                              false.toString(),
                            );
                            Modular.to.navigate("/auth/");
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue.withValues(
                                alpha: .5,
                              ),
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: index == 1
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
          crossFadeState: index == 0
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
      ),
    );
  }
}
