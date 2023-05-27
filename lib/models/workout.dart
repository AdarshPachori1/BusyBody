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
