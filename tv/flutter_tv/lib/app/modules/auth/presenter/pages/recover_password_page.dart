import 'dart:async';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/auth/presenter/widgets/buttons/button_secundary.dart';

import '../stores/recover_password_store.dart';
import '../widgets/buttons/button_primary.dart';
import '../widgets/input_form.dart';
import '../widgets/logo_presenter.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late RecoverPasswordStore store;
  FocusNode focusEmail = FocusNode();
  FocusNode focusEnviar = FocusNode();
  FocusNode focusVoltar = FocusNode();

  Color corAzulClaro = const Color(0xFFD1F7FF);
  Color corLaranjaPrimaria = const Color(0xFFE1724F);

  TextEditingController emailController = TextEditingController(text: "");

  Timer? timer;

  @override
  void initState() {
    store = Modular.get<RecoverPasswordStore>();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _init() async {
    await store.startStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 96, vertical: 80),
        color: const Color(0xFF01012B),
        child: Row(
          children: [
            const Expanded(child: LogoPresenter()),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1F7FF), width: 5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Recuperar senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: InputForm(
                            saveValue: (String value) {
                              store.setEmail(value);
                            },
                            title: "Email",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonPrimary(
                            title: 'Enviar',
                            onClick: () {
                              Modular.to.pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: ButtonSecundary(
                            title: "Voltar",
                            onClick: () {
                              Modular.to.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
