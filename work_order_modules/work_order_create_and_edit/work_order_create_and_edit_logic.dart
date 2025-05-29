import 'dart:ui';

import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../helper/date_time_helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../helper/snack_bar_helper.dart';
import '../../../provider/discrepancy_api_provider.dart';
import '../../../provider/work_orders_api_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/buttons.dart';

class WorkOrderCreateAndEditLogic extends GetxController {
  RxBool isLoading = false.obs;

  RxString title = ''.obs;

  RxBool disableKeyboard = true.obs;

  Map<String, GlobalKey> gKeyForEdit = <String, GlobalKey>{};
  Map<String, GlobalKey> gKeyForCreate = <String, GlobalKey>{};

  Map<String, GlobalKey<FormFieldState>> workOrderEditValidationKeys = <String, GlobalKey<FormFieldState>>{};
  Map<String, GlobalKey<FormFieldState>> workOrderCreateValidationKeys = <String, GlobalKey<FormFieldState>>{};

  RxList timeDropDownData = [
    {"id": 0, "name": "00:00"},
    {"id": 1, "name": "00:30"},
    {"id": 2, "name": "01:00"},
    {"id": 3, "name": "01:30"},
    {"id": 4, "name": "02:00"},
    {"id": 5, "name": "02:30"},
    {"id": 6, "name": "03:00"},
    {"id": 7, "name": "03:30"},
    {"id": 8, "name": "04:00"},
    {"id": 9, "name": "04:30"},
    {"id": 10, "name": "05:00"},
    {"id": 11, "name": "05:30"},
    {"id": 12, "name": "06:00"},
    {"id": 13, "name": "06:30"},
    {"id": 14, "name": "07:00"},
    {"id": 15, "name": "07:30"},
    {"id": 16, "name": "08:00"},
    {"id": 17, "name": "08:30"},
    {"id": 18, "name": "09:00"},
    {"id": 19, "name": "09:30"},
    {"id": 20, "name": "10:00"},
    {"id": 21, "name": "10:30"},
    {"id": 22, "name": "11:00"},
    {"id": 23, "name": "11:30"},
    {"id": 24, "name": "12:00"},
    {"id": 25, "name": "12:30"},
    {"id": 26, "name": "13:00"},
    {"id": 27, "name": "13:30"},
    {"id": 28, "name": "14:00"},
    {"id": 29, "name": "14:30"},
    {"id": 30, "name": "15:00"},
    {"id": 31, "name": "15:30"},
    {"id": 32, "name": "16:00"},
    {"id": 33, "name": "16:30"},
    {"id": 34, "name": "17:00"},
    {"id": 35, "name": "17:30"},
    {"id": 36, "name": "18:00"},
    {"id": 37, "name": "18:30"},
    {"id": 38, "name": "19:00"},
    {"id": 39, "name": "19:30"},
    {"id": 40, "name": "20:00"},
    {"id": 41, "name": "20:30"},
    {"id": 42, "name": "21:00"},
    {"id": 43, "name": "21:30"},
    {"id": 44, "name": "22:00"},
    {"id": 45, "name": "22:30"},
    {"id": 46, "name": "23:00"},
    {"id": 47, "name": "23:30"},
  ].obs;
  RxMap selectedTimeDropDown = {}.obs;

  RxList workOrderDiscoveredDropdownData = [].obs;
  RxMap selectedWorkOrderDiscoveredDropdown = {}.obs;

  RxList serviceLifeTypeOneDropdownData = [].obs;
  RxMap selectedServiceLifeTypeOneDropdown = {}.obs;

  RxList serviceLifeTypeTwoDropdownData = [].obs;
  RxMap selectedServiceLifeTypeTwoDropdown = {}.obs;

  List statusDropdownData = [
    {
      'id': 'In Progress',
      'name': 'In Progress'
    },
    {
      'id': 'Parts On Order',
      'name': 'Parts On Order'
    },
    {
      'id': 'Completed',
      'name': 'Completed'
    }
  ];

  RxMap selectedStatusDropdown = {}.obs;

  RxList mechanicAssignedToOneDropdownData = [].obs;
  RxMap selectedMechanicAssignedToOneDropdown = {}.obs;

  RxList mechanicAssignedToTwoDropdownData = [].obs;
  RxMap selectedMechanicAssignedToTwoDropdown = {}.obs;

  RxList mechanicAssignedToThreeDropdownData = [].obs;
  RxMap selectedMechanicAssignedToThreeDropdown = {}.obs;

  RxList<bool> ataFieldExpand = <bool>[].obs;
  RxMap ataCodeData = {}.obs;

  RxMap aircraftInfoData = {}.obs;

  RxMap<String, dynamic> workOrderEditApiData = <String, dynamic>{}.obs;

  RxMap<String, TextEditingController> workOrderEditTextController = <String, TextEditingController>{}.obs;
  RxMap<String, TextEditingController> workOrderCreateTextController = <String, TextEditingController>{}.obs;

  RxMap<String, dynamic> editWorkOrderUpdateApiData = <String, dynamic>{
    "userId": UserSessionInfo.userId,
    "systemId": UserSessionInfo.systemId,
    "workOrderId": 0,
    "createdBy": 0,
    "createdByName": "",
    "createdAt": "",
    "discrepancyType": 0,
    "unitId": 0,
    "componentTypeIdSpecific": 0,
    "correctedBy": 0,
    "dateCorrected": "",
    "equipmentName": "",
    "hobbsName": "0",
    "engine1TTName": "0",
    "engine2TTName": "0",
    "engine3TTName": "0",
    "engine4TTName": "0",
    "aircraftACTT": "",
    "aircraftEngine1TT": "",
    "aircraftEngine2TT": "",
    "aircraftEngine3TT": "",
    "aircraftEngine4TT": "",
    "outsideComponentName": "",
    "outsideComponentSerialNumber": "",
    "outsideComponentPartNumber": "",
    "labelOutsideComponentSerialNumber": "",
    "labelOutsideComponentPartNumber": "",
    "labelOutsideComponentName": "",
    "componentServiceLife1Type": "0",
    "componentServiceLife2Type": "0",
    "componentServiceLife1TypeName": "",
    "componentServiceLife1SinceNewAmt": "0",
    "componentServiceLife1SinceOhAmt": "0",
    "componentServiceLife2TypeName": "",
    "componentServiceLife2SinceNewAmt": "0",
    "componentServiceLife2SinceOhAmt": "0",
    "discrepancy": "",
    "status": "",
    "oldStatus": "",
    "aCTTCompletedAt": "0",
    "engine1TTCompletedAt": "0",
    "engine2TTCompletedAt": "0",
    "engine3TTCompletedAt": "0",
    "engine4TTCompletedAt": "0",
    "assignedTo": 0,
    "assignedToName": "",
    "purchaseOrder": "0",
    "engine2Enabled": "true",
    "engine3Enabled": "false",
    "engine4Enabled": "true",
    "aTACode": "",
    "mCNCode": "",
    "workorderNotes": "Test Notes",
    "notes": [],
    "attachments": [],
    "editMode": true,
    "isStatusCompleted": true,
    "componentTypeName": "Test Component",
    "itemId": 0,
    "engineNumber": 0,
    "accessoryToolName": "0",
    "torqueEvents": 0,
    "landings": 0,
    "engine1Starts": 0.0,
    "engine2Starts": 0.0,
    "engine3Starts": 0.0,
    "engine4Starts": 0.0,
    "discoveredByLicenseNumber": "",
    "correctedByLicenseNumber": "",
    "assignedTo2": 0,
    "assignedTo3Name": "",
    "mel": 0,
    "woNumber": 0,
    "woCheckOut": false,
    "aircraftName": "",
    "componentName": ""
  }.obs;

  RxList<Map<String, String>> newNotesList = <Map<String, String>>[].obs;

  ///-----------------CREATE _WORK _ORDER _DATA

  RxList workOrderTypeDropdownData = [
    {
      'id': '0',
      'name': 'Aircraft',
      'selected': true,
    },
    {
      'id': '1',
      'name': 'Accessory/Tool',
      'selected': false,
    },
    {
      'id': '2',
      'name': 'Component On Aircraft',
      'selected': false,
    },
    {
      'id': '3',
      'name': 'Component Remove From Aircraft',
      'selected': false,
    },
    {
      'id': '4',
      'name': 'Component Not In DAW / Outside Work',
      'selected': false,
    },
    {
      'id': '5',
      'name': 'Other',
      'selected': false,
    },
  ].obs;
  RxMap selectedWorkOrderTypeDropdown = {}.obs;

