import 'package:aviation_rnd/modules/mel_modules/mel_index/mel_index_logic.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MelIndexDeviceView extends GetView<MelIndexLogic> {
  const MelIndexDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelIndexLogic>();

    return Obx(() {
      return controller.isLoading.isFalse
          ? PopScope(
              onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
              child: Scaffold(
                  appBar: AppbarConstant.customAppBar(context: context, title: "Minimum Equipment List (MEL)", backTap: () => Get.back()),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.all(6.0),
                        child: GetBuilder(init: MelIndexLogic(), builder: (controller) => controller.returnMelIndexView()),
                      ),
                    ),
                  )),
            )
          : const SizedBox();
    });
  }
}
