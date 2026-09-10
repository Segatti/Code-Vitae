class SupabaseErrorHandler {
  static String getMessage(String? code, [String? message]) {
    final map = <String, String>{
      'invalid_credentials': 'Credencial inválida',
      'email_exists': 'Email em uso',
      'user_already_exists': 'Email em uso',
      'invalid_email': 'Email inválido',
      'weak_password': 'Senha fraca',
      'user_not_found': 'Usuário não encontrado',
      'over_email_send_rate_limit': 'Muitas tentativas. Tente novamente mais tarde.',
    };

    if (code != null && map.containsKey(code)) {
      return map[code]!;
    }

    return message ?? 'Erro no servidor - ${code ?? 'desconhecido'}';
  }
}
