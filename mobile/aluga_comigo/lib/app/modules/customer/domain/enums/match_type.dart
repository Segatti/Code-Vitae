enum MatchType {
  none,
  like,
  favorite,
  unlike;

  const MatchType();

  static MatchType get(String name) {
    return MatchType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => MatchType.none,
    );
  }
}
