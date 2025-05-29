import 'package:get/get.dart';

import 'file_edit_new_logic.dart';

class FileEditNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FileEditNewLogic());
  }
}