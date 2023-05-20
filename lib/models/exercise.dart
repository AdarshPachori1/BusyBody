class Exercise {
  String name;
  double duration;
  String youtubeLink;
  int numberOfSets;
  int numberOfReps;
  Exercise({
    required this.name,
    required this.duration,
    required this.youtubeLink,
    this.numberOfSets = 0,
    this.numberOfReps = 0,
  });
}
