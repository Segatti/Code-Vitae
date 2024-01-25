import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _init() async {
    await Future.delayed(Durations.extralong4);
    // Verificar se tem login
    if(mounted) Navigator.of(context).pushNamed("/menu");
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Image.asset("assets/images/logo_app.png"),
      ),
    );
  }
}
