import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../widgets/appbar.dart';
import '../forms_index_logic.dart';
import 'layers/forms_index_data.dart';
import 'layers/forms_index_filter.dart';

class ViewFormIndexTablet extends GetView<FormsIndexLogic> {
  const ViewFormIndexTablet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FormsIndexLogic>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        EasyLoading.dismiss();
        await controller.saveFilterSelectedValues();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: Get.context!,
          title: "View Forms",
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () async {
            await controller.saveFilterSelectedValues();
            Get.back();
          },
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse
                ? RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration.zero, () async {
                      await controller.loadViewFormAllData(refreshed: true);
                    });
                  },
                  child: ListView(children: [FormsIndexFilter().filter(controller, context), FormsIndexData().viewFormsIndexData(controller)]),
                )
                : const SizedBox();
          }),
        ),
      ),
    );
  }
}
