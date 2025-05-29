import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../helper/loader_helper.dart';
import '../../../../widgets/discrepancy_and_work_order_widgets.dart';
import '../work_order_create_and_edit_logic.dart';

class WorkOrderCreatePageViewCode extends StatelessWidget {
  final WorkOrderCreateAndEditLogic controller;

  const WorkOrderCreatePageViewCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SizeConstants.contentSpacing - 5,
      children: [
        // Equipment_View
        equipmentCreateViewReturn(),
        // Additional_Information_View
        controller.createWorkOrderShowHideField['additionalInformationField'] == true ? additionalInformationCreateViewReturn() : const SizedBox(),
        // Discovered_View
        discoveredCreatedViewReturn(),
        // // Description_View
        descriptionCreateViewReturn(),
        // // Status_View
        statusCreateViewReturn(),
        // // Mechanic_Assigned_To_1_View
        mechanicAssignedToOneCreateViewReturn(),
        // // Mechanic_Assigned_To_2_View
        mechanicAssignedToTwoCreateViewReturn(),
        // // Mechanic_Assigned_To_2_View
        mechanicAssignedToThreeCreateViewReturn(),
        // // Mel_View
        melCreateViewReturn(),
        // // ATA_Code_VIEW
        controller.createWorkOrderShowHideField['ataCodeView'] == true ? ataCodeCreateViewReturn() : const SizedBox(), // Discrepancy_Service_Status_View

        // // Client's_Purchase_Order_Number_View
        clientsPurchaseOrderNumberCreateViewReturn(),
        // , // Attachments_And_LogBooks_View
        attachmentsAndLogBooksCreateViewReturn(),
        // // Notes_View
        newNotesViewReturn(),
      ],
    );
  }

  equipmentCreateViewReturn() {
    dropdownReturn() {
      switch (int.parse(controller.selectedWorkOrderTypeDropdown['id'].toString())) {
        case 0:
          return DiscrepancyAndWorkOrdersDropDown(
            key: controller.gKeyForCreate.putIfAbsent('unitIdAircraft', () => GlobalKey()),
            expands: true,
            textFieldWidth:
            DeviceType.isTablet
                ? DeviceOrientation.isLandscape
                ? (Get.width / 3) - 80
                : (Get.width / 2) - 80
                : Get.width,
            dropDownController: controller.workOrderCreateTextController.putIfAbsent('unitIdAircraft', () => TextEditingController()),
            dropDownKey: 'name',
            req: true,
            validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("unitIdAircraft", () => GlobalKey<FormFieldState>()),
            dropDownData: controller.aircraftDropdownData,
            hintText:
            controller.selectedAircraftDropdown.isNotEmpty
                ? controller.selectedAircraftDropdown['name']
                : controller.aircraftDropdownData.isNotEmpty
                ? controller.aircraftDropdownData[0]['name']
                : "-- Select Aircraft --",
            fieldName: "Aircraft",
            onChanged: (value) async {
              controller.selectedAircraftDropdown.value = value;
              if (controller.selectedAircraftDropdown['id'].toString() == '0') {
                controller.createWorkOrderShowHideField['additionalInformationField'] = false;
                controller.createWorkOrderShowHideField['ataCodeView'] = false;
                controller.update();
              } else {
                LoaderHelper.loaderWithGifAndText('Loading...');
                controller.createWorkOrderUpdateApiData[''] = controller.selectedAircraftDropdown['id'];
                await controller.getAircraftInfoData(unitId: controller.selectedAircraftDropdown['id']);
              }
            },
          );
        case 1:
          return DiscrepancyAndWorkOrdersDropDown(
            key: controller.gKeyForCreate.putIfAbsent('unitIdAccessoryTools', () => GlobalKey()),
            expands: true,
            textFieldWidth:
            DeviceType.isTablet
                ? DeviceOrientation.isLandscape
                ? (Get.width / 3) - 80
                : (Get.width / 2) - 80
                : Get.width,
            dropDownController: controller.workOrderCreateTextController.putIfAbsent('unitIdAccessoryTools', () => TextEditingController()),
            dropDownKey: 'name',
            req: true,
            validationKey: controller.workOrderCreateValidationKeys.putIfAbsent('unitIdAccessoryTools', () => GlobalKey<FormFieldState>()),
            dropDownData: controller.unitIdAccessoryToolsDropdownData,
            hintText:
            controller.selectedUnitIdAccessoryToolsDropdown.isNotEmpty
                ? controller.selectedUnitIdAccessoryToolsDropdown['name']
                : controller.unitIdAccessoryToolsDropdownData.isNotEmpty
                ? controller.unitIdAccessoryToolsDropdownData[0]['name']
                : "-- Select Accessory/Tools --",
            fieldName: "Accessory/Tools",
            onChanged: (value) async {
              controller.selectedUnitIdAccessoryToolsDropdown.value = value;
              controller.createWorkOrderUpdateApiData['unitId'] = int.parse(controller.selectedUnitIdAccessoryToolsDropdown['id'].toString());
              controller.update();
            },
          );
      case 2:
        return DiscrepancyAndWorkOrdersDropDown(
          key: controller.gKeyForCreate.putIfAbsent('unitIdComponentOnAircraft', () => GlobalKey()),
          expands: true,
          textFieldWidth:
          DeviceType.isTablet
              ? DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
              : Get.width,
          dropDownController: controller.workOrderCreateTextController.putIfAbsent('unitIdComponentOnAircraft', () => TextEditingController()),
          dropDownKey: 'name',
          req: true,
          validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("unitIdComponentOnAircraft", () => GlobalKey<FormFieldState>()),
          dropDownData: controller.unitIdComponentOnAircraftDropdownData,
          hintText:
          controller.selectedUnitIdComponentOnAircraftDropdown.isNotEmpty
              ? controller.selectedUnitIdComponentOnAircraftDropdown['name']
              : controller.unitIdComponentOnAircraftDropdownData.isNotEmpty
              ? controller.unitIdComponentOnAircraftDropdownData[0]['name']
              : "-- Select Aircraft --",
          fieldName: "Component On Aircraft",
          onChanged: (value) async {
            controller.selectedUnitIdComponentOnAircraftDropdown.value = value;
            controller.createWorkOrderUpdateApiData['unitId'] = int.parse(controller.selectedUnitIdComponentOnAircraftDropdown['id'].toString());
            LoaderHelper.loaderWithGif();
            await controller.apiCallForComponentTypeSpecificData();
            controller.update();
            await EasyLoading.dismiss();
          },
        );
      case 3:
        return DiscrepancyAndWorkOrdersDropDown(
          key: controller.gKeyForCreate.putIfAbsent('unitIdComponentRemoveOnAircraft', () => GlobalKey()),
          expands: true,
          textFieldWidth:
          DeviceType.isTablet
              ? DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
              : Get.width,
          dropDownController: controller.workOrderCreateTextController.putIfAbsent('unitIdComponentRemoveOnAircraft', () => TextEditingController()),
          dropDownKey: 'name',
          req: true,
          validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("unitIdComponentRemoveOnAircraft", () => GlobalKey<FormFieldState>()),
          dropDownData: controller.unitIdComponentRemoveOnAircraftDropdownData,
          hintText:
          controller.selectedUnitIdComponentRemoveOnAircraftDropdown.isNotEmpty
              ? controller.selectedUnitIdComponentRemoveOnAircraftDropdown['name']
              : controller.unitIdComponentRemoveOnAircraftDropdownData.isNotEmpty
              ? controller.unitIdComponentRemoveOnAircraftDropdownData[0]['name']
              : "-- Select Component Remove --",
          fieldName: "Components Remove",
          onChanged: (value) async {
            controller.selectedUnitIdComponentRemoveOnAircraftDropdown.value = value;
            controller.createWorkOrderUpdateApiData['componentTypeIdSpecific'] = int.parse(controller.selectedUnitIdComponentRemoveOnAircraftDropdown['id'].toString());
            LoaderHelper.loaderWithGifAndText('Loading...');
            await controller.apiCallForAircraftComponentNameDataItemChangeTwo(
              discrepancyType: controller.selectedWorkOrderTypeDropdown['id'].toString(),
              unitId: '',
              itemChange: '2',
              componentTypeIdSpecific: controller.selectedUnitIdComponentRemoveOnAircraftDropdown['id'].toString(),
            );
          },
        );
        case 4 || 5:
          return const SizedBox();
        default:
          return const SizedBox();
      }
    }

    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.headerTitleReturn(title: 'Equipment'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                DiscrepancyAndWorkOrdersDropDown(
                  key: controller.gKeyForCreate.putIfAbsent('workOrderType', () => GlobalKey()),
                  expands: true,
                  textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                              ? (Get.width / 3) - 80
                              : (Get.width / 2) - 80
                          : Get.width,
                  dropDownController: controller.workOrderCreateTextController.putIfAbsent('workOrderType', () => TextEditingController()),
                  dropDownKey: 'name',
                  req: false,
                  validationKey: controller.workOrderCreateValidationKeys.putIfAbsent('workOrderType', () => GlobalKey<FormFieldState>()),
                  dropDownData: controller.workOrderTypeDropdownData,
                  hintText:
                      controller.selectedWorkOrderTypeDropdown.isNotEmpty
                          ? controller.selectedWorkOrderTypeDropdown['name']
                          : controller.workOrderTypeDropdownData.isNotEmpty
                          ? controller.workOrderTypeDropdownData[1]['name']
                          : "-- Select Type --",
                  fieldName: "Discrepancy Type",
                  onChanged: (value) async {
                    controller.createWorkOrderShowHideField['additionalInformationField'] = false;
                    controller.selectedWorkOrderTypeDropdown.value = value;
                    controller.update();
                  },
                ),

                dropdownReturn(),

                if (int.parse(controller.selectedWorkOrderTypeDropdown['id'].toString()) == 2 &&
                    controller.selectedUnitIdComponentOnAircraftDropdown['id'].toString() != '0' && controller.componentTypeIdSpecificDropdownData.isNotEmpty)
                  DiscrepancyAndWorkOrdersDropDown(
                    expands: true,
                    textFieldWidth:
                    DeviceType.isTablet
                        ? DeviceOrientation.isLandscape
                         ? (Get.width / 3) - 80
                         : (Get.width / 2) - 80
                        : Get.width,
                    dropDownController: controller.workOrderCreateTextController.putIfAbsent('componentTypeIdSpecific', () => TextEditingController()),
                    dropDownKey: 'name',
                    req: true,
                    validationKey: controller.workOrderCreateValidationKeys.putIfAbsent('componentTypeIdSpecific', () => GlobalKey<FormFieldState>()),
                    dropDownData: controller.componentTypeIdSpecificDropdownData,
                    hintText:
                    controller.selectedComponentTypeIdSpecificDropdown.isNotEmpty
                        ? controller.selectedComponentTypeIdSpecificDropdown['name']
                        : controller.componentTypeIdSpecificDropdownData.isNotEmpty
                        ? controller.componentTypeIdSpecificDropdownData[0]['name']
                        : "-- Select Component Name --",
                    fieldName: "Component Name",
                    onChanged: (value) async {
                      controller.selectedComponentTypeIdSpecificDropdown.value = value;
                      controller.createWorkOrderUpdateApiData['ComponentTypeIdSpecific'] = int.parse(controller.selectedComponentTypeIdSpecificDropdown['id'].toString());
                      if (int.parse(controller.selectedComponentTypeIdSpecificDropdown['id'].toString()) > 0) {
                        LoaderHelper.loaderWithGifAndText('Loading...');
                        await controller.apiCallForAircraftComponentNameDataItemChangeTwo(
                          discrepancyType: controller.selectedWorkOrderTypeDropdown['id'].toString(),
                          unitId: controller.selectedUnitIdComponentOnAircraftDropdown['id'].toString(),
                          itemChange: '2',
                          componentTypeIdSpecific: controller.selectedComponentTypeIdSpecificDropdown['id'].toString(),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  additionalInformationCreateViewReturn() {
    switch (int.parse(controller.selectedWorkOrderTypeDropdown['id'].toString())) {
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
                      textFieldController: controller.workOrderCreateTextController.putIfAbsent('hobbs', () => TextEditingController()),
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
                        controller.createWorkOrderUpdateApiData['hobbs'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.workOrderCreateTextController.putIfAbsent('landings', () => TextEditingController()),
                      dataType: 'number',
                      decimalNumber: false,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      fieldName: 'Landings',
                      onChanged: (value) {
                        controller.createWorkOrderUpdateApiData['landings'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.workOrderCreateTextController.putIfAbsent('torqueEvents', () => TextEditingController()),
                      dataType: 'number',
                      decimalNumber: false,
                      textFieldWidth:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                      fieldName: 'Torque Events',
                      onChanged: (value) {
                        controller.createWorkOrderUpdateApiData['torqueEvents'] = value;
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
                          textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine1TT', () => TextEditingController()),
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
                            controller.createWorkOrderUpdateApiData['engine1TT'] = value;
                          },
                        ),
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine1Starts', () => TextEditingController()),
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
                            controller.createWorkOrderUpdateApiData['engine1Starts'] = double.parse(value);
                          },
                        ),
                      ],
                    ),
                    if (controller.aircraftInfoData['engine2Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine2TT', () => TextEditingController()),
                            dataType: 'number',
                            decimalNumber: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #2 TT',
                            onChanged: (value) {
                              controller.createWorkOrderUpdateApiData['engine2TT'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine2Starts', () => TextEditingController()),
                            dataType: 'number',
                            decimalNumber: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #2 Starts',
                            onChanged: (value) {
                              controller.createWorkOrderUpdateApiData['engine2Starts'] = double.parse(value);
                            },
                          ),
                        ],
                      ),
                    if (controller.aircraftInfoData['engine3Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine3TT', () => TextEditingController()),
                            dataType: 'number',
                            decimalNumber: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #3 TT',
                            onChanged: (value) {
                              controller.createWorkOrderUpdateApiData['engine3TT'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine3Starts', () => TextEditingController()),
                            dataType: 'number',
                            decimalNumber: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #3 Starts',
                            onChanged: (value) {
                              controller.createWorkOrderUpdateApiData['engine3Starts'] = double.parse(value);
                            },
                          ),
                        ],
                      ),
                    if (controller.aircraftInfoData['engine4Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine4TT', () => TextEditingController()),
                            dataType: 'number',
                            decimalNumber: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #4 TT',
                            onChanged: (value) {
                              controller.createWorkOrderUpdateApiData['engine4TT'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine4Starts', () => TextEditingController()),
                            dataType: 'number',
                            decimalNumber: true,
                            textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? (Get.width / 3) - 80
                                        : (Get.width / 2) - 80
                                    : Get.width,
                            fieldName: 'Engine #4 Starts',
                            onChanged: (value) {
                              controller.createWorkOrderUpdateApiData['engine4Starts'] = double.parse(value);
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
                children: [
                  DiscrepancyAndWorkOrdersTextField(
                    key: controller.gKeyForCreate.putIfAbsent('outsideComponentName', () => GlobalKey()),
                    validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("outsideComponentName", () => GlobalKey<FormFieldState>()),
                    textFieldController: controller.workOrderCreateTextController.putIfAbsent('outsideComponentName', () => TextEditingController()),
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
                      controller.createWorkOrderUpdateApiData['outsideComponentName'] = value;
                    },
                  ),
                  DiscrepancyAndWorkOrdersTextField(
                    textFieldController: controller.workOrderCreateTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController()),
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
                      controller.createWorkOrderUpdateApiData['outsideComponentPartNumber'] = value;
                    },
                  ),
                  DiscrepancyAndWorkOrdersTextField(
                    textFieldController: controller.workOrderCreateTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController()),
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
                      controller.createWorkOrderUpdateApiData['outsideComponentSerialNumber'] = value;
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
                      DiscrepancyAndWorkOrdersDropDown(
                        expands: true,
                        textFieldWidth:
                            DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                        dropDownController: controller.workOrderCreateTextController.putIfAbsent('componentServiceLife1Type', () => TextEditingController()),
                        dropDownKey: 'name',
                        dropDownData: controller.serviceLifeTypeOneDropdownData,
                        hintText:
                            controller.selectedServiceLifeTypeOneDropdown.isNotEmpty
                                ? controller.selectedServiceLifeTypeOneDropdown['name']
                                : controller.serviceLifeTypeOneDropdownData.isNotEmpty
                                ? controller.serviceLifeTypeOneDropdownData[0]['name']
                                : "-- Select Service Life --",
                        fieldName: "Service Life Type #1",
                        onChanged: (value) async {
                          controller.selectedServiceLifeTypeOneDropdown.value = value;
                          controller.createWorkOrderUpdateApiData['componentServiceLife1Type'] = int.parse(
                            controller.selectedServiceLifeTypeOneDropdown['id'].toString(),
                          );
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
                        dropDownController: controller.workOrderCreateTextController.putIfAbsent('componentServiceLife2Type', () => TextEditingController()),
                        dropDownKey: 'name',
                        dropDownData: controller.serviceLifeTypeTwoDropdownData,
                        hintText:
                            controller.selectedServiceLifeTypeTwoDropdown.isNotEmpty
                                ? controller.selectedServiceLifeTypeTwoDropdown['name']
                                : controller.serviceLifeTypeTwoDropdownData.isNotEmpty
                                ? controller.serviceLifeTypeTwoDropdownData[0]['name']
                                : "-- Select Service Life --",
                        fieldName: "Service Life Type #2",
                        onChanged: (value) async {
                          controller.selectedServiceLifeTypeTwoDropdown.value = value;
                          controller.createWorkOrderUpdateApiData['componentServiceLife2Type'] = int.parse(
                            controller.selectedServiceLifeTypeTwoDropdown['id'].toString(),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.workOrderCreateTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController()),
                        dataType: 'number',
                        decimalNumber: true,
                        textFieldWidth:
                            DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                        fieldName: 'Since New Amount',
                        hintText: 'Since New Amount',
                        onChanged: (value) {
                          controller.createWorkOrderUpdateApiData['componentServiceLife1SinceNewAmt'] = value;
                        },
                      ),
                      DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.workOrderCreateTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController()),
                        dataType: 'number',
                        decimalNumber: true,
                        textFieldWidth:
                            DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                        fieldName: 'Since New Amount',
                        hintText: 'Since New Amount',
                        onChanged: (value) {
                          controller.createWorkOrderUpdateApiData['componentServiceLife2SinceNewAmt'] = value;
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.workOrderCreateTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController()),
                        dataType: 'number',
                        decimalNumber: true,
                        textFieldWidth:
                            DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                        fieldName: 'Since O/H Amount',
                        hintText: 'Since O/H Amount',
                        onChanged: (value) {
                          controller.createWorkOrderUpdateApiData['componentServiceLife1SinceOhAmt'] = value;
                        },
                      ),
                      DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.workOrderCreateTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController()),
                        dataType: 'number',
                        decimalNumber: true,
                        textFieldWidth:
                            DeviceType.isTablet
                                ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                : Get.width,
                        fieldName: 'Since O/H Amount',
                        hintText: 'Since O/H Amount',
                        onChanged: (value) {
                          controller.createWorkOrderUpdateApiData['componentServiceLife2SinceOhAmt'] = value;
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

  discoveredCreatedViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.headerTitleReturn(title: 'Discovered'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    DiscrepancyAndWorkOrdersDropDown(
                      key: controller.gKeyForCreate.putIfAbsent('discoveredBy', () => GlobalKey()),
                      expands: true,
                      textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                          : Get.width,
                      dropDownController: controller.workOrderCreateTextController.putIfAbsent('discoveredBy', () => TextEditingController()),
                      dropDownKey: 'name',
                      req: true,
                      validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("discoveredBy", () => GlobalKey<FormFieldState>()),
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
                        controller.createWorkOrderUpdateApiData['discoveredBy'] = int.parse(controller.selectedWorkOrderDiscoveredDropdown['id'].toString());
                        controller.createWorkOrderUpdateApiData['discoveredByName'] = controller.selectedWorkOrderDiscoveredDropdown['name'];
                      },
                    ),
                    if (controller.createWorkOrderShowHideField['discoveredBySelectMe'] == true)
                      Padding(
                        padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                        child: DiscrepancyAndWorkOrdersTextButton(
                          fieldName: '[Select Me]',
                          onPressed: () {
                            for (int i = 0; i < controller.workOrderDiscoveredDropdownData.length; i++) {
                              if (controller.workOrderDiscoveredDropdownData[i]['name'] == UserSessionInfo.userFullName) {
                                controller.selectedWorkOrderDiscoveredDropdown.value = controller.workOrderDiscoveredDropdownData[i];
                                controller.workOrderCreateValidationKeys['discoveredBy']?.currentState?.didChange(
                                    controller.selectedWorkOrderDiscoveredDropdown['id'].toString());
                                controller.createWorkOrderUpdateApiData['discoveredBy'] = int.parse(controller.selectedWorkOrderDiscoveredDropdown['id'].toString());
                                controller.createWorkOrderUpdateApiData['discoveredByName'] = controller.selectedWorkOrderDiscoveredDropdown['name'];
                                controller.update();
                              }
                            }
                          },
                        ),
                      ),
                    //ToDo: need to search userProfile development. in Future.
                  ],
                ),
                DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderCreateTextController.putIfAbsent('discoveredByLicenseNumber', () => TextEditingController()),
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
                    controller.createWorkOrderUpdateApiData['DiscoveredByLicenseNumber'] = value;
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
                        dateTimeController: controller.workOrderCreateTextController.putIfAbsent(
                          'createdAt',
                              () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTimeHelper.now)),
                        ),
                        dateType: "date",
                        onConfirm: (dateTime) {
                          controller.createWorkOrderUpdateApiData["CreatedAt"] = dateTime;
                          controller.workOrderCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                        },
                      ),
                    ),
                    DiscrepancyAndWorkOrdersDropDown(
                      dropDownController: controller.workOrderCreateTextController.putIfAbsent('time', () => TextEditingController()),
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
                        controller.createWorkOrderUpdateApiData["CreatedAt"] =
                        '${controller.createWorkOrderUpdateApiData["CreatedAt"]
                            .toString()
                            .split(' ')
                            .first}T${controller.selectedTimeDropDown['name']}';
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
                          controller.workOrderCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                          String a = DateTimeHelper.now
                              .toString()
                              .split(' ')
                              .first;
                          String b = DateTimeHelper.now
                              .toString()
                              .split(' ')
                              .last;
                          String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                          String f = '${a}T$c';
                          controller.createWorkOrderUpdateApiData["CreatedAt"] = DateFormat('yyyy-MM-ddTHH:mm').format(DateTimeHelper.now).toString();
                          controller.selectedTimeDropDown.clear();
                          controller.selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(f))});
                          controller.workOrderCreateTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
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
                        dateTimeController: controller.workOrderCreateTextController.putIfAbsent(
                          'createdAt',
                              () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTimeHelper.now)),
                        ),
                        dateType: "date",
                        onConfirm: (dateTime) {
                          controller.createWorkOrderUpdateApiData["CreatedAt"] = dateTime;
                          controller.workOrderCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                        },
                      ),
                    ),
                    DiscrepancyAndWorkOrdersDropDown(
                      expands: false,
                      dropDownController: controller.workOrderCreateTextController.putIfAbsent('time', () => TextEditingController()),
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
                        controller.createWorkOrderUpdateApiData["CreatedAt"] =
                        '${controller.createWorkOrderUpdateApiData["CreatedAt"]
                            .toString()
                            .split(' ')
                            .first}T${controller.selectedTimeDropDown['name']}';
                      },
                    ),
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: Icons.date_range_sharp,
                      iconColor: ColorConstants.button,
                      buttonColor: ColorConstants.black,
                      buttonText: "Date Now",
                      buttonTextColor: Colors.white,
                      onPressed: () {
                        controller.workOrderCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                        String a = DateTimeHelper.now
                            .toString()
                            .split(' ')
                            .first;
                        String b = DateTimeHelper.now
                            .toString()
                            .split(' ')
                            .last;
                        String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                        String f = '${a}T$c';
                        controller.createWorkOrderUpdateApiData["CreatedAt"] = DateFormat('yyyy-MM-ddTHH:mm').format(DateTimeHelper.now).toString();
                        controller.selectedTimeDropDown.clear();
                        controller.selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(f))});
                        controller.workOrderCreateTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
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

  descriptionCreateViewReturn() {
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
              key: controller.gKeyForCreate.putIfAbsent('discrepancy', () => GlobalKey()),
              validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("discrepancy", () => GlobalKey<FormFieldState>()),
              textFieldController: controller.workOrderCreateTextController.putIfAbsent('discrepancy', () => TextEditingController()),
              req: true,
              dataType: 'text',
              maxCharacterLength: 2000,
              maxLines: 5,
              showCounter: true,
              textFieldWidth: Get.width,
              fieldName: 'Description',
              hintText: 'Discrepancy Description hare....',
              onChanged: (value) {
                controller.createWorkOrderUpdateApiData['discrepancy'] = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  statusCreateViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
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
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth:
                  DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 80
                      : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.workOrderCreateTextController.putIfAbsent('status', () => TextEditingController()),
                  statusEnable: true,
                  dropDownKey: 'name',
                  completeColor: controller.selectedStatusDropdown['name'] == 'Completed' ? true : false,
                  dropDownData: controller.statusDropdownData,
                  hintText:
                  controller.selectedStatusDropdown.isNotEmpty
                      ? controller.selectedStatusDropdown['name']
                      : controller.statusDropdownData.isNotEmpty
                      ? controller.statusDropdownData[0]['name']
                      : "--  --",
                  fieldName: "Status",
                  onChanged: (value) async {
                    controller.selectedStatusDropdown.value = value;
                    controller.createWorkOrderUpdateApiData['status'] = controller.selectedStatusDropdown['id'];
                    controller.update();
                  },
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
                              textFieldController: controller.workOrderCreateTextController.putIfAbsent('aCTTCompletedAt', () => TextEditingController()),
                              dataType: 'number',
                              textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                                  : Get.width,
                              fieldName: 'AC TT @ Completed',
                              hintText: 'AC TT',
                              onChanged: (value) {
                                controller.createWorkOrderUpdateApiData['aCTTCompletedAt'] = value;
                              },
                            ),
                            Padding(
                              padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : const EdgeInsets.only(top: 0.0),
                              child: DiscrepancyAndWorkOrdersTextButton(
                                fieldName: '[Load Current Value]',
                                onPressed: () async {
                                  if (controller.createWorkOrderUpdateApiData['unitId'] > 0) {
                                    LoaderHelper.loaderWithGif();
                                    await controller.loadCurrentValueForCompleteCreateWorkOrder(unitId: controller.createWorkOrderUpdateApiData['unitId'].toString());
                                  } else {
                                    LoaderHelper.loaderWithGif();
                                    await controller.loadCurrentValueForCompleteCreateWorkOrder(unitId: '0');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController()),
                        dataType: 'number',
                        textFieldWidth:
                        DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                            ? (Get.width / 3) - 80
                            : (Get.width / 2) - 80
                            : Get.width,
                        fieldName: 'Engine #1 TT @ Completed',
                        hintText: 'E1 TT',
                        onChanged: (value) {
                          controller.createWorkOrderUpdateApiData['engine1TTCompletedAt'] = value;
                        },
                      ),
                      if (controller.aircraftInfoData.isNotNullOrEmpty)
                        Column(
                          children: [
                            if (controller.aircraftInfoData['engine2Enabled'])
                              DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                    : Get.width,
                                fieldName: 'Engine #2 TT @ Completed',
                                onChanged: (value) {
                                  controller.createWorkOrderUpdateApiData['engine2TTCompletedAt'] = value;
                                },
                              ),
                            if (controller.aircraftInfoData['engine3Enabled'])
                              DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                    : Get.width,
                                fieldName: 'Engine #3 TT @ Completed',
                                onChanged: (value) {
                                  controller.createWorkOrderUpdateApiData['engine3TTCompletedAt'] = value;
                                },
                              ),
                            if (controller.aircraftInfoData['engine4Enabled'])
                              DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.workOrderCreateTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                    ? (Get.width / 3) - 80
                                    : (Get.width / 2) - 80
                                    : Get.width,
                                fieldName: 'Engine #4 TT @ Completed',
                                onChanged: (value) {
                                  controller.createWorkOrderUpdateApiData['engine4TTCompletedAt'] = value;
                                },
                              ),
                          ],
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
  //
  mechanicAssignedToOneCreateViewReturn() {
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
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10.0,
                  children: [
                    DiscrepancyAndWorkOrdersDropDown(
                      expands: true,
                      textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                          : Get.width,
                      dropDownController: controller.workOrderCreateTextController.putIfAbsent('assignedTo', () => TextEditingController()),
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
                        controller.createWorkOrderUpdateApiData['assignedTo'] = int.parse(controller.selectedMechanicAssignedToOneDropdown['id'].toString());
                      },
                    ),
                    if (controller.createWorkOrderShowHideField['mechanicAssignedToOne'] == true)
                      Padding(
                        padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                        child: DiscrepancyAndWorkOrdersTextButton(
                          fieldName: '[Select Me]',
                          onPressed: () {
                            for (int i = 0; i < controller.mechanicAssignedToOneDropdownData.length; i++) {
                              if (controller.mechanicAssignedToOneDropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
                                controller.selectedMechanicAssignedToOneDropdown.value = controller.mechanicAssignedToOneDropdownData[i];
                                controller.createWorkOrderUpdateApiData['assignedTo'] = int.parse(controller.selectedMechanicAssignedToOneDropdown['id'].toString());
                                controller.update();
                              }
                            }
                          },
                        ),
                      ),
                  ],
                ),
                DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderCreateTextController.putIfAbsent('correctedByLicenseNumber', () => TextEditingController()),
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
                    controller.createWorkOrderUpdateApiData['correctedByLicenseNumber'] = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  mechanicAssignedToTwoCreateViewReturn() {
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
              alignment: WrapAlignment.start,
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
                  dropDownController: controller.workOrderCreateTextController.putIfAbsent('assignedTo2', () => TextEditingController()),
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
                    controller.createWorkOrderUpdateApiData['assignedTo2'] = int.parse(controller.selectedMechanicAssignedToTwoDropdown['id'].toString());
                    // controller.createWorkOrderUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToTwoDropdown['name'];
                  },
                ),
                if (controller.createWorkOrderShowHideField['mechanicAssignedToTwo'] == true)
                  Padding(
                    padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                    child: DiscrepancyAndWorkOrdersTextButton(
                      fieldName: '[Select Me]',
                      onPressed: () {
                        for (int i = 0; i < controller.mechanicAssignedToTwoDropdownData.length; i++) {
                          if (controller.mechanicAssignedToTwoDropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
                            controller.selectedMechanicAssignedToTwoDropdown.value = controller.mechanicAssignedToTwoDropdownData[i];
                            controller.createWorkOrderUpdateApiData['assignedTo2'] = int.parse(controller.selectedMechanicAssignedToTwoDropdown['id'].toString());
                            // controller.createWorkOrderUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToTwoDropdown['name'];
                            controller.update();
                          }
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  mechanicAssignedToThreeCreateViewReturn() {
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
              alignment: WrapAlignment.start,
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
                  dropDownController: controller.workOrderCreateTextController.putIfAbsent('assignedTo3', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.mechanicAssignedToThreeDropdownData,
                  hintText:
                  controller.selectedMechanicAssignedToThreeDropdown.isNotEmpty
                      ? controller.selectedMechanicAssignedToThreeDropdown['name']
                      : controller.mechanicAssignedToThreeDropdownData.isNotEmpty
                      ? controller.mechanicAssignedToThreeDropdownData[0]['name']
                      : "-- Not Assigned --",
                  fieldName: "Mechanic Assigned To #3",
                  onChanged: (value) async {
                    controller.selectedMechanicAssignedToThreeDropdown.value = value;
                    controller.createWorkOrderUpdateApiData['assignedTo3'] = int.parse(controller.selectedMechanicAssignedToThreeDropdown['id'].toString());
                    // controller.createWorkOrderUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToThreeDropdown['name'];
                  },
                ),
                if (controller.createWorkOrderShowHideField['mechanicAssignedToThree'] == true)
                  Padding(
                    padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                    child: DiscrepancyAndWorkOrdersTextButton(
                      fieldName: '[Select Me]',
                      onPressed: () {
                        for (int i = 0; i < controller.mechanicAssignedToThreeDropdownData.length; i++) {
                          if (controller.mechanicAssignedToThreeDropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
                            controller.selectedMechanicAssignedToThreeDropdown.value = controller.mechanicAssignedToThreeDropdownData[i];
                            controller.createWorkOrderUpdateApiData['assignedTo3'] = int.parse(controller.selectedMechanicAssignedToThreeDropdown['id'].toString());
                            // controller.createWorkOrderUpdateApiData['MechanicAssignedTo3'] = controller.selectedMechanicAssignedToThreeDropdown['name'];
                            controller.update();
                          }
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  melCreateViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.headerTitleReturn(title: 'MEL'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiscrepancyAndWorkOrdersDropDown(
              expands: true,
              textFieldWidth:
              DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                  ? (Get.width / 3) - 80
                  : (Get.width / 2) - 80
                  : Get.width,
              dropDownController: controller.workOrderCreateTextController.putIfAbsent('mel', () => TextEditingController()),
              dropDownKey: 'name',
              dropDownData: controller.melDropdownData,
              hintText:
              controller.selectedMelDropdown.isNotEmpty
                  ? controller.selectedMelDropdown['name']
                  : controller.melDropdownData.isNotEmpty
                  ? controller.melDropdownData[0]['name']
                  : "-- No --",
              fieldName: "MEL",
              onChanged: (value) async {
                controller.selectedMelDropdown.value = value;
                controller.createWorkOrderUpdateApiData['mel'] = int.parse(controller.selectedMelDropdown['id'].toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  ataCodeCreateViewReturn() {
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
                      key: controller.gKeyForCreate.putIfAbsent('ataCode', () => GlobalKey()),
                      validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("ataCode", () => GlobalKey<FormFieldState>()),
                      textFieldController: controller.workOrderCreateTextController.putIfAbsent('ataCode', () => TextEditingController()),
                      maxCharacterLength: 9,
                      dataType: 'number',
                      req: controller.selectedStatusDropdown['id'] == 'Completed' ? true : false,
                      textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                      fieldName: 'ATA Code',
                      hintText: 'ATA Code',
                      onChanged: (value) {
                        controller.createWorkOrderUpdateApiData['ATACode'] = value;
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
                            await controller.ataCodeDialogView(editView: 'create');
                          } else {
                            LoaderHelper.loaderWithGif();
                            await controller.ataDataViewAPICall();
                            await controller.ataCodeDialogView(editView: 'create');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderCreateTextController.putIfAbsent('atamcnCode', () => TextEditingController()),
                  maxCharacterLength: 9,
                  dataType: 'text',
                  hintText: 'MNC Code',
                  textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                  fieldName: 'MNC Code',
                  onChanged: (value) {
                    controller.createWorkOrderUpdateApiData['ATAMCNCode'] = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //
  // discrepancyServiceStatusCreateViewReturn() {
  //   return Material(
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         controller.headerTitleReturn(title: 'Discrepancy Service Status'),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Wrap(
  //             alignment: WrapAlignment.spaceBetween,
  //             spacing: 10.0,
  //             runSpacing: 5.0,
  //             children: [
  //               DiscrepancyAndWorkOrdersDropDown(
  //                 expands: true,
  //                 textFieldWidth:
  //                 DeviceType.isTablet
  //                     ? DeviceOrientation.isLandscape
  //                     ? (Get.width / 3) - 80
  //                     : (Get.width / 2) - 80
  //                     : Get.width,
  //                 dropDownController: controller.workOrderCreateTextController.putIfAbsent('systemAffected', () => TextEditingController()),
  //                 dropDownKey: 'name',
  //                 dropDownData: controller.systemAffectedDropDownData,
  //                 hintText:
  //                 controller.selectedSystemAffectedDropdown.isNotEmpty
  //                     ? controller.selectedSystemAffectedDropdown['name']
  //                     : controller.systemAffectedDropDownData.isNotEmpty
  //                     ? controller.systemAffectedDropDownData[1]['name']
  //                     : "-- Not Assigned --",
  //                 fieldName: "System Affected",
  //                 onChanged: (value) async {
  //                   controller.selectedSystemAffectedDropdown.value = value;
  //                   controller.createWorkOrderUpdateApiData['SystemAffected'] = controller.selectedSystemAffectedDropdown['id'];
  //                 },
  //               ),
  //               DiscrepancyAndWorkOrdersDropDown(
  //                 expands: true,
  //                 textFieldWidth:
  //                 DeviceType.isTablet
  //                     ? DeviceOrientation.isLandscape
  //                     ? (Get.width / 3) - 80
  //                     : (Get.width / 2) - 80
  //                     : Get.width,
  //                 dropDownController: controller.workOrderCreateTextController.putIfAbsent('functionalGroup', () => TextEditingController()),
  //                 dropDownKey: 'name',
  //                 dropDownData: controller.functionalGroupDropDownData,
  //                 hintText:
  //                 controller.selectedFunctionalGroupDropdown.isNotEmpty
  //                     ? controller.selectedFunctionalGroupDropdown['name']
  //                     : controller.functionalGroupDropDownData.isNotEmpty
  //                     ? controller.functionalGroupDropDownData[1]['name']
  //                     : "-- Not Assigned --",
  //                 fieldName: "Functional Group",
  //                 onChanged: (value) async {
  //                   controller.selectedFunctionalGroupDropdown.value = value;
  //                   controller.createWorkOrderUpdateApiData['FunctionalGroup'] = controller.selectedFunctionalGroupDropdown['id'];
  //                 },
  //               ),
  //               DiscrepancyAndWorkOrdersDropDown(
  //                 expands: true,
  //                 textFieldWidth:
  //                 DeviceType.isTablet
  //                     ? DeviceOrientation.isLandscape
  //                     ? (Get.width / 3) - 80
  //                     : (Get.width / 2) - 80
  //                     : Get.width,
  //                 dropDownController: controller.workOrderCreateTextController.putIfAbsent('malfunctionEffect', () => TextEditingController()),
  //                 dropDownKey: 'name',
  //                 dropDownData: controller.malFunctionEffectDropDownData,
  //                 hintText:
  //                 controller.selectedMalFunctionEffectDropdown.isNotEmpty
  //                     ? controller.selectedMalFunctionEffectDropdown['name']
  //                     : controller.malFunctionEffectDropDownData.isNotEmpty
  //                     ? controller.malFunctionEffectDropDownData[1]['name']
  //                     : "-- Not Assigned --",
  //                 fieldName: "Malfunction Effect",
  //                 onChanged: (value) async {
  //                   controller.selectedMalFunctionEffectDropdown.value = value;
  //                   controller.createWorkOrderUpdateApiData['MalfunctionEffect'] = controller.selectedMalFunctionEffectDropdown['id'];
  //                 },
  //               ),
  //               DiscrepancyAndWorkOrdersDropDown(
  //                 expands: true,
  //                 textFieldWidth:
  //                 DeviceType.isTablet
  //                     ? DeviceOrientation.isLandscape
  //                     ? (Get.width / 3) - 80
  //                     : (Get.width / 2) - 80
  //                     : Get.width,
  //                 dropDownController: controller.workOrderCreateTextController.putIfAbsent('whenDiscoveredName', () => TextEditingController()),
  //                 dropDownKey: 'name',
  //                 dropDownData: controller.whenDiscoveredDropDownData,
  //                 hintText:
  //                 controller.selectedWhenDiscoveredDropdown.isNotEmpty
  //                     ? controller.selectedWhenDiscoveredDropdown['name']
  //                     : controller.whenDiscoveredDropDownData.isNotEmpty
  //                     ? controller.whenDiscoveredDropDownData[1]['name']
  //                     : "-- Not Assigned --",
  //                 fieldName: "When Discovered",
  //                 onChanged: (value) async {
  //                   controller.selectedWhenDiscoveredDropdown.value = value;
  //                   controller.createWorkOrderUpdateApiData['WhenDiscovered'] = controller.selectedWhenDiscoveredDropdown['id'];
  //                 },
  //               ),
  //               DiscrepancyAndWorkOrdersDropDown(
  //                 expands: true,
  //                 textFieldWidth:
  //                 DeviceType.isTablet
  //                     ? DeviceOrientation.isLandscape
  //                     ? (Get.width / 3) - 80
  //                     : (Get.width / 2) - 80
  //                     : Get.width,
  //                 dropDownController: controller.workOrderCreateTextController.putIfAbsent('howRecognized', () => TextEditingController()),
  //                 dropDownKey: 'name',
  //                 dropDownData: controller.howRecognizedDropDownData,
  //                 hintText:
  //                 controller.selectedHowRecognizedDropdown.isNotEmpty
  //                     ? controller.selectedHowRecognizedDropdown['name']
  //                     : controller.howRecognizedDropDownData.isNotEmpty
  //                     ? controller.howRecognizedDropDownData[1]['name']
  //                     : "-- Not Assigned --",
  //                 fieldName: "How Recognized",
  //                 onChanged: (value) async {
  //                   controller.selectedHowRecognizedDropdown.value = value;
  //                   controller.createWorkOrderUpdateApiData['HowRecognized'] = controller.selectedHowRecognizedDropdown['id'];
  //                 },
  //               ),
  //               DiscrepancyAndWorkOrdersDropDown(
  //                 expands: true,
  //                 textFieldWidth:
  //                 DeviceType.isTablet
  //                     ? DeviceOrientation.isLandscape
  //                     ? (Get.width / 3) - 80
  //                     : (Get.width / 2) - 80
  //                     : Get.width,
  //                 dropDownController: controller.workOrderCreateTextController.putIfAbsent('missionFlightType', () => TextEditingController()),
  //                 dropDownKey: 'name',
  //                 dropDownData: controller.missionFlightTypeDropDownData,
  //                 hintText:
  //                 controller.selectedMissionFlightTypeDropdown.isNotEmpty
  //                     ? controller.selectedMissionFlightTypeDropdown['name']
  //                     : controller.missionFlightTypeDropDownData.isNotEmpty
  //                     ? controller.missionFlightTypeDropDownData[1]['name']
  //                     : "-- Not Assigned --",
  //                 fieldName: "Mission Flight Type",
  //                 onChanged: (value) async {
  //                   controller.selectedMissionFlightTypeDropdown.value = value;
  //                   controller.createWorkOrderUpdateApiData['MissionFlightType'] = controller.selectedMissionFlightTypeDropdown['id'];
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // correctiveActionCreateViewReturn() {
  //   return Material(
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         controller.headerTitleReturn(title: 'Corrective Action'),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DiscrepancyAndWorkOrdersTextField(
  //             key: controller.gKeyForCreate.putIfAbsent('correctiveAction', () => GlobalKey()),
  //             validationKey: controller.workOrderCreateValidationKeys.putIfAbsent("correctiveAction", () => GlobalKey<FormFieldState>()),
  //             textFieldController: controller.workOrderCreateTextController.putIfAbsent('correctiveAction', () => TextEditingController()),
  //             dataType: 'text',
  //             req: (controller.selectedStatusDropdown['id'] ?? "") == 'Completed' ? true : false,
  //             maxCharacterLength: 5000,
  //             maxLines: 5,
  //             showCounter: true,
  //             textFieldWidth: Get.width,
  //             fieldName: 'Corrective Action',
  //             hintText: 'Discrepancy\'s Corrective Action Performed here....',
  //             onChanged: (value) {
  //               controller.createWorkOrderUpdateApiData['CorrectiveAction'] = value;
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // postMaintenanceActivitiesCreateViewReturn() {
  //   return Material(
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         controller.headerTitleReturn(title: 'Post Maintenance Activities'),
  //         if (controller.selectedWorkOrderTypeDropdown['id'].toString() == '0')
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Wrap(
  //               alignment: WrapAlignment.spaceBetween,
  //               spacing: 10.0,
  //               runSpacing: 5.0,
  //               children: [
  //                 Row(
  //                   spacing: 10.0,
  //                   children: [
  //                     Text(
  //                       'Ground Run Required: ',
  //                       style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
  //                     ),
  //                     Switch(
  //                       value: controller.createWorkOrderShowHideField['checkGroundRunRequired']!,
  //                       onChanged: (value) {
  //                         controller.createWorkOrderShowHideField['checkGroundRunRequired'] = value;
  //                         controller.createWorkOrderUpdateApiData['CheckGroundRunRequired'] = value;
  //                         controller.update();
  //                       },
  //                       activeColor: Colors.green,
  //                       activeTrackColor: Colors.green.withValues(alpha: 0.4),
  //                       inactiveThumbColor: Colors.white,
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   spacing: 10.0,
  //                   children: [
  //                     Text(
  //                       'Check Flight Required: ',
  //                       style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
  //                     ),
  //                     Switch(
  //                       value: controller.createWorkOrderShowHideField['checkFlightRequired']!,
  //                       onChanged: (value) {
  //                         controller.createWorkOrderShowHideField['checkFlightRequired'] = value;
  //                         controller.createWorkOrderUpdateApiData['CheckFlightRequired'] = value;
  //                         controller.update();
  //                       },
  //                       activeColor: Colors.green,
  //                       activeTrackColor: Colors.green.withValues(alpha: 0.4),
  //                       inactiveThumbColor: Colors.white,
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   spacing: 10.0,
  //                   children: [
  //                     Text(
  //                       'Leak Test Required: ',
  //                       style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
  //                     ),
  //                     Switch(
  //                       value: controller.createWorkOrderShowHideField['leakTestRequired']!,
  //                       onChanged: (value) {
  //                         controller.createWorkOrderShowHideField['leakTestRequired'] = value;
  //                         controller.createWorkOrderUpdateApiData['LeakTestRequired'] = value;
  //                         controller.update();
  //                       },
  //                       activeColor: Colors.green,
  //                       activeTrackColor: Colors.green.withValues(alpha: 0.4),
  //                       inactiveThumbColor: Colors.white,
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   spacing: 10.0,
  //                   children: [
  //                     Text(
  //                       'Additional Inspection Required: ',
  //                       style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
  //                     ),
  //                     Switch(
  //                       value: controller.createWorkOrderShowHideField['additionalInspectionRequired']!,
  //                       onChanged: (value) {
  //                         controller.createWorkOrderShowHideField['additionalInspectionRequired'] = value;
  //                         controller.createWorkOrderUpdateApiData['AdditionalInspectionRequired'] = value;
  //                         controller.update();
  //                       },
  //                       activeColor: Colors.green,
  //                       activeTrackColor: Colors.green.withValues(alpha: 0.4),
  //                       inactiveThumbColor: Colors.white,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
  //
  // associatedWorkOrderCreateViewReturn() {
  //   return Material(
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         controller.headerTitleReturn(title: 'Associated Work Order'),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: DiscrepancyAndWorkOrdersDropDown(
  //             expands: true,
  //             textFieldWidth:
  //             DeviceType.isTablet
  //                 ? DeviceOrientation.isLandscape
  //                 ? (Get.width / 3) - 80
  //                 : (Get.width / 2) - 80
  //                 : Get.width,
  //             dropDownController: controller.workOrderCreateTextController.putIfAbsent('isWorkOrder', () => TextEditingController()),
  //             dropDownKey: 'name',
  //             dropDownData: controller.associatedWorkOrderDropdownData,
  //             hintText:
  //             controller.selectedAssociatedWorkOrderDropdown.isNotEmpty
  //                 ? controller.selectedAssociatedWorkOrderDropdown['name']
  //                 : controller.associatedWorkOrderDropdownData.isNotEmpty
  //                 ? controller.associatedWorkOrderDropdownData[1]['name']
  //                 : "-- No --",
  //             fieldName: "Associated Work Order",
  //             onChanged: (value) async {
  //               controller.selectedAssociatedWorkOrderDropdown.value = value;
  //               controller.createWorkOrderUpdateApiData['WorkOrder'] = controller.selectedAssociatedWorkOrderDropdown['id'];
  //               if (controller.selectedAssociatedWorkOrderDropdown['id'].toString() == 'True') {
  //                 controller.createWorkOrderUpdateApiData['IsWorkOrder'] = true;
  //               } else {
  //                 controller.createWorkOrderUpdateApiData['IsWorkOrder'] = false;
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //

  clientsPurchaseOrderNumberCreateViewReturn() {
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
                  textFieldController: controller.workOrderCreateTextController.putIfAbsent('purchaseOrder', () => TextEditingController()),
                  dataType: 'text',
                  maxCharacterLength: 20,
                  showCounter: false,
                  textFieldWidth:
                  DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                      ? (Get.width / 1.5) - 80
                      : (Get.width / 1.2) - 80
                      : Get.width,
                  fieldName: 'Client\'s Purchase Order Number',
                  hintText: 'Client\'s Purchase Order Number....',
                  onChanged: (value) {
                    controller.createWorkOrderUpdateApiData['purchaseOrder'] = value;
                  },
                ),
                Padding(
                  padding: DeviceType.isTablet ? const EdgeInsets.only(top: 40.0) : const EdgeInsets.only(top: 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: '(For Invoice)',
                      style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w300, fontSize: Theme
                          .of(Get.context!)
                          .textTheme
                          .headlineMedium
                          ?.fontSize),
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

  attachmentsAndLogBooksCreateViewReturn() {
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
                Text(
                  'Complete All Editing Before Adding New Uploads To This Discrepancy',
                  style: TextStyle(fontSize: Theme
                      .of(Get.context!)
                      .textTheme
                      .headlineMedium!
                      .fontSize! + 2, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border: TableBorder.all(
                          color: Colors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: ColorConstants.primary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                          ),
                          children: [
                            SizedBox(
                              width: 180.0,
                              height: 40.0,
                              child: Center(
                                child: Text(
                                  'Type',
                                  style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize),
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
                          border: TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                color: ColorConstants.primary,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                              ),
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
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
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
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
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
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
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
          controller.headerTitleReturn(title: 'Notes'),
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
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .headlineMedium
                                          ?.fontSize,
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
                                          fontSize: Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .headlineMedium
                                              ?.fontSize,
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
                                          fontSize: Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .headlineMedium
                                              ?.fontSize,
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
                                          fontSize: Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .headlineMedium
                                              ?.fontSize,
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
                                          style: TextStyle(fontSize: Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .headlineMedium
                                              ?.fontSize),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: DeviceType.isTablet ? 300.0 : 200.0,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          controller.newNotesList[i]['fullName']!,
                                          style: TextStyle(fontSize: Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .headlineMedium
                                              ?.fontSize),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300.0,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          controller.newNotesList[i]['notes']!,
                                          style: TextStyle(fontSize: Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .headlineMedium
                                              ?.fontSize),
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
              textFieldController: controller.workOrderCreateTextController.putIfAbsent('newNotes', () => TextEditingController()),
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
                  onPressed: controller.workOrderCreateTextController['newNotes']!
                      .text
                      .toString()
                      .isNotNullOrEmpty ? () {
                    controller.newNotesList.add({
                      'fullName': UserSessionInfo.userFullName,
                      'notesCreatedAt': DateTimeHelper.dateTimeFormat12H.format(DateTimeHelper.now).toString(),
                      'notes': controller.workOrderCreateTextController['newNotes']!.text,
                    });
                    controller.workOrderCreateTextController['newNotes']!.text = '';
                    controller.update();
                  } : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
