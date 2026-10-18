import '../../../../shared/domain/helpers/validator_helper.dart';

/// Regras do passo «Dados de acesso» no cadastro (pessoa ou imóvel).
abstract final class SignupAccessValidation {
  static String? emailError(String? raw) {
    final error = ValidatorHelper.email(raw, true);
    if (error == null) return null;
    if (error.contains('obrigat')) return 'Informe seu e-mail.';
    return 'Informe um e-mail válido.';
  }

  static String? passwordError(String? raw) {
    final data = raw?.trim() ?? '';
    if (data.isEmpty) return 'Informe uma senha.';
    if (data.length <= 6) {
      return 'A senha deve ter mais de 6 caracteres.';
    }
    return null;
  }

  static String? combinedMessage({
    required String email,
    required String password,
  }) {
    final errors = <String>[
      ?emailError(email),
      ?passwordError(password),
    ];
    if (errors.isEmpty) return null;
    return errors.join('\n');
  }
}