  RxList aircraftDropdownData = [].obs;
  RxMap selectedAircraftDropdown = {}.obs;

  RxList melDropdownData = [
    {
      'id': '0',
      'name': 'No'
    },
    {
      'id': '1',
      'name': 'Yes - Create MEL'
    }
  ].obs;
  RxMap selectedMelDropdown = {}.obs;

  RxList unitIdAccessoryToolsDropdownData = [].obs;
  RxMap selectedUnitIdAccessoryToolsDropdown = {}.obs;

  RxList unitIdComponentOnAircraftDropdownData = [].obs;
  RxMap selectedUnitIdComponentOnAircraftDropdown = {}.obs;

  RxList componentTypeIdSpecificDropdownData = [].obs;
  RxMap selectedComponentTypeIdSpecificDropdown = {}.obs;

  RxList unitIdComponentRemoveOnAircraftDropdownData = [].obs;
  RxMap selectedUnitIdComponentRemoveOnAircraftDropdown = {}.obs;


  RxMap<String, bool> createWorkOrderShowHideField = <String, bool>{
    'additionalInformationField': false,
    'discoveredBySelectMe': false,
    'mechanicAssignedToOne': false,
    'mechanicAssignedToTwo': false,
    'mechanicAssignedToThree': false,
    'ataCodeView': false,
    'checkGroundRunRequired': false,
    'checkFlightRequired': false,
    'leakTestRequired': false,
    'additionalInspectionRequired': false,
  }.obs;


  RxMap<String, dynamic> createWorkOrderUpdateApiData = <String, dynamic>{
    "workOrderId": 0,
    "systemID": UserSessionInfo.systemId,
    "userId": UserSessionInfo.userId,
    "discrepancyType": 0,
    "unitId": 0,
    "componentTypeIdSpecific": 0,
    "discrepancy": "",
    "correctiveAction": "",
    "createdAt": DateFormat('yyyy-MM-ddTHH:mm').format(DateTimeHelper.now).toString(),
    "status": "In Progress",
    "createdByName": "",
    "createdBy": 0,
    "correctedBy": 0,
    "dateCorrected": "",
    "workOrder": "",
    "workOrderOnly": false,
    "createWorkOrder": true,
    "hobbs": "0.0",
    "engine1TT": "0",
    "engine2TT": "0",
    "engine3TT": "0",
    "engine4TT": "0",
    "aCTTCompletedAt": "0",
    "engine1TTCompletedAt": "0",
    "engine2TTCompletedAt": "0",
    "engine3TTCompletedAt": "0",
    "engine4TTCompletedAt": "0",
    "assignedTo": 0,
    "purchaseOrder": "",
    "checkFlightRequired": false,
    "leakTestRequired": false,
    "outsideComponentSerialNumber": "",
    "outsideComponentPartNumber": "",
    "outsideComponentName": "",
    "labelOutsideComponentSerialNumber": "",
    "labelOutsideComponentPartNumber": "",
    "labelOutsideComponentName": "",
    "componentServiceLife1Type": 0,
    "componentServiceLife1SinceNewAmt": "",
    "componentServiceLife1SinceOhAmt": "",
    "componentServiceLife2Type": 0,
    "componentServiceLife2SinceNewAmt": "",
    "componentServiceLife2SinceOhAmt": "",
    "additionalInspectionRequired": false,
    "additionalInspectionRequiredPerformedById": 0,
    "additionalInspectionRequiredPerformedByDateTime": "",
    "workorderNotes": "",
    "aTACode": "",
    "mCNCode": "",
    "torqueEvents": "0",
    "landings": "0",
    "engine1Starts": "0",
    "engine2Starts": "0",
    "engine3Starts": "0",
    "engine4Starts": "0",
    "discoveredByLicenseNumber": "",
    "correctedByLicenseNumber": "",
    "assignedTo2": 0,
    "assignedTo3": 0,
    "mel": 0,
    "woCheckOut": false,
    "notes": []
  }.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();
    title.value =
    Get.parameters['action'] == 'workOrderCreate'
        ? 'Create New Work Order'
        : kDebugMode
        ? 'Edit Work Order# ${Get.parameters['woNumber']} (Id: ${Get.parameters['workOrderId']})'
        : 'Edit Work Order# ${Get.parameters['woNumber']}';

    await ataDataViewAPICall();

    if (Get.parameters['action'] == 'workOrderCreate') {
      await commonApiCallForWorkOrderCreateDropdownData();
    }

    if (Get.parameters['action'] == 'workOrderEdit') {
      await apiCallForWorkOrderEditData();
    }

    update();

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
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
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme
                    .of(Get.context!)
                    .textTheme
                    .titleLarge!
                    .fontSize! + 3,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  apiCallForWorkOrderEditData() async {
    Response? data = await WorkOrdersApiProvider().getWorkOrderDetailsApiData(workOrderId: Get.parameters['workOrderId']!);
    if (data?.statusCode == 200) {
      workOrderEditApiData.addAll(data?.data['data']['workOrderDetails']);
      await dataSetForEditFieldData();
      await apiCallForWorkOrderEditDropdownData();
      await allDataBindForPostApiCallEditWorkOrder();
    }
  }

