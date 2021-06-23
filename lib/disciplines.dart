import 'package:get/get.dart';

class Discipline {
  Discipline(
      {String name = "", int level = 1, String description = "", int max = 5})
      : this.name = name,
        this.description = description,
        this.level = level,
        this.max = max;
  final String name;
  final String description;

  final int level;
  final int max;

  List<DisciplineDot> levels = [];
}

class DisciplineDot {
  DisciplineDot(
      {String name = "",
      String system = "",
      int level = 0,
      int max = 5,
      String description = ""})
      : this.description = description,
        this.name = name,
        this.level = level,
        this.system = system,
        this.max = max;

  final String name;
  final String description;
  final String system;

  final int level;
  final int max;
}

class DisciplineController extends GetxController {
  RxList<Discipline> disciplines = RxList();

  void load(List<dynamic> json, DisciplineDictionaty dictionary) {}
}

class DisciplineDictionaty {}
