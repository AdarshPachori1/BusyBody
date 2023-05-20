import 'package:adarshpachori/models/exercise.dart';
import 'package:adarshpachori/screens/exercise_expanded_page.dart';
import 'package:flutter/material.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  String dropdownValue = "Mobility";
  List<String> dropdownlist = <String>["Mobility", "Strength"];
  List<Exercise> mobilityExercises = [
    Exercise(name: "Warrior Pose", duration: 30.0, youtubeLink: ""),
    Exercise(name: "Cobra", duration: 10.0, youtubeLink: ""),
    Exercise(name: "Downward Dog", duration: 15.0, youtubeLink: ""),
    Exercise(name: "Zumba exercises", duration: 20.0, youtubeLink: ""),
    Exercise(name: "Calisthenics", duration: 5.0, youtubeLink: ""),
    Exercise(name: "Russian Twists", duration: 2.0, youtubeLink: ""),
    Exercise(name: "Ab Roll", duration: 1.0, youtubeLink: "")
  ];
  List<Exercise> strengthExercises = [
    Exercise(name: "Plank", duration: 30.0, youtubeLink: ""),
    Exercise(name: "Pull Up", duration: 10.0, youtubeLink: ""),
    Exercise(name: "Bicep Curl", duration: 15.0, youtubeLink: ""),
    Exercise(name: "7-7-7", duration: 20.0, youtubeLink: ""),
    Exercise(name: "Hammer Curls", duration: 5.0, youtubeLink: ""),
    Exercise(name: "Lateral Raises", duration: 2.0, youtubeLink: ""),
    Exercise(name: "Shoulder Press", duration: 1.0, youtubeLink: ""),
    Exercise(name: "Tricep Extensions", duration: 1.0, youtubeLink: "")
  ];
  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Your goal: "),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              items: dropdownlist.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  dropdownValue = val!;
                });
              },
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 30,
          child: const Text("\t\t\tRecommendations"),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 30,
          child: const Text("\t\t\t\t\t Daily Regimen:"),
        ),
        Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 0.6 * heightOfScreen,
            width: 0.9 * widthOfScreen,
            child: SingleChildScrollView(
              child: Column(
                children: (dropdownValue == "Mobility"
                        ? mobilityExercises
                        : strengthExercises)
                    .map((Exercise exercise) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ExerciseFullPage(exerciseVal: exercise),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 0.1 * heightOfScreen,
                            width: 0.9 * widthOfScreen,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(exercise.name),
                          ),
                        ))
                    .toList(),
              ),
            ))
      ],
    );
  }
}
