import 'dart:async';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/auth/presenter/widgets/input_form.dart';
import 'package:flutter_tv/app/modules/auth/presenter/widgets/logo_presenter.dart';

import '../stores/login_store.dart';
import '../widgets/buttons/button_primary.dart';
import '../widgets/buttons/button_secundary.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginStore store;
  FocusNode focusEmail = FocusNode();
  FocusNode focusSenha = FocusNode();
  FocusNode focusEntrar = FocusNode();
  FocusNode focusCadastrar = FocusNode();
  FocusNode focusRecuperarSenha = FocusNode();

  Color corAzulClaro = const Color(0xFFD1F7FF);
  Color corLaranjaPrimaria = const Color(0xFFE1724F);

  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController senhaController = TextEditingController(text: "");

  Timer? timer;

  @override
  void initState() {
    store = Modular.get<LoginStore>();
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
                      'Conta Flutter TV',
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
                          child: InputForm(
                            obscureText: true,
                            saveValue: (String value) {
                              store.setSenha(value);
                            },
                            title: "Senha",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonPrimary(
                            title: 'Entrar',
                            onClick: () {
                              Modular.to.navigate('/main/');
                            },
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: ButtonSecundary(
                            title: 'Cadastrar',
                            onClick: () {
                              Modular.to.pushNamed('./sign');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: Observer(builder: (context) {
                            return Container(
                              alignment: Alignment.center,
                              child: DpadContainer(
                                onClick: () {
                                  if (timer?.isActive ?? false) timer?.cancel();
                                  timer = Timer(
                                      const Duration(milliseconds: 500), () {
                                    Modular.to.pushNamed('./recover');
                                  });
                                },
                                onFocus: (isFocused) {
                                  store.setFocusRecuperarSenha(isFocused);
                                },
                                child: Text(
                                  "Recuperar senha",
                                  style: TextStyle(
                                    color: store.focusRecuperarSenha
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
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
