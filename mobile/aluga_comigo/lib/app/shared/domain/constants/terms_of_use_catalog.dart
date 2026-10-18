/// Versões publicadas dos Termos de Uso e assets correspondentes.
abstract final class TermsOfUseCatalog {
  static const String defaultVersion = '1.0';

  static String assetPathForVersion(String version) {
    return switch (version.trim()) {
      '1.0' => 'assets/legal/termos-de-uso-v1.0.md',
      _ => 'assets/legal/termos-de-uso-v1.0.md',
    };
  }
}
