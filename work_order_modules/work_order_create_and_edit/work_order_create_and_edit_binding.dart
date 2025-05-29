import 'package:get/get.dart';

import 'work_order_create_and_edit_logic.dart';

class WorkOrderCreateAndEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkOrderCreateAndEditLogic());
  }
}
