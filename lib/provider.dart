import 'package:flutter/material.dart';
import "package:riverpod/riverpod.dart";
import 'common.dart';

final mainInfoProvider = Provider((ref) {
  return CommonCharacterInfoWidget();
});

class VampireCharacter {
  MainInfo mainInfo = MainInfo();
  CommonCharacterInfoWidget mainInfoWidget = CommonCharacterInfoWidget();

  Widget build(context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(child: watch(mainInfoProvider)),
    ));
  }
}

class MainInfo extends ChangeNotifier {
  MainInfo() : _changed = false;

  String _characterName = "";
  String _nature = "";
  String _clan = "";
  String _playerName = "";
  String _demeanor = "";
  int _generation = 13;
  String _chronicle = "";
  String _concept = "";
  String _sire = "";

  bool _changed;

  String getCharacterName() => _characterName;
  String getNature() => _nature;
  String getClan() => _clan;
  String getPlayerName() => _playerName;
  String getDemeanor() => _demeanor;
  int getGeneration() => _generation;
  String getChronicle() => _chronicle;
  String getConcept() => _concept;
  String getSire() => _sire;

  bool get changed => _changed;

  void setCharacterName(String name) {
    _characterName = name;
    _changed = true;
    notifyListeners();
  }

  void setNature(String nature) {
    _nature = nature;
    _changed = true;
    notifyListeners();
  }

  void setClan(String clan) {
    _clan = clan;
    notifyListeners();
  }

  void setPlayerName(String playerName) {
    _playerName = playerName;
    _changed = true;
    notifyListeners();
  }

  void setDemeanor(String demeanor) {
    _demeanor = demeanor;
    _changed = true;
    notifyListeners();
  }

  void setGeneration(int generation) {
    _generation = generation;
    _changed = true;
    notifyListeners();
  }

  void setChronicle(String chronicle) {
    _chronicle = chronicle;
    _changed = true;
    notifyListeners();
  }

  void setConcept(String concept) {
    _concept = concept;
    _changed = true;
    notifyListeners();
  }

  void setSire(String sire) {
    _sire = sire;
    _changed = true;
    notifyListeners();
  }
}
