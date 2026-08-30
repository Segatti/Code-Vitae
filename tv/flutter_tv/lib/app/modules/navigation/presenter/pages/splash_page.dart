import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../stores/splash_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashStore store;

  @override
  void initState() {
    store = inject<SplashStore>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future _init() async {
    await store.startStore();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (store.userIsLogged) {
      context.navigate('/main/');
    } else {
      context.navigate('/auth/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF01012B),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/logo.png",
                  scale: 1,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Flutter TV",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
