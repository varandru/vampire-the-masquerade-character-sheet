import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'defs.dart';

enum AbilityColumnType { Talents, Skills, Knowledges }

final talentsAbilitiesProvider =
    StateProvider<TalentsAbilitiesColumn>((ref) => TalentsAbilitiesColumn());

final skillsAbilitiesProvider =
    StateProvider<SkillsAbilitiesColumn>((ref) => SkillsAbilitiesColumn());

final knowledgeAbilitiesProvider = StateProvider<KnowledgeAbilitiesColumn>(
    (ref) => KnowledgeAbilitiesColumn());

class AbilitiesSectionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Column(
      children: [
        Text("Abilities", style: Theme.of(context).textTheme.headline4),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            AbilitiesColumnWidget(AbilityColumnType.Talents),
            AbilitiesColumnWidget(AbilityColumnType.Skills),
            AbilitiesColumnWidget(AbilityColumnType.Knowledges),
          ],
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class TalentsAbilitiesColumn {
  final header = "Talents";

  var attributes = [
    Attribute(name: "Alertness", current: 2),
    Attribute(name: "Athletics", current: 0),
    Attribute(name: "Brawl", current: 0),
    Attribute(name: "Dodge", current: 3),
    Attribute(name: "Empathy", current: 0),
    Attribute(name: "Expression", current: 0),
    Attribute(name: "Intimidation", current: 0),
    Attribute(name: "Leadership", current: 0),
    Attribute(name: "Streetwise", current: 0),
    Attribute(name: "Subterfuge", current: 0),
  ];
}

class SkillsAbilitiesColumn {
  final header = "Skills";

  var attributes = [
    Attribute(name: "Animal", current: 0),
    Attribute(name: "Crafts", current: 0),
    Attribute(name: "Drive", current: 0),
    Attribute(name: "Etiquette", current: 0),
    Attribute(name: "Firearms", current: 3),
    Attribute(name: "Melee", current: 0),
    Attribute(name: "Performance", current: 0),
    Attribute(name: "Security", current: 3),
    Attribute(name: "Stealth", current: 3),
    Attribute(name: "Survival", current: 0),
  ];
}

class KnowledgeAbilitiesColumn {
  final header = "Knowledges";

  var attributes = [
    Attribute(name: "Academics", current: 0),
    Attribute(
        name: "Computers", current: 4, specialization: "Passwords Hacking"),
    Attribute(name: "Finance", current: 0),
    Attribute(name: "Investigation", current: 3),
    Attribute(name: "Law", current: 0),
    Attribute(name: "Linguistics", current: 2),
    Attribute(name: "Medicine", current: 2),
    Attribute(name: "Occult", current: 3),
    Attribute(name: "Politics", current: 0),
    Attribute(name: "Science", current: 0),
  ];
}

class AbilitiesColumnWidget extends ConsumerWidget {
  AbilitiesColumnWidget(AbilityColumnType type) : _type = type;

  final _type;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String header = "";
    List<Attribute> attributes = [];

    switch (_type) {
      case AbilityColumnType.Talents:
        header = watch(talentsAbilitiesProvider).state.header;
        attributes = watch(talentsAbilitiesProvider).state.attributes;
        break;
      case AbilityColumnType.Skills:
        header = watch(skillsAbilitiesProvider).state.header;
        attributes = watch(skillsAbilitiesProvider).state.attributes;
        break;
      case AbilityColumnType.Knowledges:
        header = watch(knowledgeAbilitiesProvider).state.header;
        attributes = watch(knowledgeAbilitiesProvider).state.attributes;
        break;
    }

    List<Widget> column = [
      Text(
        header,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    for (var attr in attributes) {
      column.add(AttributeWidget(attribute: attr));
    }

    return Column(
      children: column,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
