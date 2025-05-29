import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_details_new/discrepancy_details_new_page/view_page_discrepancy_details.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../shared/constants/constant_colors.dart';
import '../../../../../shared/constants/constant_sizes.dart';
import '../../../../../widgets/appbar.dart';
import '../../../../widgets/discrepancy_and_work_order_widgets.dart';
import '../discrepancy_details_new_logic.dart';

class DiscrepancyDetailsNewViewPage extends GetView<DiscrepancyDetailsNewLogic> {
  const DiscrepancyDetailsNewViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DiscrepancyDetailsNewLogic>();

    return Obx(() {
      return controller.isLoading.isFalse
          ? PopScope(
              onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
              child: Scaffold(
                  appBar: AppbarConstant.customAppBar(
                      context: context,
                      title: kDebugMode ? 'Discrepancy Details (${Get.parameters['discrepancyId']})' : 'Discrepancy Details',
                      backTap: () => Get.back()),
                  body: SafeArea(
                    child: Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.edit_note_outlined,
                                iconColor: ColorConstants.white,
                                buttonColor: ColorConstants.primary,
                                buttonText: "Edit Discrepancy",
                                onPressed: () {
                                  Get.toNamed(Routes.discrepancyEditAndCreate, parameters: {
                                    'action': 'discrepancyEdit',
                                    'discrepancyId': controller.discrepancyId.toString(),
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: SizeConstants.contentSpacing - 5),
                            Flexible(
                              child: SingleChildScrollView(
                                // child: DiscrepancyDetailsNewPageViewCode(controller: controller),
                                child: GetBuilder(init: DiscrepancyDetailsNewLogic(), builder: (controller) => DiscrepancyDetailsNewPageViewCode(controller: controller)),
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                    ),
                  )),
            )
          : const SizedBox();
    });
  }
}
