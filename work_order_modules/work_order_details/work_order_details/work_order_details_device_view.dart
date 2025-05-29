import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/modules/work_order_modules/work_order_details/work_order_details/tab_view_page_work_order_details.dart';
import 'package:aviation_rnd/modules/work_order_modules/work_order_details/work_order_details/work_order_details_print.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/services/services.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../helper/pdf_helper.dart';
import '../../../../helper/permission_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/constants/constant_sizes.dart';
import '../../../../widgets/appbar.dart';
import '../work_order_details_logic.dart';

class WorkOrderDetailsViewPage extends GetView<WorkOrderDetailsLogic> {
  const WorkOrderDetailsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<WorkOrderDetailsLogic>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
      child: Scaffold(
        appBar: AppbarConstant.customAppBar(
          context: context,
          title: kDebugMode ? 'Work Order Details (${Get.parameters['workOrderId']})' : 'Work Order Details',
          backTap: () => Get.back(),
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse ? Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  spacing: SizeConstants.contentSpacing - 5,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 5.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.settings, size: 25.0, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black),
                            Text(controller.faFaCogString.value, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 20.0,
                            children: [
                              if (controller.demographicsTabData['status'] != 'Completed')
                                DiscrepancyAndWorkOrdersMaterialButton(
                                  icon: Icons.cloud_upload_outlined,
                                  buttonText: '\tSave & Complete\t',
                                  buttonColor: ColorConstants.button,
                                  borderColor: ColorConstants.primary,
                                  onPressed: () async {
                                    await LoaderHelper.loaderWithGifAndText('Loading...');

                                    await controller.checkLineItemsExist();

                                    await controller.apiCallForGetAllCloseOutLineItemsData();

                                    await EasyLoading.dismiss();

                                    await controller.saveAndCompleteDialogView();
                                  },
                                ),

                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.edit_document,
                                buttonText: '\tPrint Logbook\t',
                                buttonColor: ColorConstants.primary,
                                borderColor: ColorConstants.black,
                                onPressed: () async {
                                 print(controller.lineItems);
                                },
                              ),

                              if (controller.demographicsTabData['status'] != 'Completed')
                                DiscrepancyAndWorkOrdersMaterialButton(
                                  icon: Icons.document_scanner_outlined,
                                  buttonText: '\tScanning\t',
                                  buttonColor: ColorConstants.black,
                                  borderColor: ColorConstants.primary,
                                  onPressed: () {
                                    Get.toNamed(Routes.workOrderScanner, arguments: controller.workOrderId);
                                  },
                                ),

                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.print_outlined,
                                buttonText: '\tJobs\t',
                                buttonColor: ColorConstants.grey,
                                borderColor: ColorConstants.black,
                                onPressed: () async {
                                  Get.to(
                                        () =>
                                        ViewPrintSavePdf(
                                          pdfFile:
                                              (pageFormat) =>
                                              controller.pDFViewForJobListingForWorkOrder(
                                                pageFormat: pageFormat,
                                                pdfTitle: 'Job Listing For WorkOrder #${controller.workOrderId}',
                                              ),
                                          fileName: 'str_job_listing_for_workOrder_pdf',
                                          initialPageFormat: PdfPageFormat.a4.landscape,
                                        ),
                                  );
                                },
                              ),

                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.print_outlined,
                                buttonText: '\tMechanics\t',
                                buttonColor: ColorConstants.grey,
                                borderColor: ColorConstants.black,
                                onPressed: () async {
                                  Get.to(
                                        () =>
                                        ViewPrintSavePdf(
                                          pdfFile:
                                              (pageFormat) =>
                                              controller.pDFViewForActiveUsersAndMechanics(
                                                pageFormat: pageFormat,
                                                pdfTitle: 'Mechanics Listing',
                                                listData: controller.mechanicsApiData,
                                              ),
                                          fileName: 'str_work_order_mechanics_listing_pdf',
                                          initialPageFormat: PdfPageFormat.a4.landscape,
                                        ),
                                  );
                                },
                              ),

                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.print_outlined,
                                buttonText: '\tAll Users\t',
                                buttonColor: ColorConstants.grey,
                                borderColor: ColorConstants.black,
                                onPressed: () async {
                                  Get.to(
                                        () =>
                                        ViewPrintSavePdf(
                                          pdfFile:
                                              (pageFormat) =>
                                              controller.pDFViewForActiveUsersAndMechanics(
                                                pageFormat: pageFormat,
                                                pdfTitle: 'Active Users',
                                                listData: controller.activeUsersApiData,
                                              ),
                                          fileName: 'str_work_order_active_users_pdf',
                                          initialPageFormat: PdfPageFormat.a4.landscape,
                                        ),
                                  );
                                },
                              ),

                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.print_outlined,
                                buttonText: '\tPrint WO\t',
                                buttonColor: ColorConstants.primary,
                                borderColor: ColorConstants.black,
                                onPressed: () {
                                  Get.to(
                                        () => ViewPrintSavePdf(
                                      pdfFile:
                                          (pageFormat) => WorkOrderDetailsPrint.pDFViewForWorkOrderDetails(
                                        pageFormat: pageFormat,
                                        pdfTitle: 'Digital AirWare © ${DateFormat("yyyy").format(DateTimeHelper.now)} ',
                                        controller: controller,
                                      ),
                                      fileName: 'str_work_order_printing_details_pdf',
                                      initialPageFormat: PdfPageFormat.a4.landscape,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: ColorConstants.primary,
                      child: TabBar(
                        splashBorderRadius: BorderRadius.circular(5),
                        padding: const EdgeInsets.all(5.0),
                        isScrollable: true,
                        indicator: ShapeDecoration(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)), color: ColorConstants.white),
                        labelColor: ColorConstants.black,
                        unselectedLabelColor: ColorConstants.white,
                        tabs: controller.workOrdersDetailsAllTabs,
                        controller: controller.tabController,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                    ),
                    Flexible(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          for (int i = 0; i < controller.workOrdersDetailsAllTabs.length; i++)
                            switch (controller.workOrdersDetailsAllTabsName[i]) {
                              'Demographics' => Demographics(controller: controller),
                              'Jobs' => Jobs(controller: controller),
                              'PartsRemoved' => PartsRemoved(controller: controller),
                              'PartsInstalled' => PartsInstalled(controller: controller),
                              'PartsRequest' => PartsRequest(controller: controller),
                              'InventoryItems' => InventoryItems(controller: controller),
                              'NonInventoryItems' => NonInventoryItems(controller: controller),
                              'Labor' => Labor(controller: controller),
                              'Documents' => Documents(controller: controller),
                              'W/OStatus' => WOStatus(controller: controller),
                              'CheckList' => CheckList(controller: controller),

                              _ => const SizedBox(),
                            },
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        spacing: 20.0,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          if(controller.tabIndex.value == 1 && controller.workOrderDetailsFullData['objWorkOrderDetailsMVC']['status'] != 'Completed' && (UserPermission.mechanic.value == true || UserPermission.mechanicAdmin.value == true))
                            DiscrepancyAndWorkOrdersMaterialButton(
                              buttonText: 'Create New Job',
                              icon: Icons.add,
                              borderColor: ColorConstants.primary,
                              buttonColor: ColorConstants.button,
                              onPressed: () async {
                                controller.workOrderCreateNewJobsDialogView();
                              },
                            ),

                          DiscrepancyAndWorkOrdersMaterialButton(
                            icon: Icons.keyboard_return_outlined,
                            iconColor: ColorConstants.black,
                            buttonText: '\tReturn To All Work Orders\t',
                            buttonTextColor: ColorConstants.black,
                            buttonColor: ColorConstants.yellow,
                            borderColor: ColorConstants.black,
                            onPressed: () {
                              Get.back();
                            },
                          ),

                          DiscrepancyAndWorkOrdersMaterialButton(
                            icon: Icons.backspace_rounded,
                            iconColor: ColorConstants.black,
                            buttonText: '\tReturn To Discrepancy\t',
                            buttonTextColor: ColorConstants.black,
                            buttonColor: ColorConstants.yellow,
                            borderColor: ColorConstants.black,
                            onPressed: () {
                              Get.toNamed(
                                Routes.discrepancyDetailsNew,
                                arguments: controller.workOrderId,
                                parameters: {"discrepancyId": controller.workOrderId, "routeForm": "workOrderDetails"},
                              );
                            },
                          ),

                          DiscrepancyAndWorkOrdersMaterialButton(
                            icon: Icons.delete_forever,
                            buttonText: '\tDelete Work Order\t',
                            buttonColor: ColorConstants.red,
                            borderColor: ColorConstants.primary,
                            onPressed: () {
                              controller.deleteWorkOrderDialogView();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ) : SizedBox();
          }),
        ),
      ),
    );
  }
}
