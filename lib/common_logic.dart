class ComplexAbility {
  ComplexAbility(
      {required this.name,
      this.current = 1,
      this.min = 0,
      this.max = 5,
      this.specialization = "",
      this.description = "",
      this.isIncremental = true});
  String name;
  int current;
  int min;
  int max;
  String specialization;
  String description;
  List<String> levelDescriptions = [];

  /// Does this ability get directly better at higher levels?
  /// If there is variety, this is false
  bool isIncremental;
}
