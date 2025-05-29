import 'package:get/get.dart';

import 'mel_aircraft_types_logic.dart';

class MelAircraftTypesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MelAircraftTypesLogic());
  }
}
