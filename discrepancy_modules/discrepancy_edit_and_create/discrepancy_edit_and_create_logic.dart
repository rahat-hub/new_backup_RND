import 'dart:ui';

import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
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

import '../../../provider/discrepancy_api_provider.dart';
import '../../../widgets/buttons.dart';

class DiscrepancyEditAndCreateLogic extends GetxController {
  RxBool isLoading = false.obs;

  Map<String, GlobalKey> gKeyForCreate = <String, GlobalKey>{};
  Map<String, GlobalKey> gKeyForEdit = <String, GlobalKey>{};

  RxMap<String, dynamic> discrepancyEditApiData = <String, dynamic>{}.obs;

  Map<String, String> normalTileString = <String, String>{};

  Map<String, GlobalKey<FormFieldState>> discrepancyEditValidationKeys = <String, GlobalKey<FormFieldState>>{};

  Map<String, GlobalKey<FormFieldState>> discrepancyCreateValidationKeys = <String, GlobalKey<FormFieldState>>{};

  RxMap<String, TextEditingController> discrepancyEditTextController = <String, TextEditingController>{}.obs;

  RxMap<String, TextEditingController> discrepancyCreateTextController = <String, TextEditingController>{}.obs;

  RxList serviceLifeTypeOneDropdownData = [].obs;
  RxMap selectedServiceLifeTypeOneDropdown = {}.obs;

  RxList serviceLifeTypeTwoDropdownData = [].obs;
  RxMap selectedServiceLifeTypeTwoDropdown = {}.obs;

  RxList discoveredByDropdownData = [].obs;
  RxMap selectedDiscoveredByDropdown = {}.obs;

  RxList statusDropdownData = [].obs;
  RxMap selectedStatusDropdown = {}.obs;

  RxList mechanicAssignedToOneDropdownData = [].obs;
  RxMap selectedMechanicAssignedToOneDropdown = {}.obs;

  RxList mechanicAssignedToTwoDropdownData = [].obs;
  RxMap selectedMechanicAssignedToTwoDropdown = {}.obs;

  RxList mechanicAssignedToThreeDropdownData = [].obs;
  RxMap selectedMechanicAssignedToThreeDropdown = {}.obs;

  RxList scheduledMaintenanceDropdownData = [].obs;
  RxMap selectedScheduledMaintenanceDropdown = {}.obs;

  RxList melDropdownData = [].obs;
  RxMap selectedMelDropdown = {}.obs;

  RxList systemAffectedDropDownData = [].obs;
  RxMap selectedSystemAffectedDropdown = {}.obs;

  RxList functionalGroupDropDownData = [].obs;
  RxMap selectedFunctionalGroupDropdown = {}.obs;

  RxList malFunctionEffectDropDownData = [].obs;
  RxMap selectedMalFunctionEffectDropdown = {}.obs;

  RxList whenDiscoveredDropDownData = [].obs;
  RxMap selectedWhenDiscoveredDropdown = {}.obs;

  RxList howRecognizedDropDownData = [].obs;
  RxMap selectedHowRecognizedDropdown = {}.obs;

  RxList missionFlightTypeDropDownData = [].obs;
  RxMap selectedMissionFlightTypeDropdown = {}.obs;

  RxList associatedWorkOrderDropdownData = [].obs;
  RxMap selectedAssociatedWorkOrderDropdown = {}.obs;

  Map<String, dynamic> editDiscrepancyUpdateApiData = <String, dynamic>{
    'UserId': UserSessionInfo.userId,
    'DiscrepancyId': 0,
    'SystemId': UserSessionInfo.systemId,
    'DiscoveredBy': 0,
    'DiscrepancyType': 0,
    'UnitId': 0,
    'ComponentTypeIdSpecific': 0,
    'CorrectedBy': 0,
    'DiscoveredByName': '',
    'CreatedAt': '1900-01-01T00:00:00',
    'CorrectedByName': '',
    'DateCorrected': '1900-01-01T00:00:00',
    'EquipmentName': '',
    'HobbsName': '0.0',
    'TorqueEvents': '0',
    'Landings': '0',
    'OtherHobbs': '0',
    'MaintenanceHobbs': '0',
    'Engine1TTName': '0.0',
    'Engine2TTName': '0.0',
    'Engine3TTName': '0.0',
    'Engine4TTName': '0.0',
    'Starts_Ng_N1_ICY_IMP1': '0.0',
    'Starts_Ng_N1_ICY_IMP2': '0.0',
    'Starts_Ng_N1_ICY_IMP3': '0.0',
    'Starts_Ng_N1_ICY_IMP4': '0.0',
    'NP_N2_PCY_PT1': '0.0',
    'NP_N2_PCY_PT2': '0.0',
    'NP_N2_PCY_PT3': '0.0',
    'NP_N2_PCY_PT4': '0.0',
    'CT1': '0',
    'CT2': '0',
    'CT3': '0',
    'CT4': '0',
    'CYCLES1': '0',
    'CYCLES2': '0',
    'CYCLES3': '0',
    'CYCLES4': '0',
    'ClientPO': '',
    'AircraftACTT': '',
    'AircraftEngine1TT': '',
    'AircraftEngine2TT': '',
    'AircraftEngine3TT': '',
    'AircraftEngine4TT': '',
    'OutsideComponentName': '',
    'OutsideComponentSerialNumber': '',
    'OutsideComponentPartNumber': '',
    'LabelOutsideComponentSerialNumber': '',
    'LabelOutsideComponentPartNumber': '',
    'LabelOutsideComponentName': '',
    'ComponentServiceLife1Type': 0,
    'ComponentServiceLife2Type': 0,
    'ComponentServiceLife1TypeName': '',
    'ComponentServiceLife1SinceNewAmt': '0.0',
    'ComponentServiceLife1SinceOhAmt': '0.0',
    'ComponentServiceLife2TypeName': '',
    'ComponentServiceLife2SinceNewAmt': '0.0',
    'ComponentServiceLife2SinceOhAmt': '0.0',
    'CorrectiveAction': '',
    'Discrepancy': '',
    'Status': '',
    'OldStatus': '',
    'ACTTCompletedAt': '0.0',
    'Engine1TTCompletedAt': '0.0',
    'Engine2TTCompletedAt': '0.0',
    'Engine3TTCompletedAt': '0.0',
    'Engine4TTCompletedAt': '0.0',
    'AssignedToName': '',
    'PurchaseOrder': '',
    'WorkOrder': '',
    'OldMel': 0,
    'Mel': 0,
    'AssignedTo': 0,
    'AssignedTo2': 0,
    'AssignedTo3': 0,
    'AssignedTo4': 0,
    'ATACode': '',
    'ATAMCNCode': '',
    'MCNCode': '',
    'DiscrepancyNotes': '',
    'NewNote': '',
    'Notes': [],
    'Attachments': [],
    'ObjLogBookDiscrepanciesDataList': [],
    'Engine2Enabled': false,
    'Engine3Enabled': false,
    'Engine4Enabled': false,
    'EditMode': false,
    'MyProperty': false,
    'AllowRating': false,
    'IsMel': false,
    'IsStatusCompleted': false,
    'IsSignAIRPerformed': false,
    'WoCheckOut': false,
    'CheckFlightRequired': false,
    'CheckGroundRunRequired': false,
    'LeakTestRequired': false,
    'AdditionalInspectionRequired': false,
    'IsWorkOrder': false,
    'AIRPerformedById': 0,
    'AIRPerformedByName': '',
    'AIRPerformedAt': '1900-01-01T00:00:00',
    'WoNumber': 0,
    'IsAircraft': 0,
    'UsersToNotify': '',
    'ComponentTypeName': '',
    'ItemId': 0,
    'EngineNumber': 0,
    'AccessoryToolName': '',
    'ScheduleMtnc': 0,
    'Engine1Starts': 0.0,
    'Engine2Starts': 0.0,
    'Engine3Starts': 0.0,
    'Engine4Starts': 0.0,
    'DiscoveredByLicenseNumber': '',
    'CorrectedByLicenseNumber': '',
    'MechanicAssignedTo1': '',
    'MechanicAssignedTo2': '',
    'MechanicAssignedTo3': '',
    'Created_At': '',
    'SystemAffected': '',
    'WhenDiscovered': '',
    'MalfunctionEffect': '',
    'FunctionalGroup': '',
    'HowRecognized': '',
    'MissionFlightType': '',
    'SystemAffectedName': '',
    'WhenDiscoveredName': '',
    'MalfunctionEffectName': '',
    'FunctionalGroupName': '',
    'HowRecognizedName': '',
    'MissionFlightTypeName': '',
    'Discrepancy_Type': '',
    'RedirectOption': '0',
    'DateTimeNow': '0001-01-01T00:00:00',
    'AircraftName': '',
    'ComponentName': '',
  };

  //::::::TODO: OLD DATA Type

  // 'UserId': UserSessionInfo.userId,
  // 'DiscrepancyId': 0,
  // 'SystemId': UserSessionInfo.systemId,
  // 'DiscoveredBy': null,
  // 'DiscoveredByName': null,
  // 'CreatedAt': DateFormat('MM/dd/yyyy hh:mm:ss a').format(DateTimeHelper.now).toString(),
  // 'DiscrepancyType': 0,
  // 'UnitId': 0,
  // 'ComponentTypeIdSpecific': 0,
  // 'CorrectedBy': "0",
  // 'CorrectedByName': null,
  // 'DateCorrected': "1900-01-01T00:00:00",
  // 'EquipmentName': "",
  // 'HobbsName': "0.00",
  // 'TorqueEvents': "0",
  // 'Landings': "0",
  // 'OtherHobbs': "0",
  // 'MaintenanceHobbs': "0",
  // 'Engine1TTName': "0.00",
  // 'Engine2TTName': "0.00",
  // 'Engine3TTName': "0.00",
  // 'Engine4TTName': "0.00",
  // 'Starts_Ng_N1_ICY_IMP1': "0.0",
  // 'Starts_Ng_N1_ICY_IMP2': "0.0",
  // 'Starts_Ng_N1_ICY_IMP3': "0.0",
  // 'Starts_Ng_N1_ICY_IMP4': "0.0",
  // 'NP_N2_PCY_PT1': "0.0",
  // 'NP_N2_PCY_PT2': "0.0",
  // 'NP_N2_PCY_PT3': "0.0",
  // 'NP_N2_PCY_PT4': "0.0",
  // 'CT1': "0",
  // 'CT2': "0",
  // 'CT3': "0",
  // 'CT4': "0",
  // 'CYCLES1': "0",
  // 'CYCLES2': "0",
  // 'CYCLES3': "0",
  // 'CYCLES4': "0",
  // 'ClientPO': null,
  // 'AircraftACTT': null,
  // 'AircraftEngine1TT': null,
  // 'AircraftEngine2TT': null,
  // 'AircraftEngine3TT': null,
  // 'AircraftEngine4TT': null,
  // 'OutsideComponentName': "",
  // 'OutsideComponentSerialNumber': "",
  // 'OutsideComponentPartNumber': "",
  // 'LabelOutsideComponentSerialNumber': null,
  // 'LabelOutsideComponentPartNumber': null,
  // 'LabelOutsideComponentName': null,
  // 'ComponentServiceLife1Type': 0,
  // 'ComponentServiceLife2Type': 0,
  // 'ComponentServiceLife1TypeName': null,
  // 'ComponentServiceLife1SinceNewAmt': "0.0",
  // 'ComponentServiceLife1SinceOhAmt': "0.0",
  // 'ComponentServiceLife2TypeName': null,
  // 'ComponentServiceLife2SinceNewAmt': "0.0",
  // 'ComponentServiceLife2SinceOhAmt': "0.0",
  // 'CorrectiveAction': "",
  // 'Discrepancy': "",
  // 'Status': "",
  // 'OldStatus': null,
  // 'ACTTCompletedAt': "",
  // 'Engine1TTCompletedAt': "0.0",
  // 'Engine2TTCompletedAt': "0.0",
  // 'Engine3TTCompletedAt': "0.0",
  // 'Engine4TTCompletedAt': "0.0",
  // 'AssignedTo': 0,
  // 'AssignedTo2': 0,
  // 'AssignedTo3': 0,
  // 'AssignedTo4': 0,
  // 'AssignedToName': null,
  // 'PurchaseOrder': "",
  // 'Engine2Enabled': false,
  // 'Engine3Enabled': false,
  // 'Engine4Enabled': false,
  // 'ATACode': "",
  // 'ATAMCNCode': "",
  // 'MCNCode': "",
  // 'DiscrepancyNotes': null,
  // 'Notes': [],
  // 'NewNote': "",
  // 'Attachments': [],
  // 'ObjLogBookDiscrepanciesDataList': [],
  // 'EditMode': false,
  // 'IsStatusCompleted': false,
  // 'Mel': 0,
  // 'OldMel': 0,
  // 'WorkOrder': "False",
  // 'CheckFlightRequired': false,
  // 'CheckGroundRunRequired': false,
  // 'LeakTestRequired': false,
  // 'AdditionalInspectionRequired': false,
  // 'AIRPerformedById': 0,
  // 'AIRPerformedByName': null,
  // 'AIRPerformedAt': "1900-01-01T00:00:00",
  // 'IsWorkOrder': false,
  // 'IsAircraft': 1,
  // 'UsersToNotify': "",
  // 'ComponentTypeName': null,
  // 'ItemId': 0,
  // 'EngineNumber': 0,
  // 'AccessoryToolName': null,
  // 'ScheduleMtnc': 0,
  // 'Engine1Starts': 0.0,
  // 'Engine2Starts': 0.0,
  // 'Engine3Starts': 0.0,
  // 'Engine4Starts': 0.0,
  // 'DiscoveredByLicenseNumber': "",
  // 'CorrectedByLicenseNumber': "",
  // 'WoCheckOut': false,
  // 'WoNumber': 0,
  // 'MechanicAssignedTo1': null,
  // 'MechanicAssignedTo2': null,
  // 'MechanicAssignedTo3': null,
  // 'MyProperty': false,
  // 'AllowRating': true,
  // 'IsMel': false,
  // 'Created_At': null,
  // 'SystemAffected': "",
  // 'WhenDiscovered': "",
  // 'MalfunctionEffect': "",
  // 'FunctionalGroup': "",
  // 'HowRecognized': "",
  // 'MissionFlightType': "",
  // 'SystemAffectedName': null,
  // 'WhenDiscoveredName': null,
  // 'MalfunctionEffectName': null,
  // 'FunctionalGroupName': null,
  // 'HowRecognizedName': null,
  // 'MissionFlightTypeName': null,
  // 'IsSignAIRPerformed': false,
  // 'Discrepancy_Type': null,
  // 'RedirectOption': "0"

