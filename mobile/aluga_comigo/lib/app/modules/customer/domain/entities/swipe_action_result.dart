import 'mutual_match.dart';

class SwipeActionResult {
  const SwipeActionResult({
    required this.removed,
    this.mutualMatch,
  });

  final bool removed;
  final MutualMatch? mutualMatch;
}
