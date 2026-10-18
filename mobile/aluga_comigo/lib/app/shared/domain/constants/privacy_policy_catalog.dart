/// Versões publicadas da Política de Privacidade e assets correspondentes.
abstract final class PrivacyPolicyCatalog {
  static const String defaultVersion = '1.0';

  static String assetPathForVersion(String version) {
    return switch (version.trim()) {
      '1.0' => 'assets/legal/politica-de-privacidade-v1.0.md',
      _ => 'assets/legal/politica-de-privacidade-v1.0.md',
    };
  }
}
