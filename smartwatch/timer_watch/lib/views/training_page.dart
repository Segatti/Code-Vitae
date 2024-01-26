import 'package:flutter/material.dart';
import 'package:timer_watch/models/training.dart';

class TrainingPage extends StatefulWidget {
  final Training training;
  const TrainingPage({super.key, required this.training});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.training.name ?? ""),
      ),
    );
  }
}
