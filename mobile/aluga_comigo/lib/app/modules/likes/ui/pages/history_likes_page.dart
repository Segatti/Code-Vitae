import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/ui/widgets/tabs.dart';

class HistoryLikesPage extends StatefulWidget {
  const HistoryLikesPage({super.key});

  @override
  State<HistoryLikesPage> createState() => _HistoryLikesPageState();
}

class _HistoryLikesPageState extends State<HistoryLikesPage> {
  int tabSelected = 0;

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
                'Historico ',
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(16),
                    TabsWidget(
                      values: const ["Pessoas", "Imóveis"],
                      valueSelected: tabSelected,
                      onChange: (value) => setState(() {
                        tabSelected = value;
                      }),
                    ),
                    const Gap(16),
                    LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: constraints.maxWidth * .1 / 2,
                          runSpacing: 16,
                          children: [
                            for (int i = 0; i < 10; i++)
                              Container(
                                width: constraints.maxWidth * .3,
                                height: constraints.maxWidth * .45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const Gap(16),
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
