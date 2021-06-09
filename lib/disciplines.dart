// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'defs.dart';

// class DisciplinesSectionWidget extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     Discipline discipline = Discipline(
//       name: "Thaumaturgy (Path of Blood)",
//       level: 4,
//       max: 5,
//       description:
//           "Created by exhaustive research and extensive experimentation, Thaumaturgy utilizes the principles of Hermetic magic used by House Tremere when it was still a cabal of mages, adapted to be fuelled by the inherent magical power of Vitae rather than Quintessence. While it is certainly powerful and versatile, it is organized very differently to the Spheres; Thaumaturgy is largely unknown to mages, and universally distrusted and reviled by those who have encountered it.",
//     );

//     discipline.levels.add(
//       DisciplineDot(
//           level: 1,
//           name: "A Taste for Blood",
//           description:
//               "This power was developed as a means of testing a foe's might an extremely important ability in the tumultuous early nights of Clan Tremere. By merely tasting the blood of his subject, the thaumaturge may determine how much vitae remains in the subject and, if the subject is a vampire, how recently he has fed, his approximate generation and, with three or more successes, whether he has recently committed diablerie.",
//           system:
//               "The number of successes achieved on the roll determines how much information the thaumaturge gleans and how accurate it is."),
//     );

//     discipline.levels.add(
//       DisciplineDot(
//           level: 2,
//           name: "Blood Rage",
//           description:
//               "This power allows a vampire to force another Kindred to expend blood against his will. The thaumaturge must touch her subject for this power to work; though only the lightest contact is necessary. A vampire affected by this power might feel a physical rush as the thaumaturge heightens his Physical Attributes, or may even find him elf on the brink of frenzy as his stores of vitae are mystically depleted.",
//           system:
//               "Each success forces the subject to spend one blood point immediately in the way the thaumaturge desires. Note that blood points forcibly spent in this manner may exceed the normal \"per turn\" maximum indicated by the victim's generation. Each success gained also increases the subject’s difficulty to resist frenzy by one."),
//     );

//     discipline.levels.add(
//       DisciplineDot(
//           level: 3,
//           name: "Blood of Potency",
//           description:
//               "The thaumaturge gains such control over his own blood that he may effectively \"concentrate\" it, making it more powerful for a short time. In effect, he may temporarily lower his own generation with this power. This power may be used only once per night.",
//           system:
//               " Successes earned on the Willpower roll must be spent both to decrease the vampire's generation and to maintain the change. One success allows the character to lower his generation by one step for one hour. Each success grants the Kindred either one step down in generation or one hour of effect. If the vampire is diablerized while this power is in effect, it wears off immediately and the diablerist gains power appropriate to the thaumaturge's actual generation. Furthermore, any mortals Embraced by the thaumaturge are born to the generation appropriate to their sire's original generation (e.g., a 10th-generation Tremere who has reduced his effective generation to eighth still produces 11th-generation childer).\nOnce the effect wears off, any blood over the character's blood pool maximum dilutes, leaving the character at his regular blood pool maximum. Thus, if a l2th-generation Tremere (maximum blood pool of 11) decreased his generation to ninth (maximum blood pool 14), ingested 14 blood points, and had this much vitae in his system when the power wore off, his blood pool would immediately drop to 11."),
//     );

//     discipline.levels.add(
//       DisciplineDot(
//           level: 4,
//           name: "Theft of Vitae",
//           description:
//               "A thaumaturge using this power siphons vitae from her subject. She need never come in contact with the subject blood literally streams out in a physical torrent from the subject to the Kindred (though it is often mystically absorbed and need not enter through the mouth).",
//           system:
//               "The number of successes determines how many blood points the Tremere transfers from the subject. The subject must be visible to the thaumaturge and within 50 feet. Using this power is like drinking from the subject - used three times on the same Kindred, it creates a blood bond on the part of the thaumaturge! This power is obviously quite spectacular, and Camarilla princes justifiably consider its public use a breach of the Masquerade."),
//     );

//     discipline.levels.add(
//       DisciplineDot(
//           level: 5,
//           name: "Cauldron of Blood",
//           description:
//               "A thaumaturge using this power boils her subject's blood in his veins like water on a stove. The Kindred must touch her subject, and it is this contact that simmers the subject's blood. This power is always fatal to mortals, and causes great damage to even the mightiest vampires.",
//           system:
//               "The number of successes gained determines how many blood points are brought to boil. The subject suffers one health level of aggravated damage for each point boiled (individuals with Fortitude may soak this damage using only their Fortitude dice). A single success kills any mortal, though some ghouls are said to have survived."),
//     );

//     Ritual ritualLupine = Ritual(
//       name: "Scent of the Lupine’s Passing",
//       level: 1,
//       description:
//           "Developed in a besieged Carpathian chantry where Tremere fell as often to the claws of night-black Lupines as to the other clans, this simple ritual lets the caster scent Lupines in the area. The Thaumaturge prepares a small herbal bundle with milkweed, wolfs bane, sage and a handful of simple grass. With a short set of phrases she takes a whiff of the mixture, after which she can immediately tell any Lupine by scent. This does not mean that she can detect lupine at a distance, merely that she can tell if a specific person’s smell happens to be Lupine, which can be useful when combined with augmented senses.",
//       system:
//           "The Thaumaturge simply completes the ritual and sniffs from the herbal bundle. Afterward, she can detect Lupines by scent; actually sniffing someone up close would require no roll, but catching a scent at a distance of a few feet might take a Perception + Alertness roll (Diff 6). Detecting a lupine hidden around a corner, for example, could increase the difficulty to 8. This scent distinction lasts for an entire scene.",
//     );

