import 'package:get/get.dart';

/// To fill a ritual
/// 1. Create an empty one, initialize with id
/// 2. Fill the info with @fromJson method
/// TODO 3. Fill the school name by it's id
class Ritual {
  Ritual({
    required this.id,
    this.name = "",
    this.schoolId = "",
    this.school = "",
    this.level = 1,
    this.description = "",
    this.system = "",
  });
  final String id;
  int level;
  String name;
  String school;
  String schoolId;
  String? description;
  String system;

  void copy(Ritual other) {
    level = other.level;
    name = other.name;
    school = other.school;
    schoolId = other.schoolId;
    description = other.description;
    system = other.system;
  }

  /// IMPORTANT this is for Dictionary
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();

    json["level"] = level;
    json["name"] = name;
    json["id"] = id;
    json["school_id"] = schoolId;
    json["description"] = description;
    json["system"] = system;

    return json;
  }

  /// IMPORTANT this is for Dictionary.
  void fromJson(Map<String, dynamic> json) {
    level = json["level"];
    name = json["name"];
    schoolId = json["school_id"];
    description = json["description"];
    system = json["system"];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ritual && other.id == this.id);

  @override
  int get hashCode => id.hashCode;
}

/// Ritual Entry does not exist here. It contains the same
/// information as a basic ritual, so we're just pulling only the
///  neccessary ones from JSon dictionary
class RitualController extends GetxController {
  RxList<Ritual> rituals = RxList();

  List<dynamic> save() {
    return List<String>.generate(
        rituals.length, (index) => rituals[index].name);
  }

  void load(List<dynamic> ids, Map<String, dynamic> dictionary) {
    for (var id in ids) {
      var ritual = Ritual(id: id);
      if (dictionary[ritual.id] != null) {
        ritual.fromJson(dictionary[ritual.id]);
        // TODO: fill school by id
        if (!rituals.contains(ritual)) rituals.add(ritual);
      }
    }
  }
}
