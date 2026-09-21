/// Dados únicos por execução para cadastro de conta de imóvel no Supabase.
class ImmobileJourneyTestData {
  ImmobileJourneyTestData({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });

  final String email;
  final String password;
  final String name;
  final String phone;

  /// CEP válido (9 caracteres com hífen) para Acrelândia — AC.
  static const cep = '69945-000';

  /// Valor mensal do aluguel (MoneyFormatter aceita dígitos).
  static const rentValue = '150000';

  factory ImmobileJourneyTestData.unique() {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return ImmobileJourneyTestData(
      email: 'patrol.imovel.$stamp@test.com',
      password: 'Teste1234',
      name: 'Patrol Imóvel Teste',
      phone: '11987654321',
    );
  }
}
