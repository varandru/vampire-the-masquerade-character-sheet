import 'package:flutter/material.dart';

enum ConcealmentType { Pocket, Jacket, Trenchcoat, NotConcealed }

String concealmentShort(ConcealmentType type) {
  switch (type) {
    case ConcealmentType.Pocket:
      return "P";
    case ConcealmentType.Jacket:
      return "J";
    case ConcealmentType.Trenchcoat:
      return "T";
    case ConcealmentType.NotConcealed:
      return "N";
  }
}

String concealmentLong(ConcealmentType type) {
  switch (type) {
    case ConcealmentType.Pocket:
      return "Pocket";
    case ConcealmentType.Jacket:
      return "Jacket";
    case ConcealmentType.Trenchcoat:
      return "Trenchcoat";
    case ConcealmentType.NotConcealed:
      return "Not concealed";
  }
}

class MeleeWeapon {
  MeleeWeapon(this.name,
      {this.damageToStr = 0,
      this.concealmentType = ConcealmentType.NotConcealed,
      this.special = ""});

  final String name;
  final int damageToStr;
  final ConcealmentType concealmentType;
  final String special;
}

TableRow buildMeleeWeaponRow(MeleeWeapon weapon) {
  return TableRow(children: [
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(weapon.name + (weapon.special.isNotEmpty ? "*" : ""))),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("STR+" + weapon.damageToStr.toString(),
            textAlign: TextAlign.center)),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(concealmentLong(weapon.concealmentType),
            textAlign: TextAlign.center))
  ]);
}

class RangedWeapon {
  RangedWeapon(this.name,
      {this.damage = 0,
      this.range = 0,
      this.rate = 0,
      this.clip = 0,
      this.canHoldInChamber = false,
      this.concealmentType = ConcealmentType.NotConcealed,
      this.special = ""});

  final String name;
  final int damage;
  final int range;
  final int rate;
  final int clip;
  final bool canHoldInChamber;
  final ConcealmentType concealmentType;
  final String special;
}

TableRow buildRangedWeaponRow(RangedWeapon weapon) {
  return TableRow(children: [
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(weapon.name + (weapon.special.isNotEmpty ? "*" : ""))),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(weapon.damage.toString(), textAlign: TextAlign.center)),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(weapon.range.toString(), textAlign: TextAlign.center)),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(weapon.rate.toString(), textAlign: TextAlign.center)),
    TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(
          weapon.clip.toString() + (weapon.canHoldInChamber ? "+1" : ""),
          textAlign: TextAlign.center),
    ),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(concealmentShort(weapon.concealmentType),
            textAlign: TextAlign.center))
  ]);
}

class Armor {
  Armor(this.name, {this.armor = 0, this.dexPenalty = 0});

  final String name;
  final int armor;
  final int dexPenalty;
}

TableRow buildArmorRow(Armor armor) {
  return TableRow(children: [
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(armor.name)),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(armor.armor.toString(), textAlign: TextAlign.center)),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(armor.dexPenalty.toString(), textAlign: TextAlign.center)),
  ]);
}

class WeaponsAndArmorSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<TableRow> armorRows = [];
    List<TableRow> meleeRows = [];
    List<TableRow> rangedRows = [];

    // Armor
    armorRows.add(TableRow(children: [
      Text(
        "Name",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Armor",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Penalty",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ]));

    // Melee
    meleeRows.add(TableRow(children: [
      Text(
        "Name",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Damage",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Conceal",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ]));

    // Ranged
    rangedRows.add(TableRow(children: [
      Text(
        "Type - Example",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Damage",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Range",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Rate",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Clip",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Conceal",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ]));

    armorRows.add(
        buildArmorRow(Armor("Reinforced clothing", armor: 1, dexPenalty: 0)));
    armorRows
        .add(buildArmorRow(Armor("Armor T-shirt", armor: 2, dexPenalty: 1)));
    armorRows.add(buildArmorRow(Armor("Kevlar vest", armor: 3, dexPenalty: 1)));
    armorRows.add(buildArmorRow(Armor("Flak jacket", armor: 4, dexPenalty: 2)));
    armorRows
        .add(buildArmorRow(Armor("Full riot gear", armor: 5, dexPenalty: 3)));

    meleeRows.add(buildMeleeWeaponRow(MeleeWeapon("Saps (+)",
        damageToStr: 1, concealmentType: ConcealmentType.Pocket)));
    meleeRows.add(buildMeleeWeaponRow(MeleeWeapon("Clubs (+)",
        damageToStr: 2, concealmentType: ConcealmentType.Trenchcoat)));
    meleeRows.add(buildMeleeWeaponRow(MeleeWeapon("Knives",
        damageToStr: 1, concealmentType: ConcealmentType.Jacket)));
    meleeRows.add(buildMeleeWeaponRow(MeleeWeapon("Swords",
        damageToStr: 3, concealmentType: ConcealmentType.Trenchcoat)));
    meleeRows.add(buildMeleeWeaponRow(MeleeWeapon("Large Ax",
        damageToStr: 3, concealmentType: ConcealmentType.NotConcealed)));
    meleeRows.add(buildMeleeWeaponRow(MeleeWeapon("Stake (*)",
        damageToStr: 1, concealmentType: ConcealmentType.Trenchcoat)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Revolver, Lt.",
        damage: 4,
        range: 12,
        rate: 3,
        clip: 6,
        canHoldInChamber: false,
        concealmentType: ConcealmentType.Pocket)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Revolver, Heavy",
        damage: 6,
        range: 35,
        rate: 2,
        clip: 6,
        canHoldInChamber: false,
        concealmentType: ConcealmentType.Jacket)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Pistol, Lt.",
        damage: 4,
        range: 20,
        rate: 4,
        clip: 17,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.Pocket)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Pistol, Heavy.",
        damage: 5,
        range: 30,
        rate: 3,
        clip: 7,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.Jacket)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Rifle",
        damage: 8,
        range: 200,
        rate: 1,
        clip: 30,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.NotConcealed)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("SMG, Small",
        damage: 4,
        range: 25,
        rate: 3,
        clip: 30,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.Jacket,
        special:
            "The weapon is capable of three-round bursts, full-auto and strafing.")));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("SMG, Large",
        damage: 4,
        range: 50,
        rate: 3,
        clip: 30,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.Trenchcoat,
        special:
            "The weapon is capable of three-round bursts, full-auto and strafing.")));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Assault Rifle",
        damage: 7,
        range: 150,
        rate: 3,
        clip: 42,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.NotConcealed,
        special:
            "The weapon is capable of three-round bursts, full-auto and strafing.")));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Shotgun",
        damage: 8,
        range: 20,
        rate: 1,
        clip: 5,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.Trenchcoat)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Shotgun, semi-auto",
        damage: 8,
        range: 20,
        rate: 3,
        clip: 8,
        canHoldInChamber: true,
        concealmentType: ConcealmentType.Trenchcoat)));

    rangedRows.add(buildRangedWeaponRow(RangedWeapon("Crossbow",
        damage: 5,
        range: 20,
        rate: 1,
        clip: 1,
        canHoldInChamber: false,
        concealmentType: ConcealmentType.Trenchcoat,
        special:
            "Crossbows require five turns to reload. A character may use a crossbow to attempt to stake a creature with a targeted shot.")));

    return ListView(
      children: [
        Text("Armor", style: Theme.of(context).textTheme.headline4),
        Table(
          defaultColumnWidth: FlexColumnWidth(),
          children: armorRows,
        ),
        Text("Melee Weapons", style: Theme.of(context).textTheme.headline4),
        Table(
          children: meleeRows,
        ),
        Text("Ranged Weapons", style: Theme.of(context).textTheme.headline4),
        Table(
          defaultColumnWidth: FlexColumnWidth(),
          children: rangedRows,
        ),
      ],
    );
  }
}
