import 'package:adarshpachori/models/workout.dart';
import 'package:flutter/material.dart';

class ExerciseFullPage extends StatefulWidget {
  final Workout workoutVal;
  const ExerciseFullPage({super.key, required this.workoutVal});

  @override
  State<ExerciseFullPage> createState() => _ExerciseFullPageState();
}

class _ExerciseFullPageState extends State<ExerciseFullPage> {
  late Workout workout;

  int counter = 0;

  @override
  void initState() {
    super.initState();
    workout = widget.workoutVal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              children: [Icon(Icons.arrow_back), Text("Go Back")],
            ),
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text("Workout: ${workout.name}")),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text("Description: ${workout.description}")),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(
              "Equipment Needed: ${workout.equipment}",
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(
              "Program Duration: ${workout.programDuration} mins",
            ),
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text("Days per week: ${workout.daysPerWeek}")),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(
              "Time Per Workoout: ${workout.timePerWorkout}",
            ),
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text("Training Level: ${workout.trainingLevel}")),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text("URL: ${workout.url}")),
        ]),
      ),
    );
  }
}
