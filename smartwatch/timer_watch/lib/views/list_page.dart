import 'package:flutter/material.dart';
import 'package:timer_watch/models/training.dart';

import '../widgets/training_item.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        padEnds: false,
        controller: PageController(viewportFraction: .4),
        children: const [
          TrainingItem(
            training: Training(name: "Treino A", quantityExercises: 5),
          ),
          TrainingItem(
            training: Training(name: "Treino B", quantityExercises: 2),
          ),
          TrainingItem(
            training: Training(name: "Treino C", quantityExercises: 1),
          ),
        ],
      ),
    );
  }
}
