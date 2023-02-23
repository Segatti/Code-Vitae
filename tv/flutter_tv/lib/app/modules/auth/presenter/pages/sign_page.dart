import 'dart:async';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../stores/sign_store.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  late SignStore store;
  FocusNode focusEmail = FocusNode();
  FocusNode focusSenha = FocusNode();
  FocusNode focusConfirmarSenha = FocusNode();
  FocusNode focusCadastrar = FocusNode();
  FocusNode focusVoltar = FocusNode();

  Color corAzulClaro = const Color(0xFFD1F7FF);
  Color corLaranjaPrimaria = const Color(0xFFE1724F);

  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController senhaController = TextEditingController(text: "");
  TextEditingController confirmarSenhaController =
      TextEditingController(text: "");

  Timer? timer;

  @override
  void initState() {
    store = Modular.get<SignStore>();
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

  String generateTextSenha(int lenghtSenha) {
    String senhaOculta = "";
    for (int i = 0; i < lenghtSenha; i++) {
      senhaOculta += "*";
    }
    return senhaOculta;
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
                      'Criar Conta',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: Observer(builder: (context) {
                            return Container(
                              height: 44,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: store.focusEmail
                                      ? corLaranjaPrimaria
                                      : corAzulClaro,
                                  width: 3,
                                ),
                              ),
                              child: DpadContainer(
                                onClick: () {
                                  if (timer?.isActive ?? false) timer?.cancel();
                                  timer = Timer(
                                      const Duration(milliseconds: 500), () {
                                    store.setClickEmail(true);
                                    focusEmail.requestFocus();
                                  });
                                },
                                onFocus: (isFocused) {
                                  store.setFocusEmail(isFocused);
                                },
                                child: store.clickEmail
                                    ? TextField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: emailController,
                                        focusNode: focusEmail,
                                        onEditingComplete: () {
                                          store.setClickEmail(false);
                                          store.setEmail(emailController.text);
                                        },
                                      )
                                    : Text(
                                        store.email.isEmpty
                                            ? "Email"
                                            : store.email,
                                        style: TextStyle(
                                          color: store.focusEmail
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Observer(builder: (context) {
                            return Container(
                              height: 44,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: store.focusSenha
                                      ? corLaranjaPrimaria
                                      : corAzulClaro,
                                  width: 3,
                                ),
                              ),
                              child: DpadContainer(
                                onClick: () {
                                  if (timer?.isActive ?? false) timer?.cancel();
                                  timer = Timer(
                                      const Duration(milliseconds: 500), () {
                                    store.setClickSenha(true);
                                    focusSenha.requestFocus();
                                  });
                                },
                                onFocus: (isFocused) {
                                  store.setFocusSenha(isFocused);
                                },
                                child: store.clickSenha
                                    ? TextField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: senhaController,
                                        focusNode: focusSenha,
                                        onEditingComplete: () {
                                          store.setClickSenha(false);
                                          store.setSenha(senhaController.text);
                                        },
                                        obscureText: true,
                                      )
                                    : Text(
                                        store.senha.isEmpty
                                            ? "Senha"
                                            : generateTextSenha(
                                                store.senha.length,
                                              ),
                                        style: TextStyle(
                                          color: store.focusSenha
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Observer(builder: (context) {
                            return Container(
                              height: 44,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: store.focusConfirmarSenha
                                      ? corLaranjaPrimaria
                                      : corAzulClaro,
                                  width: 3,
                                ),
                              ),
                              child: DpadContainer(
                                onClick: () {
                                  if (timer?.isActive ?? false) timer?.cancel();
                                  timer = Timer(
                                      const Duration(milliseconds: 500), () {
                                    store.setClickConfirmarSenha(true);
                                    focusConfirmarSenha.requestFocus();
                                  });
                                },
                                onFocus: (isFocused) {
                                  store.setFocusConfirmarSenha(isFocused);
                                },
                                child: store.clickConfirmarSenha
                                    ? TextField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: confirmarSenhaController,
                                        focusNode: focusConfirmarSenha,
                                        onEditingComplete: () {
                                          store.setClickConfirmarSenha(false);
                                          store.setConfirmarSenha(
                                              confirmarSenhaController.text);
                                        },
                                        obscureText: true,
                                      )
                                    : Text(
                                        store.confirmarSenha.isEmpty
                                            ? "Confirmar senha"
                                            : generateTextSenha(
                                                store.confirmarSenha.length,
                                              ),
                                        style: TextStyle(
                                          color: store.focusConfirmarSenha
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Observer(builder: (context) {
                            return DpadContainer(
                              onClick: () {
                                if (timer?.isActive ?? false) timer?.cancel();
                                timer = Timer(const Duration(milliseconds: 500),
                                    () {
                                  print('cadastrar');
                                });
                              },
                              onFocus: (isFocused) {
                                store.setFocusEntrar(isFocused);
                              },
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      corLaranjaPrimaria),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                        width: 3,
                                        color: corLaranjaPrimaria,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                    color: store.focusEntrar
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Observer(builder: (context) {
                            return DpadContainer(
                              onClick: () {
                                if (timer?.isActive ?? false) timer?.cancel();
                                timer = Timer(const Duration(milliseconds: 500),
                                    () {
                                  Modular.to.pop();
                                });
                              },
                              onFocus: (isFocused) {
                                store.setFocusCriarConta(isFocused);
                              },
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                        width: 3,
                                        color: corLaranjaPrimaria,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Voltar",
                                  style: TextStyle(
                                    color: store.focusCriarConta
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
