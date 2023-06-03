import 'package:adarshpachori/models/rank.dart';
import 'package:adarshpachori/models/food.dart';

import 'package:ml_linalg/linalg.dart';

class Restaurant implements Food {
  @override
  String name;
  @override
  String url;
  String imageUrl;
  num rating;
  num sentimentRating;
  num latitude;
  num longitude;
  String priceLevel;
  String address;
  String phone;

  Restaurant(
      {required this.name,
      required this.imageUrl,
      required this.url,
      required this.rating,
      required this.sentimentRating,
      required this.latitude,
      required this.longitude,
      required this.priceLevel,
      required this.address,
      required this.phone});

  /// Get numerical representation for dollar sign "$" price level
  int getNumForPriceLevel() {
    /// Price level should be between "$" and "$$$$$"
    switch (priceLevel) {
      case "\$":
        return 1;
      case "\$\$":
        return 2;
      case "\$\$\$":
        return 3;
      case "\$\$\$\$":
        return 4;
      case "\$\$\$\$\$":
        return 5;
      default:
        return 0;
    }
  }
}

Matrix _computeNormMatrix(
    List<Restaurant> unrankedRestaurants, Vector userRow) {
  // convert workouts into vectors of nums
  List<Vector> rows = unrankedRestaurants
      .map((restaurant) => Vector.fromList([
            restaurant.rating,
            restaurant.sentimentRating,
            restaurant.getNumForPriceLevel()
          ]))
      .toList();
  // add user vector of criteria to the rows to be noramalized
  rows.add(userRow);
  return computeNormalizedMatrixFromRows(rows);
}

List<Restaurant> getRankedRestaurants(
    List<Restaurant> unsortedRestaurants, num userPriceLevel) {
  final Vector userVector = Vector.fromList([
    5.0, // rating is between 0 and 5.0
    1.0, // sentiment rating between 0 and 1.0
    userPriceLevel
  ]);
  final Matrix normalizedMatrix =
      _computeNormMatrix(unsortedRestaurants, userVector);
  final List<Vector> normalizedWorkouts = getAlternatives(normalizedMatrix);
  final Vector normalizedUserVector = getUserVector(normalizedMatrix);

  final Map<Restaurant, double> workoutToScore = {
    for (int i = 0; i < normalizedWorkouts.length; i++)
      unsortedRestaurants[i]:
          normalizedWorkouts[i].distanceTo(normalizedUserVector),
  };

  List<Restaurant> rankedWorkouts = List<Restaurant>.from(unsortedRestaurants);
  rankedWorkouts
      .sort((a, b) => workoutToScore[a]!.compareTo(workoutToScore[b]!));
  return rankedWorkouts;
}
