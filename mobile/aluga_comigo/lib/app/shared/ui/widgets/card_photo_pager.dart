import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

/// Carrossel horizontal de fotos para cards (swipe entre URLs).
class CardPhotoPager extends StatefulWidget {
  const CardPhotoPager({
    super.key,
    required this.photoUrls,
    required this.placeholder,
    this.borderRadius,
  });

  final List<String> photoUrls;
  final Widget placeholder;
  final BorderRadius? borderRadius;

  @override
  State<CardPhotoPager> createState() => _CardPhotoPagerState();
}

class _CardPhotoPagerState extends State<CardPhotoPager> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(CardPhotoPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrls != widget.photoUrls &&
        _pageIndex >= widget.photoUrls.length) {
      _pageIndex = 0;
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _photoIndicators(int count) {
    if (count <= 0) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == _pageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 8 : 6,
          height: active ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.photoUrls.where((u) => u.isNotEmpty).toList();
    final radius = widget.borderRadius ?? BorderRadius.zero;

    if (urls.isEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: ColoredBox(
          color: Colors.grey.shade200,
          child: Center(child: widget.placeholder),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (urls.length == 1)
            CachedNetworkImage(
              imageUrl: urls.first,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorWidget: (_, _, _) => Center(child: widget.placeholder),
            )
          else
            PageView.builder(
              controller: _pageController,
              itemCount: urls.length,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: urls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: (_, _, _) => Center(child: widget.placeholder),
                );
              },
            ),
          Positioned(
            left: 0,
            right: 0,
            top: 12,
            child: _photoIndicators(urls.length),
          ),
        ],
      ),
    );
  }
}
