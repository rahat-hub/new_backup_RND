import 'package:aviation_rnd/modules/mel_modules/mel_edit/mel_edit_logic.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'layer/view_mel_edit.dart';

class MelEditMobilePortrait extends GetView<MelEditLogic> {
  const MelEditMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          EasyLoading.dismiss();
          if (!didPop) {
            Get.offNamed(Routes.melDetails, parameters: {
              "melId": Get.parameters["melId"].toString(),
              "melType": Get.parameters["melType"].toString(),
            });
          }
        },
        child: Obx(() {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppbarConstant.customAppBar(
              context: Get.context!,
              title: "Edit MEL For Aircraft: ${controller.melEditData["aircraftName"] ?? ""} [${controller.melEditData["serialNumber"] ?? ""}]",
              centerTitle: true,
              menuEnable: false,
              actionEnable: false,
              backButtonEnable: true,
              backTap: () {
                Get.offNamed(Routes.melDetails, parameters: {
                  "melId": Get.parameters["melId"].toString(),
                  "melType": Get.parameters["melType"].toString(),
                });
              },
            ),
            body: SafeArea(
              child: Obx(() {
                return controller.isLoading.isFalse
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  color: ColorConstants.primary,
                                  height: 50,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Row(children: [
                                    Icon(Icons.arrow_back, size: 30, color: Colors.white),
                                    Text("Back[Aircraft] MEL List", style: TextStyle(color: Colors.white)),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                            MelEditView().editMelDataMobileViewReturn(controller),
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                            if (controller.saveAndUploadButtonShow.value)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    color: ColorConstants.primary,
                                    height: 50,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      controller.melEditPostData["isUpload"] = true;

                                      if (controller.electronicSignatureEnable.value == true) {
                                  controller.melElectronicSignatureDialog();
                                } else {
                                  controller.postCallForMelDataChange();
                                }
                              },
                              child: const Row(
                                  children: [Icon(Icons.cloud_upload, size: 30, color: Colors.white), Text("Save MEL Changes & Upload", style: TextStyle(color: Colors.white)),
                                  ]),),
                          ],), const SizedBox(height: SizeConstants.contentSpacing), Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        MaterialButton(color: ColorConstants.primary,
                          height: 50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            controller.melEditPostData["isUpload"] = false;
                            if (controller.electronicSignatureEnable.value == true) {
                              controller.melElectronicSignatureDialog();
                            } else {
                              controller.postCallForMelDataChange();
                            }
                          },
                          child: const Row(children: [Icon(Icons.save_outlined, size: 30, color: Colors.white), Text("Save MEL Changes", style: TextStyle(color: Colors.white)),
                          ]),),
                      ],), const SizedBox(height: SizeConstants.contentSpacing + 5),
                    ],),)
                    : const SizedBox();
              }),
            ),
          );
        }));
  }
}

class MelEditMobileLandscape extends GetView<MelEditLogic> {
  const MelEditMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          EasyLoading.dismiss();
          if (!didPop) {
            Get.offNamed(Routes.melDetails, parameters: {
              "melId": Get.parameters["melId"].toString(),
              "melType": Get.parameters["melType"].toString(),
            });
          }
        },
        child: Obx(() {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppbarConstant.customAppBar(
              context: Get.context!,
              title: "Edit MEL For Aircraft: ${controller.melEditData["aircraftName"] ?? ""} [${controller.melEditData["serialNumber"] ?? ""}]",
              centerTitle: true,
              menuEnable: false,
              actionEnable: false,
              backButtonEnable: true,
              backTap: () {
                Get.offNamed(Routes.melDetails, parameters: {
                  "melId": Get.parameters["melId"].toString(),
                  "melType": Get.parameters["melType"].toString(),
                });
              },
            ),
            body: SafeArea(
              child: Obx(() {
                return controller.isLoading.isFalse
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  color: ColorConstants.primary,
                                  height: 50,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Row(children: [
                                    Icon(Icons.arrow_back, size: 30, color: Colors.white),
                                    Text("Back[Aircraft] MEL List", style: TextStyle(color: Colors.white)),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                            MelEditView().editMelDataMobileViewReturn(controller),
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                            Row(
                              mainAxisAlignment: controller.saveAndUploadButtonShow.value != false ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                              children: [
                                if (controller.saveAndUploadButtonShow.value)
                                  MaterialButton(
                                    color: ColorConstants.primary,
                                    height: 50,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      controller.melEditPostData["isUpload"] = true;

                                      if (controller.electronicSignatureEnable.value == true) {
                                  controller.melElectronicSignatureDialog();
                                } else {
                                  controller.postCallForMelDataChange();
                                }
                              },
                              child: const Row(
                                  children: [Icon(Icons.cloud_upload, size: 30, color: Colors.white), Text("Save MEL Changes & Upload", style: TextStyle(color: Colors.white)),
                                  ]),),
                          MaterialButton(color: ColorConstants.primary,
                            height: 50,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              controller.melEditPostData["isUpload"] = false;

                                    if (controller.electronicSignatureEnable.value == true) {
                                      controller.melElectronicSignatureDialog();
                                    } else {
                                      controller.postCallForMelDataChange();
                                    }
                                  },
                                  child: const Row(children: [
                                    Icon(Icons.save_outlined, size: 30, color: Colors.white),
                                    Text("Save MEL Changes", style: TextStyle(color: Colors.white)),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeConstants.contentSpacing + 10),
                          ],
                        ),
                      )
                    : const SizedBox();
              }),
            ),
          );
        }));
  }
}
