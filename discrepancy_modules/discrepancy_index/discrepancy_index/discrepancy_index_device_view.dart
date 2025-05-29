import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_index/discrepancy_index_logic.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../helper/loader_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/constants/constant_colors.dart';
import '../../../../shared/constants/constant_sizes.dart';

class DiscrepancyIndexDeviceView extends GetView<DiscrepancyIndexLogic> {
  const DiscrepancyIndexDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DiscrepancyIndexLogic>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppbarConstant.customAppBar(
              context: Get.context!,
              title: "Search Discrepancy",
              centerTitle: true,
              menuEnable: false,
              actionEnable: false,
              backButtonEnable: true,
              backTap: () => Get.back()),
          body: SafeArea(
            child: Obx(() {
              return controller.isLoading.isFalse
                  ? RefreshIndicator(
                      strokeWidth: 3.0,
                      onRefresh: () {
                        return Future.delayed(Duration.zero, () async {
                          controller.isIndexDataLoading.value = true;
                          LoaderHelper.loaderWithGif();
                          await controller.indexPageDataViewApiCall(callFrom: "refreshIndication");
                          controller.isIndexDataLoading.value = false;
                          controller.update();
                          await EasyLoading.dismiss();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
                          const SizedBox(height: SizeConstants.contentSpacing - 5),
                          if (controller.createNewDiscrepancy)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DiscrepancyAndWorkOrdersMaterialButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.discrepancyEditAndCreate, parameters: {'action': 'discrepancyCreate', 'discrepancyId': ''});
                                  },
                                  icon: Icons.add_box_rounded,
                                  iconColor: ColorConstants.white,
                                  buttonText: 'Create New Discrepancy',
                                  borderColor: Colors.black.withValues(alpha: 0.2),
                                  buttonColor: ColorConstants.primary,
                                  buttonTextColor: ColorConstants.white,
                                ),
                              ],
                            ),
                          const SizedBox(height: SizeConstants.contentSpacing - 5),
                          controller.commonFilterViewLayer(),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          GetBuilder(init: DiscrepancyIndexLogic(), builder: (controller) => controller.indexDataViewReturn()),
                        ]),
                      ),
                    )
                  : const SizedBox();
            }),
          )),
    );
  }
}
