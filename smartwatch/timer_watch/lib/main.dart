import 'package:flutter/material.dart';
import 'package:timer_watch/routes.dart';
import 'package:wear/wear.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (context, mode, child) => MaterialApp(
        title: 'Timer Watch',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        onGenerateRoute: Routes.generate,
        theme: ThemeData(
          visualDensity: VisualDensity.compact,
          colorScheme: mode == WearMode.active
              ? const ColorScheme.dark(
                  //
                  primary: Color(0xFF00B5FF),
                )
              : const ColorScheme.dark(
                  primary: Colors.white24,
                  onBackground: Colors.white10,
                  onSurface: Colors.white10,
                ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
