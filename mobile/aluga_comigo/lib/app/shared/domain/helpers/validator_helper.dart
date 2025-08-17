import 'package:cpf_cnpj_validator/cnpj_validator.dart';

class ValidatorHelper {
  static String? required(String? value) {
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    return null;
  }

  static String? fullname(String? value) {
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    if (!data.contains(' ')) {
      return 'Insira o nome completo';
    }

    return null;
  }

  static String? email(String? value, bool required) {
    final String data = value?.trim() ?? '';
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
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return required ? 'Campo obrigatório' : null;

    if (data.length < 7) {
      return 'A senha deve ter pelo menos 7 caracteres';
    }

    final RegExp regexEspecial = RegExp(r'[!@#$%^&*(),.?":{}|<>~`/\\]');
    if (!regexEspecial.hasMatch(data)) {
      return 'A senha deve conter pelo menos um caractere especial. Ex: !@#\$%^&*(),.?":{}|<>~`/\\\'';
    }

    final RegExp regexNumero = RegExp(r'\d');
    if (!regexNumero.hasMatch(data)) {
      return 'A senha deve conter pelo menos um número.';
    }

    final RegExp regexLetra = RegExp(r'[a-zA-Z]');
    if (!regexLetra.hasMatch(data)) {
      return 'A senha deve conter pelo menos uma letra.';
    }

    return null;
  }

  static String? phoneComercial(String? value, {bool required = true}) {
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return (required) ? 'Campo obrigatório' : null;

    final RegExp phoneRegex = RegExp(r'^\(\d{2}\) \d{4}-\d{4}$');

    if (!phoneRegex.hasMatch(data)) {
      return 'Numero comercial inválido';
    }

    return null;
  }

  static String? phone(String? value, bool useCodeCountry) {
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp phoneRegex = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    final RegExp phone2Regex = RegExp(r'^\(\d{2}\) \d{4}-\d{4}$');
    final RegExp phoneCountryRegex = RegExp(r'^\+\d{2} \(\d{2}\) \d{5}-\d{4}$');

    if ((!phone2Regex.hasMatch(data) &&
            !phoneRegex.hasMatch(data) &&
            !useCodeCountry) ||
        (useCodeCountry && !phoneCountryRegex.hasMatch(data))) {
      return 'Numero de telefone inválido';
    }

    return null;
  }

  static String? cnpj(String? value) {
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp cnpjRegex = RegExp(r'^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$');

    if (!cnpjRegex.hasMatch(data) || !CNPJValidator.isValid(data)) {
      return 'CNPJ inválido';
    }

    return null;
  }

  static String? time(String? value,
      {bool required = false, bool useFulltime = false}) {
    final String data = value?.trim() ?? '';
    if (!required) return null;
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp timeRegex = RegExp(r'^\d{2}\:\d{2}$');
    final RegExp timeFullRegex = RegExp(r'^\d{2}\:\d{2}\:\d{2}$');

    if (useFulltime) {
      if (timeFullRegex.hasMatch(data)) {
        final List<String> sTime = data.split(':');
        final int hours = int.tryParse(sTime[0]) ?? 0;
        final int minutes = int.tryParse(sTime[1]) ?? 0;
        final int seconds = int.tryParse(sTime[2]) ?? 0;

        if (hours < 0 || hours > 23) return 'Hora inválida';
        if (minutes < 0 || minutes > 59) return 'Minuto inválido';
        if (seconds < 0 || seconds > 59) return 'Segundo inválido';
        return null;
      } else {
        return 'Tempo inválido';
      }
    } else {
      if (timeRegex.hasMatch(data)) {
        final List<String> sTime = data.split(':');
        final int hours = int.tryParse(sTime[0]) ?? 0;
        final int minutes = int.tryParse(sTime[1]) ?? 0;

        if (hours < 0 || hours > 23) return 'Hora inválida';
        if (minutes < 0 || minutes > 59) return 'Minuto inválido';
        return null;
      } else {
        return 'Tempo inválido';
      }
    }
  }

  static String? date(String? value, bool required) {
    final String data = value?.trim() ?? '';
    if (!required) return null;
    if (data.isEmpty) return 'Campo obrigatório';

    final RegExp dateRegex = RegExp(r'^\d{2}\/\d{2}\/\d{2}$');
    final RegExp dateFullRegex = RegExp(r'^\d{2}\/\d{2}\/\d{4}$');

    if (dateFullRegex.hasMatch(data)) {
      final List<String> sDate = data.split('/');
      final int day = int.tryParse(sDate[0]) ?? 0;
      final int month = int.tryParse(sDate[1]) ?? 0;
      final int year = int.tryParse(sDate[2]) ?? 0;

      if (day <= 0 || day > 31) return 'Dia inválido';
      if (month <= 0 || month > 12) return 'Mês inválido';
      if (year <= 0 || year.toString().length < 4) return 'Ano inválido';
      return null;
    }

    if (dateRegex.hasMatch(data)) {
      return 'Coloque o ano completo';
    }

    return 'Data inválida';
  }

  static String? cpf(String? value) {
    final String data = value?.trim() ?? '';

    // Verifica se o campo está vazio
    if (data.isEmpty) return 'Campo obrigatório';

    // Expressão regular para o formato do CPF
    final RegExp cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');

    if (!cpfRegex.hasMatch(data)) {
      return 'CPF inválido';
    }

    // Remove caracteres não numéricos para validar o CPF
    final String cpf = data.replaceAll(RegExp(r'[^0-9]'), '');

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

  static String? nfe(String? value) {
    // Exemplo: 35250712345678000195551237613832061471354920

    final String data = value?.trim() ?? '';

    if (data.isEmpty) return 'Campo obrigatório';

    final String nfe = data.replaceAll(RegExp(r'[^0-9]'), '');

    if (nfe.length != 44) {
      return 'NFe deve ter 44 dígitos';
    }

    if (RegExp(r'^(\d)\1{43}$').hasMatch(nfe)) {
      return 'NFe inválida';
    }

    if (!_validarDigitoVerificadorNFe(nfe)) {
      return 'NFe inválida';
    }

    return null; // NFe válida
  }

  static bool _validarDigitoVerificadorNFe(String nfe) {
    final String chaveSemDV = nfe.substring(0, 43);
    final int dvInformado = int.parse(nfe[43]);

    int soma = 0;
    int peso = 2;

    for (int i = chaveSemDV.length - 1; i >= 0; i--) {
      soma += int.parse(chaveSemDV[i]) * peso;
      peso = (peso == 9) ? 2 : peso + 1;
    }

    int resto = soma % 11;
    int dvCalculado = (resto == 0 || resto == 1) ? 0 : 11 - resto;

    return dvCalculado == dvInformado;
  }

  static String? cep(String? value, {bool required = true}) {
    final String data = value?.trim() ?? '';
    if (data.isEmpty) return (required) ? 'Campo obrigatório' : null;

    // Remove caracteres não numéricos
    final String cep = data.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se tem 8 dígitos
    if (cep.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }

    // Verifica se todos os dígitos são iguais (CEP inválido)
    if (RegExp(r'^(\d)\1*$').hasMatch(cep)) {
      return 'CEP inválido';
    }

    // Validação básica de CEPs válidos no Brasil
    // CEPs começando com 00000, 11111, 22222, etc. são inválidos
    // final String primeiroDigito = cep[0];
    if (RegExp(r'^(\d)\1{7}$').hasMatch(cep)) {
      return 'CEP inválido';
    }

    return null; // CEP é válido
  }
}
