import 'package:aluga_comigo/app/modules/auth/domain/enums/type_immobile.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HouseFlipCard extends StatelessWidget {
  final ImmobileCustomerModel immobile;
  final double? height;
  final VoidCallback? onBackPressed;
  final Future<bool> Function(FlipCardController)? onVerMaisPressed;
  final VoidCallback? onVerNoMapaPressed;

  const HouseFlipCard({
    super.key,
    required this.immobile,
    this.height,
    this.onBackPressed,
    this.onVerMaisPressed,
    this.onVerNoMapaPressed,
  });

  String _getTypeImmobileTitle(TypeImmobile type) {
    switch (type) {
      case TypeImmobile.house:
        return "Casa";
      case TypeImmobile.apartment:
        return "Apartamento";
      case TypeImmobile.none:
        return "";
    }
  }

  String _formatScore(double score) {
    if (score == 0) return "0/5";
    return "${score.toStringAsFixed(1)}/5";
  }

  @override
  Widget build(BuildContext context) {
    final flipController = FlipCardController();
    final cardHeight = height ?? MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: cardHeight,
      child: FlipCard(
        controller: flipController,
        flipOnTouch: false,
        front: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  height: cardHeight - 170,
                  imageUrl: immobile.photos.firstOrNull ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Icon(
                        Icons.home,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (immobile.score > 0)
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                Text(_formatScore(immobile.score)),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ),
                        if (immobile.cityState.isNotEmpty)
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(immobile.cityState),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (immobile.typeImmobile != TypeImmobile.none)
                              Text(
                                _getTypeImmobileTitle(immobile.typeImmobile),
                                style: GoogleFonts.rubik(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                ),
                              ),
                            const Gap(12),
                            if (immobile.price > 0)
                              Text(
                                immobile.price.toMoney(),
                                style: GoogleFonts.rubik(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.blueAccent,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: onVerNoMapaPressed ?? () {
                                // Abrir link do google maps
                              },
                              child: Text(
                                "Ver no mapa",
                                style: GoogleFonts.rubik(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(4),
                        if (immobile.shortDescription.isNotEmpty)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  immobile.shortDescription,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (immobile.bathrooms > 0) ...[
                                      SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.amber,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.bathroom),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${immobile.bathrooms}",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(8),
                                    ],
                                    if (immobile.bedrooms > 0) ...[
                                      SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.bed,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${immobile.bedrooms}",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(8),
                                    ],
                                    if (immobile.carSpaces > 0) ...[
                                      SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.local_parking,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${immobile.carSpaces}",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(8),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0XFFDF924B),
                                fixedSize: const Size(110, 40),
                                foregroundColor: Colors.amber,
                              ),
                              onPressed: () async {
                                if (onVerMaisPressed != null) {
                                  final result =
                                      await onVerMaisPressed!(flipController);
                                  if (result) {
                                    flipController.toggleCard();
                                  }
                                } else {
                                  flipController.toggleCard();
                                }
                              },
                              child: Text(
                                "Ver mais",
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        back: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descrição completa",
                  style: GoogleFonts.rubik(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Gap(4),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(8),
                          Text(
                            immobile.longDescription.isNotEmpty
                                ? immobile.longDescription
                                : "Sem descrição completa",
                            maxLines: null,
                            style: GoogleFonts.rubik(),
                          ),
                          const Gap(8),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    const Gap(4),
                    const Text("Valor do aluguel"),
                    const Gap(8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        immobile.price.toMoney(),
                        style: GoogleFonts.rubik(),
                      ),
                    )
                  ],
                ),
                const Gap(8),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Gap(8),
                    Text("Interior da Casa"),
                    Gap(8),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (immobile.bathrooms > 0) ...[
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.bathroom),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${immobile.bathrooms}",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 11,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.bedrooms > 0) ...[
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.bed),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${immobile.bedrooms}",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 11,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.carSpaces > 0) ...[
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.local_parking),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${immobile.carSpaces}",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 11,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                      ],
                    ],
                  ),
                ),
                const Gap(8),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Gap(8),
                    Text("Locais próximos"),
                    Gap(8),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (immobile.isHospitalNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Hospital"),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.isMarketNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Mercado"),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.isSchoolNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Faculdade"),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.isParkNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Parque"),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.isGymNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Academia"),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.isMallNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Shopping"),
                        ),
                        const Gap(8),
                      ],
                      if (immobile.isBeachNear) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Praia"),
                        ),
                        const Gap(8),
                      ],
                    ],
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 3,
                            color: Colors.orange,
                          ),
                        ),
                        onPressed: onBackPressed ?? () {
                          flipController.toggleCard();
                        },
                        child: Text(
                          "Voltar",
                          style: GoogleFonts.rubik(
                            color: Colors.grey,
                            fontSize: 16,
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
        ),
      ),
    );
  }
}

