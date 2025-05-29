import 'package:aviation_rnd/modules/work_order_modules/work_order_create_and_edit/work_order_create_and_edit/view_page_work_order_create.dart';
import 'package:aviation_rnd/modules/work_order_modules/work_order_create_and_edit/work_order_create_and_edit/view_page_work_order_edit.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../helper/loader_helper.dart';
import '../../../../widgets/appbar.dart';
import '../work_order_create_and_edit_logic.dart';

class WorkOrderCreateAndEditDeviceView extends GetView<WorkOrderCreateAndEditLogic> {
  const WorkOrderCreateAndEditDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<WorkOrderCreateAndEditLogic>();

    return Obx(() {
      return controller.isLoading.isFalse
          ? PopScope(
            onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
            child: Scaffold(
              appBar: AppbarConstant.customAppBar(context: context, title: controller.title.value, backTap: () => Get.back()),
              body: SafeArea(
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      spacing: SizeConstants.contentSpacing - 5,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                              child: Get.parameters['action'] == 'workOrderEdit'
                                  ? GetBuilder(init: WorkOrderCreateAndEditLogic(), builder: (controller) => WorkOrderEditPageViewCode(controller: controller))
                                  : GetBuilder(init: WorkOrderCreateAndEditLogic(), builder: (controller) => WorkOrderCreatePageViewCode(controller: controller))
                          ),
                        ),
                        if(DeviceType.isTablet)
                          Container(color: Colors.blue, height: 1, width: Get.width),
                        Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            spacing: 3.0,
                            children: [
                              if(DeviceType.isTablet && Get.parameters['action'] != 'workOrderEdit')
                                DiscrepancyAndWorkOrdersMaterialButton(
                                  icon: Icons.arrow_back,
                                  iconColor: ColorConstants.black,
                                  buttonColor: ColorConstants.yellow,
                                  buttonText: "Back to Work Order List",
                                  buttonTextColor: ColorConstants.black,
                                  lrPadding: 10.0,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              if(DeviceType.isTablet && Get.parameters['action'] == 'workOrderEdit')
                                DiscrepancyAndWorkOrdersMaterialButton(
                                  icon: Icons.arrow_back,
                                  iconColor: ColorConstants.black,
                                  buttonColor: ColorConstants.yellow,
                                  buttonText: "Back to Work Order List",
                                  buttonTextColor: ColorConstants.black,
                                  lrPadding: 10.0,
                                  onPressed: () {
                                    // Get.toNamed(Routes.discrepancyEditAndCreate, parameters: {
                                    //   'action': 'discrepancyEdit',
                                    //   'discrepancyId': controller.discrepancyId.toString(),
                                    // });
                                    Get.back();
                                    Get.back();
                                  },
                                ),
                              if(DeviceType.isTablet && Get.parameters['action'] == 'workOrderEdit')
                                DiscrepancyAndWorkOrdersMaterialButton(
                                  icon: Icons.cancel_outlined,
                                  iconColor: ColorConstants.red,
                                  buttonColor: ColorConstants.grey.withValues(alpha: 0.1),
                                  buttonText: "Cancel Edit On Work Order",
                                  buttonTextColor: ColorConstants.black,
                                  borderColor: ColorConstants.black,
                                  lrPadding: 10.0,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                spacing: 10.0,
                                runSpacing: 8.0,
                                children: [
                                  DiscrepancyAndWorkOrdersMaterialButton(
                                    icon: Icons.cloud_upload_rounded,
                                    iconColor: ColorConstants.white,
                                    buttonColor: ColorConstants.primary,
                                    buttonText: Get.parameters['action'] == 'workOrderEdit' ? 'Save Work Order Changes & Upload' : 'Create Work Order & Upload',
                                    buttonTextColor: ColorConstants.white,
                                    onPressed: () async {
                                      if (Get.parameters['action'] == 'workOrderEdit') {
                                        LoaderHelper.loaderWithGifAndText('Loading...');
                                        await controller.btnUpdateWorkOrderChangesApiCall(redirectOption: 1);
                                      }
                                      else {
                                        LoaderHelper.loaderWithGifAndText('Loading...');
                                        await controller.createWorkOrderDataBindWithFinalCondition();
                                        await controller.dataValidationCondition(redirectOption: 1);
                                      }
                                    },
                                  ),
                                  DiscrepancyAndWorkOrdersMaterialButton(
                                    icon: Icons.save,
                                    iconColor: ColorConstants.white,
                                    buttonColor: ColorConstants.primary,
                                    buttonText: Get.parameters['action'] == 'workOrderEdit' ? 'Save Work Order Changes' : 'Create Work Order',
                                    buttonTextColor: ColorConstants.white,
                                    onPressed: () async {
                                      if (Get.parameters['action'] == 'workOrderEdit') {
                                        LoaderHelper.loaderWithGifAndText('Loading...');
                                        await controller.btnUpdateWorkOrderChangesApiCall(redirectOption: 0);
                                      }
                                      else {
                                        LoaderHelper.loaderWithGifAndText('Loading...');
                                        await controller.createWorkOrderDataBindWithFinalCondition();
                                        await controller.dataValidationCondition(redirectOption: 0);
                                      }
                                    },
                                  ),
                                ],
                              )
                            ]
                        ),
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
