import 'package:get/get.dart';

import 'mel_details_logic.dart';

class MelDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MelDetailsLogic());
  }
}
