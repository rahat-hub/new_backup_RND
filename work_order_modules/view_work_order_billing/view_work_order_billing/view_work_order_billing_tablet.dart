import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../view_work_order_billing_logic.dart';

class ViewWorkOrderBillingTablet extends GetView<ViewWorkOrderBillingLogic> {
  const ViewWorkOrderBillingTablet({super.key});

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
