import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:timer_watch/models/training.dart';

class TrainingItem extends StatelessWidget {
  final Training training;
  const TrainingItem({
    super.key,
    required this.training,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          "/training",
          arguments: training,
        ),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  training.name ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Gap(8),
              Text(
                training.quantityExercises?.toString() ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
