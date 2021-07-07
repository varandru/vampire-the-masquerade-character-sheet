import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vampire_the_masquerade_character_sheet/vampite_character.dart';

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
class MainInfoController extends GetxController {
  late final Database _database;

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
    _database
        .update('characters', {'name': name},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update name, value = $value'));
  }

  void setNature(String nature) {
    _nature.value = nature;
    _database
        .update('characters', {'nature': nature},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update player name, value = $value'));
  }

  void setClan(String clan) {
    _clan.value = clan;
    _database.update('characters', {'clan': clan},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void setPlayerName(String playerName) {
    _playerName.value = playerName;
    _database.update('characters', {'player_name': playerName},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void setDemeanor(String demeanor) {
    _demeanor.value = demeanor;
    _database.update('characters', {'demeanor': demeanor},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void setGeneration(int generation) {
    _generation.value = generation;
    _database.update('characters', {'generation': generation},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void setChronicle(String chronicle) {
    _chronicle.value = chronicle;
    _database.update('characters', {'chronicle': chronicle},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void setConcept(String concept) {
    _concept.value = concept;
    _database.update('characters', {'concept': concept},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void setSire(String sire) {
    _sire.value = sire;
    _database.update('characters', {'sire': sire},
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);
  }

  void load(Map<String, dynamic> json) {
    _characterName(json["character_name"] ?? "Character Name");
    _nature(json["nature"] ?? "Nature");
    _clan(json["clan"] ?? "Clan");
    _playerName(json["player_name"] ?? "Player Name");
    _demeanor(json["demeanor"] ?? "Demeanor");
    _generation(json["generation"] ?? "Generation");
    _chronicle(json["chronicle"] ?? "Chronicle");
    _concept(json["concept"] ?? "Concept");
    _sire(json["sire"] ?? "Sire");
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

  Future<void> fromDatabase(Database database) async {
    _database = database;

    var r = await _database.query('characters',
        columns: [
          'name',
          'player_name',
          'nature',
          'clan',
          'demeanor',
          'generation',
          'chronicle',
          'concept',
          'sire'
        ],
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);

    var response = r[0];
    _characterName.value = response['name'] as String;
    _playerName.value = response['player_name'] as String;
    _nature.value = response['nature'] as String;
    _clan.value = response['clan'] as String;
    _demeanor.value = response['demeanor'] as String;
    _generation.value = response['generation'] as int;
    _chronicle.value = response['chronicle'] as String;
    _concept.value = response['concept'] as String;
    _sire.value = response['sire'] as String;
  }
}

/// Blood, willpower, experience controller. I don't have a better name
/// These values change a lot in play, so they are stored separately
class MostVariedController extends GetxController {
  late final Database _database;

  var _blood = 0.obs;
  var _bloodMax = 20.obs;
  var _will = 0.obs;

  int get blood => _blood.value;
  int get bloodMax => _bloodMax.value;
  int get will => _will.value;

  set blood(int blood) {
    _blood.value = blood;
    _database
        .update('characters', {'blood': blood},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update current blood, value = $value'));
  }

  set bloodMax(int bloodMax) {
    _bloodMax.value = bloodMax;
    _database
        .update('characters', {'blood_max': bloodMax},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update blood max, value = $value'));
  }

  set will(int will) {
    _will.value = will;
    _database
        .update('characters', {'will': will},
            where: 'id = ?',
            whereArgs: [Get.find<VampireCharacter>().characterId.value])
        .then((value) => print('Update current willpower, value = $value'));
  }

  void fromJson(Map<String, dynamic> json) {
    _blood.value = json["blood"] ?? 0;
    _bloodMax.value = json["bloodMax"] ?? 20;
    _will.value = json["will"] ?? 0;
  }

  void fromDatabase(Database database) async {
    _database = database;
    var response = await _database.query('characters',
        columns: ['will', 'blood', 'blood_max'],
        where: 'id = ?',
        whereArgs: [Get.find<VampireCharacter>().characterId.value]);

    if (response.length == 0) throw ('No character in database');
    _blood.value = response[0]['will'] as int;
    _bloodMax.value = response[0]['blood_max'] as int;
    _will.value = response[0]['will'] as int;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["blood"] = _blood.value;
    json["bloodMax"] = _bloodMax.value;
    json["will"] = _will.value;
    return json;
  }
}
