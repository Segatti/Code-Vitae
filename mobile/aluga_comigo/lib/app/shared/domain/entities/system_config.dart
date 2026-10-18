class SystemConfig {
  final bool appActive;
  final bool storeActive;
  final bool storePowerUpActive;
  final bool storeSuperStarActive;
  final bool storeSuperChatActive;
  final String termsOfUseCurrentVersion;

  const SystemConfig({
    required this.appActive,
    required this.storeActive,
    required this.storePowerUpActive,
    required this.storeSuperStarActive,
    required this.storeSuperChatActive,
    required this.termsOfUseCurrentVersion,
  });

  factory SystemConfig.defaults() {
    return const SystemConfig(
      appActive: true,
      storeActive: true,
      storePowerUpActive: true,
      storeSuperStarActive: true,
      storeSuperChatActive: true,
      termsOfUseCurrentVersion: '1.0',
    );
  }
}