  dataSetForEditFieldData() {
    workOrderEditTextController.putIfAbsent('hobbs', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('landings', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('torqueEvents', () => TextEditingController());

    workOrderEditTextController.putIfAbsent('engine1TTName', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('engine2TTName', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('engine3TTName', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('engine4TTName', () => TextEditingController());

    workOrderEditTextController.putIfAbsent('engine1Starts', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('engine2Starts', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('engine3Starts', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('engine4Starts', () => TextEditingController());

    //------SET Value
    workOrderEditTextController['hobbs']!.text = workOrderEditApiData['hobbsName'].toString();
    workOrderEditTextController['landings']!.text = workOrderEditApiData['landings'].toString();
    workOrderEditTextController['torqueEvents']!.text = workOrderEditApiData['torqueEvents'].toString();

    workOrderEditTextController['engine1TTName']!.text = workOrderEditApiData['engine1TTName'].toString();
    workOrderEditTextController['engine2TTName']!.text = workOrderEditApiData['engine2TTName'].toString();
    workOrderEditTextController['engine3TTName']!.text = workOrderEditApiData['engine3TTName'].toString();
    workOrderEditTextController['engine4TTName']!.text = workOrderEditApiData['engine4TTName'].toString();

    workOrderEditTextController['engine1Starts']!.text = workOrderEditApiData['engine1Starts'].toString();
    workOrderEditTextController['engine2Starts']!.text = workOrderEditApiData['engine2Starts'].toString();
    workOrderEditTextController['engine3Starts']!.text = workOrderEditApiData['engine3Starts'].toString();
    workOrderEditTextController['engine4Starts']!.text = workOrderEditApiData['engine4Starts'].toString();

    //-------DiscrepancyType: 2 to 5
    workOrderEditTextController.putIfAbsent('outsideComponentName', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController());

    workOrderEditTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());

    workOrderEditTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());

    workOrderEditTextController['outsideComponentName']!.text = workOrderEditApiData['outsideComponentName'].toString();
    workOrderEditTextController['outsideComponentPartNumber']!.text = workOrderEditApiData['outsideComponentPartNumber'].toString();
    workOrderEditTextController['outsideComponentSerialNumber']!.text = workOrderEditApiData['outsideComponentSerialNumber'].toString();

    workOrderEditTextController['componentServiceLife1SinceNewAmt']!.text = workOrderEditApiData['componentServiceLife1SinceNewAmt'].toString();
    workOrderEditTextController['componentServiceLife2SinceNewAmt']!.text = workOrderEditApiData['componentServiceLife2SinceNewAmt'].toString();

    workOrderEditTextController['componentServiceLife1SinceOhAmt']!.text = workOrderEditApiData['componentServiceLife1SinceOhAmt'].toString();
    workOrderEditTextController['componentServiceLife2SinceOhAmt']!.text = workOrderEditApiData['componentServiceLife2SinceOhAmt'].toString();

    //--------Discovered By

    workOrderEditTextController.putIfAbsent('discoveredByLicenseNumber', () => TextEditingController());

    workOrderEditTextController['discoveredByLicenseNumber']!.text = workOrderEditApiData['discoveredByLicenseNumber'].toString();

    selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(workOrderEditApiData['createdAt']))});

    //---------Description

    workOrderEditTextController.putIfAbsent('discrepancy', () => TextEditingController());

    workOrderEditTextController['discrepancy']!.text = workOrderEditApiData['discrepancy'].toString();

    //---------Mechanic Assigned #1

    workOrderEditTextController.putIfAbsent('correctedByLicenseNumber', () => TextEditingController());

    workOrderEditTextController['correctedByLicenseNumber']!.text = workOrderEditApiData['correctedByLicenseNumber'].toString();

    //----------ATA Code #21#

    workOrderEditTextController.putIfAbsent('ataCode', () => TextEditingController());
    workOrderEditTextController.putIfAbsent('atamcnCode', () => TextEditingController());

    workOrderEditTextController['ataCode']!.text = workOrderEditApiData['ataCode'].toString();
    workOrderEditTextController['atamcnCode']!.text = workOrderEditApiData['mcnCode'].toString();


    //---------Client's Purchase Order

    workOrderEditTextController.putIfAbsent('purchaseOrder', () => TextEditingController());

    workOrderEditTextController['purchaseOrder']!.text = workOrderEditApiData['purchaseOrder'].toString();
  }

  apiCallForWorkOrderEditDropdownData() async {
    Response? userList = await WorkOrdersApiProvider().workOrderRepopulateList(action: 'userList', itemName: '', itemId: '', groupId: '0');
    if (userList?.statusCode == 200) {
      workOrderDiscoveredDropdownData.add({'id': '0', 'name': '-- Discovered By --'});
      workOrderDiscoveredDropdownData.addAll(userList?.data);
      dropDownDataSetFunction(dropdownData: workOrderDiscoveredDropdownData,
          selectedDropdown: selectedWorkOrderDiscoveredDropdown,
          matchingValue: workOrderEditApiData['createdBy'].toString());
    }

    if (workOrderEditApiData['discrepancyType'] > 1) {
      Response? componentServiceLife = await WorkOrdersApiProvider().workOrderRepopulateList(action: 'ComponentServiceLife', itemName: '0', itemId: '0', groupId: '0');
      if (componentServiceLife?.statusCode == 200) {
        serviceLifeTypeOneDropdownData.add({'id': '0', 'name': '-- Select Service Life --'});
        serviceLifeTypeOneDropdownData.addAll(componentServiceLife?.data);
        dropDownDataSetFunction(dropdownData: serviceLifeTypeOneDropdownData,
            selectedDropdown: selectedServiceLifeTypeOneDropdown,
            matchingValue: workOrderEditApiData['componentServiceLife1Type'].toString());

        serviceLifeTypeTwoDropdownData.add({'id': '0', 'name': '-- Select Service Life --'});
        serviceLifeTypeTwoDropdownData.addAll(componentServiceLife?.data);
        dropDownDataSetFunction(dropdownData: serviceLifeTypeTwoDropdownData,
            selectedDropdown: selectedServiceLifeTypeTwoDropdown,
            matchingValue: workOrderEditApiData['componentServiceLife2Type'].toString());
      }
    }

    dropDownDataSetFunction(dropdownData: statusDropdownData, selectedDropdown: selectedStatusDropdown, matchingValue: workOrderEditApiData['status']);

    Response? assignTo = await WorkOrdersApiProvider().workOrderRepopulateList(action: 'AssignTo', itemName: '0', itemId: '0', groupId: '0');

    if (assignTo?.statusCode == 200) {
      mechanicAssignedToOneDropdownData.add({'id': '0', 'name': '-- Not Assigned --'});
      mechanicAssignedToOneDropdownData.addAll(assignTo?.data);
      dropDownDataSetFunction(dropdownData: mechanicAssignedToOneDropdownData,
          selectedDropdown: selectedMechanicAssignedToOneDropdown,
          matchingValue: workOrderEditApiData['assignedTo'].toString());

      mechanicAssignedToTwoDropdownData.add({'id': '0', 'name': '-- Not Assigned --'});
      mechanicAssignedToTwoDropdownData.addAll(assignTo?.data);
      dropDownDataSetFunction(dropdownData: mechanicAssignedToTwoDropdownData,
          selectedDropdown: selectedMechanicAssignedToTwoDropdown,
          matchingValue: workOrderEditApiData['assignedTo2'].toString());

      mechanicAssignedToThreeDropdownData.add({'id': '0', 'name': '-- Not Assigned --'});
      mechanicAssignedToThreeDropdownData.addAll(assignTo?.data);
      dropDownDataSetFunction(dropdownData: mechanicAssignedToThreeDropdownData,
          selectedDropdown: selectedMechanicAssignedToThreeDropdown,
          matchingValue: workOrderEditApiData['assignedTo3'].toString());
    }
  }

  dropDownDataSetFunction({required List? dropdownData, required Map? selectedDropdown, required String? matchingValue}) {
    for (int i = 0; i < dropdownData!.length; i++) {
      if (dropdownData[i]['id'].toString() == matchingValue) {
        selectedDropdown?.addAll(dropdownData[i]);
      }
    }
  }

  allDataBindForPostApiCallEditWorkOrder() {
    editWorkOrderUpdateApiData['workOrderId'] = workOrderEditApiData['workOrderId'];
    editWorkOrderUpdateApiData['createdBy'] = workOrderEditApiData['createdBy'];
    editWorkOrderUpdateApiData['createdByName'] = workOrderEditApiData['createdByName'];
    editWorkOrderUpdateApiData['createdAt'] = workOrderEditApiData['createdAt'];
    editWorkOrderUpdateApiData['discrepancyType'] = workOrderEditApiData['discrepancyType'];
    editWorkOrderUpdateApiData['unitId'] = workOrderEditApiData['unitId'];
    editWorkOrderUpdateApiData['componentTypeIdSpecific'] = workOrderEditApiData['componentTypeIdSpecific'];
    editWorkOrderUpdateApiData['correctedBy'] = workOrderEditApiData['correctedBy'];
    editWorkOrderUpdateApiData['dateCorrected'] = workOrderEditApiData['dateCorrected'];
    editWorkOrderUpdateApiData['equipmentName'] = workOrderEditApiData['equipmentName'];
    editWorkOrderUpdateApiData['hobbsName'] = workOrderEditApiData['hobbsName'];
    editWorkOrderUpdateApiData['engine1TTName'] = workOrderEditApiData['engine1TTName'];
    editWorkOrderUpdateApiData['engine2TTName'] = workOrderEditApiData['engine2TTName'];
    editWorkOrderUpdateApiData['engine3TTName'] = workOrderEditApiData['engine3TTName'];
    editWorkOrderUpdateApiData['engine4TTName'] = workOrderEditApiData['engine4TTName'];
    editWorkOrderUpdateApiData['aircraftACTT'] = workOrderEditApiData['aircraftACTT'];
    editWorkOrderUpdateApiData['aircraftEngine1TT'] = workOrderEditApiData['aircraftEngine1TT'];
    editWorkOrderUpdateApiData['aircraftEngine2TT'] = workOrderEditApiData['aircraftEngine2TT'];
    editWorkOrderUpdateApiData['aircraftEngine3TT'] = workOrderEditApiData['aircraftEngine3TT'];
    editWorkOrderUpdateApiData['aircraftEngine4TT'] = workOrderEditApiData['aircraftEngine4TT'];
    editWorkOrderUpdateApiData['outsideComponentName'] = workOrderEditApiData['outsideComponentName'];
    editWorkOrderUpdateApiData['outsideComponentSerialNumber'] = workOrderEditApiData['outsideComponentSerialNumber'];
    editWorkOrderUpdateApiData['outsideComponentPartNumber'] = workOrderEditApiData['outsideComponentPartNumber'];
    editWorkOrderUpdateApiData['labelOutsideComponentSerialNumber'] = workOrderEditApiData['labelOutsideComponentSerialNumber'];
    editWorkOrderUpdateApiData['labelOutsideComponentPartNumber'] = workOrderEditApiData['labelOutsideComponentPartNumber'];
    editWorkOrderUpdateApiData['labelOutsideComponentName'] = workOrderEditApiData['labelOutsideComponentName'];
    editWorkOrderUpdateApiData['componentServiceLife1Type'] = workOrderEditApiData['componentServiceLife1Type'];
    editWorkOrderUpdateApiData['componentServiceLife2Type'] = workOrderEditApiData['componentServiceLife2Type'];
    editWorkOrderUpdateApiData['componentServiceLife1TypeName'] = workOrderEditApiData['componentServiceLife1TypeName'];
    editWorkOrderUpdateApiData['componentServiceLife1SinceNewAmt'] = workOrderEditApiData['componentServiceLife1SinceNewAmt'];
    editWorkOrderUpdateApiData['componentServiceLife1SinceOhAmt'] = workOrderEditApiData['componentServiceLife1SinceOhAmt'];
    editWorkOrderUpdateApiData['componentServiceLife2TypeName'] = workOrderEditApiData['componentServiceLife2TypeName'];
    editWorkOrderUpdateApiData['componentServiceLife2SinceNewAmt'] = workOrderEditApiData['componentServiceLife2SinceNewAmt'];
    editWorkOrderUpdateApiData['componentServiceLife2SinceOhAmt'] = workOrderEditApiData['componentServiceLife2SinceOhAmt'];
    editWorkOrderUpdateApiData['discrepancy'] = workOrderEditApiData['discrepancy'];
    editWorkOrderUpdateApiData['status'] = workOrderEditApiData['status'];
    editWorkOrderUpdateApiData['oldStatus'] = workOrderEditApiData['oldStatus'];
    editWorkOrderUpdateApiData['aCTTCompletedAt'] = workOrderEditApiData['aCTTCompletedAt'];
    editWorkOrderUpdateApiData['engine1TTCompletedAt'] = workOrderEditApiData['engine1TTCompletedAt'];
    editWorkOrderUpdateApiData['engine2TTCompletedAt'] = workOrderEditApiData['engine2TTCompletedAt'];
    editWorkOrderUpdateApiData['engine3TTCompletedAt'] = workOrderEditApiData['engine3TTCompletedAt'];
    editWorkOrderUpdateApiData['engine4TTCompletedAt'] = workOrderEditApiData['engine4TTCompletedAt'];
    editWorkOrderUpdateApiData['assignedTo'] = workOrderEditApiData['assignedTo'];
    editWorkOrderUpdateApiData['assignedToName'] = workOrderEditApiData['assignedToName'];
    editWorkOrderUpdateApiData['purchaseOrder'] = workOrderEditApiData['purchaseOrder'];
    editWorkOrderUpdateApiData['engine2Enabled'] = workOrderEditApiData['engine2Enabled'];
    editWorkOrderUpdateApiData['engine3Enabled'] = workOrderEditApiData['engine3Enabled'];
    editWorkOrderUpdateApiData['engine4Enabled'] = workOrderEditApiData['engine4Enabled'];
    editWorkOrderUpdateApiData['aTACode'] = workOrderEditApiData['ataCode'];
    editWorkOrderUpdateApiData['mCNCode'] = workOrderEditApiData['mcnCode'];
    editWorkOrderUpdateApiData['workorderNotes'] = workOrderEditApiData['workorderNotes'];
    editWorkOrderUpdateApiData['notes'] = workOrderEditApiData['notes'];
    editWorkOrderUpdateApiData['attachments'] = workOrderEditApiData['attachments'];
    editWorkOrderUpdateApiData['editMode'] = workOrderEditApiData['editMode'];
    editWorkOrderUpdateApiData['isStatusCompleted'] = workOrderEditApiData['isStatusCompleted'];
    editWorkOrderUpdateApiData['componentTypeName'] = workOrderEditApiData['componentTypeName'];
    editWorkOrderUpdateApiData['itemId'] = workOrderEditApiData['itemId'];
    editWorkOrderUpdateApiData['engineNumber'] = workOrderEditApiData['engineNumber'];
    editWorkOrderUpdateApiData['accessoryToolName'] = workOrderEditApiData['accessoryToolName'];
    editWorkOrderUpdateApiData['torqueEvents'] = workOrderEditApiData['torqueEvents'];
    editWorkOrderUpdateApiData['landings'] = workOrderEditApiData['landings'];
    editWorkOrderUpdateApiData['engine1Starts'] = workOrderEditApiData['engine1Starts'];
    editWorkOrderUpdateApiData['engine2Starts'] = workOrderEditApiData['engine2Starts'];
    editWorkOrderUpdateApiData['engine3Starts'] = workOrderEditApiData['engine3Starts'];
    editWorkOrderUpdateApiData['engine4Starts'] = workOrderEditApiData['engine4Starts'];
    editWorkOrderUpdateApiData['discoveredByLicenseNumber'] = workOrderEditApiData['discoveredByLicenseNumber'];
    editWorkOrderUpdateApiData['correctedByLicenseNumber'] = workOrderEditApiData['correctedByLicenseNumber'];
    editWorkOrderUpdateApiData['assignedTo2'] = workOrderEditApiData['assignedTo2'];
    editWorkOrderUpdateApiData['assignedTo3Name'] = workOrderEditApiData['assignedTo3Name'];
    editWorkOrderUpdateApiData['mel'] = workOrderEditApiData['mel'];
    editWorkOrderUpdateApiData['woNumber'] = workOrderEditApiData['woNumber'];
    editWorkOrderUpdateApiData['woCheckOut'] = workOrderEditApiData['woCheckOut'];
    editWorkOrderUpdateApiData['aircraftName'] = workOrderEditApiData['aircraftName'];
    editWorkOrderUpdateApiData['componentName'] = workOrderEditApiData['componentName'];
  }

  additionalInformationViewForLogicalDataOne() {
    if ((workOrderEditApiData['discrepancyType'] == 2) || (workOrderEditApiData['discrepancyType'] == 3)) {
      return true;
    }
    if ((workOrderEditApiData['discrepancyType'] == 4) || (workOrderEditApiData['discrepancyType'] == 5)) {
      return false;
    }
  }

  additionalInformationViewForLogicalDataTwo() {
    if ((workOrderEditApiData['discrepancyType'] == 2 && workOrderEditApiData['status'] == 'Completed') ||
        (workOrderEditApiData['discrepancyType'] == 3 && workOrderEditApiData['status'] == 'Completed')) {
      return true;
    }
    if ((workOrderEditApiData['discrepancyType'] == 2 && workOrderEditApiData['status'] != 'Completed') ||
        (workOrderEditApiData['discrepancyType'] == 3 && workOrderEditApiData['status'] != 'Completed')) {
      return false;
    }
    if ((workOrderEditApiData['discrepancyType'] == 4 && workOrderEditApiData['status'] == 'Completed') ||
        (workOrderEditApiData['discrepancyType'] == 5 && workOrderEditApiData['status'] == 'Completed')) {
      return true;
    }
    if ((workOrderEditApiData['discrepancyType'] == 4 && workOrderEditApiData['status'] != 'Completed') ||
        (workOrderEditApiData['discrepancyType'] == 5 && workOrderEditApiData['status'] != 'Completed')) {
      return false;
    }
  }

  ataDataViewAPICall() async {
    ataCodeData.clear();
    ataFieldExpand.clear();
    Response? ataCode = await DiscrepancyNewApiProvider().ataCodeData();
    if (ataCode?.statusCode == 200) {
      ataCodeData.addAll(ataCode?.data["data"]);
      for (int i = 0; i < ataCodeData["ataChapterData"].length; i++) {
        ataFieldExpand.add(false);
      }
      // await EasyLoading.dismiss();
    }
  }

  ataCodeDialogView({required String editView}) {
    if (editView == 'edit') {
      workOrderEditTextController.putIfAbsent('ataCode', () => TextEditingController());
    } else {
      workOrderEditTextController.putIfAbsent('ataCode', () => TextEditingController());
    }

    return showDialog(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text("ATA Code", textAlign: TextAlign.center, style: TextStyle(fontSize: 40))),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: ataCodeData["ataChapterData"].length,
                      shrinkWrap: true,
                      itemBuilder: (context, chapterItem) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                ataFieldExpand[chapterItem] = !ataFieldExpand[chapterItem];
                              },
                              child: Column(
                                children: [
                                  Text(
                                    ataCodeData["ataChapterData"][chapterItem]["chapterTitle"],
                                    style: const TextStyle(fontSize: 20, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    ataCodeData["ataChapterData"][chapterItem]["chapterDescription"],
                                    style: const TextStyle(fontSize: 14, letterSpacing: 0.8, fontWeight: FontWeight.w200),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              return ataFieldExpand[chapterItem] != false
                                  ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ataCodeData["ataChapterData"][chapterItem]["ataSectionData"].length,
                                itemBuilder: (context, sectionItem) {
                                  return InkWell(
                                    onTap: () {
                                      if (editView == 'edit') {
                                        workOrderEditTextController["ataCode"]!.text =
                                            ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                        editWorkOrderUpdateApiData["aTACode"] =
                                            ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                        Get.back();
                                      } else {
                                        workOrderEditTextController["ataCode"]!.text =
                                            ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                        createWorkOrderUpdateApiData["aTACode"] =
                                            ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                        Get.back();
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["sectionTitle"].toString(),
                                          style: const TextStyle(fontSize: 16, color: Colors.blue, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["sectionDescription"].toString(),
                                          style: const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                                  : const SizedBox();
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonConstant.dialogButton(
                        title: "Cancel",
                        borderColor: ColorConstants.grey,
                        onTapMethod: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(width: SizeConstants.contentSpacing + 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  loadCurrentValueForCompleteDiscrepancy({required String unitId}) async {
    Response? data = await WorkOrdersApiProvider().aircraftInfoApiCall(aircraftId: unitId);
    if (data!.statusCode == 200) {
      aircraftInfoData.clear();
      aircraftInfoData.addAll(data.data['data']);

      workOrderEditTextController.putIfAbsent('acttCompletedAt', () => TextEditingController());
      workOrderEditTextController['acttCompletedAt']?.text = aircraftInfoData['actt'].toString();

      workOrderEditTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController());
      workOrderEditTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController());
      workOrderEditTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController());
      workOrderEditTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController());

      workOrderEditTextController['engine1TTCompletedAt']?.text = aircraftInfoData['engine1TT'].toString();
      workOrderEditTextController['engine2TTCompletedAt']?.text = aircraftInfoData['engine2TT'].toString();
      workOrderEditTextController['engine3TTCompletedAt']?.text = aircraftInfoData['engine3TT'].toString();
      workOrderEditTextController['engine4TTCompletedAt']?.text = aircraftInfoData['engine4TT'].toString();

      editWorkOrderUpdateApiData['engine1TTCompletedAt'] = aircraftInfoData['engine1TT'].toString();
      editWorkOrderUpdateApiData['engine2TTCompletedAt'] = aircraftInfoData['engine2TT'].toString();
      editWorkOrderUpdateApiData['engine3TTCompletedAt'] = aircraftInfoData['engine3TT'].toString();
      editWorkOrderUpdateApiData['engine4TTCompletedAt'] = aircraftInfoData['engine4TT'].toString();

      workOrderEditApiData.update('engine2Enabled', (value) => aircraftInfoData['engine2Enabled']);
      workOrderEditApiData.update('engine3Enabled', (value) => aircraftInfoData['engine3Enabled']);
      workOrderEditApiData.update('engine4Enabled', (value) => aircraftInfoData['engine4Enabled']);
      await EasyLoading.dismiss();
    }
  }

  btnUpdateWorkOrderChangesApiCall({required int redirectOption}) async {
    editWorkOrderUpdateApiData['notes'] = newNotesList;

    workOrderEditValidationKeys['discoveredBy']?.currentState?.didChange(selectedWorkOrderDiscoveredDropdown['id']);

    bool validated = true;
    List<String> keyName = [];

    workOrderEditValidationKeys.forEach((key, value) {
      if (workOrderEditTextController.containsKey(key)) {
        value.currentState?.didChange(workOrderEditTextController[key]?.text);
      }
      value.currentState?.save();
      if (value.currentState?.validate() == false) {
        validated = false;
        keyName.add(key);
      }
    });

    if (validated) {
      if (editWorkOrderUpdateApiData['status'] == 'Completed' && editWorkOrderUpdateApiData['oldStatus'] != 'Completed') {
        await EasyLoading.dismiss();
        await electronicSignatureReformedDialogView(type: 'edit');
      } else {
        dataSaveApiCallForEditWorkOrder(redirectOption: redirectOption);
      }
    } else {
      await EasyLoading.dismiss();
      update();
      await SnackBarHelper.openSnackBar(isError: true, message: "Field is required!!!");
      Scrollable.ensureVisible(gKeyForEdit[keyName.last]!.currentContext!, duration: const Duration(milliseconds: 500));
    }
  }

  electronicSignatureReformedDialogView({required String type}) async {
    RxBool obscureTextShow = true.obs;
    TextEditingController textController = TextEditingController();
    GlobalKey<FormFieldState<dynamic>> validationKey = GlobalKey<FormFieldState>();

    return showDialog(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: AlertDialog(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Center(child: Text("Electronic Signature", style: Theme
                    .of(Get.context!)
                    .textTheme
                    .headlineLarge)),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text("By Clicking Below, You Are Certifying The Form Is Accurate & Complete."),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(child: Text("Name : ")),
                          Expanded(
                            flex: 2,
                            child: Text(
                              UserSessionInfo.userFullName,
                              style: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ColorConstants.black, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing * 2),
                      Row(
                        children: [
                          const Expanded(child: Text("Password :")),
                          Expanded(
                            flex: 2,
                            child: FormBuilderField(
                              name: "password",
                              key: validationKey,
                              validator: FormBuilderValidators.required(errorText: "Password is Required!"),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              builder: (FormFieldState<dynamic> field) {
                                return Obx(() {
                                  return TextField(
                                    controller: textController,
                                    cursorColor: Colors.black,
                                    style: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                    onChanged: (String? value) {
                                      if (value != "") {
                                        field.didChange(value);
                                      } else {
                                        field.reset();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium
                                          ?.fontSize)! - 6),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.red),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorText: field.errorText,
                                      suffixIcon: IconButton(
                                        splashRadius: 5,
                                        onPressed: () => obscureTextShow.value = !obscureTextShow.value,
                                        icon: Icon(size: 18, obscureTextShow.value ? Feather.eye : Feather.eye_off, color: ColorConstants.black.withValues(alpha: 0.5)),
                                      ),
                                    ),
                                    obscureText: obscureTextShow.value,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actionsOverflowAlignment: OverflowBarAlignment.end,
                actionsOverflowButtonSpacing: 10.0,
                actions: [
                  ButtonConstant.dialogButton(
                    title: "Cancel",
                    borderColor: ColorConstants.red,
                    onTapMethod: () {
                      Get.back();
                    },
                  ),
                  ButtonConstant.dialogButton(
                    title: "Confirm",
                    borderColor: ColorConstants.green,
                    onTapMethod: () async {
                      if (type == 'edit') {
                        Keyboard.close();
                        if (validationKey.currentState?.validate() ?? false) {
                          LoaderHelper.loaderWithGifAndText('Loading...');
                          await electronicSignatureApiCall(userPassword: textController.text, workOrderId: editWorkOrderUpdateApiData['workOrderId'].toString());
                        }
                      } else {
                        if (validationKey.currentState?.validate() ?? false) {
                          LoaderHelper.loaderWithGifAndText('Loading...');
                          await electronicSignatureValidatePasswordApiCall(empId: UserSessionInfo.userLoginId, userPassword: textController.text);
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  electronicSignatureApiCall({required String workOrderId, required String userPassword}) async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyDetailsForAirPerformSignatureApiCall(discrepancyId: workOrderId, userPassword: userPassword);
    if (data?.statusCode == 200) {
      Get.back(closeOverlays: true);
      await SnackBarHelper.openSnackBar(isError: false, message: 'Electronic Signature Recorded For AIR Performed (ID: ${data?.data['data']['discrepancyId']})');
      // await saveChanges();
    }
  }

  dataSaveApiCallForEditWorkOrder({required int redirectOption}) async {
    // Response? data = await DiscrepancyNewApiProvider().discrepancyEditSaveApiCallData(saveEditData: editDiscrepancyUpdateApiData);
    // await EasyLoading.dismiss();
    // if (data?.statusCode == 200) {
    //   String id = data?.data["data"]["discrepancyId"].toString() ?? "0";
    //   SnackBarHelper.openSnackBar(isError: false, message: data?.data["userMessage"]);
    //   if (data?.data["data"]["redirectToAction"] == "/discrepancies/details/") {
    //     Get.offNamedUntil(
    //       Routes.discrepancyDetailsNew,
    //       ModalRoute.withName(Routes.discrepancyIndex),
    //       arguments: id,
    //       parameters: {"discrepancyId": id, "routeForm": "discrepancyEdit"},
    //     );
    //   } else {
    //     Get.offNamed(Routes.fileUpload, arguments: "discrepancyAddAttachment", parameters: {"routes": id.toString()});
    //   }
    // }

    Response? data = await WorkOrdersApiProvider().postWorkOrdersEditUpdateApiData(workOrderUpdateApiData: editWorkOrderUpdateApiData);

    if (data?.statusCode == 200) {
      // String id = data?.data['data']['workOrderId'].toString() ?? '0';
      String input = data?.data['data'];
      String id = '';

      RegExp regExp = RegExp(r'ID:\s*(\d+)');
      Match? match = regExp.firstMatch(input);

      if (match != null) {
        id = match.group(1)!;
      }
      else {
        id = '0';
      }

      SnackBarHelper.openSnackBar(isError: false, message: data?.data['data']);

      if (redirectOption == 0) {
        Get.offNamedUntil(
          Routes.workOrderDiscrepancyDetails,
          ModalRoute.withName(Routes.workOrderIndex),
          arguments: id,
          parameters: {'workOrderId': id, 'routeForm': 'workOrderEdit'},
        );
      } else {
        // Get.toNamed(Routes.fileUpload,
        //     arguments: "workOrderAddAttachment", parameters: {"routes": 'workOrdersDetails', 'workOrderId': controller.workOrderDetailsApiData['workOrderId'].toString(), 'woNumber': Get.parameters['woNumber'].toString()});

        // Get.offNamed(Routes.fileUpload, arguments: "workOrderAddAttachmentUpdate", parameters: {"routes": 'workOrdersEdit', 'workOrderId': id, 'woNumber': ''});

        //---------FUTURE WORK----UPLOAD
        Get.offNamedUntil(
          Routes.workOrderDiscrepancyDetails,
          ModalRoute.withName(Routes.workOrderIndex),
          arguments: id,
          parameters: {'workOrderId': id, 'routeForm': 'workOrderEdit'},
        );
      }


      // if (data?.data['data']['redirectToAction'] == '/workOrders/details/') {
      //   Get.offNamedUntil(
      //     Routes.workOrderDetails,
      //     ModalRoute.withName(Routes.workOrderIndex),
      //     arguments: id,
      //     parameters: {'workOrderId': id, 'routeForm': 'workOrderEdit'},
      //   );
      // }
      // else {
      //   Get.offNamed(Routes.fileUpload, arguments: "workOrdersAddAttachment", parameters: {"routes": id.toString()});
      // }

    }
  }


  ///-----------------------Work Order Create All Function -------------------------------------------------

  commonApiCallForWorkOrderCreateDropdownData() async {
    for (int i = 0; i < workOrderTypeDropdownData.length; i++) {
      if (workOrderTypeDropdownData[i]['selected'] == true) {
        selectedWorkOrderTypeDropdown.addAll(workOrderTypeDropdownData[i]);
      }
    }

    //------Aircraft Data Api Call

    Response? aircraftData = await WorkOrdersApiProvider().workOrderAircraftDataApiCall(type: '0');

    if (aircraftData?.statusCode == 200) {
      aircraftDropdownData.clear();
      aircraftDropdownData.addAll(aircraftData?.data['data']['discrepancyTypeChangedEvent']['unit']);
      unitIdComponentOnAircraftDropdownData.addAll(aircraftData?.data['data']['discrepancyTypeChangedEvent']['unit']);
    }

    //------Accessory/Tools Data Api Call

    Response? accessoryToolsData = await WorkOrdersApiProvider().workOrderAircraftDataApiCall(type: '1');

    if (accessoryToolsData?.statusCode == 200) {
      unitIdAccessoryToolsDropdownData.clear();
      unitIdAccessoryToolsDropdownData.addAll(accessoryToolsData?.data['data']['discrepancyTypeChangedEvent']['accessoryTools']);
    }

    //------User List Api Call #Discovered By:

    Response? userList = await WorkOrdersApiProvider().workOrderRepopulateList(action: 'userList', itemName: '', itemId: '', groupId: '0');

    workOrderDiscoveredDropdownData.clear();

    if (userList?.statusCode == 200) {
      workOrderDiscoveredDropdownData.add({'id': '0', 'name': '-- Discovered By --'});
      workOrderDiscoveredDropdownData.addAll(userList?.data);
      dropdownDataSetForCreateView(
        dropdownData: workOrderDiscoveredDropdownData,
        selectMe: true,
        keyName: 'discoveredBySelectMe',
      );
    }

    Response? componentServiceLife = await WorkOrdersApiProvider().workOrderRepopulateList(action: 'ComponentServiceLife', itemName: '0', itemId: '0', groupId: '0');
    if (componentServiceLife?.statusCode == 200) {
      serviceLifeTypeOneDropdownData.add({'id': '0', 'name': '-- Select Service Life --'});
      serviceLifeTypeOneDropdownData.addAll(componentServiceLife?.data);

      serviceLifeTypeTwoDropdownData.add({'id': '0', 'name': '-- Select Service Life --'});
      serviceLifeTypeTwoDropdownData.addAll(componentServiceLife?.data);
    }

    Response? assignTo = await WorkOrdersApiProvider().workOrderRepopulateList(action: 'AssignTo', itemName: '0', itemId: '0', groupId: '0');

    if (assignTo?.statusCode == 200) {
      mechanicAssignedToOneDropdownData.add({'id': '0', 'name': '-- Not Assigned --'});
      mechanicAssignedToOneDropdownData.addAll(assignTo?.data);

      dropdownDataSetForCreateView(
        dropdownData: mechanicAssignedToOneDropdownData,
        selectMe: true,
        keyName: 'mechanicAssignedToOne',
      );


      mechanicAssignedToTwoDropdownData.add({'id': '0', 'name': '-- Not Assigned --'});
      mechanicAssignedToTwoDropdownData.addAll(assignTo?.data);
      dropdownDataSetForCreateView(
        dropdownData: mechanicAssignedToTwoDropdownData,
        selectMe: true,
        keyName: 'mechanicAssignedToTwo',
      );


      mechanicAssignedToThreeDropdownData.add({'id': '0', 'name': '-- Not Assigned --'});
      mechanicAssignedToThreeDropdownData.addAll(assignTo?.data);
      dropdownDataSetForCreateView(
        dropdownData: mechanicAssignedToThreeDropdownData,
        selectMe: true,
        keyName: 'mechanicAssignedToThree',
      );
    }

    workOrderCreateTextController.putIfAbsent('time', () => TextEditingController());

    selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTimeHelper.now)});

    //------Component Remove From Aircraft DropdownData

    Response? componentRemove = await WorkOrdersApiProvider().workOrderAircraftDataApiCall(type: '3');

    if (aircraftData?.statusCode == 200) {
      unitIdComponentRemoveOnAircraftDropdownData.clear();
      unitIdComponentRemoveOnAircraftDropdownData.addAll(componentRemove?.data['data']['discrepancyTypeChangedEvent']['componentTypeSpecific']);
    }
  }

  getAircraftInfoData({required String unitId}) async {
    aircraftInfoData.clear();

    Response? aircraftInfo = await WorkOrdersApiProvider().aircraftInfoApiCall(aircraftId: unitId);

    if (aircraftInfo?.statusCode == 200) {
      aircraftInfoData.addAll(aircraftInfo?.data['data']);

      workOrderCreateTextController.putIfAbsent('hobbs', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('landings', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('torqueEvents', () => TextEditingController());

      workOrderCreateTextController['hobbs']?.text = aircraftInfoData['actt'].toString();
      workOrderCreateTextController['landings']?.text = aircraftInfoData['landings'].toString();
      workOrderCreateTextController['torqueEvents']?.text = aircraftInfoData['torqueEvents'].toString();

      createWorkOrderUpdateApiData['hobbs'] = aircraftInfoData['actt'].toString();
      createWorkOrderUpdateApiData['landings'] = aircraftInfoData['landings'].toString();
      createWorkOrderUpdateApiData['torqueEvents'] = aircraftInfoData['torqueEvents'].toString();

      workOrderCreateTextController.putIfAbsent('engine1TT', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine2TT', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine3TT', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine4TT', () => TextEditingController());

      workOrderCreateTextController.putIfAbsent('engine1Starts', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine2Starts', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine3Starts', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine4Starts', () => TextEditingController());

      workOrderCreateTextController['engine1TT']?.text = aircraftInfoData['engine1TT'].toString();
      workOrderCreateTextController['engine2TT']?.text = aircraftInfoData['engine2TT'].toString();
      workOrderCreateTextController['engine3TT']?.text = aircraftInfoData['engine3TT'].toString();
      workOrderCreateTextController['engine4TT']?.text = aircraftInfoData['engine4TT'].toString();

      createWorkOrderUpdateApiData['engine1TT'] = aircraftInfoData['engine1TT'].toString();
      createWorkOrderUpdateApiData['engine2TT'] = aircraftInfoData['engine2TT'].toString();
      createWorkOrderUpdateApiData['engine3TT'] = aircraftInfoData['engine3TT'].toString();
      createWorkOrderUpdateApiData['engine4TT'] = aircraftInfoData['engine4TT'].toString();

      workOrderCreateTextController['engine1Starts']?.text = aircraftInfoData['engine1Starts'].toString();
      workOrderCreateTextController['engine2Starts']?.text = aircraftInfoData['engine2Starts'].toString();
      workOrderCreateTextController['engine3Starts']?.text = aircraftInfoData['engine3Starts'].toString();
      workOrderCreateTextController['engine4Starts']?.text = aircraftInfoData['engine4Starts'].toString();

      createWorkOrderShowHideField['additionalInformationField'] = true;
      createWorkOrderShowHideField['ataCodeView'] = true;

      update();

      await EasyLoading.dismiss();
    }
  }

  dropdownDataSetForCreateView({required List dropdownData, bool selectMe = false, String? keyName}) {
    for (int i = 0; i < dropdownData.length; i++) {
      if (selectMe) {
        if (dropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
          createWorkOrderShowHideField[keyName!] = true;
        }
      }
    }
  }

  apiCallForComponentTypeSpecificData() async {
    Response? data = await WorkOrdersApiProvider().workOrderComponentTypeSpecificDropdownDataApiCall(
        discrepancyType: selectedWorkOrderTypeDropdown['id'].toString(),
        aircraftUnitId: selectedUnitIdComponentOnAircraftDropdown['id'].toString()
    );

    if (data?.statusCode == 200) {
      componentTypeIdSpecificDropdownData.add({"id": "0", "name": "-- Selected Component Name --", "selected": true});
      componentTypeIdSpecificDropdownData.addAll(data?.data['data']['discrepancyTypeChangedEvent']['componentTypeSpecific']);
    }
  }


  apiCallForAircraftComponentNameDataItemChangeTwo({
    required String discrepancyType,
    required String unitId,
    required String itemChange,
    required String componentTypeIdSpecific,
  }) async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyComponentOnAircraftDropdownDataLoad(
      discrepancyType: discrepancyType,
      aircraftUnitId: unitId,
      itemChanged: itemChange,
      componentTypeIdSpecific: componentTypeIdSpecific,
    );
    if (data?.statusCode == 200) {
      workOrderCreateTextController.putIfAbsent('outsideComponentName', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController());

      workOrderCreateTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController());

      workOrderCreateTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());


      workOrderCreateTextController['outsideComponentName']?.text = data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['outsideComponentName'];
      workOrderCreateTextController['outsideComponentPartNumber']?.text =
      data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['outsideComponentPartNumber'];
      workOrderCreateTextController['outsideComponentSerialNumber']?.text =
      data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['outsideComponentSerialNumber'];

      workOrderCreateTextController['componentServiceLife1SinceNewAmt']?.text =
          data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['componentNewAmt'].toString() ?? '';
      workOrderCreateTextController['componentServiceLife1SinceOhAmt']?.text =
          data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['componentOhAmt'].toString() ?? '';

      workOrderCreateTextController['componentServiceLife2SinceNewAmt']?.text = '';
      workOrderCreateTextController['componentServiceLife2SinceOhAmt']?.text = '';

      createWorkOrderUpdateApiData['outsideComponentName'] = data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['outsideComponentName'];
      createWorkOrderUpdateApiData['outsideComponentPartNumber'] =
      data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['outsideComponentPartNumber'];
      createWorkOrderUpdateApiData['outsideComponentSerialNumber'] =
      data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['outsideComponentSerialNumber'];

      createWorkOrderUpdateApiData['componentServiceLife1SinceNewAmt'] =
          data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['componentNewAmt'].toString() ?? '';
      createWorkOrderUpdateApiData['componentServiceLife1SinceOhAmt'] =
          data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['componentOhAmt'].toString() ?? '';

      createWorkOrderUpdateApiData['componentServiceLife2SinceNewAmt'] = '';
      createWorkOrderUpdateApiData['componentServiceLife2SinceOhAmt'] = '';

      for (int i = 0; i < serviceLifeTypeOneDropdownData.length; i++) {
        if (serviceLifeTypeOneDropdownData[i]['name'] == data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent'][0]['componentServiceLifeName']) {
          selectedServiceLifeTypeOneDropdown.addAll(serviceLifeTypeOneDropdownData[i]);
          createWorkOrderUpdateApiData['componentServiceLife1Type'] = int.parse(selectedServiceLifeTypeOneDropdown['id'].toString());
          break;
        }
      }

      createWorkOrderShowHideField['additionalInformationField'] = true;
      update();
      await EasyLoading.dismiss();
    }
  }

  loadCurrentValueForCompleteCreateWorkOrder({required String unitId}) async {
    Response? data = await WorkOrdersApiProvider().aircraftInfoApiCall(aircraftId: unitId);
    if (data!.statusCode == 200) {
      aircraftInfoData.clear();
      aircraftInfoData.addAll(data.data['data']);

      workOrderEditTextController.putIfAbsent('aCTTCompletedAt', () => TextEditingController());
      workOrderEditTextController['aCTTCompletedAt']?.text = aircraftInfoData['actt'].toString();

      workOrderCreateTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController());
      workOrderCreateTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController());

      workOrderCreateTextController['engine1TTCompletedAt']?.text = aircraftInfoData['engine1TT'].toString();
      workOrderCreateTextController['engine2TTCompletedAt']?.text = aircraftInfoData['engine2TT'].toString();
      workOrderCreateTextController['engine3TTCompletedAt']?.text = aircraftInfoData['engine3TT'].toString();
      workOrderCreateTextController['engine4TTCompletedAt']?.text = aircraftInfoData['engine4TT'].toString();

      createWorkOrderUpdateApiData['engine1TTCompletedAt'] = aircraftInfoData['engine1TT'].toString();
      createWorkOrderUpdateApiData['engine2TTCompletedAt'] = aircraftInfoData['engine2TT'].toString();
      createWorkOrderUpdateApiData['engine3TTCompletedAt'] = aircraftInfoData['engine3TT'].toString();
      createWorkOrderUpdateApiData['engine4TTCompletedAt'] = aircraftInfoData['engine4TT'].toString();
      update();
      await EasyLoading.dismiss();
    }
  }

  createWorkOrderDataBindWithFinalCondition() {
    switch (createWorkOrderUpdateApiData['discrepancyType']) {
      case 0:
        createWorkOrderUpdateApiData['outsideComponentName'] = '';
        createWorkOrderUpdateApiData['outsideComponentPartNumber'] = '';
        createWorkOrderUpdateApiData['outsideComponentSerialNumber'] = '';

        createWorkOrderUpdateApiData['componentServiceLife1Type'] = 0;
        createWorkOrderUpdateApiData['componentServiceLife2Type'] = 0;


        createWorkOrderUpdateApiData['componentServiceLife1SinceNewAmt'] = '0.0';
        createWorkOrderUpdateApiData['componentServiceLife2SinceNewAmt'] = '0.0';

        createWorkOrderUpdateApiData['componentServiceLife1SinceOhAmt'] = '0.0';
        createWorkOrderUpdateApiData['componentServiceLife2SinceOhAmt'] = '0.0';

        createWorkOrderUpdateApiData['IsAircraft'] = 1;

        break;

      case 1:
        createWorkOrderUpdateApiData['cutsideComponentName'] = '';
        createWorkOrderUpdateApiData['cutsideComponentPartNumber'] = '';
        createWorkOrderUpdateApiData['cutsideComponentSerialNumber'] = '';

        createWorkOrderUpdateApiData['componentServiceLife1Type'] = 0;

        createWorkOrderUpdateApiData['componentServiceLife2Type'] = 0;

        createWorkOrderUpdateApiData['componentServiceLife1SinceNewAmt'] = '0.0';
        createWorkOrderUpdateApiData['componentServiceLife2SinceNewAmt'] = '0.0';

        createWorkOrderUpdateApiData['componentServiceLife1SinceOhAmt'] = '0.0';
        createWorkOrderUpdateApiData['componentServiceLife2SinceOhAmt'] = '0.0';

        createWorkOrderUpdateApiData["hobbs"] = "0.0";
        createWorkOrderUpdateApiData["landings"] = "0";
        createWorkOrderUpdateApiData["torqueEvents"] = "0";

        createWorkOrderUpdateApiData["engine1TT"] = "0.0";
        createWorkOrderUpdateApiData["engine2TT"] = "0.0";
        createWorkOrderUpdateApiData["engine3TT"] = "0.0";
        createWorkOrderUpdateApiData["engine4TT"] = "0.0";

        createWorkOrderUpdateApiData["engine1Starts"] = "0.0";
        createWorkOrderUpdateApiData["engine2Starts"] = "0.0";
        createWorkOrderUpdateApiData["engine3Starts"] = "0.0";
        createWorkOrderUpdateApiData["engine4Starts"] = "0.0";

        createWorkOrderUpdateApiData["aTACode"] = "";
        createWorkOrderUpdateApiData["mCNCode"] = "";

        break;

      case 2 || 3 || 4 || 5:
      //------true
        createWorkOrderUpdateApiData["hobbs"] = "0.0";
        createWorkOrderUpdateApiData["landings"] = "0";
        createWorkOrderUpdateApiData["torqueEvents"] = "0";

        createWorkOrderUpdateApiData["engine1TT"] = "0.0";
        createWorkOrderUpdateApiData["engine2TT"] = "0.0";
        createWorkOrderUpdateApiData["engine3TT"] = "0.0";
        createWorkOrderUpdateApiData["engine4TT"] = "0.0";

        createWorkOrderUpdateApiData["engine1Starts"] = "0.0";
        createWorkOrderUpdateApiData["engine2Starts"] = "0.0";
        createWorkOrderUpdateApiData["engine3Starts"] = "0.0";
        createWorkOrderUpdateApiData["engine4Starts"] = "0.0";

        createWorkOrderUpdateApiData["aTACode"] = "";
        createWorkOrderUpdateApiData["mCNCode"] = "";

        break;
    }
  }

  dataValidationCondition({required int redirectOption}) async {


    workOrderCreateValidationKeys['workOrderType']?.currentState?.didChange(createWorkOrderUpdateApiData['discrepancyType']);
    workOrderCreateValidationKeys['discoveredBy']?.currentState?.didChange(selectedWorkOrderDiscoveredDropdown['id'].toString());

    bool validated = true;
    List<String> keyName = [];
    workOrderCreateValidationKeys.forEach((key, value) {
      if (workOrderCreateTextController.containsKey(key)) {
        value.currentState?.didChange(workOrderCreateTextController[key]?.text);
      }
      value.currentState?.save();
      if (value.currentState?.validate() == false) {
        validated = false;
        keyName.add(key);
      }
    });
    if (validated) {
      if (createWorkOrderUpdateApiData['status'] == 'Completed') {
        await EasyLoading.dismiss();
        await electronicSignatureReformedDialogView(type: 'create');
      } else {
        dataSaveApiCallForCreateWorkOrder(redirectOption: redirectOption);
      }
    } else {
      await EasyLoading.dismiss();
      update();
      await SnackBarHelper.openSnackBar(isError: true, message: "Field is required!!!");
      Scrollable.ensureVisible(gKeyForCreate[keyName.last]!.currentContext!, duration: const Duration(milliseconds: 500));
    }
  }

  dataSaveApiCallForCreateWorkOrder({required int redirectOption}) async {
    // Response data = await DiscrepancyNewApiProvider().discrepancyCreateSaveApiCall(createDiscrepancyData: createDiscrepancyUpdateApiData);
    //
    // if (data.statusCode == 200) {
    //   await SnackBarHelper.openSnackBar(isError: false, message: "Create Discrepancy ${data.data["data"]["discrepancyId"]} SuccessFully");
    //   await Get.offNamed(
    //     Routes.discrepancyDetailsNew,
    //     arguments: data.data["data"]["discrepancyId"].toString(),
    //     parameters: {"discrepancyId": data.data["data"]["discrepancyId"].toString(), "routeForm": "discrepancyNewCreate"},
    //   );
    // } else {
    //   EasyLoading.dismiss();
    //   Get.offNamed(Routes.discrepancyIndex);
    // }

    Response? createData = await WorkOrdersApiProvider().postWorkOrdersCreateUpdateApiData(workOrderCreateApiData: createWorkOrderUpdateApiData);

    if(createData!.statusCode == 200) {
      await SnackBarHelper.openSnackBar(isError: false, message: "Create Work Order ${createData.data['data']['save']} SuccessFully");
      await Get.offNamed(
        Routes.workOrderDiscrepancyDetails,
        arguments: createData.data['data']['save'].toString(),
        parameters: {"workOrderId": createData.data['data']['save'].toString(), "woNumber": createData.data['data']['workOrderJobId'].toString(), "routeForm": "workOrderCreate"},
      );
    }

  }


  electronicSignatureValidatePasswordApiCall({required String empId, required String userPassword}) async {
    // Response? signatureDataOne = await DiscrepancyNewApiProvider().discrepancyCreateElectronicSignatureValidateUserPassword(empId: empId, userPassword: userPassword);
    // if (signatureDataOne?.statusCode == 200) {
    //   Get.back(closeOverlays: true);
    //   Response? signatureDataTwo = await DiscrepancyNewApiProvider().discrepancyCreateSaveApiCall(createDiscrepancyData: createDiscrepancyUpdateApiData);
    //   if (signatureDataTwo?.statusCode == 200) {
    //     Response? finalSignatureData = await DiscrepancyNewApiProvider().discrepancyDetailsForAirPerformSignatureApiCall(
    //       discrepancyId: signatureDataTwo?.data["data"]["discrepancyId"].toString() ?? '',
    //       userPassword: userPassword,
    //     );
    //     if (finalSignatureData?.statusCode == 200) {
    //       await SnackBarHelper.openSnackBar(isError: false, message: "Create Discrepancy ${signatureDataTwo?.data["data"]["discrepancyId"]} SuccessFully");
    //       await Get.offNamed(
    //         Routes.discrepancyDetailsNew,
    //         arguments: signatureDataTwo?.data["data"]["discrepancyId"].toString(),
    //         parameters: {"discrepancyId": signatureDataTwo?.data["data"]["discrepancyId"].toString() ?? '', "routeForm": "discrepancyNewCreate"},
    //       );
    //     }
    //   } else {
    //     EasyLoading.dismiss();
    //     Get.offNamed(Routes.discrepancyIndex);
    //   }
    // } else {
    //   Get.back(closeOverlays: true);
    //   EasyLoading.dismiss();
    // }
  }


}
