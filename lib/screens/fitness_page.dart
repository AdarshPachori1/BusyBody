import 'package:adarshpachori/models/workout.dart';
import 'package:adarshpachori/screens/exercise_expanded_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  String dropdownValue = "Muscle Building";

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> dropdownlist = ["Muscle Building"];
  bool runOnce = false;
  void updateDropDown() async {
    await firestore.collection('workouts').get().then((value) {
      setState(() {
        dropdownlist = value.docs
            .map((document) => document['category'] as String)
            .toSet()
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;
    if (!runOnce) {
      runOnce = true;
      updateDropDown();
    }
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
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('workouts').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              List<QueryDocumentSnapshot> documentsFiltered =
                  documents.where((doc) {
                return (doc.data() as Map<String, dynamic>)['category'] ==
                    dropdownValue;
              }).toList();
              return ListView.builder(
                itemCount: documentsFiltered.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> mappedData =
                      documentsFiltered[index].data() as Map<String, dynamic>;
                  Workout workoutData = Workout(
                      category: mappedData['category'],
                      daysPerWeek: mappedData['days_per_week'],
                      description: mappedData['description'],
                      equipment: mappedData['equipment'],
                      goal: mappedData['goal'],
                      name: mappedData['name'],
                      programDuration: mappedData['program_duration'],
                      timePerWorkout: mappedData['time_per_workout'],
                      trainingLevel: mappedData['training_level'],
                      url: mappedData['url']);
                  // Build your widget using the data
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ExerciseFullPage(workoutVal: workoutData),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                      child: Text(workoutData.name),
                    ),
                  );
                },
              );
            },
          ),

          /*(dropdownValue == "Mobility"
                        ? mobilityExercises
                        : strengthExercises)
                    .map((Workout workout) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ExerciseFullPage(workoutVal: workout),
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
                            child: Text(workout.name),
                          ),
                        ))
                    .toList(),*/
        ),
      ],
    );
  }
}
