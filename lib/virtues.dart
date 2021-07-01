import 'package:get/get.dart';

class VirtuesController extends GetxController {
  var consience = 2.obs;
  var selfControl = 3.obs;
  var courage = 5.obs;

  var additionalHumanity = 0.obs;
  var additionalWillpower = 5.obs;

  int get humanity =>
      consience.value + selfControl.value + additionalHumanity.value;
  int get willpower => courage.value + additionalWillpower.value;

  void load(Map<String, dynamic> json) {
    consience.value = json["consience"] ?? 0;
    selfControl.value = json["self_control"] ?? 0;
    courage.value = json["courage"] ?? 0;

    additionalHumanity.value = json["additional_humanity"] ?? 0;
    additionalWillpower.value = json["additional_willpower"] ?? 0;
  }

  Map<String, dynamic> save() {
    Map<String, dynamic> json = Map();
    json["consience"] = consience.value;
    json["self_control"] = selfControl.value;
    json["courage"] = courage.value;

    json["additional_humanity"] = additionalHumanity.value;
    json["additional_willpower"] = additionalWillpower.value;
    return json;
  }
}
