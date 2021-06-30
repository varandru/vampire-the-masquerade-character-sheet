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

// TODO: somehow, generation still isn't a dropdown
class MainInfo extends GetxController {
  MainInfo();

  var _characterName = "Character Name".obs;
  var _nature = "nature".obs;
  var _clan = "Clan".obs;
  var _playerName = "Player Name".obs;
  var _demeanor = "Demeanor".obs;
  var _generation = 10.obs;
  var _chronicle = "Chronicle".obs;
  var _concept = "Concept".obs;
  var _sire = "Sire".obs;

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
        return characterName.isEmpty ? "Character Name" : characterName;
      case MainInfoFieldType.Nature:
        return nature.isEmpty ? "Nature" : nature;
      case MainInfoFieldType.Clan:
        return clan.isEmpty ? "Clan" : clan;
      case MainInfoFieldType.PlayerName:
        return playerName.isEmpty ? "Player Name" : playerName;
      case MainInfoFieldType.Demeanor:
        return demeanor.isEmpty ? "Demeanor" : demeanor;
      case MainInfoFieldType.Chronicle:
        return chronicle.isEmpty ? "Chronicle" : chronicle;
      case MainInfoFieldType.Concept:
        return concept.isEmpty ? "Concept" : concept;
      case MainInfoFieldType.Sire:
        return sire.isEmpty ? "Sire" : sire;
      case MainInfoFieldType.Generation:
        return generation.toString() + "th";
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

  void load(Map<String, dynamic> json) {
    blood.value = json["blood"] ?? 0;
    bloodMax.value = json["bloodMax"] ?? 20;
    will.value = json["will"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["blood"] = blood.value;
    json["bloodMax"] = bloodMax.value;
    json["will"] = will.value;
    return json;
  }
}
