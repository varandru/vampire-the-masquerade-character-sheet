import 'package:get/get.dart';

class Ritual {
  Ritual({
    required this.name,
    this.level = 1,
    this.description = "",
    this.system = "",
  });
  final int level;
  final String name;
  final String description;
  final String system;
}

class RitualController extends GetxController {
  RxList<Ritual> rituals = RxList();
}
