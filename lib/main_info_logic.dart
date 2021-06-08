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
}

/// Blood, willpower, experience controller. I don't have a better name
class MostVariedController extends GetxController {
  var blood = 0.obs;
  var bloodMax = 0.obs;
  var will = 0.obs;
  var willMax = 0.obs;
}
