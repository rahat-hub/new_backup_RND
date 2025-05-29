import 'package:aviation_rnd/modules/form_modules/view_user_form/view_user_form/view_user_form_top_bottom_layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/constants/constant_colors.dart';
import '../../../../shared/services/keyboard.dart';
import '../../../../widgets/appbar.dart';
import '../view_user_form_logic.dart';

class ViewUserFormMobilePortrait extends GetView<ViewUserFormLogic> {
  const ViewUserFormMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ViewUserFormLogic>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop) {
          if (Get.arguments == "fromViewUserForm") {
            Get.offNamed(Routes.viewUserForm, arguments: "fromNewViewUserForm", parameters: {"formId": Get.parameters["previousFormId"].toString(), "masterFormId": ""});
          } else {
            Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: context,
          isDynamicTitle: true,
          dynamicTitle: Obx(() {
            return TextScroll(
              controller.formName.value,
              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              delayBefore: const Duration(milliseconds: 1500),
              numberOfReps: 5,
              intervalSpaces: 8,
              fadedBorder: true,
              fadeBorderSide: FadeBorderSide.right,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize),
            );
          }),
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () {
            if (Get.arguments == "fromViewUserForm") {
              Get.offNamed(Routes.viewUserForm, arguments: "fromNewViewUserForm", parameters: {"formId": Get.parameters["previousFormId"].toString(), "masterFormId": ""});
            } else {
              Get.back();
            }
          },
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse
                ? Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ViewUserFormTopBottomLayers().topLayerCard(controller, context),
                      Obx(() {
                        return Material(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstants.primary.withValues(alpha: 0.3),
                          child: TabBar(
                            indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), color: ColorConstants.primary),
                            labelColor: Colors.white,
                            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            unselectedLabelColor: Colors.grey,
                            isScrollable: controller.myTabs.length <= 2 ? false : true,
                            controller: controller.tabController.value,
                            tabs: controller.myTabs,
                          ),
                        );
                      }),
                      Expanded(
                        child: Obx(() {
                          return TabBarView(controller: controller.tabController.value, children: controller.widgetsForEachTab /*controller.tabView()*/);
                        }),
                      ),
                    ],
                  ),
                )
                : const SizedBox();
          }),
        ),
        bottomNavigationBar: Obx(() {
          return controller.isLoading.isFalse
              ? Material(
                shape: const RoundedRectangleBorder(
                  /*borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),*/
                  side: BorderSide(color: ColorConstants.primary, width: 2.0),
                ),
                child: BottomAppBar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: ViewUserFormTopBottomLayers().bottomNavigationBarButtons(controller, context)),
                  ),
                ),
              )
              : const SizedBox();
        }),
      ),
    );
  }
}

class ViewUserFormMobileLandscape extends GetView<ViewUserFormLogic> {
  const ViewUserFormMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ViewUserFormLogic>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop) {
          if (Get.arguments == "fromViewUserForm") {
            Get.offNamed(Routes.viewUserForm, arguments: "fromNewViewUserForm", parameters: {"formId": Get.parameters["previousFormId"].toString(), "masterFormId": ""});
          } else {
            Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: context,
          isDynamicTitle: true,
          dynamicTitle: Obx(() {
            return TextScroll(
              controller.formName.value,
              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              delayBefore: const Duration(milliseconds: 1500),
              numberOfReps: 5,
              intervalSpaces: 8,
              fadedBorder: true,
              fadeBorderSide: FadeBorderSide.right,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize),
            );
          }),
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () {
            if (Get.arguments == "fromViewUserForm") {
              Get.offNamed(Routes.viewUserForm, arguments: "fromNewViewUserForm", parameters: {"formId": Get.parameters["previousFormId"].toString(), "masterFormId": ""});
            } else {
              Get.back();
            }
          },
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse
                ? Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        return Keyboard.isClose
                            ? Material(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorConstants.primary.withValues(alpha: 0.3),
                              child: TabBar(
                                indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), color: ColorConstants.primary),
                                labelColor: Colors.white,
                                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                unselectedLabelColor: Colors.grey,
                                isScrollable: controller.myTabs.length <= 3 ? false : true,
                                controller: controller.tabController.value,
                                tabs: controller.myTabs,
                              ),
                            )
                            : const SizedBox();
                      }),
                      Expanded(
                        child: Obx(() {
                          return TabBarView(controller: controller.tabController.value, children: controller.widgetsForEachTab);
                        }),
                      ),
                    ],
                  ),
                )
                : const SizedBox();
          }),
        ),
        bottomNavigationBar: Obx(() {
          return controller.isLoading.isFalse
              ? Material(
                shape: const RoundedRectangleBorder(
                  /*borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),*/
                  side: BorderSide(color: ColorConstants.primary, width: 2.0),
                ),
                child: BottomAppBar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: ViewUserFormTopBottomLayers().bottomNavigationBarButtons(controller, context)),
                  ),
                ),
              )
              : const SizedBox();
        }),
      ),
    );
  }
}
