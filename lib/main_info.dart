import 'package:get/get.dart';

enum MainInfoFieldType {
  CharacterName,
  Nature,
  Clan,
  PlayerName,
  Demeanor,
  Generation,
  Chronicle,
  Concept,
  Sire
}

class MainInfo extends GetxController {
  MainInfo();

  var _characterName = "Noah Brendel".obs;
  var _nature = "Perfectionist".obs;
  var _clan = "Tremere".obs;
  var _playerName = "Vladimir Aranovskiy".obs;
  var _demeanor = "Perfectionist".obs;
  var _generation = 10.obs;
  var _chronicle = "Academia".obs;
  var _concept = "Intellectual".obs;
  var _sire = "Lawrence".obs;

  String get characterName => _characterName.value;
  String get nature => _nature.value;
  String get clan => _clan.value;
  String get playerName => _playerName.value;
  String get demeanor => _demeanor.value;
  int get generation => _generation.value;
  String get chronicle => _chronicle.value;
  String get concept => _concept.value;
  String get sire => _sire.value;

  void setByType(MainInfoFieldType type, String newField) {
    switch (type) {
      case MainInfoFieldType.CharacterName:
        setCharacterName(newField);
        break;
      case MainInfoFieldType.Nature:
        setNature(newField);
        break;
      case MainInfoFieldType.Clan:
        setClan(newField);
        break;
      case MainInfoFieldType.PlayerName:
        setPlayerName(newField);
        break;
      case MainInfoFieldType.Demeanor:
        setDemeanor(newField);
        break;
      case MainInfoFieldType.Generation:
        setGeneration(int.parse(newField));
        break;
      case MainInfoFieldType.Chronicle:
        setChronicle(newField);
        break;
      case MainInfoFieldType.Concept:
        setConcept(newField);
        break;
      case MainInfoFieldType.Sire:
        setSire(newField);
        break;
    }
  }

  String getByType(MainInfoFieldType type) {
    switch (type) {
      case MainInfoFieldType.CharacterName:
        return characterName;
      case MainInfoFieldType.Nature:
        return nature;
      case MainInfoFieldType.Clan:
        return clan;
      case MainInfoFieldType.PlayerName:
        return playerName;
      case MainInfoFieldType.Demeanor:
        return demeanor;
      case MainInfoFieldType.Generation:
        return generation.toString() + "th";
      case MainInfoFieldType.Chronicle:
        return chronicle;
      case MainInfoFieldType.Concept:
        return concept;
      case MainInfoFieldType.Sire:
        return sire;
    }
  }

  void setCharacterName(String name) {
    _characterName.value = name;
  }

  void setNature(String nature) {
    _nature.value = nature;
  }

  void setClan(String clan) {
    _clan.value = clan;
  }

  void setPlayerName(String playerName) {
    _playerName.value = playerName;
  }

  void setDemeanor(String demeanor) {
    _demeanor.value = demeanor;
  }

  void setGeneration(int generation) {
    _generation.value = generation;
  }

  void setChronicle(String chronicle) {
    _chronicle.value = chronicle;
  }

  void setConcept(String concept) {
    _concept.value = concept;
  }

  void setSire(String sire) {
    _sire.value = sire;
  }

  void load(Map<String, dynamic> json) {
    setCharacterName(json["character_name"] ?? "Character Name");
    setNature(json["nature"] ?? "Nature");
    setClan(json["clan"] ?? "Clan");
    setPlayerName(json["player_name"] ?? "Player Name");
    setDemeanor(json["demeanor"] ?? "Demeanor");
    setGeneration(json["generation"] ?? "Generation");
    setChronicle(json["chronicle"] ?? "Chronicle");
    setConcept(json["concept"] ?? "Concept");
    setSire(json["sire"] ?? "Sire");
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["character_name"] = characterName;
    json["nature"] = nature;
    json["clan"] = clan;
    json["player_name"] = playerName;
    json["demeanor"] = demeanor;
    json["generation"] = generation;
    json["chronicle"] = chronicle;
    json["concept"] = concept;
    json["sire"] = sire;
    return json;
  }
}

/// Blood, willpower, experience controller. I don't have a better name
/// These values change a lot in play, so they are stored separately
class MostVariedController extends GetxController {
  var blood = 0.obs;
  var bloodMax = 20.obs;
  var will = 0.obs;

  var xp = 0.obs;

  void load(Map<String, dynamic> json) {
    blood.value = json["blood"] ?? 0;
    bloodMax.value = json["bloodMax"] ?? 20;
    will.value = json["will"] ?? 0;
    xp.value = json["xp"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["blood"] = blood.value;
    json["bloodMax"] = bloodMax.value;
    json["will"] = will.value;
    json["xp"] = xp.value;
    return json;
  }
}

class VirtuesController extends GetxController {
  var consience = 2.obs;
  var selfControl = 3.obs;
  var courage = 5.obs;

  var additionalHumanity = 0.obs;
  var additionalWillpower = 5.obs;

  int get humanity =>
      consience.value + selfControl.value + additionalHumanity.value;
  int get willpower => courage.value + additionalWillpower.value;

  void load(Map<String, dynamic> json) {
    consience.value = json["consience"] ?? 0;
    selfControl.value = json["self_control"] ?? 0;
    courage.value = json["courage"] ?? 0;

    additionalHumanity.value = json["additional_humanity"] ?? 0;
    additionalWillpower.value = json["additional_willpower"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["consience"] = consience.value;
    json["self_control"] = selfControl.value;
    json["courage"] = courage.value;

    json["additional_humanity"] = additionalHumanity.value;
    json["additional_willpower"] = additionalWillpower.value;
    return json;
  }
}
