import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../helper/loader_helper.dart';
import '../../../../helper/snack_bar_helper.dart';
import '../../../../shared/constants/constant_colors.dart';
import '../../../../shared/constants/constant_sizes.dart';
import '../../../../shared/services/device_orientation.dart';
import '../../../../shared/services/theme_color_mode.dart';
import '../../../../shared/utils/data_utils.dart';
import '../../../../shared/utils/device_type.dart';
import '../../../../shared/utils/file_control.dart';
import '../../../../shared/utils/logged_in_data.dart';
import '../../../../widgets/discrepancy_and_work_order_widgets.dart';
import '../work_order_create_and_edit_logic.dart';

class WorkOrderEditPageViewCode extends StatelessWidget {
  final WorkOrderCreateAndEditLogic controller;

  const WorkOrderEditPageViewCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SizeConstants.contentSpacing - 5,
      children: [
        // Equipment_View
        equipmentEditViewReturn(),
        // Additional_Information_View
        additionalInformationEditViewReturn(),
        // Discovered_View
        discoveredEditViewReturn(),
        // Description_View
        descriptionEditViewReturn(),
        // Status_View
        statusEditViewReturn(),
        // Mechanic_Assigned_To_1_View
        mechanicAssignedToOneViewReturn(),
        // Mechanic_Assigned_To_2_View
        mechanicAssignedToTwoViewReturn(),
        // Mechanic_Assigned_To_3_View
        mechanicAssignedToThreeViewReturn(),
        // ATA_Code_View
        if (controller.workOrderEditApiData['discrepancyType'].toString() == '0') ataCodeViewReturn(),
        // Client's_Purchase_Order_Number_View
        clientsPurchaseOrderNumberViewReturn(),
        // Attachments_And_LogBooks
        attachmentsAndLogBooksViewReturn(),
        // Previous_Notes_View
        previousNotesViewReturn(),
        // New_Notes_View
        newNotesViewReturn(),
      ],
    );
  }

  equipmentEditViewReturn() {
    switch (controller.workOrderEditApiData['discrepancyType']) {
      case 0:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            children: [
              controller.headerTitleReturn(title: 'Equipment'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  children: [
                    Text(
                      controller.workOrderEditApiData['equipmentName'].toString().split(' ').first,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: controller.workOrderEditApiData['equipmentName'].toString().split('-').last,
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
              controller.headerTitleReturn(title: 'Equipment'),
              DiscrepancyAndWorkOrdersMaterialButton(
                iconColor: ColorConstants.white,
                buttonColor: ColorConstants.primary,
                buttonText: controller.workOrderEditApiData['equipmentName'].toString(),
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
              controller.headerTitleReturn(title: 'Equipment'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    Text(
                      controller.workOrderEditApiData['equipmentName'].toString().split('-').first,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    ),
                    Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText:
                          (controller.workOrderEditApiData['equipmentName'].toString().split('-')[1]) == ' (None) '
                              ? 'Not Found'
                              : controller.workOrderEditApiData['equipmentName'].toString().split('-')[1],
                    ),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: Icons.open_in_new,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: controller.workOrderEditApiData['equipmentName'].toString().split(')').last,
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
              controller.headerTitleReturn(title: 'Equipment'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.workOrderEditApiData['equipmentName'],
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

  additionalInformationEditViewReturn() {
    switch (controller.workOrderEditApiData['discrepancyType']) {
      case 0:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              controller.headerTitleReturn(title: 'Additional Information At The Time Of Issue'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.workOrderEditTextController.putIfAbsent('hobbs', () => TextEditingController()),
                      maxCharacterLength: 9,
                      dataType: 'number',
                      decimalNumber: true,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      fieldName: 'AC TT',
                      onChanged: (value) {
                        controller.editWorkOrderUpdateApiData['hobbsName'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.workOrderEditTextController.putIfAbsent('landings', () => TextEditingController()),
                      maxCharacterLength: 9,
                      dataType: 'number',
                      decimalNumber: true,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      fieldName: 'Landings',
                      onChanged: (value) {
                        controller.editWorkOrderUpdateApiData['landings'] = double.parse(value).round();
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.workOrderEditTextController.putIfAbsent('torqueEvents', () => TextEditingController()),
                      maxCharacterLength: 9,
                      dataType: 'number',
                      decimalNumber: true,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      fieldName: 'Torque Events',
                      onChanged: (value) {
                        controller.editWorkOrderUpdateApiData['torqueEvents'] = double.parse(value).round();
                      },
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
                      children: [
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.workOrderEditTextController.putIfAbsent('engine1TTName', () => TextEditingController()),
                          dataType: 'number',
                          decimalNumber: true,
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Engine #1 TT',
                          onChanged: (value) {
                            controller.editWorkOrderUpdateApiData['engine1TTName'] = value;
                          },
                        ),
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.workOrderEditTextController.putIfAbsent('engine1Starts', () => TextEditingController()),
                          dataType: 'number',
                          decimalNumber: true,
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Engine #1 Starts',
                          onChanged: (value) {
                            controller.editWorkOrderUpdateApiData['engine1Starts'] = value;
                          },
                        ),
                      ],
                    ),
                    if (controller.workOrderEditApiData['engine2Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine2TTName', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #2 TT',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine2TTName'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine2Starts', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #2 Starts',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine2Starts'] = value;
                            },
                          ),
                        ],
                      ),
                    if (controller.workOrderEditApiData['engine3Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine3TTName', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #3 TT',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine3TTName'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine3Starts', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #3 Starts',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine3Starts'] = value;
                            },
                          ),
                        ],
                      ),
                    if (controller.workOrderEditApiData['engine4Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine4TTName', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #4 TT',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine4TTName'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine4Starts', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #4 Starts',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine4Starts'] = value;
                            },
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [controller.headerTitleReturn(title: 'Additional Information At The Time Of Issue')]),
        );
      case 2 || 3 || 4 || 5:
        return Material(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              controller.headerTitleReturn(title: 'Additional Information At The Time Of Issue'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children:
                      controller.additionalInformationViewForLogicalDataOne()
                          ? [
                            RichText(
                              text: TextSpan(
                                text: 'Component Name: ',
                                style: TextStyle(
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: controller.workOrderEditApiData['outsideComponentName'],
                                    style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Part Number: ',
                                style: TextStyle(
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        DataUtils.isNullOrEmptyString(controller.workOrderEditApiData['outsideComponentPartNumber'])
                                            ? "(None)"
                                            : controller.workOrderEditApiData['outsideComponentPartNumber'],
                                    style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Serial Number: ',
                                style: TextStyle(
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        DataUtils.isNullOrEmptyString(controller.workOrderEditApiData['outsideComponentSerialNumber'])
                                            ? "(None)"
                                            : controller.workOrderEditApiData['outsideComponentSerialNumber'],
                                    style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                          : [
                            DiscrepancyAndWorkOrdersTextField(
                              key: controller.gKeyForEdit.putIfAbsent('outsideComponentName', () => GlobalKey()),
                              validationKey: controller.workOrderEditValidationKeys.putIfAbsent("outsideComponentName", () => GlobalKey<FormFieldState>()),
                              textFieldController: controller.workOrderEditTextController.putIfAbsent('outsideComponentName', () => TextEditingController()),
                              dataType: 'text',
                              req: true,
                              textFieldWidth:
                                  DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                              fieldName: 'Component Name',
                              hintText: 'Component Name',
                              onChanged: (value) {
                                controller.editWorkOrderUpdateApiData['outsideComponentName'] = value;
                              },
                            ),
                            DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.workOrderEditTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController()),
                              dataType: 'text',
                              textFieldWidth:
                                  DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                              fieldName: 'Part Number',
                              hintText: 'Part Number',
                              onChanged: (value) {
                                controller.editWorkOrderUpdateApiData['outsideComponentPartNumber'] = value;
                              },
                            ),
                            DiscrepancyAndWorkOrdersTextField(
                              textFieldController: controller.workOrderEditTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController()),
                              dataType: 'text',
                              textFieldWidth:
                                  DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 3) - 80
                                          : (Get.width / 2) - 80
                                      : Get.width,
                              fieldName: 'Serial Number',
                              hintText: 'Serial Number',
                              onChanged: (value) {
                                controller.editWorkOrderUpdateApiData['outsideComponentSerialNumber'] = value;
                              },
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
                  children:
                      controller.additionalInformationViewForLogicalDataTwo()
                          ? [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5.0,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Service Life Type# 1: ',
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            DataUtils.isNullOrEmptyString(controller.workOrderEditApiData['componentServiceLife1TypeName'])
                                                ? "(None)"
                                                : controller.workOrderEditApiData['componentServiceLife1TypeName'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Service Life Type# 2: ',
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            DataUtils.isNullOrEmptyString(controller.workOrderEditApiData['componentServiceLife2TypeName'])
                                                ? "(None)"
                                                : controller.workOrderEditApiData['componentServiceLife2TypeName'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
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
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: controller.workOrderEditApiData['componentServiceLife1SinceNewAmt'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Since New Amount: ',
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: controller.workOrderEditApiData['componentServiceLife2SinceNewAmt'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
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
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: controller.workOrderEditApiData['componentServiceLife1SinceOhAmt'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Since O/H Amount: ',
                                    style: TextStyle(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: controller.workOrderEditApiData['componentServiceLife2SinceOhAmt'],
                                        style: TextStyle(
                                          color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                          fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                          : [
                            Column(
                              children: [
                                DiscrepancyAndWorkOrdersDropDown(
                                  expands: true,
                                  textFieldWidth:
                                      DeviceType.isTablet
                                          ? DeviceOrientation.isLandscape
                                              ? (Get.width / 3) - 80
                                              : (Get.width / 2) - 80
                                          : Get.width,
                                  dropDownController: controller.workOrderEditTextController.putIfAbsent('componentServiceLife1Type', () => TextEditingController()),
                                  dropDownKey: 'name',
                                  dropDownData: controller.serviceLifeTypeOneDropdownData,
                                  hintText:
                                      controller.selectedServiceLifeTypeOneDropdown.isNotEmpty
                                          ? controller.selectedServiceLifeTypeOneDropdown['name']
                                          : controller.serviceLifeTypeOneDropdownData.isNotEmpty
                                          ? controller.serviceLifeTypeOneDropdownData[1]['name']
                                          : "-- Select Service Life --",
                                  fieldName: "Service Life Type #1",
                                  onChanged: (value) async {
                                    controller.selectedServiceLifeTypeOneDropdown.value = value;
                                    controller.editWorkOrderUpdateApiData['componentServiceLife1Type'] = controller.selectedServiceLifeTypeOneDropdown['id'];
                                    controller.editWorkOrderUpdateApiData['componentServiceLife1TypeName'] = controller.selectedServiceLifeTypeOneDropdown['name'];
                                  },
                                ),
                                DiscrepancyAndWorkOrdersDropDown(
                                  expands: true,
                                  textFieldWidth:
                                      DeviceType.isTablet
                                          ? DeviceOrientation.isLandscape
                                              ? (Get.width / 3) - 80
                                              : (Get.width / 2) - 80
                                          : Get.width,
                                  dropDownController: controller.workOrderEditTextController.putIfAbsent('componentServiceLife2Type', () => TextEditingController()),
                                  dropDownKey: 'name',
                                  dropDownData: controller.serviceLifeTypeTwoDropdownData,
                                  hintText:
                                      controller.selectedServiceLifeTypeTwoDropdown.isNotEmpty
                                          ? controller.selectedServiceLifeTypeTwoDropdown['name']
                                          : controller.serviceLifeTypeTwoDropdownData.isNotEmpty
                                          ? controller.serviceLifeTypeTwoDropdownData[1]['name']
                                          : "-- Select Service Life --",
                                  fieldName: "Service Life Type #2",
                                  onChanged: (value) async {
                                    controller.selectedServiceLifeTypeTwoDropdown.value = value;
                                    controller.editWorkOrderUpdateApiData['componentServiceLife2Type'] = controller.selectedServiceLifeTypeTwoDropdown['id'];
                                    controller.editWorkOrderUpdateApiData['componentServiceLife2TypeName'] = controller.selectedServiceLifeTypeTwoDropdown['name'];
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                DiscrepancyAndWorkOrdersTextField(
                                  textFieldController: controller.workOrderEditTextController.putIfAbsent(
                                    'componentServiceLife1SinceNewAmt',
                                    () => TextEditingController(),
                                  ),
                                  dataType: 'number',
                                  textFieldWidth:
                                      DeviceType.isTablet
                                          ? DeviceOrientation.isLandscape
                                              ? (Get.width / 3) - 80
                                              : (Get.width / 2) - 80
                                          : Get.width,
                                  fieldName: 'Since New Amount',
                                  onChanged: (value) {
                                    controller.editWorkOrderUpdateApiData['componentServiceLife1SinceNewAmt'] = value;
                                  },
                                ),
                                DiscrepancyAndWorkOrdersTextField(
                                  textFieldController: controller.workOrderEditTextController.putIfAbsent(
                                    'componentServiceLife2SinceNewAmt',
                                    () => TextEditingController(),
                                  ),
                                  dataType: 'number',
                                  textFieldWidth:
                                      DeviceType.isTablet
                                          ? DeviceOrientation.isLandscape
                                              ? (Get.width / 3) - 80
                                              : (Get.width / 2) - 80
                                          : Get.width,
                                  fieldName: 'Since New Amount',
                                  onChanged: (value) {
                                    controller.editWorkOrderUpdateApiData['componentServiceLife2SinceNewAmt'] = value;
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                DiscrepancyAndWorkOrdersTextField(
                                  textFieldController: controller.workOrderEditTextController.putIfAbsent(
                                    'componentServiceLife1SinceOhAmt',
                                    () => TextEditingController(),
                                  ),
                                  dataType: 'number',
                                  textFieldWidth:
                                      DeviceType.isTablet
                                          ? DeviceOrientation.isLandscape
                                              ? (Get.width / 3) - 80
                                              : (Get.width / 2) - 80
                                          : Get.width,
                                  fieldName: 'Since O/H Amount',
                                  onChanged: (value) {
                                    controller.editWorkOrderUpdateApiData['componentServiceLife1SinceOhAmt'] = value;
                                  },
                                ),
                                DiscrepancyAndWorkOrdersTextField(
                                  textFieldController: controller.workOrderEditTextController.putIfAbsent(
                                    'componentServiceLife2SinceOhAmt',
                                    () => TextEditingController(),
                                  ),
                                  dataType: 'number',
                                  textFieldWidth:
                                      DeviceType.isTablet
                                          ? DeviceOrientation.isLandscape
                                              ? (Get.width / 3) - 80
                                              : (Get.width / 2) - 80
                                          : Get.width,
                                  fieldName: 'Since O/H Amount',
                                  onChanged: (value) {
                                    controller.editWorkOrderUpdateApiData['componentServiceLife2SinceOhAmt'] = value;
                                  },
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

  discoveredEditViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.headerTitleReturn(title: 'Discovered'),
          controller.workOrderEditApiData['status'] == 'Completed'
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
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: controller.workOrderEditApiData['discoveredByName'],
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                            ),
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
                            text:
                                DataUtils.isNullOrEmptyString(controller.workOrderEditApiData['discoveredByLicenseNumber'])
                                    ? 'None'
                                    : controller.workOrderEditApiData['discoveredByLicenseNumber'],
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                            ),
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
                            text: DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.parse(controller.workOrderEditApiData['createdAt'])),
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    DiscrepancyAndWorkOrdersDropDown(
                      key: controller.gKeyForEdit.putIfAbsent('discoveredBy', () => GlobalKey()),
                      expands: true,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      dropDownController: controller.workOrderEditTextController.putIfAbsent('discoveredBy', () => TextEditingController()),
                      dropDownKey: 'name',
                      req: true,
                      dropDownData: controller.workOrderDiscoveredDropdownData,
                      hintText:
                          controller.selectedWorkOrderDiscoveredDropdown.isNotEmpty
                              ? controller.selectedWorkOrderDiscoveredDropdown['name']
                              : controller.workOrderDiscoveredDropdownData.isNotEmpty
                              ? controller.workOrderDiscoveredDropdownData[0]['name']
                              : "-- Discovered By --",
                      fieldName: "Discovered",
                      onChanged: (value) async {
                        controller.selectedWorkOrderDiscoveredDropdown.value = value;
                        controller.editWorkOrderUpdateApiData['discoveredBy'] = int.parse(controller.selectedWorkOrderDiscoveredDropdown['id'].toString());
                        controller.editWorkOrderUpdateApiData['discoveredByName'] = controller.selectedWorkOrderDiscoveredDropdown['name'];
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.workOrderEditTextController.putIfAbsent('discoveredByLicenseNumber', () => TextEditingController()),
                      dataType: 'text',
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      fieldName: 'License Number',
                      hintText: 'License #',
                      onChanged: (value) {
                        controller.editWorkOrderUpdateApiData['discoveredByLicenseNumber'] = value;
                      },
                    ),
                    DeviceType.isTablet
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width:
                                  DeviceType.isTablet
                                      ? DeviceOrientation.isLandscape
                                          ? (Get.width / 4) - 200
                                          : (Get.width / 3) - 100
                                      : Get.width / 3,
                              child: DiscrepancyAndWorkOrdersDateTime(
                                fieldName: "Date",
                                isDense: true,
                                disableKeyboard: controller.disableKeyboard,
                                dateTimeController: controller.workOrderEditTextController.putIfAbsent(
                                  'createdAt',
                                  () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTime.parse(controller.workOrderEditApiData['createdAt']))),
                                ),
                                dateType: "date",
                                onConfirm: (dateTime) {
                                  controller.editWorkOrderUpdateApiData["createdAt"] = dateTime;
                                  controller.workOrderEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                                },
                              ),
                            ),
                            DiscrepancyAndWorkOrdersDropDown(
                              dropDownController: controller.workOrderEditTextController.putIfAbsent('time', () => TextEditingController()),
                              dropDownKey: 'name',
                              dropDownData: controller.timeDropDownData,
                              hintText:
                                  controller.selectedTimeDropDown.isNotEmpty
                                      ? controller.selectedTimeDropDown['name']
                                      : controller.timeDropDownData.isNotEmpty
                                      ? controller.timeDropDownData[0]['name']
                                      : "00:00",
                              fieldName: "Time",
                              onChanged: (value) async {
                                controller.selectedTimeDropDown.value = value;
                                controller.editWorkOrderUpdateApiData["createdAt"] =
                                    '${controller.editWorkOrderUpdateApiData["createdAt"].toString().split(' ').first}T${controller.selectedTimeDropDown['name']}';
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
                                  controller.workOrderEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                                  String a = DateTimeHelper.now.toString().split(' ').first;
                                  String b = DateTimeHelper.now.toString().split(' ').last;
                                  String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                                  String f = '${a}T$c';
                                  controller.editWorkOrderUpdateApiData["createdAt"] = f;
                                  controller.selectedTimeDropDown.clear();
                                  controller.selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(f))});
                                  controller.workOrderEditTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
                                  controller.update();
                                },
                              ),
                            ),
                          ],
                        )
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
                                dateTimeController: controller.workOrderEditTextController.putIfAbsent(
                                  'createdAt',
                                  () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTime.parse(controller.workOrderEditApiData['createdAt']))),
                                ),
                                dateType: "date",
                                onConfirm: (dateTime) {
                                  controller.editWorkOrderUpdateApiData["createdAt"] = dateTime;
                                  controller.workOrderEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                                },
                              ),
                            ),
                            DiscrepancyAndWorkOrdersDropDown(
                              expands: false,
                              textFieldWidth: Get.width / 3,
                              dropDownController: controller.workOrderEditTextController.putIfAbsent('time', () => TextEditingController()),
                              dropDownKey: 'name',
                              dropDownData: controller.timeDropDownData,
                              hintText:
                                  controller.selectedTimeDropDown.isNotEmpty
                                      ? controller.selectedTimeDropDown['name']
                                      : controller.timeDropDownData.isNotEmpty
                                      ? controller.timeDropDownData[0]['name']
                                      : "00:00",
                              fieldName: "Time",
                              onChanged: (value) async {
                                controller.selectedTimeDropDown.value = value;
                                controller.editWorkOrderUpdateApiData["createdAt"] =
                                    '${controller.editWorkOrderUpdateApiData["createdAt"].toString().split(' ').first}T${controller.selectedTimeDropDown['name']}';
                              },
                            ),
                            DiscrepancyAndWorkOrdersMaterialButton(
                              icon: Icons.date_range_sharp,
                              iconColor: ColorConstants.button,
                              buttonColor: ColorConstants.black,
                              buttonText: "Date Now",
                              buttonTextColor: Colors.white,
                              onPressed: () {
                                controller.workOrderEditTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                                String a = DateTimeHelper.now.toString().split(' ').first;
                                String b = DateTimeHelper.now.toString().split(' ').last;
                                String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                                String f = '${a}T$c';
                                controller.editWorkOrderUpdateApiData["createdAt"] = f;
                                controller.selectedTimeDropDown.clear();
                                controller.selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(f))});
                                controller.workOrderEditTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
                                controller.update();
                              },
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

  descriptionEditViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.headerTitleReturn(title: 'Description'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiscrepancyAndWorkOrdersTextField(
              key: controller.gKeyForEdit.putIfAbsent('discrepancy', () => GlobalKey()),
              validationKey: controller.workOrderEditValidationKeys.putIfAbsent("discrepancy", () => GlobalKey<FormFieldState>()),
              textFieldController: controller.workOrderEditTextController.putIfAbsent('discrepancy', () => TextEditingController()),
              req: true,
              dataType: 'text',
              maxCharacterLength: 2000,
              maxLines: 5,
              showCounter: true,
              textFieldWidth: Get.width,
              fieldName: 'Description',
              onChanged: (value) {
                controller.editWorkOrderUpdateApiData['discrepancy'] = value;
              },
            ),
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
            controller.headerTitleReturn(title: 'Status'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                runSpacing: 5.0,
                children: [
                  (controller.workOrderEditApiData['status'] != 'Completed' && Get.parameters['action'] == 'workOrderEdit')
                      ? DiscrepancyAndWorkOrdersDropDown(
                        expands: true,
                        textFieldWidth:
                            DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                        dropDownController: controller.workOrderEditTextController.putIfAbsent('status', () => TextEditingController()),
                        statusEnable: true,
                        dropDownKey: 'name',
                        completeColor: controller.selectedStatusDropdown['name'] == 'Completed' ? true : false,
                        dropDownData: controller.statusDropdownData,
                        hintText:
                            controller.selectedStatusDropdown.isNotEmpty
                                ? controller.selectedStatusDropdown['name']
                                : controller.statusDropdownData.isNotEmpty
                                ? controller.statusDropdownData[1]['name']
                                : "--  --",
                        fieldName: "Status",
                        onChanged: (value) async {
                          controller.selectedStatusDropdown.value = value;
                          controller.editWorkOrderUpdateApiData['status'] = controller.selectedStatusDropdown['id'];
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
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${controller.workOrderEditApiData['status']} [Green]',
                                    style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.green : Colors.green,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Corrected By: ',
                                style: TextStyle(
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        DataUtils.isNullOrEmptyString(controller.workOrderEditApiData['correctedByName'])
                                            ? 'None'
                                            : '${controller.workOrderEditApiData['correctedByName']} At ${DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(controller.workOrderEditApiData['dateCorrected']))}',
                                    style: TextStyle(
                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                      fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                    ),
                                  ),
                                ],
                              ),
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
                                textFieldController: controller.workOrderEditTextController.putIfAbsent('acttCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                    DeviceType.isTablet
                                        ? DeviceOrientation.isLandscape
                                            ? (Get.width / 3) - 80
                                            : (Get.width / 2) - 80
                                        : Get.width,
                                fieldName: 'AC TT @ Completed',
                                onChanged: (value) {
                                  controller.editWorkOrderUpdateApiData['acttCompletedAt'] = value;
                                },
                              ),
                              Padding(
                                padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : const EdgeInsets.only(top: 0.0),
                                child: DiscrepancyAndWorkOrdersTextButton(
                                  fieldName: '[Load Current Value]',
                                  onPressed: () async {
                                    if (controller.workOrderEditApiData['unitId'] > 0) {
                                      LoaderHelper.loaderWithGif();
                                      await controller.loadCurrentValueForCompleteDiscrepancy(unitId: controller.workOrderEditApiData['unitId'].toString());
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
                          textFieldController: controller.workOrderEditTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController()),
                          dataType: 'number',
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Engine #1 TT @ Completed',
                          onChanged: (value) {
                            controller.editWorkOrderUpdateApiData['engine1TTCompletedAt'] = value;
                          },
                        ),
                        if (controller.workOrderEditApiData['engine2Enabled'])
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #2 TT @ Completed',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine2TTCompletedAt'] = value;
                            },
                          ),
                        if (controller.workOrderEditApiData['engine3Enabled'])
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #3 TT @ Completed',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine3TTCompletedAt'] = value;
                            },
                          ),
                        if (controller.workOrderEditApiData['engine4Enabled'])
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController()),
                            dataType: 'number',
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #4 TT @ Completed',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['engine4TTCompletedAt'] = value;
                            },
                          ),
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
          controller.headerTitleReturn(title: 'Mechanic Assigned To #1'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.workOrderEditApiData['status'] != 'Completed'
                    ? SizedBox(
                      width: Get.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 10.0,
                        runSpacing: 5.0,
                        children: [
                          DiscrepancyAndWorkOrdersDropDown(
                            expands: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            dropDownController: controller.workOrderEditTextController.putIfAbsent('assignedTo', () => TextEditingController()),
                            dropDownKey: 'name',
                            dropDownData: controller.mechanicAssignedToOneDropdownData,
                            hintText:
                                controller.selectedMechanicAssignedToOneDropdown.isNotEmpty
                                    ? controller.selectedMechanicAssignedToOneDropdown['name']
                                    : controller.mechanicAssignedToOneDropdownData.isNotEmpty
                                    ? controller.mechanicAssignedToOneDropdownData[0]['name']
                                    : "-- Not Assigned --",
                            fieldName: "Mechanic Assigned To #1",
                            onChanged: (value) async {
                              controller.selectedMechanicAssignedToOneDropdown.value = value;
                              controller.editWorkOrderUpdateApiData['assignedTo'] = int.parse(controller.selectedMechanicAssignedToOneDropdown['id'].toString());
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderEditTextController.putIfAbsent('correctedByLicenseNumber', () => TextEditingController()),
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'License Number',
                            hintText: 'License#',
                            onChanged: (value) {
                              controller.editWorkOrderUpdateApiData['correctedByLicenseNumber'] = value;
                            },
                          ),
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
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      DataUtils.isNullOrEmptyString(controller.editWorkOrderUpdateApiData['mechanicAssignedTo1'])
                                          ? 'Not Specified'
                                          : controller.editWorkOrderUpdateApiData['mechanicAssignedTo1'],
                                  style: TextStyle(
                                    color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                    fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'License Number: ',
                              style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.workOrderEditApiData['correctedByLicenseNumber'],
                                  style: TextStyle(
                                    color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                    fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                  ),
                                ),
                              ],
                            ),
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
          controller.headerTitleReturn(title: 'Mechanic Assigned To #2'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.workOrderEditApiData['status'] != 'Completed'
                    ? DiscrepancyAndWorkOrdersDropDown(
                      expands: true,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      dropDownController: controller.workOrderEditTextController.putIfAbsent('assignedTo2', () => TextEditingController()),
                      dropDownKey: 'name',
                      dropDownData: controller.mechanicAssignedToTwoDropdownData,
                      hintText:
                          controller.selectedMechanicAssignedToTwoDropdown.isNotEmpty
                              ? controller.selectedMechanicAssignedToTwoDropdown['name']
                              : controller.mechanicAssignedToTwoDropdownData.isNotEmpty
                              ? controller.mechanicAssignedToTwoDropdownData[0]['name']
                              : "-- Not Assigned --",
                      fieldName: "Mechanic Assigned To #2",
                      onChanged: (value) async {
                        controller.selectedMechanicAssignedToTwoDropdown.value = value;
                        controller.editWorkOrderUpdateApiData['assignedTo2'] = int.parse(controller.selectedMechanicAssignedToTwoDropdown['id'].toString());
                      },
                    )
                    : RichText(
                      text: TextSpan(
                        text: 'Mechanic Assigned To #2: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.editWorkOrderUpdateApiData['assignedTo2Name'])
                                    ? 'Not Specified'
                                    : controller.editWorkOrderUpdateApiData['assignedTo2Name'],
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                            ),
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

  mechanicAssignedToThreeViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.headerTitleReturn(title: 'Mechanic Assigned To #3'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                controller.workOrderEditApiData['status'] != 'Completed'
                    ? DiscrepancyAndWorkOrdersDropDown(
                      expands: true,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      dropDownController: controller.workOrderEditTextController.putIfAbsent('assignedTo3', () => TextEditingController()),
                      dropDownKey: 'name',
                      dropDownData: controller.mechanicAssignedToThreeDropdownData,
                      hintText:
                          controller.selectedMechanicAssignedToThreeDropdown.isNotEmpty
                              ? controller.selectedMechanicAssignedToThreeDropdown['name']
                              : controller.mechanicAssignedToThreeDropdownData.isNotEmpty
                              ? controller.mechanicAssignedToThreeDropdownData[1]['name']
                              : "-- Not Assigned --",
                      fieldName: "Mechanic Assigned To #3",
                      onChanged: (value) async {
                        controller.selectedMechanicAssignedToThreeDropdown.value = value;
                        controller.editWorkOrderUpdateApiData['assignedTo3'] = int.parse(controller.selectedMechanicAssignedToThreeDropdown['id'].toString());
                      },
                    )
                    : RichText(
                      text: TextSpan(
                        text: 'Mechanic Assigned To #3: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                DataUtils.isNullOrEmptyString(controller.editWorkOrderUpdateApiData['assignedTo3Name'])
                                    ? 'Not Specified'
                                    : controller.editWorkOrderUpdateApiData['assignedTo3Name'],
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                            ),
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
          controller.headerTitleReturn(title: 'ATA Code'),
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
                      textFieldController: controller.workOrderEditTextController.putIfAbsent('ataCode', () => TextEditingController()),
                      validationKey: controller.workOrderEditValidationKeys.putIfAbsent("ataCode", () => GlobalKey<FormFieldState>()),
                      dataType: 'text',
                      textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                      req: (controller.selectedStatusDropdown['id'] ?? "") == 'Completed' ? true : false,
                      fieldName: 'ATA Code',
                      onChanged: (value) {
                        controller.editWorkOrderUpdateApiData['aTACode'] = value;
                      },
                    ),
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
                            Future.delayed(Duration(seconds: 1));
                            await EasyLoading.dismiss();
                            SnackBarHelper.openSnackBar(isError: true, message: "No, Data Found for ATA Code");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderEditTextController.putIfAbsent('atamcnCode', () => TextEditingController()),
                  dataType: 'text',
                  textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                  fieldName: 'MNC Code',
                  onChanged: (value) {
                    controller.editWorkOrderUpdateApiData['mCNCode'] = value;
                  },
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
          controller.headerTitleReturn(title: 'Client\'s Purchase Order Number'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderEditTextController.putIfAbsent('purchaseOrder', () => TextEditingController()),
                  dataType: 'text',
                  maxCharacterLength: 20,
                  showCounter: false,
                  textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                              ? (Get.width / 3) - 80
                              : (Get.width / 2) - 80
                          : Get.width,
                  fieldName: 'Client\'s Purchase Order Number',
                  hintText: 'Client\'s Purchase Order Number....',
                  onChanged: (value) {
                    controller.editWorkOrderUpdateApiData['PurchaseOrder'] = value;
                  },
                ),
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
          controller.headerTitleReturn(title: 'Attachments & Log Books'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10.0,
              children: [
                if (controller.workOrderEditApiData['attachments'].isEmpty)
                  Text(
                    'Complete All Editing Before Adding New Uploads To This Discrepancy',
                    style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 2, fontWeight: FontWeight.w600),
                  ),
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border: TableBorder.all(
                        color: Colors.black,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                      ),
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
                        for (int i = 0; i < controller.workOrderEditApiData['attachments'].length; i++)
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
                          border: TableBorder.all(
                            color: Colors.black,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                          ),
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
                            for (int i = 0; i < controller.workOrderEditApiData['attachments'].length; i++)
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
                                                  fileId: controller.workOrderEditApiData['attachments'][i]['attachmentId'].toString(),
                                                  fileName: controller.workOrderEditApiData['attachments'][i]['fileName'].toString(),
                                                ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  documentsViewIconReturns(
                                                    types: FileControl.fileType(fileName: controller.workOrderEditApiData['attachments'][i]['fileName']),
                                                  ),
                                                  size: 25.0,
                                                  color: ColorConstants.primary.withValues(alpha: 0.7),
                                                ),
                                                Text(
                                                  controller.workOrderEditApiData['attachments'][i]['fileName'],
                                                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                                ),
                                              ],
                                            ),
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
                                        DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.parse(controller.workOrderEditApiData['attachments'][i]['createdAt'])),
                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300.0,
                                    height: 35.0,
                                    child: Center(
                                      child: Text(
                                        controller.workOrderEditApiData['attachments'][i]['fullName'],
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
                if (controller.workOrderEditApiData['attachments'].isEmpty)
                  Text('No File Attachments', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
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
          controller.headerTitleReturn(title: 'Previous Notes'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border: TableBorder.all(
                        color: Colors.black,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                      ),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
                          children: [
                            SizedBox(
                              width: DeviceType.isTablet ? 250.0 : Get.width / 2.8,
                              height: 40.0,
                              child: Center(
                                child: Text(
                                  'Date',
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
                        for (int i = 0; i < controller.workOrderEditApiData['notes'].length; i++)
                          TableRow(
                            children: [
                              SizedBox(
                                width: DeviceType.isTablet ? 250.0 : Get.width / 2.8,
                                height: 70.0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      controller.workOrderEditApiData['notes'][i]['notesCreatedAt'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                    ),
                                  ),
                                ),
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
                          border: TableBorder.all(
                            color: Colors.black,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                          ),
                          // border: TableBorder(top: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
                              children: [
                                SizedBox(
                                  width: DeviceType.isTablet ? 300.0 : 200.0,
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
                                  width: 300.0,
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
                            for (int i = 0; i < controller.workOrderEditApiData['notes'].length; i++)
                              TableRow(
                                children: [
                                  SizedBox(
                                    width: DeviceType.isTablet ? 300.0 : 200.0,
                                    height: 70.0,
                                    child: Center(
                                      child: Text(
                                        controller.workOrderEditApiData['notes'][i]['fullName'],
                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300.0,
                                    height: 70.0,
                                    child: Center(
                                      child: Text(
                                        controller.workOrderEditApiData['notes'][i]['notes'],
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
                if (controller.workOrderEditApiData['notes'].isEmpty)
                  Center(
                    child: Text(
                      'No Note',
                      style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize, fontWeight: FontWeight.w600),
                    ),
                  ),
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
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          controller.headerTitleReturn(title: 'New Notes'),
          if (controller.newNotesList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Table(
                        defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                        border: TableBorder.all(
                          color: Colors.black,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                        ),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
                            children: [
                              SizedBox(
                                width: 100.0,
                                height: 40.0,
                                child: Center(
                                  child: Text(
                                    'Action',
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
                          for (int i = 0; i < controller.newNotesList.length; i++)
                            TableRow(
                              children: [
                                SizedBox(
                                  width: 100.0,
                                  height: 50.0,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          controller.newNotesList.removeAt(i);
                                          controller.update();
                                        },
                                        child: Icon(Icons.cancel_outlined, color: ColorConstants.red, size: 25.0),
                                      ),
                                    ),
                                  ),
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
                            border: TableBorder.all(
                              color: Colors.black,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                            ),
                            children: [
                              TableRow(
                                decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
                                children: [
                                  SizedBox(
                                    width: DeviceType.isTablet ? 300.0 : 200.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        'Date',
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
                                    width: Get.width / 2.2,
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
                              for (int i = 0; i < controller.newNotesList.length; i++)
                                TableRow(
                                  children: [
                                    SizedBox(
                                      width: DeviceType.isTablet ? 300.0 : 200.0,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          controller.newNotesList[i]['notesCreatedAt']!,
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: DeviceType.isTablet ? 300.0 : 200.0,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          controller.newNotesList[i]['fullName']!,
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300.0,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          controller.newNotesList[i]['notes']!,
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
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
            child: DiscrepancyAndWorkOrdersTextField(
              textFieldController: controller.workOrderEditTextController.putIfAbsent('newNotes', () => TextEditingController()),
              dataType: 'text',
              maxCharacterLength: 1000,
              maxLines: 4,
              showCounter: true,
              textFieldWidth: Get.width,
              fieldName: 'Add New Note',
              hintText: 'Add Note here....',
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DiscrepancyAndWorkOrdersMaterialButton(
                  icon: Icons.add,
                  iconColor: ColorConstants.white,
                  buttonText: 'New Note',
                  buttonColor: ColorConstants.button,
                  buttonTextColor: ColorConstants.white,
                  onPressed: () {
                    controller.newNotesList.add({
                      'fullName': UserSessionInfo.userFullName,
                      'notesCreatedAt': DateTimeHelper.dateTimeFormat12H.format(DateTimeHelper.now).toString(),
                      'notes': controller.workOrderEditTextController['newNotes']!.text,
                    });
                    controller.workOrderEditTextController['newNotes']!.text = '';
                    controller.update();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
