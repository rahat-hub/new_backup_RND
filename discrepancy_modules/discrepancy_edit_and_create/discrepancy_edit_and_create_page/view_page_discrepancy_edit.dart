import 'package:aviation_rnd/shared/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../helper/loader_helper.dart';
import '../../../../shared/constants/constant_colors.dart';
import '../../../../shared/constants/constant_sizes.dart';
import '../../../../shared/services/device_orientation.dart';
import '../../../../shared/services/theme_color_mode.dart';
import '../../../../shared/utils/data_utils.dart';
import '../../../../shared/utils/file_control.dart';
import '../../../../widgets/discrepancy_and_work_order_widgets.dart';
import '../discrepancy_edit_and_create_logic.dart';

class DiscrepancyEditPageViewCode extends StatelessWidget {
  final DiscrepancyEditAndCreateLogic controller;

  const DiscrepancyEditPageViewCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: SizeConstants.contentSpacing - 5, children: [
      // Equipment_View
      equipmentEditViewReturn(), // Additional_Information_View
      additionalInformationEditViewReturn(), // Discovered_View
      discoveredEditViewReturn(), // Description_View
      descriptionEditViewReturn(), // Status_View
      statusEditViewReturn(), // Mechanic_Assigned_To_1_View
      mechanicAssignedToOneViewReturn(), // Mechanic_Assigned_To_2_View
      mechanicAssignedToTwoViewReturn(), // Mechanic_Assigned_To_3_View
      mechanicAssignedToThreeViewReturn(), // Scheduled_Maintenance_View
      scheduledMaintenanceViewReturn(), // Mel_View
      if (controller.discrepancyEditApiData['discrepancyType'].toString() == '0') melViewReturn(), // ATA_Code_View
      if (controller.discrepancyEditApiData['discrepancyType'].toString() == '0') ataCodeViewReturn(), // Discrepancy_Service_Status_View
      discrepancyServiceStatusViewReturn(), // Corrective_Action_View
      correctiveActionViewReturn(), // Post_Maintenance_Activities
      postMaintenanceActivitiesViewReturn(), // Associated_Work_Order_View
      associatedWorkOrderViewReturn(), // Client's_Purchase_Order_Number_View
      clientsPurchaseOrderNumberViewReturn(), // Attachments_And_LogBooks
      attachmentsAndLogBooksViewReturn(), // Notification_View
      notificationViewReturn(), // Previous_Notes_View
      previousNotesViewReturn(), // New_Notes_View
      newNotesViewReturn(),
    ]);
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
              style:
                  TextStyle(color: Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
          ),
        ),
      ),
    );
  }

  equipmentEditViewReturn() {
    switch (controller.discrepancyEditApiData['discrepancyType']) {
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
                    Text(controller.discrepancyEditApiData['equipmentName'].toString().split(' ').first,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    DiscrepancyAndWorkOrdersMaterialButton(
                        iconColor: ColorConstants.white,
                        buttonColor: ColorConstants.primary,
                        buttonText: controller.discrepancyEditApiData['equipmentName'].toString().split('-').last),
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
                buttonText: controller.discrepancyEditApiData['equipmentName'].toString(),
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
                    Text(controller.discrepancyEditApiData['equipmentName'].toString().split('-').first,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: (controller.discrepancyEditApiData['equipmentName'].toString().split('-')[1]) == ' (None) '
                          ? 'Not Found'
                          : controller.discrepancyEditApiData['equipmentName'].toString().split('-')[1],
                    ),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: Icons.open_in_new,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: controller.discrepancyEditApiData['equipmentName'].toString().split(')').last,
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
                child: Text(controller.discrepancyEditApiData['equipmentName'],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
              )
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  additionalInformationEditViewReturn() {
    switch (controller.discrepancyEditApiData['discrepancyType']) {
      case 0:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerTitleReturn(title: 'Additional Information At The Time Of Issue'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.discrepancyEditTextController.putIfAbsent('acTT', () => TextEditingController()),
                        maxCharacterLength: 9,
                        dataType: 'number',
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        fieldName: 'AC TT',
                        onChanged: (value) {
                          controller.editDiscrepancyUpdateApiData['HobbsName'] = value;
                        }),
                    DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.discrepancyEditTextController.putIfAbsent('landing', () => TextEditingController()),
                        maxCharacterLength: 9,
                        dataType: 'number',
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        fieldName: 'Landings',
                        onChanged: (value) {
                          controller.editDiscrepancyUpdateApiData['Landings'] = value;
                        }),
                    DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.discrepancyEditTextController.putIfAbsent('torque_events', () => TextEditingController()),
                        maxCharacterLength: 9,
                        dataType: 'number',
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        fieldName: 'Torque Events',
                        onChanged: (value) {
                          controller.editDiscrepancyUpdateApiData['TorqueEvents'] = value;
                        }),
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
                      children: [
                        DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine1TTName', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth: DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                            fieldName: 'Engine #1 TT',
                            onChanged: (value) {
                              controller.editDiscrepancyUpdateApiData['Engine1TTName'] = value;
                            }),
                        DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine1Starts', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth: DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                            fieldName: 'Engine #1 Starts',
                            onChanged: (value) {
                              controller.editDiscrepancyUpdateApiData['Engine1Starts'] = value;
                            }),
                      ],
                    ),
                    if (controller.discrepancyEditApiData['engine2Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine2TTName', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #2 TT',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine2TTName'] = value;
                              }),
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine2Starts', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #2 Starts',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine2Starts'] = value;
                              }),
                        ],
                      ),
                    if (controller.discrepancyEditApiData['engine3Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine3TTName', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #3 TT',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine3TTName'] = value;
                              }),
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine3Starts', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #3 Starts',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine3Starts'] = value;
                              }),
                        ],
                      ),
                    if (controller.discrepancyEditApiData['engine4Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine4TTName', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #4 TT',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine4TTName'] = value;
                              }),
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine4Starts', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #4 Starts',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine4Starts'] = value;
                              }),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerTitleReturn(title: 'Additional Information At The Time Of Issue'),
            ],
          ),
        );
      case 2 || 3 || 4 || 5:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerTitleReturn(title: 'Additional Information At The Time Of Issue'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: controller.additionalInformationViewForLogicalDataOne()
                      ? [
                          RichText(
                            text: TextSpan(
                                text: 'Component Name: ',
                                style: TextStyle(
                                    color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: controller.discrepancyEditApiData['outsideComponentName'],
                                      style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Part Number: ',
                                style: TextStyle(
                                    color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: DataUtils.isNullOrEmptyString(controller.discrepancyEditApiData['outsideComponentPartNumber'])
                                          ? "(None)"
                                          : controller.discrepancyEditApiData['outsideComponentPartNumber'],
                                      style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Serial Number: ',
                                style: TextStyle(
                                    color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: DataUtils.isNullOrEmptyString(controller.discrepancyEditApiData['outsideComponentSerialNumber'])
                                          ? "(None)"
                                          : controller.discrepancyEditApiData['outsideComponentSerialNumber'],
                                      style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                ]),
                          )
                        ]
                      : [
                    DiscrepancyAndWorkOrdersTextField(
                              key: controller.gKeyForEdit.putIfAbsent('outsideComponentName', () => GlobalKey()),
                              validationKey: controller.discrepancyEditValidationKeys.putIfAbsent("outsideComponentName", () => GlobalKey<FormFieldState>()),
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('outsideComponentName', () => TextEditingController()),
                              dataType: 'text',
                              req: true,
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Component Name',
                              hintText: 'Component Name',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['OutsideComponentName'] = value;
                              }),
                    DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController()),
                              dataType: 'text',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Part Number',
                              hintText: 'Part Number',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = value;
                              }),
                    DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController()),
                              dataType: 'text',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Serial Number',
                              hintText: 'Serial Number',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = value;
                              }),
                        ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: controller.additionalInformationViewForLogicalDataTwo()
                      ? [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5.0,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Service Life Type# 1: ',
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: DataUtils.isNullOrEmptyString(controller.discrepancyEditApiData['componentServiceLife1TypeName'])
                                              ? "(None)"
                                              : controller.discrepancyEditApiData['componentServiceLife1TypeName'],
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Service Life Type# 2: ',
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: DataUtils.isNullOrEmptyString(controller.discrepancyEditApiData['componentServiceLife2TypeName'])
                                              ? "(None)"
                                              : controller.discrepancyEditApiData['componentServiceLife2TypeName'],
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
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
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: controller.discrepancyEditApiData['componentServiceLife1SinceNewAmt'],
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Since New Amount: ',
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: controller.discrepancyEditApiData['componentServiceLife2SinceNewAmt'],
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
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
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: controller.discrepancyEditApiData['componentServiceLife1SinceOhAmt'],
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Since O/H Amount: ',
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: controller.discrepancyEditApiData['componentServiceLife2SinceOhAmt'],
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
                              ),
                            ],
                          ),
                        ]
                      : [
                          Column(
                            children: [
                              DiscrepancyAndWorkOrdersDropDown(
                                expands: true,
                                textFieldWidth: DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                                dropDownController: controller.discrepancyEditTextController.putIfAbsent('componentServiceLife1Type', () => TextEditingController()),
                                dropDownKey: 'name',
                                dropDownData: controller.serviceLifeTypeOneDropdownData,
                                hintText: controller.selectedServiceLifeTypeOneDropdown.isNotEmpty
                                    ? controller.selectedServiceLifeTypeOneDropdown['name']
                                    : controller.serviceLifeTypeOneDropdownData.isNotEmpty
                                        ? controller.serviceLifeTypeOneDropdownData[1]['name']
                                        : "-- Select Service Life --",
                                fieldName: "Service Life Type #1",
                                onChanged: (value) async {
                                  controller.selectedServiceLifeTypeOneDropdown.value = value;
                                  controller.editDiscrepancyUpdateApiData['ComponentServiceLife1Type'] = controller.selectedServiceLifeTypeOneDropdown['id'];
                                  controller.editDiscrepancyUpdateApiData['ComponentServiceLife1TypeName'] = controller.selectedServiceLifeTypeOneDropdown['name'];
                                },
                              ),
                              DiscrepancyAndWorkOrdersDropDown(
                                expands: true,
                                textFieldWidth: DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                                dropDownController: controller.discrepancyEditTextController.putIfAbsent('componentServiceLife2Type', () => TextEditingController()),
                                dropDownKey: 'name',
                                dropDownData: controller.serviceLifeTypeTwoDropdownData,
                                hintText: controller.selectedServiceLifeTypeTwoDropdown.isNotEmpty
                                    ? controller.selectedServiceLifeTypeTwoDropdown['name']
                                    : controller.serviceLifeTypeTwoDropdownData.isNotEmpty
                                        ? controller.serviceLifeTypeTwoDropdownData[1]['name']
                                        : "-- Select Service Life --",
                                fieldName: "Service Life Type #2",
                                onChanged: (value) async {
                                  controller.selectedServiceLifeTypeTwoDropdown.value = value;
                                  controller.editDiscrepancyUpdateApiData['ComponentServiceLife2Type'] = controller.selectedServiceLifeTypeTwoDropdown['id'];
                                  controller.editDiscrepancyUpdateApiData['ComponentServiceLife2TypeName'] = controller.selectedServiceLifeTypeTwoDropdown['name'];
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              DiscrepancyAndWorkOrdersTextField(
                                  textFieldController:
                                      controller.discrepancyEditTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController()),
                                  dataType: 'number',
                                  textFieldWidth: DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                                  fieldName: 'Since New Amount',
                                  onChanged: (value) {
                                    controller.editDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = value;
                                  }),
                              DiscrepancyAndWorkOrdersTextField(
                                  textFieldController:
                                      controller.discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController()),
                                  dataType: 'number',
                                  textFieldWidth: DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                                  fieldName: 'Since New Amount',
                                  onChanged: (value) {
                                    controller.editDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = value;
                                  }),
                            ],
                          ),
                          Column(
                            children: [
                              DiscrepancyAndWorkOrdersTextField(
                                  textFieldController:
                                      controller.discrepancyEditTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController()),
                                  dataType: 'number',
                                  textFieldWidth: DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                                  fieldName: 'Since O/H Amount',
                                  onChanged: (value) {
                                    controller.editDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = value;
                                  }),
                              DiscrepancyAndWorkOrdersTextField(
                                  textFieldController:
                                      controller.discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController()),
                                  dataType: 'number',
                                  textFieldWidth: DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                                  fieldName: 'Since O/H Amount',
                                  onChanged: (value) {
                                    controller.editDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = value;
                                  }),
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

  discoveredEditViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Discovered'),
          controller.discrepancyEditApiData['status'] == 'Completed'
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 10.0,
                    runSpacing: 5.0,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Discovered: ',
                            style: TextStyle(
                                color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.discrepancyEditApiData['discoveredByName'],
                                  style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'License Number: ',
                            style: TextStyle(
                                color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                  text: DataUtils.isNullOrEmptyString(controller.discrepancyEditApiData['discoveredByLicenseNumber'])
                                      ? 'None'
                                      : controller.discrepancyEditApiData['discoveredByLicenseNumber'],
                                  style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Date: ',
                            style: TextStyle(
                                color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                  text: DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.parse(controller.discrepancyEditApiData['createdAt'])),
                                  style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            ]),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(alignment: WrapAlignment.spaceBetween, spacing: 10.0, runSpacing: 5.0, children: [
                    DiscrepancyAndWorkOrdersDropDown(
                      key: controller.gKeyForEdit.putIfAbsent('discoveredBy', () => GlobalKey()),
                      expands: true,
                      textFieldWidth: DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                              ? (Get.width / 3) - 80
                              : (Get.width / 2) - 80
                          : Get.width,
                      dropDownController: controller.discrepancyEditTextController.putIfAbsent('discoveredBy', () => TextEditingController()),
                      dropDownKey: 'name',
                      req: true,
                      dropDownData: controller.discoveredByDropdownData,
                      hintText: controller.selectedDiscoveredByDropdown.isNotEmpty
                          ? controller.selectedDiscoveredByDropdown['name']
                          : controller.discoveredByDropdownData.isNotEmpty
                              ? controller.discoveredByDropdownData[1]['name']
                              : "-- Discovered By --",
                      fieldName: "Discovered",
                      onChanged: (value) async {
                        controller.selectedDiscoveredByDropdown.value = value;
                        controller.editDiscrepancyUpdateApiData['DiscoveredBy'] = int.parse(controller.selectedDiscoveredByDropdown['id'].toString());
                        controller.editDiscrepancyUpdateApiData['DiscoveredByName'] = controller.selectedDiscoveredByDropdown['name'];
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.discrepancyEditTextController.putIfAbsent('discoveredByLicenseNumber', () => TextEditingController()),
                        dataType: 'text',
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        fieldName: 'License Number',
                        onChanged: (value) {
                          controller.editDiscrepancyUpdateApiData['DiscoveredByLicenseNumber'] = value;
                        }),
                    DeviceType.isTablet
                        ? Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, children: [
                            SizedBox(
                              width: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 4) - 200
                                      : (Get.width / 3) - 100
                                  : Get.width / 3,
                              child: DiscrepancyAndWorkOrdersDateTime(
                                fieldName: "Date",
                                isDense: true,
                                disableKeyboard: controller.disableKeyboard,
                                dateTimeController: controller.discrepancyEditTextController.putIfAbsent('createdAt',
                                    () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTime.parse(controller.discrepancyEditApiData['createdAt'])))),
                                dateType: "date",
                                onConfirm: (dateTime) {
                                  controller.editDiscrepancyUpdateApiData["CreatedAt"] = dateTime;
                                  controller.discrepancyEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                                },
                              ),
                            ),
                      DiscrepancyAndWorkOrdersDropDown(
                              dropDownController: controller.discrepancyEditTextController.putIfAbsent('time', () => TextEditingController()),
                              dropDownKey: 'name',
                              dropDownData: controller.timeDropDownData,
                              hintText: controller.selectedTimeDropDown.isNotEmpty
                                  ? controller.selectedTimeDropDown['name']
                                  : controller.timeDropDownData.isNotEmpty
                                      ? controller.timeDropDownData[0]['name']
                                      : "00:00",
                              fieldName: "Time",
                              onChanged: (value) async {
                                controller.selectedTimeDropDown.value = value;
                                controller.editDiscrepancyUpdateApiData["CreatedAt"] =
                                    '${controller.editDiscrepancyUpdateApiData["CreatedAt"].toString().split(' ').first}T${controller.selectedTimeDropDown['name']}';
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.date_range_sharp,
                                iconColor: ColorConstants.button,
                                buttonColor: ColorConstants.black,
                                buttonText: "Date Now",
                                buttonTextColor: Colors.white,
                                onPressed: () {
                                  controller.discrepancyEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                                  String a = DateTimeHelper.now.toString().split(' ').first;
                                  String b = DateTimeHelper.now.toString().split(' ').last;
                                  String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                                  String f = '${a}T$c';
                                  controller.editDiscrepancyUpdateApiData["CreatedAt"] = f;
                                  controller.selectedTimeDropDown.clear();
                                  controller.selectedTimeDropDown.addAll({
                                    "id": 50,
                                    "name": DateFormat("HH:mm").format(DateTime.parse(f)),
                                  });
                                  controller.discrepancyEditTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
                                  controller.update();
                                },
                              ),
                            )
                          ])
                        : Wrap(
                            //alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 10.0,
                            runSpacing: 5.0,
                            children: [
                                SizedBox(
                                  width: Get.width / 3,
                                  child: DiscrepancyAndWorkOrdersDateTime(
                                    fieldName: "Date",
                                    isDense: true,
                                    disableKeyboard: controller.disableKeyboard,
                                    dateTimeController: controller.discrepancyEditTextController.putIfAbsent(
                                        'createdAt',
                                        () =>
                                            TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTime.parse(controller.discrepancyEditApiData['createdAt'])))),
                                    dateType: "date",
                                    onConfirm: (dateTime) {
                                      controller.editDiscrepancyUpdateApiData["CreatedAt"] = dateTime;
                                      controller.discrepancyEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                                    },
                                  ),
                                ),
                              DiscrepancyAndWorkOrdersDropDown(
                                  expands: false,
                                  textFieldWidth: Get.width / 3,
                                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('time', () => TextEditingController()),
                                  dropDownKey: 'name',
                                  dropDownData: controller.timeDropDownData,
                                  hintText: controller.selectedTimeDropDown.isNotEmpty
                                      ? controller.selectedTimeDropDown['name']
                                      : controller.timeDropDownData.isNotEmpty
                                          ? controller.timeDropDownData[0]['name']
                                          : "00:00",
                                  fieldName: "Time",
                                  onChanged: (value) async {
                                    controller.selectedTimeDropDown.value = value;
                                    controller.editDiscrepancyUpdateApiData["CreatedAt"] =
                                        '${controller.editDiscrepancyUpdateApiData["CreatedAt"].toString().split(' ').first}T${controller.selectedTimeDropDown['name']}';
                                  },
                                ),
                              DiscrepancyAndWorkOrdersMaterialButton(
                                  icon: Icons.date_range_sharp,
                                  iconColor: ColorConstants.button,
                                  buttonColor: ColorConstants.black,
                                  buttonText: "Date Now",
                                  buttonTextColor: Colors.white,
                                  onPressed: () {
                                    controller.discrepancyEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                                    String a = DateTimeHelper.now.toString().split(' ').first;
                                    String b = DateTimeHelper.now.toString().split(' ').last;
                                    String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                                    String f = '${a}T$c';
                                    controller.editDiscrepancyUpdateApiData["CreatedAt"] = f;
                                    controller.selectedTimeDropDown.clear();
                                    controller.selectedTimeDropDown.addAll({
                                      "id": 50,
                                      "name": DateFormat("HH:mm").format(DateTime.parse(f)),
                                    });
                                    controller.discrepancyEditTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
                                    controller.update();
                                  },
                                )
                              ])
                  ]),
                ),
        ],
      ),
    );
  }

  descriptionEditViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Description'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiscrepancyAndWorkOrdersTextField(
                key: controller.gKeyForEdit.putIfAbsent('discrepancy', () => GlobalKey()),
                validationKey: controller.discrepancyEditValidationKeys.putIfAbsent("discrepancy", () => GlobalKey<FormFieldState>()),
                textFieldController: controller.discrepancyEditTextController.putIfAbsent('discrepancy', () => TextEditingController()),
                req: true,
                dataType: 'text',
                maxCharacterLength: 2000,
                maxLines: 5,
                showCounter: true,
                textFieldWidth: Get.width,
                fieldName: 'Description',
                onChanged: (value) {
                  controller.editDiscrepancyUpdateApiData['Discrepancy'] = value;
                }),
          ),
        ],
      ),
    );
  }

  statusEditViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Obx(() {
        return Column(
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
                  (controller.discrepancyEditApiData['status'] != 'Completed' && Get.parameters['action'] == 'discrepancyEdit')
                      ? DiscrepancyAndWorkOrdersDropDown(
                          expands: true,
                          textFieldWidth: DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                          dropDownController: controller.discrepancyEditTextController.putIfAbsent('status', () => TextEditingController()),
                          statusEnable: true,
                          dropDownKey: 'name',
                          completeColor: controller.selectedStatusDropdown['name'] == 'Completed' ? true : false,
                          dropDownData: controller.statusDropdownData,
                          hintText: controller.selectedStatusDropdown.isNotEmpty
                              ? controller.selectedStatusDropdown['name']
                              : controller.statusDropdownData.isNotEmpty
                                  ? controller.statusDropdownData[1]['name']
                                  : "--  --",
                          fieldName: "Status",
                          onChanged: (value) async {
                            controller.selectedStatusDropdown.value = value;
                            controller.editDiscrepancyUpdateApiData['Status'] = controller.selectedStatusDropdown['id'];
                            controller.update();
                          },
                        )
                      : SizedBox(
                          width: Get.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 10.0,
                            runSpacing: 5.0,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Status: ',
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${controller.discrepancyEditApiData['status']} [Green]',
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.green : Colors.green,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Corrected By: ',
                                    style: TextStyle(
                                        color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: DataUtils.isNullOrEmptyString(controller.discrepancyEditApiData['correctedByName'])
                                              ? 'None'
                                              : '${controller.discrepancyEditApiData['correctedByName']} At ${DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(controller.discrepancyEditApiData['dateCorrected']))}',
                                          style: TextStyle(
                                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            if (controller.selectedStatusDropdown['id'] == 'Completed')
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
                        SizedBox(
                          width: Get.width,
                          child: Wrap(
                            // spacing: 10.0,
                            //runSpacing: 5.0,
                            children: [
                              DiscrepancyAndWorkOrdersTextField(
                                  textFieldController: controller.discrepancyEditTextController.putIfAbsent('acttCompletedAt', () => TextEditingController()),
                                  dataType: 'number',
                                  textFieldWidth: DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                                  fieldName: 'AC TT @ Completed',
                                  onChanged: (value) {
                                    controller.editDiscrepancyUpdateApiData['ACTTCompletedAt'] = value;
                                  }),
                              Padding(
                                padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : const EdgeInsets.only(top: 0.0),
                                child: DiscrepancyAndWorkOrdersTextButton(
                                  fieldName: '[Load Current Value]',
                                  onPressed: () async {
                                    if (controller.discrepancyEditApiData['unitId'] > 0) {
                                      LoaderHelper.loaderWithGif();
                                      await controller.loadCurrentValueForCompleteDiscrepancy(unitId: controller.discrepancyEditApiData['unitId'].toString());
                                    } else {
                                      LoaderHelper.loaderWithGif();
                                      await controller.loadCurrentValueForCompleteDiscrepancy(unitId: '1');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth: DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                            fieldName: 'Engine #1 TT @ Completed',
                            onChanged: (value) {
                              controller.editDiscrepancyUpdateApiData['Engine1TTCompletedAt'] = value;
                            }),
                        if (controller.discrepancyEditApiData['engine2Enabled'])
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #2 TT @ Completed',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine2TTCompletedAt'] = value;
                              }),
                        if (controller.discrepancyEditApiData['engine3Enabled'])
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #3 TT @ Completed',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine3TTCompletedAt'] = value;
                              }),
                        if (controller.discrepancyEditApiData['engine4Enabled'])
                          DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'Engine #4 TT @ Completed',
                              onChanged: (value) {
                                controller.editDiscrepancyUpdateApiData['Engine4TTCompletedAt'] = value;
                              }),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  mechanicAssignedToOneViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Mechanic Assigned To #1'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.discrepancyEditApiData['status'] != 'Completed'
                    ? SizedBox(
                        width: Get.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 10.0,
                          runSpacing: 5.0,
                          children: [
                            DiscrepancyAndWorkOrdersDropDown(
                              expands: true,
                              textFieldWidth: DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                              dropDownController: controller.discrepancyEditTextController.putIfAbsent('mechanicAssignedTo1', () => TextEditingController()),
                              dropDownKey: 'name',
                              dropDownData: controller.mechanicAssignedToOneDropdownData,
                              hintText: controller.selectedMechanicAssignedToOneDropdown.isNotEmpty
                                  ? controller.selectedMechanicAssignedToOneDropdown['name']
                                  : controller.mechanicAssignedToOneDropdownData.isNotEmpty
                                      ? controller.mechanicAssignedToOneDropdownData[0]['name']
                                      : "-- Not Assigned --",
                              fieldName: "Mechanic Assigned To #1",
                              onChanged: (value) async {
                                controller.selectedMechanicAssignedToOneDropdown.value = value;
                                controller.editDiscrepancyUpdateApiData['AssignedTo'] = int.parse(controller.selectedMechanicAssignedToOneDropdown['id'].toString());
                                controller.editDiscrepancyUpdateApiData['MechanicAssignedTo1'] = controller.selectedMechanicAssignedToOneDropdown['name'];
                              },
                            ),
                            DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.discrepancyEditTextController.putIfAbsent('correctedByLicenseNumber', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth: DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                                fieldName: 'License Number',
                                onChanged: (value) {
                                  controller.editDiscrepancyUpdateApiData['CorrectedByLicenseNumber'] = value;
                                }),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: Get.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 10.0,
                          runSpacing: 5.0,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Mechanic Assigned To #1: ',
                                  style: TextStyle(
                                      color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: DataUtils.isNullOrEmptyString(controller.editDiscrepancyUpdateApiData['mechanicAssignedTo1'])
                                            ? 'Not Specified'
                                            : controller.editDiscrepancyUpdateApiData['mechanicAssignedTo1'],
                                        style: TextStyle(
                                            color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                            fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                  ]),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'License Number: ',
                                  style: TextStyle(
                                      color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: controller.discrepancyEditApiData['correctedByLicenseNumber'],
                                        style: TextStyle(
                                            color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                            fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                  ]),
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

  mechanicAssignedToTwoViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Mechanic Assigned To #2'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.discrepancyEditApiData['status'] != 'Completed'
                    ? DiscrepancyAndWorkOrdersDropDown(
                        expands: true,
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        dropDownController: controller.discrepancyEditTextController.putIfAbsent('mechanicAssignedTo2', () => TextEditingController()),
                        dropDownKey: 'name',
                        dropDownData: controller.mechanicAssignedToTwoDropdownData,
                        hintText: controller.selectedMechanicAssignedToTwoDropdown.isNotEmpty
                            ? controller.selectedMechanicAssignedToTwoDropdown['name']
                            : controller.mechanicAssignedToTwoDropdownData.isNotEmpty
                                ? controller.mechanicAssignedToTwoDropdownData[0]['name']
                                : "-- Not Assigned --",
                        fieldName: "Mechanic Assigned To #2",
                        onChanged: (value) async {
                          controller.selectedMechanicAssignedToTwoDropdown.value = value;
                          controller.editDiscrepancyUpdateApiData['AssignedTo2'] = int.parse(controller.selectedMechanicAssignedToTwoDropdown['id'].toString());
                          controller.editDiscrepancyUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToTwoDropdown['name'];
                        },
                      )
                    : RichText(
                        text: TextSpan(
                            text: 'Mechanic Assigned To #2: ',
                            style: TextStyle(
                                color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                  text: DataUtils.isNullOrEmptyString(controller.editDiscrepancyUpdateApiData['mechanicAssignedTo2'])
                                      ? 'Not Specified'
                                      : controller.editDiscrepancyUpdateApiData['mechanicAssignedTo2'],
                                  style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            ]),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  mechanicAssignedToThreeViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Mechanic Assigned To #3'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.discrepancyEditApiData['status'] != 'Completed'
                    ? DiscrepancyAndWorkOrdersDropDown(
                        expands: true,
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        dropDownController: controller.discrepancyEditTextController.putIfAbsent('mechanicAssignedTo3', () => TextEditingController()),
                        dropDownKey: 'name',
                        dropDownData: controller.mechanicAssignedToThreeDropdownData,
                        hintText: controller.selectedMechanicAssignedToThreeDropdown.isNotEmpty
                            ? controller.selectedMechanicAssignedToThreeDropdown['name']
                            : controller.mechanicAssignedToThreeDropdownData.isNotEmpty
                                ? controller.mechanicAssignedToThreeDropdownData[1]['name']
                                : "-- Not Assigned --",
                        fieldName: "Mechanic Assigned To #3",
                        onChanged: (value) async {
                          controller.selectedMechanicAssignedToThreeDropdown.value = value;
                          controller.editDiscrepancyUpdateApiData['AssignedTo3'] = int.parse(controller.selectedMechanicAssignedToThreeDropdown['id'].toString());
                          controller.editDiscrepancyUpdateApiData['MechanicAssignedTo4'] = controller.selectedMechanicAssignedToThreeDropdown['name'];
                        },
                      )
                    : RichText(
                        text: TextSpan(
                            text: 'Mechanic Assigned To #3: ',
                            style: TextStyle(
                                color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                  text: DataUtils.isNullOrEmptyString(controller.editDiscrepancyUpdateApiData['mechanicAssignedTo2'])
                                      ? 'Not Specified'
                                      : controller.editDiscrepancyUpdateApiData['mechanicAssignedTo2'],
                                  style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            ]),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
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
                controller.discrepancyEditApiData['status'] != 'Completed'
                    ? DiscrepancyAndWorkOrdersDropDown(
                        expands: true,
                        textFieldWidth: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                        dropDownController: controller.discrepancyEditTextController.putIfAbsent('scheduleMtnc', () => TextEditingController()),
                        dropDownKey: 'name',
                        dropDownData: controller.scheduledMaintenanceDropdownData,
                        hintText: controller.selectedScheduledMaintenanceDropdown.isNotEmpty
                            ? controller.selectedScheduledMaintenanceDropdown['name']
                            : controller.scheduledMaintenanceDropdownData.isNotEmpty
                                ? controller.scheduledMaintenanceDropdownData[1]['name']
                                : "-- Not Assigned --",
                        fieldName: "Scheduled Maintenance",
                        onChanged: (value) async {
                          controller.selectedScheduledMaintenanceDropdown.value = value;
                          controller.editDiscrepancyUpdateApiData['ScheduleMtnc'] = int.parse(controller.selectedScheduledMaintenanceDropdown['id'].toString());
                        },
                      )
                    : RichText(
                        text: TextSpan(
                            text: 'Scheduled Maintenance: ',
                            style: TextStyle(
                                color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                            children: <TextSpan>[
                              TextSpan(
                                  text: controller.discrepancyEditApiData['scheduleMtnc'].toString() == '0' ? 'No' : 'Yes',
                                  style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            ]),
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
            child: DiscrepancyAndWorkOrdersDropDown(
              expands: true,
              textFieldWidth: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 80
                      : (Get.width / 2) - 80
                  : Get.width,
              dropDownController: controller.discrepancyEditTextController.putIfAbsent('mel', () => TextEditingController()),
              dropDownKey: 'name',
              dropDownData: controller.melDropdownData,
              hintText: controller.selectedMelDropdown.isNotEmpty
                  ? controller.selectedMelDropdown['name']
                  : controller.melDropdownData.isNotEmpty
                      ? controller.melDropdownData[1]['name']
                      : "-- No --",
              fieldName: "MEL",
              onChanged: (value) async {
                controller.selectedMelDropdown.value = value;
                controller.editDiscrepancyUpdateApiData['Mel'] = int.parse(controller.selectedMelDropdown['id'].toString());
              },
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
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    DiscrepancyAndWorkOrdersTextField(
                        key: controller.gKeyForEdit.putIfAbsent('ataCode', () => GlobalKey()),
                        textFieldController: controller.discrepancyEditTextController.putIfAbsent('ataCode', () => TextEditingController()),
                        validationKey: controller.discrepancyEditValidationKeys.putIfAbsent("ataCode", () => GlobalKey<FormFieldState>()),
                        dataType: 'text',
                        textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                        req: (controller.selectedStatusDropdown['id'] ?? "") == 'Completed' ? true : false,
                        fieldName: 'ATA Code',
                        onChanged: (value) {
                          controller.editDiscrepancyUpdateApiData['ATACode'] = value;
                        }),
                    Padding(
                      padding: DeviceType.isTablet ? const EdgeInsets.only(top: 30.0) : const EdgeInsets.only(top: 0.0),
                      child: DiscrepancyAndWorkOrdersMaterialButton(
                        icon: Icons.search_sharp,
                        iconColor: ColorConstants.white,
                        buttonColor: ColorConstants.black,
                        buttonText: "Find ATA Code",
                        buttonTextColor: Colors.white,
                        onPressed: () async {
                          if (controller.ataCodeData.isNotNullOrEmpty) {
                            await controller.ataCodeDialogView(editView: 'edit');
                          } else {
                            LoaderHelper.loaderWithGif();
                            await controller.ataDataViewAPICall();
                          }
                        },
                      ),
                    )
                  ],
                ),
                DiscrepancyAndWorkOrdersTextField(
                    textFieldController: controller.discrepancyEditTextController.putIfAbsent('atamcnCode', () => TextEditingController()),
                    dataType: 'text',
                    textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                    fieldName: 'MNC Code',
                    onChanged: (value) {
                      controller.editDiscrepancyUpdateApiData['ATAMCNCode'] = value;
                    }),
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
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('systemAffected', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.systemAffectedDropDownData,
                  hintText: controller.selectedSystemAffectedDropdown.isNotEmpty
                      ? controller.selectedSystemAffectedDropdown['name']
                      : controller.systemAffectedDropDownData.isNotEmpty
                          ? controller.systemAffectedDropDownData[0]['name']
                          : "-- Not Assigned --",
                  fieldName: "System Affected",
                  onChanged: (value) async {
                    controller.selectedSystemAffectedDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['SystemAffected'] = controller.selectedSystemAffectedDropdown['id'];
                  },
                ),
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('functionalGroup', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.functionalGroupDropDownData,
                  hintText: controller.selectedFunctionalGroupDropdown.isNotEmpty
                      ? controller.selectedFunctionalGroupDropdown['name']
                      : controller.functionalGroupDropDownData.isNotEmpty
                          ? controller.functionalGroupDropDownData[0]['name']
                          : "-- Not Assigned --",
                  fieldName: "Functional Group",
                  onChanged: (value) async {
                    controller.selectedFunctionalGroupDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['FunctionalGroup'] = controller.selectedFunctionalGroupDropdown['id'];
                  },
                ),
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('malfunctionEffect', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.malFunctionEffectDropDownData,
                  hintText: controller.selectedMalFunctionEffectDropdown.isNotEmpty
                      ? controller.selectedMalFunctionEffectDropdown['name']
                      : controller.malFunctionEffectDropDownData.isNotEmpty
                          ? controller.malFunctionEffectDropDownData[0]['name']
                          : "-- Not Assigned --",
                  fieldName: "Malfunction Effect",
                  onChanged: (value) async {
                    controller.selectedMalFunctionEffectDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['MalfunctionEffect'] = controller.selectedMalFunctionEffectDropdown['id'];
                  },
                ),
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('whenDiscoveredName', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.whenDiscoveredDropDownData,
                  hintText: controller.selectedWhenDiscoveredDropdown.isNotEmpty
                      ? controller.selectedWhenDiscoveredDropdown['name']
                      : controller.whenDiscoveredDropDownData.isNotEmpty
                          ? controller.whenDiscoveredDropDownData[0]['name']
                          : "-- Not Assigned --",
                  fieldName: "When Discovered",
                  onChanged: (value) async {
                    controller.selectedWhenDiscoveredDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['WhenDiscovered'] = controller.selectedWhenDiscoveredDropdown['id'];
                  },
                ),
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('howRecognized', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.howRecognizedDropDownData,
                  hintText: controller.selectedHowRecognizedDropdown.isNotEmpty
                      ? controller.selectedHowRecognizedDropdown['name']
                      : controller.howRecognizedDropDownData.isNotEmpty
                          ? controller.howRecognizedDropDownData[0]['name']
                          : "-- Not Assigned --",
                  fieldName: "How Recognized",
                  onChanged: (value) async {
                    controller.selectedHowRecognizedDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['HowRecognized'] = controller.selectedHowRecognizedDropdown['id'];
                  },
                ),
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('missionFlightType', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.missionFlightTypeDropDownData,
                  hintText: controller.selectedMissionFlightTypeDropdown.isNotEmpty
                      ? controller.selectedMissionFlightTypeDropdown['name']
                      : controller.missionFlightTypeDropDownData.isNotEmpty
                          ? controller.missionFlightTypeDropDownData[0]['name']
                          : "-- Not Assigned --",
                  fieldName: "Mission Flight Type",
                  onChanged: (value) async {
                    controller.selectedMissionFlightTypeDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['MissionFlightType'] = controller.selectedMissionFlightTypeDropdown['id'];
                  },
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
            child: Obx(() {
              return DiscrepancyAndWorkOrdersTextField(
                  key: controller.gKeyForEdit.putIfAbsent('correctiveAction', () => GlobalKey()),
                  validationKey: controller.discrepancyEditValidationKeys.putIfAbsent("correctiveAction", () => GlobalKey<FormFieldState>()),
                  textFieldController: controller.discrepancyEditTextController.putIfAbsent('correctiveAction', () => TextEditingController()),
                  dataType: 'text',
                  req: (controller.selectedStatusDropdown['id'] ?? "") == 'Completed' ? true : false,
                  maxCharacterLength: 5000,
                  maxLines: 5,
                  showCounter: true,
                  textFieldWidth: Get.width,
                  fieldName: 'Corrective Action',
                  hintText: 'Discrepancy\'s Corrective Action Performed here....',
                  onChanged: (value) {
                    controller.editDiscrepancyUpdateApiData['CorrectiveAction'] = value;
                  });
            }),
          ),
        ],
      ),
    );
  }

  postMaintenanceActivitiesViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Post Maintenance Activities'),
          if (controller.discrepancyEditApiData['discrepancyType'].toString() == '0')
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
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        Switch(
                          value: controller.discrepancyEditApiData['checkGroundRunRequired'],
                          onChanged: (value) {
                            controller.discrepancyEditApiData['checkGroundRunRequired'] = value;
                            controller.editDiscrepancyUpdateApiData['CheckGroundRunRequired'] = controller.discrepancyEditApiData['checkGroundRunRequired'];
                          },
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
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        Switch(
                          value: controller.discrepancyEditApiData['checkFlightRequired'],
                          onChanged: (value) {
                            controller.discrepancyEditApiData['checkFlightRequired'] = value;
                            controller.editDiscrepancyUpdateApiData['CheckFlightRequired'] = controller.discrepancyEditApiData['checkFlightRequired'];
                          },
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
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        Switch(
                          value: controller.discrepancyEditApiData['leakTestRequired'],
                          onChanged: (value) {
                            controller.discrepancyEditApiData['leakTestRequired'] = value;
                            controller.editDiscrepancyUpdateApiData['LeakTestRequired'] = controller.discrepancyEditApiData['leakTestRequired'];
                          },
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
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        ),
                        Switch(
                          value: controller.discrepancyEditApiData['additionalInspectionRequired'],
                          onChanged: (value) {
                            controller.discrepancyEditApiData['additionalInspectionRequired'] = value;
                            controller.editDiscrepancyUpdateApiData['AdditionalInspectionRequired'] = controller.discrepancyEditApiData['additionalInspectionRequired'];
                          },
                          activeColor: Colors.green,
                          activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          inactiveThumbColor: Colors.white,
                        ),
                      ],
                    )
                  ],
                )),
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
            child: DiscrepancyAndWorkOrdersDropDown(
              expands: true,
              textFieldWidth: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 80
                      : (Get.width / 2) - 80
                  : Get.width,
              dropDownController: controller.discrepancyEditTextController.putIfAbsent('isWorkOrder', () => TextEditingController()),
              dropDownKey: 'name',
              dropDownData: controller.associatedWorkOrderDropdownData,
              hintText: controller.selectedAssociatedWorkOrderDropdown.isNotEmpty
                  ? controller.selectedAssociatedWorkOrderDropdown['name']
                  : controller.associatedWorkOrderDropdownData.isNotEmpty
                      ? controller.associatedWorkOrderDropdownData[1]['name']
                      : "-- No --",
              fieldName: "Associated Work Order",
              onChanged: (value) async {
                controller.selectedAssociatedWorkOrderDropdown.value = value;
                controller.editDiscrepancyUpdateApiData['IsWorkOrder'] = controller.selectedMelDropdown['id'];
                controller.editDiscrepancyUpdateApiData['WorkOrder'] = controller.selectedMelDropdown['id'].toString();
              },
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
              alignment: WrapAlignment.start,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                DiscrepancyAndWorkOrdersTextField(
                    textFieldController: controller.discrepancyEditTextController.putIfAbsent('purchaseOrder', () => TextEditingController()),
                    dataType: 'text',
                    maxCharacterLength: 20,
                    showCounter: false,
                    textFieldWidth: DeviceType.isTablet
                        ? DeviceOrientation.isLandscape
                            ? (Get.width / 3) - 80
                            : (Get.width / 2) - 80
                        : Get.width,
                    fieldName: 'Client\'s Purchase Order Number',
                    hintText: 'Client\'s Purchase Order Number....',
                    onChanged: (value) {
                      controller.editDiscrepancyUpdateApiData['PurchaseOrder'] = value;
                    }),
                Padding(
                  padding: DeviceType.isTablet ? const EdgeInsets.only(top: 40.0) : const EdgeInsets.only(top: 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: '(For Invoice)',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w300, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
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
              spacing: 10.0,
              children: [
                if (controller.discrepancyEditApiData['attachments'].isEmpty)
                  Text('Complete All Editing Before Adding New Uploads To This Discrepancy',
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 2, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border:
                          TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                      children: [
                        TableRow(
                            decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
                            children: [
                              SizedBox(
                                  width: 180.0,
                                  height: 40.0,
                                  child: Center(
                                      child: Text('Type',
                                          style: TextStyle(
                                              color: ColorConstants.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                            ]),
                        for (int i = 0; i < controller.discrepancyEditApiData['attachments'].length; i++)
                          TableRow(children: [
                            SizedBox(
                                width: 180.0,
                                height: 35.0,
                                child: Center(child: Text('Attachment', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                          ]),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          border: TableBorder.all(
                              color: Colors.black, borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          // border: TableBorder(top: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          children: [
                            TableRow(
                                decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
                                children: [
                                  SizedBox(
                                      width: 450.0,
                                      height: 40.0,
                                      child: Center(
                                          child: Text('File Name',
                                              style: TextStyle(
                                                  color: ColorConstants.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                  SizedBox(
                                      width: 300.0,
                                      height: 40.0,
                                      child: Center(
                                          child: Text('Uploaded At',
                                              style: TextStyle(
                                                  color: ColorConstants.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                  SizedBox(
                                      width: 300.0,
                                      height: 40.0,
                                      child: Center(
                                          child: Text('Uploaded By',
                                              style: TextStyle(
                                                  color: ColorConstants.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                ]),
                            for (int i = 0; i < controller.discrepancyEditApiData['attachments'].length; i++)
                              TableRow(children: [
                                SizedBox(
                                    width: 450.0,
                                    height: 35.0,
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          onTap: () async => await FileControl.getPathAndViewFile(
                                              fileId: controller.discrepancyEditApiData['attachments'][i]['attachmentId'].toString(),
                                              fileName: controller.discrepancyEditApiData['attachments'][i]['fileName'].toString()),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  documentsViewIconReturns(
                                                      types: FileControl.fileType(fileName: controller.discrepancyEditApiData['attachments'][i]['fileName'])),
                                                  size: 25.0,
                                                  color: ColorConstants.primary.withValues(alpha: 0.7)),
                                              Text(controller.discrepancyEditApiData['attachments'][i]['fileName'],
                                                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))),
                                SizedBox(
                                    width: 300.0,
                                    height: 35.0,
                                    child: Center(
                                        child: Text(
                                            DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.parse(controller.discrepancyEditApiData['attachments'][i]['createdAt'])),
                                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                SizedBox(
                                    width: 300.0,
                                    height: 35.0,
                                    child: Center(
                                        child: Text(controller.discrepancyEditApiData['attachments'][i]['fullName'],
                                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                              ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.discrepancyEditApiData['attachments'].isEmpty)
                  Text('No File Attachments', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize))
              ],
            ),
          ),
        ],
      ),
    );
  }

  notificationViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Notification'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Available List: ',
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                          children: <TextSpan>[]),
                    ),
                    Obx(() {
                      return MaterialButton(
                        color: controller.checkboxSelectAllUser.value ? ColorConstants.button : ColorConstants.grey,
                        onPressed: () {
                          controller.checkboxSelectAllUser.value = !controller.checkboxSelectAllUser.value;
                          controller.checkBox.clear();
                          controller.selectedUsersDropdownList.clear();
                          controller.editDiscrepancyUpdateApiData["UsersToNotify"] = "";
                          for (int i = 0; i < controller.userDropDownList.length; i++) {
                            controller.checkBox.add(controller.checkboxSelectAllUser.value);
                          }
                          if (controller.checkboxSelectAllUser.value == true) {
                            for (int i = 0; i < controller.userDropDownList.length; i++) {
                              controller.selectedUsersDropdownList.add(int.parse(controller.userDropDownList[i]["id"]));
                            }
                            controller.editDiscrepancyUpdateApiData["UsersToNotify"] = controller.selectedUsersDropdownList.join(", ");
                          }
                        },
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Select All User',
                                  style: TextStyle(
                                      color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                  children: <TextSpan>[]),
                            ),
                            Checkbox(
                              side: const BorderSide(color: ColorConstants.white, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              value: controller.checkboxSelectAllUser.value,
                              onChanged: (val) {
                                controller.checkboxSelectAllUser.value = val!;
                                controller.checkBox.clear();
                                controller.selectedUsersDropdownList.clear();
                                controller.editDiscrepancyUpdateApiData["UsersToNotify"] = "";
                                for (int i = 0; i < controller.userDropDownList.length; i++) {
                                  controller.checkBox.add(val);
                                }
                                if (controller.checkboxSelectAllUser.value == true) {
                                  for (int i = 0; i < controller.userDropDownList.length; i++) {
                                    controller.selectedUsersDropdownList.add(int.parse(controller.userDropDownList[i]["id"]));
                                  }
                                  controller.editDiscrepancyUpdateApiData["UsersToNotify"] = controller.selectedUsersDropdownList.join(", ");
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: SizeConstants.contentSpacing + 10,
                ),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? 3
                                : 2
                            : DeviceOrientation.isLandscape
                                ? 2
                                : 1,
                        crossAxisSpacing: 40,
                        childAspectRatio: 3 / 2,
                        mainAxisExtent: 80),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.userDropDownList.length,
                    itemBuilder: (context, item) {
                      return Column(
                        children: [
                          Obx(() {
                            return CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              side: const BorderSide(color: ColorConstants.black, width: 2),
                              value: controller.checkBox[item],
                              tileColor: Colors.white,
                              title: Text(controller.userDropDownList[item]["name"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: controller.checkboxSelectAllUser.value == true || controller.checkBox[item] == true
                                          ? ColorConstants.white
                                          : ColorConstants.black,
                                      letterSpacing: 0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(SizeConstants.listItemRadius),
                                side: const BorderSide(color: ColorConstants.primary),
                              ),
                              selected: controller.checkBox[item],
                              selectedTileColor: ColorConstants.primary.withValues(alpha: 0.4),
                              onChanged: (val) async {
                                controller.checkBox[item] = val!;
                                if (controller.checkBox[item] == false) {
                                  controller.selectedUsersDropdownList.clear();
                                  controller.editDiscrepancyUpdateApiData["UsersToNotify"] = "";
                                  controller.checkboxSelectAllUser.value = false;
                                }
                                await controller.selectAllUserCheck();
                              },
                            );
                          }),
                          const SizedBox(
                            height: SizeConstants.contentSpacing,
                          )
                        ],
                      );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  previousNotesViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Previous Notes'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border:
                          TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                      children: [
                        TableRow(
                            decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
                            children: [
                              SizedBox(
                                  width: DeviceType.isTablet ? 250.0 : Get.width / 2.8,
                                  height: 40.0,
                                  child: Center(
                                      child: Text('Date',
                                          style: TextStyle(
                                              color: ColorConstants.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                            ]),
                        for (int i = 0; i < controller.discrepancyEditApiData['notes'].length; i++)
                          TableRow(children: [
                            SizedBox(
                                width: DeviceType.isTablet ? 250.0 : Get.width / 2.8,
                                height: 70.0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.discrepancyEditApiData['notes'][i]['notesCreatedAt'],
                                        textAlign: TextAlign.center, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                                  ),
                                )),
                          ]),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          border: TableBorder.all(
                              color: Colors.black, borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          // border: TableBorder(top: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          children: [
                            TableRow(
                                decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
                                children: [
                                  SizedBox(
                                      width: DeviceType.isTablet ? 300.0 : 200.0,
                                      height: 40.0,
                                      child: Center(
                                          child: Text('User',
                                              style: TextStyle(
                                                  color: ColorConstants.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                  SizedBox(
                                      width: 300.0,
                                      height: 40.0,
                                      child: Center(
                                          child: Text('Note',
                                              style: TextStyle(
                                                  color: ColorConstants.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                ]),
                            for (int i = 0; i < controller.discrepancyEditApiData['notes'].length; i++)
                              TableRow(children: [
                                SizedBox(
                                    width: DeviceType.isTablet ? 300.0 : 200.0,
                                    height: 70.0,
                                    child: Center(
                                        child: Text(controller.discrepancyEditApiData['notes'][i]['fullName'],
                                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                                SizedBox(
                                    width: 300.0,
                                    height: 70.0,
                                    child: Center(
                                        child: Text(controller.discrepancyEditApiData['notes'][i]['notes'],
                                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                              ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.discrepancyEditApiData['attachments'].isEmpty)
                  Center(
                      child: Text('No Note',
                          style:
                              TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize, fontWeight: FontWeight.w600)))
              ],
            ),
          ),
        ],
      ),
    );
  }

  newNotesViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'New Notes'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiscrepancyAndWorkOrdersTextField(
                textFieldController: controller.discrepancyEditTextController.putIfAbsent('newNotes', () => TextEditingController()),
                dataType: 'text',
                maxCharacterLength: 1000,
                maxLines: 4,
                showCounter: true,
                textFieldWidth: Get.width,
                fieldName: 'New Notes',
                hintText: 'Add Note here....',
                onChanged: (value) {
                  controller.editDiscrepancyUpdateApiData['NewNote'] = value;
                }),
          ),
        ],
      ),
    );
  }
}
