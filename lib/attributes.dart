import 'package:get/get.dart';
import 'common_logic.dart';

enum AttributeColumnType { Physical, Mental, Social }

class AttributesController extends GetxController {
  var attributeListFile = 'attributes.json';

  RxList<ComplexAbility> physicalAttributes = RxList<ComplexAbility>();
  RxList<ComplexAbility> socialAttributes = RxList<ComplexAbility>();
  RxList<ComplexAbility> mentalAttributes = RxList<ComplexAbility>();

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

  List<ComplexAbility> getColumnByType(AttributeColumnType type) {
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

//CRUTCH: constants for debugging and web
class PhysicalAttributesColumn {
  final header = "Physical";

  final List<ComplexAbility> attributes = [
    ComplexAbility(name: "Strength", current: 1),
    ComplexAbility(
        name: "Dexterity", current: 5, specialization: "Lightning Reflexes"),
    ComplexAbility(name: "Stamina", current: 2),
  ];
}

class SocialAttributesColumn {
  final header = "Social";

  var attributes = [
    ComplexAbility(name: "Charisma", current: 1),
    ComplexAbility(name: "Manipulation", current: 1),
    ComplexAbility(name: "Appearance", current: 4),
  ];
}

class MentalAttributesColumn {
  final header = "Mental";

  var attributes = [
    ComplexAbility(name: "Perception", current: 1),
    ComplexAbility(
        name: "Intelligence",
        current: 5,
        specialization: "Analytical Thinking"),
    ComplexAbility(name: "Wits", current: 4, specialization: "Adapt to others")
  ];
}
