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
      'Créditos para Super Star: destaque máximo ao reagir a um inquilino ou '
      'imóvel. O outro usuário recebe notificação e sua reação fica registrada '
      'como favorito especial no histórico.',
    StoreItemCategory.superChat =>
      'Créditos para Super Chat: envie a primeira mensagem destacada em um '
      'match ou abra conversa com imóvel com mais visibilidade. A mensagem '
      'aparece em destaque no chat e gera notificação para quem recebe.',
    StoreItemCategory.powerUp =>
      'Seu perfil ou anúncio ganha prioridade no feed da mesma cidade. Enquanto '
      'ativo, você pode alterar opiniões no histórico. Pacotes de 7 e 30 dias '
      'incluem créditos bônus de Super Star e Super Chat.',
  };
}
