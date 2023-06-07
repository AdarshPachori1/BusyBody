import 'package:adarshpachori/models/rank.dart';
import 'package:adarshpachori/models/food.dart';

import 'package:ml_linalg/linalg.dart';

class Recipe implements Food {
  @override
  String name;
  @override
  String url;
  String description;
  num calories; // units: kcal
  num protein;
  num carbs;
  num fat;

  Recipe(
      {required this.url,
      required this.name,
      required this.description,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fat});
}

Matrix _computeNormMatrix(List<Recipe> unrankedRecipes, Vector userRow) {
  // convert workouts into vectors of nums
  List<Vector> rows = unrankedRecipes
      .map((recipe) => Vector.fromList(
          [recipe.calories, recipe.protein, recipe.carbs, recipe.fat]))
      .toList();
  // add user vector of criteria to the rows to be noramalized
  rows.add(userRow);
  return computeNormalizedMatrixFromRows(rows);
}

List<Recipe> getRankedRecipes(List<Recipe> unsortedWorkouts, num userCalories,
    num userProtein, num userCarbs, num userFat) {
  final Vector userVector =
      Vector.fromList([userCalories, userProtein, userCarbs, userFat]);
  final Matrix normalizedMatrix =
      _computeNormMatrix(unsortedWorkouts, userVector);
  final List<Vector> normalizedWorkouts = getAlternatives(normalizedMatrix);
  final Vector normalizedUserVector = getUserVector(normalizedMatrix);

  final Map<Recipe, double> workoutToScore = {
    for (int i = 0; i < normalizedWorkouts.length; i++)
      unsortedWorkouts[i]:
          normalizedWorkouts[i].distanceTo(normalizedUserVector),
  };

  List<Recipe> rankedWorkouts = List<Recipe>.from(unsortedWorkouts);
  rankedWorkouts
      .sort((a, b) => workoutToScore[a]!.compareTo(workoutToScore[b]!));
  return rankedWorkouts;
}
