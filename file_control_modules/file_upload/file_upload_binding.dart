import 'package:get/get.dart';

import 'file_upload_logic.dart';

class FileUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FileUploadLogic());
  }
}
