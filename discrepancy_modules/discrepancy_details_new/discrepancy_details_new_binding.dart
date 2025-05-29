import 'package:get/get.dart';

import 'discrepancy_details_new_logic.dart';

class DiscrepancyDetailsNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscrepancyDetailsNewLogic());
  }
}
