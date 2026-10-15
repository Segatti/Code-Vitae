import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import 'primary_button.dart';

enum FeedEmptyKind {
  people,
  houses,
}

/// Estado exibido quando o feed de swipe não tem mais itens.
class FeedEmptyState extends StatelessWidget {
  const FeedEmptyState({
    super.key,
    required this.kind,
    this.onRefresh,
    this.isRefreshing = false,
  });

  final FeedEmptyKind kind;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  String get _title => switch (kind) {
    FeedEmptyKind.people => 'Você viu todo mundo por aqui',
    FeedEmptyKind.houses => 'Você viu todos os imóveis por aqui',
  };

  String get _subtitle => switch (kind) {
    FeedEmptyKind.people =>
      'Não há mais perfis na sua região agora. '
      'Novas pessoas entram o tempo todo — volte mais tarde '
      'ou toque em buscar novamente.',
    FeedEmptyKind.houses =>
      'Não há mais anúncios disponíveis agora. '
      'Novos imóveis são publicados com frequência — volte mais tarde '
      'ou toque em buscar novamente.',
  };

  IconData get _icon => switch (kind) {
    FeedEmptyKind.people => Icons.groups_outlined,
    FeedEmptyKind.houses => Icons.home_work_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                offset: Offset(-8, -8),
                blurRadius: 24,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(8, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFDF924B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  size: 40,
                  color: const Color(0xFFDF924B),
                ),
              ),
              const Gap(20),
              Text(
                _title,
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const Gap(12),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  height: 1.45,
                ),
              ),
              if (onRefresh != null) ...[
                const Gap(24),
                PrimaryButtonWidget(
                  title: 'Buscar novamente',
                  isLoading: isRefreshing,
                  onTap: onRefresh!,
                  borderRadius: 12,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
