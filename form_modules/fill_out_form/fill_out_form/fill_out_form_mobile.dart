import 'package:aviation_rnd/modules/form_modules/fill_out_form/fill_out_form/top_bottom_layers.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../shared/services/keyboard.dart';
import '../../../../widgets/appbar.dart';
import '../fill_out_form_logic.dart';

class FillOutFormMobilePortrait extends GetView<FillOutFormLogic> {
  const FillOutFormMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    var showMore = false.obs;
    Get.find<FillOutFormLogic>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop) {
          Get.back(result: controller.dataModified);
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
          backTap: () => Get.back(result: controller.dataModified),
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse
                ? Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TopBottomLayers().topLayerCard(controller, context),
                      if (controller.formEditData["allowAttachments"] != null ? !controller.formEditData["allowAttachments"] : true)
                        Obx(() {
                          return showMore.value ? const SizedBox(height: 5) : const SizedBox();
                        }),
                      if (controller.formEditData["allowAttachments"] ?? false)
                        Obx(() {
                          return showMore.value ? TopBottomLayers().formAttachmentCard(controller) : const SizedBox();
                        }),
                      Obx(() {
                        return controller.dataLoaded.value
                            ? Material(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorConstants.primary.withValues(alpha: 0.3),
                              child: TabBar(
                                indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), color: ColorConstants.primary),
                                labelColor: Colors.white,
                                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                unselectedLabelColor: Colors.grey,
                                isScrollable: !(controller.myTabs.length <= 2),
                                controller: controller.tabController.value,
                                tabs: controller.myTabs,
                              ),
                            )
                            : const SizedBox();
                      }),
                      Expanded(
                        child: Obx(() {
                          return controller.dataLoaded.value
                              ? TabBarView(
                                physics: controller.tabScrollerControllerStop.value ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                                controller: controller.tabController.value,
                                children: controller.widgetsForEachTab /*controller.tabView()*/,
                              )
                              : const SizedBox();
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
                shape: const RoundedRectangleBorder(side: BorderSide(color: ColorConstants.primary, width: 2.0)),
                child: BottomAppBar(
                  child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: TopBottomLayers().bottomNavigationBar(controller, context))),
                ),
              )
              : const SizedBox();
        }),
      ),
    );
  }
}

class FillOutFormMobileLandscape extends GetView<FillOutFormLogic> {
  const FillOutFormMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FillOutFormLogic>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop) {
          Get.back(result: controller.dataModified);
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
          backTap: () => Get.back(result: controller.dataModified),
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
                        return controller.dataLoaded.value
                            ? Keyboard.isClose
                                ? Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorConstants.primary.withValues(alpha: 0.3),
                                  child: TabBar(
                                    indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), color: ColorConstants.primary),
                                    labelColor: Colors.white,
                                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    unselectedLabelColor: Colors.grey,
                                    isScrollable: !(controller.myTabs.length <= 3),
                                    controller: controller.tabController.value,
                                    tabs: controller.myTabs,
                                  ),
                                )
                                : const SizedBox()
                            : const SizedBox();
                      }),
                      Expanded(
                        child: Obx(() {
                          return controller.dataLoaded.value
                              ? TabBarView(
                                physics: controller.tabScrollerControllerStop.value ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                                controller: controller.tabController.value,
                                children: controller.widgetsForEachTab /*controller.tabView()*/,
                              )
                              : const SizedBox();
                        }),
                      ),
                    ],
                  ),
                )
                : const SizedBox();
          }),
        ),
        bottomNavigationBar: Obx(() {
          return controller.isLoading.isFalse && Keyboard.isClose
              ? Material(
                shape: const RoundedRectangleBorder(side: BorderSide(color: ColorConstants.primary, width: 2.0)),
                child: BottomAppBar(
                  child: SingleChildScrollView(
                    reverse: true,
                    controller: ScrollController(
                      onAttach: (ctr) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        ctr.animateTo(ctr.maxScrollExtent.toPrecision(1), duration: const Duration(milliseconds: 1), curve: Curves.easeInOutCubic);
                      },
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(children: TopBottomLayers().bottomNavigationBar(controller, context)),
                  ),
                ),
              )
              : const SizedBox();
        }),
      ),
    );
  }
}
