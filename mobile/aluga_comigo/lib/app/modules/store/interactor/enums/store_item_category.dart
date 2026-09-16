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
      'Seu perfil aparece em destaque na mesma cidade. Com PowerUp ativo, '
      'você pode mudar sua opinião no histórico. Pacote de 7 dias: +1 Super '
      'Star e +1 Super Chat. Pacote de 30 dias: +4 de cada.',
  };
}
