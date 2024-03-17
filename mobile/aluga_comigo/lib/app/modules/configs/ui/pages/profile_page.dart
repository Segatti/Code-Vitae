import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                'Perfil',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Visualizar",
                style: GoogleFonts.rubik(
                  color: const Color(0xFF2C29A3),
                  fontSize: 16,
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
            child: Column(
              children: [
                const Gap(16),
                SizedBox(
                  height: 155,
                  child: ListView(
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    children: [
                      const Gap(16),
                      Container(
                        width: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4WP2MsbDRCViQDfYrBBElK0lOlMdPdtlvnw&usqp=CAU",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Container(
                        height: 155,
                        width: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4WP2MsbDRCViQDfYrBBElK0lOlMdPdtlvnw&usqp=CAU",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Container(
                        height: 155,
                        width: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4WP2MsbDRCViQDfYrBBElK0lOlMdPdtlvnw&usqp=CAU",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Container(
                        height: 155,
                        width: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD9D9D9),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF7C7C7C),
                            ),
                          ),
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
