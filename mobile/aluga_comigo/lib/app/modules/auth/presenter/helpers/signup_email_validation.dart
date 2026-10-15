import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/check_signup_email_available.dart';

/// Retorna `true` se o e-mail está livre para cadastro.
Future<bool> validateSignupEmailAvailable({
  required String email,
  required String password,
  required void Function(String title, String message) onError,
}) async {
  final check = inject<ICheckSignupEmailAvailable>();
  final result = await check(email.trim(), password);

  return result.fold(
    (failure) {
      onError('Erro', failure.message);
      return false;
    },
    (isAvailable) {
      if (!isAvailable) {
        onError(
          'Atenção',
          'Já existe uma conta com esse email',
        );
        return false;
      }
      return true;
    },
  );
}
