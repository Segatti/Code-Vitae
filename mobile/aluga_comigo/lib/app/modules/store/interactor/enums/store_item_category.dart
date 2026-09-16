enum StoreItemCategory {
  superStar,
  superChat,
  powerUp;

  String get title => switch (this) {
    StoreItemCategory.superStar => 'SuperStar',
    StoreItemCategory.superChat => 'SuperChat',
    StoreItemCategory.powerUp => 'PowerUp',
  };

  String get description => switch (this) {
    StoreItemCategory.superStar =>
      'Destaque especial ao dar Super Star em um perfil.',
    StoreItemCategory.superChat =>
      'Abra a conversa com mais visibilidade no chat.',
    StoreItemCategory.powerUp =>
      'Seu perfil aparece em destaque para pessoas da mesma cidade.',
  };
}
