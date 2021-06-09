import 'package:get/get.dart';

enum AttributeColumnType { Physical, Mental, Social }

// TODO: it builds. Carry on from here
class AttributesController extends GetxController {
  RxList<Attribute> physicalAttributes = RxList<Attribute>();
  RxList<Attribute> socialAttributes = RxList<Attribute>();
  RxList<Attribute> mentalAttributes = RxList<Attribute>();

  final Map<AttributeColumnType, String> _headers = {
    AttributeColumnType.Physical: 'Physical',
    AttributeColumnType.Mental: 'Mental',
    AttributeColumnType.Social: 'Social',
  };

  void initializeFromConstants() {
    physicalAttributes.value = PhysicalAttributesColumn().attributes;
    socialAttributes.value = SocialAttributesColumn().attributes;
    mentalAttributes.value = MentalAttributesColumn().attributes;
  }

  String getHeaderByType(AttributeColumnType type) => _headers[type]!;

  RxList<Attribute> getColumnByType(AttributeColumnType type) {
    switch (type) {
      case AttributeColumnType.Physical:
        return physicalAttributes;
      case AttributeColumnType.Mental:
        return mentalAttributes;
      case AttributeColumnType.Social:
        return socialAttributes;
    }
  }
}

class Attribute {
  Attribute(
      {required this.name,
      this.current = 1,
      this.min = 0,
      this.max = 5,
      this.specialization = "",
      this.description = ""});
  String name;
  int current;
  int min;
  int max;
  String specialization;
  String description;
}

class PhysicalAttributesColumn {
  final header = "Physical";

  final List<Attribute> attributes = [
    Attribute(name: "Strength", current: 1),
    Attribute(
        name: "Dexterity", current: 5, specialization: "Lightning Reflexes"),
    Attribute(name: "Stamina", current: 2),
  ];
}

class SocialAttributesColumn {
  final header = "Social";

  var attributes = [
    Attribute(name: "Charisma", current: 1),
    Attribute(name: "Manipulation", current: 1),
    Attribute(name: "Appearance", current: 4),
  ];
}

class MentalAttributesColumn {
  final header = "Mental";

  var attributes = [
    Attribute(name: "Perception", current: 1),
    Attribute(
        name: "Intelligence",
        current: 5,
        specialization: "Analytical Thinking"),
    Attribute(name: "Wits", current: 4, specialization: "Adapt to others")
  ];
}