  RxBool disableKeyboard = true.obs;

  RxList timeDropDownData =
      [
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

  RxList<bool> ataFieldExpand = <bool>[].obs;
  RxMap ataCodeData = {}.obs;

  RxList userDropDownList = [].obs;
  RxList<bool> checkBox = <bool>[].obs;
  RxBool checkboxSelectAllUser = false.obs;
  RxList selectedUsersDropdownList = [].obs;

  String editClass = '';
  String editableClass = '';
  String editingClass = '';

  RxList discrepancyTypeDropdownData = [].obs;
  RxMap selectedDiscrepancyTypeDropdown = {}.obs;

  RxList unitIdAircraftDropdownData = [].obs;
  RxMap selectedUnitIdAircraftDropdown = {}.obs;

  RxList unitIdAccessoryToolsDropdownData = [].obs;
  RxMap selectedUnitIdAccessoryToolsDropdown = {}.obs;

  RxInt unitId = 0.obs;

  RxList unitIdComponentOnAircraftDropdownData = [].obs;
  RxMap selectedUnitIdComponentOnAircraftDropdown = {}.obs;

  RxList unitIdComponentRemoveOnAircraftDropdownData = [].obs;
  RxMap selectedUnitIdComponentRemoveOnAircraftDropdown = {}.obs;

  RxList componentTypeIdSpecificDropdownData = [].obs;
  RxMap selectedComponentTypeIdSpecificDropdown = {}.obs;

  RxMap aircraftInfoData = {}.obs;

  RxList workOrderComponentData = [].obs;

  Map<String, dynamic> createDiscrepancyUpdateApiData = {
    "UserId": UserSessionInfo.userId,
    "DiscrepancyId": 0,
    "SystemId": UserSessionInfo.systemId,
    "DiscoveredBy": 0,
    "DiscoveredByName": '',
    "CreatedAt": DateFormat('yyyy-MM-ddTHH:mm').format(DateTimeHelper.now).toString(),
    "DiscrepancyType": 0,
    "UnitId": 0,
    "ComponentTypeIdSpecific": 0,
    "CorrectedBy": 0,
    "CorrectedByName": null,
    "DateCorrected": "1900-01-01T00:00:00",
    "EquipmentName": null,
    "HobbsName": "",
    "TorqueEvents": "",
    "Landings": "",
    "OtherHobbs": "0",
    "MaintenanceHobbs": "0",
    "Engine1TTName": "",
    "Engine2TTName": "0",
    "Engine3TTName": "0",
    "Engine4TTName": "0",
    "Starts_Ng_N1_ICY_IMP1": "0.0",
    "Starts_Ng_N1_ICY_IMP2": "0.0",
    "Starts_Ng_N1_ICY_IMP3": "0.0",
    "Starts_Ng_N1_ICY_IMP4": "0.0",
    "NP_N2_PCY_PT1": "0.0",
    "NP_N2_PCY_PT2": "0.0",
    "NP_N2_PCY_PT3": "0.0",
    "NP_N2_PCY_PT4": "0.0",
    "CT1": "0",
    "CT2": "0",
    "CT3": "0",
    "CT4": "0",
    "CYCLES1": "0",
    "CYCLES2": "0",
    "CYCLES3": "0",
    "CYCLES4": "0",
    "ClientPO": null,
    "AircraftACTT": null,
    "AircraftEngine1TT": null,
    "AircraftEngine2TT": null,
    "AircraftEngine3TT": null,
    "AircraftEngine4TT": null,
    "OutsideComponentName": "",
    "OutsideComponentSerialNumber": "",
    "OutsideComponentPartNumber": "",
    "LabelOutsideComponentSerialNumber": null,
    "LabelOutsideComponentPartNumber": null,
    "LabelOutsideComponentName": null,
    "ComponentServiceLife1Type": 0,
    "ComponentServiceLife2Type": 0,
    "ComponentServiceLife1TypeName": null,
    "ComponentServiceLife1SinceNewAmt": "0.0",
    "ComponentServiceLife1SinceOhAmt": "0.0",
    "ComponentServiceLife2TypeName": null,
    "ComponentServiceLife2SinceNewAmt": "0.0",
    "ComponentServiceLife2SinceOhAmt": "0.0",
    "CorrectiveAction": "",
    "Discrepancy": "",
    "Status": "AOG",
    "OldStatus": null,
    "ACTTCompletedAt": "",
    "Engine1TTCompletedAt": "0.0",
    "Engine2TTCompletedAt": "0.0",
    "Engine3TTCompletedAt": "0.0",
    "Engine4TTCompletedAt": "0.0",
    "AssignedTo": 0,
    "AssignedTo2": 0,
    "AssignedTo3": 0,
    "AssignedTo4": 0,
    "AssignedToName": null,
    "PurchaseOrder": "0",
    "Engine2Enabled": false,
    "Engine3Enabled": false,
    "Engine4Enabled": false,
    "ATACode": "",
    "ATAMCNCode": "",
    "MCNCode": "",
    "DiscrepancyNotes": null,
    "Notes": [],
    "NewNote": "",
    "Attachments": [],
    "ObjLogBookDiscrepanciesDataList": [],
    "EditMode": false,
    "IsStatusCompleted": false,
    "Mel": 0,
    "OldMel": 0,
    "WorkOrder": "False",
    "CheckFlightRequired": false,
    "CheckGroundRunRequired": false,
    "LeakTestRequired": false,
    "AdditionalInspectionRequired": false,
    "AIRPerformedById": 0,
    "AIRPerformedByName": null,
    "AIRPerformedAt": "1900-01-01T00:00:00",
    "IsWorkOrder": false,
    "IsAircraft": 0,
    "UsersToNotify": "",
    "ComponentTypeName": null,
    "ItemId": 0,
    "EngineNumber": 0,
    "AccessoryToolName": null,
    "ScheduleMtnc": 0,
    "Engine1Starts": 0.0,
    "Engine2Starts": 0.0,
    "Engine3Starts": 0.0,
    "Engine4Starts": 0.0,
    "DiscoveredByLicenseNumber": "",
    "CorrectedByLicenseNumber": "",
    "WoCheckOut": false,
    "WoNumber": 0,
    "MechanicAssignedTo1": null,
    "MechanicAssignedTo2": null,
    "MechanicAssignedTo3": null,
    "MyProperty": false,
    "AllowRating": true,
    "IsMel": false,
    "Created_At": null,
    "SystemAffected": "",
    "WhenDiscovered": "",
    "MalfunctionEffect": "",
    "FunctionalGroup": "",
    "HowRecognized": "",
    "MissionFlightType": "",
    "SystemAffectedName": null,
    "WhenDiscoveredName": null,
    "MalfunctionEffectName": null,
    "FunctionalGroupName": null,
    "HowRecognizedName": null,
    "MissionFlightTypeName": null,
    "IsSignAIRPerformed": false,
    "Discrepancy_Type": null,
    "RedirectOption": "0",
  };

  RxMap<String, bool> createDiscrepancyShowHideField =
      <String, bool>{
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

  RxList<String> editDragKey = <String>[].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    if (Get.parameters['action'] == 'discrepancyEdit') {
      //normalTileString.addIf() = 'Edit Discrepancy';
      if (kDebugMode) {
        normalTileString.addIf(true, 'title', 'Edit Discrepancy (${Get.parameters['discrepancyId']})');
        normalTileString.addIf(true, 'buttonSave', 'Save Discrepancy Changes');
        normalTileString.addIf(true, 'buttonCancel', 'Cancel Edit Discrepancy');
      } else {
        normalTileString.addIf(true, 'title', 'Edit Discrepancy');
        normalTileString.addIf(true, 'buttonSave', 'Save Discrepancy Changes');
        normalTileString.addIf(true, 'buttonCancel', 'Cancel Edit Discrepancy');
      }
      await loadInitialEditDiscrepancyData();
    } else {
      normalTileString.addIf(true, 'title', 'Create Discrepancy');
      normalTileString.addIf(true, 'buttonSave', 'Create New Discrepancy');
      normalTileString.addIf(true, 'buttonCancel', 'Cancel Create Discrepancy');
      await loadInitialCreateDiscrepancyData();
    }

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

  loadInitialEditDiscrepancyData() async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyEditViewData(discrepancyId: Get.parameters['discrepancyId'].toString());
    if (data?.statusCode == 200) {
      discrepancyEditApiData.addAll(data?.data['data']['createDiscrepancy']);

      serviceLifeTypeOneDropdownData.addAll(data?.data['data']['componentServiceLife1Type']);

      serviceLifeTypeTwoDropdownData.addAll(data?.data['data']['componentServiceLife2Type']);

      discoveredByDropdownData.addAll(data?.data['data']['discoveredBy']);

      statusDropdownData.addAll(data?.data['data']['discrepancyStatus']);

      mechanicAssignedToOneDropdownData.addAll(data?.data['data']['mechanicAssignedTo1']);
      mechanicAssignedToTwoDropdownData.addAll(data?.data['data']['mechanicAssignedTo2']);
      mechanicAssignedToThreeDropdownData.addAll(data?.data['data']['mechanicAssignedTo3']);

      scheduledMaintenanceDropdownData.addAll(data?.data['data']['scheduledMaintenance']);

      systemAffectedDropDownData.addAll(data?.data['data']['systemAffected']);
      functionalGroupDropDownData.addAll(data?.data['data']['functionalGroup']);
      malFunctionEffectDropDownData.addAll(data?.data['data']['malfunctionEffect']);
      whenDiscoveredDropDownData.addAll(data?.data['data']['whenDiscovered']);
      howRecognizedDropDownData.addAll(data?.data['data']['howRecognized']);
      missionFlightTypeDropDownData.addAll(data?.data['data']['missionFlightType']);

      associatedWorkOrderDropdownData.addAll(data?.data['data']['associatedWorkOrder']);

      if (discrepancyEditApiData['mel'] == 0) {
        melDropdownData.add({'id': 0, 'name': 'No'});
        melDropdownData.add({'id': 1, 'name': 'Yes - Create MEL'});
      } else {
        melDropdownData.add({'id': 0, 'name': 'No ** PRIOR MEL MUST BE COMPLETED MANUALLY **'});
        melDropdownData.add({'id': 1, 'name': 'Yes'});
      }

      userDropDownList.addAll(data?.data['data']['userNotification']);

      checkboxSelectAllUser.value = false;
      checkBox.clear();
      for (int i = 0; i < userDropDownList.length; i++) {
        checkBox.add(userDropDownList[i]['selected']);
      }

      if (discrepancyEditApiData['status'] == "Completed") {
        editClass = "NonEditable";
      } else {
        editClass = "";
      }

      if (discrepancyEditApiData['discrepancyType'] > 0) {
        editableClass = "DoNotEdit";
        editingClass = "DoNotEdit hidden";
      } else {
        editableClass = 'Editable$editClass';
        editingClass = 'Editing$editClass';
      }

      await updateDataSetForEdit();

      await initialDataSetForEditView();

      await dropdownDataSetForEditView();
    }
  }

  loadInitialCreateDiscrepancyData() async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyCreateViewData();
    if (data!.statusCode == 200) {
      discrepancyTypeDropdownData.addAll(data.data['data']['discrepancyType']);
      dropdownDataSetForCreateView(dropdownData: discrepancyTypeDropdownData, selectedValue: selectedDiscrepancyTypeDropdown);
      if (selectedDiscrepancyTypeDropdown.isNotEmpty) {
        createDiscrepancyUpdateApiData['DiscrepancyType'] = int.parse(selectedDiscrepancyTypeDropdown['id'].toString());
      }

      unitIdAircraftDropdownData.addAll(data.data['data']['unit']);
      dropdownDataSetForCreateView(dropdownData: unitIdAircraftDropdownData, selectedValue: selectedUnitIdAircraftDropdown);
      unitIdAccessoryToolsDropdownData.addAll(data.data['data']['accessoryTools']);
      dropdownDataSetForCreateView(dropdownData: unitIdAccessoryToolsDropdownData, selectedValue: selectedUnitIdAccessoryToolsDropdown);

      serviceLifeTypeOneDropdownData.addAll(data.data['data']['componentServiceLife1Type']);
      dropdownDataSetForCreateView(dropdownData: serviceLifeTypeOneDropdownData, selectedValue: selectedServiceLifeTypeOneDropdown);

      serviceLifeTypeTwoDropdownData.addAll(data.data['data']['componentServiceLife2Type']);
      dropdownDataSetForCreateView(dropdownData: serviceLifeTypeTwoDropdownData, selectedValue: selectedServiceLifeTypeTwoDropdown);

      discoveredByDropdownData.addAll(data.data['data']['discoveredBy']);
      dropdownDataSetForCreateView(dropdownData: discoveredByDropdownData, selectedValue: selectedDiscoveredByDropdown, selectMe: true, keyName: 'discoveredBySelectMe');

      selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTimeHelper.now)});

      statusDropdownData.addAll(data.data['data']['discrepancyStatus']);
      dropdownDataSetForCreateView(dropdownData: statusDropdownData, selectedValue: selectedStatusDropdown);
      if (selectedStatusDropdown.isNotEmpty) {
        createDiscrepancyUpdateApiData['Status'] = selectedStatusDropdown['id'];
      }

      mechanicAssignedToOneDropdownData.addAll(data.data['data']['mechanicAssignedTo1']);
      dropdownDataSetForCreateView(
        dropdownData: mechanicAssignedToOneDropdownData,
        selectedValue: selectedMechanicAssignedToOneDropdown,
        selectMe: true,
        keyName: 'mechanicAssignedToOne',
      );

      mechanicAssignedToTwoDropdownData.addAll(data.data['data']['mechanicAssignedTo2']);
      dropdownDataSetForCreateView(
        dropdownData: mechanicAssignedToTwoDropdownData,
        selectedValue: selectedMechanicAssignedToTwoDropdown,
        selectMe: true,
        keyName: 'mechanicAssignedToTwo',
      );

      mechanicAssignedToThreeDropdownData.addAll(data.data['data']['mechanicAssignedTo3']);
      dropdownDataSetForCreateView(
        dropdownData: mechanicAssignedToThreeDropdownData,
        selectedValue: selectedMechanicAssignedToThreeDropdown,
        selectMe: true,
        keyName: 'mechanicAssignedThree',
      );

      scheduledMaintenanceDropdownData.addAll(data.data['data']['scheduledMaintenance']);
      dropdownDataSetForCreateView(dropdownData: scheduledMaintenanceDropdownData, selectedValue: selectedScheduledMaintenanceDropdown);

      melDropdownData.addAll(data.data['data']['discrepancyMEL']);
      dropdownDataSetForCreateView(dropdownData: melDropdownData, selectedValue: selectedMelDropdown);

      systemAffectedDropDownData.addAll(data.data['data']['systemAffected']);
      dropdownDataSetForCreateView(dropdownData: systemAffectedDropDownData, selectedValue: selectedSystemAffectedDropdown);

      functionalGroupDropDownData.addAll(data.data['data']['functionalGroup']);
      dropdownDataSetForCreateView(dropdownData: functionalGroupDropDownData, selectedValue: selectedFunctionalGroupDropdown);

      malFunctionEffectDropDownData.addAll(data.data['data']['malfunctionEffect']);
      dropdownDataSetForCreateView(dropdownData: malFunctionEffectDropDownData, selectedValue: selectedMalFunctionEffectDropdown);

      whenDiscoveredDropDownData.addAll(data.data['data']['whenDiscovered']);
      dropdownDataSetForCreateView(dropdownData: whenDiscoveredDropDownData, selectedValue: selectedWhenDiscoveredDropdown);

      howRecognizedDropDownData.addAll(data.data['data']['howRecognized']);
      dropdownDataSetForCreateView(dropdownData: howRecognizedDropDownData, selectedValue: selectedHowRecognizedDropdown);

      missionFlightTypeDropDownData.addAll(data.data['data']['missionFlightType']);
      dropdownDataSetForCreateView(dropdownData: missionFlightTypeDropDownData, selectedValue: selectedMissionFlightTypeDropdown);

      associatedWorkOrderDropdownData.addAll(data.data['data']['associatedWorkOrder']);
      dropdownDataSetForCreateView(dropdownData: associatedWorkOrderDropdownData, selectedValue: selectedAssociatedWorkOrderDropdown);

      userDropDownList.addAll(data.data['data']['userNotification']);

      checkboxSelectAllUser.value = false;
      checkBox.clear();
      for (int i = 0; i < userDropDownList.length; i++) {
        checkBox.add(userDropDownList[i]['selected']);
      }

      discrepancyCreateValidationKeys.putIfAbsent("discrepancyType", () => GlobalKey<FormFieldState>());
      discrepancyCreateValidationKeys.putIfAbsent("discoveredBy", () => GlobalKey<FormFieldState>());
      discrepancyCreateValidationKeys.putIfAbsent("discrepancy", () => GlobalKey<FormFieldState>());
    }
  }

  updateDataSetForEdit() {
    editDiscrepancyUpdateApiData['UserId'] = discrepancyEditApiData['userId'];
    editDiscrepancyUpdateApiData['DiscrepancyId'] = discrepancyEditApiData['discrepancyId'];
    editDiscrepancyUpdateApiData['SystemId'] = discrepancyEditApiData['systemId'];
    editDiscrepancyUpdateApiData['DiscoveredBy'] = discrepancyEditApiData['discoveredBy'];
    editDiscrepancyUpdateApiData['DiscoveredByName'] = discrepancyEditApiData['discoveredByName'];
    editDiscrepancyUpdateApiData['CreatedAt'] = discrepancyEditApiData['createdAt'];
    editDiscrepancyUpdateApiData['DiscrepancyType'] = discrepancyEditApiData['discrepancyType'];
    editDiscrepancyUpdateApiData['UnitId'] = discrepancyEditApiData['unitId'];
    editDiscrepancyUpdateApiData['ComponentTypeIdSpecific'] = discrepancyEditApiData['componentTypeIdSpecific'];
    editDiscrepancyUpdateApiData['CorrectedBy'] = discrepancyEditApiData['correctedBy'];
    editDiscrepancyUpdateApiData['CorrectedByName'] = discrepancyEditApiData['correctedByName'];
    editDiscrepancyUpdateApiData['DateCorrected'] = discrepancyEditApiData['dateCorrected'];
    editDiscrepancyUpdateApiData['EquipmentName'] = discrepancyEditApiData['equipmentName'];
    editDiscrepancyUpdateApiData['HobbsName'] = discrepancyEditApiData['hobbsName'];
    editDiscrepancyUpdateApiData['TorqueEvents'] = discrepancyEditApiData['torqueEvents'];
    editDiscrepancyUpdateApiData['Landings'] = discrepancyEditApiData['landings'];
    editDiscrepancyUpdateApiData['OtherHobbs'] = discrepancyEditApiData['otherHobbs'];
    editDiscrepancyUpdateApiData['MaintenanceHobbs'] = discrepancyEditApiData['maintenanceHobbs'];
    editDiscrepancyUpdateApiData['Engine1TTName'] = discrepancyEditApiData['engine1TTName'];
    editDiscrepancyUpdateApiData['Engine2TTName'] = discrepancyEditApiData['engine2TTName'];
    editDiscrepancyUpdateApiData['Engine3TTName'] = discrepancyEditApiData['engine3TTName'];
    editDiscrepancyUpdateApiData['Engine4TTName'] = discrepancyEditApiData['engine4TTName'];
    editDiscrepancyUpdateApiData['Starts_Ng_N1_ICY_IMP1'] = discrepancyEditApiData['starts_Ng_N1_ICY_IMP1'];
    editDiscrepancyUpdateApiData['Starts_Ng_N1_ICY_IMP2'] = discrepancyEditApiData['starts_Ng_N1_ICY_IMP2'];
    editDiscrepancyUpdateApiData['Starts_Ng_N1_ICY_IMP3'] = discrepancyEditApiData['starts_Ng_N1_ICY_IMP3'];
    editDiscrepancyUpdateApiData['Starts_Ng_N1_ICY_IMP4'] = discrepancyEditApiData['starts_Ng_N1_ICY_IMP4'];
    editDiscrepancyUpdateApiData['NP_N2_PCY_PT1'] = discrepancyEditApiData['nP_N2_PCY_PT1'];
    editDiscrepancyUpdateApiData['NP_N2_PCY_PT2'] = discrepancyEditApiData['nP_N2_PCY_PT2'];
    editDiscrepancyUpdateApiData['NP_N2_PCY_PT3'] = discrepancyEditApiData['nP_N2_PCY_PT3'];
    editDiscrepancyUpdateApiData['NP_N2_PCY_PT4'] = discrepancyEditApiData['nP_N2_PCY_PT4'];
    editDiscrepancyUpdateApiData['CT1'] = discrepancyEditApiData['cT1'];
    editDiscrepancyUpdateApiData['CT2'] = discrepancyEditApiData['cT2'];
    editDiscrepancyUpdateApiData['CT3'] = discrepancyEditApiData['cT3'];
    editDiscrepancyUpdateApiData['CT4'] = discrepancyEditApiData['cT4'];
    editDiscrepancyUpdateApiData['CYCLES1'] = discrepancyEditApiData['cycleS1'];
    editDiscrepancyUpdateApiData['CYCLES2'] = discrepancyEditApiData['cycleS2'];
    editDiscrepancyUpdateApiData['CYCLES3'] = discrepancyEditApiData['cycleS3'];
    editDiscrepancyUpdateApiData['CYCLES4'] = discrepancyEditApiData['cycleS4'];

    editDiscrepancyUpdateApiData['ClientPO'] = discrepancyEditApiData['clientPO'];
    editDiscrepancyUpdateApiData['AircraftACTT'] = discrepancyEditApiData['aircraftACTT'];
    editDiscrepancyUpdateApiData['AircraftEngine1TT'] = discrepancyEditApiData['aircraftEngine1TT'];
    editDiscrepancyUpdateApiData['AircraftEngine2TT'] = discrepancyEditApiData['aircraftEngine2TT'];
    editDiscrepancyUpdateApiData['AircraftEngine3TT'] = discrepancyEditApiData['aircraftEngine3TT'];
    editDiscrepancyUpdateApiData['AircraftEngine4TT'] = discrepancyEditApiData['aircraftEngine4TT'];
    editDiscrepancyUpdateApiData['OutsideComponentName'] = discrepancyEditApiData['outsideComponentName'];
    editDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = discrepancyEditApiData['outsideComponentSerialNumber'];
    editDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = discrepancyEditApiData['outsideComponentPartNumber'];
    editDiscrepancyUpdateApiData['LabelOutsideComponentSerialNumber'] = discrepancyEditApiData['labelOutsideComponentSerialNumber'];
    editDiscrepancyUpdateApiData['LabelOutsideComponentPartNumber'] = discrepancyEditApiData['labelOutsideComponentPartNumber'];
    editDiscrepancyUpdateApiData['LabelOutsideComponentName'] = discrepancyEditApiData['labelOutsideComponentName'];
    editDiscrepancyUpdateApiData['ComponentServiceLife1Type'] = discrepancyEditApiData['componentServiceLife1Type'];
    editDiscrepancyUpdateApiData['ComponentServiceLife2Type'] = discrepancyEditApiData['componentServiceLife2Type'];
    editDiscrepancyUpdateApiData['ComponentServiceLife1TypeName'] = discrepancyEditApiData['componentServiceLife1TypeName'];
    editDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = discrepancyEditApiData['componentServiceLife1SinceNewAmt'];
    editDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = discrepancyEditApiData['componentServiceLife1SinceOhAmt'];
    editDiscrepancyUpdateApiData['ComponentServiceLife2TypeName'] = discrepancyEditApiData['componentServiceLife2TypeName'];
    editDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = discrepancyEditApiData['componentServiceLife2SinceNewAmt'];
    editDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = discrepancyEditApiData['componentServiceLife2SinceOhAmt'];
    editDiscrepancyUpdateApiData['CorrectiveAction'] = discrepancyEditApiData['correctiveAction'];
    editDiscrepancyUpdateApiData['Discrepancy'] = discrepancyEditApiData['discrepancy'];
    editDiscrepancyUpdateApiData['Status'] = discrepancyEditApiData['status'];
    editDiscrepancyUpdateApiData['OldStatus'] = discrepancyEditApiData['status'];
    editDiscrepancyUpdateApiData['ACTTCompletedAt'] = discrepancyEditApiData['acttCompletedAt'];
    editDiscrepancyUpdateApiData['Engine1TTCompletedAt'] = discrepancyEditApiData['engine1TTCompletedAt'];
    editDiscrepancyUpdateApiData['Engine2TTCompletedAt'] = discrepancyEditApiData['engine2TTCompletedAt'];
    editDiscrepancyUpdateApiData['Engine3TTCompletedAt'] = discrepancyEditApiData['engine3TTCompletedAt'];
    editDiscrepancyUpdateApiData['Engine4TTCompletedAt'] = discrepancyEditApiData['engine4TTCompletedAt'];
    editDiscrepancyUpdateApiData['AssignedTo'] = discrepancyEditApiData['assignedTo'];
    editDiscrepancyUpdateApiData['AssignedTo2'] = discrepancyEditApiData['assignedTo2'];
    editDiscrepancyUpdateApiData['AssignedTo3'] = discrepancyEditApiData['assignedTo3'];
    editDiscrepancyUpdateApiData['AssignedTo4'] = discrepancyEditApiData['assignedTo4'];
    editDiscrepancyUpdateApiData['AssignedToName'] = discrepancyEditApiData['assignedToName'];
    editDiscrepancyUpdateApiData['PurchaseOrder'] = discrepancyEditApiData['purchaseOrder'];

    editDiscrepancyUpdateApiData['Engine2Enabled'] = discrepancyEditApiData['engine2Enabled'];
    editDiscrepancyUpdateApiData['Engine3Enabled'] = discrepancyEditApiData['engine3Enabled'];
    editDiscrepancyUpdateApiData['Engine4Enabled'] = discrepancyEditApiData['engine4Enabled'];
    editDiscrepancyUpdateApiData['ATACode'] = discrepancyEditApiData['ataCode'];
    editDiscrepancyUpdateApiData['ATAMCNCode'] = discrepancyEditApiData['atamcnCode'];
    editDiscrepancyUpdateApiData['MCNCode'] = discrepancyEditApiData['mcnCode'];
    editDiscrepancyUpdateApiData['DiscrepancyNotes'] = discrepancyEditApiData['discrepancyNotes'];
    editDiscrepancyUpdateApiData['Notes'] = discrepancyEditApiData['notes'];
    editDiscrepancyUpdateApiData['NewNote'] = '';
    editDiscrepancyUpdateApiData['Attachments'] = discrepancyEditApiData['attachments'];
    editDiscrepancyUpdateApiData['ObjLogBookDiscrepanciesDataList'] = discrepancyEditApiData['objLogBookDiscrepanciesDataList'];
    editDiscrepancyUpdateApiData['EditMode'] = discrepancyEditApiData['editMode'];
    editDiscrepancyUpdateApiData['IsStatusCompleted'] = discrepancyEditApiData['isStatusCompleted'];
    editDiscrepancyUpdateApiData['Mel'] = discrepancyEditApiData['mel'];
    editDiscrepancyUpdateApiData['OldMel'] = discrepancyEditApiData['oldMel'];
    editDiscrepancyUpdateApiData['WorkOrder'] = discrepancyEditApiData['workOrder'];
    editDiscrepancyUpdateApiData['CheckFlightRequired'] = discrepancyEditApiData['checkFlightRequired'];
    editDiscrepancyUpdateApiData['CheckGroundRunRequired'] = discrepancyEditApiData['checkGroundRunRequired'];
    editDiscrepancyUpdateApiData['LeakTestRequired'] = discrepancyEditApiData['leakTestRequired'];
    editDiscrepancyUpdateApiData['AdditionalInspectionRequired'] = discrepancyEditApiData['additionalInspectionRequired'];
    editDiscrepancyUpdateApiData['AIRPerformedById'] = discrepancyEditApiData['airPerformedById'];
    editDiscrepancyUpdateApiData['AIRPerformedByName'] = discrepancyEditApiData['airPerformedByName'];
    editDiscrepancyUpdateApiData['AIRPerformedAt'] = discrepancyEditApiData['airPerformedAt'];
    editDiscrepancyUpdateApiData['IsWorkOrder'] = discrepancyEditApiData['isWorkOrder'];
    editDiscrepancyUpdateApiData['IsAircraft'] = discrepancyEditApiData['isAircraft'];
    editDiscrepancyUpdateApiData['UsersToNotify'] = discrepancyEditApiData['usersToNotify'];
    editDiscrepancyUpdateApiData['ComponentTypeName'] = discrepancyEditApiData['componentTypeName'];
    editDiscrepancyUpdateApiData['ItemId'] = discrepancyEditApiData['itemId'];
    editDiscrepancyUpdateApiData['EngineNumber'] = discrepancyEditApiData['engineNumber'];
    editDiscrepancyUpdateApiData['AccessoryToolName'] = discrepancyEditApiData['accessoryToolName'];
    editDiscrepancyUpdateApiData['ScheduleMtnc'] = discrepancyEditApiData['scheduleMtnc'];
    editDiscrepancyUpdateApiData['Engine1Starts'] = discrepancyEditApiData['engine1Starts'];
    editDiscrepancyUpdateApiData['Engine2Starts'] = discrepancyEditApiData['engine2Starts'];
    editDiscrepancyUpdateApiData['Engine3Starts'] = discrepancyEditApiData['engine3Starts'];
    editDiscrepancyUpdateApiData['Engine4Starts'] = discrepancyEditApiData['engine4Starts'];
    editDiscrepancyUpdateApiData['DiscoveredByLicenseNumber'] = discrepancyEditApiData['discoveredByLicenseNumber'];
    editDiscrepancyUpdateApiData['CorrectedByLicenseNumber'] = discrepancyEditApiData['correctedByLicenseNumber'];
    editDiscrepancyUpdateApiData['WoCheckOut'] = discrepancyEditApiData['woCheckOut'];
    editDiscrepancyUpdateApiData['WoNumber'] = discrepancyEditApiData['woNumber'];

    editDiscrepancyUpdateApiData['MechanicAssignedTo1'] = discrepancyEditApiData['mechanicAssignedTo1'];
    editDiscrepancyUpdateApiData['MechanicAssignedTo2'] = discrepancyEditApiData['mechanicAssignedTo2'];
    editDiscrepancyUpdateApiData['MechanicAssignedTo3'] = discrepancyEditApiData['mechanicAssignedTo3'];
    editDiscrepancyUpdateApiData['MyProperty'] = discrepancyEditApiData['myProperty'];
    editDiscrepancyUpdateApiData['AllowRating'] = discrepancyEditApiData['allowRating'];
    editDiscrepancyUpdateApiData['IsMel'] = discrepancyEditApiData['isMel'];
    editDiscrepancyUpdateApiData['Created_At'] = discrepancyEditApiData['created_At'];
    editDiscrepancyUpdateApiData['SystemAffected'] = discrepancyEditApiData['systemAffected'];
    editDiscrepancyUpdateApiData['WhenDiscovered'] = discrepancyEditApiData['whenDiscovered'];
    editDiscrepancyUpdateApiData['MalfunctionEffect'] = discrepancyEditApiData['malfunctionEffect'];
    editDiscrepancyUpdateApiData['FunctionalGroup'] = discrepancyEditApiData['functionalGroup'];
    editDiscrepancyUpdateApiData['HowRecognized'] = discrepancyEditApiData['howRecognized'];
    editDiscrepancyUpdateApiData['MissionFlightType'] = discrepancyEditApiData['missionFlightType'];
    editDiscrepancyUpdateApiData['SystemAffectedName'] = discrepancyEditApiData['systemAffectedName'];
    editDiscrepancyUpdateApiData['WhenDiscoveredName'] = discrepancyEditApiData['whenDiscoveredName'];
    editDiscrepancyUpdateApiData['MalfunctionEffectName'] = discrepancyEditApiData['malfunctionEffectName'];
    editDiscrepancyUpdateApiData['FunctionalGroupName'] = discrepancyEditApiData['functionalGroupName'];
    editDiscrepancyUpdateApiData['HowRecognizedName'] = discrepancyEditApiData['howRecognizedName'];
    editDiscrepancyUpdateApiData['MissionFlightTypeName'] = discrepancyEditApiData['missionFlightTypeName'];
    editDiscrepancyUpdateApiData['IsSignAIRPerformed'] = discrepancyEditApiData['isSignAIRPerformed'];
    editDiscrepancyUpdateApiData['Discrepancy_Type'] = discrepancyEditApiData['discrepancy_Type'];
    editDiscrepancyUpdateApiData['RedirectOption'] = discrepancyEditApiData['redirectOption'];
    editDiscrepancyUpdateApiData['DateTimeNow'] = discrepancyEditApiData['dateTimeNow'];
    editDiscrepancyUpdateApiData['AircraftName'] = discrepancyEditApiData['aircraftName'];
    editDiscrepancyUpdateApiData['ComponentName'] = discrepancyEditApiData['componentName'];
  }

  initialDataSetForEditView() {
    discrepancyEditTextController.putIfAbsent('acTT', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('landing', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('torque_events', () => TextEditingController());

    discrepancyEditTextController['acTT']!.text = discrepancyEditApiData['hobbsName'];
    discrepancyEditTextController['landing']!.text = discrepancyEditApiData['landings'];
    discrepancyEditTextController['torque_events']!.text = discrepancyEditApiData['torqueEvents'];

    discrepancyEditTextController.putIfAbsent('engine1TTName', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine1Starts', () => TextEditingController());

    discrepancyEditTextController.putIfAbsent('engine2TTName', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine2Starts', () => TextEditingController());

    discrepancyEditTextController.putIfAbsent('engine3TTName', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine3Starts', () => TextEditingController());

    discrepancyEditTextController.putIfAbsent('engine4TTName', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine4Starts', () => TextEditingController());

    discrepancyEditTextController['engine1TTName']!.text = discrepancyEditApiData['engine1TTName'].toString();
    discrepancyEditTextController['engine1Starts']!.text = discrepancyEditApiData['engine1Starts'].toString();

    discrepancyEditTextController['engine2TTName']!.text = discrepancyEditApiData['engine2TTName'].toString();
    discrepancyEditTextController['engine2Starts']!.text = discrepancyEditApiData['engine2Starts'].toString();

    discrepancyEditTextController['engine3TTName']!.text = discrepancyEditApiData['engine3TTName'].toString();
    discrepancyEditTextController['engine3Starts']!.text = discrepancyEditApiData['engine3Starts'].toString();

    discrepancyEditTextController['engine4TTName']!.text = discrepancyEditApiData['engine4TTName'].toString();
    discrepancyEditTextController['engine4Starts']!.text = discrepancyEditApiData['engine4Starts'].toString();

    discrepancyEditTextController.putIfAbsent('discoveredByLicenseNumber', () => TextEditingController());
    discrepancyEditTextController['discoveredByLicenseNumber']!.text = discrepancyEditApiData['discoveredByLicenseNumber'];

    discrepancyEditTextController.putIfAbsent('discrepancy', () => TextEditingController());
    discrepancyEditTextController['discrepancy']!.text = discrepancyEditApiData['discrepancy'];

    discrepancyEditTextController.putIfAbsent('acttCompletedAt', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController());
    discrepancyEditTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController());

    discrepancyEditTextController.putIfAbsent('correctiveAction', () => TextEditingController());
    discrepancyEditTextController['correctiveAction']!.text = discrepancyEditApiData['correctiveAction'];

    discrepancyEditTextController['acttCompletedAt']!.text = discrepancyEditApiData['acttCompletedAt'].toString();
    discrepancyEditTextController['engine1TTCompletedAt']!.text = discrepancyEditApiData['engine1TTCompletedAt'].toString();
    discrepancyEditTextController['engine2TTCompletedAt']!.text = discrepancyEditApiData['engine2TTCompletedAt'].toString();
    discrepancyEditTextController['engine3TTCompletedAt']!.text = discrepancyEditApiData['engine3TTCompletedAt'].toString();
    discrepancyEditTextController['engine4TTCompletedAt']!.text = discrepancyEditApiData['engine4TTCompletedAt'].toString();

    discrepancyEditTextController.putIfAbsent('correctedByLicenseNumber', () => TextEditingController());
    discrepancyEditTextController['correctedByLicenseNumber']!.text = discrepancyEditApiData['correctedByLicenseNumber'];

    discrepancyEditTextController.putIfAbsent('ataCode', () => TextEditingController());
    discrepancyEditTextController['ataCode']!.text = discrepancyEditApiData['ataCode'];

    discrepancyEditTextController.putIfAbsent('atamcnCode', () => TextEditingController());
    discrepancyEditTextController['atamcnCode']!.text = discrepancyEditApiData['atamcnCode'];

    discrepancyEditTextController.putIfAbsent('purchaseOrder', () => TextEditingController());
    discrepancyEditTextController['purchaseOrder']!.text = discrepancyEditApiData['purchaseOrder'];

    discrepancyEditTextController.putIfAbsent('newNotes', () => TextEditingController());

    discrepancyEditTextController.putIfAbsent('outsideComponentName', () => TextEditingController());
    discrepancyEditTextController['outsideComponentName']!.text = discrepancyEditApiData['outsideComponentName'];

    discrepancyEditTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController());
    discrepancyEditTextController['outsideComponentPartNumber']!.text = discrepancyEditApiData['outsideComponentPartNumber'];

    discrepancyEditTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController());
    discrepancyEditTextController['outsideComponentSerialNumber']!.text = discrepancyEditApiData['outsideComponentSerialNumber'];

    discrepancyEditTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController());
    discrepancyEditTextController['componentServiceLife1SinceNewAmt']!.text = discrepancyEditApiData['componentServiceLife1SinceNewAmt'];

    discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
    discrepancyEditTextController['componentServiceLife2SinceNewAmt']!.text = discrepancyEditApiData['componentServiceLife2SinceNewAmt'];

    discrepancyEditTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController());
    discrepancyEditTextController['componentServiceLife1SinceOhAmt']!.text = discrepancyEditApiData['componentServiceLife1SinceOhAmt'];

    discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());
    discrepancyEditTextController['componentServiceLife2SinceOhAmt']!.text = discrepancyEditApiData['componentServiceLife2SinceOhAmt'];
  }

  dropdownDataSetForEditView() {
    for (int i = 0; i < discoveredByDropdownData.length; i++) {
      if (discoveredByDropdownData[i]['id'].toString() == discrepancyEditApiData['discoveredBy'].toString()) {
        selectedDiscoveredByDropdown.value = discoveredByDropdownData[i];
      }
    }

    for (int i = 0; i < serviceLifeTypeOneDropdownData.length; i++) {
      if (serviceLifeTypeOneDropdownData[i]['id'].toString() == discrepancyEditApiData['componentServiceLife1Type'].toString()) {
        selectedServiceLifeTypeOneDropdown.value = serviceLifeTypeOneDropdownData[i];
      }
    }

    for (int i = 0; i < serviceLifeTypeTwoDropdownData.length; i++) {
      if (serviceLifeTypeTwoDropdownData[i]['id'].toString() == discrepancyEditApiData['componentServiceLife2Type'].toString()) {
        selectedServiceLifeTypeTwoDropdown.value = serviceLifeTypeTwoDropdownData[i];
      }
    }

    for (int i = 0; i < statusDropdownData.length; i++) {
      if (statusDropdownData[i]['id'].toString() == discrepancyEditApiData['status'].toString()) {
        selectedStatusDropdown.value = statusDropdownData[i];
      }
    }

    for (int i = 0; i < mechanicAssignedToOneDropdownData.length; i++) {
      if (mechanicAssignedToOneDropdownData[i]['selected']) {
        selectedMechanicAssignedToOneDropdown.value = mechanicAssignedToOneDropdownData[i];
      }
    }

    for (int i = 0; i < mechanicAssignedToTwoDropdownData.length; i++) {
      if (mechanicAssignedToTwoDropdownData[i]['selected']) {
        selectedMechanicAssignedToTwoDropdown.value = mechanicAssignedToTwoDropdownData[i];
      }
    }

    for (int i = 0; i < mechanicAssignedToThreeDropdownData.length; i++) {
      if (mechanicAssignedToThreeDropdownData[i]['selected']) {
        selectedMechanicAssignedToThreeDropdown.value = mechanicAssignedToThreeDropdownData[i];
      }
    }

    for (int i = 0; i < scheduledMaintenanceDropdownData.length; i++) {
      if (scheduledMaintenanceDropdownData[i]['id'].toString() == discrepancyEditApiData['scheduleMtnc'].toString()) {
        selectedScheduledMaintenanceDropdown.value = scheduledMaintenanceDropdownData[i];
      }
    }

    for (int i = 0; i < melDropdownData.length; i++) {
      if (melDropdownData[i]['id'].toString() == discrepancyEditApiData['mel'].toString()) {
        selectedMelDropdown.value = melDropdownData[i];
      }
    }

    dropdownDataSetFunction(dropdownData: systemAffectedDropDownData, selectedValue: selectedSystemAffectedDropdown);
    dropdownDataSetFunction(dropdownData: functionalGroupDropDownData, selectedValue: selectedFunctionalGroupDropdown);
    dropdownDataSetFunction(dropdownData: malFunctionEffectDropDownData, selectedValue: selectedMalFunctionEffectDropdown);
    dropdownDataSetFunction(dropdownData: whenDiscoveredDropDownData, selectedValue: selectedWhenDiscoveredDropdown);
    dropdownDataSetFunction(dropdownData: howRecognizedDropDownData, selectedValue: selectedHowRecognizedDropdown);
    dropdownDataSetFunction(dropdownData: missionFlightTypeDropDownData, selectedValue: selectedMissionFlightTypeDropdown);
    dropdownDataSetFunction(dropdownData: associatedWorkOrderDropdownData, selectedValue: selectedAssociatedWorkOrderDropdown);

    selectedTimeDropDown.addAll({"id": 50, "name": DateFormat("HH:mm").format(DateTime.parse(discrepancyEditApiData['createdAt']))});
  }

  dropdownDataSetForCreateView({required List dropdownData, required Map selectedValue, bool selectMe = false, String? keyName}) {
    for (int i = 0; i < dropdownData.length; i++) {
      if (dropdownData[i]['selected']) {
        selectedValue.addAll(dropdownData[i]);
      }
      if (selectMe) {
        if (dropdownData[i]['id'].toString() == UserSessionInfo.userId.toString()) {
          createDiscrepancyShowHideField[keyName!] = true;
        }
      }
    }
  }

  dropdownDataSetFunction({required List dropdownData, required Map selectedValue}) {
    for (int i = 0; i < dropdownData.length; i++) {
      if (dropdownData[i]['selected']) {
        selectedValue.addAll(dropdownData[i]);
      }
    }
  }

  loadCurrentValueForCompleteDiscrepancy({required String unitId, bool create = false}) async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyAircraftInfoApiCall(aircraftId: unitId);
    if (data!.statusCode == 200) {
      if (create) {
        aircraftInfoData.clear();
        aircraftInfoData.addAll(data.data['data']);

        discrepancyCreateTextController.putIfAbsent('acttCompletedAt', () => TextEditingController());
        discrepancyCreateTextController['acttCompletedAt']?.text = aircraftInfoData['actt'].toString();

        discrepancyCreateTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController());

        discrepancyCreateTextController['engine1TTCompletedAt']?.text = aircraftInfoData['engine1TT'].toString();
        discrepancyCreateTextController['engine2TTCompletedAt']?.text = aircraftInfoData['engine2TT'].toString();
        discrepancyCreateTextController['engine3TTCompletedAt']?.text = aircraftInfoData['engine3TT'].toString();
        discrepancyCreateTextController['engine4TTCompletedAt']?.text = aircraftInfoData['engine4TT'].toString();

        createDiscrepancyUpdateApiData['Engine1TTCompletedAt'] = aircraftInfoData['engine1TT'].toString();
        createDiscrepancyUpdateApiData['Engine2TTCompletedAt'] = aircraftInfoData['engine2TT'].toString();
        createDiscrepancyUpdateApiData['Engine3TTCompletedAt'] = aircraftInfoData['engine3TT'].toString();
        createDiscrepancyUpdateApiData['Engine4TTCompletedAt'] = aircraftInfoData['engine4TT'].toString();

        createDiscrepancyUpdateApiData['Engine2Enabled'] = aircraftInfoData['engine2Enabled'];
        createDiscrepancyUpdateApiData['Engine3Enabled'] = aircraftInfoData['engine3Enabled'];
        createDiscrepancyUpdateApiData['Engine4Enabled'] = aircraftInfoData['engine4Enabled'];

        await EasyLoading.dismiss();
      } else {
        aircraftInfoData.clear();
        aircraftInfoData.addAll(data.data['data']);

        discrepancyEditTextController.putIfAbsent('acttCompletedAt', () => TextEditingController());
        discrepancyEditTextController['acttCompletedAt']?.text = aircraftInfoData['actt'].toString();

        discrepancyEditTextController.putIfAbsent('engine1TTCompletedAt', () => TextEditingController());
        discrepancyEditTextController.putIfAbsent('engine2TTCompletedAt', () => TextEditingController());
        discrepancyEditTextController.putIfAbsent('engine3TTCompletedAt', () => TextEditingController());
        discrepancyEditTextController.putIfAbsent('engine4TTCompletedAt', () => TextEditingController());

        discrepancyEditTextController['engine1TTCompletedAt']?.text = aircraftInfoData['engine1TT'].toString();
        discrepancyEditTextController['engine2TTCompletedAt']?.text = aircraftInfoData['engine2TT'].toString();
        discrepancyEditTextController['engine3TTCompletedAt']?.text = aircraftInfoData['engine3TT'].toString();
        discrepancyEditTextController['engine4TTCompletedAt']?.text = aircraftInfoData['engine4TT'].toString();

        editDiscrepancyUpdateApiData['Engine1TTCompletedAt'] = aircraftInfoData['engine1TT'].toString();
        editDiscrepancyUpdateApiData['Engine2TTCompletedAt'] = aircraftInfoData['engine2TT'].toString();
        editDiscrepancyUpdateApiData['Engine3TTCompletedAt'] = aircraftInfoData['engine3TT'].toString();
        editDiscrepancyUpdateApiData['Engine4TTCompletedAt'] = aircraftInfoData['engine4TT'].toString();

        discrepancyEditApiData.update('engine2Enabled', (value) => aircraftInfoData['engine2Enabled']);
        discrepancyEditApiData.update('engine3Enabled', (value) => aircraftInfoData['engine3Enabled']);
        discrepancyEditApiData.update('engine4Enabled', (value) => aircraftInfoData['engine4Enabled']);
        await EasyLoading.dismiss();
      }
    }
  }

  additionalInformationViewForLogicalDataOne() {
    if ((discrepancyEditApiData['discrepancyType'] == 2) || (discrepancyEditApiData['discrepancyType'] == 3)) {
      return true;
    }
    if ((discrepancyEditApiData['discrepancyType'] == 4) || (discrepancyEditApiData['discrepancyType'] == 5)) {
      return false;
    }
  }

  additionalInformationViewForLogicalDataTwo() {
    if ((discrepancyEditApiData['discrepancyType'] == 2 && discrepancyEditApiData['status'] == 'Completed') ||
        (discrepancyEditApiData['discrepancyType'] == 3 && discrepancyEditApiData['status'] == 'Completed')) {
      return true;
    }
    if ((discrepancyEditApiData['discrepancyType'] == 2 && discrepancyEditApiData['status'] != 'Completed') ||
        (discrepancyEditApiData['discrepancyType'] == 3 && discrepancyEditApiData['status'] != 'Completed')) {
      return false;
    }
    if ((discrepancyEditApiData['discrepancyType'] == 4 && discrepancyEditApiData['status'] == 'Completed') ||
        (discrepancyEditApiData['discrepancyType'] == 5 && discrepancyEditApiData['status'] == 'Completed')) {
      return true;
    }
    if ((discrepancyEditApiData['discrepancyType'] == 4 && discrepancyEditApiData['status'] != 'Completed') ||
        (discrepancyEditApiData['discrepancyType'] == 5 && discrepancyEditApiData['status'] != 'Completed')) {
      return false;
    }
  }

  ataDataViewAPICall() async {
    ataCodeData.clear();
    Response? ataCode = await DiscrepancyNewApiProvider().ataCodeData();
    if (ataCode?.statusCode == 200) {
      ataCodeData.addAll(ataCode?.data["data"]);
      for (int i = 0; i < ataCodeData["ataChapterData"].length; i++) {
        ataFieldExpand.add(false);
      }
      await EasyLoading.dismiss();
    }
  }

  ataCodeDialogView({required String editView}) {
    if (editView == 'edit') {
      discrepancyEditTextController.putIfAbsent('ataCode', () => TextEditingController());
    } else {
      discrepancyCreateTextController.putIfAbsent('ataCode', () => TextEditingController());
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
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
                                            discrepancyEditTextController["ataCode"]!.text =
                                                ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                            editDiscrepancyUpdateApiData["ATACode"] =
                                                ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                            Get.back();
                                          } else {
                                            discrepancyCreateTextController["ataCode"]!.text =
                                                ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                            createDiscrepancyUpdateApiData["ATACode"] =
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

  selectAllUserCheck() {
    int re = 0;
    selectedUsersDropdownList.clear();

    for (int i = 0; i < checkBox.length; i++) {
      if (checkBox[i] == true) {
        selectedUsersDropdownList.add(int.parse(userDropDownList[i]['id'].toString()));
        re = re + 1;
      }
    }
    createDiscrepancyUpdateApiData["UsersToNotify"] = selectedUsersDropdownList.join(", ");
    editDiscrepancyUpdateApiData["UsersToNotify"] = selectedUsersDropdownList.join(", ");
    if (re == checkBox.length) {
      return checkboxSelectAllUser.value = true;
    } else {
      return checkboxSelectAllUser.value = false;
    }
  }

  btnSaveChanges() async {
    if (validateInputs(operation: 'Edit')) {
      if (editDiscrepancyUpdateApiData['OldStatus'] != 'Completed' && editDiscrepancyUpdateApiData['Status'] == 'Completed') {
        await EasyLoading.dismiss();
        await electronicSignatureReformedDialogView(type: 'edit');
      } else {
        saveChanges();
      }
    } else {
      // if (editDiscrepancyUpdateApiData['Status'] == 'Completed') {
      //   bool validated = true;
      //   discrepancyEditValidationKeys.forEach((key, value) {
      //     if (value.currentState?.validate() == false) {
      //       validated = false;
      //     }
      //   });
      //   if (validated) {
      //     SnackBarHelper.openSnackBar(isError: true, message: 'Please, check the input field. Given data in invalid or something error!!!');
      //   }
      // }
      await EasyLoading.dismiss();
      update();
      await SnackBarHelper.openSnackBar(isError: true, message: "Field is required!!!");
      Scrollable.ensureVisible(gKeyForEdit[editDragKey.last]!.currentContext!, duration: const Duration(milliseconds: 500));
    }
  }

  validateInputs({required String operation}) {
    bool falseValue = true;
    editDragKey.clear();
    if (editDiscrepancyUpdateApiData['CreatedAtDate'].toString().trim().isEmpty) {
      falseValue = false;
    }
    if (editDiscrepancyUpdateApiData['CreatedAtTime'].toString().trim().isEmpty) {
      falseValue = false;
    }

    if (editDiscrepancyUpdateApiData['DiscrepancyType'].toString().trim().isEmpty) {
      falseValue = false;
    }

    if (editDiscrepancyUpdateApiData['DiscoveredBy'].toString() == '0') {
      falseValue = false;
      editDragKey.add('discoveredBy');
    }

    if (int.parse(editDiscrepancyUpdateApiData['DiscrepancyType'].toString()) > 3) {
      if (editDiscrepancyUpdateApiData['OutsideComponentName'].toString().isEmpty) {
        falseValue = false;
        editDragKey.add('outsideComponentName');
      }
    }

    if (editDiscrepancyUpdateApiData['Status'] == 'Completed') {
      if (editDiscrepancyUpdateApiData['CorrectiveAction'].toString().isEmpty) {
        falseValue = false;
        editDragKey.add('correctiveAction');
      }
    }

    if (int.parse(editDiscrepancyUpdateApiData['DiscrepancyType'].toString()) == 0 &&
        int.parse(editDiscrepancyUpdateApiData['UnitId'].toString()) > 0 &&
        editDiscrepancyUpdateApiData['Status'] == 'Completed') {
      if (editDiscrepancyUpdateApiData['ATACode'].toString().isEmpty) {
        falseValue = false;
        editDragKey.add('ataCode');
      }
    }

    if (operation == 'Edit') {
      if (editDiscrepancyUpdateApiData['Status'] == 'Completed') {
        if (editDiscrepancyUpdateApiData['DiscoveredBy'].toString().trim().isEmpty) {
          falseValue = false;
          editDragKey.add('discoveredBy');
        }
      } else {
        if (editDiscrepancyUpdateApiData['DiscoveredBy'].toString() == '0') {
          falseValue = false;
          editDragKey.add('discoveredBy');
        }
      }
    }

    if (editDiscrepancyUpdateApiData['Discrepancy'].toString().trim().isEmpty) {
      falseValue = false;
      editDragKey.add('discrepancy');
    }

    return falseValue;
  }

  saveChanges() async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyEditSaveApiCallData(saveEditData: editDiscrepancyUpdateApiData);
    await EasyLoading.dismiss();
    if (data?.statusCode == 200) {
      String id = data?.data["data"]["discrepancyId"].toString() ?? "0";
      SnackBarHelper.openSnackBar(isError: false, message: data?.data["userMessage"]);
      if (data?.data["data"]["redirectToAction"] == "/discrepancies/details/") {
        Get.offNamedUntil(
          Routes.discrepancyDetailsNew,
          ModalRoute.withName(Routes.discrepancyIndex),
          arguments: id,
          parameters: {"discrepancyId": id, "routeForm": "discrepancyEdit"},
        );
      } else {
        Get.offNamed(Routes.fileUpload, arguments: "discrepancyAddAttachment", parameters: {"routes": id.toString()});
      }
    }
  }

  discrepancyTypeChangeApiCall() async {
    Response? typeChangeData = await DiscrepancyNewApiProvider().discrepancyTypeChangeApiCall(
      discrepancyId: selectedDiscrepancyTypeDropdown['id'].toString(),
      itemChange: "0",
      unitId: "0",
      componentTypeIdSpecific: "0",
    );
    if (typeChangeData!.statusCode == 200) {
      switch (int.parse(selectedDiscrepancyTypeDropdown['id'].toString())) {
        case 0:
          unitIdAircraftDropdownData.clear();
          selectedUnitIdAircraftDropdown.clear();
          unitIdAircraftDropdownData.addAll(typeChangeData.data['data']['discrepancyTypeChangedEvent']['unit']);
          dropdownDataSetForCreateView(dropdownData: unitIdAircraftDropdownData, selectedValue: selectedUnitIdAircraftDropdown);
          await EasyLoading.dismiss();
          break;

        case 1:
          unitIdAccessoryToolsDropdownData.clear();
          selectedUnitIdAccessoryToolsDropdown.clear();
          unitIdAccessoryToolsDropdownData.addAll(typeChangeData.data['data']['discrepancyTypeChangedEvent']['accessoryTools']);
          dropdownDataSetForCreateView(dropdownData: unitIdAccessoryToolsDropdownData, selectedValue: selectedUnitIdAccessoryToolsDropdown);
          await EasyLoading.dismiss();
          break;

        case 2:
          unitIdComponentOnAircraftDropdownData.clear();
          selectedUnitIdComponentOnAircraftDropdown.clear();
          unitIdComponentOnAircraftDropdownData.addAll(typeChangeData.data['data']['discrepancyTypeChangedEvent']['unit']);
          dropdownDataSetForCreateView(dropdownData: unitIdComponentOnAircraftDropdownData, selectedValue: selectedUnitIdComponentOnAircraftDropdown);
          await EasyLoading.dismiss();
          break;

        case 3:
          unitIdComponentRemoveOnAircraftDropdownData.clear();
          selectedUnitIdComponentRemoveOnAircraftDropdown.clear();
          unitIdComponentRemoveOnAircraftDropdownData.addAll(typeChangeData.data['data']['discrepancyTypeChangedEvent']['componentTypeSpecific']);
          dropdownDataSetForCreateView(dropdownData: unitIdComponentRemoveOnAircraftDropdownData, selectedValue: selectedUnitIdComponentRemoveOnAircraftDropdown);
          await EasyLoading.dismiss();
          break;

        case 4 || 5:
          serviceLifeTypeOneDropdownData.clear();
          serviceLifeTypeTwoDropdownData.clear();
          selectedServiceLifeTypeOneDropdown.clear();
          selectedServiceLifeTypeTwoDropdown.clear();
          serviceLifeTypeOneDropdownData.addAll(typeChangeData.data['data']['discrepancyTypeChangedEvent']['componentServiceLife1Type']);
          dropdownDataSetForCreateView(dropdownData: serviceLifeTypeOneDropdownData, selectedValue: selectedServiceLifeTypeOneDropdown);
          serviceLifeTypeTwoDropdownData.addAll(typeChangeData.data['data']['discrepancyTypeChangedEvent']['componentServiceLife2Type']);
          dropdownDataSetForCreateView(dropdownData: serviceLifeTypeTwoDropdownData, selectedValue: selectedServiceLifeTypeTwoDropdown);
          await EasyLoading.dismiss();
          break;

        default:
          await EasyLoading.dismiss();
          break;
      }
    }
  }

  apiCallForAircraftComponentNameData() async {
    componentTypeIdSpecificDropdownData.clear();
    Response? data = await DiscrepancyNewApiProvider().discrepancyComponentOnAircraftDropdownDataLoad(
      discrepancyType: selectedDiscrepancyTypeDropdown['id'].toString(),
      aircraftUnitId: selectedUnitIdComponentOnAircraftDropdown['id'].toString(),
      itemChanged: '1',
      componentTypeIdSpecific: "0",
    );
    if (data!.statusCode == 200) {
      componentTypeIdSpecificDropdownData.add({"id": "0", "name": "-- Selected Component Name --", "selected": true});
      componentTypeIdSpecificDropdownData.addAll(data.data['data']['discrepancyTypeChangedEvent']['componentTypeSpecific']);
      dropdownDataSetForCreateView(dropdownData: componentTypeIdSpecificDropdownData, selectedValue: selectedComponentTypeIdSpecificDropdown);
      await EasyLoading.dismiss();
    }
  }

  apiCallForAircraftAdditionalInformationData() async {
    aircraftInfoData.clear();

    Response? data = await DiscrepancyNewApiProvider().discrepancyAircraftInfoApiCall(aircraftId: selectedUnitIdAircraftDropdown['id'].toString());
    if (data!.statusCode == 200) {
      aircraftInfoData.addAll(data.data['data']);

      discrepancyCreateTextController.putIfAbsent('actt', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('landings', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('torqueEvents', () => TextEditingController());

      discrepancyCreateTextController['actt']!.text = aircraftInfoData['actt'].toString();
      discrepancyCreateTextController['landings']!.text = aircraftInfoData['landings'].toString();
      discrepancyCreateTextController['torqueEvents']!.text = aircraftInfoData['torqueEvents'].toString();

      createDiscrepancyUpdateApiData['HobbsName'] = aircraftInfoData['actt'].toString();
      createDiscrepancyUpdateApiData['Landings'] = aircraftInfoData['landings'].toString();
      createDiscrepancyUpdateApiData['TorqueEvents'] = aircraftInfoData['torqueEvents'].toString();

      discrepancyCreateTextController.putIfAbsent('engine1TT', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('engine2TT', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('engine3TT', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('engine4TT', () => TextEditingController());

      discrepancyCreateTextController['engine1TT']!.text = aircraftInfoData['engine1TT'].toString();
      discrepancyCreateTextController['engine2TT']!.text = aircraftInfoData['engine2TT'].toString();
      discrepancyCreateTextController['engine3TT']!.text = aircraftInfoData['engine3TT'].toString();
      discrepancyCreateTextController['engine4TT']!.text = aircraftInfoData['engine4TT'].toString();

      createDiscrepancyUpdateApiData["Engine1TTName"] = aircraftInfoData['engine1TT'].toString();
      createDiscrepancyUpdateApiData["Engine2TTName"] = aircraftInfoData['engine2TT'].toString();
      createDiscrepancyUpdateApiData["Engine3TTName"] = aircraftInfoData['engine3TT'].toString();
      createDiscrepancyUpdateApiData["Engine4TTName"] = aircraftInfoData['engine4TT'].toString();

      discrepancyCreateTextController.putIfAbsent('engine1Starts', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('engine2Starts', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('engine3Starts', () => TextEditingController());
      discrepancyCreateTextController.putIfAbsent('engine4Starts', () => TextEditingController());

      discrepancyCreateTextController['engine1Starts']!.text = aircraftInfoData['engine1Starts'].toString();
      discrepancyCreateTextController['engine2Starts']!.text = aircraftInfoData['engine2Starts'].toString();
      discrepancyCreateTextController['engine3Starts']!.text = aircraftInfoData['engine3Starts'].toString();
      discrepancyCreateTextController['engine4Starts']!.text = aircraftInfoData['engine4Starts'].toString();

      createDiscrepancyUpdateApiData['Engine1Starts'] = double.parse(aircraftInfoData['engine1Starts'].toString());
      createDiscrepancyUpdateApiData['Engine2Starts'] = double.parse(aircraftInfoData['engine2Starts'].toString());
      createDiscrepancyUpdateApiData['Engine3Starts'] = double.parse(aircraftInfoData['engine3Starts'].toString());
      createDiscrepancyUpdateApiData['Engine4Starts'] = double.parse(aircraftInfoData['engine4Starts'].toString());

      createDiscrepancyShowHideField['additionalInformationField'] = true;

      update();

      await EasyLoading.dismiss();
    }
  }

  apiCallForAircraftComponentNameDataItemChangeTwo({
    required String discrepancyType,
    required String unitId,
    required String itemChange,
    required String componentTypeIdSpecific,
  }) async {
    workOrderComponentData.clear();

    aircraftInfoData.clear();

    // print('ChangeID: $componentTypeIdSpecific');

    Response? data = await DiscrepancyNewApiProvider().discrepancyComponentOnAircraftDropdownDataLoad(
      discrepancyType: discrepancyType,
      aircraftUnitId: unitId,
      itemChanged: itemChange,
      componentTypeIdSpecific: componentTypeIdSpecific,
    );
    if (data?.statusCode == 200) {
      workOrderComponentData.addAll(data?.data['data']['discrepancyTypeChangedEvent']['workOrderComponent']);
      aircraftInfoData.addAll(data?.data['data']['discrepancyTypeChangedEvent']['aircraftInfo']);

      if (workOrderComponentData.isNotNullOrEmpty) {
        discrepancyCreateTextController.putIfAbsent('outsideComponentName', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController());

        discrepancyCreateTextController['outsideComponentName']!.text = workOrderComponentData[0]['outsideComponentName'];
        discrepancyCreateTextController['outsideComponentSerialNumber']!.text = workOrderComponentData[0]['outsideComponentSerialNumber'];
        discrepancyCreateTextController['outsideComponentPartNumber']!.text = workOrderComponentData[0]['outsideComponentPartNumber'];

        createDiscrepancyUpdateApiData['OutsideComponentName'] = workOrderComponentData[0]['outsideComponentName'].toString();
        createDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = workOrderComponentData[0]['outsideComponentSerialNumber'].toString();
        createDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = workOrderComponentData[0]['outsideComponentPartNumber'].toString();

        for (int i = 0; i < serviceLifeTypeOneDropdownData.length; i++) {
          if (workOrderComponentData[0]['componentServiceLifeName'] == serviceLifeTypeOneDropdownData[i]['name']) {
            selectedServiceLifeTypeOneDropdown.addAll(serviceLifeTypeOneDropdownData[i]);
          }
        }

        discrepancyCreateTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController());

        discrepancyCreateTextController['componentServiceLife1SinceNewAmt']!.text = workOrderComponentData[0]['componentNewAmt'].toString();
        discrepancyCreateTextController['componentServiceLife1SinceOhAmt']!.text = workOrderComponentData[0]['componentOhAmt'].toString();

        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = workOrderComponentData[0]['componentNewAmt'].toString();
        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = workOrderComponentData[0]['componentOhAmt'].toString();

        discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());

        discrepancyCreateTextController['componentServiceLife2SinceNewAmt']!.text = '0.0';
        discrepancyCreateTextController['componentServiceLife2SinceOhAmt']!.text = '0.0';

        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = '0.0';

        for (int i = 0; i < serviceLifeTypeTwoDropdownData.length; i++) {
          if (workOrderComponentData[1]['componentServiceLifeName'] == serviceLifeTypeTwoDropdownData[i]['name']) {
            selectedServiceLifeTypeTwoDropdown.addAll(serviceLifeTypeTwoDropdownData[i]);
          }
        }

        discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());

        discrepancyCreateTextController['componentServiceLife2SinceNewAmt']!.text = '0.0';
        discrepancyCreateTextController['componentServiceLife2SinceOhAmt']!.text = '0.0';

        // if (workOrderComponentData.length > 1) {
        //   discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
        //   discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());
        //
        //   discrepancyEditTextController['componentServiceLife2SinceNewAmt']!.text = workOrderComponentData[1]['componentNewAmt'].toString();
        //   discrepancyEditTextController['componentServiceLife2SinceOhAmt']!.text = workOrderComponentData[1]['componentOhAmt'].toString();
        //
        //   for (int i = 0; i < serviceLifeTypeTwoDropdownData.length; i++) {
        //     if (workOrderComponentData[1]['componentServiceLifeName'] == serviceLifeTypeTwoDropdownData[i]['name']) {
        //       selectedServiceLifeTypeTwoDropdown.addAll(serviceLifeTypeTwoDropdownData[i]);
        //     }
        //   }
        // }
        // else {
        //   discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
        //   discrepancyEditTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());
        //
        //   discrepancyEditTextController['componentServiceLife2SinceNewAmt']!.text = '0';
        //   discrepancyEditTextController['componentServiceLife2SinceOhAmt']!.text = '0.0';
        // }
      } else {
        discrepancyCreateTextController.putIfAbsent('outsideComponentName', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('outsideComponentSerialNumber', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('outsideComponentPartNumber', () => TextEditingController());

        discrepancyCreateTextController['outsideComponentName']!.text = '';
        discrepancyCreateTextController['outsideComponentSerialNumber']!.text = '';
        discrepancyCreateTextController['outsideComponentPartNumber']!.text = '';

        createDiscrepancyUpdateApiData['OutsideComponentName'] = '';
        createDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = '';
        createDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = '';

        discrepancyCreateTextController.putIfAbsent('componentServiceLife1SinceNewAmt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('componentServiceLife1SinceOhAmt', () => TextEditingController());

        discrepancyCreateTextController['componentServiceLife1SinceNewAmt']!.text = '0.0';
        discrepancyCreateTextController['componentServiceLife1SinceOhAmt']!.text = '0.0';

        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = '0.0';

        discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceNewAmt', () => TextEditingController());
        discrepancyCreateTextController.putIfAbsent('componentServiceLife2SinceOhAmt', () => TextEditingController());

        discrepancyCreateTextController['componentServiceLife2SinceNewAmt']!.text = '0.0';
        discrepancyCreateTextController['componentServiceLife2SinceOhAmt']!.text = '0.0';

        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = '0.0';
      }
      createDiscrepancyShowHideField['additionalInformationField'] = true;
      update();
      await EasyLoading.dismiss();
    }
  }

  userNotifierViewApiCall({required String aircraftId, required String discrepancyType}) async {
    userDropDownList.clear();

    Response? data = await DiscrepancyNewApiProvider().discrepancyUserNotifierApiCallData(aircraftId: aircraftId, discrepancyType: discrepancyType);
    if (data?.statusCode == 200) {
      userDropDownList.addAll(data?.data['data']['notifiedUsers']);

      checkboxSelectAllUser.value = false;
      checkBox.clear();
      for (int i = 0; i < userDropDownList.length; i++) {
        checkBox.add(userDropDownList[i]['isSelected'] == 1 ? true : false);
      }

      selectedUsersDropdownList.clear();

      for (int i = 0; i < checkBox.length; i++) {
        if (checkBox[i] == true) {
          selectedUsersDropdownList.add(int.parse(userDropDownList[i]['id'].toString()));
        }
      }
      createDiscrepancyUpdateApiData['UsersToNotify'] = selectedUsersDropdownList.join(", ");
    }
  }

  createDiscrepancyDataBindWithFinalCondition() {
    switch (createDiscrepancyUpdateApiData['DiscrepancyType']) {
      case 0:
        createDiscrepancyUpdateApiData['OutsideComponentName'] = '';
        createDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = '';
        createDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = '';

        createDiscrepancyUpdateApiData['ComponentServiceLife1Type'] = 0;
        createDiscrepancyUpdateApiData['ComponentServiceLife1TypeName'] = null;

        createDiscrepancyUpdateApiData['ComponentServiceLife2Type'] = 0;
        createDiscrepancyUpdateApiData['ComponentServiceLife2TypeName'] = null;

        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = '0.0';

        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = '0.0';

        createDiscrepancyUpdateApiData['IsAircraft'] = 1;

        break;

      case 1:
        // createDiscrepancyUpdateApiData['OutsideComponentName'] = '';
        // createDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = '';
        // createDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = '';
        //
        // createDiscrepancyUpdateApiData['ComponentServiceLife1Type'] = 0;
        // createDiscrepancyUpdateApiData['ComponentServiceLife1TypeName'] = null;
        //
        // createDiscrepancyUpdateApiData['ComponentServiceLife2Type'] = 0;
        // createDiscrepancyUpdateApiData['ComponentServiceLife2TypeName'] = null;
        //
        // createDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = '0.0';
        // createDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = '0.0';
        //
        // createDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = '0.0';
        // createDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = '0.0';
        //
        // createDiscrepancyUpdateApiData['HobbsName'] = '';
        // createDiscrepancyUpdateApiData['Landings'] = '';
        // createDiscrepancyUpdateApiData['TorqueEvents'] = '';
        //
        // createDiscrepancyUpdateApiData['Engine1TTName'] = '0.0';
        // createDiscrepancyUpdateApiData['Engine1Starts'] = 0.0;
        //
        // createDiscrepancyUpdateApiData['Engine2TTName'] = '0.0';
        // createDiscrepancyUpdateApiData['Engine2Starts'] = 0.0;
        //
        // createDiscrepancyUpdateApiData['Engine3TTName'] = '0.0';
        // createDiscrepancyUpdateApiData['Engine3Starts'] = 0.0;
        //
        // createDiscrepancyUpdateApiData['Engine4TTName'] = '0.0';
        // createDiscrepancyUpdateApiData['Engine4Starts'] = 0.0;
        //
        // createDiscrepancyUpdateApiData['Engine2Enabled'] = false;
        // createDiscrepancyUpdateApiData['Engine3Enabled'] = false;
        // createDiscrepancyUpdateApiData['Engine4Enabled'] = false;
        //
        // createDiscrepancyUpdateApiData['ATACode'] = '';
        // createDiscrepancyUpdateApiData['ATAMCNCode'] = '';
        //
        // createDiscrepancyUpdateApiData['CheckFlightRequired'] = false;
        // createDiscrepancyUpdateApiData['CheckGroundRunRequired'] = false;
        // createDiscrepancyUpdateApiData['LeakTestRequired'] = false;
        // createDiscrepancyUpdateApiData['AdditionalInspectionRequired'] = false;
        //
        // createDiscrepancyUpdateApiData['AIRPerformedById'] = 0;
        // createDiscrepancyUpdateApiData['AIRPerformedByName'] = null;
        // createDiscrepancyUpdateApiData['AIRPerformedAt'] = '1900-01-01T00:00:00';
        //
        // createDiscrepancyUpdateApiData['IsAircraft'] = 0;

        createDiscrepancyUpdateApiData['OutsideComponentName'] = '';
        createDiscrepancyUpdateApiData['OutsideComponentPartNumber'] = '';
        createDiscrepancyUpdateApiData['OutsideComponentSerialNumber'] = '';

        createDiscrepancyUpdateApiData['ComponentServiceLife1Type'] = 0;
        createDiscrepancyUpdateApiData['ComponentServiceLife1TypeName'] = null;

        createDiscrepancyUpdateApiData['ComponentServiceLife2Type'] = 0;
        createDiscrepancyUpdateApiData['ComponentServiceLife2TypeName'] = null;

        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceNewAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceNewAmt'] = '0.0';

        createDiscrepancyUpdateApiData['ComponentServiceLife1SinceOhAmt'] = '0.0';
        createDiscrepancyUpdateApiData['ComponentServiceLife2SinceOhAmt'] = '0.0';

        createDiscrepancyUpdateApiData["HobbsName"] = "0.0";
        createDiscrepancyUpdateApiData["Landings"] = "0";
        createDiscrepancyUpdateApiData["TorqueEvents"] = "0";

        createDiscrepancyUpdateApiData["Engine1TTName"] = "0.0";
        createDiscrepancyUpdateApiData["Engine2TTName"] = "0.0";
        createDiscrepancyUpdateApiData["Engine3TTName"] = "0.0";
        createDiscrepancyUpdateApiData["Engine4TTName"] = "0.0";

        createDiscrepancyUpdateApiData["Engine1Starts"] = "0.0";
        createDiscrepancyUpdateApiData["Engine2Starts"] = "0.0";
        createDiscrepancyUpdateApiData["Engine3Starts"] = "0.0";
        createDiscrepancyUpdateApiData["Engine4Starts"] = "0.0";

        createDiscrepancyUpdateApiData["CheckGroundRunRequired"] = false;
        createDiscrepancyUpdateApiData["CheckFlightRequired"] = false;
        createDiscrepancyUpdateApiData["LeakTestRequired"] = false;
        createDiscrepancyUpdateApiData["AdditionalInspectionRequired"] = false;
        createDiscrepancyUpdateApiData["AIRPerformedById"] = 0;

        createDiscrepancyUpdateApiData["ATACode"] = "";
        createDiscrepancyUpdateApiData["ATAMCNCode"] = "";

        break;

      case 2 || 3 || 4 || 5:
        //createDiscrepancyUpdateApiData['HobbsName'] = '';
        //createDiscrepancyUpdateApiData['Landings'] = '';
        //createDiscrepancyUpdateApiData['TorqueEvents'] = '';
        //
        //createDiscrepancyUpdateApiData['Engine1TTName'] = '0.0';
        //createDiscrepancyUpdateApiData['Engine1Starts'] = 0.0;
        //
        //createDiscrepancyUpdateApiData['Engine2TTName'] = '0.0';
        //createDiscrepancyUpdateApiData['Engine2Starts'] = 0.0;

        // createDiscrepancyUpdateApiData['Engine3TTName'] = '0.0';
        // createDiscrepancyUpdateApiData['Engine3Starts'] = 0.0;
        //
        // createDiscrepancyUpdateApiData['Engine4TTName'] = '0.0';
        // createDiscrepancyUpdateApiData['Engine4Starts'] = 0.0;
        //
        // createDiscrepancyUpdateApiData['Engine2Enabled'] = false;
        // createDiscrepancyUpdateApiData['Engine3Enabled'] = false;
        // createDiscrepancyUpdateApiData['Engine4Enabled'] = false;
        //
        // createDiscrepancyUpdateApiData['ATACode'] = '';
        // createDiscrepancyUpdateApiData['ATAMCNCode'] = '';
        //
        // createDiscrepancyUpdateApiData['CheckFlightRequired'] = false;
        // createDiscrepancyUpdateApiData['CheckGroundRunRequired'] = false;
        // createDiscrepancyUpdateApiData['LeakTestRequired'] = false;
        // createDiscrepancyUpdateApiData['AdditionalInspectionRequired'] = false;
        //
        // createDiscrepancyUpdateApiData['AIRPerformedById'] = 0;
        // createDiscrepancyUpdateApiData['AIRPerformedByName'] = null;
        // createDiscrepancyUpdateApiData['AIRPerformedAt'] = '1900-01-01T00:00:00';

        createDiscrepancyUpdateApiData['IsAircraft'] = 0;

        //------true
        createDiscrepancyUpdateApiData["HobbsName"] = "0.0";
        createDiscrepancyUpdateApiData["Landings"] = "0";
        createDiscrepancyUpdateApiData["TorqueEvents"] = "0";

        createDiscrepancyUpdateApiData["Engine1TTName"] = "0.0";
        createDiscrepancyUpdateApiData["Engine2TTName"] = "0.0";
        createDiscrepancyUpdateApiData["Engine3TTName"] = "0.0";
        createDiscrepancyUpdateApiData["Engine4TTName"] = "0.0";

        createDiscrepancyUpdateApiData["Engine1Starts"] = "0.0";
        createDiscrepancyUpdateApiData["Engine2Starts"] = "0.0";
        createDiscrepancyUpdateApiData["Engine3Starts"] = "0.0";
        createDiscrepancyUpdateApiData["Engine4Starts"] = "0.0";

        createDiscrepancyUpdateApiData["CheckGroundRunRequired"] = false;
        createDiscrepancyUpdateApiData["CheckFlightRequired"] = false;
        createDiscrepancyUpdateApiData["LeakTestRequired"] = false;
        createDiscrepancyUpdateApiData["AdditionalInspectionRequired"] = false;
        createDiscrepancyUpdateApiData["AIRPerformedById"] = 0;

        createDiscrepancyUpdateApiData["ATACode"] = "";
        createDiscrepancyUpdateApiData["ATAMCNCode"] = "";

        break;
    }
  }

  dataValidationCondition() async {
    // Common Data Validation
    // if(discrepancyCreateValidationKeys['discrepancyType']!.currentState!.validate() && discrepancyCreateValidationKeys['discoveredBy']!.currentState!.validate() && discrepancyCreateValidationKeys['discrepancy']!.currentState!.validate()) {
    //   if(selectedStatusDropdown['id'] == 'Completed') {
    //     if(selectedDiscrepancyTypeDropdown['id'].toString() == '0') {
    //       if(discrepancyCreateValidationKeys['ataCode']!.currentState!.validate() && discrepancyCreateValidationKeys['correctiveAction']!.currentState!.validate()) {
    //         print('true');
    //       }
    //       else {
    //         SnackBarHelper.openSnackBar(isError: true, message: 'Field is Required!');
    //       }
    //     }
    //     else {
    //       if(discrepancyCreateValidationKeys['correctiveAction']!.currentState!.validate()) {
    //         print('true');
    //       }
    //       else {
    //         SnackBarHelper.openSnackBar(isError: true, message: 'Field is Required!');
    //       }
    //     }
    //   }
    //   else{
    //     print('true');
    //   }
    // }
    // else {
    //   await SnackBarHelper.openSnackBar(isError: true, message: 'Field is Required!');
    //   Scrollable.ensureVisible(dataKey.currentContext!);
    // }

    discrepancyCreateValidationKeys['discrepancyType']?.currentState?.didChange(createDiscrepancyUpdateApiData['DiscrepancyType']);
    discrepancyCreateValidationKeys['discoveredBy']?.currentState?.didChange(selectedDiscoveredByDropdown['id'].toString());

    bool validated = true;
    List<String> keyName = [];
    discrepancyCreateValidationKeys.forEach((key, value) {
      if (discrepancyCreateTextController.containsKey(key)) {
        value.currentState?.didChange(discrepancyCreateTextController[key]?.text);
      }
      value.currentState?.save();
      if (value.currentState?.validate() == false) {
        validated = false;
        keyName.add(key);
      }
    });
    if (validated) {
      if (createDiscrepancyUpdateApiData['Status'] == 'Completed') {
        await EasyLoading.dismiss();
        await electronicSignatureReformedDialogView(type: 'create');
      } else {
        dataSaveApiCallForCreateDiscrepancy(redirectOption: '0');
      }
    } else {
      await EasyLoading.dismiss();
      update();
      await SnackBarHelper.openSnackBar(isError: true, message: "Field is required!!!");
      Scrollable.ensureVisible(gKeyForCreate[keyName.last]!.currentContext!, duration: const Duration(milliseconds: 500));
    }
  }

  dataSaveApiCallForCreateDiscrepancy({required String redirectOption}) async {
    // createDiscrepancyApiPostData["CreatedAt"] = "${discrepancyCreateNewTextController["discrepancy_date"]!.text}T${discrepancyCreateNewTextController["discrepancy_time"]!.text}";
    createDiscrepancyUpdateApiData['RedirectOption'] = redirectOption;

    // print("888888888888888888888888888");
    // print(createDiscrepancyUpdateApiData);
    // print("****************************");

    // await EasyLoading.dismiss();

    Response data = await DiscrepancyNewApiProvider().discrepancyCreateSaveApiCall(createDiscrepancyData: createDiscrepancyUpdateApiData);

    if (data.statusCode == 200) {
      await SnackBarHelper.openSnackBar(isError: false, message: "Create Discrepancy ${data.data["data"]["discrepancyId"]} SuccessFully");
      await Get.offNamed(
        Routes.discrepancyDetailsNew,
        arguments: data.data["data"]["discrepancyId"].toString(),
        parameters: {"discrepancyId": data.data["data"]["discrepancyId"].toString(), "routeForm": "discrepancyNewCreate"},
      );
    } else {
      EasyLoading.dismiss();
      Get.offNamed(Routes.discrepancyIndex);
    }
  }

  buttonEnable() {
    if (int.parse(selectedDiscoveredByDropdown['id'].toString()) > 0 &&
        int.parse(selectedDiscrepancyTypeDropdown['id'].toString()) > -1 &&
        createDiscrepancyUpdateApiData['Discrepancy'].toString().isNotNullOrEmpty) {
      return true;
    } else {
      return false;
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
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Center(child: Text("Electronic Signature", style: Theme.of(Get.context!).textTheme.headlineLarge)),
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
                              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w600),
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
                                    style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
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
                                      hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 6),
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
                          await electronicSignatureApiCall(userPassword: textController.text, discrepancyId: editDiscrepancyUpdateApiData['DiscrepancyId'].toString());
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

  electronicSignatureApiCall({required String discrepancyId, required String userPassword}) async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyDetailsForAirPerformSignatureApiCall(discrepancyId: discrepancyId, userPassword: userPassword);
    if (data?.statusCode == 200) {
      Get.back(closeOverlays: true);
      await SnackBarHelper.openSnackBar(isError: false, message: 'Electronic Signature Recorded For AIR Performed (ID: ${data?.data['data']['discrepancyId']})');
      await saveChanges();
    }
  }

  electronicSignatureValidatePasswordApiCall({required String empId, required String userPassword}) async {
    Response? signatureDataOne = await DiscrepancyNewApiProvider().discrepancyCreateElectronicSignatureValidateUserPassword(empId: empId, userPassword: userPassword);
    if (signatureDataOne?.statusCode == 200) {
      Get.back(closeOverlays: true);
      createDiscrepancyUpdateApiData['RedirectOption'] = '0';
      Response? signatureDataTwo = await DiscrepancyNewApiProvider().discrepancyCreateSaveApiCall(createDiscrepancyData: createDiscrepancyUpdateApiData);
      if (signatureDataTwo?.statusCode == 200) {
        Response? finalSignatureData = await DiscrepancyNewApiProvider().discrepancyDetailsForAirPerformSignatureApiCall(
          discrepancyId: signatureDataTwo?.data["data"]["discrepancyId"].toString() ?? '',
          userPassword: userPassword,
        );
        if (finalSignatureData?.statusCode == 200) {
          await SnackBarHelper.openSnackBar(isError: false, message: "Create Discrepancy ${signatureDataTwo?.data["data"]["discrepancyId"]} SuccessFully");
          await Get.offNamed(
            Routes.discrepancyDetailsNew,
            arguments: signatureDataTwo?.data["data"]["discrepancyId"].toString(),
            parameters: {"discrepancyId": signatureDataTwo?.data["data"]["discrepancyId"].toString() ?? '', "routeForm": "discrepancyNewCreate"},
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.offNamed(Routes.discrepancyIndex);
      }
    } else {
      Get.back(closeOverlays: true);
      EasyLoading.dismiss();
    }
  }
}
