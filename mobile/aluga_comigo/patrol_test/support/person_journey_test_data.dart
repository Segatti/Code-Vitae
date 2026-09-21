/// Dados únicos por execução para cadastro no Supabase.
class PersonJourneyTestData {
  PersonJourneyTestData({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });

  final String email;
  final String password;
  final String name;
  final String phone;

  static const shortDescription =
      'Busco imóvel tranquilo para morar com minha família.';
  static const longDescription =
      'Tenho interesse em alugar uma casa ou apartamento em Acrelândia ou '
      'região. Preciso de local seguro, com boa ventilação e espaço para '
      'convivência. Posso cuidar bem do imóvel.';
  static const chatMessage =
      'Ola! Gostaria de mais informacoes sobre o imovel, pois tenho '
      'interesse em alugar. Obrigado!';

  factory PersonJourneyTestData.unique() {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return PersonJourneyTestData(
      email: 'patrol.pessoa.$stamp@test.com',
      password: 'Teste1234',
      name: 'Patrol Pessoa Teste',
      phone: '11987654321',
    );
  }
}
