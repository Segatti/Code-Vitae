class FirebaseErrorHandler {
  static String getMessage(String code) {
    var map = <String, String>{
      "invalid-credential": "Credencial inválida",
      "account-exists-with-different-credential":
          "Conta já existe",
      "invalid-email": "Email inválido",
      "user-disabled": "Usuário desabilitado",
      "user-not-found": "Usuário não encontrado",
      "wrong-password": "Senha incorreta",
      "email-already-in-use": "Email em uso",
      "operation-not-allowed": "Operação não permitida",
      "weak-password": "Senha fraca",
      "requires-recent-login": "Requerindo login recente",
      "missing-android-pkg-name": "Faltando o nome do pacote do Android",
      "missing-continue-uri": "Faltando o continue URI",
      "missing-ios-bundle-id": "Faltando o bundle ID do iOS",
      "invalid-continue-uri": "URI invalido",
      "unauthorized-continue-uri": "URI não autorizada",
    };
    return map[code] ?? "${'firebase-error-default'} - $code";
  }
}
