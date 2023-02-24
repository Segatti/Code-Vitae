import 'package:flutter/material.dart';

class LogoPresenter extends StatefulWidget {
  const LogoPresenter({super.key});

  @override
  State<LogoPresenter> createState() => _LogoPresenterState();
}

class _LogoPresenterState extends State<LogoPresenter> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
