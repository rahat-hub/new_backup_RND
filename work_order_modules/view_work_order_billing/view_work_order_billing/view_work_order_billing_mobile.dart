import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../view_work_order_billing_logic.dart';

class ViewWorkOrderBillingMobilePortrait extends GetView<ViewWorkOrderBillingLogic> {
  const ViewWorkOrderBillingMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ViewWorkOrderBillingLogic>();
    return PopScope(
        onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppbarConstant.customAppBar(
              context: Get.context!, title: "Work Order Billing", centerTitle: true, menuEnable: false, actionEnable: false, backButtonEnable: true, backTap: () => Get.back()),
          body: SafeArea(
            child: Obx(() {
              return controller.isLoading.isFalse
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                      child: ListView(
                        children: [
                          const SizedBox(height: SizeConstants.contentSpacing + 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: controller.switchToInvoice.value
                                    ? Text(
                                        "Invoice # ${Get.parameters["discrepancyId"]}",
                                        style: const TextStyle(),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      )
                                    : Text(
                                        "Work Order # ${Get.parameters["discrepancyId"]}",
                                        style: const TextStyle(),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                              ),
                              const SizedBox(width: SizeConstants.contentSpacing),
                              Expanded(
                                flex: 2,
                                child: MaterialButton(
                                  color: ColorConstants.primary,
                                  height: 50,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    controller.switchToInvoice.value = !controller.switchToInvoice.value;
                                  },
                                  child: controller.switchToInvoice.value
                                      ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.switch_access_shortcut, size: 30, color: Colors.white),
                                          Text(
                                            "Switch to Invoice",
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        ])
                                      : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.switch_access_shortcut_rounded, size: 30, color: Colors.red),
                                          Text(
                                            "Switch to Work Order",
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        ]),
                                ),
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
        ));
  }
}

class ViewWorkOrderBillingMobileLandscape extends GetView<ViewWorkOrderBillingLogic> {
  const ViewWorkOrderBillingMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ViewWorkOrderBillingLogic>();
    return PopScope(
        onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppbarConstant.customAppBar(
              context: Get.context!, title: "Work Order Billing", centerTitle: true, menuEnable: false, actionEnable: false, backButtonEnable: true, backTap: () => Get.back()),
        ));
  }
}
