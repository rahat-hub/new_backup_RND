import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_details_new/discrepancy_details_new_logic.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../helper/permission_helper.dart';

class DiscrepancyDetailsNewPageViewCode extends StatelessWidget {
  final DiscrepancyDetailsNewLogic controller;

  const DiscrepancyDetailsNewPageViewCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.discrepancyDetailsNewApiData.isNotEmpty
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: SizeConstants.contentSpacing - 5,
          children: [
            // Equipment
            equipmentViewReturn(),
            // Additional_Information_At_Time_Of_Issue
            additionalInformationAtTimeOfIssueViewReturn(),
            // Discovered
            discoveredViewReturn(),
            // Description
            descriptionViewReturn(),
            // Status
            statusViewReturn(),
            // Mechanic_Assign_To
            for (int i = 1; i <= 3; i++) mechanicAssignToViewReturn(x: i),
            // Scheduled_Maintenance
            scheduledMaintenanceViewReturn(),
            // MEL
            if (controller.discrepancyDetailsNewApiData['discrepancyType'] == 0 && controller.discrepancyDetailsNewApiData['unitId'] > 0) melViewReturn(),
            if (controller.discrepancyDetailsNewApiData['discrepancyType'] == 0 && controller.discrepancyDetailsNewApiData['unitId'] > 0)
              // ATA_Code
              ataCodeViewReturn(),
            // Discrepancy_Service_Status
            discrepancyServiceStatusViewReturn(),
            // Corrective_Action
            correctiveActionViewReturn(),
            if (controller.discrepancyDetailsNewApiData['discrepancyType'] == 0)
              // Post_Maintenance_Activities
              postMaintenanceActivities(),
            // Associated_Work_Order
            associatedWorkOrderViewReturn(),
            // Client's_Purchase_Order_Number
            clientsPurchaseOrderNumberViewReturn(),
            // Attachments_&_Log_Books
            attachmentsAndLogBooksViewReturn(),
            // Notes
            notesViewReturn(),
          ],
        )
        : const SizedBox();
  }

  headerTitleReturn({required String title}) {
    return SizedBox(
      height: SizeConstants.contentSpacing * 4,
      width: Get.width,
      child: Material(
        color: ColorConstants.primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: TextScroll(
              title,
              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              delayBefore: const Duration(milliseconds: 2000),
              numberOfReps: 5,
              intervalSpaces: 20,
              style: TextStyle(color: Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
          ),
        ),
      ),
    );
  }

  equipmentViewReturn() {
    switch (controller.discrepancyDetailsNewApiData['discrepancyType']) {
      case 0:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            children: [
              headerTitleReturn(title: 'Equipment'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  children: [
                    Text(
                      controller.discrepancyDetailsNewApiData['equipmentName'].toString().split(' ').first,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: controller.discrepancyDetailsNewApiData['equipmentName'].toString().split('-').last,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            children: [
              headerTitleReturn(title: 'Equipment'),
              DiscrepancyAndWorkOrdersMaterialButton(
                iconColor: ColorConstants.white,
                buttonColor: ColorConstants.primary,
                buttonText: controller.discrepancyDetailsNewApiData['equipmentName'].toString(),
              ),
            ],
          ),
        );
      case 2:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            children: [
              headerTitleReturn(title: 'Equipment'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    Text(
                      controller.discrepancyDetailsNewApiData['equipmentName'].toString().split('-').first,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: controller.discrepancyDetailsNewApiData['equipmentName'].toString().split('-')[1],
                    ),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: Icons.open_in_new,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: controller.discrepancyDetailsNewApiData['equipmentName'].toString().split(')').last,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 3 || 4 || 5:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            children: [
              headerTitleReturn(title: 'Equipment'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.discrepancyDetailsNewApiData['equipmentName'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  additionalInformationAtTimeOfIssueViewReturn() {
    switch (controller.discrepancyDetailsNewApiData['discrepancyType']) {
      case 0:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerTitleReturn(title: 'Additional Information At Time Of Issue'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'AC TT: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['hobbsName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Landings: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['landings'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Torque Events: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['torqueEvents'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.0,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Engine #1 TT: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.discrepancyDetailsNewApiData['engine1TTName'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Engine #1 Starts: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.discrepancyDetailsNewApiData['engine1Starts'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (controller.discrepancyDetailsNewApiData['engine2Enabled'])
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Engine #2 TT: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.discrepancyDetailsNewApiData['engine2TTName'],
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Engine #2 Starts: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.discrepancyDetailsNewApiData['engine2Starts'].toString(),
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (controller.discrepancyDetailsNewApiData['engine3Enabled'])
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Engine #3 TT: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.discrepancyDetailsNewApiData['engine3TTName'],
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Engine #3 Starts: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.discrepancyDetailsNewApiData['engine3Starts'].toString(),
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (controller.discrepancyDetailsNewApiData['engine4Enabled'])
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Engine #4 TT: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.discrepancyDetailsNewApiData['engine4TTName'],
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Engine #4 Starts: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.discrepancyDetailsNewApiData['engine4Starts'].toString(),
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [headerTitleReturn(title: 'Additional Information At Time Of Issue')]),
        );
      case 2 || 3 || 4 || 5:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerTitleReturn(title: 'Additional Information At Time Of Issue'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Component Name: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['outsideComponentName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Part Number: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['outsideComponentPartNumber'])
                                    ? "(None)"
                                    : controller.discrepancyDetailsNewApiData['outsideComponentPartNumber'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Serial Number: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['outsideComponentSerialNumber'])
                                    ? "(None)"
                                    : controller.discrepancyDetailsNewApiData['outsideComponentSerialNumber'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.0,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Service Life Type# 1: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['componentServiceLife1TypeName'])
                                        ? "(None)"
                                        : controller.discrepancyDetailsNewApiData['componentServiceLife1TypeName'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Service Life Type# 2: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['componentServiceLife2TypeName'])
                                        ? "(None)"
                                        : controller.discrepancyDetailsNewApiData['componentServiceLife2TypeName'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.0,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Since New Amount: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.discrepancyDetailsNewApiData['componentServiceLife1SinceNewAmt'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Since New Amount: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.discrepancyDetailsNewApiData['componentServiceLife2SinceNewAmt'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.0,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Since O/H Amount: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.discrepancyDetailsNewApiData['componentServiceLife1SinceOhAmt'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Since O/H Amount: ',
                            style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.discrepancyDetailsNewApiData['componentServiceLife2SinceOhAmt'],
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  discoveredViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Discovered'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Discovered: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.discrepancyDetailsNewApiData['discoveredByName'],
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'License Number: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.discrepancyDetailsNewApiData['discoveredByLicenseNumber'],
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Date: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: DateFormat("MM/dd/yyyy HH:mm").format(DateTime.parse(controller.discrepancyDetailsNewApiData['createdAt'] ?? "")),
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  descriptionViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Description'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.discrepancyDetailsNewApiData['discrepancy'],
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  statusTextValueReturn({required String valueReturn}) {
    if (valueReturn == 'text') {
      switch (controller.discrepancyDetailsNewApiData['status']) {
        case 'AOG':
          return 'On Ground / Out Of Service [Red]';
        case 'In Service':
          return 'In Service [Green]';
        case 'Parts On Order':
          return 'Parts On Order [Yellow]';
        case 'Limited Mission':
          return 'Limited Mission [Yellow]';
        case 'Completed':
          return 'Completed[Green]';
        default:
          return 'None';
      }
    } else {
      switch (controller.discrepancyDetailsNewApiData['status']) {
        case 'AOG':
          return Colors.red;
        case 'In Service':
          return Colors.green;
        case 'Parts On Order' || 'Limited Mission':
          return Colors.yellow.shade800;
        case 'Completed':
          return Colors.green;
        default:
          return Colors.transparent;
      }
    }
  }

  statusViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Status'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.discrepancyDetailsNewApiData['status'] != 'Completed'
                    ? RichText(
                      text: TextSpan(
                        text: 'Status: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            // text: controller.discrepancyDetailsNewApiData['status'],
                            text: statusTextValueReturn(valueReturn: 'text'),
                            style: TextStyle(color: statusTextValueReturn(valueReturn: 'color'), fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    )
                    : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10.0,
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        const DiscrepancyAndWorkOrdersMaterialButton(
                          buttonColor: ColorConstants.button,
                          buttonText: "Completed [Green]",
                          // onPressed: () {},
                        ),
                      ],
                    ),
                !DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['correctedByName'])
                    ? RichText(
                      text: TextSpan(
                        text: 'Corrected By: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['correctedByName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                          if (DateFormat("yyyy/MM/dd").format(DateTime.parse(controller.discrepancyDetailsNewApiData['dateCorrected'])) != '1900/01/01')
                            TextSpan(
                              text: '\tAt\t${DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.parse(controller.discrepancyDetailsNewApiData['dateCorrected']))}',
                              style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            ),
                        ],
                      ),
                    )
                    : controller.discrepancyDetailsNewApiData['status'] == 'Completed'
                    ? RichText(
                      text: TextSpan(
                        text: 'Corrected By: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[TextSpan(text: '(None)', style: TextStyle(color: Colors.red, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize))],
                      ),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
          if (controller.discrepancyDetailsNewApiData['status'] == 'Completed' || controller.discrepancyDetailsNewApiData['discrepancyType'] == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                runSpacing: 5.0,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'AC TT @ Completed: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          children: <TextSpan>[
                            TextSpan(
                              text: controller.discrepancyDetailsNewApiData['acttCompletedAt'],
                              style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Engine #1 TT @ Completed: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          children: <TextSpan>[
                            TextSpan(
                              text: controller.discrepancyDetailsNewApiData['engine1TTCompletedAt'],
                              style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (controller.discrepancyDetailsNewApiData['engine2Enabled'])
                    RichText(
                      text: TextSpan(
                        text: 'Engine #2 TT: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['engine2TTCompletedAt'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                  if (controller.discrepancyDetailsNewApiData['engine3Enabled'])
                    RichText(
                      text: TextSpan(
                        text: 'Engine #3 TT: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['engine3TTCompletedAt'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                  if (controller.discrepancyDetailsNewApiData['engine4Enabled'])
                    RichText(
                      text: TextSpan(
                        text: 'Engine #4 TT: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['engine4TTCompletedAt'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  mechanicDataPass({required int x}) {
    switch (x) {
      case 1:
        return TextSpan(
          text:
              DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['mechanicAssignedTo1'])
                  ? "Not Found"
                  : controller.discrepancyDetailsNewApiData['mechanicAssignedTo1'],
          style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
        );
      case 2:
        return TextSpan(
          text:
              DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['mechanicAssignedTo2'])
                  ? "Not Found"
                  : controller.discrepancyDetailsNewApiData['mechanicAssignedTo2'],
          style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
        );
      case 3:
        return TextSpan(
          text:
              DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['mechanicAssignedTo3'])
                  ? "Not Found"
                  : controller.discrepancyDetailsNewApiData['mechanicAssignedTo3'],
          style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
        );
      default:
        return TextSpan(
          text: '',
          style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
        );
    }
  }

  mechanicAssignToViewReturn({required int x}) {
    if (!controller.discrepancyDetailsNewApiData['woCheckOut']) {
      int thisMechanicId = 0;
      switch (x) {
        case 1:
          thisMechanicId = controller.discrepancyDetailsNewApiData['assignedTo'];
          break;
        case 2:
          thisMechanicId = controller.discrepancyDetailsNewApiData['assignedTo2'];
          break;
        case 3:
          thisMechanicId = controller.discrepancyDetailsNewApiData['assignedTo3'];
          break;
        default:
          break;
      }
      return Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            headerTitleReturn(title: 'Mechanic Assigned To # $x'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                runSpacing: 5.0,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Mechanic Assigned To #$x: ',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      children: <TextSpan>[
                        thisMechanicId > 0
                            ? mechanicDataPass(x: x)
                            : TextSpan(
                              text: 'Not Specified',
                              style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            ),
                      ],
                    ),
                  ),
                  if (x == 1)
                    RichText(
                      text: TextSpan(
                        text: 'License Number: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.discrepancyDetailsNewApiData['correctedByLicenseNumber'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  scheduledMaintenanceViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Scheduled Maintenance'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Scheduled Maintenance: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.discrepancyDetailsNewApiData['scheduleMtnc'] == 1 ? 'YES' : 'NO',
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  melViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'MEL'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.discrepancyDetailsNewApiData['mel'] > 0
                    ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10.0,
                      children: [
                        Text(
                          'MEL: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        DiscrepancyAndWorkOrdersMaterialButton(
                          icon: Icons.menu,
                          buttonColor: ColorConstants.black,
                          buttonText: "View MEL",
                          onPressed: () async {
                            Get.toNamed(
                              Routes.melDetails,
                              parameters: {
                                "aircraftName": controller.discrepancyDetailsNewApiData["equipmentName"],
                                "melId": controller.discrepancyDetailsNewApiData["mel"].toString(),
                                "melType": "Mel",
                              },
                            );
                          },
                        ),
                      ],
                    )
                    : RichText(
                      text: TextSpan(
                        text: 'MEL: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'No MEL Created',
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ataCodeViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'ATA Code'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'ATA Code: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.discrepancyDetailsNewApiData['ataCode'] == "" ? "None" : controller.discrepancyDetailsNewApiData['ataCode'],
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'ATA MNC Code: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.discrepancyDetailsNewApiData['atamcnCode'] == "" ? "None" : controller.discrepancyDetailsNewApiData['atamcnCode'],
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  discrepancyServiceStatusViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Discrepancy Service Status'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 5.0,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: DeviceType.isTablet ? 80.0 : 10.0,
                  runSpacing: DeviceType.isTablet ? 30.0 : 5.0,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'System Affected: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['systemAffectedName'])
                                    ? "None"
                                    : controller.discrepancyDetailsNewApiData['systemAffectedName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'When Discovered: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['whenDiscoveredName'])
                                    ? "None"
                                    : controller.discrepancyDetailsNewApiData['whenDiscoveredName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Functional Group: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['functionalGroupName'])
                                    ? "None"
                                    : controller.discrepancyDetailsNewApiData['functionalGroupName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: DeviceType.isTablet ? 80.0 : 10.0,
                  runSpacing: DeviceType.isTablet ? 30.0 : 5.0,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'How Recognized: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['howRecognizedName'])
                                    ? "None"
                                    : controller.discrepancyDetailsNewApiData['howRecognizedName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Malfunction Effect: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['malfunctionEffectName'])
                                    ? "None"
                                    : controller.discrepancyDetailsNewApiData['malfunctionEffectName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Mission Flight Type: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['missionFlightTypeName'])
                                    ? "None"
                                    : controller.discrepancyDetailsNewApiData['missionFlightTypeName'],
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  correctiveActionViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Corrective Action'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Corrective Action: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            DataUtils.isNullOrEmptyString(controller.discrepancyDetailsNewApiData['correctiveAction'])
                                ? "None"
                                : controller.discrepancyDetailsNewApiData['correctiveAction'],
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  postMaintenanceActivities() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Post Maintenance Activities'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                Row(
                  spacing: 10.0,
                  children: [
                    Text(
                      'Ground Run Required: ',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Switch(
                      value: controller.discrepancyDetailsNewApiData['checkGroundRunRequired'],
                      onChanged: null,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withValues(alpha: 0.4),
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  spacing: 10.0,
                  children: [
                    Text(
                      'Check Flight Required: ',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Switch(
                      value: controller.discrepancyDetailsNewApiData['checkFlightRequired'],
                      onChanged: null,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withValues(alpha: 0.4),
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  spacing: 10.0,
                  children: [
                    Text(
                      'Leak Test Required: ',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Switch(
                      value: controller.discrepancyDetailsNewApiData['leakTestRequired'],
                      onChanged: null,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withValues(alpha: 0.4),
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  spacing: 10.0,
                  children: [
                    Text(
                      'Additional Inspection Required: ',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Switch(
                      value: controller.discrepancyDetailsNewApiData['additionalInspectionRequired'],
                      onChanged: null,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withValues(alpha: 0.4),
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (controller.discrepancyDetailsNewApiData['additionalInspectionRequired'])
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                runSpacing: 5.0,
                children: [
                  controller.discrepancyDetailsNewApiData['airPerformedById'] > 0
                      ? RichText(
                        text: TextSpan(
                          text: 'Performed By: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "${controller.discrepancyDetailsNewApiData['airPerformedByName']} on ${DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(controller.discrepancyDetailsNewApiData['airPerformedAt']))}",
                              //"${controller.discrepancyDetailsNewApiData['airPerformedByName']} on ${DateTimeHelper.dateTimeFormat12H.format(DateTime.parse(controller.discrepancyDetailsNewApiData['airPerformedAt']))}",
                              style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            ),
                          ],
                        ),
                      )
                      : (controller.discrepancyDetailsNewApiData['isSignAIRPerformed'] && controller.discrepancyDetailsNewApiData['status'] == 'Completed')
                      ? (controller.discrepancyDetailsNewApiData['correctedBy'] != UserSessionInfo.userId)
                          ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10.0,
                            children: [
                              Text(
                                'Performed By: ',
                                style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              ),
                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.circle,
                                iconColor: Colors.green.shade700,
                                buttonColor: Colors.blue.shade900,
                                buttonText: "Sign AIR Has Been Reformed",
                                onPressed: () async {
                                  await controller.electronicSignatureReformedDialogView();
                                },
                              ),
                            ],
                          )
                          : RichText(
                            text: TextSpan(
                              text: 'Performed By: ',
                              style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Note: Another Person is required to sign AIR',
                                  style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ],
                            ),
                          )
                      : RichText(
                        text: TextSpan(
                          text: 'Performed By: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Note: Complete Discrepancies before signing AIR',
                              style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  associatedWorkOrderViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Associated Work Order'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.discrepancyDetailsNewApiData['isWorkOrder']
                    ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10.0,
                      children: [
                        Text(
                          'Associated Work Order: ',
                          style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        DiscrepancyAndWorkOrdersMaterialButton(
                          icon: Icons.search,
                          buttonColor: ColorConstants.black,
                          buttonText: "View Work Order #${controller.discrepancyDetailsNewApiData['woNumber']}",
                          onPressed: () async {},
                        ),
                      ],
                    )
                    : RichText(
                      text: TextSpan(
                        text: 'Associated Work Order: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'No',
                            style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  clientsPurchaseOrderNumberViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Client\'s Purchase Order Number'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Client\'s Purchase Order Number: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            controller.discrepancyDetailsNewApiData['purchaseOrder'] == ''
                                ? "None (For Invoice)"
                                : "${controller.discrepancyDetailsNewApiData['purchaseOrder']} (For Invoice)",
                        style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  documentsViewIconReturns({required String types}) {
    switch (types) {
      case 'file':
        return MaterialCommunityIcons.file_pdf;
      case 'folder':
        return MaterialCommunityIcons.folder;
      case 'url':
        return MaterialCommunityIcons.link;
      case 'excel':
        return MaterialCommunityIcons.file_excel;
      case 'doc':
        return MaterialCommunityIcons.file_word;
      case 'powerpoint':
        return MaterialCommunityIcons.file_powerpoint;
      case 'image':
        return MaterialCommunityIcons.image;
      case 'root':
        return MaterialCommunityIcons.folder;
      default:
        return MaterialCommunityIcons.folder;
    }
  }

  attachmentsAndLogBooksViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Attachments & Log Books'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (UserPermission.pilot.value ||
                    UserPermission.pilotAdmin.value ||
                    UserPermission.mechanic.value ||
                    UserPermission.mechanicAdmin.value ||
                    UserPermission.discrepanciesWo.value ||
                    UserPermission.coSignAcLogs.value)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      Text(
                        'Attachments & Log Books: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                      DiscrepancyAndWorkOrdersMaterialButton(
                        buttonColor: ColorConstants.primary,
                        buttonText: "Attach New Upload",
                        onPressed: () async {
                          Get.toNamed(
                            Routes.fileUpload,
                            arguments: "discrepancyAddAttachment",
                            parameters: {"routes": 'discrepancyDetails', 'discrepancyId': controller.discrepancyId.toString()},
                          );
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border: TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
                          children: [
                            SizedBox(
                              width: 180.0,
                              height: 40.0,
                              child: Center(
                                child: Text(
                                  'Type',
                                  style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < controller.discrepancyDetailsNewApiData['attachments'].length; i++)
                          TableRow(
                            children: [
                              SizedBox(
                                width: 180.0,
                                height: 35.0,
                                child: Center(child: Text('Attachment', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize))),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          border: TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          // border: TableBorder(top: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
                              children: [
                                SizedBox(
                                  width: 450.0,
                                  height: 40.0,
                                  child: Center(
                                    child: Text(
                                      'File Name',
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300.0,
                                  height: 40.0,
                                  child: Center(
                                    child: Text(
                                      'Uploaded At',
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300.0,
                                  height: 40.0,
                                  child: Center(
                                    child: Text(
                                      'Uploaded By',
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (int i = 0; i < controller.discrepancyDetailsNewApiData['attachments'].length; i++)
                              TableRow(
                                children: [
                                  SizedBox(
                                    width: 450.0,
                                    height: 35.0,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          InkWell(
                                            onTap:
                                                () async => await FileControl.getPathAndViewFile(
                                                  fileId: controller.discrepancyDetailsNewApiData['attachments'][i]['attachmentId'].toString(),
                                                  fileName: controller.discrepancyDetailsNewApiData['attachments'][i]['fileName'].toString(),
                                                ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  documentsViewIconReturns(
                                                    types: FileControl.fileType(fileName: controller.discrepancyDetailsNewApiData['attachments'][i]['fileName']),
                                                  ),
                                                  size: 25.0,
                                                  color: ColorConstants.primary.withValues(alpha: 0.7),
                                                ),
                                                Text(
                                                  controller.discrepancyDetailsNewApiData['attachments'][i]['fileName'],
                                                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (UserPermission.pilot.value ||
                                              UserPermission.pilotAdmin.value ||
                                              UserPermission.mechanic.value ||
                                              UserPermission.mechanicAdmin.value ||
                                              UserPermission.discrepanciesWo.value ||
                                              UserPermission.coSignAcLogs.value)
                                            InkWell(
                                              onTap: () async {
                                                await controller.attachmentRemoveDialogView(
                                                  attachmentId: controller.discrepancyDetailsNewApiData['attachments'][i]['attachmentId'].toString(),
                                                );
                                              },
                                              child: const Icon(Icons.delete, color: ColorConstants.red, size: 30.0),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300.0,
                                    height: 35.0,
                                    child: Center(
                                      child: Text(
                                        DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(controller.discrepancyDetailsNewApiData['attachments'][i]['createdAt'])),
                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300.0,
                                    height: 35.0,
                                    child: Center(
                                      child: Text(
                                        controller.discrepancyDetailsNewApiData['attachments'][i]['fullName'],
                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.discrepancyDetailsNewApiData['attachments'].isEmpty)
                  Text('No File Attachments', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  notesViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Notes'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border: TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
                          children: [
                            SizedBox(
                              width: 220.0,
                              height: 40.0,
                              child: Center(
                                child: Text(
                                  'Date',
                                  style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < controller.discrepancyDetailsNewApiData['notes'].length; i++)
                          TableRow(
                            children: [
                              SizedBox(
                                width: 200.0,
                                height: 100.0,
                                child: Center(
                                  child: Text(
                                    controller.discrepancyDetailsNewApiData['notes'][i]['notesCreatedAt'],
                                    style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          border: TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          // border: TableBorder(top: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
                              children: [
                                SizedBox(
                                  width: 250.0,
                                  height: 40.0,
                                  child: Center(
                                    child: Text(
                                      'User',
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: DeviceType.isTablet ? Get.width - (250.0 + 220.0) : Get.width,
                                  height: 40.0,
                                  child: Center(
                                    child: Text(
                                      'Note',
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (int i = 0; i < controller.discrepancyDetailsNewApiData['notes'].length; i++)
                              TableRow(
                                children: [
                                  SizedBox(
                                    width: 250.0,
                                    height: 35.0,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          controller.discrepancyDetailsNewApiData['notes'][i]['fullName'],
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: DeviceType.isTablet ? Get.width - (250.0 + 220.0) : Get.width,
                                    height: 100.0,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          controller.discrepancyDetailsNewApiData['notes'][i]['notes'],
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.discrepancyDetailsNewApiData['notes'].isEmpty) Text('None', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
