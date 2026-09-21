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

  /// `--dart-define=PATROL_PERSON_EMAIL=...` e `PATROL_PERSON_PASSWORD=...`
  static bool get hasPatrolLoginDefines {
    const email = String.fromEnvironment('PATROL_PERSON_EMAIL');
    return email.isNotEmpty;
  }

  factory PersonJourneyTestData.fromPatrolDefines() {
    const email = String.fromEnvironment('PATROL_PERSON_EMAIL');
    const password = String.fromEnvironment(
      'PATROL_PERSON_PASSWORD',
      defaultValue: 'Teste1234',
    );
    if (email.isEmpty) {
      throw StateError(
        'Defina PATROL_PERSON_EMAIL (e opcionalmente PATROL_PERSON_PASSWORD) '
        'no --dart-define-from-file ou deixe vazio para cadastrar conta no teste.',
      );
    }
    return PersonJourneyTestData(
      email: email,
      password: password,
      name: 'Patrol Pessoa Login',
      phone: '11987654321',
    );
  }
}
