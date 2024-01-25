import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      child: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, mode, child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
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
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: WatchShape(
          builder: (context, shape, child) => Container(
            decoration: BoxDecoration(
              shape: shape == WearShape.round
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey,
                width: 5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                const Text("Contador"),
                Text(
                  _counter.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
