import 'package:get/get.dart';

import 'view_user_form_logic.dart';

class ViewUserFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewUserFormLogic());
  }
}
