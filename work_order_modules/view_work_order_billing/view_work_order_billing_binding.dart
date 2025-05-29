import 'package:get/get.dart';

import 'view_work_order_billing_logic.dart';

class ViewWorkOrderBillingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewWorkOrderBillingLogic());
  }
}
