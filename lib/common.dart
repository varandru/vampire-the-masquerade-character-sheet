import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'

class CommonCharacterInfo extends StatelessWidget {
  //TODO move these to provider, lul
  String characterName = "";
  String nature = "";
  String clan = "";
  String playerName = "";
  String demeanor = "";
  String generation = ""; // TODO: this is really an Int
  String chronicle = "";
  String concept = "";
  String sire = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Column(
            children: [
              // character name
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  characterName = text;
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
                  playerName = text;
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
                  chronicle = text;
                },
                decoration: InputDecoration(
                  helperText: "Chronicle",
                  hintText: "Chronicle",
                ),
              )),
// TODO remove
              Flexible(
                child: Attribute(
                  name: "Strength",
                ),
              ),
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
                  nature = text;
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
                  demeanor = text;
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
                  concept = text;
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
                  clan = text;
                },
                decoration: InputDecoration(
                  helperText: "Clan",
                  hintText: "Clan",
                ),
              )),
              // generation
              // TODO: make this a dropdown
              Flexible(
                  child: TextField(
                onChanged: (text) {
                  generation = text;
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
                  sire = text;
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

class Attribute extends StatefulWidget {
  Attribute(
      {Key? key,
      required String name,
      int currentValue = 0,
      int currentMax = 0,
      int max = 5})
      : this.name = name,
        this.currentValue = currentValue,
        this.currentMax = currentMax,
        this.max = max,
        super(key: key);

  final String name;
  final currentValue;
  final currentMax;
  final max;

  @override
  _AttributeState createState() => _AttributeState();
}

class _AttributeState extends State<Attribute> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(widget.name)],
    );
  }
}

// class AttributesWidget extends StatelessWidget {
//   //TODO move these to provider, lul

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Flexible(
//           child: Column(
//             children: [
//               // character name
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   characterName = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Name",
//                   hintText: "Character Name",
//                 ),
//               )),
//               // nature
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   playerName = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Player",
//                   hintText: "Player",
//                 ),
//               )),
//               // clan
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   chronicle = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Chronicle",
//                   hintText: "Chronicle",
//                 ),
//               )),
//             ],
//           ),
//         ),
//         Flexible(
//           child: Column(
//             children: [
//               // character name
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   nature = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Nature",
//                   hintText: "Nature",
//                 ),
//               )),
//               // nature
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   demeanor = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Demeanor",
//                   hintText: "Demeanor",
//                 ),
//               )),
//               // clan
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   concept = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Concept",
//                   hintText: "Concept",
//                 ),
//               )),
//             ],
//           ),
//         ),
//         Flexible(
//           child: Column(
//             children: [
//               // clan
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   clan = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Clan",
//                   hintText: "Clan",
//                 ),
//               )),
//               // generation
//               // TODO: make this a dropdown
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   generation = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Generation",
//                   hintText: "Generation",
//                 ),
//               )),
//               // clan
//               Flexible(
//                   child: TextField(
//                 onChanged: (text) {
//                   sire = text;
//                 },
//                 decoration: InputDecoration(
//                   helperText: "Sire",
//                   hintText: "Sire",
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
