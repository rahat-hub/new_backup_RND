import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_edit_and_create/discrepancy_edit_and_create_page/view_page_discrepancy_create.dart';
import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_edit_and_create/discrepancy_edit_and_create_page/view_page_discrepancy_edit.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../helper/loader_helper.dart';
import '../../../../widgets/discrepancy_and_work_order_widgets.dart';
import '../discrepancy_edit_and_create_logic.dart';

class DiscrepancyEditAndCreateViewPage extends GetView<DiscrepancyEditAndCreateLogic> {
  const DiscrepancyEditAndCreateViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DiscrepancyEditAndCreateLogic>();
    return Obx(() {
      return controller.isLoading.isFalse
          ? PopScope(
            onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
            child: Scaffold(
              appBar: AppbarConstant.customAppBar(context: context, title: controller.normalTileString['title'], backTap: () => Get.back()),
              body: SafeArea(
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            if (Get.parameters['action'] == 'discrepancyEdit')
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: ColorConstants.button.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Last Discovered By: ',
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: controller.discrepancyEditApiData['discoveredByName'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (DeviceType.isTablet)
                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.cancel_outlined,
                                iconColor: ColorConstants.red,
                                buttonColor: ColorConstants.transparent,
                                borderColor: ColorConstants.black,
                                buttonText: controller.normalTileString['buttonCancel'],
                                buttonTextColor: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                onPressed: () {
                                  Get.back();
                                },
                              ), // if (Get.parameters['action'] != 'discrepancyEdit')
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                text: "",
                                style: TextStyle(
                                  color: ThemeColorMode.isLight ? Colors.black : Colors.white,
                                  fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                                children: <TextSpan>[
                                  const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 28)),
                                  const TextSpan(text: '\tMarked Fields are Required!\t'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing - 5),
                        Flexible(
                          child: SingleChildScrollView(
                            child:
                                Get.parameters['action'] == 'discrepancyEdit'
                                    ? GetBuilder(init: DiscrepancyEditAndCreateLogic(), builder: (controller) => DiscrepancyEditPageViewCode(controller: controller))
                                    : GetBuilder(init: DiscrepancyEditAndCreateLogic(), builder: (controller) => DiscrepancyCreatePageViewCode(controller: controller)),
                          ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing - 5),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 10.0,
                          runSpacing: 5.0,
                          children: [
                            // if (Get.parameters['action'] != 'discrepancyEdit')
                            //   DiscrepancyAndWorkOrdersMaterialButton(
                            //     icon: Icons.cloud_upload,
                            //     iconColor: ColorConstants.white,
                            //     buttonColor: ColorConstants.primary,
                            //     buttonText: 'Save Discrepancy Changes',
                            //     buttonTextColor: ColorConstants.white,
                            //     onPressed: () async {
                            //       // if (Get.parameters['action'] == 'discrepancyEdit') {
                            //       //   await controller.btnSaveChanges();
                            //       // } else {
                            //       //   await controller.btnCreateDiscrepancy();
                            //       // }
                            //     },
                            //   ),
                            DiscrepancyAndWorkOrdersMaterialButton(
                              icon: Icons.save,
                              iconColor: ColorConstants.white,
                              buttonColor: ColorConstants.primary,
                              buttonText: controller.normalTileString['buttonSave'],
                              buttonTextColor: ColorConstants.white,
                              onPressed: () async {
                                if (Get.parameters['action'] == 'discrepancyEdit') {
                                  LoaderHelper.loaderWithGifAndText('Loading...');
                                  await controller.btnSaveChanges();
                                } else {
                                  LoaderHelper.loaderWithGifAndText('Loading...');
                                  await controller.createDiscrepancyDataBindWithFinalCondition();
                                  await controller.dataValidationCondition();
                                }
                              },
                            ),
                          ],
                        ),
                        // GetBuilder(init: DiscrepancyDetailsNewLogic(), builder: (controller) => DiscrepancyDetailsNewPageViewCode(controller: controller)),

                        /*Align(
                              alignment: Alignment.bottomRight,
                              child: DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.save,
                                iconColor: ColorConstants.white,
                                buttonColor: controller.buttonEnable() ? ColorConstants.primary : ColorConstants.grey.withValues(green: 0.7),
                                buttonText: controller.normalTileString['buttonSave'],
                                buttonTextColor: ColorConstants.white,
                                onPressed: controller.buttonEnable()
                                    ? () async {
                                        if (Get.parameters['action'] == 'discrepancyEdit') {
                                          await controller.btnSaveChanges();
                                        } else {
                                          await controller.btnCreateDiscrepancy();
                                        }
                                      }
                                    : null,
                              ),
                            ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          : const SizedBox();
    });
  }
}
