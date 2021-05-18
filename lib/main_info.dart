import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainInfoProvider = StateProvider<MainInfo>((ref) => MainInfo());

class CommonCharacterInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //  I don't get WTF is happening. I think, MainInfo is available outside
    final mainInfo = watch(mainInfoProvider);
    // final characterName = watch(characterNameProvider);
    // final playerName = watch(playerNameProvider);
    // final chronicle = watch(chronicleProvider);
    // final nature = watch(natureProvider);
    // final demeanor = watch(demeanorProvider);
    // final concept = watch(conceptProvider);
    // final clan = watch(clanProvider);
    // final generation = watch(generationProvider);
    // final sire = watch(sireProvider);

    return Row(
      children: [
        Flexible(
          child: Column(
            children: [
              // character name
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setCharacterName(text);
                },
                decoration: InputDecoration(
                  helperText: "Name",
                  hintText: "Character Name",
                ),
              )),
              // nature
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setPlayerName(text);
                },
                decoration: InputDecoration(
                  helperText: "Player",
                  hintText: "Player",
                ),
              )),
              // clan
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setChronicle(text);
                },
                decoration: InputDecoration(
                  helperText: "Chronicle",
                  hintText: "Chronicle",
                ),
              )),
            ],
          ),
        ),
        Flexible(
          child: Column(
            children: [
              // character name
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setNature(text);
                },
                decoration: InputDecoration(
                  helperText: "Nature",
                  hintText: "Nature",
                ),
              )),
              // nature
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setDemeanor(text);
                },
                decoration: InputDecoration(
                  helperText: "Demeanor",
                  hintText: "Demeanor",
                ),
              )),
              // clan
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setConcept(text);
                },
                decoration: InputDecoration(
                  helperText: "Concept",
                  hintText: "Concept",
                ),
              )),
            ],
          ),
        ),
        Flexible(
          child: Column(
            children: [
              // clan
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setClan(text);
                },
                decoration: InputDecoration(
                  helperText: "Clan",
                  hintText: "Clan",
                ),
              )),
              // generation
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setGeneration(int.parse(text));
                },
                decoration: InputDecoration(
                  helperText: "Generation",
                  hintText: "Generation",
                ),
              )),
              // clan
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  mainInfo.state.setSire(text);
                },
                decoration: InputDecoration(
                  helperText: "Sire",
                  hintText: "Sire",
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class MainInfo {
  MainInfo({
    String characterName = "",
    String nature = "",
    String clan = "",
    String playerName = "",
    String demeanor = "",
    int generation = 13,
    String chronicle = "",
    String concept = "",
    String sire = "",
  })  : _characterName = characterName,
        _nature = nature,
        _clan = clan,
        _playerName = playerName,
        _demeanor = demeanor,
        _generation = generation,
        _chronicle = chronicle,
        _concept = concept,
        _sire = sire;

  String _characterName;
  String _nature;
  String _clan;
  String _playerName;
  String _demeanor;
  int _generation;
  String _chronicle;
  String _concept;
  String _sire;

  String get characterName => _characterName;
  String get nature => _nature;
  String get clan => _clan;
  String get playerName => _playerName;
  String get demeanor => _demeanor;
  int get generation => _generation;
  String get chronicle => _chronicle;
  String get concept => _concept;
  String get sire => _sire;

  void setCharacterName(String name) {
    _characterName = name;
    print("$_characterName");
  }

  void setNature(String nature) {
    _nature = nature;
    print(_nature);
  }

  void setClan(String clan) {
    _clan = clan;
  }

  void setPlayerName(String playerName) {
    _playerName = playerName;
  }

  void setDemeanor(String demeanor) {
    _demeanor = demeanor;
  }

  void setGeneration(int generation) {
    _generation = generation;
  }

  void setChronicle(String chronicle) {
    _chronicle = chronicle;
  }

  void setConcept(String concept) {
    _concept = concept;
  }

  void setSire(String sire) {
    _sire = sire;
  }
}
