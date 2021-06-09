import 'package:get/get.dart';

import 'common_logic.dart';

enum AbilityColumnType { Talents, Skills, Knowledges }

class AbilitiesController extends GetxController {
  RxList<ComplexAbility> talents = RxList<ComplexAbility>();
  RxList<ComplexAbility> skills = RxList<ComplexAbility>();
  RxList<ComplexAbility> knowledges = RxList<ComplexAbility>();

  List<ComplexAbility> getAbilitiesByType(AbilityColumnType type) {
    switch (type) {
      case AbilityColumnType.Talents:
        return talents;
      case AbilityColumnType.Skills:
        return skills;
      case AbilityColumnType.Knowledges:
        return knowledges;
    }
  }

  String getHeaderByType(AbilityColumnType type) {
    switch (type) {
      case AbilityColumnType.Talents:
        return "Talents";
      case AbilityColumnType.Skills:
        return "Skills";
      case AbilityColumnType.Knowledges:
        return "Knowledges";
    }
  }

  //CRUTCH: This is a crutch for Web debug
  void initializeFromConstants() {
    talents.value = TalentsAbilitiesColumn().attributes;
    skills.value = SkillsAbilitiesColumn().attributes;
    knowledges.value = KnowledgeAbilitiesColumn().attributes;
  }
}

class TalentsAbilitiesColumn {
  final header = "Talents";

  var attributes = [
    ComplexAbility(name: "Alertness", current: 2),
    ComplexAbility(name: "Athletics", current: 0),
    ComplexAbility(name: "Brawl", current: 0),
    ComplexAbility(name: "Dodge", current: 3),
    ComplexAbility(name: "Empathy", current: 0),
    ComplexAbility(name: "Expression", current: 0),
    ComplexAbility(name: "Intimidation", current: 0),
    ComplexAbility(name: "Leadership", current: 0),
    ComplexAbility(name: "Streetwise", current: 0),
    ComplexAbility(name: "Subterfuge", current: 0),
  ];
}

class SkillsAbilitiesColumn {
  final header = "Skills";

  var attributes = [
    ComplexAbility(name: "Animal", current: 0),
    ComplexAbility(name: "Crafts", current: 0),
    ComplexAbility(name: "Drive", current: 0),
    ComplexAbility(name: "Etiquette", current: 0),
    ComplexAbility(name: "Firearms", current: 3),
    ComplexAbility(name: "Melee", current: 0),
    ComplexAbility(name: "Performance", current: 0),
    ComplexAbility(name: "Security", current: 3),
    ComplexAbility(name: "Stealth", current: 3),
    ComplexAbility(name: "Survival", current: 0),
  ];
}

class KnowledgeAbilitiesColumn {
  final header = "Knowledges";

  var attributes = [
    ComplexAbility(name: "Academics", current: 0),
    ComplexAbility(
        name: "Computers", current: 4, specialization: "Passwords Hacking"),
    ComplexAbility(name: "Finance", current: 0),
    ComplexAbility(name: "Investigation", current: 3),
    ComplexAbility(name: "Law", current: 0),
    ComplexAbility(name: "Linguistics", current: 2),
    ComplexAbility(name: "Medicine", current: 2),
    ComplexAbility(name: "Occult", current: 3),
    ComplexAbility(name: "Politics", current: 0),
    ComplexAbility(name: "Science", current: 0),
  ];
}
