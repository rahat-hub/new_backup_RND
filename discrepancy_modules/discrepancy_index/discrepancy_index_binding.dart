import 'package:get/get.dart';

import 'discrepancy_index_logic.dart';

class DiscrepancyIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscrepancyIndexLogic());
  }
}
