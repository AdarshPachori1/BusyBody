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
}

Matrix _computeNormMatrix(List<Workout> unrankedWorkouts, Vector userRow) {
  // convert workouts into vectors of nums
  List<Vector> rows = unrankedWorkouts
      .map((workout) =>
          Vector.fromList([workout.daysPerWeek, workout.timePerWorkout]))
      .toList();
  // add user vector of criteria to the rows to be noramalized
  rows.add(userRow);
  return computeNormalizedMatrixFromRows(rows);
}

List<Workout> getRankedWorkouts(List<Workout> unsortedWorkouts,
    num userDaysPerWeek, num userTimePerWorkout) {
  final Vector userVector =
      Vector.fromList([userDaysPerWeek, userTimePerWorkout]);
  final Matrix normalizedMatrix =
      _computeNormMatrix(unsortedWorkouts, userVector);
  final List<Vector> normalizedWorkouts = getAlternatives(normalizedMatrix);
  final Vector normalizedUserVector = getUserVector(normalizedMatrix);

  final Map<Workout, double> workoutToScore = {
    for (int i = 0; i < normalizedWorkouts.length; i++)
      unsortedWorkouts[i]:
          normalizedWorkouts[i].distanceTo(normalizedUserVector),
  };

  List<Workout> rankedWorkouts = List<Workout>.from(unsortedWorkouts);
  rankedWorkouts
      .sort((a, b) => workoutToScore[a]!.compareTo(workoutToScore[b]!));
  return rankedWorkouts;
}
