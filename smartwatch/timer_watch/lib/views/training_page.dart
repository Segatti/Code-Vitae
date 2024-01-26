import 'package:flutter/material.dart';
import 'package:timer_watch/models/exercise.dart';
import 'package:timer_watch/models/training.dart';

import '../widgets/exercise_item.dart';

class TrainingPage extends StatefulWidget {
  final Training training;
  const TrainingPage({super.key, required this.training});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<Exercise> exercises = [
    const Exercise(
      name: 'Corrida',
      series: 1,
      timeExecution: 60,
      timeResting: 10,
    ),
    const Exercise(
      name: 'Biceps',
      load: "10Kg",
      repetitions: 20,
      series: 2,
      timeResting: 20,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      scrollDirection: Axis.vertical,
      children: [
        ExerciseItem(exercise: exercises[0]),
        ExerciseItem(exercise: exercises[1]),
      ],
    ));
  }
}
