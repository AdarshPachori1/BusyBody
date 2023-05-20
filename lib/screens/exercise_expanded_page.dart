
import 'package:adarshpachori/models/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseFullPage extends StatefulWidget {
  final Exercise exerciseVal;
  const ExerciseFullPage({super.key, required this.exerciseVal});

  @override
  State<ExerciseFullPage> createState() => _ExerciseFullPageState();
}

class _ExerciseFullPageState extends State<ExerciseFullPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: const [Icon(Icons.arrow_back), Text("Go Back")],
            ),
          ),
          Text(widget.exerciseVal.name),
          Text(
            "Duration: ${widget.exerciseVal.duration.toString()}",
          ),
          Text("Youtube Link: ${widget.exerciseVal.youtubeLink}"),
        ]),
      ),
    );
  }
}
