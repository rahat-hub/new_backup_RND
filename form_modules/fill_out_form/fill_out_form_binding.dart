import 'package:get/get.dart';

import 'fill_out_form_logic.dart';

class FillOutFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FillOutFormLogic());
  }
}
