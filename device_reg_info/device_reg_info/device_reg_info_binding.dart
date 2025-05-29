import 'package:get/get.dart';

import 'device_reg_info_logic.dart';

class DeviceRegInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeviceRegInfoLogic());
  }
}
