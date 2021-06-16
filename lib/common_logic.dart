class ComplexAbility {
  ComplexAbility(
      {required this.name,
      this.current = 1,
      this.min = 0,
      this.max = 5,
      this.specialization = "",
      this.description = "",
      this.levelDescriptions,
      this.isIncremental = true});
  String name;
  int current;
  int min;
  int max;
  String specialization;
  String description;
  List<String>? levelDescriptions = [];

  /// Does this ability get directly better at higher levels?
  /// If there is variety, this is false
  bool isIncremental;

  // TODO: think if name is the only thing to compare
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComplexAbility && other.name == this.name);

  @override
  int get hashCode => name.hashCode;
}

// String name is not in the entry, it's a map key
class ComplexAbilityEntry {
  // String name = "";
  List<String> specializations = [];
  List<String> level = [];
  String? description;
}
