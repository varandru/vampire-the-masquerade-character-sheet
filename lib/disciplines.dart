import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'defs.dart';

class DisciplinesSectionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    Discipline discipline = Discipline(
      name: "Thaumaturgy (Path of Blood)",
      level: 4,
      max: 5,
      description:
          "Created by exhaustive research and extensive experimentation, Thaumaturgy utilizes the principles of Hermetic magic used by House Tremere when it was still a cabal of mages, adapted to be fuelled by the inherent magical power of Vitae rather than Quintessence. While it is certainly powerful and versatile, it is organized very differently to the Spheres; Thaumaturgy is largely unknown to mages, and universally distrusted and reviled by those who have encountered it.",
    );

    discipline.levels.add(
      DisciplineDot(
          level: 1,
          name: "A Taste for Blood",
          description:
              "This power was developed as a means of testing a foe's might an extremely important ability in the tumultuous early nights of Clan Tremere. By merely tasting the blood of his subject, the thaumaturge may determine how much vitae remains in the subject and, if the subject is a vampire, how recently he has fed, his approximate generation and, with three or more successes, whether he has recently committed diablerie.",
          system:
              "The number of successes achieved on the roll determines how much information the thaumaturge gleans and how accurate it is."),
    );

    discipline.levels.add(
      DisciplineDot(
          level: 2,
          name: "Blood Rage",
          description:
              "This power allows a vampire to force another Kindred to expend blood against his will. The thaumaturge must touch her subject for this power to work; though only the lightest contact is necessary. A vampire affected by this power might feel a physical rush as the thaumaturge heightens his Physical Attributes, or may even find him elf on the brink of frenzy as his stores of vitae are mystically depleted.",
          system:
              "Each success forces the subject to spend one blood point immediately in the way the thaumaturge desires. Note that blood points forcibly spent in this manner may exceed the normal \"per turn\" maximum indicated by the victim's generation. Each success gained also increases the subject’s difficulty to resist frenzy by one."),
    );

    discipline.levels.add(
      DisciplineDot(
          level: 3,
          name: "Blood of Potency",
          description:
              "The thaumaturge gains such control over his own blood that he may effectively \"concentrate\" it, making it more powerful for a short time. In effect, he may temporarily lower his own generation with this power. This power may be used only once per night.",
          system:
              " Successes earned on the Willpower roll must be spent both to decrease the vampire's generation and to maintain the change. One success allows the character to lower his generation by one step for one hour. Each success grants the Kindred either one step down in generation or one hour of effect. If the vampire is diablerized while this power is in effect, it wears off immediately and the diablerist gains power appropriate to the thaumaturge's actual generation. Furthermore, any mortals Embraced by the thaumaturge are born to the generation appropriate to their sire's original generation (e.g., a 10th-generation Tremere who has reduced his effective generation to eighth still produces 11th-generation childer).\nOnce the effect wears off, any blood over the character's blood pool maximum dilutes, leaving the character at his regular blood pool maximum. Thus, if a l2th-generation Tremere (maximum blood pool of 11) decreased his generation to ninth (maximum blood pool 14), ingested 14 blood points, and had this much vitae in his system when the power wore off, his blood pool would immediately drop to 11."),
    );

    discipline.levels.add(
      DisciplineDot(
          level: 4,
          name: "Theft of Vitae",
          description:
              "A thaumaturge using this power siphons vitae from her subject. She need never come in contact with the subject blood literally streams out in a physical torrent from the subject to the Kindred (though it is often mystically absorbed and need not enter through the mouth).",
          system:
              "The number of successes determines how many blood points the Tremere transfers from the subject. The subject must be visible to the thaumaturge and within 50 feet. Using this power is like drinking from the subject - used three times on the same Kindred, it creates a blood bond on the part of the thaumaturge! This power is obviously quite spectacular, and Camarilla princes justifiably consider its public use a breach of the Masquerade."),
    );

    discipline.levels.add(
      DisciplineDot(
          level: 5,
          name: "Cauldron of Blood",
          description:
              "A thaumaturge using this power boils her subject's blood in his veins like water on a stove. The Kindred must touch her subject, and it is this contact that simmers the subject's blood. This power is always fatal to mortals, and causes great damage to even the mightiest vampires.",
          system:
              "The number of successes gained determines how many blood points are brought to boil. The subject suffers one health level of aggravated damage for each point boiled (individuals with Fortitude may soak this damage using only their Fortitude dice). A single success kills any mortal, though some ghouls are said to have survived."),
    );

    return Column(
      children: [
        Text("Disciplines", style: Theme.of(context).textTheme.headline4),
        Wrap(
          children: [
            DisciplineWidget(discipline),
          ],
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

// A widget for a single discipline, ExpansionTile
class DisciplineWidget extends ConsumerWidget {
  DisciplineWidget(Discipline discipline) : _discipline = discipline;

  final _discipline;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<Widget> row = makeIconRow(_discipline.level, _discipline.max,
        Icons.circle, Icons.circle_outlined);
    row.insert(0, Spacer());
    row.add(Spacer());

    List<Widget> disciplineDots = [];
    for (int i = 0; i < _discipline.level; i++) {
      disciplineDots.add(DisciplineDotWidget(dot: _discipline.levels[i]));
    }

    return ExpansionTile(
      title: Text(_discipline.name),
      trailing: Container(
        constraints:
            BoxConstraints(maxWidth: _discipline.max.toDouble() * 20.0),
        child: NoTitleCounterWidget(
          current: _discipline.level,
          max: _discipline.max,
        ),
      ),
      children: disciplineDots,
    );
  }
}

class Discipline {
  Discipline(
      {String name = "", int level = 1, String description = "", int max = 5})
      : this.name = name,
        this.description = description,
        this.level = level,
        this.max = max;
  final String name;
  final String description;

  final int level;
  final int max;

  List<DisciplineDot> levels = [];
}

class DisciplineDotWidget extends StatelessWidget {
  DisciplineDotWidget({required DisciplineDot dot}) : this.dot = dot;

  final DisciplineDot dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300.0),
      child: ListTile(
        title: Text(dot.name),
        trailing: Container(
          constraints: BoxConstraints(maxWidth: 20.0 * dot.max.toDouble()),
          child: NoTitleCounterWidget(
            current: dot.level,
            max: dot.max,
          ),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text("Description"),
                  children: [
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(dot.description),
                    Text(
                      "System",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(dot.system),
                  ],
                );
              }).then((value) => null);
        },
      ),
    );
  }
}

class DisciplineDot {
  DisciplineDot(
      {String name = "",
      String system = "",
      int level = 0,
      int max = 5,
      String description = ""})
      : this.description = description,
        this.name = name,
        this.level = level,
        this.system = system,
        this.max = max;

  final String name;
  final String description;
  final String system;

  final int level;
  final int max;
}
