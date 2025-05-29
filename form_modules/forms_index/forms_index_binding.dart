import 'package:get/get.dart';

import 'forms_index_logic.dart';

class FormsIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FormsIndexLogic());
  }
}
