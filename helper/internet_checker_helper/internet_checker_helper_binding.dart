import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:get/get.dart';

class InternetCheckerHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetCheckerHelperLogic(), permanent: true);
  }
}
