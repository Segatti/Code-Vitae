enum StoreItemCategory {
  superStar,
  superChat,
  powerUp;

  String get title => switch (this) {
    StoreItemCategory.superStar => 'Super Star',
    StoreItemCategory.superChat => 'Super Chat',
    StoreItemCategory.powerUp => 'PowerUp',
  };

  String get tagline => switch (this) {
    StoreItemCategory.superStar =>
      'Seja lembrado: reação especial com notificação',
    StoreItemCategory.superChat =>
      'Abra conversas com a primeira mensagem em destaque',
    StoreItemCategory.powerUp =>
      'Prioridade no feed da sua cidade por tempo limitado',
  };

  List<String> get benefits => switch (this) {
    StoreItemCategory.superStar => [
      'Notificação para quem recebe',
      'Favorito especial no histórico',
      'Destaque máximo na reação',
    ],
    StoreItemCategory.superChat => [
      'Primeira mensagem em evidência',
      'Mais chance de resposta no match',
      'Notificação para quem recebe',
    ],
    StoreItemCategory.powerUp => [
      'Seu perfil ou anúncio no topo do feed local',
      'Altere opiniões no histórico enquanto ativo',
      'Pacotes longos incluem créditos bônus',
    ],
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
