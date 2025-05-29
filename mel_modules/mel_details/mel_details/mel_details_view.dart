import 'package:aviation_rnd/modules/mel_modules/mel_details/mel_details_logic.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MelDetailsView extends GetView<MelDetailsLogic> {
  const MelDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelDetailsLogic>();

    return PopScope(
        onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
        child: Obx(() {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppbarConstant.customAppBar(
                context: Get.context!,
                title: "MEL Details For Aircraft: ${controller.melDetailsData["aircraftName"] ?? ""} [${controller.melDetailsData["serialNumber"] ?? ""}]",
                centerTitle: true,
                menuEnable: false,
                actionEnable: false,
                backButtonEnable: true,
                backTap: () => Get.back()),
            body: SafeArea(
              child: Obx(() {
                return controller.isLoading.isFalse
                    ? RefreshIndicator(
                        onRefresh: () {
                          return Future.delayed(Duration.zero, () async {
                            await controller.melDetailsApiCall(refresh: true);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: ListView(
                            children: [
                              const SizedBox(height: SizeConstants.contentSpacing - 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    color: ColorConstants.primary,
                                    height: 50,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      Get.offNamed(Routes.melEdit, parameters: {
                                        "melId": Get.parameters["melId"].toString(),
                                        "melType": Get.parameters["melType"].toString(),
                                      });
                                    },
                                    child: Row(children: [
                                      const Icon(Icons.edit_document, size: SizeConstants.contentSpacing * 3 + 5, color: Colors.white),
                                      Text("  Edit MEL  ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 4,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2)),
                                    ]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: SizeConstants.contentSpacing - 5),
                              DeviceType.isTablet ? controller.melDetailsViewTablet() : controller.melDetailsViewMobile(),
                              const SizedBox(height: SizeConstants.contentSpacing - 5),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              }),
            ),
          );
        }));
  }
}
