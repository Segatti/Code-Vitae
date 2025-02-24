class ValidatorHelper {
  static String? required(String? value) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    return null;
  }

  static String? fullname(String? value) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    if (!data.contains(" ")) {
      return 'Insira o nome completo';
    }

    return null;
  }

  static String? email(String? value, bool required) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return (required) ? 'Campo obrigatório' : null;

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(data)) {
      return 'Email invalido';
    }

    return null;
  }

  static String? password(String? value, bool required) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return (required) ? 'Campo obrigatório' : null;

    if (data.length < 7) {
      return 'A senha deve mais de 6 caracteres';
    }

    final regexEspecial = RegExp(r'[!@#$%^&*(),.?":{}|<>~`/\\]');
    if (!regexEspecial.hasMatch(data)) {
      return "Adicione caractere especial. Ex: !@#\$%^&*(),.?\":{}|<>~`/\\";
    }

    return null;
  }

  static String? phoneComercial(String? value, {bool required = true}) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return (required) ? 'Campo obrigatório' : null;

    final RegExp phoneRegex = RegExp(r'^\(\d{2}\) \d{4}-\d{4}$');

    if (!phoneRegex.hasMatch(data)) {
      return 'Numero comercial inválido';
    }

    return null;
  }

  static String? phone(String? value, bool useCodeCountry) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp phoneRegex = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    final RegExp phone2Regex = RegExp(r'^\(\d{2}\) \d{4}-\d{4}$');
    final RegExp phoneCountryRegex = RegExp(r'^\+\d{2} \(\d{2}\) \d{5}-\d{4}$');

    if ((!phone2Regex.hasMatch(data) && !phoneRegex.hasMatch(data)) ||
        (useCodeCountry && !phoneCountryRegex.hasMatch(data))) {
      return 'Numero de telefone inválido';
    }

    return null;
  }

  static String? cnpj(String? value) {
    var data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp cnpjRegex = RegExp(r'^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$');

    if (!cnpjRegex.hasMatch(data)) {
      return 'CNPJ inválido';
    }

    return null;
  }

  static String? date(String? value, bool required) {
    var data = value?.trim() ?? '';
    if (!required) return null;
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp dateRegex = RegExp(r'^\d{2}\/\d{2}\/\d{2}$');
    final RegExp dateFullRegex = RegExp(r'^\d{2}\/\d{2}\/\d{4}$');

    if (dateFullRegex.hasMatch(data)) {
      var sDate = data.split("/");
      var day = int.tryParse(sDate[0]) ?? 0;
      var month = int.tryParse(sDate[1]) ?? 0;
      var year = int.tryParse(sDate[2]) ?? 0;

      if (day <= 0 || day > 31) return "Dia inválido";
      if (month <= 0 || month > 12) return "Mês inválido";
      if (year <= 0 || year.toString().length < 4) return "Ano inválido";
      return null;
    }

    if (dateRegex.hasMatch(data)) {
      return "Coloque o ano completo";
    }

    return "Data inválida";
  }

  static String? cpf(String? value) {
    var data = value?.trim() ?? '';

    // Verifica se o campo está vazio
    if (data.isEmpty) return 'Campo obrigatório';

    // Expressão regular para o formato do CPF
    final RegExp cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');

    if (!cpfRegex.hasMatch(data)) {
      return 'CPF inválido';
    }

    // Remove caracteres não numéricos para validar o CPF
    String cpf = data.replaceAll(RegExp(r'[^0-9]'), '');

    // Validação do número de dígitos
    if (cpf.length != 11) {
      return 'CPF inválido';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Cálculo do primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int primeiroDigito = (soma * 10) % 11;
    if (primeiroDigito == 10) primeiroDigito = 0;

    if (primeiroDigito != int.parse(cpf[9])) {
      return 'CPF inválido';
    }

    // Cálculo do segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int segundoDigito = (soma * 10) % 11;
    if (segundoDigito == 10) segundoDigito = 0;

    if (segundoDigito != int.parse(cpf[10])) {
      return 'CPF inválido';
    }

    return null; // CPF é válido
  }
}
