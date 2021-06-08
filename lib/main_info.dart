import 'package:flutter/material.dart';

import 'defs.dart';
import 'main_info_logic.dart';

class CommonCharacterInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0.0,
      runSpacing: 0.0,
      children: [
        MainInfoWidget(MainInfoFieldType.CharacterName),
        MainInfoWidget(MainInfoFieldType.PlayerName),
        MainInfoWidget(MainInfoFieldType.Chronicle),
        MainInfoWidget(MainInfoFieldType.Nature),
        MainInfoWidget(MainInfoFieldType.Demeanor),
        MainInfoWidget(MainInfoFieldType.Concept),
        MainInfoWidget(MainInfoFieldType.Clan),
        MainInfoWidget(MainInfoFieldType.Generation),
        MainInfoWidget(MainInfoFieldType.Sire),
      ],
    );
  }
}
