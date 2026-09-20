class DesignScreenConfig {
  static const _widthRaw = String.fromEnvironment(
    'DESIGN_SCREEN_WIDTH',
    defaultValue: '390',
  );

  static const _heightRaw = String.fromEnvironment(
    'DESIGN_SCREEN_HEIGHT',
    defaultValue: '844',
  );

  static double get referenceWidth => double.tryParse(_widthRaw) ?? 390;

  static double get referenceHeight => double.tryParse(_heightRaw) ?? 844;
}
