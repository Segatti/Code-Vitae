import 'package:aluga_comigo/app/shared/interactor/constants/icons_figma.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.grey,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Loja ',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(
            height: 2,
            thickness: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFFFDC64),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white24,
                              offset: Offset(-10, -10),
                              blurRadius: 40,
                            ),
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(10, 10),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          top: 32,
                          bottom: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Bounce(
                                duration: Durations.short3,
                                onPressed: () {},
                                child: Container(
                                  width: constraints.maxWidth * .3,
                                  height: constraints.maxWidth * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Image.asset(
                                              IconsFigma.superStar1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            "R\$ 11,99",
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Durations.short3,
                                onPressed: () {},
                                child: Container(
                                  width: constraints.maxWidth * .3,
                                  height: constraints.maxWidth * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Image.asset(
                                              IconsFigma.superStar2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            "R\$ 27,99",
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Durations.short3,
                                onPressed: () {},
                                child: Container(
                                  width: constraints.maxWidth * .3,
                                  height: constraints.maxWidth * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Image.asset(
                                              IconsFigma.superStar3,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            "R\$ 49,99",
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(10),
                          ),
                          color: Color(0xFFFFC850),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "SuperStar",
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF605DDE),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white24,
                              offset: Offset(-10, -10),
                              blurRadius: 40,
                            ),
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(10, 10),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          top: 32,
                          bottom: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Bounce(
                                duration: Durations.short3,
                                onPressed: () {},
                                child: Container(
                                  width: constraints.maxWidth * .3,
                                  height: constraints.maxWidth * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Image.asset(
                                              IconsFigma.superChat1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            "R\$ 11,99",
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Durations.short3,
                                onPressed: () {},
                                child: Container(
                                  width: constraints.maxWidth * .3,
                                  height: constraints.maxWidth * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Image.asset(
                                              IconsFigma.superChat2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            "R\$ 27,99",
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Durations.short3,
                                onPressed: () {},
                                child: Container(
                                  width: constraints.maxWidth * .3,
                                  height: constraints.maxWidth * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Image.asset(
                                              IconsFigma.superChat3,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            "R\$ 49,99",
                                            style: GoogleFonts.rubik(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(10),
                          ),
                          color: Color(0xFF5350C3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white30,
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "SuperChat",
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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
          ),
        ],
      ),
    );
  }
}
