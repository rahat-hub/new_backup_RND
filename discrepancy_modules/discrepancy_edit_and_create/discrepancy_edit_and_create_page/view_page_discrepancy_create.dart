import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_edit_and_create/discrepancy_edit_and_create_logic.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../helper/loader_helper.dart';
import '../../../../widgets/discrepancy_and_work_order_widgets.dart';

class DiscrepancyCreatePageViewCode extends StatelessWidget {
  final DiscrepancyEditAndCreateLogic controller;

  const DiscrepancyCreatePageViewCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SizeConstants.contentSpacing - 5,
      children: [
        // Equipment_View
        equipmentCreateViewReturn(),
        // Additional_Information_View
        controller.createDiscrepancyShowHideField['additionalInformationField'] == true ? additionalInformationCreateViewReturn() : const SizedBox(), // Discovered_View
        discoveredCreatedViewReturn(),
        // Description_View
        descriptionCreateViewReturn(),
        // Status_View
        statusCreateViewReturn(),
        // Mechanic_Assigned_To_1_View
        mechanicAssignedToOneCreateViewReturn(),
        // Mechanic_Assigned_To_2_View
        mechanicAssignedToTwoCreateViewReturn(),
        // Mechanic_Assigned_To_2_View
        mechanicAssignedToThreeCreateViewReturn(),
        // Scheduled_Maintenance_View
        scheduledMaintenanceCreateView(),
        // Mel_View
        melCreateViewReturn(),
        // ATA_Code_VIEW
        controller.createDiscrepancyShowHideField['ataCodeView'] == true ? ataCodeCreateViewReturn() : const SizedBox(), // Discrepancy_Service_Status_View
        discrepancyServiceStatusCreateViewReturn(),
        // Corrective_Action_View
        correctiveActionCreateViewReturn(),
        // Post_Maintenance_Activities_View
        controller.selectedDiscrepancyTypeDropdown['id'].toString() == '0' ? postMaintenanceActivitiesCreateViewReturn() : const SizedBox(), // Associated_Work_Order_View
        associatedWorkOrderCreateViewReturn(),
        // Client's_Purchase_Order_Number_View
        clientsPurchaseOrderNumberCreateViewReturn()
        , // Attachments_And_LogBooks_View
        attachmentsAndLogBooksCreateViewReturn(),
        // Notification_View
        notificationCreateViewReturn(),
        // Notes_View
        previousNotesCreateViewReturn(),
      ],
    );
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

  equipmentCreateViewReturn() {
    dropdownReturn() {
      switch (int.parse(controller.selectedDiscrepancyTypeDropdown['id'].toString())) {
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
            dropDownController: controller.discrepancyEditTextController.putIfAbsent('unitIdAircraft', () => TextEditingController()),
            dropDownKey: 'name',
            req: true,
            validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("unitIdAircraft", () => GlobalKey<FormFieldState>()),
            dropDownData: controller.unitIdAircraftDropdownData,
            hintText:
                controller.selectedUnitIdAircraftDropdown.isNotEmpty
                    ? controller.selectedUnitIdAircraftDropdown['name']
                    : controller.unitIdAircraftDropdownData.isNotEmpty
                    ? controller.unitIdAircraftDropdownData[0]['name']
                    : "-- Select Aircraft --",
            fieldName: "Aircraft",
            onChanged: (value) async {
              controller.selectedUnitIdAircraftDropdown.value = value;
              controller.unitId.value = int.parse(controller.selectedUnitIdAircraftDropdown['id'].toString());
              controller.createDiscrepancyUpdateApiData['UnitId'] = int.parse(controller.selectedUnitIdAircraftDropdown['id'].toString());
              if (int.parse(controller.selectedUnitIdAircraftDropdown['id'].toString()) > 0) {
                LoaderHelper.loaderWithGif();
                await controller.apiCallForAircraftAdditionalInformationData();
                controller.createDiscrepancyShowHideField['ataCodeView'] = true;
                await controller.userNotifierViewApiCall(
                  aircraftId: controller.selectedUnitIdAircraftDropdown['id'].toString(),
                  discrepancyType: controller.selectedDiscrepancyTypeDropdown['id'],
                );
                controller.update();
              } else {
                controller.createDiscrepancyShowHideField['additionalInformationField'] = false;
                controller.update();
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
            dropDownController: controller.discrepancyEditTextController.putIfAbsent('unitIdAccessoryTools', () => TextEditingController()),
            dropDownKey: 'name',
            req: true,
            validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent('unitIdAccessoryTools', () => GlobalKey<FormFieldState>()),
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
              controller.createDiscrepancyUpdateApiData['UnitId'] = int.parse(controller.selectedUnitIdAccessoryToolsDropdown['id'].toString());
              controller.unitId.value = int.parse(controller.selectedUnitIdAccessoryToolsDropdown['id'].toString());
              controller.createDiscrepancyShowHideField['additionalInformationField'] = false;
              await controller.userNotifierViewApiCall(
                aircraftId: controller.selectedUnitIdAccessoryToolsDropdown['id'].toString(),
                discrepancyType: controller.selectedDiscrepancyTypeDropdown['id'],
              );
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
            dropDownController: controller.discrepancyEditTextController.putIfAbsent('unitIdComponentOnAircraft', () => TextEditingController()),
            dropDownKey: 'name',
            req: true,
            validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("unitIdComponentOnAircraft", () => GlobalKey<FormFieldState>()),
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
              controller.createDiscrepancyUpdateApiData['UnitId'] = int.parse(controller.selectedUnitIdComponentOnAircraftDropdown['id'].toString());
              controller.unitId.value = int.parse(controller.selectedUnitIdComponentOnAircraftDropdown['id'].toString());
              LoaderHelper.loaderWithGif();
              controller.apiCallForAircraftComponentNameData();
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
            dropDownController: controller.discrepancyEditTextController.putIfAbsent('unitIdComponentRemoveOnAircraft', () => TextEditingController()),
            dropDownKey: 'name',
            req: true,
            validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("unitIdComponentRemoveOnAircraft", () => GlobalKey<FormFieldState>()),
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
              controller.createDiscrepancyUpdateApiData['ComponentTypeIdSpecific'] = int.parse(controller.selectedUnitIdComponentRemoveOnAircraftDropdown['id'].toString());
              LoaderHelper.loaderWithGifAndText('Loading...');
              await controller.apiCallForAircraftComponentNameDataItemChangeTwo(
                discrepancyType: controller.selectedDiscrepancyTypeDropdown['id'].toString(),
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
          headerTitleReturn(title: 'Equipment'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10.0,
              runSpacing: 5.0,
              children: [
                DiscrepancyAndWorkOrdersDropDown(
                  key: controller.gKeyForCreate.putIfAbsent('discrepancyType', () => GlobalKey()),
                  expands: true,
                  textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                              ? (Get.width / 3) - 80
                              : (Get.width / 2) - 80
                          : Get.width,
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('discrepancyType', () => TextEditingController()),
                  dropDownKey: 'name',
                  req: true,
                  validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("discrepancyType", () => GlobalKey<FormFieldState>()),
                  dropDownData: controller.discrepancyTypeDropdownData,
                  hintText:
                      controller.selectedDiscrepancyTypeDropdown.isNotEmpty
                          ? controller.selectedDiscrepancyTypeDropdown['name']
                          : controller.discrepancyTypeDropdownData.isNotEmpty
                          ? controller.discrepancyTypeDropdownData[1]['name']
                          : "-- Select Type --",
                  fieldName: "Discrepancy Type",
                  onChanged: (value) async {
                    controller.createDiscrepancyShowHideField['additionalInformationField'] = false;
                    controller.selectedDiscrepancyTypeDropdown.value = value;
                    controller.createDiscrepancyShowHideField['ataCodeView'] = false;
                    controller.createDiscrepancyUpdateApiData['DiscrepancyType'] = int.parse(controller.selectedDiscrepancyTypeDropdown['id'].toString());
                    if (controller.selectedDiscrepancyTypeDropdown['id'].toString() == '0' ||
                        controller.selectedDiscrepancyTypeDropdown['id'].toString() == '1' ||
                        controller.selectedDiscrepancyTypeDropdown['id'].toString() == '2' ||
                        controller.selectedDiscrepancyTypeDropdown['id'].toString() == '3') {
                      LoaderHelper.loaderWithGifAndText('Loading...');
                      await controller.discrepancyTypeChangeApiCall();
                    }
                    if (controller.selectedDiscrepancyTypeDropdown['id'].toString() == '4' || controller.selectedDiscrepancyTypeDropdown['id'].toString() == '5') {
                      LoaderHelper.loaderWithGifAndText('Loading...');
                      await controller.apiCallForAircraftComponentNameDataItemChangeTwo(
                        discrepancyType: controller.selectedDiscrepancyTypeDropdown['id'].toString(),
                        unitId: '',
                        itemChange: '0',
                        componentTypeIdSpecific: '0',
                      );
                    }
                    controller.update();
                  },
                ),
                dropdownReturn(),
                if (int.parse(controller.selectedDiscrepancyTypeDropdown['id'].toString()) == 2 &&
                    controller.selectedUnitIdComponentOnAircraftDropdown.isNotNullOrEmpty &&
                    controller.selectedUnitIdComponentOnAircraftDropdown['id'].toString() != '0')
                  DiscrepancyAndWorkOrdersDropDown(
                    expands: true,
                    textFieldWidth:
                        DeviceType.isTablet
                            ? DeviceOrientation.isLandscape
                                ? (Get.width / 3) - 80
                                : (Get.width / 2) - 80
                            : Get.width,
                    dropDownController: controller.discrepancyEditTextController.putIfAbsent('componentTypeIdSpecific', () => TextEditingController()),
                    dropDownKey: 'name',
                    req: true,
                    validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent('componentTypeIdSpecific', () => GlobalKey<FormFieldState>()),
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
                      controller.createDiscrepancyUpdateApiData['ComponentTypeIdSpecific'] = int.parse(controller.selectedComponentTypeIdSpecificDropdown['id'].toString());
                      if (int.parse(controller.selectedComponentTypeIdSpecificDropdown['id'].toString()) > 0) {
                        LoaderHelper.loaderWithGifAndText('Loading...');
                        await controller.apiCallForAircraftComponentNameDataItemChangeTwo(
                          discrepancyType: controller.selectedDiscrepancyTypeDropdown['id'].toString(),
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
    switch (int.parse(controller.selectedDiscrepancyTypeDropdown['id'].toString())) {
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
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('actt', () => TextEditingController()),
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
                        controller.createDiscrepancyUpdateApiData['HobbsName'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('landings', () => TextEditingController()),
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
                        controller.createDiscrepancyUpdateApiData['Landings'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('torqueEvents', () => TextEditingController()),
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
                        controller.createDiscrepancyUpdateApiData['TorqueEvents'] = value;
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
                          textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine1TT', () => TextEditingController()),
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
                            controller.createDiscrepancyUpdateApiData['Engine1TTName'] = value;
                          },
                        ),
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine1Starts', () => TextEditingController()),
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
                            controller.createDiscrepancyUpdateApiData['Engine1Starts'] = double.parse(value);
                          },
                        ),
                      ],
                    ),
                    if (controller.aircraftInfoData['engine2Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine2TT', () => TextEditingController()),
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
                              controller.createDiscrepancyUpdateApiData['Engine2TTName'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine2Starts', () => TextEditingController()),
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
                              controller.createDiscrepancyUpdateApiData['Engine2Starts'] = double.parse(value);
                            },
                          ),
                        ],
                      ),
                    if (controller.aircraftInfoData['engine3Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine3TT', () => TextEditingController()),
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
                              controller.createDiscrepancyUpdateApiData['Engine3TTName'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine3Starts', () => TextEditingController()),
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
                              controller.createDiscrepancyUpdateApiData['Engine3Starts'] = double.parse(value);
                            },
                          ),
                        ],
                      ),
                    if (controller.aircraftInfoData['engine4Enabled'])
                      Column(
                        children: [
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine4TT', () => TextEditingController()),
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
                              controller.createDiscrepancyUpdateApiData['Engine4TTName'] = value;
                            },
                          ),
                          DiscrepancyAndWorkOrdersTextField(
                            textFieldController: controller.discrepancyEditTextController.putIfAbsent('engine4Starts', () => TextEditingController()),
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
                              controller.createDiscrepancyUpdateApiData['Engine4Starts'] = double.parse(value);
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [headerTitleReturn(title: 'Additional Information At The Time Of Issue')]),
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
                  children: [
                    DiscrepancyAndWorkOrdersTextField(
                      key: controller.gKeyForCreate.putIfAbsent('outsideComponentName', () => GlobalKey()),
                      validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("outsideComponentName", () => GlobalKey<FormFieldState>()),
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('outsideComponentName', () => TextEditingController()),
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
                        controller.createDiscrepancyUpdateApiData['OutsideComponentName'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController()),
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
                        controller.createDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = value;
                      },
                    ),
                    DiscrepancyAndWorkOrdersTextField(
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController()),
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
                        controller.createDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = value;
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
                          dropDownController: controller.discrepancyCreateTextController.putIfAbsent('componentServiceLife1Type', () => TextEditingController()),
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
                            controller.createDiscrepancyUpdateApiData['ComponentServiceLife1Type'] = int.parse(controller.selectedServiceLifeTypeOneDropdown['id'].toString());
                            // controller.createDiscrepancyUpdateApiData['ComponentServiceLife1TypeName'] = controller.selectedServiceLifeTypeOneDropdown['name'];
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
                          dropDownController: controller.discrepancyCreateTextController.putIfAbsent('componentServiceLife2Type', () => TextEditingController()),
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
                            controller.createDiscrepancyUpdateApiData['ComponentServiceLife2Type'] = int.parse(controller.selectedServiceLifeTypeTwoDropdown['id'].toString());
                            // controller.createDiscrepancyUpdateApiData['ComponentServiceLife2TypeName'] = controller.selectedServiceLifeTypeTwoDropdown['name'];
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.discrepancyCreateTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController()),
                          dataType: 'number',
                          decimalNumber: true,
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Since New Amount',
                          onChanged: (value) {
                            controller.createDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = value;
                          },
                        ),
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController()),
                          dataType: 'number',
                          decimalNumber: true,
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Since New Amount',
                          onChanged: (value) {
                            controller.createDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = value;
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.discrepancyCreateTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController()),
                          dataType: 'number',
                          decimalNumber: true,
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Since O/H Amount',
                          onChanged: (value) {
                            controller.createDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = value;
                          },
                        ),
                        DiscrepancyAndWorkOrdersTextField(
                          textFieldController: controller.discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController()),
                          dataType: 'number',
                          decimalNumber: true,
                          textFieldWidth:
                              DeviceType.isTablet
                                  ? DeviceOrientation.isLandscape
                                      ? (Get.width / 3) - 80
                                      : (Get.width / 2) - 80
                                  : Get.width,
                          fieldName: 'Since O/H Amount',
                          onChanged: (value) {
                            controller.createDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = value;
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
          headerTitleReturn(title: 'Discovered'),
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
                      dropDownController: controller.discrepancyCreateTextController.putIfAbsent('discoveredBy', () => TextEditingController()),
                      dropDownKey: 'name',
                      req: true,
                      validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("discoveredBy", () => GlobalKey<FormFieldState>()),
                      dropDownData: controller.discoveredByDropdownData,
                      hintText:
                          controller.selectedDiscoveredByDropdown.isNotEmpty
                              ? controller.selectedDiscoveredByDropdown['name']
                              : controller.discoveredByDropdownData.isNotEmpty
                              ? controller.discoveredByDropdownData[1]['name']
                              : "-- Discovered By --",
                      fieldName: "Discovered",
                      onChanged: (value) async {
                        controller.selectedDiscoveredByDropdown.value = value;
                        controller.createDiscrepancyUpdateApiData['DiscoveredBy'] = int.parse(controller.selectedDiscoveredByDropdown['id'].toString());
                        controller.createDiscrepancyUpdateApiData['DiscoveredByName'] = controller.selectedDiscoveredByDropdown['name'];
                      },
                    ),
                    if (controller.createDiscrepancyShowHideField['discoveredBySelectMe'] == true)
                      Padding(
                        padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                        child: DiscrepancyAndWorkOrdersTextButton(
                          fieldName: '[Select Me]',
                          onPressed: () {
                            for (int i = 0; i < controller.discoveredByDropdownData.length; i++) {
                              if (controller.discoveredByDropdownData[i]['name'] == UserSessionInfo.userFullName) {
                                controller.selectedDiscoveredByDropdown.value = controller.discoveredByDropdownData[i];
                                controller.discrepancyCreateValidationKeys['discoveredBy']?.currentState?.didChange(controller.selectedDiscoveredByDropdown['id'].toString());
                                controller.createDiscrepancyUpdateApiData['DiscoveredBy'] = int.parse(controller.selectedDiscoveredByDropdown['id'].toString());
                                controller.createDiscrepancyUpdateApiData['DiscoveredByName'] = controller.selectedDiscoveredByDropdown['name'];
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
                  textFieldController: controller.discrepancyCreateTextController.putIfAbsent('discoveredByLicenseNumber', () => TextEditingController()),
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
                    controller.createDiscrepancyUpdateApiData['DiscoveredByLicenseNumber'] = value;
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
                            dateTimeController: controller.discrepancyCreateTextController.putIfAbsent(
                              'createdAt',
                              () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTimeHelper.now)),
                            ),
                            dateType: "date",
                            onConfirm: (dateTime) {
                              controller.createDiscrepancyUpdateApiData["CreatedAt"] = dateTime;
                              controller.discrepancyCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                            },
                          ),
                        ),
                        DiscrepancyAndWorkOrdersDropDown(
                          dropDownController: controller.discrepancyCreateTextController.putIfAbsent('time', () => TextEditingController()),
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
                            controller.createDiscrepancyUpdateApiData["CreatedAt"] =
                                '${controller.createDiscrepancyUpdateApiData["CreatedAt"].toString().split(' ').first}T${controller.selectedTimeDropDown['name']}';
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
                              controller.discrepancyCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                              String a = DateTimeHelper.now.toString().split(' ').first;
                              String b = DateTimeHelper.now.toString().split(' ').last;
                              String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                              String f = '${a}T$c';
                              controller.createDiscrepancyUpdateApiData["CreatedAt"] = DateFormat('yyyy-MM-ddTHH:mm').format(DateTimeHelper.now).toString();
                              controller.selectedTimeDropDown.clear();
                              controller.selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(f))});
                              controller.discrepancyCreateTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
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
                            dateTimeController: controller.discrepancyCreateTextController.putIfAbsent(
                              'createdAt',
                              () => TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTimeHelper.now)),
                            ),
                            dateType: "date",
                            onConfirm: (dateTime) {
                              controller.createDiscrepancyUpdateApiData["CreatedAt"] = dateTime;
                              controller.discrepancyCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                            },
                          ),
                        ),
                        DiscrepancyAndWorkOrdersDropDown(
                          expands: false,
                          dropDownController: controller.discrepancyCreateTextController.putIfAbsent('time', () => TextEditingController()),
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
                            controller.createDiscrepancyUpdateApiData["CreatedAt"] =
                                '${controller.createDiscrepancyUpdateApiData["CreatedAt"].toString().split(' ').first}T${controller.selectedTimeDropDown['name']}';
                          },
                        ),
                        DiscrepancyAndWorkOrdersMaterialButton(
                          icon: Icons.date_range_sharp,
                          iconColor: ColorConstants.button,
                          buttonColor: ColorConstants.black,
                          buttonText: "Date Now",
                          buttonTextColor: Colors.white,
                          onPressed: () {
                            controller.discrepancyCreateTextController['createdAt']!.text = DateFormat("MM/dd/yyyy").format(DateTimeHelper.now);
                            String a = DateTimeHelper.now.toString().split(' ').first;
                            String b = DateTimeHelper.now.toString().split(' ').last;
                            String c = '${b.split(':')[0]}:${b.split(':')[1]}';
                            String f = '${a}T$c';
                            controller.createDiscrepancyUpdateApiData["CreatedAt"] = DateFormat('yyyy-MM-ddTHH:mm').format(DateTimeHelper.now).toString();
                            controller.selectedTimeDropDown.clear();
                            controller.selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(f))});
                            controller.discrepancyCreateTextController['time']!.text = DateFormat("HH:mm").format(DateTime.parse(f));
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
          headerTitleReturn(title: 'Description'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiscrepancyAndWorkOrdersTextField(
              key: controller.gKeyForCreate.putIfAbsent('discrepancy', () => GlobalKey()),
              validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("discrepancy", () => GlobalKey<FormFieldState>()),
              textFieldController: controller.discrepancyCreateTextController.putIfAbsent('discrepancy', () => TextEditingController()),
              req: true,
              dataType: 'text',
              maxCharacterLength: 2000,
              maxLines: 5,
              showCounter: true,
              textFieldWidth: Get.width,
              fieldName: 'Description',
              hintText: 'Discrepancy Description hare....',
              onChanged: (value) {
                controller.createDiscrepancyUpdateApiData['Discrepancy'] = value;
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
          headerTitleReturn(title: 'Status'),
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
                  dropDownController: controller.discrepancyCreateTextController.putIfAbsent('status', () => TextEditingController()),
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
                    controller.createDiscrepancyUpdateApiData['Status'] = controller.selectedStatusDropdown['id'];
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
                              textFieldController: controller.discrepancyCreateTextController.putIfAbsent('acttCompletedAt', () => TextEditingController()),
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
                                controller.createDiscrepancyUpdateApiData['ACTTCompletedAt'] = value;
                              },
                            ),
                            Padding(
                              padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : const EdgeInsets.only(top: 0.0),
                              child: DiscrepancyAndWorkOrdersTextButton(
                                fieldName: '[Load Current Value]',
                                onPressed: () async {
                                  if (controller.createDiscrepancyUpdateApiData['UnitId'] > 0) {
                                    LoaderHelper.loaderWithGif();
                                    await controller.loadCurrentValueForCompleteDiscrepancy(unitId: controller.createDiscrepancyUpdateApiData['UnitId'].toString(), create: true);
                                  } else {
                                    LoaderHelper.loaderWithGif();
                                    await controller.loadCurrentValueForCompleteDiscrepancy(unitId: '1', create: true);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController()),
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
                          controller.createDiscrepancyUpdateApiData['Engine1TTCompletedAt'] = value;
                        },
                      ),
                      if (controller.aircraftInfoData.isNotNullOrEmpty)
                        Column(
                          children: [
                            if (controller.aircraftInfoData['engine2Enabled'])
                              DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                    DeviceType.isTablet
                                        ? DeviceOrientation.isLandscape
                                            ? (Get.width / 3) - 80
                                            : (Get.width / 2) - 80
                                        : Get.width,
                                fieldName: 'Engine #2 TT @ Completed',
                                onChanged: (value) {
                                  controller.createDiscrepancyUpdateApiData['Engine2TTCompletedAt'] = value;
                                },
                              ),
                            if (controller.aircraftInfoData['engine3Enabled'])
                              DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                    DeviceType.isTablet
                                        ? DeviceOrientation.isLandscape
                                            ? (Get.width / 3) - 80
                                            : (Get.width / 2) - 80
                                        : Get.width,
                                fieldName: 'Engine #3 TT @ Completed',
                                onChanged: (value) {
                                  controller.createDiscrepancyUpdateApiData['Engine3TTCompletedAt'] = value;
                                },
                              ),
                            if (controller.aircraftInfoData['engine4Enabled'])
                              DiscrepancyAndWorkOrdersTextField(
                                textFieldController: controller.discrepancyCreateTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController()),
                                dataType: 'number',
                                textFieldWidth:
                                    DeviceType.isTablet
                                        ? DeviceOrientation.isLandscape
                                            ? (Get.width / 3) - 80
                                            : (Get.width / 2) - 80
                                        : Get.width,
                                fieldName: 'Engine #4 TT @ Completed',
                                onChanged: (value) {
                                  controller.createDiscrepancyUpdateApiData['Engine4TTCompletedAt'] = value;
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

  mechanicAssignedToOneCreateViewReturn() {
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
                      dropDownController: controller.discrepancyCreateTextController.putIfAbsent('mechanicAssignedTo1', () => TextEditingController()),
                      dropDownKey: 'name',
                      dropDownData: controller.mechanicAssignedToOneDropdownData,
                      hintText:
                          controller.selectedMechanicAssignedToOneDropdown.isNotEmpty
                              ? controller.selectedMechanicAssignedToOneDropdown['name']
                              : controller.mechanicAssignedToOneDropdownData.isNotEmpty
                              ? controller.mechanicAssignedToOneDropdownData[1]['name']
                              : "-- Not Assigned --",
                      fieldName: "Mechanic Assigned To #1",
                      onChanged: (value) async {
                        controller.selectedMechanicAssignedToOneDropdown.value = value;
                        controller.createDiscrepancyUpdateApiData['AssignedTo'] = int.parse(controller.selectedMechanicAssignedToOneDropdown['id'].toString());
                        // controller.createDiscrepancyUpdateApiData['MechanicAssignedTo1'] = controller.selectedMechanicAssignedToOneDropdown['name'];
                      },
                    ),
                    if (controller.createDiscrepancyShowHideField['mechanicAssignedToOne'] == true)
                      Padding(
                        padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                        child: DiscrepancyAndWorkOrdersTextButton(
                          fieldName: '[Select Me]',
                          onPressed: () {
                            for (int i = 0; i < controller.mechanicAssignedToOneDropdownData.length; i++) {
                              if (controller.mechanicAssignedToOneDropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
                                controller.selectedMechanicAssignedToOneDropdown.value = controller.mechanicAssignedToOneDropdownData[i];
                                controller.createDiscrepancyUpdateApiData['AssignedTo'] = int.parse(controller.selectedMechanicAssignedToOneDropdown['id'].toString());
                                // controller.createDiscrepancyUpdateApiData['MechanicAssignedTo1'] = controller.selectedMechanicAssignedToOneDropdown['name'];
                                controller.update();
                              }
                            }
                          },
                        ),
                      ),
                  ],
                ),
                DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.discrepancyCreateTextController.putIfAbsent('correctedByLicenseNumber', () => TextEditingController()),
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
                    controller.createDiscrepancyUpdateApiData['CorrectedByLicenseNumber'] = value;
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
          headerTitleReturn(title: 'Mechanic Assigned To #2'),
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
                  dropDownController: controller.discrepancyCreateTextController.putIfAbsent('mechanicAssignedTo2', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.mechanicAssignedToTwoDropdownData,
                  hintText:
                      controller.selectedMechanicAssignedToTwoDropdown.isNotEmpty
                          ? controller.selectedMechanicAssignedToTwoDropdown['name']
                          : controller.mechanicAssignedToTwoDropdownData.isNotEmpty
                          ? controller.mechanicAssignedToTwoDropdownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "Mechanic Assigned To #2",
                  onChanged: (value) async {
                    controller.selectedMechanicAssignedToTwoDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['AssignedTo2'] = int.parse(controller.selectedMechanicAssignedToTwoDropdown['id'].toString());
                    // controller.createDiscrepancyUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToTwoDropdown['name'];
                  },
                ),
                if (controller.createDiscrepancyShowHideField['mechanicAssignedToTwo'] == true)
                  Padding(
                    padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                    child: DiscrepancyAndWorkOrdersTextButton(
                      fieldName: '[Select Me]',
                      onPressed: () {
                        for (int i = 0; i < controller.mechanicAssignedToTwoDropdownData.length; i++) {
                          if (controller.mechanicAssignedToTwoDropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
                            controller.selectedMechanicAssignedToTwoDropdown.value = controller.mechanicAssignedToTwoDropdownData[i];
                            controller.createDiscrepancyUpdateApiData['AssignedTo2'] = int.parse(controller.selectedMechanicAssignedToTwoDropdown['id'].toString());
                            // controller.createDiscrepancyUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToTwoDropdown['name'];
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
          headerTitleReturn(title: 'Mechanic Assigned To #3'),
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
                  dropDownController: controller.discrepancyCreateTextController.putIfAbsent('mechanicAssignedTo3', () => TextEditingController()),
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
                    controller.createDiscrepancyUpdateApiData['AssignedTo3'] = int.parse(controller.selectedMechanicAssignedToThreeDropdown['id'].toString());
                    // controller.createDiscrepancyUpdateApiData['MechanicAssignedTo2'] = controller.selectedMechanicAssignedToThreeDropdown['name'];
                  },
                ),
                if (controller.createDiscrepancyShowHideField['mechanicAssignedThree'] == true)
                  Padding(
                    padding: DeviceType.isTablet ? const EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                    child: DiscrepancyAndWorkOrdersTextButton(
                      fieldName: '[Select Me]',
                      onPressed: () {
                        for (int i = 0; i < controller.mechanicAssignedToThreeDropdownData.length; i++) {
                          if (controller.mechanicAssignedToThreeDropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
                            controller.selectedMechanicAssignedToThreeDropdown.value = controller.mechanicAssignedToThreeDropdownData[i];
                            controller.createDiscrepancyUpdateApiData['AssignedTo3'] = int.parse(controller.selectedMechanicAssignedToThreeDropdown['id'].toString());
                            // controller.createDiscrepancyUpdateApiData['MechanicAssignedTo3'] = controller.selectedMechanicAssignedToThreeDropdown['name'];
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

  scheduledMaintenanceCreateView() {
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
                DiscrepancyAndWorkOrdersDropDown(
                  expands: true,
                  textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                              ? (Get.width / 3) - 80
                              : (Get.width / 2) - 80
                          : Get.width,
                  dropDownController: controller.discrepancyCreateTextController.putIfAbsent('scheduleMtnc', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.scheduledMaintenanceDropdownData,
                  hintText:
                      controller.selectedScheduledMaintenanceDropdown.isNotEmpty
                          ? controller.selectedScheduledMaintenanceDropdown['name']
                          : controller.scheduledMaintenanceDropdownData.isNotEmpty
                          ? controller.scheduledMaintenanceDropdownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "Scheduled Maintenance",
                  onChanged: (value) async {
                    controller.selectedScheduledMaintenanceDropdown.value = value;
                    controller.editDiscrepancyUpdateApiData['ScheduleMtnc'] = int.parse(controller.selectedScheduledMaintenanceDropdown['id'].toString());
                  },
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
          headerTitleReturn(title: 'MEL'),
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
              dropDownController: controller.discrepancyCreateTextController.putIfAbsent('mel', () => TextEditingController()),
              dropDownKey: 'name',
              dropDownData: controller.melDropdownData,
              hintText:
                  controller.selectedMelDropdown.isNotEmpty
                      ? controller.selectedMelDropdown['name']
                      : controller.melDropdownData.isNotEmpty
                      ? controller.melDropdownData[1]['name']
                      : "-- No --",
              fieldName: "MEL",
              onChanged: (value) async {
                controller.selectedMelDropdown.value = value;
                controller.createDiscrepancyUpdateApiData['Mel'] = int.parse(controller.selectedMelDropdown['id'].toString());
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
                      key: controller.gKeyForCreate.putIfAbsent('ataCode', () => GlobalKey()),
                      validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("ataCode", () => GlobalKey<FormFieldState>()),
                      textFieldController: controller.discrepancyCreateTextController.putIfAbsent('ataCode', () => TextEditingController()),
                      maxCharacterLength: 9,
                      dataType: 'number',
                      req: controller.selectedStatusDropdown['id'] == 'Completed' ? true : false,
                      textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                      fieldName: 'ATA Code',
                      hintText: 'ATA Code',
                      onChanged: (value) {
                        controller.createDiscrepancyUpdateApiData['ATACode'] = value;
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
                  textFieldController: controller.discrepancyCreateTextController.putIfAbsent('atamcnCode', () => TextEditingController()),
                  maxCharacterLength: 9,
                  dataType: 'text',
                  hintText: 'MNC Code',
                  textFieldWidth: DeviceType.isTablet ? (Get.width / 3) - 80 : Get.width,
                  fieldName: 'MNC Code',
                  onChanged: (value) {
                    controller.createDiscrepancyUpdateApiData['ATAMCNCode'] = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  discrepancyServiceStatusCreateViewReturn() {
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
                  textFieldWidth:
                      DeviceType.isTablet
                          ? DeviceOrientation.isLandscape
                              ? (Get.width / 3) - 80
                              : (Get.width / 2) - 80
                          : Get.width,
                  dropDownController: controller.discrepancyCreateTextController.putIfAbsent('systemAffected', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.systemAffectedDropDownData,
                  hintText:
                      controller.selectedSystemAffectedDropdown.isNotEmpty
                          ? controller.selectedSystemAffectedDropdown['name']
                          : controller.systemAffectedDropDownData.isNotEmpty
                          ? controller.systemAffectedDropDownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "System Affected",
                  onChanged: (value) async {
                    controller.selectedSystemAffectedDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['SystemAffected'] = controller.selectedSystemAffectedDropdown['id'];
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
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('functionalGroup', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.functionalGroupDropDownData,
                  hintText:
                      controller.selectedFunctionalGroupDropdown.isNotEmpty
                          ? controller.selectedFunctionalGroupDropdown['name']
                          : controller.functionalGroupDropDownData.isNotEmpty
                          ? controller.functionalGroupDropDownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "Functional Group",
                  onChanged: (value) async {
                    controller.selectedFunctionalGroupDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['FunctionalGroup'] = controller.selectedFunctionalGroupDropdown['id'];
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
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('malfunctionEffect', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.malFunctionEffectDropDownData,
                  hintText:
                      controller.selectedMalFunctionEffectDropdown.isNotEmpty
                          ? controller.selectedMalFunctionEffectDropdown['name']
                          : controller.malFunctionEffectDropDownData.isNotEmpty
                          ? controller.malFunctionEffectDropDownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "Malfunction Effect",
                  onChanged: (value) async {
                    controller.selectedMalFunctionEffectDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['MalfunctionEffect'] = controller.selectedMalFunctionEffectDropdown['id'];
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
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('whenDiscoveredName', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.whenDiscoveredDropDownData,
                  hintText:
                      controller.selectedWhenDiscoveredDropdown.isNotEmpty
                          ? controller.selectedWhenDiscoveredDropdown['name']
                          : controller.whenDiscoveredDropDownData.isNotEmpty
                          ? controller.whenDiscoveredDropDownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "When Discovered",
                  onChanged: (value) async {
                    controller.selectedWhenDiscoveredDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['WhenDiscovered'] = controller.selectedWhenDiscoveredDropdown['id'];
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
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('howRecognized', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.howRecognizedDropDownData,
                  hintText:
                      controller.selectedHowRecognizedDropdown.isNotEmpty
                          ? controller.selectedHowRecognizedDropdown['name']
                          : controller.howRecognizedDropDownData.isNotEmpty
                          ? controller.howRecognizedDropDownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "How Recognized",
                  onChanged: (value) async {
                    controller.selectedHowRecognizedDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['HowRecognized'] = controller.selectedHowRecognizedDropdown['id'];
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
                  dropDownController: controller.discrepancyEditTextController.putIfAbsent('missionFlightType', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.missionFlightTypeDropDownData,
                  hintText:
                      controller.selectedMissionFlightTypeDropdown.isNotEmpty
                          ? controller.selectedMissionFlightTypeDropdown['name']
                          : controller.missionFlightTypeDropDownData.isNotEmpty
                          ? controller.missionFlightTypeDropDownData[1]['name']
                          : "-- Not Assigned --",
                  fieldName: "Mission Flight Type",
                  onChanged: (value) async {
                    controller.selectedMissionFlightTypeDropdown.value = value;
                    controller.createDiscrepancyUpdateApiData['MissionFlightType'] = controller.selectedMissionFlightTypeDropdown['id'];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  correctiveActionCreateViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Corrective Action'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiscrepancyAndWorkOrdersTextField(
              key: controller.gKeyForCreate.putIfAbsent('correctiveAction', () => GlobalKey()),
              validationKey: controller.discrepancyCreateValidationKeys.putIfAbsent("correctiveAction", () => GlobalKey<FormFieldState>()),
              textFieldController: controller.discrepancyCreateTextController.putIfAbsent('correctiveAction', () => TextEditingController()),
              dataType: 'text',
              req: (controller.selectedStatusDropdown['id'] ?? "") == 'Completed' ? true : false,
              maxCharacterLength: 5000,
              maxLines: 5,
              showCounter: true,
              textFieldWidth: Get.width,
              fieldName: 'Corrective Action',
              hintText: 'Discrepancy\'s Corrective Action Performed here....',
              onChanged: (value) {
                controller.createDiscrepancyUpdateApiData['CorrectiveAction'] = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  postMaintenanceActivitiesCreateViewReturn() {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ColorConstants.primary, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTitleReturn(title: 'Post Maintenance Activities'),
          if (controller.selectedDiscrepancyTypeDropdown['id'].toString() == '0')
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
                        value: controller.createDiscrepancyShowHideField['checkGroundRunRequired']!,
                        onChanged: (value) {
                          controller.createDiscrepancyShowHideField['checkGroundRunRequired'] = value;
                          controller.createDiscrepancyUpdateApiData['CheckGroundRunRequired'] = value;
                          controller.update();
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
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                      Switch(
                        value: controller.createDiscrepancyShowHideField['checkFlightRequired']!,
                        onChanged: (value) {
                          controller.createDiscrepancyShowHideField['checkFlightRequired'] = value;
                          controller.createDiscrepancyUpdateApiData['CheckFlightRequired'] = value;
                          controller.update();
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
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                      Switch(
                        value: controller.createDiscrepancyShowHideField['leakTestRequired']!,
                        onChanged: (value) {
                          controller.createDiscrepancyShowHideField['leakTestRequired'] = value;
                          controller.createDiscrepancyUpdateApiData['LeakTestRequired'] = value;
                          controller.update();
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
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                      ),
                      Switch(
                        value: controller.createDiscrepancyShowHideField['additionalInspectionRequired']!,
                        onChanged: (value) {
                          controller.createDiscrepancyShowHideField['additionalInspectionRequired'] = value;
                          controller.createDiscrepancyUpdateApiData['AdditionalInspectionRequired'] = value;
                          controller.update();
                        },
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green.withValues(alpha: 0.4),
                        inactiveThumbColor: Colors.white,
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

  associatedWorkOrderCreateViewReturn() {
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
              textFieldWidth:
                  DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
              dropDownController: controller.discrepancyCreateTextController.putIfAbsent('isWorkOrder', () => TextEditingController()),
              dropDownKey: 'name',
              dropDownData: controller.associatedWorkOrderDropdownData,
              hintText:
                  controller.selectedAssociatedWorkOrderDropdown.isNotEmpty
                      ? controller.selectedAssociatedWorkOrderDropdown['name']
                      : controller.associatedWorkOrderDropdownData.isNotEmpty
                      ? controller.associatedWorkOrderDropdownData[1]['name']
                      : "-- No --",
              fieldName: "Associated Work Order",
              onChanged: (value) async {
                controller.selectedAssociatedWorkOrderDropdown.value = value;
                controller.createDiscrepancyUpdateApiData['WorkOrder'] = controller.selectedAssociatedWorkOrderDropdown['id'];
                if (controller.selectedAssociatedWorkOrderDropdown['id'].toString() == 'True') {
                  controller.createDiscrepancyUpdateApiData['IsWorkOrder'] = true;
                } else {
                  controller.createDiscrepancyUpdateApiData['IsWorkOrder'] = false;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  clientsPurchaseOrderNumberCreateViewReturn() {
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
                  textFieldController: controller.discrepancyCreateTextController.putIfAbsent('purchaseOrder', () => TextEditingController()),
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
                    controller.createDiscrepancyUpdateApiData['PurchaseOrder'] = value;
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

  attachmentsAndLogBooksCreateViewReturn() {
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
                Text(
                  'Complete All Editing Before Adding New Uploads To This Discrepancy',
                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 2, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(flex: 3),
                      border: TableBorder.all(color: Colors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
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
                                  style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                ),
                              ),
                            ),
                          ],
                        ), // for (int i = 0; i < controller.discrepancyEditApiData['attachments'].length; i++)
                        //   TableRow(children: [
                        //     SizedBox(
                        //         width: 180.0,
                        //         height: 35.0,
                        //         child: Center(child: Text('Attachment', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                        //   ]),
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
                            ), // for (int i = 0; i < controller.discrepancyEditApiData['attachments'].length; i++)
                            //   TableRow(children: [
                            //     SizedBox(
                            //         width: 450.0,
                            //         height: 35.0,
                            //         child: Center(
                            //             child: Row(
                            //               mainAxisAlignment: MainAxisAlignment.center,
                            //               mainAxisSize: MainAxisSize.max,
                            //               children: [
                            //                 InkWell(
                            //                   onTap: () async => await FileControl.getPathAndViewFile(
                            //                       fileId: controller.discrepancyEditApiData['attachments'][i]['attachmentId'].toString(),
                            //                       fileName: controller.discrepancyEditApiData['attachments'][i]['fileName'].toString()),
                            //                   child: Row(
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       Icon(
                            //                           documentsViewIconReturns(
                            //                               types: FileControl.fileType(fileName: controller.discrepancyEditApiData['attachments'][i]['fileName'])),
                            //                           size: 25.0,
                            //                           color: ColorConstants.primary.withValues(alpha: 0.7)),
                            //                       Text(controller.discrepancyEditApiData['attachments'][i]['fileName'],
                            //                           style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ))),
                            //     SizedBox(
                            //         width: 300.0,
                            //         height: 35.0,
                            //         child: Center(
                            //             child: Text(
                            //                 DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.parse(controller.discrepancyEditApiData['attachments'][i]['createdAt'])),
                            //                 style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                            //     SizedBox(
                            //         width: 300.0,
                            //         height: 35.0,
                            //         child: Center(
                            //             child: Text(controller.discrepancyEditApiData['attachments'][i]['fullName'],
                            //                 style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)))),
                            //   ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('No File Attachments', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  notificationCreateViewReturn() {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Available List: ',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                        children: <TextSpan>[],
                      ),
                    ),
                    Obx(() {
                      return MaterialButton(
                        color: controller.checkboxSelectAllUser.value ? ColorConstants.button : ColorConstants.grey,
                        onPressed: () {
                          controller.checkboxSelectAllUser.value = !controller.checkboxSelectAllUser.value;
                          controller.checkBox.clear();
                          controller.selectedUsersDropdownList.clear();
                          controller.createDiscrepancyUpdateApiData['UsersToNotify'] = "";
                          for (int i = 0; i < controller.userDropDownList.length; i++) {
                            controller.checkBox.add(controller.checkboxSelectAllUser.value);
                          }
                          if (controller.checkboxSelectAllUser.value == true) {
                            for (int i = 0; i < controller.userDropDownList.length; i++) {
                              controller.selectedUsersDropdownList.add(int.parse(controller.userDropDownList[i]["id"]));
                            }
                            controller.createDiscrepancyUpdateApiData['UsersToNotify'] = controller.selectedUsersDropdownList.join(", ");
                          }
                        },
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Select All User',
                                style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                                children: <TextSpan>[],
                              ),
                            ),
                            Checkbox(
                              side: const BorderSide(color: ColorConstants.white, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              value: controller.checkboxSelectAllUser.value,
                              onChanged: (val) {
                                controller.checkboxSelectAllUser.value = val!;
                                controller.checkBox.clear();
                                controller.selectedUsersDropdownList.clear();
                                controller.createDiscrepancyUpdateApiData["UsersToNotify"] = "";
                                for (int i = 0; i < controller.userDropDownList.length; i++) {
                                  controller.checkBox.add(val);
                                }
                                if (controller.checkboxSelectAllUser.value == true) {
                                  for (int i = 0; i < controller.userDropDownList.length; i++) {
                                    controller.selectedUsersDropdownList.add(int.parse(controller.userDropDownList[i]["id"]));
                                  }
                                  controller.createDiscrepancyUpdateApiData["UsersToNotify"] = controller.selectedUsersDropdownList.join(", ");
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstants.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorConstants.grey.withValues(alpha: 0.4),
                  ),
                  //padding: const EdgeInsets.symmetric(vertical: 3.0),
                  //margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: List.generate(controller.userDropDownList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                          child: SizedBox(
                            width:
                                DeviceType.isTablet
                                    ? DeviceOrientation.isLandscape
                                        ? Get.width / 4.5
                                        : Get.width / 2.5
                                    : Get.width,
                            child: CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              dense: false,
                              side: const BorderSide(color: ColorConstants.black, width: 2),
                              value: controller.checkBox[index],
                              tileColor: Colors.white,
                              title: Text(
                                controller.userDropDownList[index]["name"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: controller.checkboxSelectAllUser.value == true || controller.checkBox[index] == true ? ColorConstants.white : ColorConstants.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(SizeConstants.listItemRadius),
                                side: const BorderSide(color: ColorConstants.primary),
                              ),
                              selected: controller.checkBox[index],
                              selectedTileColor: ColorConstants.primary.withValues(alpha: 0.9),
                              onChanged: (val) async {
                                controller.checkBox[index] = val!;
                                if (controller.checkBox[index] == false) {
                                  controller.selectedUsersDropdownList.clear();
                                  controller.editDiscrepancyUpdateApiData["UsersToNotify"] = "";
                                  controller.checkboxSelectAllUser.value = false;
                                }
                                await controller.selectAllUserCheck();
                                controller.update();
                              },
                            ),
                          ),
                        );
                      }),
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

  previousNotesCreateViewReturn() {
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
                          decoration: const BoxDecoration(
                            color: ColorConstants.primary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                          ),
                          children: [
                            SizedBox(
                              width: DeviceType.isTablet ? 250.0 : Get.width / 2.8,
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
                              decoration: const BoxDecoration(
                                color: ColorConstants.primary,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                              ),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text('No Note', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: DiscrepancyAndWorkOrdersTextField(
              textFieldController: controller.discrepancyCreateTextController.putIfAbsent('newNotes', () => TextEditingController()),
              dataType: 'text',
              maxCharacterLength: 5000,
              maxLines: 4,
              showCounter: true,
              textFieldWidth: Get.width,
              fieldName: 'Add New Note',
              hintText: 'Add Note here....',
              onChanged: (value) {
                controller.createDiscrepancyUpdateApiData['NewNote'] = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
