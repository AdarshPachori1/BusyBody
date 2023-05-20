class Recipe {
  String name;
  double cookingTime;
  String youtubeLink;
  String description;
  double calories;
  double protein;
  double carbs;
  double fat;
  List<String> ingredients;
  List<String> cookingSteps;

  Recipe({
    required this.name,
    required this.cookingTime,
    required this.youtubeLink,
    this.description = "",
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.ingredients = const [],
    this.cookingSteps = const [],
  });
}
