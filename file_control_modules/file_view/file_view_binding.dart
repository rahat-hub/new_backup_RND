import 'package:get/get.dart';

import 'file_view_logic.dart';

class FileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FileViewLogic());
  }
}
