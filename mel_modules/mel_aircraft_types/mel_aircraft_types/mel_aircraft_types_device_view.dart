import 'package:aviation_rnd/modules/mel_modules/mel_aircraft_types/mel_aircraft_types_logic.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MelAircraftTypesDeviceView extends GetView<MelAircraftTypesLogic> {
  const MelAircraftTypesDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelAircraftTypesLogic>();

    return PopScope(
        onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppbarConstant.customAppBar(
              context: Get.context!,
              title: "MEL -Aircraft Types",
              centerTitle: true,
              menuEnable: false,
              actionEnable: false,
              backButtonEnable: true,
              textScrollForLongTitleMobile: true,
              backTap: () => Get.back()),
          body: SafeArea(
            child: Obx(() {
              return controller.isLoading.isFalse
                  ? RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(Duration.zero, () async {
                          controller.onInit();
                          controller.update();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: controller.viewReturnForMelAircraftTypes(),
                      ),
                    )
                  : const SizedBox();
            }),
          ),
        ));
  }
}
