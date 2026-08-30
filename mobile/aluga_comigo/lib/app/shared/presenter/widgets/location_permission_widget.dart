import 'package:aluga_comigo/app/shared/domain/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPermissionWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const LocationPermissionWidget({
    super.key,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 120,
                color: AppColors.primaryOrange,
              ),
              const Gap(32),
              Text(
                "Permissão de Localização Necessária",
                style: GoogleFonts.rubik(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              Text(
                "Para buscar os dados da proximidade, precisamos da sua permissão de localização. Por favor, conceda a permissão para continuar.",
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(48),
              ElevatedButton(
                onPressed: onRequestPermission,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primaryOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Conceder Permissão",
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

