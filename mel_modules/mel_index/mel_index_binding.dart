import 'package:get/get.dart';

import 'mel_index_logic.dart';

class MelIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MelIndexLogic());
  }
}