//     Ritual ritualEncrypt = Ritual(
//       name: "Encrypt Missive",
//       level: 1,
//       description:
//           "To insure that messages remain secure against prying eyes, the Tremere sometimes use this ritual the encode documents magically. Created during nights long past to send messages across battle lines or hostile borders, this ritual is not used as often in the age of electronic communications, but is occasionally used to communicate between chantries. Also, this is a fairly common ritual – many anarchs of the Anarch Free State seem to have learned it, and use it to encrypt graffiti messages to others of their kind.",
//       system:
//           "The Thaumaturge writes the message in blood over the course of a night and speaks the name of the person he wishes to read it. Only the writer and the person to whom the letter is addressed can read the document, but numerous “counter-rituals” exist that can be used to confound the magic of this ritual. To any others who observe the letter, the writing simply appears as gibberish.",
//     );

//     Ritual ritualDonTheMaskOfShadows = Ritual(
//         name: "Donning the Mask of Shadows",
//         level: 2,
//         description:
//             "This Ritual renders its subject translucent, her form appearing dark and Smokey and the sounds of her footsteps muffled. While it does not create true invisibility, the mask of shadows makes the subject much less likely to be detected by sight or hearing.",
//         system:
//             "This ritual may be simultaneously cast on a number of subjects equal to the casters Occult rating; each individual past the first adds 5 min to the base casting time. Individuals under the mask of shadows can only be detected if the observer succeeds in a perception+Awareness roll (difficulty = casters wits + Occult) or if the observer possesses a power (i.e. Auspex) to penetrate level 3 Obfuscate (ACTIVE). The mask of shadows lasts a number of hours equal to the number of successes rolled when it is cast or until the caster lowers it.");

//     return Column(
//       children: [
//         Text("Disciplines", style: Theme.of(context).textTheme.headline4),
//         Wrap(
//           alignment: WrapAlignment.center,
//           children: [
//             DisciplineWidget(discipline),
//           ],
//         ),
//         Text("Rituals", style: Theme.of(context).textTheme.headline4),
//         Wrap(
//           alignment: WrapAlignment.center,
//           children: [
//             RitualWidget(ritualLupine),
//             RitualWidget(ritualEncrypt),
//             RitualWidget(ritualDonTheMaskOfShadows),
//           ],
//         ),
//       ],
//       mainAxisSize: MainAxisSize.min,
//     );
//   }
// }

// // A widget for a single discipline, ExpansionTile
// class DisciplineWidget extends ConsumerWidget {
//   DisciplineWidget(Discipline discipline) : _discipline = discipline;

//   final _discipline;

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     List<Widget> disciplineDots = [];
//     for (int i = 0; i < _discipline.level; i++) {
//       disciplineDots.add(DisciplineDotWidget(dot: _discipline.levels[i]));
//     }

//     return ExpansionTile(
//       title: Text(_discipline.name),
//       trailing: Container(
//         constraints:
//             BoxConstraints(maxWidth: _discipline.max.toDouble() * 20.0),
//         child: NoTitleCounterWidget(
//           current: _discipline.level,
//           max: _discipline.max,
//         ),
//       ),
//       children: disciplineDots,
//     );
//   }
// }

// class Discipline {
//   Discipline(
//       {String name = "", int level = 1, String description = "", int max = 5})
//       : this.name = name,
//         this.description = description,
//         this.level = level,
//         this.max = max;
//   final String name;
//   final String description;

//   final int level;
//   final int max;

//   List<DisciplineDot> levels = [];
// }

// class DisciplineDotWidget extends StatelessWidget {
//   DisciplineDotWidget({required DisciplineDot dot}) : this.dot = dot;

//   final DisciplineDot dot;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 300.0),
//       child: ListTile(
//         title: Text(dot.name),
//         trailing: Container(
//           constraints: BoxConstraints(maxWidth: 20.0 * dot.max.toDouble()),
//           child: NoTitleCounterWidget(
//             current: dot.level,
//             max: dot.max,
//           ),
//         ),
//         onTap: () {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return SimpleDialog(
//                   title: Text(dot.name),
//                   children: [
//                     Text(
//                       "Description",
//                       style: Theme.of(context).textTheme.headline6,
//                     ),
//                     Text(dot.description),
//                     Text(
//                       "System",
//                       style: Theme.of(context).textTheme.headline6,
//                     ),
//                     Text(dot.system),
//                   ],
//                 );
//               }).then((value) => null);
//         },
//       ),
//     );
//   }
// }

// class DisciplineDot {
//   DisciplineDot(
//       {String name = "",
//       String system = "",
//       int level = 0,
//       int max = 5,
//       String description = ""})
//       : this.description = description,
//         this.name = name,
//         this.level = level,
//         this.system = system,
//         this.max = max;

//   final String name;
//   final String description;
//   final String system;

//   final int level;
//   final int max;
// }

// class Ritual {
//   Ritual({
//     required this.name,
//     this.level = 1,
//     this.description = "",
//     this.system = "",
//   });
//   final int level;
//   final String name;
//   final String description;
//   final String system;
// }

// class RitualWidget extends StatelessWidget {
//   RitualWidget(this._ritual);

//   final Ritual _ritual;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(_ritual.name),
//       trailing: Container(
//         constraints: BoxConstraints(maxWidth: 100.0),
//         child: NoTitleCounterWidget(
//           current: _ritual.level,
//           max: 5,
//         ),
//       ),
//       onTap: () {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return SimpleDialog(
//                 title: Text(_ritual.name),
//                 children: [
//                   Text(
//                     "Description",
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Text(_ritual.description),
//                   Text(
//                     "System",
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Text(_ritual.system),
//                 ],
//               );
//             }).then((value) => null);
//       },
//     );
//   }
// }
