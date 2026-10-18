import 'package:flutter/widgets.dart';

import 'app_lifecycle_bridge.dart';

class AlugaAppLifecycleListener extends StatefulWidget {
  const AlugaAppLifecycleListener({super.key, required this.child});

  final Widget child;

  @override
  State<AlugaAppLifecycleListener> createState() =>
      _AlugaAppLifecycleListenerState();
}

class _AlugaAppLifecycleListenerState extends State<AlugaAppLifecycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLifecycleBridge.updateLifecycle(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
