import 'package:get/get.dart';

import 'mel_edit_logic.dart';

class MelEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MelEditLogic());
  }
}
