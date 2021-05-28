import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vampire_the_masquerade_character_sheet/defs.dart';

final mainInfoProvider = StateProvider<MainInfo>((ref) {
  return MainInfo();
});

final mainInfoCharacterNameProvider = StateProvider<String>(
    (ref) => ref.watch(mainInfoProvider).state.characterName);
final mainInfoPlayerNameProvider = StateProvider<String>(
    (ref) => ref.watch(mainInfoProvider).state.playerName);
final mainInfoChronicleProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.chronicle);
final mainInfoNatureProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.nature);
final mainInfoDemeanorProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.demeanor);
final mainInfoConceptProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.concept);
final mainInfoClanProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.clan);
final mainInfoGenerationProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.nature);
final mainInfoSireProvider =
    StateProvider<String>((ref) => ref.watch(mainInfoProvider).state.sire);

class CommonCharacterInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0.0,
      runSpacing: 0.0,
      children: [
        MainInfoWidget(mainInfoCharacterNameProvider),
        MainInfoWidget(mainInfoPlayerNameProvider),
        MainInfoWidget(mainInfoChronicleProvider),
        MainInfoWidget(mainInfoNatureProvider),
        MainInfoWidget(mainInfoDemeanorProvider),
        MainInfoWidget(mainInfoConceptProvider),
        MainInfoWidget(mainInfoClanProvider),
        MainInfoWidget(mainInfoGenerationProvider),
        MainInfoWidget(mainInfoSireProvider),
      ],
    );
  }
}

class MainInfo {
  MainInfo({
    String characterName = "Noah Brendel",
    String nature = "Perfectionist",
    String clan = "Tremere",
    String playerName = "Vladimir Aranovskiy",
    String demeanor = "Perfectionist",
    int generation = 10,
    String chronicle = "?",
    String concept = "Intellectual",
    String sire = "Lawrence",
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
  }

  void setNature(String nature) {
    _nature = nature;
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
