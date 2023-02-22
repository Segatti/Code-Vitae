import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/auth/presenter/stores/login_store.dart';

import '../../../../shared/dpad/always_disabled_focus_node.dart';

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

  @override
  void initState() {
    store = Modular.get<LoginStore>();
    _init();
    super.initState();
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: Image.asset('assets/icons/logo.png'),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "A melhor plataforma de streaming para sua família.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        fontFamily: 'Montserrat',
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Observer(builder: (context) {
                      return DpadContainer(
                        onClick: () {
                          print("Clique no email");
                        },
                        onFocus: (isFocused) {
                          store.setFocusEmail(isFocused);
                        },
                        child: TextFormField(
                          focusNode: AlwaysDisabledFocusNode(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                color: (store.focusEmail)
                                    ? const Color(0xFFE1724F)
                                    : const Color(0xFFD1F7FF),
                                width: 3.0,
                              ),
                            ),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Observer(builder: (context) {
                      return DpadContainer(
                        onClick: () {},
                        onFocus: (isFocused) {
                          store.setFocusSenha(isFocused);
                        },
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          focusNode: AlwaysDisabledFocusNode(),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                color: (store.focusSenha)
                                    ? const Color(0xFFE1724F)
                                    : const Color(0xFFD1F7FF),
                                width: 3.0,
                              ),
                            ),
                            hintText: 'Senha',
                            hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Observer(builder: (context) {
                            return DpadContainer(
                              onClick: () {},
                              onFocus: (isFocused) {
                                store.setFocusEntrar(isFocused);
                              },
                              child: InkWell(
                                focusNode: focusEmail,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (store.focusEntrar)
                                          ? const Color.fromARGB(
                                              255, 175, 69, 37)
                                          : const Color(0xFFE1724F),
                                      strokeAlign: 1,
                                    ),
                                    color: const Color(0xFFE1724F),
                                  ),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: const Text(
                                      'Entrar',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Validar login
                                  if (store.userIsLogged) {
                                    Modular.to.navigate('/main/');
                                  } else {}
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Observer(builder: (context) {
                            return DpadContainer(
                              onClick: () {},
                              onFocus: (isFocused) {
                                store.setFocusCriarConta(isFocused);
                              },
                              child: InkWell(
                                focusNode: focusCadastrar,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (store.focusCriarConta)
                                          ? const Color.fromARGB(
                                              255, 175, 69, 37)
                                          : const Color(0xFFE1724F),
                                      strokeAlign: 1,
                                    ),
                                  ),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: const Text(
                                      'Criar Conta',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Validar login
                                  if (store.userIsLogged) {
                                    Modular.to.navigate('/main/');
                                  } else {}
                                },
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Observer(builder: (context) {
                      return DpadContainer(
                        onClick: () {},
                        onFocus: (isFocused) {
                          store.setFocusRecuperarSenha(isFocused);
                        },
                        child: InkWell(
                          focusNode: focusRecuperarSenha,
                          child: Text(
                            "Recuperar senha",
                            style: TextStyle(
                              color: (store.focusRecuperarSenha)
                                  ? const Color(0xFFE1724F)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
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
