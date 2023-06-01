import 'package:adarshpachori/models/rank.dart';

import 'package:ml_linalg/linalg.dart';

class Workout {
  String category;
  num daysPerWeek;
  String description;
  String equipment;
  String goal;
  String name;
  num programDuration;
  num timePerWorkout;
  String trainingLevel;
  String url;

  Workout(
      {required this.category,
      required this.daysPerWeek,
      required this.description,
      required this.equipment,
      required this.goal,
      required this.name,
      required this.programDuration,
      required this.timePerWorkout,
      required this.trainingLevel,
      required this.url});

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
        category: json['category'],
        daysPerWeek: json['days_per_week'],
        description: json['description'],
        equipment: json['equipment'],
        goal: json['goal'],
        name: json['name'],
        programDuration: json['program_duration'],
        timePerWorkout: json['time_per_workout'],
        trainingLevel: json['training_level'],
        url: json['url']);
  }
}

Matrix _computeNormMatrix(List<Workout> unrankedWorkouts, num userDaysPerWeek,
    num userTimePerWorkout) {
  // convert workouts into vectors of nums
  List<Vector> rows = unrankedWorkouts
      .map((workout) =>
          Vector.fromList([workout.daysPerWeek, workout.timePerWorkout]))
      .toList();
  // add user vector of criteria to the rows to be noramalized
  rows.add(Vector.fromList([userDaysPerWeek, userTimePerWorkout]));
  return computeNormalizedMatrixFromRows(rows);
}

List<Workout> getRankedWorkouts(List<Workout> unsortedWorkouts,
    num userDaysPerWeek, num userTimePerWorkout) {
  final Matrix normalizedMatrix =
      _computeNormMatrix(unsortedWorkouts, userDaysPerWeek, userTimePerWorkout);
  final List<Vector> alternatives = getAlternatives(normalizedMatrix);
  final Vector userVector = getUserVector(normalizedMatrix);

  final Map<Workout, double> workoutToScore = {
    for (int i = 0; i < alternatives.length; i++)
      unsortedWorkouts[i]: alternatives[i].distanceTo(userVector),
  };

  List<Workout> rankedWorkouts = List<Workout>.from(unsortedWorkouts);
  rankedWorkouts
      .sort((a, b) => workoutToScore[a]!.compareTo(workoutToScore[b]!));
  return rankedWorkouts;
}
