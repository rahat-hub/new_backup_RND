import 'package:get/get.dart';

import 'discrepancy_edit_and_create_logic.dart';

class DiscrepancyEditAndCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscrepancyEditAndCreateLogic());
  }
}
