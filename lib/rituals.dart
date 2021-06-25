import 'package:get/get.dart';

class Ritual {
  Ritual({
    required this.name,
    this.level = 1,
    this.description = "",
    this.system = "",
  });
  final int level;
  final String name;
  final String description;
  final String system;
}

class RitualController extends GetxController {
  RxList<Ritual> rituals = RxList();
}
// Ritual ritualLupine = Ritual(
//   name: "Scent of the Lupine’s Passing",
//   level: 1,
//   description:
//       "Developed in a besieged Carpathian chantry where Tremere fell as often to the claws of night-black Lupines as to the other clans, this simple ritual lets the caster scent Lupines in the area. The Thaumaturge prepares a small herbal bundle with milkweed, wolfs bane, sage and a handful of simple grass. With a short set of phrases she takes a whiff of the mixture, after which she can immediately tell any Lupine by scent. This does not mean that she can detect lupine at a distance, merely that she can tell if a specific person’s smell happens to be Lupine, which can be useful when combined with augmented senses.",
//   system:
//       "The Thaumaturge simply completes the ritual and sniffs from the herbal bundle. Afterward, she can detect Lupines by scent; actually sniffing someone up close would require no roll, but catching a scent at a distance of a few feet might take a Perception + Alertness roll (Diff 6). Detecting a lupine hidden around a corner, for example, could increase the difficulty to 8. This scent distinction lasts for an entire scene.",
// );

// Ritual ritualEncrypt = Ritual(
//   name: "Encrypt Missive",
//   level: 1,
//   description:
//       "To insure that messages remain secure against prying eyes, the Tremere sometimes use this ritual the encode documents magically. Created during nights long past to send messages across battle lines or hostile borders, this ritual is not used as often in the age of electronic communications, but is occasionally used to communicate between chantries. Also, this is a fairly common ritual – many anarchs of the Anarch Free State seem to have learned it, and use it to encrypt graffiti messages to others of their kind.",
//   system:
//       "The Thaumaturge writes the message in blood over the course of a night and speaks the name of the person he wishes to read it. Only the writer and the person to whom the letter is addressed can read the document, but numerous “counter-rituals” exist that can be used to confound the magic of this ritual. To any others who observe the letter, the writing simply appears as gibberish.",
// );

// Ritual ritualDonTheMaskOfShadows = Ritual(
//     name: "Donning the Mask of Shadows",
//     level: 2,
//     description:
//         "This Ritual renders its subject translucent, her form appearing dark and Smokey and the sounds of her footsteps muffled. While it does not create true invisibility, the mask of shadows makes the subject much less likely to be detected by sight or hearing.",
//     system:
//         "This ritual may be simultaneously cast on a number of subjects equal to the casters Occult rating; each individual past the first adds 5 min to the base casting time. Individuals under the mask of shadows can only be detected if the observer succeeds in a perception+Awareness roll (difficulty = casters wits + Occult) or if the observer possesses a power (i.e. Auspex) to penetrate level 3 Obfuscate (ACTIVE). The mask of shadows lasts a number of hours equal to the number of successes rolled when it is cast or until the caster lowers it.");