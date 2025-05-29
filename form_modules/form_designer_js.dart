import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/form_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:signature/signature.dart';

import '../../provider/forms_api_provider.dart';
import '../../routes/app_pages.dart';
import '../../widgets/buttons.dart';
import '../../widgets/widgets.dart';

mixin FormDesignerJs {
  var dataModified = false;

  static var userListHeight = 0.0.obs;
  static var sectionHeight = 0.0.obs;
  var formsApiProvider = FormsApiProvider();

  var initialFillOutFormData = {};
  var lastViewedFormId = "0";

  var arrRulesRows = 0;
  var arrRules = <List>[];
  var addChoiceServiceTableData = <String, List>{}.obs;
  var jsClass = {
    "acc": [],
    "accNum": [],
    "accCStart": [],
    "accCAdd": [],
    "accCEnd": [],
    "accHStart": [],
    "accHAdd": [],
    "accHEnd": [],
    "acSelector": [],
    "Billable_Hobbs_Name": [],
    "decimals0": [],
    "decimals1": [],
    "decimals2": [],
    "decimals3": [],
    "decimals4": [],
    "default_hidden": [],
    "Engine1Fields": [],
    "Engine2Fields": [],
    "EngineStarts": [],
    "EngineNP": [],
    "EngineNG2": [],
    "EngineCycles": [],
    "FlightDate_New": [],
    "FlightDate_Older": [],
    "gpsDMS": [],
    "gpsParent": [],
    "lblStartsName": [],
    "lblNPName": [],
    "lblNG2Name": [],
    "lblCyclesName": [],
    "NormalText": [],
    "NormalTextWhite": [],
    "OtherDate": [],
    "pos": [],
    "raforms": [],
    "raReload": [],
    "sn": [],
    "span": [],
    "yellow_background": [],
  }; // Use on .addClass() Method
  var showField = <String, bool>{}.obs; //Use on .show() or .hide() Method
  var values = <String, String>{}.obs; //Use on .val() Method
  var htmlValues = <String, String>{}.obs; //Use on .html() Method
  var requires = <String, bool>{}; //Use on
  var needValidation = <String, bool>{};
  var fieldType = <String, String>{};
  var property = <String, Map<String, bool>>{};
  var attribute = <String, Map<String, String>>{};
  var lastSave = "".obs;

  var updateExtendedTextField = "";
  var extendedFields = [];
  var extendedTextFields = [];
  var extendedFieldsValue = <String, String>{}.obs;
  var requiredFields = <String>[];
  var fieldIDsWithName = {};
  var formFieldAllIds = [];
  var fieldToShowTotal = '';
  var fieldsToAdd = '';
  Timer? intervalID;

  var signaturePenAllData = {}.obs;
  var signaturePenData = [].obs;
  var signaturePointLists = <String, List<Point>>{}.obs;
  var penSignatureDataList = <String, Map<String, List>>{}.obs;

  var riskAssessmentDropDownData = <String, List>{}.obs;
  var triggeredFieldsDropDownData = <String, List>{}.obs;
  var loadExtendedFieldData = <String, List>{}.obs;
  var loadExtendedChildFieldData = <String, List>{}.obs;

  var saveInProgress = false;
  var advanceRoutingFormID = '';
  var advanceRoutingAction = '';
  var advanceRoutingNotes = '';
  var advanceRoutingEmailUser = '';
  var signatureMode = 0;
  var signatureOnComplete = 0;

  var strFormID = 0;
  var strFormName = "";
  var strACPrimaryField = 0;
  var strMathFields = '';
  var strMathFieldsSubtract = '';
  var strMathFieldsTimeSubtractHours = '';
  var strMathFieldsTimeSubtractMinutes = '';
  var strMathFieldsSumMinutesToHours = '';
  var strMathFieldsMultiply0 = '';
  var strMathFieldsMultiply1 = '';
  var strMathFieldsMultiply2 = '';
  var strMathFieldsDivide0 = '';
  var strMathFieldsDivide1 = '';
  var strMathFieldsDivide2 = '';
  var strStartsName = '';
  var strRequiredSignaturePENFields = '';
  var strMemoFields = '';
  var strPICFieldBasis = '';
  var strBillableHobbsName = '';
  var strEngine2Enabled = '';
  var reloadAcInformation = 0;
  var strACHobbsStartID = 0;
  var strACHobbsToAddID = 0;
  var strACHobbsEndID = 0;
  var strACBillableStartID = 0;
  var strACBillableToAddID = 0;
  var strACBillableEndID = 0;
  var strAuxHobbsStartID = 0;
  var strAuxHobbsToAddID = 0;
  var strAuxHobbsEndID = 0;
  var strACTTStartID = 0;
  var strACTTToAddID = 0;
  var strACTTEndID = 0;
  var strACStartsStartID = 0;
  var strACStartsToAddID = 0;
  var strACStartsEndID = 0;
  var strACStarts2StartID = 0;
  var strACStarts2ToAddID = 0;
  var strACStarts2EndID = 0;
  var strACNPStartID = 0;
  var strACNPToAddID = 0;
  var strACNPEndID = 0;
  var strACNP2StartID = 0;
  var strACNP2ToAddID = 0;
  var strACNP2EndID = 0;
  var strACTEStartID = 0;
  var strACTEToAddID = 0;
  var strACTEEndID = 0;
  var strACLandingsStartID = 0;
  var strACLandingsToAddID = 0;
  var strACLandingsEndID = 0;
  var strACRunOnLandingsStartID = 0;
  var strACRunOnLandingsToAddID = 0;
  var strACRunOnLandingsEndID = 0;
  var strPICFieldID = 0;
  var strSICFieldID = 0;
  var strE1TTStartID = 0;
  var strE1TTToAddID = 0;
  var strE1TTEndID = 0;
  var strE2TTStartID = 0;
  var strE2TTToAddID = 0;
  var strE2TTEndID = 0;
  var strAPUTTStartID = 0;
  var strAPUTTToAddID = 0;
  var strAPUTTEndID = 0;
  var strE1NG2StartID = 0;
  var strE1NG2ToAddID = 0;
  var strE1NG2EndID = 0;
  var strE2NG2StartID = 0;
  var strE2NG2ToAddID = 0;
  var strE2NG2EndID = 0;
  var strE1CyclesStartID = 0;
  var strE1CyclesToAddID = 0;
  var strE1CyclesEndID = 0;
  var strE2CyclesStartID = 0;
  var strE2CyclesToAddID = 0;
  var strE2CyclesEndID = 0;
  var strFuelFarmFilledStartID = 0;
  var strFuelFarmFilledToAddID = 0;
  var strFuelFarmFilledEndID = 0;
  var strE1CreepEndID = 0;
  var strE2CreepEndID = 0;
  var strACHoistStartID = 0;
  var strACHoistToAddID = 0;
  var strACHoistEndID = 0;
  var strACHookStartID = 0;
  var strACHookToAddID = 0;
  var strACHookEndID = 0;
  var strFlightDateField = 0;
  var strE3TTStartID = 0;
  var strE3TTToAddID = 0;
  var strE3TTEndID = 0;
  var strE3CyclesStartID = 0;
  var strE3CyclesToAddID = 0;
  var strE3CyclesEndID = 0;

  var strE1HPCompressorStartID = 0;
  var strE1HPCompressorEndID = 0;
  var strE1HPCompressorToAddID = 0;
  var strE2HPCompressorStartID = 0;
  var strE2HPCompressorEndID = 0;
  var strE2HPCompressorToAddID = 0;
  var strE1CTCoverStartID = 0;
  var strE1CTCoverEndID = 0;
  var strE1CTCoverToAddID = 0;
  var strE2CTCoverStartID = 0;
  var strE2CTCoverEndID = 0;
  var strE2CTCoverToAddID = 0;
  var strE1CTCreepStartID = 0;
  var strE1CTCreepEndID = 0;
  var strE1CTCreepToAddID = 0;
  var strE2CTCreepStartID = 0;
  var strE2CTCreepEndID = 0;
  var strE2CTCreepToAddID = 0;
  var strE1PT2DiscStartID = 0;
  var strE1PT2DiscEndID = 0;
  var strE1PT2DiscToAddID = 0;
  var strE2PT2DiscStartID = 0;
  var strE2PT2DiscEndID = 0;
  var strE2PT2DiscToAddID = 0;

  var strE1PT1CreepStartID = 0;
  var strE1PT1CreepToAddID = 0;
  var strE1PT1CreepEndID = 0;
  var strE2PT1CreepStartID = 0;
  var strE2PT1CreepToAddID = 0;
  var strE2PT1CreepEndID = 0;
  var strE1PT2CreepStartID = 0;
  var strE1PT2CreepToAddID = 0;
  var strE1PT2CreepEndID = 0;
  var strE2PT2CreepStartID = 0;
  var strE2PT2CreepToAddID = 0;
  var strE2PT2CreepEndID = 0;

  var strCATAOperationsStartID = 0;
  var strCATAOperationsToAddID = 0;
  var strCATAOperationsEndID = 0;
  var strAVCSINOPStartID = 0;
  var strAVCSINOPToAddID = 0;
  var strAVCSINOPEndID = 0;
  var strMTOWFHSStartID = 0;
  var strMTOWFHSToAddID = 0;
  var strMTOWFHSEndID = 0;
  var strMTOWLDSStartID = 0;
  var strMTOWLDSToAddID = 0;
  var strMTOWLDSEndID = 0;

  var saveDialogText = "";

  ///Made & Done by Surjit - 100%
  Future<void> setInitialFillOutFormData() async {
    initialFillOutFormData.clear();

    Response response = await FormsApiProvider().getInitialFillOutFormData(fillOutFormId: Get.parameters["formId"] ?? lastViewedFormId, needJavaScriptData: true);
    if (response.statusCode == 200) {
      initialFillOutFormData.addAll(response.data["data"]);
      if (!(initialFillOutFormData["formFilloutMvc"]["canEdit"] ?? false)) {
        Get.back();
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "You Do Not Have Access To Edit This Form [ID: ${initialFillOutFormData["formId"]}]");
      }
    }
    /*initialFillOutFormData["arrayFormRules"].forEach((key, value) {
      arrRules.add(value);
    });*/
    for (int i = 0; i < initialFillOutFormData["arrayFormRules"].keys.length; i++) {
      arrRules.insert(i, initialFillOutFormData["arrayFormRules"][i.toString()]);
    }
    arrRulesRows = arrRules.isNotEmpty ? arrRules[0].length : 0;
  }

  ///Made & Done by Surjit - 100%
  Future<void> initEditUserForm() async {
    setFieldIds();
    doBindings();
    if (reloadAcInformation > 0) {
      await loadACData(id: reloadAcInformation);
    }
    await setupAircraftFields(strStartsName: strStartsName, strBillableHobbsName: strBillableHobbsName, strEngine2Enabled: strEngine2Enabled);
    await checkTriggersForPriorValues();
    await checkForm(doSave: false, fieldId: null);
    await checkRiskAssessments();
    intervalID = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      await autoSave();
    });
  }

  ///Made by Tayeb - 80% && Modified & Done by Surjit
  void setFieldIds() {
    requiredFields.addAll(initialFillOutFormData["formFilloutMvc"]["objFormEditData"]["requiredFieldsList"].cast<String>());
    requiredFields.sort((a, b) => a.compareTo(b));
    initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"].forEach((element) {
      requiredFields.removeWhere(
        (id) =>
            id.isEmpty ||
            (id == element["id"].toString() &&
                (element["fieldName"].toUpperCase().contains("HEADER") ||
                    element["fieldName"].toUpperCase().contains("SPACER") ||
                    element["formFieldType"] == 0 ||
                    element["formFieldType"] == 208 ||
                    element["formFieldType"] == 99)),
      );
      fieldIDsWithName.addIf(true, element["id"].toString(), [element["pageName"].toString(), element["formFieldName"].toString()]);
    });
    signatureOnComplete = initialFillOutFormData["formFilloutMvc"]["objFormEditData"]["signatureOnComplete"] == true ? 1 : 0;
    values["IsCloseOutForm"] = initialFillOutFormData["formFilloutMvc"]["objFormEditData"]["isCloseOutForm"]?.toString() ?? "";
    values["FormType"] = initialFillOutFormData["formFilloutMvc"]["objFormEditData"]["formType"]?.toString() ?? "";

    strFormID = int.parse(initialFillOutFormData["formId"]?.toString() ?? "0");
    strFormName = initialFillOutFormData["formName"]?.toString() ?? "";
    strACPrimaryField = int.parse(initialFillOutFormData["formFilloutMvc"]["acPrimaryField"]?.toString() ?? "0");
    strFlightDateField = int.parse(initialFillOutFormData["formFilloutMvc"]["flightDateField"]?.toString() ?? "0");
    strMathFields = initialFillOutFormData["formFilloutMvc"]["mathFields"]?.toString() ?? "";
    strMathFieldsSubtract = initialFillOutFormData["formFilloutMvc"]["mathFieldsSubtract"]?.toString() ?? "";
    strMathFieldsTimeSubtractHours = initialFillOutFormData["formFilloutMvc"]["mathFieldsTimeSubtractHours"]?.toString() ?? "";
    strMathFieldsTimeSubtractMinutes = initialFillOutFormData["formFilloutMvc"]["mathFieldsTimeSubtractMinutes"]?.toString() ?? "";
    strMathFieldsSumMinutesToHours = initialFillOutFormData["formFilloutMvc"]["mathFieldsSumMinutesToHours"]?.toString() ?? "";
    strMathFieldsMultiply0 = initialFillOutFormData["formFilloutMvc"]["mathFieldsMultiply0"]?.toString() ?? "";
    strMathFieldsMultiply1 = initialFillOutFormData["formFilloutMvc"]["mathFieldsMultiply1"]?.toString() ?? "";
    strMathFieldsMultiply2 = initialFillOutFormData["formFilloutMvc"]["mathFieldsMultiply2"]?.toString() ?? "";
    strMathFieldsDivide0 = initialFillOutFormData["formFilloutMvc"]["mathFieldsDivide0"]?.toString() ?? "";
    strMathFieldsDivide1 = initialFillOutFormData["formFilloutMvc"]["mathFieldsDivide1"]?.toString() ?? "";
    strMathFieldsDivide2 = initialFillOutFormData["formFilloutMvc"]["mathFieldsDivide2"]?.toString() ?? "";
    strStartsName = initialFillOutFormData["formFilloutMvc"]["startsName"]?.toString() ?? "";
    strRequiredSignaturePENFields = initialFillOutFormData["formFilloutMvc"]["requiredSignaturePenFields"]?.toString() ?? "";
    strMemoFields = initialFillOutFormData["formFilloutMvc"]["memoFields"]?.toString() ?? "";
    strPICFieldBasis = initialFillOutFormData["picFieldBasis"]?.toString() ?? "";
    strBillableHobbsName = initialFillOutFormData["formFilloutMvc"]["billableHobbsName"]?.toString() ?? "";
    strEngine2Enabled = initialFillOutFormData["formFilloutMvc"]["engine2Enabled"]?.toString() ?? "";
    reloadAcInformation = int.parse(initialFillOutFormData["formFilloutMvc"]["reloadAcInformation"]?.toString() ?? "0");
    strACHobbsStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHobbsStartId"]?.toString() ?? "0");
    strACHobbsToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHobbsToAddId"]?.toString() ?? "0");
    strACHobbsEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHobbsEndId"]?.toString() ?? "0");
    strACBillableStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acBillableStartId"]?.toString() ?? "0");
    strACBillableToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acBillableToAddId"]?.toString() ?? "0");
    strACBillableEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acBillableEndId"]?.toString() ?? "0");
    strAuxHobbsStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["auxHobbsStartId"]?.toString() ?? "0");
    strAuxHobbsToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["auxHobbsToAddId"]?.toString() ?? "0");
    strAuxHobbsEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["auxHobbsEndId"]?.toString() ?? "0");
    strACTTStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acttStartId"]?.toString() ?? "0");
    strACTTToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acttToAddId"]?.toString() ?? "0");
    strACTTEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acttEndId"]?.toString() ?? "0");
    strACStartsStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acStartsStartId"]?.toString() ?? "0");
    strACStartsToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acStartsToAddId"]?.toString() ?? "0");
    strACStartsEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acStartsEndId"]?.toString() ?? "0");
    strACStarts2StartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acStarts2StartId"]?.toString() ?? "0");
    strACStarts2ToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acStarts2ToAddId"]?.toString() ?? "0");
    strACStarts2EndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acStarts2EndId"]?.toString() ?? "0");
    strACNPStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acnpStartId"]?.toString() ?? "0");
    strACNPToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acnpToAddId"]?.toString() ?? "0");
    strACNPEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acnpEndId"]?.toString() ?? "0");
    strACNP2StartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acnP2StartId"]?.toString() ?? "0");
    strACNP2ToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acnP2ToAddId"]?.toString() ?? "0");
    strACNP2EndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acnP2EndId"]?.toString() ?? "0");
    strACTEStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acteStartId"]?.toString() ?? "0");
    strACTEToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acteToAddId"]?.toString() ?? "0");
    strACTEEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acteEndId"]?.toString() ?? "0");
    strACLandingsStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acLandingsStartId"]?.toString() ?? "0");
    strACLandingsToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acLandingsToAddId"]?.toString() ?? "0");
    strACLandingsEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acLandingsEndId"]?.toString() ?? "0");
    strACRunOnLandingsStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acRunOnLandingsStartId"]?.toString() ?? "0");
    strACRunOnLandingsToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acRunOnLandingsToAddId"]?.toString() ?? "0");
    strACRunOnLandingsEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acRunOnLandingsEndId"]?.toString() ?? "0");
    strPICFieldID = int.parse(initialFillOutFormData["formFilloutMvc"]["picFieldId"]?.toString() ?? "0");
    strSICFieldID = int.parse(initialFillOutFormData["formFilloutMvc"]["sicFieldId"]?.toString() ?? "0");
    strE1TTStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1TTStartId"]?.toString() ?? "0");
    strE1TTToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1TTToAddId"]?.toString() ?? "0");
    strE1TTEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1TTEndId"]?.toString() ?? "0");
    strE2TTStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2TTStartId"]?.toString() ?? "0");
    strE2TTToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2TTToAddId"]?.toString() ?? "0");
    strE2TTEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2TTEndId"]?.toString() ?? "0");
    strAPUTTStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["aputtStartId"]?.toString() ?? "0");
    strAPUTTToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["aputtToAddId"]?.toString() ?? "0");
    strAPUTTEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["aputtEndId"]?.toString() ?? "0");
    strE1NG2StartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1NG2StartId"]?.toString() ?? "0");
    strE1NG2ToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1NG2ToAddId"]?.toString() ?? "0");
    strE1NG2EndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1NG2EndId"]?.toString() ?? "0");
    strE2NG2StartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2NG2StartId"]?.toString() ?? "0");
    strE2NG2ToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2NG2ToAddId"]?.toString() ?? "0");
    strE2NG2EndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2NG2EndId"]?.toString() ?? "0");
    strE1CyclesStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CyclesStartId"]?.toString() ?? "0");
    strE1CyclesToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CyclesToAddId"]?.toString() ?? "0");
    strE1CyclesEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CyclesEndId"]?.toString() ?? "0");
    strE2CyclesStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CyclesStartId"]?.toString() ?? "0");
    strE2CyclesToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CyclesToAddId"]?.toString() ?? "0");
    strE2CyclesEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CyclesEndId"]?.toString() ?? "0");
    strFuelFarmFilledStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["fuelFarmFilledStartId"]?.toString() ?? "0");
    strFuelFarmFilledToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["fuelFarmFilledToAddId"]?.toString() ?? "0");
    strFuelFarmFilledEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["fuelFarmFilledEndId"]?.toString() ?? "0");
    strE1CreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CreepEndId"]?.toString() ?? "0");
    strE2CreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CreepEndId"]?.toString() ?? "0");
    strACHoistStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHoistStartId"]?.toString() ?? "0");
    strACHoistToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHoistToAddId"]?.toString() ?? "0");
    strACHoistEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHoistEndId"]?.toString() ?? "0");
    strACHookStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHookStartId"]?.toString() ?? "0");
    strACHookToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHookToAddId"]?.toString() ?? "0");
    strACHookEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["acHookEndId"]?.toString() ?? "0");
    strE3TTStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e3TTStartId"]?.toString() ?? "0");
    strE3TTToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e3TTToAddId"]?.toString() ?? "0");
    strE3TTEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e3TTEndId"]?.toString() ?? "0");
    strE3CyclesStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e3CyclesStartId"]?.toString() ?? "0");
    strE3CyclesToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e3CyclesToAddId"]?.toString() ?? "0");
    strE3CyclesEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e3CyclesEndId"]?.toString() ?? "0");

    strE1CTCoverStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CTCoverStartId"]?.toString() ?? "0");
    strE1CTCoverToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CTCoverToAddId"]?.toString() ?? "0");
    strE1CTCoverEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CTCoverEndId"]?.toString() ?? "0");
    strE2CTCoverStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CTCoverStartId"]?.toString() ?? "0");
    strE2CTCoverToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CTCoverToAddId"]?.toString() ?? "0");
    strE2CTCoverEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CTCoverEndId"]?.toString() ?? "0");
    strE1CTCreepStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CTCreepStartId"]?.toString() ?? "0");
    strE1CTCreepToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CTCreepToAddId"]?.toString() ?? "0");
    strE1CTCreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1CTCreepEndId"]?.toString() ?? "0");
    strE2CTCreepStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CTCreepStartId"]?.toString() ?? "0");
    strE2CTCreepToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CTCreepToAddId"]?.toString() ?? "0");
    strE2CTCreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2CTCreepEndId"]?.toString() ?? "0");
    strE1HPCompressorStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1HPCompressorStartId"]?.toString() ?? "0");
    strE1HPCompressorToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1HPCompressorToAddId"]?.toString() ?? "0");
    strE1HPCompressorEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1HPCompressorEndId"]?.toString() ?? "0");
    strE2HPCompressorStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2HPCompressorStartId"]?.toString() ?? "0");
    strE2HPCompressorToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2HPCompressorToAddId"]?.toString() ?? "0");
    strE2HPCompressorEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2HPCompressorEndId"]?.toString() ?? "0");
    strE1PT2DiscStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT2DiscStartId"]?.toString() ?? "0");
    strE1PT2DiscToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT2DiscToAddId"]?.toString() ?? "0");
    strE1PT2DiscEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT2DiscEndId"]?.toString() ?? "0");
    strE2PT2DiscStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT2DiscStartId"]?.toString() ?? "0");
    strE2PT2DiscToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT2DiscToAddId"]?.toString() ?? "0");
    strE2PT2DiscEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT2DiscEndId"]?.toString() ?? "0");

    strE1PT1CreepStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT1CreepStartId"]?.toString() ?? "0");
    strE1PT1CreepToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT1CreepToAddId"]?.toString() ?? "0");
    strE1PT1CreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT1CreepEndId"]?.toString() ?? "0");
    strE2PT1CreepStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT1CreepStartId"]?.toString() ?? "0");
    strE2PT1CreepToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT1CreepToAddId"]?.toString() ?? "0");
    strE2PT1CreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT1CreepEndId"]?.toString() ?? "0");
    strE1PT2CreepStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT2CreepStartId"]?.toString() ?? "0");
    strE1PT2CreepToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT2CreepToAddId"]?.toString() ?? "0");
    strE1PT2CreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e1PT2CreepEndId"]?.toString() ?? "0");
    strE2PT2CreepStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT2CreepStartId"]?.toString() ?? "0");
    strE2PT2CreepToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT2CreepToAddId"]?.toString() ?? "0");
    strE2PT2CreepEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["e2PT2CreepEndId"]?.toString() ?? "0");

    strCATAOperationsStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["caT_A_Operations_Start_Id"]?.toString() ?? "0");
    strCATAOperationsToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["caT_A_Operations_ToAdd_Id"]?.toString() ?? "0");
    strCATAOperationsEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["caT_A_Operations_End_Id"]?.toString() ?? "0");
    strAVCSINOPStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["avcS_INOP_Start_Id"]?.toString() ?? "0");
    strAVCSINOPToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["avcS_INOP_ToAdd_Id"]?.toString() ?? "0");
    strAVCSINOPEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["avcS_INOP_End_Id"]?.toString() ?? "0");
    strMTOWFHSStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["mtoW_FHS_Start_Id"]?.toString() ?? "0");
    strMTOWFHSToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["mtoW_FHS_ToAdd_Id"]?.toString() ?? "0");
    strMTOWFHSEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["mtoW_FHS_End_Id"]?.toString() ?? "0");
    strMTOWLDSStartID = int.parse(initialFillOutFormData["formFilloutMvc"]["mtoW_LDS_Start_Id"]?.toString() ?? "0");
    strMTOWLDSToAddID = int.parse(initialFillOutFormData["formFilloutMvc"]["mtoW_LDS_ToAdd_Id"]?.toString() ?? "0");
    strMTOWLDSEndID = int.parse(initialFillOutFormData["formFilloutMvc"]["mtoW_LDS_End_Id"]?.toString() ?? "0");
  }

  ///Made by Tayeb - 40% && Modified & Done by Surjit
  void doBindings({id, value}) {
    for (int i = 0; i < initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"].length; i++) {
      if (initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["cssClassName"] != null &&
          initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["cssClassName"] != '') {
        var fieldClass = initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["cssClassName"]?.toString().split(" ") ?? [];
        for (var key in fieldClass) {
          jsClass[key.trim()]?.addIf(
            jsClass[key.trim()]?.contains(initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["id"].toString()) == false,
            initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["id"].toString(),
          );
        }
      }

      if (initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["formFieldType"] == 144) {
        jsClass["raforms"]?.addIf(
          jsClass["raforms"]?.contains(initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["id"].toString()) == false,
          initialFillOutFormData["formFilloutMvc"]["objFormFieldsOnFormList"][i]["id"].toString(),
        );
      }
    }

    jsClass["raforms"]?.forEach((id) {
      attribute.addIf(true, id.toString(), {"rel": "0", "id": id.toString()});
    });

    jsClass["default_hidden"]?.forEach((id) {
      showField[id] = false;
    });

    /*jsClass["FlightDate_Older"]?.forEach((id) {
      //datepicker({ minDate: -1460, dateFormat: "mm/dd/yy", maxDate: "+1D" });
    });

    jsClass["FlightDate_New"]?.forEach((id) {
      //datepicker({ minDate: -30, maxDate: 1, dateFormat: "mm/dd/yy" });
    });

    jsClass["OtherDate"]?.forEach((id) {
      //datepicker({ dateFormat: "mm/dd/yy" });
    });

    if (jsClass["acSelector"]?.contains(id) == true) {
      jsClass["sn"]?.addIf(jsClass["sn"]?.contains(id) == false, id);
      loadACData(id: int.parse(value));
    }

    if (jsClass[".gpsDMS"]?.contains(id) == true) {
      calcGpsCoordinatesDMS(fieldId: attribute[id]?["rel"]);
    }*/

    /*if (jsClass["decimals0"]?.contains(id) == true) {
      int d = value.replace(",", "");
      if (d.isNaN || d.toString() == "") {
        d = 0;
      }

      if (jsClass["pos"]?.contains(id) == true) {
        if (d < 0) {
          d = 0;
        }
      }

      var dFinal = d;
      value[dFinal];
    }

    if (jsClass["decimals1"]?.contains(id) == true) {
      int d = value.replace(",", "");
      if (d.isNaN || d.toString() == "") {
        d = 0;
      }

      if (jsClass["pos"]?.contains(id) == true) {
        if (d < 0) {
          d = 0;
        }
      }

      var dFinal = double.parse(d as String).toStringAsFixed(1);
      value[dFinal];
    }

    if (jsClass["decimals2"]?.contains(id) == true) {
      int d = value.replace(",", "");
      if (d.isNaN || d.toString() == "") {
        d = 0;
      }

      if (jsClass["pos"]?.contains(id) == true) {
        if (d < 0) {
          d = 0;
        }
      }

      var dFinal = double.parse(d as String).toStringAsFixed(2);
      value[dFinal];
    }

    if (jsClass["decimals3"]?.contains(id) == true) {
      int d = value.replace(",", "");
      if (d.isNaN || d.toString() == "") {
        d = 0;
      }

      if (jsClass["pos"]?.contains(id) == true) {
        if (d < 0) {
          d = 0;
        }
      }

      var dFinal = double.parse(d as String).toStringAsFixed(3);
      value[dFinal];
    }

    if (jsClass["decimals4"]?.contains(id) == true) {
      int d = value.replace(",", "");
      if (d.isNaN || d.toString() == "") {
        d = 0;
      }

      if (jsClass["pos"]?.contains(id) == true) {
        if (d < 0) {
          d = 0;
        }
      }

      var dFinal = double.parse(d as String).toStringAsFixed(4);
      value[dFinal];
    }

    if (jsClass["acc"]?.isNotEmpty == true) {
      if (jsClass[".acc"]?.contains(id) == true) {
        var fieldId = id.replace("acc", "");
        if (value > 0) {
          var opt = value.find("option:selected");
          jsClass["acc"]?.add(fieldId);

          if (jsClass["acc"]?.contains(fieldId) == true) {
            jsClass["acc"]?.removeWhere((id) => id = fieldId);
          }

          jsClass["acc"]?.add(fieldId);
          jsClass["acc"]?.add("accCStart");
          jsClass["acc"]?.forEach((id) {
            values[id] = "";
          });
          attribute[opt] = "c";
          jsClass["acc"]?.removeWhere((id) => id = fieldId);

          jsClass["acc"]?.add(fieldId);
          jsClass["acc"]?.add("accCEnd");
          jsClass["acc"]?.forEach((id) {
            values[id] = "";
          });
          attribute[opt] = "c";
          jsClass["acc"]?.removeWhere((id) => id = fieldId);

          jsClass["acc"]?.add(fieldId);
          jsClass["acc"]?.add("accHStart");
          jsClass["acc"]?.forEach((id) {
            values[id] = "";
          });
          attribute[opt] = "h";
          jsClass["acc"]?.removeWhere((id) => id = fieldId);

          jsClass["acc"]?.add(fieldId);
          jsClass["acc"]?.add("accHEnd");
          jsClass["acc"]?.forEach((id) {
            values[id] = "";
          });
          attribute[opt] = "h";
          jsClass["acc"]?.removeWhere((id) => id = fieldId);
        } else {
          jsClass["acc"]?.add(fieldId);

          if (jsClass["acc"]?.contains(fieldId) == true) {
            jsClass["acc"]?.removeWhere((id) => id = fieldId);
          }

          await checkForm(doSave: false, fieldId: fieldId);
        }
      }

      if (jsClass["accNum"]?.contains(id) == true) {
        accValChanged(
            fieldId: int.parse(attribute[id]["rel"]), cycOrHobbs: int.parse(attribute[id]["numtype"]), fieldNumber: int.parse(attribute[id]["fieldnum"]));
      }
    }*/
  }

  ///Made by Rahat - 40% && Modified & Done by Surjit
  void calcGpsCoordinatesDMS({fieldId}) {
    values[fieldId.toString()] = "${values["${fieldId}gpsN0"]}° ${values["${fieldId}gpsN1"]}'\"N ${values["${fieldId}gpsW0"]}° ${values["${fieldId}gpsW1"]}'\"W";
  }

  ///Done by Rahat - 100% - TODO: Called from doBindings but Not Used
  void accValChanged({fieldId, cycOrHobbs, fieldNumber}) {
    int decimals;
    String fieldStart;
    String fieldToAdd;
    String fieldEnd;
    double nStart;
    double nToAdd;
    double nEnd;

    if (cycOrHobbs == 0) {
      decimals = 0;
      fieldStart = fieldId;
      jsClass["accCStart"]?.addIf(jsClass["accCStart"]?.contains(fieldId) == false, fieldId);
      fieldToAdd = fieldId;
      jsClass["accCAdd"]?.addIf(jsClass["accCAdd"]?.contains(fieldId) == false, fieldId);
      fieldEnd = fieldId;
      jsClass["accCEnd"]?.addIf(jsClass["accCEnd"]?.contains(fieldId) == false, fieldId);
    } else {
      decimals = 1;
      fieldStart = fieldId;
      jsClass["accHStart"]?.addIf(jsClass["accHStart"]?.contains(fieldId) == false, fieldId);
      fieldToAdd = fieldId;
      jsClass["accHAdd"]?.addIf(jsClass["accHAdd"]?.contains(fieldId) == false, fieldId);
      fieldEnd = fieldId;
      jsClass["accHEnd"]?.addIf(jsClass["accHEnd"]?.contains(fieldId) == false, fieldId);
    }

    nStart = double.parse(fieldStart.replaceAll(RegExp('[^0-9]'), ''));
    nToAdd = double.parse(fieldToAdd.replaceAll(RegExp('[^0-9]'), ''));
    nEnd = double.parse(fieldEnd.replaceAll(RegExp('^0-9'), ''));

    if (nStart.isNaN || nStart < 0) {
      nStart = 0;
    }
    if (nToAdd.isNaN || nToAdd < 0) {
      nToAdd = 0;
    }
    if (nEnd.isNaN || nEnd < 0) {
      nEnd = 0;
    }

    switch (fieldNumber) {
      case 0:
        {
          nEnd = nStart + nToAdd;
          break;
        }
      case 1:
        {
          nEnd = nStart + nToAdd;
          break;
        }
      default:
        {
          nToAdd = nEnd - nStart;
          break;
        }
    }
    fieldStart = nStart.toStringAsFixed(decimals);
    fieldToAdd = nToAdd.toStringAsFixed(decimals);
    fieldEnd = nEnd.toStringAsFixed(decimals);
  }

  ///Made by Tayeb - 60% && Modified & Done by Surjit
  Future<void> loadACData({id}) async {
    Response response = await formsApiProvider.generalAPICall(
      apiCallType: "POST",
      url: "/forms/load_ac_data",
      postData: {"system_id": UserSessionInfo.systemId.toString(), "user_id": UserSessionInfo.userId.toString(), "aircraft_id": id.toString()},
    );
    if (response.statusCode == 200) {
      var data = response.data["data"];
      var loadACDataList = {};

      data.forEach((item, value) {
        loadACDataList.addAll(value);

        loadACDataList.forEach((i, v) {
          var thisDataFieldID = i;
          var thisDataFieldValue = v;
          var strFinalVarName1 = "";
          var strFinalVarName2 = "";
          var strFinalVarToClear = "";

          switch (int.tryParse(thisDataFieldID)) {
            case 8: //FH
              strFinalVarName1 = strACHobbsStartID.toString();
              strFinalVarName2 = strACHobbsEndID.toString();
              strFinalVarToClear = strACHobbsToAddID.toString();
              break;
            case 9: //BH
              strFinalVarName1 = strACBillableStartID.toString();
              strFinalVarName2 = strACBillableEndID.toString();
              strFinalVarToClear = strACBillableToAddID.toString();
              break;
            case 12: //NG-Starts E1
              strFinalVarName1 = strACStartsStartID.toString();
              strFinalVarName2 = strACStartsEndID.toString();
              strFinalVarToClear = strACStartsToAddID.toString();
              break;
            case 14: //NG-Starts E2
              strFinalVarName1 = strACStarts2StartID.toString();
              strFinalVarName2 = strACStarts2EndID.toString();
              strFinalVarToClear = strACStarts2ToAddID.toString();
              break;
            case 33: //Torque Events
              strFinalVarName1 = strACTEStartID.toString();
              strFinalVarName2 = strACTEEndID.toString();
              strFinalVarToClear = strACTEToAddID.toString();
              break;
            case 29: //Landings
              strFinalVarName1 = strACLandingsStartID.toString();
              strFinalVarName2 = strACLandingsEndID.toString();
              strFinalVarToClear = strACLandingsToAddID.toString();
              break;
            case 44: //Hoist
              strFinalVarName1 = strACHoistStartID.toString();
              strFinalVarName2 = strACHoistEndID.toString();
              strFinalVarToClear = strACHoistToAddID.toString();
              break;
            case 47: //Hook
              strFinalVarName1 = strACHookStartID.toString();
              strFinalVarName2 = strACHookEndID.toString();
              strFinalVarToClear = strACHookToAddID.toString();
              break;
            case 13: //NP1
              strFinalVarName1 = strACNPStartID.toString();
              strFinalVarName2 = strACNPEndID.toString();
              strFinalVarToClear = strACNPToAddID.toString();
              break;
            case 15: //NP2
              strFinalVarName1 = strACNP2StartID.toString();
              strFinalVarName2 = strACNP2EndID.toString();
              strFinalVarToClear = strACNP2ToAddID.toString();
              break;
            case 76: //E1TT
              strFinalVarName1 = strE1TTStartID.toString();
              strFinalVarName2 = strE1TTEndID.toString();
              strFinalVarToClear = strE1TTToAddID.toString();
              break;
            case 79: //E2TT
              strFinalVarName1 = strE2TTStartID.toString();
              strFinalVarName2 = strE2TTEndID.toString();
              strFinalVarToClear = strE2TTToAddID.toString();
              break;
            case 82: //APU TT
              strFinalVarName1 = strAPUTTStartID.toString();
              strFinalVarName2 = strAPUTTEndID.toString();
              strFinalVarToClear = strAPUTTToAddID.toString();
              break;
            case 85: //E1NG2
              strFinalVarName1 = strE1NG2StartID.toString();
              strFinalVarName2 = strE1NG2EndID.toString();
              strFinalVarToClear = strE1NG2ToAddID.toString();
              break;
            case 88: //E2NG2
              strFinalVarName1 = strE2NG2StartID.toString();
              strFinalVarName2 = strE2NG2EndID.toString();
              strFinalVarToClear = strE2NG2ToAddID.toString();
              break;
            case 94: //Run On Landings
              strFinalVarName1 = strACRunOnLandingsStartID.toString();
              strFinalVarName2 = strACRunOnLandingsEndID.toString();
              strFinalVarToClear = strACRunOnLandingsToAddID.toString();
              break;
            case 131: //E1 Cycles Pratt
              strFinalVarName1 = strE1CyclesStartID.toString();
              strFinalVarName2 = strE1CyclesEndID.toString();
              strFinalVarToClear = strE1CyclesToAddID.toString();
              break;
            case 134: //E2 Cycles Pratt
              strFinalVarName1 = strE2CyclesStartID.toString();
              strFinalVarName2 = strE2CyclesEndID.toString();
              strFinalVarToClear = strE2CyclesToAddID.toString();
              break;
            case 145: //AuxHobbs
              strFinalVarName1 = strAuxHobbsStartID.toString();
              strFinalVarName2 = strAuxHobbsEndID.toString();
              strFinalVarToClear = strAuxHobbsToAddID.toString();
              break;
            case 151: //AC TT
              strFinalVarName1 = strACTTStartID.toString();
              strFinalVarName2 = strACTTEndID.toString();
              strFinalVarToClear = strACTTToAddID.toString();
              break;
            case 154: //E1 Creep Damage
              strFinalVarName1 = "";
              strFinalVarName2 = strE1CreepEndID.toString();
              strFinalVarToClear = "";
              break;
            case 155: //E2 Creep Damage
              strFinalVarName1 = "";
              strFinalVarName2 = strE2CreepEndID.toString();
              strFinalVarToClear = "";
              break;
            case 1000: //Starts Name
              strStartsName = thisDataFieldValue;
              break;
            case 1001: //Billable Hobbs Name
              strBillableHobbsName = thisDataFieldValue;
              break;
            case 1002: //Engine 2 Enabled?
              strEngine2Enabled = thisDataFieldValue;
              break;
            case 104: //E3TT
              strFinalVarName1 = strE3TTStartID.toString();
              strFinalVarName2 = strE3TTEndID.toString();
              strFinalVarToClear = strE3TTToAddID.toString();
              break;
            case 97: //E3Cycles
              strFinalVarName1 = strE3CyclesStartID.toString();
              strFinalVarName2 = strE3CyclesEndID.toString();
              strFinalVarToClear = strE3CyclesToAddID.toString();
              break;

            case 175: //ENG1_HP_Compressor
              strFinalVarName1 = strE1HPCompressorStartID.toString();
              strFinalVarName2 = strE1HPCompressorEndID.toString();
              strFinalVarToClear = strE1HPCompressorToAddID.toString();
              break;
            case 178: //ENG2_HP_Compressor
              strFinalVarName1 = strE2HPCompressorStartID.toString();
              strFinalVarName2 = strE2HPCompressorEndID.toString();
              strFinalVarToClear = strE2HPCompressorToAddID.toString();
              break;
            case 163: //E1CTCover
              strFinalVarName1 = strE1CTCoverStartID.toString();
              strFinalVarName2 = strE1CTCoverEndID.toString();
              strFinalVarToClear = strE1CTCoverToAddID.toString();
              break;
            case 166: //E2CTCover
              strFinalVarName1 = strE2CTCoverStartID.toString();
              strFinalVarName2 = strE2CTCoverEndID.toString();
              strFinalVarToClear = strE2CTCoverToAddID.toString();
              break;
            case 169: //ENG1_CT_Creep
              strFinalVarName1 = strE1CTCreepStartID.toString();
              strFinalVarName2 = strE1CTCreepEndID.toString();
              strFinalVarToClear = strE1CTCreepToAddID.toString();
              break;
            case 172: //ENG2_CT_Creep
              strFinalVarName1 = strE2CTCreepStartID.toString();
              strFinalVarName2 = strE2CTCreepEndID.toString();
              strFinalVarToClear = strE2CTCreepToAddID.toString();
              break;
            case 181: //E1PT1_Creep
              strFinalVarName1 = strE1PT1CreepStartID.toString();
              strFinalVarName2 = strE1PT1CreepEndID.toString();
              strFinalVarToClear = strE1PT1CreepToAddID.toString();
              break;
            case 184: //E2PT1_Creep
              strFinalVarName1 = strE2PT1CreepStartID.toString();
              strFinalVarName2 = strE2PT1CreepEndID.toString();
              strFinalVarToClear = strE2PT1CreepToAddID.toString();
              break;
            case 187: //E1PT2_Creep
              strFinalVarName1 = strE1PT2CreepStartID.toString();
              strFinalVarName2 = strE1PT2CreepEndID.toString();
              strFinalVarToClear = strE1PT2CreepToAddID.toString();
              break;
            case 190: //E2PT2_Creep
              strFinalVarName1 = strE2PT2CreepStartID.toString();
              strFinalVarName2 = strE2PT2CreepEndID.toString();
              strFinalVarToClear = strE2PT2CreepToAddID.toString();
              break;
            case 193: //ENG1_PT2_Disc
              strFinalVarName1 = strE1PT2DiscStartID.toString();
              strFinalVarName2 = strE1PT2DiscEndID.toString();
              strFinalVarToClear = strE1PT2DiscToAddID.toString();
              break;
            case 196: //ENG2_PT2_Disc
              strFinalVarName1 = strE2PT2DiscStartID.toString();
              strFinalVarName2 = strE2PT2DiscEndID.toString();
              strFinalVarToClear = strE2PT2DiscToAddID.toString();
              break;
            case 251: //CAT_A_Operations
              strFinalVarName1 = strCATAOperationsStartID.toString();
              strFinalVarName2 = strCATAOperationsEndID.toString();
              strFinalVarToClear = strCATAOperationsToAddID.toString();
              break;
            case 254: //AVCS_INOP
              strFinalVarName1 = strAVCSINOPStartID.toString();
              strFinalVarName2 = strAVCSINOPEndID.toString();
              strFinalVarToClear = strAVCSINOPToAddID.toString();
              break;
            case 257: //MTOW_FHS
              strFinalVarName1 = strMTOWFHSStartID.toString();
              strFinalVarName2 = strMTOWFHSEndID.toString();
              strFinalVarToClear = strMTOWFHSToAddID.toString();
              break;
            case 260: //MTOW_LDS
              strFinalVarName1 = strMTOWLDSStartID.toString();
              strFinalVarName2 = strMTOWLDSEndID.toString();
              strFinalVarToClear = strMTOWLDSToAddID.toString();
              break;
          }

          if (strFinalVarName1.isNotEmpty && strFinalVarName1 != "0") {
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strFinalVarName1) == false, strFinalVarName1);
            values[strFinalVarName1] = thisDataFieldValue;
            //values.addIf(strFinalVarName1.isNotEmpty, strFinalVarName1, thisDataFieldValue);
          }

          if (strFinalVarName2.isNotEmpty && strFinalVarName2 != "0") {
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strFinalVarName2) == false, strFinalVarName2);
            values[strFinalVarName2] = thisDataFieldValue;
            //values.addIf(strFinalVarName2.isNotEmpty, strFinalVarName2, thisDataFieldValue);
          }

          if (strFinalVarToClear.isNotEmpty && strFinalVarToClear != "0") {
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strFinalVarToClear) == false, strFinalVarToClear);
            values[strFinalVarToClear] = "0";
            //values.addIf(strFinalVarToClear.isNotEmpty, strFinalVarToClear, "0");
          }
        });
      });
      await setupAircraftFields(strStartsName: strStartsName, strBillableHobbsName: strBillableHobbsName, strEngine2Enabled: strEngine2Enabled);
    }
  }

  ///Made by Tayeb - 50% && Modified & Done by Surjit
  Future<void> setupAircraftFields({strStartsName, strBillableHobbsName, strEngine2Enabled}) async {
    jsClass["EngineNP"]?.forEach((id) {
      showField[id] = true;
    });
    jsClass["EngineNG2"]?.forEach((id) {
      showField[id] = true;
    });
    jsClass["EngineCycles"]?.forEach((id) {
      showField[id] = true;
    });

    jsClass["lblNPName"]?.forEach((id) {
      htmlValues[id] = "NP/NF";
    });
    jsClass["lblStartsName"]?.forEach((id) {
      htmlValues[id] = "Starts";
    });
    jsClass["lblNG2Name"]?.forEach((id) {
      htmlValues[id] = "N2";
    });
    jsClass["lblCyclesName"]?.forEach((id) {
      htmlValues[id] = "Cycles";
    });

    if (strEngine2Enabled == "false") {
      jsClass["Engine2Fields"]?.forEach((id) {
        showField[id] = false;
      });
    } else {
      jsClass["Engine2Fields"]?.forEach((id) {
        showField[id] = true;
      });
    }

    if (strBillableHobbsName == "") {
      strBillableHobbsName = "Billable Hobbs";
    }

    jsClass["Billable_Hobbs_Name"]?.forEach((id) {
      htmlValues[id] = strBillableHobbsName;
    });

    switch (strStartsName) {
      case "STARTS":
        jsClass["lblStartsName"]?.forEach((id) {
          htmlValues[id] = "Starts";
        });
        jsClass["EngineNP"]?.forEach((id) {
          showField[id] = false;
        });
        jsClass["EngineNG2"]?.forEach((id) {
          showField[id] = false;
        });
        jsClass["EngineCycles"]?.forEach((id) {
          showField[id] = false;
        });
        break;
      case 'N1N2':
        jsClass["lblStartsName"]?.forEach((id) {
          htmlValues[id] = "N1";
        });
        jsClass["lblNG2Name"]?.forEach((id) {
          htmlValues[id] = "N2";
        });
        jsClass["EngineNP"]?.forEach((id) {
          showField[id] = false;
        });
        jsClass["EngineCycles"]?.forEach((id) {
          showField[id] = false;
        });
        break;
      case 'NPNG':
        jsClass["lblStartsName"]?.forEach((id) {
          htmlValues[id] = "NG";
        });
        jsClass["lblNPName"]?.forEach((id) {
          htmlValues[id] = "NP/NF";
        });
        jsClass["EngineNG2"]?.forEach((id) {
          showField[id] = false;
        });
        jsClass["EngineCycles"]?.forEach((id) {
          showField[id] = false;
        });
        break;
      case 'IPC':
        jsClass["lblStartsName"]?.forEach((id) {
          htmlValues[id] = "CCY";
        });
        jsClass["lblNPName"]?.forEach((id) {
          htmlValues[id] = "ICY";
        });
        jsClass["lblNG2Name"]?.forEach((id) {
          htmlValues[id] = "PCY";
        });
        break;

      case 'IMPPTCT':
        jsClass["lblStartsName"]?.forEach((id) {
          htmlValues[id] = "CT Disc";
        });
        jsClass["lblNPName"]?.forEach((id) {
          htmlValues[id] = "Impeller";
        });
        jsClass["lblNG2Name"]?.forEach((id) {
          htmlValues[id] = "PT 1 Disc";
        });
        break;
      default:
    }
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  void updateFlightCalculations({strType, strMode}) {
    var strBeginningID = 0;
    var strToAddID = 0;
    var strEndingID = 0;

    var strBeginningValue = '0';
    var strToAddValue = '0';
    var strEndingValue = '0';
    var strNumberOfDecimals = 0;

    switch (strType) {
      case 'ACTT':
        strBeginningID = strACTTStartID;
        strToAddID = strACTTToAddID;
        strEndingID = strACTTEndID;
        strNumberOfDecimals = 1;
        break;
      case 'AuxHobbs':
        strBeginningID = strAuxHobbsStartID;
        strToAddID = strAuxHobbsToAddID;
        strEndingID = strAuxHobbsEndID;
        strNumberOfDecimals = 1;
        break;
      case 'FuelFarm':
        strBeginningID = strFuelFarmFilledStartID;
        strToAddID = strFuelFarmFilledToAddID;
        strEndingID = strFuelFarmFilledEndID;
        strNumberOfDecimals = 1;
        break;
      case 'ACHobbs':
        strBeginningID = strACHobbsStartID;
        strToAddID = strACHobbsToAddID;
        strEndingID = strACHobbsEndID;
        strNumberOfDecimals = 1;
        break;
      case 'BillableHobbs':
        strBeginningID = strACBillableStartID;
        strToAddID = strACBillableToAddID;
        strEndingID = strACBillableEndID;
        strNumberOfDecimals = 1;
        break;
      case 'Engine_1_Starts':
        strBeginningID = strACStartsStartID;
        strToAddID = strACStartsToAddID;
        strEndingID = strACStartsEndID;
        switch (strStartsName) {
          case 'N1N2':
          case 'NPNG':
            strNumberOfDecimals = 2;
            break;
          default:
            strNumberOfDecimals = 0;
        }
        break;
      case 'Engine_2_Starts':
        strBeginningID = strACStarts2StartID;
        strToAddID = strACStarts2ToAddID;
        strEndingID = strACStarts2EndID;
        switch (strStartsName) {
          case 'N1N2':
          case 'NPNG':
            strNumberOfDecimals = 2;
            break;
          default:
            strNumberOfDecimals = 0;
        }
        break;
      case 'Engine_3_Starts':
        strBeginningID = strE3CyclesStartID;
        strToAddID = strE3CyclesToAddID;
        strEndingID = strE3CyclesEndID;
        switch (strStartsName) {
          case 'N1N2':
          case 'NPNG':
            strNumberOfDecimals = 2;
            break;
          default:
            strNumberOfDecimals = 0;
        }
        break;
      case 'Torque_Events':
        strBeginningID = strACTEStartID;
        strToAddID = strACTEToAddID;
        strEndingID = strACTEEndID;
        break;
      case 'Landings':
        strBeginningID = strACLandingsStartID;
        strToAddID = strACLandingsToAddID;
        strEndingID = strACLandingsEndID;
        break;
      case 'RunOnLandings':
        strBeginningID = strACRunOnLandingsStartID;
        strToAddID = strACRunOnLandingsToAddID;
        strEndingID = strACRunOnLandingsEndID;
        break;
      case 'HoistCycles':
        strBeginningID = strACHoistStartID;
        strToAddID = strACHoistToAddID;
        strEndingID = strACHoistEndID;
        break;
      case 'HookCycles':
        strBeginningID = strACHookStartID;
        strToAddID = strACHookToAddID;
        strEndingID = strACHookEndID;
        break;
      case 'Engine_1_NP':
        strBeginningID = strACNPStartID;
        strToAddID = strACNPToAddID;
        strEndingID = strACNPEndID;
        strNumberOfDecimals = 2;
        break;
      case 'Engine_2_NP':
        strBeginningID = strACNP2StartID;
        strToAddID = strACNP2ToAddID;
        strEndingID = strACNP2EndID;
        strNumberOfDecimals = 2;
        break;
      case 'E1TT':
        strBeginningID = strE1TTStartID;
        strToAddID = strE1TTToAddID;
        strEndingID = strE1TTEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2TT':
        strBeginningID = strE2TTStartID;
        strToAddID = strE2TTToAddID;
        strEndingID = strE2TTEndID;
        strNumberOfDecimals = 1;
        break;
      case 'APUTT':
        strBeginningID = strAPUTTStartID;
        strToAddID = strAPUTTToAddID;
        strEndingID = strAPUTTEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E1NG2':
        strBeginningID = strE1NG2StartID;
        strToAddID = strE1NG2ToAddID;
        strEndingID = strE1NG2EndID;
        strNumberOfDecimals = 2;
        break;
      case 'E2NG2':
        strBeginningID = strE2NG2StartID;
        strToAddID = strE2NG2ToAddID;
        strEndingID = strE2NG2EndID;
        strNumberOfDecimals = 2;
        break;
      case 'E1Cycles':
        strBeginningID = strE1CyclesStartID;
        strToAddID = strE1CyclesToAddID;
        strEndingID = strE1CyclesEndID;
        break;
      case 'E2Cycles':
        strBeginningID = strE2CyclesStartID;
        strToAddID = strE2CyclesToAddID;
        strEndingID = strE2CyclesEndID;
        break;
      case 'E3TT':
        strBeginningID = strE3TTStartID;
        strToAddID = strE3TTToAddID;
        strEndingID = strE3TTEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E3Cycles':
        strBeginningID = strE3CyclesStartID;
        strToAddID = strE3CyclesToAddID;
        strEndingID = strE3CyclesEndID;
        strNumberOfDecimals = 1;
        break;

      case 'E1CTCover':
        strBeginningID = strE1CTCoverStartID;
        strToAddID = strE1CTCoverToAddID;
        strEndingID = strE1CTCoverEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2CTCover':
        strBeginningID = strE2CTCoverStartID;
        strToAddID = strE2CTCoverToAddID;
        strEndingID = strE2CTCoverEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E1CTCreep':
        strBeginningID = strE1CTCreepStartID;
        strToAddID = strE1CTCreepToAddID;
        strEndingID = strE1CTCreepEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2CTCreep':
        strBeginningID = strE2CTCreepStartID;
        strToAddID = strE2CTCreepToAddID;
        strEndingID = strE2CTCreepEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E1HPCompressor':
        strBeginningID = strE1HPCompressorStartID;
        strToAddID = strE1HPCompressorToAddID;
        strEndingID = strE1HPCompressorEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2HPCompressor':
        strBeginningID = strE2HPCompressorStartID;
        strToAddID = strE2HPCompressorToAddID;
        strEndingID = strE2HPCompressorEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E1PT2Disc':
        strBeginningID = strE1PT2DiscStartID;
        strToAddID = strE1PT2DiscToAddID;
        strEndingID = strE1PT2DiscEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2PT2Disc':
        strBeginningID = strE2PT2DiscStartID;
        strToAddID = strE2PT2DiscToAddID;
        strEndingID = strE2PT2DiscEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E1PT1Creep':
        strBeginningID = strE1PT1CreepStartID;
        strToAddID = strE1PT1CreepToAddID;
        strEndingID = strE1PT1CreepEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2PT1Creep':
        strBeginningID = strE2PT1CreepStartID;
        strToAddID = strE2PT1CreepToAddID;
        strEndingID = strE2PT1CreepEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E1PT2Creep':
        strBeginningID = strE1PT2CreepStartID;
        strToAddID = strE1PT2CreepToAddID;
        strEndingID = strE1PT2CreepEndID;
        strNumberOfDecimals = 1;
        break;
      case 'E2PT2Creep':
        strBeginningID = strE2PT2CreepStartID;
        strToAddID = strE2PT2CreepToAddID;
        strEndingID = strE2PT2CreepEndID;
        strNumberOfDecimals = 1;
        break;
      case 'CAT_A_Operations':
        strBeginningID = strCATAOperationsStartID;
        strToAddID = strCATAOperationsToAddID;
        strEndingID = strCATAOperationsEndID;
        strNumberOfDecimals = 1;
        break;
      case 'AVCS_INOP_Operations':
        strBeginningID = strAVCSINOPStartID;
        strToAddID = strAVCSINOPToAddID;
        strEndingID = strAVCSINOPEndID;
        strNumberOfDecimals = 1;
        break;
      case 'MTOW_FHS_Operations':
        strBeginningID = strMTOWFHSStartID;
        strToAddID = strMTOWFHSToAddID;
        strEndingID = strMTOWFHSEndID;
        strNumberOfDecimals = 1;
        break;
      case 'MTOW_LDS_Operations':
        strBeginningID = strMTOWLDSStartID;
        strToAddID = strMTOWLDSToAddID;
        strEndingID = strMTOWLDSEndID;
        strNumberOfDecimals = 1;
        break;
      default:
    }
    /*strBeginningID = int.parse(strBeginningID);
    strToAddID = int.parse(strToAddID);
    strEndingID = int.parse(strEndingID);*/
    if (strBeginningID.isNaN) {
      strBeginningID = 0;
    }
    if (strToAddID.isNaN) {
      strToAddID = 0;
    }
    if (strEndingID.isNaN) {
      strEndingID = 0;
    }

    if (strBeginningID > 0 && strToAddID > 0 && strEndingID > 0) {
      strBeginningValue = values[strBeginningID.toString()] ?? '0';
      strToAddValue = values[strToAddID.toString()] ?? '0';
      strEndingValue = values[strEndingID.toString()] ?? '0';

      if (strBeginningValue == '.') {
        strBeginningValue = '0.';
        values[strBeginningID.toString()] = '0.';
      }
      if (strToAddValue == '.') {
        strToAddValue = '0.';
        values[strToAddID.toString()] = '0.';
      }
      if (strEndingValue == '.') {
        strEndingValue = '0.';
        values[strEndingID.toString()] = '0.';
      }

      strBeginningValue = strBeginningValue.replaceAll('\$', '').replaceAll(',', '');
      strToAddValue = strToAddValue.replaceAll('\$', '').replaceAll(',', '');
      strEndingValue = strEndingValue.replaceAll('\$', '').replaceAll(',', '');

      if (strMode == 1 || strMode == 2) {
        //Forward + To Add = Total
        if ((num.tryParse(strBeginningValue)?.isNaN ?? true) == false && (num.tryParse(strToAddValue)?.isNaN ?? true) == false) {
          values[strEndingID.toString()] = (num.parse(strBeginningValue) + num.parse(strToAddValue)).toStringAsFixed(strNumberOfDecimals);
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strEndingID.toString()) == false, strEndingID.toString());
        } else {
          var strMessage = 'Please Verify Your $strType Values: \n';
          if (num.parse(strBeginningValue).isNaN) {
            strMessage = "$strMessage $strType Beginning: $strBeginningValue Is Not A Numerical Value";

            values[strBeginningID.toString()] = '0';
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strBeginningID.toString()) == false, strBeginningID.toString());
          }
          if (num.parse(strToAddValue).isNaN) {
            strMessage = "$strMessage $strType To Augment: $strToAddValue Is Not A Numerical Value";
            if (strType != 'FuelFarm') {
              values[strToAddID.toString()] = '0';
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strToAddID.toString()) == false, strToAddID.toString()); //If this is a fuel farm update, allow negative numbers
            }
          }
          SnackBarHelper.openSnackBar(isError: true, message: strMessage);
        }
      }
      if (strMode == 3) {
        // To Add = forward - Total
        if ((num.tryParse(strBeginningValue)?.isNaN ?? true) == false && (num.tryParse(strEndingValue)?.isNaN ?? true) == false) {
          values[strToAddID.toString()] = (double.parse(strEndingValue) - double.parse(strBeginningValue)).toStringAsFixed(strNumberOfDecimals);
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strToAddID.toString()) == false, strToAddID.toString());
        } else {
          var strMessage = 'Please Verify Your $strType Values: \n';
          if (num.parse(strBeginningValue).isNaN) {
            strMessage = "$strMessage $strType Beginning $strBeginningValue Is Not A Numerical value";
            values[strBeginningID.toString()] = '0';
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strBeginningID.toString()) == false, strBeginningID.toString());
          }
          if (num.parse(strEndingValue).isNaN) {
            strMessage = "$strMessage $strType Ending $strEndingValue Is Not A Numerical Value";
            values[strEndingID.toString()] = '0';
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strEndingID.toString()) == false, strEndingID.toString());
          }
          SnackBarHelper.openSnackBar(isError: true, message: strMessage);
        }
      }
      if (strPICFieldID > 0) {
        if (strType == strPICFieldBasis) {
          if (strPICFieldBasis == 'BillableHobbs') {
            if ((num.tryParse(values[strToAddID.toString()] ?? "")?.isNaN ?? true) == false && strPICFieldID.toString() != '0') {
              values[strPICFieldID.toString()] = values[strToAddID.toString()] ?? "";
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strPICFieldID.toString()) == false, strPICFieldID.toString());
            }
          }
          if (strPICFieldBasis == 'ACHobbs') {
            if ((num.tryParse(values[strToAddID.toString()] ?? "")?.isNaN ?? true) == false && strPICFieldID.toString() != '0') {
              values[strPICFieldID.toString()] = values[strToAddID.toString()] ?? "";
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strPICFieldID.toString()) == false, strPICFieldID.toString());
            }
          }
        }
      }
      if (strSICFieldID > 0) {
        if (strType == strPICFieldBasis) {
          if (strPICFieldBasis == 'BillableHobbs') {
            if ((num.tryParse(values[strToAddID.toString()] ?? "")?.isNaN ?? true) == false && strSICFieldID.toString() != '0') {
              values[strSICFieldID.toString()] = values[strToAddID.toString()] ?? "";
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strSICFieldID.toString()) == false, strSICFieldID.toString());
            }
          }
          if (strPICFieldBasis == 'ACHobbs') {
            if ((num.tryParse(values[strToAddID.toString()] ?? "")?.isNaN ?? true) == false && strSICFieldID.toString() != '0') {
              values[strSICFieldID.toString()] = values[strToAddID.toString()] ?? "";
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strSICFieldID.toString()) == false, strSICFieldID.toString());
            }
          }
        }
      }
    }
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  void changePICTime() {
    if (strPICFieldID != 0 && strACHobbsStartID != 0 && strACHobbsEndID != 0) {
      var strEndingTime = num.tryParse(values[strACHobbsEndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
      var strBeginningTime = num.tryParse(values[strACHobbsStartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
      if (strEndingTime.isNaN == false || strBeginningTime.isNaN == false) {
        strEndingTime = (strEndingTime - strBeginningTime);
        if (strEndingTime > 10) {
          SnackBarHelper.openSnackBar(isError: true, message: "PIC Time Is Calculated As > 10 Hours. Verify Your Ending Time (${strEndingTime.toStringAsFixed(1)} > 10)");
        }
        values[strPICFieldID.toString()] = strEndingTime.toStringAsFixed(1);
      }
    }
  }

  ///Made by Tayeb - 80% && Modified & Done by Surjit
  Future<void> checkTriggersForPriorValues() async {
    //If User has already filled out a value that triggers sub choices, so force to run on form load. (System 68/Form408=MissionType Which Triggers Activity Values)
    for (var i = 0; i < arrRulesRows; i++) {
      var strThisFieldId = arrRules[0][i];
      if (arrRules[1][i] == "7") {
        await checkForm(doSave: false, fieldId: strThisFieldId);
      }
    }
  }

  ///Made & Done by Surjit - 100%
  Future<void> checkForm({required bool doSave, String? fieldId}) async {
    try {
      //------------------- Do We Need Any Automatic Rule Checks? ---------------------
      if (arrRulesRows > 0 && fieldId != null /*undefined*/ ) {
        //arrRules[0][i] = Trigger Field ID
        //arrRules[1][i] = Rule Type (1=Get Demos)
        //arrRules[2][i] = Return Type (1=DOB)
        //arrRules[3][i] = Output Action (0=Set Value As)
        //arrRules[4][i] = Output Field ID
        //arrRules[5][i] = Field Comparison Value
        for (var i = 0; i < arrRulesRows; i++) {
          if (fieldId == arrRules[0][i]) {
            var thisValue = values[fieldId.toString()] ?? "";
            switch (arrRules[1][i]) {
              case '1': //Get Demographics 1=User, 2=Aircraft
                //Rule type 1 does not exist in database
                Response response = await formsApiProvider.generalAPICall(
                  apiCallType: "POST",
                  url: "/forms/checkForm",
                  postData: {
                    "systemId": UserSessionInfo.systemId.toString(),
                    "userId": UserSessionInfo.userId.toString(),
                    "ruleType": RegExp.escape(arrRules[1][i]?.toString() ?? ""),
                    "return": RegExp.escape(arrRules[2][i]?.toString() ?? ""),
                    "value": thisValue,
                    "comparisonValue": RegExp.escape(arrRules[5][i]?.toString() ?? ""),
                    "miscField": RegExp.escape(arrRules[6][i]?.toString() ?? ""),
                    "parentId": "",
                  },
                );
                if (response.statusCode == 200) {
                  values[arrRules[4][i]?.toString() ?? ""] = response.data["data"] ?? "";
                  jsClass["sn"]?.addIf(jsClass["sn"]?.contains(arrRules[4][i]?.toString() ?? "") == false, arrRules[4][i]?.toString() ?? "");
                }
                break;
              case '3': //Get Demographics 1=User, 2=Aircraft
                // We have not found any call of check form for Rule type 3
                Response response = await formsApiProvider.generalAPICall(
                  apiCallType: "POST",
                  url: "/forms/checkForm",
                  postData: {
                    "systemId": UserSessionInfo.systemId.toString(),
                    "userId": UserSessionInfo.userId.toString(),
                    "ruleType": RegExp.escape(arrRules[1][i]?.toString() ?? ""),
                    "return": RegExp.escape(arrRules[2][i]?.toString() ?? ""),
                    "value": thisValue,
                    "comparisonValue": RegExp.escape(arrRules[5][i]?.toString() ?? ""),
                    "miscField": "",
                    "parentId": "",
                  },
                );
                if (response.statusCode == 200) {
                  values[arrRules[4][i]?.toString() ?? ""] = response.data["data"] ?? "";
                  jsClass["sn"]?.addIf(jsClass["sn"]?.contains(arrRules[4][i]?.toString() ?? "") == false, arrRules[4][i]?.toString() ?? "");
                }
                break;
              case '4': //METAR List
                //Metar data scrapping hasn't finished
                var thisFieldToReplace = arrRules[4][i]; //i gets re-assigned with function below so we save it.
                var runMetar = false;
                switch (arrRules[3][i]) {
                  case '0': //Equal To
                    if (arrRules[5][i] == thisValue) {
                      runMetar = true;
                    }
                    break;
                  case '1': //Not Equal To
                    if (arrRules[5][i] != thisValue) {
                      runMetar = true;
                    }
                    break;
                  case '2': //Is Blank
                    if (thisValue == '') {
                      runMetar = true;
                    }
                    break;
                  case '3': //Not Blank
                    if (thisValue != '') {
                      runMetar = true;
                    }
                    break;
                  case '4': //Greater Than
                    if (int.tryParse(thisValue)?.isNaN ?? true) {
                      thisValue = "0";
                    }
                    if (int.tryParse(arrRules[5][i])?.isNaN ?? true) {
                      arrRules[5][i] = 0;
                    }
                    if ((int.tryParse(thisValue) ?? 0) > arrRules[5][i]) {
                      runMetar = true;
                    }
                    break;
                  case '5': //Less Than
                    if (int.tryParse(thisValue)?.isNaN ?? true) {
                      thisValue = "0";
                    }
                    if (int.tryParse(arrRules[5][i])?.isNaN ?? true) {
                      arrRules[5][i] = 0;
                    }
                    if ((int.tryParse(thisValue) ?? 0) < arrRules[5][i]) {
                      runMetar = true;
                    }
                    break;
                  case '6': //Checked
                    if (thisValue == 'off') {
                      runMetar = true;
                    } //2020-02-19 - Was on but Seminole County Notams was not triggering.
                    break;
                  case '7': //Not Checked
                    if (thisValue == 'on') {
                      runMetar = true;
                    }
                    break;
                  default:
                    if (kDebugMode) {
                      SnackBarHelper.openSnackBar(isError: true, message: "Found Error in CheckForm: Unknown Comparison Type");
                    }
                }
                if (runMetar) {
                  Response response = await formsApiProvider.proxyMetar(id: RegExp.escape(arrRules[6][i]?.toString() ?? ""));
                  if (response.statusCode == 200) {
                    await updateExtendedField(thisFieldToReplace: thisFieldToReplace, strFormID: strFormID, thisResults: response.data?.toString() ?? "");
                  }
                } else {
                  await updateExtendedField(thisFieldToReplace: thisFieldToReplace, strFormID: strFormID, thisResults: ""); //Clear Value
                }
                break;
              case '2': //Hide a field
              case '5': //Set another field's value
              case '8': //show a hidden field
                var okToProceedAction = false;
                switch (arrRules[3][i]) {
                  case '0': //Equal To
                    if (arrRules[5][i] == thisValue) {
                      okToProceedAction = true;
                    }
                    break;
                  case '1': //Not Equal To
                    if (arrRules[5][i] != thisValue) {
                      okToProceedAction = true;
                    }
                    break;
                  case '2': //Is Blank
                    if (thisValue == '') {
                      okToProceedAction = true;
                    }
                    break;
                  case '3': //Not Blank
                    if (thisValue != '') {
                      okToProceedAction = true;
                    }
                    break;
                  case '4': //Greater Than
                    if (int.tryParse(thisValue)?.isNaN ?? true) {
                      thisValue = "0";
                    }
                    if (int.tryParse(arrRules[5][i])?.isNaN ?? true) {
                      arrRules[5][i] = 0;
                    }
                    if ((int.tryParse(thisValue) ?? 0) > arrRules[5][i]) {
                      okToProceedAction = true;
                    }
                    break;
                  case '5': //Less Than
                    if (int.tryParse(thisValue)?.isNaN ?? true) {
                      thisValue = "0";
                    }
                    if (int.tryParse(arrRules[5][i])?.isNaN ?? true) {
                      arrRules[5][i] = 0;
                    }
                    if ((int.tryParse(thisValue) ?? 0) < arrRules[5][i]) {
                      okToProceedAction = true;
                    }
                    break;
                  case '6': //Checked
                    if (thisValue == 'on') {
                      okToProceedAction = true;
                    }
                    break;
                  case '7': //Not Checked
                    if (thisValue == 'off') {
                      okToProceedAction = true;
                    }
                    break;
                  default:
                    if (kDebugMode) {
                      SnackBarHelper.openSnackBar(isError: true, message: "Found Error in CheckForm: Unknown Comparison Type");
                    }
                }
                switch (arrRules[1][i]) {
                  case '2': //hide field
                    if (okToProceedAction == true) {
                      jsClass["span"]?.add(arrRules[4][i]);
                      showField[arrRules[4][i]] = false; //hide
                    } else {
                      jsClass["span"]?.add(arrRules[4][i]);
                      showField[arrRules[4][i]] = true; //show
                    }
                    break;
                  case '8': //show field
                    if (okToProceedAction == true) {
                      jsClass["span"]?.add(arrRules[4][i]);
                      showField[arrRules[4][i]] = true; //show
                    } else {
                      jsClass["span"]?.add(arrRules[4][i]);
                      showField[arrRules[4][i]] = false; //hide
                    }
                    break;
                  default:
                    if (okToProceedAction == true) {
                      values[arrRules[4][i]?.toString() ?? ""] = arrRules[6][i] ?? "";
                      jsClass["sn"]?.addIf(jsClass["sn"]?.contains(arrRules[4][i]?.toString() ?? "") == false, arrRules[4][i]?.toString() ?? "");
                    }
                }
                break;
              case '6': //Get Fuel Farm Cost Per Gallon
              case '9': //Get Next Auto Increment Field Id
                var parentId = arrRules[0][i] ?? "";
                Response response = await formsApiProvider.generalAPICall(
                  apiCallType: "POST",
                  url: "/forms/checkForm",
                  postData: {
                    "systemId": UserSessionInfo.systemId.toString(),
                    "userId": UserSessionInfo.userId.toString(),
                    "ruleType": RegExp.escape(arrRules[1][i]?.toString() ?? ""),
                    "return": "",
                    "value": thisValue,
                    "comparisonValue": "",
                    "miscField": "",
                    "parentId": parentId,
                  },
                );
                if (response.statusCode == 200) {
                  values[arrRules[4][i]?.toString() ?? ""] = response.data["data"] ?? "";
                  jsClass["sn"]?.addIf(jsClass["sn"]?.contains(arrRules[4][i]?.toString() ?? "") == false, arrRules[4][i]?.toString() ?? "");
                }
                break;
              case '7':
                var parentId = arrRules[0][i]?.toString() ?? "";
                var childId = arrRules[4][i]?.toString() ?? "";
                var myVal = values[parentId] ?? "";
                var priorUserChoice = values[childId] ?? "";
                await loadOptionsListFillFromServiceTable(
                  url: '/forms/loadOptionsListFillFromServiceTable',
                  dropdownListId: childId,
                  optionsValue: myVal,
                  selectText: priorUserChoice,
                );
                break;
              default:
                if (kDebugMode) {
                  SnackBarHelper.openSnackBar(isError: true, message: "Found Error in CheckForm: Unknown Rule Type (${arrRules[1][i]} | FD JS)");
                }
            }
          }
        }
      }
      //------------------- Do We Need Any Automatic Rule Checks? ---------------------

      var firstFieldIdOfError = '';
      if (requiredFields.isNotEmpty) {
        var z = requiredFields;
        for (var i = 0; i < z.length; i++) {
          var productElement = z[i]; //Does Element Exist
          if (productElement.isNotEmpty) {
            if (jsClass["gpsParent"]?.contains(productElement) ?? false) {
              //validate gps coordinates
              var f = z[i];
              //var emptyValues = false;
              requires[f] = false;
              //f.parent().find("input").each(function() // For all GPS Fields
              if ((values[f] ?? "") == "") {
                if (firstFieldIdOfError == '') {
                  firstFieldIdOfError = z[i];
                }
                needValidation[firstFieldIdOfError] = true;
              }
            } else {
              if (jsClass["span"]?.contains(z[i]) ?? false) {
                //textarea / narrative
                var t = values[z[i]] ?? "";
                if ((t == "None") || (t == "")) {
                  if (firstFieldIdOfError == '') {
                    firstFieldIdOfError = z[i];
                  }
                  needValidation[firstFieldIdOfError] = true;
                } else {
                  requires[z[i]] = false;
                }
              } else {
                if ((fieldType[z[i]] ?? "") == 'text') {
                  if ((values[z[i]] ?? "") == '') {
                    if (firstFieldIdOfError == '') {
                      firstFieldIdOfError = z[i];
                    }
                    needValidation[firstFieldIdOfError] = true;
                  } else {
                    if (jsClass["yellow_background"]?.contains(z[i]) ?? false) {
                      if (kDebugMode) {
                        SnackBarHelper.openSnackBar(isError: true, message: "Found Error in CheckForm: Need To Check");
                      }
                    } else {
                      requires[z[i]] = false;
                    }
                  }
                }
                if ((fieldType[z[i]] ?? "") == 'select-one') {
                  //Drop Downs
                  if ((values[z[i]] ?? "") == "0") {
                    if (firstFieldIdOfError == '') {
                      firstFieldIdOfError = z[i];
                    }
                    needValidation[firstFieldIdOfError] = true;
                  } else {
                    requires[z[i]] = false;
                  }
                }
                if ((fieldType[z[i]] ?? "") == 'hidden') {
                  //Check Boxes - Due to Hidden Fields With Check Boxes
                  if ((values[z[i]] ?? "") == "off") {
                    //TODO:Need to check with classic
                    if (firstFieldIdOfError == '') {
                      firstFieldIdOfError = z[i];
                    }
                    needValidation[firstFieldIdOfError] = true; //You cant set backgrounds or borders with Checkboxes so use Span behind it
                  } else {
                    requires[z[i]] = false;
                  }
                }
              }
            }
          }
        }
      }

      // ----- Do Any Math Needed ----------------
      if (strMathFieldsSubtract != '') {
        var y = strMathFieldsSubtract.split("^");
        for (var j = 0; j < y.length; j++) {
          var x = y[j].split("\$");
          var normalDecimalLength = 0;
          var n = <String>[];
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            num runningTotal = 0;
            if (fieldsToAdd != '') {
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                var productElement = z[i];
                if (productElement.isNotEmpty) {
                  if ((values[z[i]] ?? "") != '') {
                    if ((values[z[i]] ?? "") == '.') {
                      values[z[i]] = '0.';
                    }
                    var thisFieldValue = double.tryParse(values[z[i]]?.replaceAll(',', '') ?? "") ?? 0.0;
                    values[z[i]] = thisFieldValue.toString(); //Set The Value Back To User With No Commas
                    if (thisFieldValue.isNaN == false) {
                      n = thisFieldValue.toString().split("."); //get the decimal portion of the number
                      if (n.length == 2) {
                        normalDecimalLength = (n[1]).length;
                      }
                      if (runningTotal == 0) {
                        runningTotal = thisFieldValue;
                      } else {
                        runningTotal = runningTotal - thisFieldValue;
                      }
                    } else {
                      values[z[i]] = "0";
                    }
                  }
                }
              }
              if (normalDecimalLength == 0) {
                normalDecimalLength = 1;
              }
              var strTemp = ((runningTotal * 100).round() / 100).toStringAsFixed(normalDecimalLength);
              values[fieldToShowTotal] = strTemp;
              property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
              property[fieldToShowTotal]?["disabled"] = true;
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
            }
          }
        }
      }

      if (strMathFieldsTimeSubtractHours != '') {
        var y = strMathFieldsTimeSubtractHours.split("^");
        for (var j = 0; j < y.length; j++) {
          //alert(y[j]);
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            //var runningTotal = 0;
            if (fieldsToAdd != '') {
              var startingTimeHours = ''; //Reset vars
              var startingTimeMinutes = '';
              var endingTimeHours = '';
              var endingTimeMinutes = '';
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                var productElement = z[i];
                if (productElement.isNotEmpty) {
                  if ((values[z[i]] ?? "") != '') {
                    var thisFieldValue = values[z[i]]?.replaceAll(',', '') ?? "";
                    //Is Valid Time?
                    var strValue = thisFieldValue;
                    var length = strValue.length;
                    var colonCountInString = strValue.indexOf(":");
                    if (colonCountInString > 0) {
                      if (colonCountInString + 3 == length) {
                        if (startingTimeHours == '') {
                          startingTimeHours = strValue.substring(0, colonCountInString);
                          startingTimeMinutes = strValue.substring(colonCountInString + 1, length);
                        } else {
                          endingTimeHours = strValue.substring(0, colonCountInString);
                          endingTimeMinutes = strValue.substring(colonCountInString + 1, length);
                        }
                      }
                    }
                  }
                }
              }

              if (startingTimeHours != '' && endingTimeHours != '') {
                var date1 = DateTime(2000, 0, 1, int.parse(startingTimeHours), int.parse(startingTimeMinutes)); // 9:00 AM
                var date2 = DateTime(2000, 0, 1, int.parse(endingTimeHours), int.parse(endingTimeMinutes)); // 5:00 PM
                if (date2.isBefore(date1)) {
                  date2 = date2.add(const Duration(days: 1));
                }
                var diff = date2.difference(date1).inMilliseconds;
                var hh = (diff / 1000 / 60 / 60).floor();
                diff -= hh * 1000 * 60 * 60;
                var mm = (diff / 1000 / 60);
                if (mm > 0) {
                  if (mm < 7) {
                    mm = 6;
                  } else {
                    if (mm < 13) {
                      mm = 12;
                    } else {
                      if (mm < 19) {
                        mm = 18;
                      } else {
                        if (mm < 25) {
                          mm = 24;
                        } else {
                          if (mm < 31) {
                            mm = 30;
                          } else {
                            if (mm < 37) {
                              mm = 36;
                            } else {
                              if (mm < 43) {
                                mm = 42;
                              } else {
                                if (mm < 49) {
                                  mm = 48;
                                } else {
                                  if (mm < 55) {
                                    mm = 54;
                                  } else {
                                    mm = 0;
                                    hh = hh + 1;
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
                mm = mm / 60;
                mm = ((hh + mm) * pow(10, 1)).round() / pow(10, 1);
                values[fieldToShowTotal] = mm.toStringAsFixed(1);
                property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
                property[fieldToShowTotal]?["disabled"] = true;
                jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
              } else {
                values[fieldToShowTotal] = "0";
                property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
                property[fieldToShowTotal]?["disabled"] = true;
                jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
              }
            }
          }
        }
      }
      if (strMathFieldsTimeSubtractMinutes != '') {
        var y = strMathFieldsTimeSubtractMinutes.split("^");
        for (var j = 0; j < y.length; j++) {
          //alert(y[j]);
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            //var runningTotal = 0;
            if (fieldsToAdd != '') {
              var startingTimeHours = '', startingTimeMinutes = '', endingTimeHours = '', endingTimeMinutes = '';
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                var productElement = z[i];
                if (productElement.isNotEmpty) {
                  if ((values[z[i]] ?? "") != '') {
                    var thisFieldValue = values[z[i]]?.replaceAll(',', '') ?? "";
                    //Is Valid Time?
                    var strValue = thisFieldValue;
                    var length = strValue.length;
                    var colonCountInString = strValue.indexOf(":");
                    if (colonCountInString > 0) {
                      if (colonCountInString + 3 == length) {
                        if (startingTimeHours == '') {
                          startingTimeHours = strValue.substring(0, colonCountInString);
                          startingTimeMinutes = strValue.substring(colonCountInString + 1, length);
                        } else {
                          endingTimeHours = strValue.substring(0, colonCountInString);
                          endingTimeMinutes = strValue.substring(colonCountInString + 1, length);
                        }
                      }
                    }
                  }
                }
              }
              if (startingTimeHours != '' && endingTimeHours != '') {
                var date1 = DateTime(2000, 0, 1, int.parse(startingTimeHours), int.parse(startingTimeMinutes)); // 9:00 AM
                var date2 = DateTime(2000, 0, 1, int.parse(endingTimeHours), int.parse(endingTimeMinutes)); // 5:00 PM
                if (date2.isBefore(date1)) {
                  date2 = date2.add(const Duration(days: 1));
                }
                values[fieldToShowTotal] = ((((date2.difference(date1).inMilliseconds) / 1000 / 60) * pow(10, 1)).round() / pow(10, 1)).toString();
                property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
                property[fieldToShowTotal]?["disabled"] = true;
                jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
              } else {
                values[fieldToShowTotal] = "0";
                property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
                property[fieldToShowTotal]?["disabled"] = true;
                jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
              }
            }
          }
        }
      }
      if (strMathFieldsSumMinutesToHours != '') {
        var y = strMathFieldsSumMinutesToHours.split("^");
        for (var j = 0; j < y.length; j++) {
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            num runningTotal = 0;
            if (fieldsToAdd != '') {
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                var productElement = z[i];
                if (productElement.isNotEmpty) {
                  if ((values[z[i]] ?? "") != '') {
                    if ((values[z[i]] ?? "") == '.') {
                      values[z[i]] = '0.';
                    }
                    var thisFieldValue = num.tryParse(values[z[i]]?.replaceAll(',', '') ?? "") ?? 0;
                    values[z[i]] = thisFieldValue.toString(); //Set The Value Back To User With No Commas
                    if (thisFieldValue.isNaN == false) {
                      runningTotal = runningTotal + thisFieldValue;
                    } else {
                      values[z[i]] = "0";
                    }
                  }
                }
              }

              var hh = runningTotal ~/ 60;
              var mm = (runningTotal - (hh * 60));
              if (mm > 0) {
                if (mm < 7) {
                  mm = 6;
                } else {
                  if (mm < 13) {
                    mm = 12;
                  } else {
                    if (mm < 19) {
                      mm = 18;
                    } else {
                      if (mm < 25) {
                        mm = 24;
                      } else {
                        if (mm < 31) {
                          mm = 30;
                        } else {
                          if (mm < 37) {
                            mm = 36;
                          } else {
                            if (mm < 43) {
                              mm = 42;
                            } else {
                              if (mm < 49) {
                                mm = 48;
                              } else {
                                if (mm < 55) {
                                  mm = 54;
                                } else {
                                  mm = 0;
                                  hh = hh + 1;
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              mm = mm / 60;
              mm = ((hh + mm) * pow(10, 1)).round() / pow(10, 1);
              values[fieldToShowTotal] = mm.toStringAsFixed(1);
              property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
              property[fieldToShowTotal]?["disabled"] = true;
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
              //print('if hh+mm: $mm');
            }
          }
        }
      }

      if (strMathFields != '') {
        var y = strMathFields.split("^");
        for (var j = 0; j < y.length; j++) {
          //console.log(y[j]);
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            var normalDecimalLength = 0;
            num runningTotal = 0;
            if (fieldsToAdd != '') {
              var nType = int.tryParse(fieldsToAdd.split("|")[1]) ?? 0;
              fieldsToAdd = fieldsToAdd.split("|")[0];
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                var productElement = z[i];
                if (productElement.isNotEmpty) {
                  if ((values[z[i]] ?? "") != '') {
                    if (values[z[i]] == '.') {
                      values[z[i]] = '0.';
                    }
                    var thisFieldValue = double.tryParse(values[z[i]]?.replaceAll(',', '') ?? "") ?? 0.0;
                    values[z[i]] = thisFieldValue.toString(); //Set The Value Back To User With No Commas
                    if (thisFieldValue.isNaN == false) {
                      //thisFieldValue = thisFieldValue;
                      // Find the exact decimal point place
                      if (nType != 0) {
                        switch (nType) {
                          case 38:
                            normalDecimalLength = 1;
                            break;
                          case 39:
                            normalDecimalLength = 2;
                            break;
                          case 40:
                            normalDecimalLength = 3;
                            break;
                          case 41:
                            normalDecimalLength = 4;
                            break;
                        }
                      } else {
                        var n = thisFieldValue.toString().split("."); //get the decimal portion of the number
                        if (n.length == 2) {
                          normalDecimalLength = (n[1]).length;
                        }
                      }
                      runningTotal = runningTotal + thisFieldValue;
                    } else {
                      values[z[i]] = "0";
                    }
                  }
                }
              }
              if (normalDecimalLength == 0) {
                normalDecimalLength = 1;
              }
              values[fieldToShowTotal] = runningTotal.toStringAsFixed(normalDecimalLength);
              property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
              property[fieldToShowTotal]?["disabled"] = true;
              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
            }
          }
        }
      }

      if (strMathFieldsMultiply0 != '') {
        var y = strMathFieldsMultiply0.split("^");
        for (var j = 0; j < y.length; j++) {
          num thisVal;
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up

            num? runningTotal;
            if (fieldsToAdd != '') {
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                thisVal = num.tryParse(values[z[i]]?.replaceAll(',', '') ?? "") ?? 0;
                if (thisVal.isNaN) {
                  thisVal = 0;
                }
                if (runningTotal != null) {
                  runningTotal = runningTotal * thisVal;
                } else {
                  runningTotal = thisVal;
                }
              }
            }
            if (runningTotal?.isNaN ?? true) {
              runningTotal = 0;
            }
            values[fieldToShowTotal] = runningTotal?.toStringAsFixed(0) ?? "0";
            property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
            property[fieldToShowTotal]?["disabled"] = true;
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
          }
        }
      }
      if (strMathFieldsMultiply1 != '') {
        var y = strMathFieldsMultiply1.split("^");
        for (var j = 0; j < y.length; j++) {
          num thisVal;
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            num? runningTotal;
            if (fieldsToAdd != '') {
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                thisVal = num.tryParse(values[z[i]]?.replaceAll(',', '') ?? "") ?? 0;
                if (thisVal.isNaN) {
                  thisVal = 0;
                }
                if (runningTotal != null) {
                  runningTotal = runningTotal * thisVal;
                } else {
                  runningTotal = thisVal;
                }
              }
            }
            if (runningTotal?.isNaN ?? true) {
              runningTotal = 0;
            }
            values[fieldToShowTotal] = runningTotal?.toStringAsFixed(1) ?? "0.0";
            property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
            property[fieldToShowTotal]?["disabled"] = true;
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
          }
        }
      }
      if (strMathFieldsMultiply2 != '') {
        var y = strMathFieldsMultiply2.split("^");
        for (var j = 0; j < y.length; j++) {
          num thisVal;
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            fieldsToAdd = (x[1]); //Field IDs To Add Up
            num? runningTotal;
            if (fieldsToAdd != '') {
              var z = fieldsToAdd.split(",");
              for (var i = 0; i < z.length; i++) {
                property.putIfAbsent(z[i], () => {"disabled": false, "numberOnly": false});
                property[z[i]]?["numberOnly"] = true;
                thisVal = num.tryParse(values[z[i]]?.replaceAll(',', '') ?? "") ?? 0;
                if (thisVal.isNaN) {
                  thisVal = 0;
                }
                if (runningTotal != null) {
                  runningTotal = runningTotal * thisVal;
                } else {
                  runningTotal = thisVal;
                }
              }
            }
            if (runningTotal?.isNaN ?? true) {
              runningTotal = 0;
            }
            values[fieldToShowTotal] = runningTotal?.toStringAsFixed(2) ?? "0.00";
            property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
            property[fieldToShowTotal]?["disabled"] = true;
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
          }
        }
      }

      if (strMathFieldsDivide0 != '') {
        var divideDecimals = 0;
        var y = strMathFieldsDivide0.split("^");
        for (var j = 0; j < y.length; j++) {
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            var fieldsToAdd = (x[1]).split(",");
            num runningTotal = 0;
            if (fieldsToAdd.length == 2) {
              var f0 = num.tryParse(values[fieldsToAdd[0]]?.replaceAll(',', '') ?? "") ?? 0;
              var f1 = num.tryParse(values[fieldsToAdd[1]]?.replaceAll(',', '') ?? "") ?? 0;
              if (f0.isNaN) {
                f0 = 0;
              }
              if (f1.isNaN) {
                f1 = 0;
              }
              f0 = f0.toDouble();
              f1 = f1.toDouble();
              if (f1 > 0) {
                runningTotal = (f0 / f1).toPrecision(divideDecimals);
              }
            }
            values[fieldToShowTotal] = runningTotal.toStringAsFixed(divideDecimals);
            property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
            property[fieldToShowTotal]?["disabled"] = true;
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
          }
        }
      }
      if (strMathFieldsDivide1 != '') {
        var divideDecimals = 1;
        var y = strMathFieldsDivide1.split("^");
        for (var j = 0; j < y.length; j++) {
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            var fieldsToAdd = (x[1]).split(",");
            num runningTotal = 0;
            if (fieldsToAdd.length == 2) {
              var f0 = num.tryParse(values[fieldsToAdd[0]]?.replaceAll(',', '') ?? "") ?? 0;
              var f1 = num.tryParse(values[fieldsToAdd[1]]?.replaceAll(',', '') ?? "") ?? 0;
              if (f0.isNaN) {
                f0 = 0;
              }
              if (f1.isNaN) {
                f1 = 0;
              }
              f0 = f0.toDouble();
              f1 = f1.toDouble();
              if (f1 > 0) {
                runningTotal = (f0 / f1).toPrecision(divideDecimals);
              }
            }
            values[fieldToShowTotal] = runningTotal.toStringAsFixed(divideDecimals);
            property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
            property[fieldToShowTotal]?["disabled"] = true;
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
          }
        }
      }
      if (strMathFieldsDivide2 != '') {
        var divideDecimals = 2;
        var y = strMathFieldsDivide2.split("^");
        for (var j = 0; j < y.length; j++) {
          var x = y[j].split("\$");
          if (x.length == 2) {
            fieldToShowTotal = (x[0]); //Field ID Of Final Sum Value
            var fieldsToAdd = (x[1]).split(",");
            num runningTotal = 0;
            if (fieldsToAdd.length == 2) {
              var f0 = num.tryParse(values[fieldsToAdd[0]]?.replaceAll(',', '') ?? "") ?? 0;
              var f1 = num.tryParse(values[fieldsToAdd[1]]?.replaceAll(',', '') ?? "") ?? 0;
              if (f0.isNaN) {
                f0 = 0;
              }
              if (f1.isNaN) {
                f1 = 0;
              }
              f0 = f0.toDouble();
              f1 = f1.toDouble();
              if (f1 > 0) {
                runningTotal = (f0 / f1).toPrecision(divideDecimals);
              }
            }
            values[fieldToShowTotal] = runningTotal.toStringAsFixed(divideDecimals);
            property.putIfAbsent(fieldToShowTotal, () => {"disabled": false, "numberOnly": false});
            property[fieldToShowTotal]?["disabled"] = true;
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldToShowTotal) == false, fieldToShowTotal);
          }
        }
      }
      // ----- Do Any Math Needed ----------------

      if (doSave) {
        // -------------------- Begin Check For AC Validation ------------------------
        var strFieldsCheck = ''; //,strTitle = '';
        // -------------------- Begin Check For AC Validation ------------------------

        if (strRequiredSignaturePENFields != '') {
          var strRequiredSignaturePENFieldsTEMP = strRequiredSignaturePENFields.split(';');
          for (var i = 0; i < strRequiredSignaturePENFieldsTEMP.length; i++) {
            if ((penSignatureDataList[strRequiredSignaturePENFieldsTEMP[i]] ?? {}).isEmpty) {
              strFieldsCheck = '${strFieldsCheck}Electronic PEN Signature Required\n';
            }
          }
        }

        if (strPICFieldID > 0) {
          var strTitle = 'PIC Time', sValue = values[strPICFieldID.toString()] ?? "";
          if (sValue != '') {
            var startValue = num.tryParse(sValue.replaceAll('\$', '').replaceAll(',', '')) ?? 0;
            values[strPICFieldID.toString()] = startValue.toString();
            jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strPICFieldID.toString()) == false, strPICFieldID.toString());
            if (startValue.isNaN == false) {
              if (startValue < 0) {
                strFieldsCheck = '$strFieldsCheck$strTitle Can Not Be Less Than 0.0 (${startValue.toStringAsFixed(1)})\n';
              }
            } else {
              strFieldsCheck = '$strFieldsCheck$strTitle Is Not A Number ($startValue)\n';
            }
          } else {
            strFieldsCheck = '$strFieldsCheck$strTitle Can Not Be Blank\n';
          }
        }
        // -------------------- Check For AC Maintenance Hobbs Times ------------------------

        // ----------- Check For Flt Hobbs To Add > 10 (strACHobbsToAddID) ---------
        if (strACHobbsToAddID > 0) {
          var thisValue = num.tryParse(values[strACHobbsToAddID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACHobbsToAddID.toString()] = thisValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACHobbsToAddID.toString()) == false, strACHobbsToAddID.toString());
          if (thisValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Flight Hobbs To Add Is Not A Number (${thisValue.toStringAsFixed(1)})\n';
          } else {
            //Per JD - Remove 6/3/2019 Ref Airtec. 6/30/2021 he wants it back. FML then USDA he said to turn it off. So it's 10 and 20. DO NOT CHANGE!
            if (thisValue > 10) {
              if (thisValue > 20) {
                strFieldsCheck = '${strFieldsCheck}Flight Hobbs To Add Can Not Be More Than 20.0 Hours (${thisValue.toStringAsFixed(1)})\n';
              } else {
                return showDialog<void>(
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
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                              side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                            ),
                            title: const Center(child: Text("Flight Hobbs To Add Is > 10 Hours.")),
                            titleTextStyle: TextStyle(
                              fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                              fontWeight: FontWeight.bold,
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                            ),
                            content: const Text("Please Verify The Flight Hobbs To Add Time Before Continuing"),
                            contentTextStyle: TextStyle(
                              fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize)! + 3,
                              fontWeight: FontWeight.bold,
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Material(
                                    color: ColorConstants.primary,
                                    elevation: 10,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      side: const BorderSide(color: ColorConstants.red),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        values["PerformCloseOut"] = "No";
                                        Get.back();
                                      },
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, fontWeight: FontWeight.bold, color: ColorConstants.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: SizeConstants.contentSpacing),
                                  Material(
                                    color: ColorConstants.red,
                                    elevation: 10,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      side: const BorderSide(color: Colors.transparent),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            "Continue",
                                            style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, fontWeight: FontWeight.bold, color: ColorConstants.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }
          }
        }
        // ----------- Check For Flt Hobbs To Add > 3 And > 10 (strACHobbsToAddID) ---------

        // -------------------- Check For AC Maintenance Hobbs Times ------------------------
        if (strACHobbsStartID > 0 && strACHobbsEndID > 0) {
          var strTitle = 'Flight Hobbs';
          var startValue = num.tryParse(values[strACHobbsStartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strACHobbsEndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACHobbsEndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACHobbsEndID.toString()) == false, strACHobbsEndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC Maintenance Hobbs Times ------------------------

        // -------------------- Check For AC Billable Hobbs Times ------------------------
        if (strACBillableStartID > 0 && strACBillableEndID > 0) {
          var strTitle = 'Billable Hobbs';
          var startValue = num.tryParse(values[strACBillableStartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strACBillableEndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACBillableEndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACBillableEndID.toString()) == false, strACBillableEndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                startValue = startValue.toDouble();
                endValue = endValue.toDouble();
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC Billable Hobbs Times ------------------------

        // -------------------- Check For AC E1 Starts/NG ------------------------
        if (strACStartsStartID > 0 && strACStartsEndID > 0) {
          var strTitle = 'Engine 1 Starts/NG/NF';
          var startValue = num.tryParse(values[strACStartsStartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strACStartsEndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACStartsEndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACStartsEndID.toString()) == false, strACStartsEndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC E1 Starts/NG ------------------------

        // -------------------- Check For AC E2 Starts/NG ------------------------
        if (strACStarts2StartID > 0 && strACStarts2EndID > 0) {
          var strTitle = 'Engine 2 Starts/NG/NF';
          var startValue = num.tryParse(values[strACStarts2StartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strACStarts2EndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACStarts2EndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACStarts2EndID.toString()) == false, strACStarts2EndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                startValue = startValue.toDouble();
                endValue = endValue.toDouble();
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC E1 NP ------------------------
        if (strACNPStartID > 0 && strACNPEndID > 0) {
          var strTitle = 'Engine 1 NP';
          var startValue = num.tryParse(values[strACNPStartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strACNPEndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACNPEndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACNPEndID.toString()) == false, strACNPEndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                startValue = startValue.toDouble();
                endValue = endValue.toDouble();
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC E2 NP ------------------------
        if (strACNP2StartID > 0 && strACNP2EndID > 0) {
          var strTitle = 'Engine 2 NP';
          var startValue = num.tryParse(values[strACNP2StartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strACNP2EndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strACNP2EndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strACNP2EndID.toString()) == false, strACNP2EndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                startValue = startValue.toDouble();
                endValue = endValue.toDouble();
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC E1 NG2 ------------------------
        if (strE1NG2StartID > 0 && strE1NG2EndID > 0) {
          var strTitle = 'Engine 1 NG2';
          var startValue = num.tryParse(values[strE1NG2StartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strE1NG2EndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strE1NG2EndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strE1NG2EndID.toString()) == false, strE1NG2EndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                startValue = startValue.toDouble();
                endValue = endValue.toDouble();
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }
        // -------------------- Check For AC E2 NG2 ------------------------
        if (strE2NG2StartID > 0 && strE2NG2EndID > 0) {
          var strTitle = 'Engine 2 NG2';
          var startValue = num.tryParse(values[strE2NG2StartID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          var endValue = num.tryParse(values[strE2NG2EndID.toString()]?.replaceAll('\$', '').replaceAll(',', '') ?? "") ?? 0;
          values[strE2NG2EndID.toString()] = endValue.toString();
          jsClass["sn"]?.addIf(jsClass["sn"]?.contains(strE2NG2EndID.toString()) == false, strE2NG2EndID.toString());
          if (endValue.isNaN == true) {
            strFieldsCheck = '${strFieldsCheck}Ending $strTitle Is Not A Number ($endValue)\n';
          } else {
            if (endValue.toString() != '') {
              if (startValue.isNaN == false && endValue.isNaN == false) {
                startValue = startValue.toDouble();
                endValue = endValue.toDouble();
                if (endValue < startValue) {
                  strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Less Than The Beginning $strTitle ($endValue "<" $startValue)\n';
                }
              }
            } else {
              strFieldsCheck = '${strFieldsCheck}Ending $strTitle Can Not Be Blank\n';
            }
          }
        }

        if (strFieldsCheck == '') {
          if (firstFieldIdOfError == '') {
            await saveFormPrep();
          } else {
            SnackBarHelper.openSnackBar(
              isError: true,
              title: "The Following Errors Have Been Found:",
              message: 'Please Verify That All Required Items Have Been Completed\nRequired Fields Are Highlighted With Red Star Mark',
            );
          }
        } else {
          SnackBarHelper.openSnackBar(isError: true, title: "The Following Errors Have Been Found:", message: strFieldsCheck);
        }
      }
      if (fieldId != null && !extendedFields.contains(fieldId.toString())) {
        dataModified = true;
        jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldId.toString()) == false, fieldId.toString());
      }
      //return false;
    } catch (_) {
      if (kDebugMode) {
        SnackBarHelper.openSnackBar(isError: true, message: "Found Error/Exception in CheckForm: $e");
      }

      if (fieldId != null) {
        jsClass["sn"]?.addIf(jsClass["sn"]?.contains(fieldId.toString()) == false, fieldId.toString());
      }
      EasyLoading.dismiss();
    }
  }

  ///Made by Tayeb - 90% && Modified & Done by Surjit
  Future<void> updateExtendedField({required String thisFieldToReplace, required int strFormID, required String thisResults}) async {
    thisResults = thisResults.toString().trim();
    if (thisResults != '') {
      //If this is a METAR don't let it null over write a previous value.
      //HCSO if any leg is Non-Weather then I want it to save. So if next leg is NOT no-Response, it will clear. I don't want that.
      if (strMemoFields != '') {
        //Is this a normal field or a memo
        var foundFieldInMemo = false;
        var z = strMemoFields.split(",");
        for (var h = 0; h <= z.length - 1; h++) {
          if (z[h] == thisFieldToReplace.toString()) {
            foundFieldInMemo = true;
          }
        }
        if (foundFieldInMemo == true) {
          //Update memo field on screen and jquery in background value
          Response response = await formsApiProvider.generalAPICall(
            showSnackBar: false,
            apiCallType: "POST",
            url: "/forms/updateExtendedField",
            postData: {
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "formId": strFormID.toString(),
              "fieldToReplace": thisFieldToReplace,
              "results": RegExp.escape(thisResults),
            },
          );
          if (response.statusCode == 200) {
            //var data = response.data;
            //SnackBarHelper.openSnackBar(isError: true, message: response.data["userMessage"]);
          } else {
            SnackBarHelper.openSnackBar(isError: true, message: "Unable To Retrieve Information");
          }
        }
      }
      updateExtendedTextField = thisFieldToReplace.toString();
      //values[thisFieldToReplace.toString()] = thisResults;
    }
  }

  ///Made by Tayeb - 30% && Modified & Done by Surjit
  Future<void> loadExtendedField({strNarrativeID, strFieldID, strFieldTypeID}) async {
    loadExtendedFieldData.remove(strFieldID.toString());
    loadExtendedChildFieldData.remove(strFieldID.toString());
    var allValues = [];

    Response response = await formsApiProvider.generalAPICall(
      apiCallType: "POST",
      url: "/forms/loadExtendedField",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "type": strFieldTypeID.toString(),
        "formFieldId": strFieldID.toString(),
        "narrativeFieldId": strNarrativeID.toString(),
      },
    );

    if (response.statusCode == 200) {
      if (response.data["data"]["objLoadExtendedField"]["objAllFormsUsersExtendedData"]["formData"] != null) {
        //values[strFieldID.toString()] = response.data["data"]["objLoadExtendedField"]["objAllFormsUsersExtendedData"]["formData"];
        extendedFieldsValue[strFieldID.toString()] = response.data["data"]["objLoadExtendedField"]["objAllFormsUsersExtendedData"]["formData"];
      }

      if (response.data["data"]["objLoadExtendedField"]["allServiceVariableNameDataList"].length > 0) {
        for (int i = 0; i < response.data["data"]["objLoadExtendedField"]["allServiceVariableNameDataList"].length; i++) {
          allValues.add({"name": response.data["data"]["objLoadExtendedField"]["allServiceVariableNameDataList"][i]["serviceVariableName"]});
        }
      }

      if (response.data["data"]["objLoadExtendedField"]["mdfrVenomDrugAvailableParentList"].length > 0) {
        allValues.add({"id": 0, "name": "-- Select A Drug Below --"});
        for (int i = 0; i < response.data["data"]["objLoadExtendedField"]["mdfrVenomDrugAvailableParentList"].length; i++) {
          allValues.add({
            "id": response.data["data"]["objLoadExtendedField"]["mdfrVenomDrugAvailableParentList"][i]["parentId"],
            "name": response.data["data"]["objLoadExtendedField"]["mdfrVenomDrugAvailableParentList"][i]["description"],
          });
        }
      }

      loadExtendedFieldData.addIf(true, strFieldID, allValues);
    }
  }

  ///Made & Done by Surjit - 100%
  Future<void> loadExtendedChildField({strFieldID, dropDownId}) async {
    loadExtendedChildFieldData.remove(strFieldID.toString());

    Response response = await formsApiProvider.generalAPICall(
      apiCallType: "POST",
      url: "/forms/loadChildItems",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "optionsType": "Get_Venom_Form_Inventory_Child_Items",
        "parentId": dropDownId.toString(),
        "ItemList": "",
        "returnType": "0",
      },
    );

    if (response.statusCode == 200) {
      loadExtendedChildFieldData.addIf(true, strFieldID, response.data["data"]);
    }
  }

  ///Made by Tayeb - 90% && Modified & Done by Surjit
  Future<void> loadExtendedFieldSave({strNarrativeId, strFieldId, strFieldTypeId, strValue}) async {
    Response response = await formsApiProvider.generalAPICall(
      apiCallType: "POST",
      url: "/forms/loadExtendedFieldSave",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "formFieldId": strFieldId.toString(),
        "narrativeId": strNarrativeId.toString(),
        "value": strValue.toString(),
        "fieldTypeId": strFieldTypeId.toString(),
      },
    );

    if (response.statusCode == 200) {
      var msg = response.data["data"]?.toString() ?? "";

      if (strFieldTypeId.toString() == "28") {
        if (msg == "") {
          msg = "None";
        } else {
          htmlValues[strFieldId.toString()] = msg;
        }
      } else {
        htmlValues[strFieldId.toString()] = msg;
      }
      await checkForm(doSave: false, fieldId: null);
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "Unable To Retrieve Information");
    }
  }

  ///Made by Tayeb - 90% && Modified & Done by Surjit
  Future<void> saveSelectMultipleFinal({strFormFieldID, strFormFieldNarrativeID, strData}) async {
    Response response = await formsApiProvider.generalAPICall(
      showSnackBar: false,
      apiCallType: "POST",
      url: "/forms/saveSelectMultipleFinal",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "formFieldId": strFormFieldID.toString(),
        "formFieldNarrativeId": strFormFieldNarrativeID.toString(),
        "data": strData.toString(),
        "action": "Update_Select_Multiple",
      },
    );

    if (response.statusCode == 200) {
      var data = response.data["data"];
      values[strFormFieldID.toString()] = data.toString().replaceAll("^^^#", ", ");
      if (data == null || data == "") {
        extendedFieldsValue.remove(strFormFieldID.toString());
      } else {
        extendedFieldsValue[strFormFieldID.toString()] = data.toString().replaceAll("^^^#", ", ");
      }
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "Error Saving Data: $strData");
    }
  }

  ///Made by Tayeb - 90% && Modified & Done by Surjit
  Future<void> saveSelectMultipleFinalVenom({strFormFieldID, strFormFieldNarrativeID, strData}) async {
    Response response = await formsApiProvider.generalAPICall(
      showSnackBar: false,
      apiCallType: "POST",
      url: "/forms/saveSelectMultipleFinalVenom",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "formFieldId": strFormFieldID.toString(),
        "formFieldNarrativeId": strFormFieldNarrativeID.toString(),
        "data": strData.toString(),
        "action": "Update_Select_Multiple_Venom",
      },
    );

    if (response.statusCode == 200) {
      var data = response.data["data"];
      values[strFormFieldID.toString()] = data.toString();
      if (data == null || data == "") {
        extendedFieldsValue.remove(strFormFieldID.toString());
      } else {
        extendedFieldsValue[strFormFieldID.toString()] = data.toString();
      }
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "Error Saving Data: $strData");
    }
  }

  ///Made by Tayeb - 90% && Modified & Done by Surjit
  Future<void> saveFormPrep() async {
    var saveOrSaveAndComplete = values["PerformCloseOut"] ?? "";
    if (saveOrSaveAndComplete == "Yes") {
      if (signatureOnComplete == 1) {
        var obscureTextShow = true.obs;
        var textController = TextEditingController();
        var validationKey = GlobalKey<FormFieldState>();

        return showDialog<void>(
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
                          const Text("By Clicking Below, You Are Certifying The Item Is Accurate & Complete."),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(child: Text("Name : ")),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  UserSessionInfo.userFullName,
                                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w600),
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
                                        style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
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
                    actionsOverflowButtonSpacing: 5.0,
                    actions: [
                      ButtonConstant.dialogButton(
                        title: "Cancel",
                        borderColor: ColorConstants.red,
                        onTapMethod: () {
                          Get.back();
                        },
                      ),
                      ButtonConstant.dialogButton(
                        title: "Electronically Sign",
                        borderColor: ColorConstants.green,
                        onTapMethod: () {
                          if (validationKey.currentState?.validate() ?? false) {
                            Get.back();
                            validatePassword(textController.text);
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
      } else {
        await saveForm();
      }
    } else {
      values["PerformCloseOut"] = "No"; //just in case
      await saveForm();
    }
  }

  ///Done by Tayeb - 100%
  Future<void> validatePassword(password) async {
    /// POST CALL
    Response response = await formsApiProvider.generalAPICall(
      showSnackBar: false,
      apiCallType: "POST",
      url: "/forms/validatePassword",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "formId": strFormID != 0 ? strFormID.toString() : Get.parameters["formId"],
        "formFieldId": "",
        "password": password,
        "sMode": "ValidateOnly",
      },
    );

    if (response.statusCode == 200) {
      if ((response.data["data"]?.toString() ?? "") == "1") {
        saveDialogText = "Please Wait... Saving & Completing Form";
        await doSave();
      } else {
        SnackBarHelper.openSnackBar(isError: true, message: "Unable To Verify Your Password!");
      }
    } else if ((response.statusCode == 400) && ((response.data["data"]?.toString() ?? "") == "0")) {
      SnackBarHelper.openSnackBar(isError: true, message: 'Unable To Verify Your Password. Please Verify Your Password And Try Again.');
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "There was an error submitting your request. Please Try Again.");
    }
  }

  ///Made by Tayeb - 70% && Modified & Done by Surjit
  Future<void> saveForm() async {
    if (values["PerformCloseOut"] == "Yes") {
      //If a close out form, ensure aircraft times are not < aircraft current times
      var acHoursCheckDbInProgress = false;
      if (values["IsCloseOutForm"] == "1") {
        var acHoursCheckDbIssues = "";
        acHoursCheckDbInProgress = false;
        var subAcFieldId = strACPrimaryField;

        if (subAcFieldId.isNaN) {
          subAcFieldId = 0;
        }

        if (subAcFieldId > 0) {
          var subAircraftId = int.tryParse(values[subAcFieldId.toString()] ?? "") ?? 0;

          if (subAircraftId.isNaN) {
            subAircraftId = 0;
          }
          if (subAircraftId > 0) {
            acHoursCheckDbInProgress = true;

            if (strACHobbsStartID.isNaN) {
              strACHobbsStartID = 0;
            }
            if (strACTTStartID.isNaN) {
              strACTTStartID = 0;
            }
            if (strACStartsStartID.isNaN) {
              strACStartsStartID = 0;
            }
            if (strACLandingsStartID.isNaN) {
              strACLandingsStartID = 0;
            }
            if (strE1TTStartID.isNaN) {
              strE1TTStartID = 0;
            }

            var subFormACHobbsStartID = 0.0;
            var subFormACTTStartID = 0.0;
            var subFormACStartsStartID = 0.0;
            var subFormACLandingsStartID = 0.0;
            var subFormE1TTStartID = 0.0;
            var subDbACHobbsStartID = 0.0;
            var subDbACTTStartID = 0.0;
            var subDbACStartsStartID = 0.0;
            var subDbACLandingsStartID = 0.0;
            var subDbE1TTStartID = 0.0;

            if (strACHobbsStartID > 0) {
              subFormACHobbsStartID = double.tryParse(values[strACHobbsStartID.toString()] ?? "") ?? 0.0;
            }
            if (strACTTStartID > 0) {
              subFormACTTStartID = double.tryParse(values[strACTTStartID.toString()] ?? "") ?? 0.0;
            }
            if (strACStartsStartID > 0) {
              subFormACStartsStartID = double.tryParse(values[strACStartsStartID.toString()] ?? "") ?? 0.0;
            }
            if (strACLandingsStartID > 0) {
              subFormACLandingsStartID = double.tryParse(values[strACLandingsStartID.toString()] ?? "") ?? 0.0;
            }
            if (strE1TTStartID > 0) {
              subFormE1TTStartID = double.tryParse(values[strE1TTStartID.toString()] ?? "") ?? 0.0;
            }

            if (subFormACHobbsStartID.isNaN) {
              subFormACHobbsStartID = 0;
            }
            if (subFormACTTStartID.isNaN) {
              subFormACTTStartID = 0;
            }
            if (subFormACStartsStartID.isNaN) {
              subFormACStartsStartID = 0;
            }
            if (subFormACLandingsStartID.isNaN) {
              subFormACLandingsStartID = 0;
            }
            if (subFormE1TTStartID.isNaN) {
              subFormE1TTStartID = 0;
            }

            Response response = await formsApiProvider.generalAPICall(
              apiCallType: "POST",
              url: "/forms/aircraftCurrentValues",
              postData: {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "aircraftId": subAircraftId.toString()},
            );

            if (response.statusCode == 200) {
              var data = response.data["data"];

              data.forEach((item, value) {
                var results = value;

                results.forEach((i, v) {
                  switch (int.tryParse(i)) {
                    case 8:
                      subDbACHobbsStartID = double.parse(v);
                      break;
                    case 12:
                      subDbACStartsStartID = double.parse(v);
                      break;
                    case 29:
                      subDbACLandingsStartID = double.parse(v);
                      break;
                    case 76:
                      subDbE1TTStartID = double.parse(v);
                      break;
                    case 151:
                      subDbACTTStartID = double.parse(v);
                      break;
                  }
                });
              });
              if (strACHobbsStartID > 0 && subFormACHobbsStartID != subDbACHobbsStartID) {
                acHoursCheckDbIssues = "${acHoursCheckDbIssues}Current Aircraft Hobbs Start = $subDbACHobbsStartID Your Form: $subFormACHobbsStartID";
              }
              if (strACTTStartID > 0 && subFormACTTStartID != subDbACTTStartID) {
                acHoursCheckDbIssues = "${acHoursCheckDbIssues}Current Aircraft Total Time=$subDbACTTStartID Your Form: $subFormACTTStartID";
              }
              if (strACStartsStartID > 0 && subFormACStartsStartID != subDbACStartsStartID) {
                acHoursCheckDbIssues = "${acHoursCheckDbIssues}Current Engine Starts = $subDbACStartsStartID Your Form: $subFormACStartsStartID";
              }
              if (strACLandingsStartID > 0 && subFormACLandingsStartID != subDbACLandingsStartID) {
                acHoursCheckDbIssues = "${acHoursCheckDbIssues}Current Aircraft Landings = $subDbACLandingsStartID Your Form: $subFormACLandingsStartID";
              }
              if (strE1TTStartID > 0 && subFormE1TTStartID != subDbE1TTStartID) {
                acHoursCheckDbIssues = "${acHoursCheckDbIssues}Current Engine 1 Total = $subDbE1TTStartID Your Form: $subFormE1TTStartID";
              }
              if (acHoursCheckDbIssues == "") {
                saveDialogText = "Please Wait... Saving & Completing Form";
                await doSave();
              } else {
                return showDialog<void>(
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
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                              side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                            ),
                            title: Center(child: Text("The Aircraft Has Different Values Than Your Current Starting Values:\n$acHoursCheckDbIssues")),
                            titleTextStyle: TextStyle(
                              fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                              fontWeight: FontWeight.bold,
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                            ),
                            content: const Text("If Your Values are Correct, Press OK to Continue or Cancel to Return to the Form"),
                            contentTextStyle: TextStyle(
                              fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize)! + 3,
                              fontWeight: FontWeight.bold,
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Material(
                                    color: ColorConstants.primary,
                                    elevation: 10,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      side: const BorderSide(color: ColorConstants.red),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: SizeConstants.contentSpacing),
                                  Material(
                                    color: ColorConstants.red,
                                    elevation: 10,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      side: const BorderSide(color: Colors.transparent),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        saveDialogText = "Please Wait... Saving & Completing Form";
                                        await doSave();
                                      },
                                      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }
          }
        }
      }
      if (!acHoursCheckDbInProgress) {
        saveDialogText = "Please Wait... Saving & Completing Form";
        await doSave();
      }
    } else {
      saveDialogText = "Please Wait... Saving Form";
      await doSave();
    }
  }

  ///Made by Tayeb - 60% && Modified & Done by Surjit
  Future<void> doSave() async {
    LoaderHelper.loaderWithGifAndText(saveDialogText);

    if (jsClass["acc"]?.isNotEmpty ?? false) {
      //accessory with cyc and hobbs
      //check for blank values

      jsClass["accNum"]?.forEach((element) {
        if (double.tryParse(values[element?.toString() ?? ""]?.replaceAll(",", '') ?? "")?.isNaN ?? true) {
          values[element.toString()] = "0";
        }
      });

      String fieldId, value;
      jsClass["acc"]?.forEach((element) {
        fieldId = element?.toString() ?? "";
        if ((num.tryParse(values[fieldId]?.replaceAll(',', '') ?? "") ?? 0) > 0) {
          //accessory id
          values["accCStart_$fieldId"] = num.tryParse(values["accCStart_$fieldId"]?.replaceAll(',', '') ?? "")?.toStringAsFixed(0) ?? "0";
          values["accCAdd_$fieldId"] = num.tryParse(values["accCAdd_$fieldId"]?.replaceAll(',', '') ?? "")?.toStringAsFixed(0) ?? "0";
          values["accCEnd_$fieldId"] = num.tryParse(values["accCEnd_$fieldId"]?.replaceAll(',', '') ?? "")?.toStringAsFixed(0) ?? "0";
          values["accHStart_$fieldId"] = num.tryParse(values["accHStart_$fieldId"]?.replaceAll(',', '') ?? "")?.toStringAsFixed(1) ?? "0.0";
          values["accHAdd_$fieldId"] = num.tryParse(values["accHAdd_$fieldId"]?.replaceAll(',', '') ?? "")?.toStringAsFixed(1) ?? "0.0";
          values["accHEnd_$fieldId"] = num.tryParse(values["accHEnd_$fieldId"]?.replaceAll(',', '') ?? "")?.toStringAsFixed(1) ?? "0.0";

          value =
              "${values[fieldId]?.replaceAll(',', '')},${values["accCStart_$fieldId"]},${values["accCAdd_$fieldId"]},${values["accCEnd_$fieldId"]},${values["accHStart_$fieldId"]},${values["accHAdd_$fieldId"]},${values["accHEnd_$fieldId"]}";
        } else {
          value = "0,0,0,0,0.0,0.0,0.0";
        }
        values[fieldId.toString()] = value;
      });
    }
    var formFieldValues = [];
    for (var key in formFieldAllIds) {
      formFieldValues.add({"fieldId": key.toString(), "fieldValue": values[key] ?? ""});
    }
    Response response = await FormsApiProvider().submitFormData(
      fillOutFormId: strFormID.toString(),
      formName: strFormName.toString(),
      performCloseOut: values["PerformCloseOut"] ?? "",
      formType: values["FormType"] ?? "",
      isCloseOutForm: values["IsCloseOutForm"] ?? "",
      formFieldValues: formFieldValues,
    );
    if (response.statusCode == 200) {
      Get.offNamedUntil(
        Routes.viewUserForm,
        ModalRoute.withName(Routes.formsIndex),
        arguments: "afterSave",
        parameters: {
          "formId": strFormID.toString(),
          "formName": strFormName.toString(),
          "masterFormId": Get.parameters["masterFormId"]?.toString() ?? "",
          "performCloseOut": values["PerformCloseOut"] ?? "",
          "saveAndComplete": response.data["data"]["saveAndComplete"]?.toString() ?? "",
          "alreadyCompleted": response.data["data"]["alreadyCompleted"]?.toString() ?? "",
          "linkedFormFieldAction": response.data["data"]["linkedFormFieldAction"]?.toString() ?? "",
          "showStatusMessage": response.data["data"]["showStatusMessage"]?.toString() ?? "",
        },
      );
    }
    //document.submit.submit();
  }

  ///Made by Rahat - 60% && Modified & Done by Surjit
  Future<void> deleteFillOutForm({id, formName}) async {
    if (id > 0) {
      return showDialog<void>(
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
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                    side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                  ),
                  title: Center(child: Text("Confirm Form Delete (ID: $id)")),
                  titleTextStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                    color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                  ),
                  content: Row(
                    children: [
                      Icon(Icons.delete_forever_outlined, size: (Theme.of(context).textTheme.displayMedium?.fontSize)! + 3, color: Colors.red),
                      const SizedBox(width: 10),
                      const Flexible(child: Text("Are You Sure, Want To Delete?")),
                    ],
                  ),
                  contentTextStyle: TextStyle(
                    fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize)! + 3,
                    fontWeight: FontWeight.bold,
                    color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: ColorConstants.primary,
                          elevation: 10,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.buttonRadius), side: const BorderSide(color: ColorConstants.red)),
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                              child: Center(
                                child: Text(
                                  "Cancel Delete",
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, fontWeight: FontWeight.bold, color: ColorConstants.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: SizeConstants.contentSpacing),
                        Material(
                          color: ColorConstants.red,
                          elevation: 10,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.buttonRadius), side: const BorderSide(color: Colors.transparent)),
                          child: InkWell(
                            onTap: () async {
                              LoaderHelper.loaderWithGif();
                              Response response = await FormsApiProvider().generalAPICall(
                                url: '/forms/deleteFillOutForm',
                                apiCallType: 'POST',
                                postData: {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "formId": "$id"},
                              );
                              Get.back();
                              if (response.statusCode == 200) {
                                EasyLoading.dismiss();
                                if (response.data["data"] != null && response.data["data"] > 0) {
                                  if (Get.arguments == "formEdit") {
                                    Get.offNamedUntil(
                                      Routes.formsIndex,
                                      ModalRoute.withName(Routes.dashBoard),
                                      arguments: "afterDelete",
                                      parameters: {"formId": id.toString(), "formName": formName},
                                    );
                                  } else {
                                    Get.back(result: true);
                                  }
                                } else if (response.data["data"] == -1) {
                                  SnackBarHelper.openSnackBar(isError: true, message: 'You Do Not Have Access To Delete This Form ID: $id');
                                } else {
                                  SnackBarHelper.openSnackBar(isError: true, message: 'Form is not Found');
                                }
                              }
                              EasyLoading.dismiss();
                            },
                            borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                              child: Center(
                                child: Text(
                                  "Confirm Delete",
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, fontWeight: FontWeight.bold, color: ColorConstants.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: 'Not a valid Event.');
    }
  }

  ///Made by Rahat - 70% && Modified & Done by Surjit
  Future<void> loadOptionsListFillFromServiceTable({required String url, required String dropdownListId, required String optionsValue, required String selectText}) async {
    var dropdownId = dropdownListId;

    Response response = await FormsApiProvider().generalAPICall(
      url: url,
      apiCallType: 'POST',
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "dropdownListId": dropdownListId,
        "optionsValue": optionsValue,
        "selectText": selectText,
      },
    );
    if (response.statusCode == 200) {
      triggeredFieldsDropDownData.addIf(true, dropdownId, response.data["data"]);
    }
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  Future<void> searchFormFieldValues({strFormFieldType, strValue, liveSearchID}) async {
    addChoiceServiceTableData[liveSearchID.toString()] = [];
    //addChoiceServiceTableData.clear();
    /*var strTempString = strValue.replaceAll(RegExp('[/"]'), '');
    strTempString = strTempString.toUpperCase();
    values[liveSearchID] = strTempString;*/
    Response response = await FormsApiProvider().generalAPICall(
      url: "/forms/searchFormFieldValues",
      apiCallType: 'POST',
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "liveSearchId": liveSearchID.toString(),
        "formFieldType": strFormFieldType.toString(),
        "value": strValue.toString(),
      },
    );
    if (response.statusCode == 200) {
      if (response.data["data"]["formSTLookup"].any((element) => element["value"] == strValue.toUpperCase()) == false) {
        addChoiceServiceTableData[liveSearchID.toString()]?.add({"value": strValue.toUpperCase(), "requestToAdd": "1"});
      }
      addChoiceServiceTableData[liveSearchID.toString()]?.addAll(response.data["data"]["formSTLookup"]);
    }
  }

  ///Made by Rahat - 90% && Modified & Done by Surjit
  Future<void> setChoiceFromSearch({strFieldId, strValue, requestToAdd, serviceTableToAddTo}) async {
    if (requestToAdd == '1') {
      Response response = await FormsApiProvider().generalAPICall(
        apiCallType: 'POST',
        url: '/forms/setChoiceFromSearch',
        postData: {
          "systemId": UserSessionInfo.systemId.toString(),
          "userId": UserSessionInfo.userId.toString(),
          "fieldId": strFieldId.toString(),
          "RequestToAdd": requestToAdd.toString(),
          "value": strValue.toString(),
          "serviceTableToAdd": serviceTableToAddTo.toString(),
        },
      );
      if (response.statusCode == 200) {
        SnackBarHelper.openSnackBar(isError: false, message: 'Added $strValue To Table $serviceTableToAddTo');
      }
    }
    if (strValue != '' && strValue != null) {
      values[strFieldId.toString()] = strValue;
    } else {
      values.remove(strFieldId.toString());
    }
    //values["LiveSearchID-$strFieldId"] = "";
  }

  ///Made by Rahat - 90% && Modified & Done by Surjit - Called from RiskAssessmentJs
  Future<void> returnValueFormRiskAssessment({String? strID}) async {
    jsClass["raforms"]?.forEach((id) {
      attribute[id.toString()]!["rel"] = strID ?? "0";
    });
    await checkRiskAssessments();
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  Future<void> checkRiskAssessments() async {
    if (jsClass["raforms"]?.isNotEmpty ?? false) {
      var currentRaId = int.tryParse(attribute[jsClass["raforms"]?[0]?.toString() ?? ""]?["rel"] ?? "") ?? 0;
      var raFormsId = attribute[jsClass["raforms"]?[0]?.toString() ?? ""]?['id'] ?? "";

      await loadOptionsListRiskAssessment(
        url: "/forms/loadOptionsListRiskAssessment",
        dropdownListId: raFormsId,
        selectText: currentRaId,
        callBack: await riskAssessmentCallBack(value: "0", onChange: false, onClick: false),
      );
    }
  }

  ///Made by Rahat - 70% && Modified & Done by Surjit
  Future<void> loadOptionsListRiskAssessment({url, dropdownListId, selectText, callBack}) async {
    var dropdownId = dropdownListId;
    var options = [];

    Response response = await FormsApiProvider().generalAPICall(
      url: url,
      apiCallType: "POST",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "acId": values[strACPrimaryField.toString()] ?? "",
        "cuId": initialFillOutFormData["formFilloutMvc"]["objFormEditData"]["userId"] ?? UserSessionInfo.userId.toString(),
        "date": values[strFlightDateField.toString()] ?? "",
        "raFormId": dropdownListId,
        "currentRaId": selectText,
      },
    );
    if (response.statusCode == 200) {
      var name = "";
      var id = "";

      options.add({"id": "0", "name": "-- Select Risk Assessment --"});

      for (int i = 0; i < response.data["data"].length; i++) {
        id = response.data["data"][i]["id"];
        name = response.data["data"][i]["name"];
        if (name == "") {
          name = "No Title (ID: $id)";
        }
        options.add({"id": id, "name": "${id.contains("-") ? "-- Create New " : ""}$name"});
      }

      riskAssessmentDropDownData.addIf(true, dropdownId, options);

      if (callBack != null && callBack != '') {
        await callBack();
      }
    }
  }

  ///Done by Rahat - 70% && Modified & Done by Surjit
  Future<String?>? riskAssessmentCallBack({value, onChange, onClick}) async {
    if (onChange == true) {
      var currVal = int.parse(value);
      if (currVal.isNaN) {
        currVal = 0;
      }
      if (currVal < 0) {
        Future<dynamic>? riskIdData = Get.toNamed(
          Routes.raFillOutAndFollowUp,
          arguments: "FormFillOutRAChooser",
          parameters: {"riskId": currVal.toString().replaceAll("-", ""), "instanceId": "0", "aircraftId": values[strACPrimaryField.toString()] ?? "0"},
        );

        await riskIdData?.then((riskIdValue) async {
          if (riskIdValue != null) {
            await returnValueFormRiskAssessment(strID: riskIdValue);
          }
        });
        return await riskIdData;
      } else {
        await checkForm(doSave: false, fieldId: attribute[jsClass["raforms"]?[0]?.toString() ?? ""]?['id'] ?? "");
      }
    }
    if (onClick == true) {
      await checkRiskAssessments();
    }
    return null;
  }

  ///Made & Done by Surjit - 100%
  Future<void> autoSave() async {
    if (!saveInProgress && (jsClass["sn"]?.isNotEmpty ?? false)) {
      saveInProgress = true;
      var data = [];
      jsClass["sn"]?.forEach((element) {
        var d = <String, dynamic>{};
        d["id"] = element.toString();
        d["val"] = values[element.toString()] ?? "";
        data.add(d);
        //jsClass["sn"]?.remove(element);
      });
      jsClass["sn"]?.clear();
      Response response = await formsApiProvider.generalAPICall(
        apiCallType: "POST",
        url: "/forms/formAutoSave",
        postData: {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "formId": strFormID.toString(), "jsonData": data},
      );
      if (response.statusCode == 200) {
        lastSave.value = (response.data["data"]?.toString() ?? DateTimeHelper.timeFormatDefault.format(DateTimeHelper.now)).split(" ").last;
        saveInProgress = false;
      }
    }
  }

  ///Made by Tayeb - 80% && Modified & Done by Surjit
  Future<void> loadCurrentFuelFarmGallons({thisFuelFarmId}) async {
    Response response = await formsApiProvider.generalAPICall(
      showSnackBar: false,
      apiCallType: "POST",
      url: "/forms/loadCurrentFuelFarmGallons",
      postData: {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "fuelFarmId": thisFuelFarmId.toString()},
    );

    if (response.statusCode == 200) {
      values[strFuelFarmFilledStartID.toString()] = response.data["data"]?.toString() ?? "";
      values[strFuelFarmFilledToAddID.toString()] = "0";
      values[strFuelFarmFilledEndID.toString()] = response.data["data"]?.toString() ?? "";
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "Error Retrieving Fuel Farm Current Gallons: ${response.data["userMessage"]}");
    }
  }

  ///Made by Rahat - 70% && Modified & Done by Surjit
  Future<bool> formCheckTime({required String field}) async {
    var strValue = "";
    var errorMsg = "";

    strValue = values[field] ?? "";

    var length = strValue.length;

    if (length == 4) {
      var first1 = strValue.substring(0, 2);
      var first2 = strValue.substring(2, 4);
      strValue = "$first1:$first2";
      values[field] = strValue;
    }
    if (length == 3) {
      var first1 = strValue.substring(0, 1);
      var first2 = strValue.substring(1, 3);
      strValue = "0$first1:$first2";
      values[field] = strValue;
    }
    var re = RegExp(r'^(\d{1,2}):(\d{2})(:00)?([ap]m)?$');
    if (strValue != '') {
      if (re.hasMatch(strValue)) {
        var regs = re.allMatches(strValue).map((m) => m.groups([0, 1, 2, 3, 4])).toList();
        if (regs[0][4] != null) {
          // 12-hour time format with am/pm
          if (int.parse(regs[0][1].toString()) < 1 || int.parse(regs[0][1].toString()) > 12) {
            errorMsg = "Invalid value for hours: ${regs[0][1]}";
          }
        } else {
          // 24-hour time format
          if (int.parse(regs[0][1].toString()) > 23) {
            errorMsg = "Invalid value for hours: ${regs[0][1]}";
          }
        }
        if (errorMsg.isEmpty && int.parse(regs[0][2].toString()) > 59) {
          errorMsg = "Invalid value for minutes: ${regs[0][2]}";
        }
      } else {
        errorMsg = "Invalid time format: $strValue";
      }
    }

    if (errorMsg != '') {
      SnackBarHelper.openSnackBar(isError: true, message: errorMsg);
      return false;
    }
    await checkForm(doSave: false, fieldId: field);
    return true;
  }

  ///Made & Done by Surjit - 100%
  bool isDate({required String date}) {
    String d = date;
    //var currVal = txtDate;
    //if(currVal == '') return false;

    //Declare Regex  Pattern
    var regExp = RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$'); //RegExp(r'^(\d{1,2})([/-])(\d{1,2})([/-])(\d{4})$');

    //var rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/; Pattern for MM/DD/YYYY or MM-DD-YYYY
    //var dtArray = currVal.match(rxDatePattern); // is format OK?

    //if (dtArray == null) return false;

    //Checks for mm/dd/yyyy format.
    //dtMonth = dtArray[1];
    //dtDay = dtArray[3];
    //dtYear = dtArray[5];

    /*if (dtMonth < 1 || dtMonth > 12)
      return false;
    else if (dtDay < 1 || dtDay> 31)
      return false;
    else if ((dtMonth==4 || dtMonth==6 || dtMonth==9 || dtMonth==11) && dtDay ==31)
      return false;
    else if (dtMonth == 2) {
      var isLeap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
      if (dtDay> 29 || (dtDay ==29 && !isLeap))
        return false;
    }*/

    if (!regExp.hasMatch(d)) {
      return false;
    } else {
      var spd = d.split("/"); //d.split(RegExp(r'[/-]'));

      //Checks for mm/dd/yyyy format.
      var month = int.parse(spd[0]);
      var day = int.parse(spd[1]);
      var year = int.parse(spd[2]);

      // check leap year
      var isLeapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);

      var i = isLeapYear ? 1 : 0;
      if (month == 2 && day > 28 + i) {
        return false;
      }

      var dayUpperLimit = 30;
      switch (month) {
        case 1: //January
        case 3: // March
        case 5: // May
        case 7: // July
        case 8: // August
        case 10: // October
        case 12: // December
          dayUpperLimit = 31;
          break;
      }
      // check valid month or day
      if (month > 12 || day > dayUpperLimit) {
        return false;
      }

      if (month < 1 || day < 1 || year < 1) {
        return false;
      }
    }
    return true;
  }

  //TODO:-------------Need to Check----------------
  ///Made by Tayeb - 40%, Modified by Rahat - 40% && Modified & Done by Surjit
  Future<void> signatureSearchExtended({strFormFieldId, currentSignatureRecordId, searchTerm}) async {
    Response response = await FormsApiProvider().generalAPICall(
      showSnackBar: false,
      url: "/forms/signatureSearchExtended",
      apiCallType: "POST",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "signatureRecordId": currentSignatureRecordId.toString(),
        "formFieldId": strFormFieldId.toString(),
        "searchTerm": searchTerm.toString(),
      },
    );
    if (response.statusCode == 200) {
      signaturePenAllData.clear();
      signaturePenData.clear();
      signaturePenAllData.addAll(response.data["data"]);
      signaturePenData.addAll(response.data["data"]["signaturePenData"]);
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Signature Information!");
    }
  }

  ///Made by Tayeb - 40%, Modified by Rahat - 40% && Modified & Done by Surjit
  Future<void> signatureLoadSaved({strFormFieldId, currentSignatureRecordId, strSignatureIdSelected}) async {
    var drawSignaturePointData = {};
    List<Point>? signaturePointList = [];

    Response response = await formsApiProvider.generalAPICall(
      showSnackBar: false,
      apiCallType: "POST",
      url: "/forms/signatureLoadSaved",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "formFieldId": strFormFieldId.toString(),
        "signatureIdSelected": strSignatureIdSelected.toString(),
        "currentSignatureRecordId": currentSignatureRecordId.toString(),
      },
    );

    if (response.statusCode == 200) {
      try {
        drawSignaturePointData = jsonDecode(response.data["data"]);
        for (var i = 0; i < drawSignaturePointData["lines"].length; i++) {
          var v = drawSignaturePointData["lines"][i];
          for (var j = 0; j < v.length; j++) {
            if (j == 0 || j == v.length - 1) {
              signaturePointList.add(Point(Offset(double.parse(v[j][0].toString()), double.parse(v[j][1].toString())), PointType.tap, 1.0));
            } else {
              signaturePointList.add(Point(Offset(double.parse(v[j][0].toString()), double.parse(v[j][1].toString())), PointType.move, 1.0));
            }
          }
        }
        signaturePointLists.addIf(true, strFormFieldId, signaturePointList);
      } catch (_) {
        Get.back();
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "Unable To Retrieve Information");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable To Retrieve Information");
    }
    drawSignaturePointData.clear();
  }

  ///Mde by Tayeb - 20% && Modified & Done by Surjit
  Future<void> viewRouting({strFormId}) async {
    Response response = await formsApiProvider.generalAPICall(
      apiCallType: "POST",
      url: "/forms/viewRouting",
      postData: {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "formId": strFormId.toString(), "action": "ViewDemographics"},
    );
    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      var data = response.data["data"];
      showAdaptiveDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder:
            (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: AlertDialog(
                elevation: 1,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                titlePadding: const EdgeInsets.all(10.0),
                title: const Text("Form Routing:", textAlign: TextAlign.center),
                titleTextStyle: TextStyle(
                  fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 2,
                  fontWeight: FontWeight.bold,
                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                ),
                contentPadding: const EdgeInsets.all(10.0),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: ColorConstants.primary,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "Routing Rules:",
                            style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                          ),
                        ),
                      ),
                      Material(
                        color: ColorConstants.primary.withValues(alpha: 0.8),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Level:",
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Type:",
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "User / Role:",
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ...List.generate(
                        data["objFormsRoutingDataForViewDemographicsList"].length,
                        (index) => Material(
                          borderRadius:
                              index == (data["objFormsRoutingDataForViewDemographicsList"].length - 1)
                                  ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                  : BorderRadius.zero,
                          color: index % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.5) : ColorConstants.primary.withValues(alpha: 0.3),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${data["objFormsRoutingDataForViewDemographicsList"][index]["routingLevel"] ?? ""}",
                                    style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    data["objFormsRoutingDataForViewDemographicsList"][index]["routingType"] != null
                                        ? data["objFormsRoutingDataForViewDemographicsList"][index]["routingType"].trim() == "I"
                                            ? "Individual"
                                            : "User Role"
                                        : "",
                                    style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    data["objFormsRoutingDataForViewDemographicsList"][index]["routingType"] != null
                                        ? data["objFormsRoutingDataForViewDemographicsList"][index]["routingType"].trim() == "I"
                                            ? data["objFormsRoutingDataForViewDemographicsList"][index]["userFullName"] ?? ""
                                            : data["objFormsRoutingDataForViewDemographicsList"][index]["objTop1RoleTitleData"]["roleTitle"] ?? ""
                                        : "",
                                    style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: ColorConstants.primary,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0, right: data["objRoutingApprovalList"].isEmpty ? 5.0 : 0.0),
                          child: Text(
                            "Routing Signatures & Advancements:",
                            style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                          ),
                        ),
                      ),
                      if (data["objRoutingApprovalList"].isEmpty)
                        Material(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          color: ColorConstants.primary.withValues(alpha: 0.5),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              "None",
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ...List.generate(
                        data["objRoutingApprovalList"].length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (Get.width < 480) ...{
                              Material(
                                color: ColorConstants.primary.withValues(alpha: 0.8),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Signed Time:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Routing Level:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: ColorConstants.primary.withValues(alpha: 0.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          data["objRoutingApprovalList"][index]["signedTime"] ?? "",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${data["objRoutingApprovalList"][index]["formFieldId"] ?? ""}",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: ColorConstants.primary.withValues(alpha: 0.8),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          "User:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          "Routing Decision:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: ColorConstants.primary.withValues(alpha: 0.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          data["objRoutingApprovalList"][index]["signedBy"] ?? "",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          data["objRoutingApprovalList"][index]["routingDecision"] ?? "",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            },
                            if (Get.width > 480) ...{
                              Material(
                                color: ColorConstants.primary.withValues(alpha: 0.8),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Signed Time:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Routing Level:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "User:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Routing Decision:",
                                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: ColorConstants.primary.withValues(alpha: 0.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          data["objRoutingApprovalList"][index]["signedTime"] ?? "",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${data["objRoutingApprovalList"][index]["formFieldId"] ?? ""}",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          data["objRoutingApprovalList"][index]["signedBy"] ?? "",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          data["objRoutingApprovalList"][index]["routingDecision"] ?? "",
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            },
                            Material(
                              borderRadius:
                                  index + 1 == data["objRoutingApprovalList"].length
                                      ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                      : BorderRadius.zero,
                              color: ColorConstants.primary.withValues(alpha: 0.3),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  data["objRoutingApprovalList"][index]["notes"] ?? "",
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                actions: [GeneralMaterialButton(buttonText: "CLOSE", buttonColor: ColorConstants.primary, borderColor: ColorConstants.red, onPressed: () => Get.back())],
              ),
            ),
      );
    }
  }

  ///Mde by Tayeb - 20% && Modified & Done by Surjit
  Future<void> advanceRouting({
    strFormId,
    TextEditingController? controller,
    notesController,
    userName,
    required List? userDropDownData,
    selectedUserData,
    onDialogPopUp,
    onTapSignForm,
    onChangedUser,
  }) async {
    signatureMode = 1;
    Response response = await formsApiProvider.generalAPICall(
      apiCallType: "POST",
      url: "/forms/viewRouting",
      postData: {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "formId": strFormId.toString(), "action": "Advance"},
    );
    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      var data = response.data["data"];
      var approvalStatus = "".obs;
      var emailFormCreator = "".obs;
      values['AdvanceRoutingForm_ID'] = strFormId.toString();
      values.remove("AdvanceRoutingSubmit");
      showAdaptiveDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder:
            (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: const Text("Advance / Demote Form Routing", textAlign: TextAlign.center),
                titleTextStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                ),
                titlePadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                content: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      defaultColumnWidth: Get.width > 480 ? const IntrinsicColumnWidth() : const FlexColumnWidth(),
                      border: const TableBorder.symmetric(inside: BorderSide(width: 1.0, color: Colors.black)),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.3)]),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Form Created By:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                data["objFormsViewDetailsByID"]["userNameCreated"] ?? "",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.5)])),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Form Information:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 2.0,
                                runSpacing: 2.0,
                                children: [
                                  RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      text: "Created: ",
                                      style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                        color: ThemeColorMode.isLight ? ColorConstants.black : ColorConstants.white,
                                      ),
                                      children: [TextSpan(text: data["objFormsViewDetailsByID"]["createdAt"] ?? "", style: const TextStyle(fontWeight: FontWeight.w600))],
                                    ),
                                  ),
                                  RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      text: "Completed: ",
                                      style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                        color: ThemeColorMode.isLight ? ColorConstants.black : ColorConstants.white,
                                      ),
                                      children: [TextSpan(text: data["objFormsViewDetailsByID"]["completedAt"] ?? "", style: const TextStyle(fontWeight: FontWeight.w600))],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.3)])),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Current Routing Level:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "${data["objFormsViewDetailsByID"]["routingLevelCurrent"] ?? ""} of ${data["objFormsViewDetailsByID"]["routingLevelMax"] ?? ""}",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.5)])),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Approval Status:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Obx(() {
                                return DropdownMenu(
                                  menuHeight: Get.height - 200,
                                  textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                  trailingIcon: Icon(Icons.keyboard_arrow_down, size: (Theme.of(context).textTheme.bodyMedium?.fontSize)! + 10, color: ColorConstants.black),
                                  expandedInsets: EdgeInsets.zero,
                                  hintText: approvalStatus.value != "" ? approvalStatus.value : "Select Approval Status",
                                  inputDecorationTheme: InputDecorationTheme(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
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
                                  ),
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry<dynamic>(
                                      value: const {"id": "0", "value": "Select Approval Status"},
                                      label: "Select Approval Status",
                                      style: ButtonStyle(textStyle: WidgetStatePropertyAll(Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal))),
                                    ),
                                    if (data["objFormsViewDetailsByID"]["canAdvance"] == 1)
                                      DropdownMenuEntry<dynamic>(
                                        value: {"id": "A", "value": "Approve & ${data["advanceNote"] ?? ""}"},
                                        label: "Approve & ${data["advanceNote"] ?? ""}",
                                        style: ButtonStyle(textStyle: WidgetStatePropertyAll(Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal))),
                                      ),
                                    if (data["objFormsViewDetailsByID"]["canDemote"] == 1)
                                      DropdownMenuEntry<dynamic>(
                                        value: const {"id": "U", "value": "Demote Form To User Level"},
                                        label: "Demote Form To User Level",
                                        style: ButtonStyle(textStyle: WidgetStatePropertyAll(Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal))),
                                      ),
                                  ],
                                  onSelected: (val) {
                                    approvalStatus.value = val["value"];
                                    values['AdvanceRoutingAction'] = val["id"];
                                    advanceRoutingFeatures(strAdvanceFeatures: val["id"]);
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.3)])),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Notes:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: notesController,
                                cursorColor: Colors.black,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                style: Theme.of(
                                  Get.context!,
                                ).textTheme.bodyMedium?.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4, color: ColorConstants.black),
                                onChanged: (String? value) {
                                  values['AdvanceRoutingNotes'] = value ?? "";
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Notes (Optional)",
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.5)])),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Email Form Creator:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Obx(() {
                                return DropdownMenu(
                                  menuHeight: Get.height - 200,
                                  textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                  trailingIcon: Icon(Icons.keyboard_arrow_down, size: (Theme.of(context).textTheme.bodyMedium?.fontSize)! + 10, color: ColorConstants.black),
                                  expandedInsets: EdgeInsets.zero,
                                  hintText: emailFormCreator.value != "" ? emailFormCreator.value : "Yes",
                                  inputDecorationTheme: InputDecorationTheme(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
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
                                  ),
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry<dynamic>(
                                      value: const {"id": "1", "value": "Yes"},
                                      label: "Yes",
                                      style: ButtonStyle(textStyle: WidgetStatePropertyAll(Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal))),
                                    ),
                                    DropdownMenuEntry<dynamic>(
                                      value: const {"id": "0", "value": "No"},
                                      label: "No",
                                      style: ButtonStyle(textStyle: WidgetStatePropertyAll(Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal))),
                                    ),
                                  ],
                                  onSelected: (val) {
                                    emailFormCreator.value = val["value"];
                                    values['AdvanceRoutingEmailUser'] = val["id"];
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            gradient: LinearGradient(colors: [ColorConstants.primary, ColorConstants.primary.withValues(alpha: 0.3)]),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(
                                "Update Routing:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Obx(() {
                              return values["AdvanceRoutingSubmit"] == ''
                                  ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GeneralMaterialButton(
                                      buttonText: "Proceed To Signature Validation",
                                      buttonTextSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                      icon: Icons.edit_note,
                                      //Icons.draw,
                                      borderColor: ColorConstants.primary,
                                      onPressed: () async {
                                        advanceRoutingItems();
                                        await onDialogPopUp();
                                        var obscureTextShow = true.obs;
                                        controller?.clear();
                                        DialogHelper.openCommonDialogBox(
                                          title: "${UserSessionInfo.systemName} Electronic Signature",
                                          message: "By Clicking Below, You Are Certifying The Form Is Accurate.",
                                          centerTitle: true,
                                          enableWidget: true,
                                          widgetButtonTitle: "Sign Form",
                                          onTap: onTapSignForm,
                                          children: [
                                            const Text("By Clicking Below, You Are Certifying The Form Is Accurate."),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Expanded(child: Text("Name : ")),
                                                Expanded(
                                                  flex: 2,
                                                  child: DropdownMenu(
                                                    menuHeight: Get.height - 200,
                                                    textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                                    trailingIcon: Icon(Icons.keyboard_arrow_down, size: 18, color: ColorConstants.black.withValues(alpha: 0.5)),
                                                    expandedInsets: EdgeInsets.zero,
                                                    hintText: selectedUserData["fullName"] ?? userName,
                                                    inputDecorationTheme: InputDecorationTheme(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
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
                                                    ),
                                                    dropdownMenuEntries:
                                                        userDropDownData == null
                                                            ? []
                                                            : userDropDownData.map((value) {
                                                              return DropdownMenuEntry<dynamic>(
                                                                value: value,
                                                                label: "${value["fullName"]}",
                                                                style: ButtonStyle(
                                                                  textStyle: WidgetStatePropertyAll(
                                                                    Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                    onSelected: (val) {
                                                      onChangedUser(val);
                                                    },
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
                                                    validator: FormBuilderValidators.required(errorText: "Password is Required!"),
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    builder: (FormFieldState<dynamic> field) {
                                                      return Obx(() {
                                                        return TextField(
                                                          controller: controller,
                                                          cursorColor: Colors.black,
                                                          style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
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
                                                            hintStyle: TextStyle(
                                                              color: ColorConstants.grey,
                                                              fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 6,
                                                            ),
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
                                                              icon: Icon(
                                                                size: 18,
                                                                obscureTextShow.value ? Feather.eye : Feather.eye_off,
                                                                color: ColorConstants.black.withValues(alpha: 0.5),
                                                              ),
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
                                        );
                                      },
                                    ),
                                  )
                                  : const SizedBox();
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                actions: [
                  GeneralMaterialButton(
                    buttonText: "CLOSE",
                    buttonColor: ColorConstants.primary,
                    borderColor: ColorConstants.red,
                    onPressed: () {
                      notesController.clear();
                      Get.back();
                    },
                  ),
                ],
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.0),
              ),
            ),
      );
    }
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  void advanceRoutingFeatures({strAdvanceFeatures}) {
    if (strAdvanceFeatures == '0') {
      values["AdvanceRoutingSubmit"] = 'none';
    } else {
      values["AdvanceRoutingSubmit"] = '';
    }
  }

  ///Made by Rahat - 90% && Modified & Done by Surjit
  void advanceRoutingItems() {
    advanceRoutingFormID = values['AdvanceRoutingForm_ID'] ?? Get.parameters["formId"] ?? strFormID.toString();
    advanceRoutingAction = values['AdvanceRoutingAction'] ?? "0";
    advanceRoutingNotes = values['AdvanceRoutingNotes'] ?? "";
    advanceRoutingEmailUser = values['AdvanceRoutingEmailUser'] ?? "1";
    performSignature(strFieldID: '-1');
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  void performSignature({strFieldID}) {
    values['signaturePWD'] = '';
    values['formFieldID'] = strFieldID;
  }

  ///Made by Rahat - 60% && Modified & Done by Surjit
  Future<bool> performSignatureValidation({userID, password}) async {
    var userId = userID ?? UserSessionInfo.userId.toString();
    var pwd = password.toString();
    if (pwd == '') {
      SnackBarHelper.openSnackBar(isError: true, message: "Password can't be Blank, Password is Required!");
      return false;
    } else {
      Response response;
      if (signatureMode == 0) {
        //User Sign
        response = await FormsApiProvider().generalAPICall(
          showSnackBar: false,
          url: "/forms/performSignatureValidation",
          apiCallType: "POST",
          postData: {
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": userId.toString(),
            "formID": strFormID != 0 ? strFormID.toString() : Get.parameters["formId"],
            "formFieldId": values['formFieldID'] ?? "",
            "password": pwd.toString(),
            "sMode": "Form_Signature",
          },
        );
      } else {
        response = await FormsApiProvider().generalAPICall(
          url: "/forms/performSignatureValidation",
          apiCallType: "POST",
          postData: {
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": userId.toString(),
            "formID": strFormID != 0 ? strFormID.toString() : Get.parameters["formId"],
            "formFieldId": values['formFieldID'] ?? "",
            "password": pwd.toString(),
            "sMode": "ValidateOnly",
          },
        );
      }
      if (response.statusCode == 200) {
        if ((int.tryParse(response.data["data"]?.toString() ?? "") ?? 0) >= 1) {
          if (signatureMode == 0) {
            return true;
          } else {
            Response response = await FormsApiProvider().generalAPICall(
              showSnackBar: false,
              url: "/forms/postAdvanceRouting",
              apiCallType: "POST",
              postData: {
                "systemId": UserSessionInfo.systemId.toString(),
                "userId": userId.toString(),
                "formId": strFormID != 0 ? strFormID.toString() : Get.parameters["formId"] ?? advanceRoutingFormID,
                "advanceRoutingAction": advanceRoutingAction,
                "advanceRoutingNotes": advanceRoutingNotes,
                "advanceRoutingEmailUser": advanceRoutingEmailUser,
              },
            );
            if (response.statusCode == 200) {
              //var data = response.data["data"];
              SnackBarHelper.openSnackBar(isError: false, message: response.data["userMessage"]?.toString().split("||").first);
              return true;
            } else {
              SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
            }
          }
        } else {
          SnackBarHelper.openSnackBar(isError: true, message: 'Unable To Verify Your Password. Please Verify Your Password And Try Again.');
        }
      } else if (response.statusCode == 400 && response.data["data"] == 0) {
        SnackBarHelper.openSnackBar(isError: true, message: 'Unable To Verify Your Password. Please Verify Your Password And Try Again.');
      } else {
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while submitting your request.\nTry Again Later or Contact Digital AirWare.");
      }
    }
    return false;
  }

  ///Made by Rahat - 90% && Modified & Done by Surjit
  Future<void> updateSignatureName({signatureRecordID, strName}) async {
    Response response = await FormsApiProvider().generalAPICall(
      url: '/forms/updateSignatureName',
      apiCallType: 'POST',
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "signatureId": signatureRecordID.toString(),
        "signatureName": strName.toString(),
      },
    );
    if (response.statusCode == 200) {
      //SnackBarHelper.openSnackBar(isError: false, message: response.data["remarks"]); //"ok"
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: response.data["errorMessages"]); //"Error Saving Data: ${response.data["data"]}"
    }
  }

  ///Made by Rahat - 80% && Modified & Done by Surjit
  Future<void> updateSignature({strFormFieldID, signatureRecordID, savedOnFile}) async {
    Response response = await FormsApiProvider().generalAPICall(
      url: '/forms/updateSignature',
      apiCallType: 'POST',
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "signatureData": jsonEncode(penSignatureDataList[strFormFieldID.toString()]),
        "signatureId": signatureRecordID.toString(),
        "signatureName": values[strFormFieldID.toString()] ?? "",
        "saveOnFiles": savedOnFile.toString(),
      },
    );
    if (response.statusCode == 200) {
      await updateSignatureName(signatureRecordID: signatureRecordID.toString(), strName: values[strFormFieldID.toString()] ?? "");
      if (savedOnFile) SnackBarHelper.openSnackBar(isError: false, message: "Signature Saved On File");
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: response.data["errorMessages"]);
    }
  }

  ///Made by Rahat & Tayeb - 100%
  //Case 2,143 'CheckBox & FAA Laser Strike Reporting
  showHideText({fieldId}) {
    if (values[fieldId.toString()] == 'off') {
      values[fieldId.toString()] = 'on';
    } else {
      values[fieldId.toString()] = 'off';
    }
  }

  ///Mde by Tayeb - 30% && Modified & Done by Surjit
  Future<void> viewHistory({required String formId}) async {
    String formID = "ID: $formId)";
    bool sysOp = UserPermission.sysOp.value;

    Response response = await formsApiProvider.generalAPICall(
      showSnackBar: false,
      apiCallType: "POST",
      url: "/forms/viewHistory",
      postData: {
        "systemId": UserSessionInfo.systemId.toString(),
        "userId": UserSessionInfo.userId.toString(),
        "formId": formId.toString(),
        "searchField": "VERBOSE",
        "numberOfResults": "100",
        "q": formID.toString(),
      },
    );
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      List data = response.data["data"]["objGetTopLogData"];
      showAdaptiveDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder:
            (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Text("(Searched [All Text Fields] For $formID", textAlign: TextAlign.center),
                titleTextStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                ),
                titlePadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: ColorConstants.primary.withValues(alpha: 0.8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Date",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            if (sysOp)
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Service",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "IP Address",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (Get.width > 980)
                              Expanded(
                                flex: 7,
                                child: Text(
                                  "Event",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      ...List.generate(data.length, (index) {
                        return Material(
                          borderRadius: index + 1 == data.length ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : null,
                          color: index % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text("${index + 1}", style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize)),
                                        if (sysOp) Icon(Icons.clear, size: (Theme.of(context).textTheme.bodyMedium?.fontSize)! + 5, color: ColorConstants.red),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(data[index]["eveDate"], textAlign: TextAlign.center, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize)),
                                  ),
                                  if (sysOp)
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        data[index]["systemId"]?.toString() ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
                                      ),
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${data[index]["eveLastName"]}, ${data[index]["eveFirstName"]} (${data[index]["eveId"]})",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
                                    ),
                                  ),
                                  Expanded(flex: 3, child: Center(child: Text(data[index]["eveIP"], style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize)))),
                                  if (Get.width > 980)
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: RichText(
                                          textScaler: TextScaler.linear(Get.textScaleFactor),
                                          text: TextSpan(
                                            text: (data[index]["eveMsg"]?.toString() ?? "").replaceAll(formID, "").toUpperCase(),
                                            style: TextStyle(
                                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                              color: ThemeColorMode.isLight ? ColorConstants.black : ColorConstants.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: formID.replaceAll(")", ""),
                                                style: TextStyle(
                                                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorConstants.red,
                                                ),
                                              ),
                                              const TextSpan(text: ")"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (Get.width < 980)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Event",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.primary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 11,
                                      child: RichText(
                                        textScaler: TextScaler.linear(Get.textScaleFactor),
                                        text: TextSpan(
                                          text: (data[index]["eveMsg"]?.toString() ?? "").split(formID)[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                            color: ThemeColorMode.isLight ? ColorConstants.black : ColorConstants.white,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: formID.replaceAll(")", ""),
                                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.red),
                                            ),
                                            const TextSpan(text: ")"),
                                            TextSpan(text: (data[index]["eveMsg"]?.toString() ?? "").split(formID)[1].toUpperCase()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                actions: [GeneralMaterialButton(buttonText: "CLOSE", buttonColor: ColorConstants.primary, borderColor: ColorConstants.red, onPressed: () => Get.back())],
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.0),
              ),
            ),
      );
    } else if (response.statusCode == 400) {
      showAdaptiveDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder:
            (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Text("(Searched [All Text Fields] For $formID", textAlign: TextAlign.center),
                titleTextStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                ),
                titlePadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      color: ColorConstants.primary.withValues(alpha: 0.8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "#",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Date",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                            ),
                          ),
                          if (sysOp)
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Service",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "IP Address",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Event",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      color: ColorConstants.primary.withValues(alpha: 0.5),
                      child: Center(
                        child: Text(
                          "No Results Found...",
                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize, fontWeight: FontWeight.w600, color: ColorConstants.white),
                        ),
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                actions: [GeneralMaterialButton(buttonText: "CLOSE", buttonColor: ColorConstants.primary, borderColor: ColorConstants.red, onPressed: () => Get.back())],
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.0),
              ),
            ),
      );
    } else {
      SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
    }
  }

  //TODO:-------------Not Used----------------

  ///Done by Tayeb - 100% (Not Used)
  //Case 36 'Fuel Input (UPDATE AC FUEL IN LBS)'
  double validateNumber({strValue, strNumberOfDecimals}) {
    strValue = num.tryParse(strValue.replaceAll(",", ""));

    if (double.parse(strValue).isNaN || strValue.isFinite == false) {
      strValue = 0;
    }

    var strTemp = double.parse(((strValue * 100) / 100).round()).toPrecision(strNumberOfDecimals);

    if (strTemp < 0) {
      strTemp = 0;
    }
    return strTemp;
  }

  ///Done by Rahat - 100%
  Future<void> signatureLookUp({strFormFieldID, currentSignatureRecordID}) {
    return DialogHelper.openCommonDialogBox(message: 'Signature Lookup /Forms/SavedSignatures?FieldId=$strFormFieldID&SignatureRecordId$currentSignatureRecordID');
  }

  ///Done by Tayeb - 100%
  void fillOutWeightInString({strThisValue, strFieldIdNumber}) {
    var pos1 = strThisValue.indexOf("(");
    var pos2 = strThisValue.indexOf("Kg)");

    if (pos1 > 0 && pos2 > 0) {
      strThisValue.substring(pos1 + 1, pos2);
    }

    if (double.parse(strThisValue).isNaN || strThisValue.isFinite == false) {
      var productElement = values[strFieldIdNumber.toString()];

      if (productElement != null) {
        productElement = strThisValue;
      }
    }
  }

  ///---------------- Helper Functions ----------------------------///

  ///Done by Tayeb - 100%
  String? globalReplace({String? stringBeginning, required String stringToFind, required String replaceWith}) {
    var regex = stringToFind.replaceAll(RegExp(stringToFind), "g");
    var finalResult = stringBeginning?.replaceAll(RegExp(regex), replaceWith);
    finalResult = finalResult?.replaceAll(RegExp(stringToFind), replaceWith); //Legacy
    finalResult = finalResult?.replaceAll(RegExp(stringToFind), replaceWith); //Legacy
    finalResult = finalResult?.replaceAll(RegExp(stringToFind), replaceWith); //Legacy

    return finalResult;
  }

  ///Made by Tayeb - 10% && Modified & Done by Surjit
  Future<void> importCloseOut({required String formId}) async {
    LoaderHelper.loaderWithGifAndText("Loading Importer...");
    Map formDesignerImportAllData = <dynamic, dynamic>{};

    Response response = await FormsApiProvider().getFormDesignerImport(formId: formId);

    if (response.statusCode == 200) {
      formDesignerImportAllData = response.data["data"];

      int systemID = formDesignerImportAllData["systemId"] ?? UserSessionInfo.systemId;
      int strFirstUserFieldID = formDesignerImportAllData["firstUserFieldId"] ?? 0;
      int strUserIDCreatingForm = formDesignerImportAllData["userIdCreatingForm"] ?? 0;
      int arrUsersInFormRows = formDesignerImportAllData["arrUsersInFormRows"] ?? 0;

      List<List> arrUsersInFormData = <List<dynamic>>[];
      formDesignerImportAllData["usersInForm"].forEach((key, value) {
        arrUsersInFormData.insert(int.parse(key.toString()), value);
      });
      String arrUsersInForm(int i, int j) => arrUsersInFormData[i][j];

      //Demographics with Flight Date, Aircraft, Airports, Remarks
      Map demographicsData = formDesignerImportAllData["objImportDemographics"] as Map<String, dynamic>;
      //Flight Date
      String strFlightDate =
          demographicsData["flightDate"] == "01/01/1900" ? DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now) : demographicsData["flightDate"] ?? "01/01/1900";
      //Aircraft
      List aircraftDropDownData = [];
      aircraftDropDownData = formDesignerImportAllData["objAircraftDataList"] ?? [];
      String strAircraft =
          aircraftDropDownData.isNotEmpty
              ? aircraftDropDownData.singleWhere(
                (element) => element["id"].toString() == demographicsData["aircraftId"].toString(),
                orElse: () => aircraftDropDownData.first,
              )["aircraft"]
              : "";
      //Airports
      String strRouteFrom = demographicsData["routeFrom"] ?? "";
      String strRouteTo = demographicsData["routeTo"] ?? "";
      String strViaPoints = demographicsData["routeVia"] ?? "";
      //Remarks
      String strRemarks = demographicsData["remarks"] ?? "";

      //User List with Include User
      //Include User

      Map<String, dynamic> formDesignerImportLocalVariables = formDesignerImportAllData["objAllUsedLocalVariable"];
      //Times with Duration Of Flight, PIC Time, SIC Time, Cross Country Time, Instructor Time (CFI), Dual Time Received, Solo Time Received
      //Duration Of Flight
      double strDurationOfFlight = formDesignerImportLocalVariables["durationOfFlight"] ?? 0.0;
      int strPilotID = formDesignerImportLocalVariables["pilotID"] ?? 0;
      int strCoPilotID = formDesignerImportLocalVariables["coPilotID"] ?? 0;
      String strCrew1 = formDesignerImportLocalVariables["crew1"] ?? "";
      String strCrew2 = formDesignerImportLocalVariables["crew2"] ?? "";
      String strCrew3 = formDesignerImportLocalVariables["crew3"] ?? "";
      String strCrew4 = formDesignerImportLocalVariables["crew4"] ?? "";
      String strCrew5 = formDesignerImportLocalVariables["crew5"] ?? "";
      String strCrew1Hours = formDesignerImportLocalVariables["crew1Hours"] ?? "";
      String strCrew2Hours = formDesignerImportLocalVariables["crew2Hours"] ?? "";
      String strCrew3Hours = formDesignerImportLocalVariables["crew3Hours"] ?? "";
      String strCrew4Hours = formDesignerImportLocalVariables["crew4Hours"] ?? "";
      String strCrew5Hours = formDesignerImportLocalVariables["crew5Hours"] ?? "";

      //PIC Time
      double strPICTime = formDesignerImportLocalVariables["picTime"] ?? 0.0;
      int strPICTimeUsed = formDesignerImportLocalVariables["picTimeUsed"] ?? 0;
      String piCId = formDesignerImportLocalVariables["piC_Id"] ?? "";
      String piCPicTime = formDesignerImportLocalVariables["piC_PicTime"] ?? "";
      String pilotPIC = formDesignerImportLocalVariables["pilot_PIC"] ?? "";
      String strPilotPICTime = formDesignerImportLocalVariables["pilot_PICTime"] ?? "";
      String strCoPilotPICTime = formDesignerImportLocalVariables["coPilot_PICTime"] ?? "";
      String piCPilot1 = formDesignerImportLocalVariables["piC_Pilot1"] ?? "";
      String picPIC = formDesignerImportLocalVariables["piC_PIC"] ?? "";
      int strNjspPilotId = formDesignerImportLocalVariables["njspPilotId"] ?? 0;
      String strNjspPilotPicTime = formDesignerImportLocalVariables["njspPilotPicTime"] ?? "";
      String strEpsPic = formDesignerImportLocalVariables["eps_Pic"] ?? "";
      String strPICTimePic = formDesignerImportLocalVariables["picTime_Pic"] ?? "";
      int piC1ID = formDesignerImportLocalVariables["piC1_ID"] ?? 0;
      String trNPilotPilot1 = formDesignerImportLocalVariables["trN_Pilot_Pilot1"] ?? "";
      String trNPilotPilot2 = formDesignerImportLocalVariables["trN_Pilot_Pilot2"] ?? "";
      String trNPilotPilot3 = formDesignerImportLocalVariables["trN_Pilot_Pilot3"] ?? "";
      String trNPilotPilot4 = formDesignerImportLocalVariables["trN_Pilot_Pilot4"] ?? "";
      String trNPilotPilot5 = formDesignerImportLocalVariables["trN_Pilot_Pilot5"] ?? "";
      String trNPilotPilot6 = formDesignerImportLocalVariables["trN_Pilot_Pilot6"] ?? "";
      String trNPilotPIC1 = formDesignerImportLocalVariables["trN_Pilot_PIC1"] ?? "";
      String trNPilotPIC2 = formDesignerImportLocalVariables["trN_Pilot_PIC2"] ?? "";
      String trNPilotPIC3 = formDesignerImportLocalVariables["trN_Pilot_PIC3"] ?? "";
      String trNPilotPIC4 = formDesignerImportLocalVariables["trN_Pilot_PIC4"] ?? "";
      String trNPilotPIC5 = formDesignerImportLocalVariables["trN_Pilot_PIC5"] ?? "";
      String trNPilotPIC6 = formDesignerImportLocalVariables["trN_Pilot_PIC6"] ?? "";
      String piCID = formDesignerImportLocalVariables["piC_ID"] ?? "";
      String siC1ID = formDesignerImportLocalVariables["siC1_ID"] ?? "";
      String siC2ID = formDesignerImportLocalVariables["siC2_ID"] ?? "";
      String siC1PIC = formDesignerImportLocalVariables["siC1_PIC"] ?? "";
      String siC2PIC = formDesignerImportLocalVariables["siC2_PIC"] ?? "";
      String tfO1ID = formDesignerImportLocalVariables["tfO1_ID"] ?? "";
      String tfO2ID = formDesignerImportLocalVariables["tfO2_ID"] ?? "";
      String tfO3ID = formDesignerImportLocalVariables["tfO3_ID"] ?? "";
      String tfO1PIC = formDesignerImportLocalVariables["tfO1_PIC"] ?? "";
      String tfO2PIC = formDesignerImportLocalVariables["tfO2_PIC"] ?? "";
      String tfO3PIC = formDesignerImportLocalVariables["tfO3_PIC"] ?? "";
      String piCUser = formDesignerImportLocalVariables["piC_User"] ?? "";
      String piCPICTime = formDesignerImportLocalVariables["piC_PICTime"] ?? "";
      String coPilotId = formDesignerImportLocalVariables["coPilot_Id"] ?? "";
      String coPilotPICTime = formDesignerImportLocalVariables["coPilot_PICTime"] ?? "";
      String crewPIC1 = formDesignerImportLocalVariables["crew_PIC1"] ?? "";
      String crewPIC2 = formDesignerImportLocalVariables["crew_PIC2"] ?? "";
      String crewPIC3 = formDesignerImportLocalVariables["crew_PIC3"] ?? "";
      String crewPIC4 = formDesignerImportLocalVariables["crew_PIC4"] ?? "";
      int strPilot = formDesignerImportLocalVariables["pilot"] ?? 0;
      int strCoPilot = formDesignerImportLocalVariables["coPilot"] ?? 0;
      String strPIC = formDesignerImportLocalVariables["pic"] ?? "";

      //SIC Time
      double strSICTime = formDesignerImportLocalVariables["sicTime"] ?? 0.0;
      String siCId = formDesignerImportLocalVariables["siC_Id"] ?? "";
      String siCSicTime = formDesignerImportLocalVariables["siC_SicTime"] ?? "";
      String coPilotSIC = formDesignerImportLocalVariables["coPilot_SIC"] ?? "";
      String piCPilot2 = formDesignerImportLocalVariables["piC_Pilot2"] ?? "";
      String sicSIC = formDesignerImportLocalVariables["siC_SIC"] ?? "";
      int strNjspCoPilotId = formDesignerImportLocalVariables["njspCoPilotId"] ?? 0;
      String strNjspCoPilotSicTime = formDesignerImportLocalVariables["njspCoPilotSicTime"] ?? "";
      String strEpsSic = formDesignerImportLocalVariables["eps_Sic"] ?? "";
      String strSICTimeSic = formDesignerImportLocalVariables["sicTime_Sic"] ?? "";
      int piC2ID = formDesignerImportLocalVariables["piC2_ID"] ?? 0;
      String siCUser = formDesignerImportLocalVariables["siC_User"] ?? "";
      String siCSICTime = formDesignerImportLocalVariables["siC_SICTime"] ?? "";
      int strSICTimeUsed = formDesignerImportLocalVariables["sicTimeUsed"] ?? 0;

      //Cross Country Time
      String pilotXCountry = formDesignerImportLocalVariables["pilot_XCountry"] ?? "";
      String coPilotXCountry = formDesignerImportLocalVariables["coPilot_XCountry"] ?? "";
      String strXCountryPic = formDesignerImportLocalVariables["xCountry_Pic"] ?? "";
      String strXCountrySic = formDesignerImportLocalVariables["xCountry_Sic"] ?? "";
      int strTxWildPilotId = formDesignerImportLocalVariables["txWildPilotId"] ?? 0;
      int strTxWildCoPilotId = formDesignerImportLocalVariables["txWildCoPilotId"] ?? 0;
      String strTxWildPilotXCountryTime = formDesignerImportLocalVariables["txWildPilotXCountryTime"] ?? "";
      String strTxWildCoPilotXCountryTime = formDesignerImportLocalVariables["txWildCoPilotXCountryTime"] ?? "";
      String picXCountry = formDesignerImportLocalVariables["piC_X_Country"] ?? "";
      String siC1XCountry = formDesignerImportLocalVariables["siC1_X_Country"] ?? "";
      String piCCrossCountryTime = formDesignerImportLocalVariables["piC_CrossCountryTime"] ?? "";
      String coPilotCrossCountryTime = formDesignerImportLocalVariables["coPilot_CrossCountryTime"] ?? "";
      String piCXCountry = formDesignerImportLocalVariables["piC_XCountry"] ?? "";
      String strXCountry = formDesignerImportLocalVariables["xCountry"] ?? "";
      int strCrossCountry = formDesignerImportLocalVariables["crossCountry"] ?? 0;

      //Instructor Time (CFI)
      String coPilotInstructor = formDesignerImportLocalVariables["coPilotInstructor"] ?? "";
      String piCInstructorTimeCFI = formDesignerImportLocalVariables["piC_InstructorTimeCFI"] ?? "";
      String coPilotInstructorTimeCFI = formDesignerImportLocalVariables["coPilot_InstructorTimeCFI"] ?? "";
      String strInstructorTime = formDesignerImportLocalVariables["instructorTime"] ?? "";

      //Dual Time Received
      String piCDualTimeReceived = formDesignerImportLocalVariables["piC_DualTimeReceived"] ?? "";
      String coPilotDualTimeReceived = formDesignerImportLocalVariables["coPilot_DualTimeReceived"] ?? "";

      //Solo Time Received
      String strTxWildPilotSoloTime = formDesignerImportLocalVariables["txWildPilotSoloTime"] ?? "";
      String strTxWildCoPilotSoloTime = formDesignerImportLocalVariables["txWildCoPilotSoloTime"] ?? "";
      String piCSoloTimeReceived = formDesignerImportLocalVariables["piC_SoloTimeReceived"] ?? "";
      String coPilotSoloTimeReceived = formDesignerImportLocalVariables["coPilot_SoloTimeReceived"] ?? "";
      String piCSolo = formDesignerImportLocalVariables["piC_Solo"] ?? "";
      String strSolo = formDesignerImportLocalVariables["solo"] ?? "";

      //Day with Take Offs/Ldgs
      //Take Offs/Ldgs
      String pilotDayLandings = formDesignerImportLocalVariables["pilot_DayLandings"] ?? ""; //strPilotDayLandings
      String coPilotDayLandings = formDesignerImportLocalVariables["coPilot_DayLandings"] ?? ""; //strCoPilotDayLandings
      String strPilotDayLandings = formDesignerImportLocalVariables["pilot_DayLandings"] ?? "";
      String strCoPilotDayLandings = formDesignerImportLocalVariables["coPilot_DayLandings"] ?? "";
      String siCDayLandings = formDesignerImportLocalVariables["siC_DayLandings"] ?? "";
      String piCDayLandings = formDesignerImportLocalVariables["piC_DayLandings"] ?? "";
      String strNjspPilotDayLandings = formDesignerImportLocalVariables["njspPilotDayLandings"] ?? "";
      String strNjspCoPilotDayLandings = formDesignerImportLocalVariables["njspCoPilotDayLandings"] ?? "";
      String strDayLandingsPic = formDesignerImportLocalVariables["dayLandings_Pic"] ?? "";
      String strDayLandingsSic = formDesignerImportLocalVariables["dayLandings_Sic"] ?? "";
      String picDayLandings = formDesignerImportLocalVariables["piC_Day_Landings"] ?? "";
      String siC1DayLandings = formDesignerImportLocalVariables["siC1_Day_Landings"] ?? "";
      String tfO1DayLandings = formDesignerImportLocalVariables["tfO1_Day_Landings"] ?? "";
      String tfO2DayLandings = formDesignerImportLocalVariables["tfO2_Day_Landings"] ?? "";
      String tfO3DayLandings = formDesignerImportLocalVariables["tfO3_Day_Landings"] ?? "";
      String piCDayTakeOffsLdgs = formDesignerImportLocalVariables["piC_DayTakeOffsLdgs"] ?? "";
      String siCDayTakeOffsLdgs = formDesignerImportLocalVariables["siC_DayTakeOffsLdgs"] ?? "";
      String coPilotDayTakeOffsLdgs = formDesignerImportLocalVariables["coPilot_DayTakeOffsLdgs"] ?? "";
      double strDayLandings = formDesignerImportLocalVariables["dayLandings"] ?? 0.0;

      //Night with Take Offs/Ldgs, Flight Time
      //Take Offs/Ldgs
      String pilotNightLandings = formDesignerImportLocalVariables["pilot_NightLandings"] ?? "";
      String coPilotNightLandings = formDesignerImportLocalVariables["coPilot_NightLandings"] ?? "";
      int strPilotNightFlightLandings = formDesignerImportLocalVariables["pilot_NightFlightLandings"] ?? 0;
      int strCoPilotNightFlightLandings = formDesignerImportLocalVariables["coPilot_NightFlightLandings"] ?? 0;
      String siCNightLandings = formDesignerImportLocalVariables["siC_NightLandings"] ?? "";
      String piCNightLandings = formDesignerImportLocalVariables["piC_NightLandings"] ?? "";
      String strNjspPilotNightLandings = formDesignerImportLocalVariables["njspPilotNightLandings"] ?? "";
      String strNjspCoPilotNightLandings = formDesignerImportLocalVariables["njspCoPilotNightLandings"] ?? "";
      String strNightLandingsPic = formDesignerImportLocalVariables["nightLandings_Pic"] ?? "";
      String strNightLandingsSic = formDesignerImportLocalVariables["nightLandings_Sic"] ?? "";
      String strTxWildPilotNightLandings = formDesignerImportLocalVariables["txWildPilotNightLandings"] ?? "";
      String strTxWildCoPilotNightLandings = formDesignerImportLocalVariables["txWildCoPilotNightLandings"] ?? "";
      String picNightLandings = formDesignerImportLocalVariables["piC_Night_Landings"] ?? "";
      String siC1NightLandings = formDesignerImportLocalVariables["siC1_Night_Landings"] ?? "";
      String tfO1NightLandings = formDesignerImportLocalVariables["tfO1_Night_Landings"] ?? "";
      String tfO2NightLandings = formDesignerImportLocalVariables["tfO2_Night_Landings"] ?? "";
      String tfO3NightLandings = formDesignerImportLocalVariables["tfO3_Night_Landings"] ?? "";
      String piCNightTakeOffsLdgs = formDesignerImportLocalVariables["piC_NightTakeOffsLdgs"] ?? "";
      String siCNightTakeOffsLdgs = formDesignerImportLocalVariables["siC_NightTakeOffsLdgs"] ?? "";
      String coPilotNightTakeOffsLdgs = formDesignerImportLocalVariables["coPilot_NightTakeOffsLdgs"] ?? "";
      double strNightLandings = formDesignerImportLocalVariables["nightLandings"] ?? 0.0;

      //Flight Time
      String pilotNightFlightTime = formDesignerImportLocalVariables["pilot_NightFlightTime"] ?? ""; //strPilotNightFlightTime
      String coPilotNightFlightTime = formDesignerImportLocalVariables["coPilot_NightFlightTime"] ?? ""; //strCoPilotNightFlightTime
      String strPilotNightFlightTime = formDesignerImportLocalVariables["pilot_NightFlightTime"] ?? "";
      String strCoPilotNightFlightTime = formDesignerImportLocalVariables["coPilot_NightFlightTime"] ?? "";
      String strNjspPilotNightFlightTime = formDesignerImportLocalVariables["njspPilotNightFlightTime"] ?? "";
      String strNjspCoPilotNightFlightTime = formDesignerImportLocalVariables["njspCoPilotNightFlightTime"] ?? "";
      String strNightFlightTimeCrew1 = formDesignerImportLocalVariables["nightFlightTime_Crew1"] ?? "";
      String strNightFlightTimeCrew2 = formDesignerImportLocalVariables["nightFlightTime_Crew2"] ?? "";
      String strNightFlightTimeCrew3 = formDesignerImportLocalVariables["nightFlightTime_Crew3"] ?? "";
      String strNightFlightTimeCrew4 = formDesignerImportLocalVariables["nightFlightTime_Crew4"] ?? "";
      String strNightFlightTimePic = formDesignerImportLocalVariables["nightFlightTime_Pic"] ?? "";
      String strNightFlightTimeSic = formDesignerImportLocalVariables["nightFlightTime_Sic"] ?? "";
      String strEpsTfo1 = formDesignerImportLocalVariables["eps_Tfo1"] ?? "";
      String strEpsTfo2 = formDesignerImportLocalVariables["eps_Tfo2"] ?? "";
      String strNightFlightTimeTfo1 = formDesignerImportLocalVariables["nightFlightTime_Tfo1"] ?? "";
      String strNightFlightTimeTfo2 = formDesignerImportLocalVariables["nightFlightTime_Tfo2"] ?? "";
      String hoistOpHoistOperator1 = formDesignerImportLocalVariables["hoistoP_HOIST_OPERATOR1"] ?? "";
      String hoistOpHoistOperator2 = formDesignerImportLocalVariables["hoistoP_HOIST_OPERATOR2"] ?? "";
      String hoistOpHoistOperator3 = formDesignerImportLocalVariables["hoistoP_HOIST_OPERATOR3"] ?? "";
      String hoistOpHoistOperator4 = formDesignerImportLocalVariables["hoistoP_HOIST_OPERATOR4"] ?? "";
      String hoistOpHoistOperator5 = formDesignerImportLocalVariables["hoistoP_HOIST_OPERATOR5"] ?? "";
      String hoistOpHoistOperator6 = formDesignerImportLocalVariables["hoistoP_HOIST_OPERATOR6"] ?? "";
      String hoistOpNightTime1 = formDesignerImportLocalVariables["hoistoP_NIGHT_TIME1"] ?? "";
      String hoistOpNightTime2 = formDesignerImportLocalVariables["hoistoP_NIGHT_TIME2"] ?? "";
      String hoistOpNightTime3 = formDesignerImportLocalVariables["hoistoP_NIGHT_TIME3"] ?? "";
      String hoistOpNightTime4 = formDesignerImportLocalVariables["hoistoP_NIGHT_TIME4"] ?? "";
      String hoistOpNightTime5 = formDesignerImportLocalVariables["hoistoP_NIGHT_TIME5"] ?? "";
      String hoistOpNightTime6 = formDesignerImportLocalVariables["hoistoP_NIGHT_TIME6"] ?? "";

      String rescueRescueSpecialist1 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST1"] ?? "";
      String rescueRescueSpecialist2 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST2"] ?? "";
      String rescueRescueSpecialist3 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST3"] ?? "";
      String rescueRescueSpecialist4 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST4"] ?? "";
      String rescueRescueSpecialist5 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST5"] ?? "";
      String rescueRescueSpecialist6 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST6"] ?? "";
      String rescueRescueSpecialist7 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST7"] ?? "";
      String rescueRescueSpecialist8 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST8"] ?? "";
      String rescueRescueSpecialist9 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST9"] ?? "";
      String rescueRescueSpecialist10 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST10"] ?? "";
      String rescueRescueSpecialist11 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST11"] ?? "";
      String rescueRescueSpecialist12 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST12"] ?? "";
      String rescueRescueSpecialist13 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST13"] ?? "";
      String rescueRescueSpecialist14 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST14"] ?? "";
      String rescueRescueSpecialist15 = formDesignerImportLocalVariables["rescuE_RESCUE_SPECIALIST15"] ?? "";
      String rescueNightTime1 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME1"] ?? "";
      String rescueNightTime2 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME2"] ?? "";
      String rescueNightTime3 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME3"] ?? "";
      String rescueNightTime4 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME4"] ?? "";
      String rescueNightTime5 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME5"] ?? "";
      String rescueNightTime6 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME6"] ?? "";
      String rescueNightTime7 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME7"] ?? "";
      String rescueNightTime8 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME8"] ?? "";
      String rescueNightTime9 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME9"] ?? "";
      String rescueNightTime10 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME10"] ?? "";
      String rescueNightTime11 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME11"] ?? "";
      String rescueNightTime12 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME12"] ?? "";
      String rescueNightTime13 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME13"] ?? "";
      String rescueNightTime14 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME14"] ?? "";
      String rescueNightTime15 = formDesignerImportLocalVariables["rescuE_NIGHT_TIME15"] ?? "";
      String strTxWildPilotNightFlightTime = formDesignerImportLocalVariables["txWildPilotNightFlightTime"] ?? "";
      String strTxWildCoPilotNightFlightTime = formDesignerImportLocalVariables["txWildCoPilotNightFlightTime"] ?? "";
      String picNightFlightTime = formDesignerImportLocalVariables["piC_Night_Flight_Time"] ?? "";
      String siC1NightFlightTime = formDesignerImportLocalVariables["siC1_Night_Flight_Time"] ?? "";
      String tfO1NightFlightTime = formDesignerImportLocalVariables["tfO1_Night_Flight_Time"] ?? "";
      String tfO2NightFlightTime = formDesignerImportLocalVariables["tfO2_Night_Flight_Time"] ?? "";
      String tfO3NightFlightTime = formDesignerImportLocalVariables["tfO3_Night_Flight_Time"] ?? "";
      String piCNightFlightTime = formDesignerImportLocalVariables["piC_NightFlightTime"] ?? "";
      double strNightFlightTime = formDesignerImportLocalVariables["nightFlightTime"] ?? 0.0;

      //NVG with NVG Time, NVG Operations
      //NVG Time
      String pilotNVGTime = formDesignerImportLocalVariables["pilot_NVGTime"] ?? "";
      String coPilotNVGTime = formDesignerImportLocalVariables["coPilot_NVGTime"] ?? "";
      String tfo1TFO = formDesignerImportLocalVariables["tfo1_TFO"] ?? "";
      String tfo2TFO = formDesignerImportLocalVariables["tfo2_TFO"] ?? "";
      String tfo3TFO = formDesignerImportLocalVariables["tfo3_TFO"] ?? "";
      String tfo1NVGTime = formDesignerImportLocalVariables["tfo1_NVGTIME"] ?? "";
      String tfo2NVGTime = formDesignerImportLocalVariables["tfo2_NVGTIME"] ?? "";
      String tfo3NVGTime = formDesignerImportLocalVariables["tfo3_NVGTIME"] ?? "";
      String strPilotNVGTIME = formDesignerImportLocalVariables["pilot_NVGTIME"] ?? "";
      String strCoPilotNVGTIME = formDesignerImportLocalVariables["coPilot_NVGTIME"] ?? "";
      String siCNVGTime = formDesignerImportLocalVariables["siC_NVGTime"] ?? "";
      String piCNVGTime = formDesignerImportLocalVariables["piC_NVGTime"] ?? "";
      String strNjspPilotNvgTime = formDesignerImportLocalVariables["njspPilotNvgTime"] ?? "";
      String strNjspCoPilotNvgTime = formDesignerImportLocalVariables["njspCoPilotNvgTime"] ?? "";
      String strNVGTimePic = formDesignerImportLocalVariables["nvgTime_Pic"] ?? "";
      String strNVGTimeSic = formDesignerImportLocalVariables["nvgTime_Sic"] ?? "";
      String strNVGTimeTfo1 = formDesignerImportLocalVariables["nvgTime_Tfo1"] ?? "";
      String strNVGTimeTfo2 = formDesignerImportLocalVariables["nvgTime_Tfo2"] ?? "";
      String trNPilotNVGTime1 = formDesignerImportLocalVariables["trN_Pilot_NVG_Time1"] ?? "";
      String trNPilotNVGTime2 = formDesignerImportLocalVariables["trN_Pilot_NVG_Time2"] ?? "";
      String trNPilotNVGTime3 = formDesignerImportLocalVariables["trN_Pilot_NVG_Time3"] ?? "";
      String trNPilotNVGTime4 = formDesignerImportLocalVariables["trN_Pilot_NVG_Time4"] ?? "";
      String trNPilotNVGTime5 = formDesignerImportLocalVariables["trN_Pilot_NVG_Time5"] ?? "";
      String trNPilotNVGTime6 = formDesignerImportLocalVariables["trN_Pilot_NVG_Time6"] ?? "";
      String strTxWildPilotNvgTime = formDesignerImportLocalVariables["txWildPilotNvgTime"] ?? "";
      String strTxWildCoPilotNvgTime = formDesignerImportLocalVariables["txWildCoPilotNvgTime"] ?? "";
      String picNVGTime = formDesignerImportLocalVariables["piC_NVG_Time"] ?? "";
      String siC1NVGTime = formDesignerImportLocalVariables["siC1_NVG_Time"] ?? "";
      String tfO1NVGTime = formDesignerImportLocalVariables["tfO1_NVG_TIME"] ?? "";
      String tfO2NVGTime = formDesignerImportLocalVariables["tfO2_NVG_TIME"] ?? "";
      String tfO3NVGTime = formDesignerImportLocalVariables["tfO3_NVG_TIME"] ?? "";
      String cC1User = formDesignerImportLocalVariables["cC1_User"] ?? "";
      String cC2User = formDesignerImportLocalVariables["cC2_User"] ?? "";
      String cC3User = formDesignerImportLocalVariables["cC3_User"] ?? "";
      String cC4User = formDesignerImportLocalVariables["cC4_User"] ?? "";
      String cC1NVGTime = formDesignerImportLocalVariables["cC1_NVGTime"] ?? "";
      String cC2NVGTime = formDesignerImportLocalVariables["cC2_NVGTime"] ?? "";
      String cC3NVGTime = formDesignerImportLocalVariables["cC3_NVGTime"] ?? "";
      String cC4NVGTime = formDesignerImportLocalVariables["cC4_NVGTime"] ?? "";
      String specID1 = formDesignerImportLocalVariables["spec_ID_1"] ?? "";
      String specID2 = formDesignerImportLocalVariables["spec_ID_2"] ?? "";
      String specID3 = formDesignerImportLocalVariables["spec_ID_3"] ?? "";
      String specID4 = formDesignerImportLocalVariables["spec_ID_4"] ?? "";
      String specID5 = formDesignerImportLocalVariables["spec_ID_5"] ?? "";
      String specID6 = formDesignerImportLocalVariables["spec_ID_6"] ?? "";
      String specID7 = formDesignerImportLocalVariables["spec_ID_7"] ?? "";
      String specID8 = formDesignerImportLocalVariables["spec_ID_8"] ?? "";
      String specID9 = formDesignerImportLocalVariables["spec_ID_9"] ?? "";
      String specID10 = formDesignerImportLocalVariables["spec_ID_10"] ?? "";
      String specNVGTime1 = formDesignerImportLocalVariables["spec_NVGTime_1"] ?? "";
      String specNVGTime2 = formDesignerImportLocalVariables["spec_NVGTime_2"] ?? "";
      String specNVGTime3 = formDesignerImportLocalVariables["spec_NVGTime_3"] ?? "";
      String specNVGTime4 = formDesignerImportLocalVariables["spec_NVGTime_4"] ?? "";
      String specNVGTime5 = formDesignerImportLocalVariables["spec_NVGTime_5"] ?? "";
      String specNVGTime6 = formDesignerImportLocalVariables["spec_NVGTime_6"] ?? "";
      String specNVGTime7 = formDesignerImportLocalVariables["spec_NVGTime_7"] ?? "";
      String specNVGTime8 = formDesignerImportLocalVariables["spec_NVGTime_8"] ?? "";
      String specNVGTime9 = formDesignerImportLocalVariables["spec_NVGTime_9"] ?? "";
      String specNVGTime10 = formDesignerImportLocalVariables["spec_NVGTime_10"] ?? "";
      String crewCREWCHIEF1 = formDesignerImportLocalVariables["crew_CREWCHIEF1"] ?? "";
      String crewCREWCHIEF2 = formDesignerImportLocalVariables["crew_CREWCHIEF2"] ?? "";
      String crewCREWCHIEF3 = formDesignerImportLocalVariables["crew_CREWCHIEF3"] ?? "";
      String crewCREWCHIEF4 = formDesignerImportLocalVariables["crew_CREWCHIEF4"] ?? "";
      String crewCREWCHIEF5 = formDesignerImportLocalVariables["crew_CREWCHIEF5"] ?? "";
      String crewCREWCHIEF6 = formDesignerImportLocalVariables["crew_CREWCHIEF6"] ?? "";
      String cCNVGTime = formDesignerImportLocalVariables["cC_NVGTIME"] ?? "";
      double strNVGTime = formDesignerImportLocalVariables["nvgTime"] ?? 0.0;
      int strTFO1 = formDesignerImportLocalVariables["tfO1"] ?? 0;
      int strTFO2 = formDesignerImportLocalVariables["tfO2"] ?? 0;
      int strTFO3 = formDesignerImportLocalVariables["tfO3"] ?? 0;
      int strTFO4 = formDesignerImportLocalVariables["tfO4"] ?? 0;
      String strTFO1NVGTime = formDesignerImportLocalVariables["tfO1NVGTIME"] ?? "";
      String strTFO2NVGTime = formDesignerImportLocalVariables["tfO2NVGTIME"] ?? "";
      String strTFO3NVGTime = formDesignerImportLocalVariables["tfO3NVGTIME"] ?? "";
      String strTFO4NVGTime = formDesignerImportLocalVariables["tfO4NVGTIME"] ?? "";

      //NVG Operations
      String pilotNVGOPS = formDesignerImportLocalVariables["pilot_NVGOPS"] ?? "";
      String coPilotNVGOPS = formDesignerImportLocalVariables["coPilot_NVGOPS"] ?? "";
      String tfo1NVGOps = formDesignerImportLocalVariables["tfo1_NVGOPS"] ?? "";
      String tfo2NVGOps = formDesignerImportLocalVariables["tfo2_NVGOPS"] ?? "";
      String tfo3NVGOps = formDesignerImportLocalVariables["tfo3_NVGOPS"] ?? "";
      int strPilotNVGO = formDesignerImportLocalVariables["pilot_NVGO"] ?? 0;
      int strCoPilotNVGO = formDesignerImportLocalVariables["coPilot_NVGO"] ?? 0;
      String siCNVGOperations = formDesignerImportLocalVariables["siC_NVGOperations"] ?? "";
      String piCNVGOperations = formDesignerImportLocalVariables["piC_NVGOperations"] ?? "";
      String strNjspPilotNvgOperations = formDesignerImportLocalVariables["njspPilotNvgOperations"] ?? "";
      String strNjspCoPilotNvgOperations = formDesignerImportLocalVariables["njspCoPilotNvgOperations"] ?? "";
      String strNVGEventPic = formDesignerImportLocalVariables["nvgEvent_Pic"] ?? "";
      String strNVGEventSic = formDesignerImportLocalVariables["nvgEvent_Sic"] ?? "";
      String strNVGEventTfo1 = formDesignerImportLocalVariables["nvgEvent_Tfo1"] ?? "";
      String strNVGEventTfo2 = formDesignerImportLocalVariables["nvgEvent_Tfo2"] ?? "";
      String strTxWildPilotNvgOperations = formDesignerImportLocalVariables["txWildPilotNvgOperations"] ?? "";
      String strTxWildCoPilotNvgOperations = formDesignerImportLocalVariables["txWildCoPilotNvgOperations"] ?? "";
      String picNVGOps = formDesignerImportLocalVariables["piC_NVG_OPS"] ?? "";
      String siC1NVGOps = formDesignerImportLocalVariables["siC1_NVG_OPS"] ?? "";
      String tfO1NVGOps = formDesignerImportLocalVariables["tfO1_NVG_OPS"] ?? "";
      String tfO2NVGOps = formDesignerImportLocalVariables["tfO2_NVG_OPS"] ?? "";
      String tfO3NVGOps = formDesignerImportLocalVariables["tfO3_NVG_OPS"] ?? "";
      String picId = formDesignerImportLocalVariables["picId"] ?? "";
      String sicId = formDesignerImportLocalVariables["sicId"] ?? "";
      String picNvgOps = formDesignerImportLocalVariables["picNvgOps"] ?? "";
      String sicNvgOps = formDesignerImportLocalVariables["sicNvgOps"] ?? "";
      String medic1Id = formDesignerImportLocalVariables["medic1Id"] ?? "";
      String medic2Id = formDesignerImportLocalVariables["medic2Id"] ?? "";
      String medic1NvgOps = formDesignerImportLocalVariables["medic1NvgOps"] ?? "";
      String medic2NvgOps = formDesignerImportLocalVariables["medic2NvgOps"] ?? "";
      String cC1NVGOperations = formDesignerImportLocalVariables["cC1_NVGOperations"] ?? "";
      String cC2NVGOperations = formDesignerImportLocalVariables["cC2_NVGOperations"] ?? "";
      String cC3NVGOperations = formDesignerImportLocalVariables["cC3_NVGOperations"] ?? "";
      String cC4NVGOperations = formDesignerImportLocalVariables["cC4_NVGOperations"] ?? "";
      String coPilotNVGOperations = formDesignerImportLocalVariables["coPilot_NVGOperations"] ?? "";
      String specNVGOperations1 = formDesignerImportLocalVariables["spec_NVGOperations_1"] ?? "";
      String specNVGOperations2 = formDesignerImportLocalVariables["spec_NVGOperations_2"] ?? "";
      String specNVGOperations3 = formDesignerImportLocalVariables["spec_NVGOperations_3"] ?? "";
      String specNVGOperations4 = formDesignerImportLocalVariables["spec_NVGOperations_4"] ?? "";
      String specNVGOperations5 = formDesignerImportLocalVariables["spec_NVGOperations_5"] ?? "";
      String specNVGOperations6 = formDesignerImportLocalVariables["spec_NVGOperations_6"] ?? "";
      String specNVGOperations7 = formDesignerImportLocalVariables["spec_NVGOperations_7"] ?? "";
      String specNVGOperations8 = formDesignerImportLocalVariables["spec_NVGOperations_8"] ?? "";
      String specNVGOperations9 = formDesignerImportLocalVariables["spec_NVGOperations_9"] ?? "";
      String specNVGOperations10 = formDesignerImportLocalVariables["spec_NVGOperations_10"] ?? "";
      String piCNvgOps = formDesignerImportLocalVariables["piC_NVGOPS"] ?? "";
      String cCNvgOps = formDesignerImportLocalVariables["cC_NVGOPS"] ?? "";
      String strNVGOps = formDesignerImportLocalVariables["nvgops"] ?? "";
      String strTFO1NVGOps = formDesignerImportLocalVariables["tfO1NVGOPS"] ?? "";
      String strTFO2NVGOps = formDesignerImportLocalVariables["tfO2NVGOPS"] ?? "";
      String strTFO3NVGOps = formDesignerImportLocalVariables["tfO3NVGOPS"] ?? "";
      String strTFO4NVGOps = formDesignerImportLocalVariables["tfO4NVGOPS"] ?? "";

      //Approaches with Precision, Non-Precision, Holds
      //Precision
      String pilotPrecisionApproaches = formDesignerImportLocalVariables["pilot_PrecisionApproaches"] ?? "";
      String coPilotPrecisionApproaches = formDesignerImportLocalVariables["coPilot_PrecisionApproaches"] ?? "";
      int strPilotInstrumentApproach = formDesignerImportLocalVariables["pilot_InstrumentApproach"] ?? 0;
      int strCoPilotInstrumentApproach = formDesignerImportLocalVariables["coPilot_InstrumentApproach"] ?? 0;
      String strNjspPilotApproaches = formDesignerImportLocalVariables["njspPilotApproaches"] ?? "";
      String strNjspCoPilotApproaches = formDesignerImportLocalVariables["njspCoPilotApproaches"] ?? "";
      String strPrecisionApproachesPic = formDesignerImportLocalVariables["precisionApproaches_Pic"] ?? "";
      String strPrecisionApproachesSic = formDesignerImportLocalVariables["precisionApproaches_Sic"] ?? "";
      String strPrecisionApproachesTfo1 = formDesignerImportLocalVariables["precisionApproaches_Tfo1"] ?? "";
      String strPrecisionApproachesTfo2 = formDesignerImportLocalVariables["precisionApproaches_Tfo2"] ?? "";
      String picPrecisionApproaches = formDesignerImportLocalVariables["piC_Precision_Approaches"] ?? "";
      String picNONPrecisionApproaches = formDesignerImportLocalVariables["piC_NON_Precision_Approaches"] ?? "";
      String siC1PrecisionApproaches = formDesignerImportLocalVariables["siC1_Precision_Approaches"] ?? "";
      String siC1NONPrecisionApproaches = formDesignerImportLocalVariables["siC1_NON_Precision_Approaches"] ?? "";
      String piCApproachesInstrument = formDesignerImportLocalVariables["piC_ApproachesInstrument"] ?? "";
      String coPilotApproachesInstrument = formDesignerImportLocalVariables["coPilot_ApproachesInstrument"] ?? "";
      String piCPrecisionApproaches = formDesignerImportLocalVariables["piC_PrecisionApproaches"] ?? "";
      String strPrecisionApproaches = formDesignerImportLocalVariables["precisionApproaches"] ?? "";
      double strApproachInstrument = formDesignerImportLocalVariables["approachInstrument"] ?? 0.0;

      //Non-Precision
      String pilotNONPrecisionApproaches = formDesignerImportLocalVariables["pilot_NONPrecisionApproaches"] ?? "";
      String coPilotNONPrecisionApproaches = formDesignerImportLocalVariables["coPilot_NONPrecisionApproaches"] ?? "";
      String strNONPrecisionApproachesPic = formDesignerImportLocalVariables["nonPrecisionApproaches_Pic"] ?? "";
      String strNONPrecisionApproachesSic = formDesignerImportLocalVariables["nonPrecisionApproaches_Sic"] ?? "";
      String strNONPrecisionApproachesTfo1 = formDesignerImportLocalVariables["nonPrecisionApproaches_Tfo1"] ?? "";
      String strNONPrecisionApproachesTfo2 = formDesignerImportLocalVariables["nonPrecisionApproaches_Tfo2"] ?? "";
      String piCApproachesNonInstrument = formDesignerImportLocalVariables["piC_ApproachesNonInstrument"] ?? "";
      String coPilotApproachesNonInstrument = formDesignerImportLocalVariables["coPilot_ApproachesNonInstrument"] ?? "";
      String piCNONPrecisionApproaches = formDesignerImportLocalVariables["piC_NONPrecisionApproaches"] ?? "";
      String strNONPrecisionApproaches = formDesignerImportLocalVariables["nonPrecisionApproaches"] ?? "";

      //Holds
      String pilotHold = formDesignerImportLocalVariables["pilot_Hold"] ?? ""; //strPilotHold
      String coPilotHold = formDesignerImportLocalVariables["coPilot_Hold"] ?? ""; //strCoPilotHold
      String strPilotHold = formDesignerImportLocalVariables["pilot_Hold"] ?? "";
      String strCoPilotHold = formDesignerImportLocalVariables["coPilot_Hold"] ?? "";
      String strNjspPilotHolds = formDesignerImportLocalVariables["njspPilotHolds"] ?? "";
      String strNjspCoPilotHolds = formDesignerImportLocalVariables["njspCoPilotHolds"] ?? "";
      String piCHold = formDesignerImportLocalVariables["piC_Hold"] ?? "";
      String siC1Hold = formDesignerImportLocalVariables["siC1_Hold"] ?? "";
      String piCApproachesHolds = formDesignerImportLocalVariables["piC_ApproachesHolds"] ?? "";
      String coPilotApproachesHolds = formDesignerImportLocalVariables["coPilot_ApproachesHolds"] ?? "";
      String strHold = formDesignerImportLocalVariables["hold"] ?? "";
      //String strHolds = formDesignerImportLocalVariables["holds"] ?? ""; //Not Initialized in the formDesignerImportLocalVariables of Classic ASP

      //Conditions with Actual Instrument, Simulated Instrument
      //Actual Instrument
      String pilotIFRAct = formDesignerImportLocalVariables["pilot_IFRAct"] ?? "";
      String coPilotIFRAct = formDesignerImportLocalVariables["coPilot_IFRAct"] ?? "";
      String strNjspPilotApproachesActual = formDesignerImportLocalVariables["njspPilotApproachesActual"] ?? "";
      String strNjspCoPilotApproachesActual = formDesignerImportLocalVariables["njspCoPilotApproachesActual"] ?? "";
      String strIFRActPic = formDesignerImportLocalVariables["ifrAct_Pic"] ?? "";
      String strIFRActSic = formDesignerImportLocalVariables["ifrAct_Sic"] ?? "";
      String picIFRAct = formDesignerImportLocalVariables["piC_IFR_Act"] ?? "";
      String siC1IFRAct = formDesignerImportLocalVariables["siC1_IFR_Act"] ?? "";
      String piCConditionsActualInstrument = formDesignerImportLocalVariables["piC_ConditionsActualInstrument"] ?? "";
      String coPilotConditionsActualInstrument = formDesignerImportLocalVariables["coPilot_ConditionsActualInstrument"] ?? "";
      String piCIfrAct = formDesignerImportLocalVariables["piC_IFRAct"] ?? "";
      String strIFRAct = formDesignerImportLocalVariables["ifrAct"] ?? "";
      double strConditionsActualInstrument = formDesignerImportLocalVariables["conditionsActualInstrument"] ?? 0.0;

      //Simulated Instrument
      String pilotIFRSim = formDesignerImportLocalVariables["pilot_IFRSim"] ?? "";
      String coPilotIFRSim = formDesignerImportLocalVariables["coPilot_IFRSim"] ?? "";
      String strNjspPilotApproachesSimulated = formDesignerImportLocalVariables["njspPilotApproachesSimulated"] ?? "";
      String strNjspCoPilotApproachesSimulated = formDesignerImportLocalVariables["njspCoPilotApproachesSimulated"] ?? "";
      String strIFRSimPic = formDesignerImportLocalVariables["ifrSim_Pic"] ?? "";
      String strIFRSimSic = formDesignerImportLocalVariables["ifrSim_Sic"] ?? "";
      String picIFRSim = formDesignerImportLocalVariables["piC_IFR_Sim"] ?? "";
      String siC1IFRSim = formDesignerImportLocalVariables["siC1_IFR_Sim"] ?? "";
      String piCConditionsSimulatedInstrument = formDesignerImportLocalVariables["piC_ConditionsSimulatedInstrument"] ?? "";
      String coPilotConditionsSimulatedInstrument = formDesignerImportLocalVariables["coPilot_ConditionsSimulatedInstrument"] ?? "";
      String piCIfrSim = formDesignerImportLocalVariables["piC_IFRSim"] ?? "";
      String strIFRSim = formDesignerImportLocalVariables["ifrSim"] ?? "";
      double strConditionsSimulatedInstrument = formDesignerImportLocalVariables["conditionsSimulatedInstrument"] ?? 0.0;

      //FAR Part with 91 Time, 135 Time
      //91 Time
      double strFAR91Time = formDesignerImportLocalVariables["faR_91_Time"] ?? 0.0;
      //135 Time
      double strFAR135Time = formDesignerImportLocalVariables["faR_135_Time"] ?? 0.0;

      //Activities
      List<Map<String, dynamic>> activitySectionData = <Map<String, dynamic>>[];
      for (Map activityData in formDesignerImportAllData["objFlightLogServiceTableDataList"]) {
        activitySectionData.addIf(activityData["serviceVariableValue"].toString().removeAllWhitespace != activityData["serviceVariableName"], {
          "activityId": activityData["serviceVariableName"].toLowerCase(),
          "name": activityData["serviceVariableValue"],
          "height": 70.0,
        });
      }
      double strThisAmount = formDesignerImportAllData["thisAmount"] ?? 0.0;
      String rotorFixedWing = demographicsData["rotorFixedWing"] ?? "";
      String pilotTrack = formDesignerImportLocalVariables["pilot_Track"] ?? "";
      String coPilotTrack = formDesignerImportLocalVariables["coPilot_Track"] ?? "";
      String pilotHoistOpsLand = formDesignerImportLocalVariables["pilot_HoistOpsLand"] ?? "";
      String coPilotHoistOpsLand = formDesignerImportLocalVariables["coPilot_HoistOpsLand"] ?? "";
      String tfo1HoistOpsLand = formDesignerImportLocalVariables["tfo1_HoistOpsLand"] ?? "";
      String tfo2HoistOpsLand = formDesignerImportLocalVariables["tfo2_HoistOpsLand"] ?? "";
      String tfo3HoistOpsLand = formDesignerImportLocalVariables["tfo3_HoistOpsLand"] ?? "";
      String pilotHoistOpsWater = formDesignerImportLocalVariables["pilot_HoistOpsWater"] ?? "";
      String coPilotHoistOpsWater = formDesignerImportLocalVariables["coPilot_HoistOpsWater"] ?? "";
      String tfo1HoistOpsWater = formDesignerImportLocalVariables["tfo1_HoistOpsWater"] ?? "";
      String tfo2HoistOpsWater = formDesignerImportLocalVariables["tfo2_HoistOpsWater"] ?? "";
      String tfo3HoistOpsWater = formDesignerImportLocalVariables["tfo3_HoistOpsWater"] ?? "";
      int strPilotTrackIntercept = formDesignerImportLocalVariables["pilot_TrackIntercept"] ?? 0;
      int strCoPilotTrackIntercept = formDesignerImportLocalVariables["coPilot_TrackIntercept"] ?? 0;
      String piCSO = formDesignerImportLocalVariables["piC_SO"] ?? "";
      String piCVerticalRefOpSOShortHaul = formDesignerImportLocalVariables["piC_VerticalRefOpSOShortHaul"] ?? "";
      String siCVerticalRefOpSOShortHaul = formDesignerImportLocalVariables["siC_VerticalRefOpSOShortHaul"] ?? "";
      String piCVerticalReferenceOpOverH20SOOverH20 = formDesignerImportLocalVariables["piC_VerticalReferenceOpOverH20SOOverH20"] ?? "";
      String siCVerticalReferenceOpOverH20SOOverH20 = formDesignerImportLocalVariables["siC_VerticalReferenceOpOverH20SOOverH20"] ?? "";
      String piCVerticalRefTimeSOTime = formDesignerImportLocalVariables["piC_VerticalRefTimeSOTime"] ?? "";
      String siCVerticalRefTimeSOTime = formDesignerImportLocalVariables["siC_VerticalRefTimeSOTime"] ?? "";
      String piCRS = formDesignerImportLocalVariables["piC_RS"] ?? "";
      String piCHoistInsertionDay = formDesignerImportLocalVariables["piC_HoistInsertionDay"] ?? "";
      String siCHoistInsertionDay = formDesignerImportLocalVariables["siC_HoistInsertionDay"] ?? "";
      String paramedicHoistInsertionDay = formDesignerImportLocalVariables["paramedic_HoistInsertionDay"] ?? "";
      String paramedicHoistInsertionDaySO = formDesignerImportLocalVariables["paramedic_HoistInsertionDaySO"] ?? "";
      String piCHoistInsertionNight = formDesignerImportLocalVariables["piC_HoistInsertionNight"] ?? "";
      String siCHoistInsertionNight = formDesignerImportLocalVariables["siC_HoistInsertionNight"] ?? "";
      String paramedicHoistInsertionNight = formDesignerImportLocalVariables["paramedic_HoistInsertionNight"] ?? "";
      String paramedicHoistInsertionNightSO = formDesignerImportLocalVariables["paramedic_HoistInsertionNightSO"] ?? "";
      String piCHoistExtractionDay = formDesignerImportLocalVariables["piC_HoistExtractionDay"] ?? "";
      String siCHoistExtractionDay = formDesignerImportLocalVariables["siC_HoistExtractionDay"] ?? "";
      String paramedicHoistExtractionDay = formDesignerImportLocalVariables["paramedic_HoistExtractionDay"] ?? "";
      String piCNVGAidedUnAidedTransition = formDesignerImportLocalVariables["piC_NVGAidedUnAidedTransition"] ?? "";
      String siCNVGAidedUnAidedTransition = formDesignerImportLocalVariables["siC_NVGAidedUnAidedTransition"] ?? "";
      String paramedicHoistExtractionDaySO = formDesignerImportLocalVariables["paramedic_HoistExtractionDaySO"] ?? "";
      String piCShortHaul = formDesignerImportLocalVariables["piC_ShortHaul"] ?? "";
      String siCShortHaul = formDesignerImportLocalVariables["siC_ShortHaul"] ?? "";
      String paramedicShortHaul = formDesignerImportLocalVariables["paramedic_ShortHaul"] ?? "";
      String piCHoistExtractionNight = formDesignerImportLocalVariables["piC_HoistExtractionNight"] ?? "";
      String siCHoistExtractionNight = formDesignerImportLocalVariables["siC_HoistExtractionNight"] ?? "";
      String paramedicHoistExtractionNight = formDesignerImportLocalVariables["paramedic_HoistExtractionNight"] ?? "";
      String paramedicHoistExtractionNightSO = formDesignerImportLocalVariables["paramedic_HoistExtractionNightSO"] ?? "";
      String piCRappel = formDesignerImportLocalVariables["piC_Rappel"] ?? "";
      String siCRappel = formDesignerImportLocalVariables["siC_Rappel"] ?? "";
      String paramedicRappel = formDesignerImportLocalVariables["paramedic_Rappel"] ?? "";
      String paramedicRappelSO = formDesignerImportLocalVariables["paramedic_RappelSO"] ?? "";
      String piCToeIn = formDesignerImportLocalVariables["piC_ToeIn"] ?? "";
      String siCToeIn = formDesignerImportLocalVariables["siC_ToeIn"] ?? "";
      String paramedicToeIn = formDesignerImportLocalVariables["paramedic_ToeIn"] ?? "";
      String piCOneSkid = formDesignerImportLocalVariables["piC_OneSkid"] ?? "";
      String siCOneSkid = formDesignerImportLocalVariables["siC_OneSkid"] ?? "";
      String paramedicOneSkid = formDesignerImportLocalVariables["paramedic_OneSkid"] ?? "";
      String piCHoverIngressEgress = formDesignerImportLocalVariables["piC_HoverIngressEgress"] ?? "";
      String siCHoverIngressEgress = formDesignerImportLocalVariables["siC_HoverIngressEgress"] ?? "";
      String paramedicHoverIngressEgress = formDesignerImportLocalVariables["paramedic_HoverIngressEgress"] ?? "";
      String paramedicDoubleUpExtraction = formDesignerImportLocalVariables["paramedic_DoubleUpExtraction"] ?? "";
      String paramedicDoubleUpExtractionSO = formDesignerImportLocalVariables["paramedic_DoubleUpExtractionSO"] ?? "";
      String piCLitterHoistWithTaglineDay = formDesignerImportLocalVariables["piC_LitterHoistwithTaglineDay"] ?? "";
      String siCLitterHoistWithTaglineDay = formDesignerImportLocalVariables["siC_LitterHoistwithTaglineDay"] ?? "";
      String paramedicLitterHoistWithTaglineDay = formDesignerImportLocalVariables["paramedic_LitterHoistwithTaglineDay"] ?? "";
      String paramedicLitterHoistWithTaglineDaySO = formDesignerImportLocalVariables["paramedic_LitterHoistwithTaglineDaySO"] ?? "";
      String piCLitterHoistWithTaglineNight = formDesignerImportLocalVariables["piC_LitterHoistwithTaglineNight"] ?? "";
      String siCLitterHoistWithTaglineNight = formDesignerImportLocalVariables["siC_LitterHoistwithTaglineNight"] ?? "";
      String paramedicLitterHoistWithTaglineNight = formDesignerImportLocalVariables["paramedic_LitterHoistwithTaglineNight"] ?? "";
      String paramedicLitterHoistWithTaglineNightSO = formDesignerImportLocalVariables["paramedic_LitterHoistwithTaglineNightSO"] ?? "";
      String paramedicLitterDoubleUpWithTaglineDay = formDesignerImportLocalVariables["paramedic_LitterDouble_UpwithTaglineDay"] ?? "";
      String paramedicLitterDoubleUpWithTaglineDaySO = formDesignerImportLocalVariables["paramedic_LitterDoubleUpwithTaglineDaySO"] ?? "";
      String paramedicLitterDoubleUpWithTaglineNight = formDesignerImportLocalVariables["paramedic_LitterDouble_UpwithTaglineNight"] ?? "";
      String paramedicLitterDoubleUpWithTaglineNightSO = formDesignerImportLocalVariables["paramedic_LitterDoubleUpwithTaglineNightSO"] ?? "";
      int strNjspCrewChiefId = formDesignerImportLocalVariables["njspCrewChiefId"] ?? 0;
      String aircraftType = demographicsData["aircraftType"] ?? "";
      String strNjspCoPilotHoistCycle = formDesignerImportLocalVariables["njspCoPilotHoistCycle"] ?? "";
      String strNjspPilotNightHoistCycle = formDesignerImportLocalVariables["njspPilotNightHoistCycle"] ?? "";
      String strNjspPilotHoistCycle = formDesignerImportLocalVariables["njspPilotHoistCycle"] ?? "";
      String strNjspCoPilotNightHoistCycle = formDesignerImportLocalVariables["njspCoPilotNightHoistCycle"] ?? "";
      String strNjspCCHoistCycleDay = formDesignerImportLocalVariables["njspCCHoistCycleDay"] ?? "";
      String strNjspCCHoistCycleNight = formDesignerImportLocalVariables["njspCCHoistCycleNight"] ?? "";
      String strNjspPilotApproachILS = formDesignerImportLocalVariables["njspPilotApproachILS"] ?? "";
      String strNjspCoPilotApproachILS = formDesignerImportLocalVariables["njspCoPilotApproachILS"] ?? "";
      String strNjspPilotApproachLPV = formDesignerImportLocalVariables["njspPilotApproachLPV"] ?? "";
      String strNjspCoPilotApproachLPV = formDesignerImportLocalVariables["njspCoPilotApproachLPV"] ?? "";
      String strNjspPilotApproachLNAV = formDesignerImportLocalVariables["njspPilotApproachLNAV"] ?? "";
      String strNjspCoPilotApproachLNAV = formDesignerImportLocalVariables["njspCoPilotApproachLNAV"] ?? "";
      String strNjspPilotApproachLOC = formDesignerImportLocalVariables["njspPilotApproachLOC"] ?? "";
      String strNjspCoPilotApproachLOC = formDesignerImportLocalVariables["njspCoPilotApproachLOC"] ?? "";
      String strNjspPilotApproachVOR = formDesignerImportLocalVariables["njspPilotApproachVOR"] ?? "";
      String strNjspCoPilotApproachVOR = formDesignerImportLocalVariables["njspCoPilotApproachVOR"] ?? "";
      String strNjspCCFastRope = formDesignerImportLocalVariables["njspCCFastRope"] ?? "";
      String hoistOpID = formDesignerImportLocalVariables["hoistOp_ID"] ?? "";
      String piCToeIN = formDesignerImportLocalVariables["piC_ToeIN"] ?? "";
      String hoistOpOneSkid = formDesignerImportLocalVariables["hoistOp_OneSkid"] ?? "";
      String piCTotalNumberPicks = formDesignerImportLocalVariables["piC_TotalNumberPicks"] ?? "";
      String trNPilotTotalPicks1 = formDesignerImportLocalVariables["trN_Pilot_Total_Picks1"] ?? "";
      String trNPilotTotalPicks2 = formDesignerImportLocalVariables["trN_Pilot_Total_Picks2"] ?? "";
      String trNPilotTotalPicks3 = formDesignerImportLocalVariables["trN_Pilot_Total_Picks3"] ?? "";
      String trNPilotTotalPicks4 = formDesignerImportLocalVariables["trN_Pilot_Total_Picks4"] ?? "";
      String trNPilotTotalPicks5 = formDesignerImportLocalVariables["trN_Pilot_Total_Picks5"] ?? "";
      String trNPilotTotalPicks6 = formDesignerImportLocalVariables["trN_Pilot_Total_Picks6"] ?? "";
      String hoistOpTotalOfPicks1 = formDesignerImportLocalVariables["hoistoP_TOTAL_OF_PICKS1"] ?? "";
      String hoistOpTotalOfPicks2 = formDesignerImportLocalVariables["hoistoP_TOTAL_OF_PICKS2"] ?? "";
      String hoistOpTotalOfPicks3 = formDesignerImportLocalVariables["hoistoP_TOTAL_OF_PICKS3"] ?? "";
      String hoistOpTotalOfPicks4 = formDesignerImportLocalVariables["hoistoP_TOTAL_OF_PICKS4"] ?? "";
      String hoistOpTotalOfPicks5 = formDesignerImportLocalVariables["hoistoP_TOTAL_OF_PICKS5"] ?? "";
      String hoistOpTotalOfPicks6 = formDesignerImportLocalVariables["hoistoP_TOTAL_OF_PICKS6"] ?? "";
      String rescueTotalOfPicks1 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS1"] ?? "";
      String rescueTotalOfPicks2 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS2"] ?? "";
      String rescueTotalOfPicks3 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS3"] ?? "";
      String rescueTotalOfPicks4 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS4"] ?? "";
      String rescueTotalOfPicks5 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS5"] ?? "";
      String rescueTotalOfPicks6 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS6"] ?? "";
      String rescueTotalOfPicks7 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS7"] ?? "";
      String rescueTotalOfPicks8 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS8"] ?? "";
      String rescueTotalOfPicks9 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS9"] ?? "";
      String rescueTotalOfPicks10 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS10"] ?? "";
      String rescueTotalOfPicks11 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS11"] ?? "";
      String rescueTotalOfPicks12 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS12"] ?? "";
      String rescueTotalOfPicks13 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS13"] ?? "";
      String rescueTotalOfPicks14 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS14"] ?? "";
      String rescueTotalOfPicks15 = formDesignerImportLocalVariables["rescuE_TOTAL_OF_PICKS15"] ?? "";
      String hoistOpAres = formDesignerImportLocalVariables["hoistOp_Ares"] ?? "";
      String trNPilotARESPICKS1 = formDesignerImportLocalVariables["trN_Pilot_ARES_PICKS1"] ?? "";
      String trNPilotARESPICKS2 = formDesignerImportLocalVariables["trN_Pilot_ARES_PICKS2"] ?? "";
      String trNPilotARESPICKS3 = formDesignerImportLocalVariables["trN_Pilot_ARES_PICKS3"] ?? "";
      String trNPilotARESPICKS4 = formDesignerImportLocalVariables["trN_Pilot_ARES_PICKS4"] ?? "";
      String trNPilotARESPICKS5 = formDesignerImportLocalVariables["trN_Pilot_ARES_PICKS5"] ?? "";
      String trNPilotARESPICKS6 = formDesignerImportLocalVariables["trN_Pilot_ARES_PICKS6"] ?? "";
      String hoistOpOfARESPICKS1 = formDesignerImportLocalVariables["hoistoP_OF_ARES_PICKS1"] ?? "";
      String hoistOpOfARESPICKS2 = formDesignerImportLocalVariables["hoistoP_OF_ARES_PICKS2"] ?? "";
      String hoistOpOfARESPICKS3 = formDesignerImportLocalVariables["hoistoP_OF_ARES_PICKS3"] ?? "";
      String hoistOpOfARESPICKS4 = formDesignerImportLocalVariables["hoistoP_OF_ARES_PICKS4"] ?? "";
      String hoistOpOfARESPICKS5 = formDesignerImportLocalVariables["hoistoP_OF_ARES_PICKS5"] ?? "";
      String hoistOpOfARESPICKS6 = formDesignerImportLocalVariables["hoistoP_OF_ARES_PICKS6"] ?? "";
      String rescueARESPICKS1 = formDesignerImportLocalVariables["rescuE_ARES_PICKS1"] ?? "";
      String rescueARESPICKS2 = formDesignerImportLocalVariables["rescuE_ARES_PICKS2"] ?? "";
      String rescueARESPICKS3 = formDesignerImportLocalVariables["rescuE_ARES_PICKS3"] ?? "";
      String rescueARESPICKS4 = formDesignerImportLocalVariables["rescuE_ARES_PICKS4"] ?? "";
      String rescueARESPICKS5 = formDesignerImportLocalVariables["rescuE_ARES_PICKS5"] ?? "";
      String rescueARESPICKS6 = formDesignerImportLocalVariables["rescuE_ARES_PICKS6"] ?? "";
      String rescueARESPICKS7 = formDesignerImportLocalVariables["rescuE_ARES_PICKS7"] ?? "";
      String rescueARESPICKS8 = formDesignerImportLocalVariables["rescuE_ARES_PICKS8"] ?? "";
      String rescueARESPICKS9 = formDesignerImportLocalVariables["rescuE_ARES_PICKS9"] ?? "";
      String rescueARESPICKS10 = formDesignerImportLocalVariables["rescuE_ARES_PICKS10"] ?? "";
      String rescueARESPICKS11 = formDesignerImportLocalVariables["rescuE_ARES_PICKS11"] ?? "";
      String rescueARESPICKS12 = formDesignerImportLocalVariables["rescuE_ARES_PICKS12"] ?? "";
      String rescueARESPICKS13 = formDesignerImportLocalVariables["rescuE_ARES_PICKS13"] ?? "";
      String rescueARESPICKS14 = formDesignerImportLocalVariables["rescuE_ARES_PICKS14"] ?? "";
      String rescueARESPICKS15 = formDesignerImportLocalVariables["rescuE_ARES_PICKS15"] ?? "";
      String hoistOpArv = formDesignerImportLocalVariables["hoistOp_Arv"] ?? "";
      String trNPilotARVPICKS1 = formDesignerImportLocalVariables["trN_Pilot_ARV_PICKS1"] ?? "";
      String trNPilotARVPICKS2 = formDesignerImportLocalVariables["trN_Pilot_ARV_PICKS2"] ?? "";
      String trNPilotARVPICKS3 = formDesignerImportLocalVariables["trN_Pilot_ARV_PICKS3"] ?? "";
      String trNPilotARVPICKS4 = formDesignerImportLocalVariables["trN_Pilot_ARV_PICKS4"] ?? "";
      String trNPilotARVPICKS5 = formDesignerImportLocalVariables["trN_Pilot_ARV_PICKS5"] ?? "";
      String trNPilotARVPICKS6 = formDesignerImportLocalVariables["trN_Pilot_ARV_PICKS6"] ?? "";
      String hoistOpARVPICKS1 = formDesignerImportLocalVariables["hoistoP_ARV_PICKS1"] ?? "";
      String hoistOpARVPICKS2 = formDesignerImportLocalVariables["hoistoP_ARV_PICKS2"] ?? "";
      String hoistOpARVPICKS3 = formDesignerImportLocalVariables["hoistoP_ARV_PICKS3"] ?? "";
      String hoistOpARVPICKS4 = formDesignerImportLocalVariables["hoistoP_ARV_PICKS4"] ?? "";
      String hoistOpARVPICKS5 = formDesignerImportLocalVariables["hoistoP_ARV_PICKS5"] ?? "";
      String hoistOpARVPICKS6 = formDesignerImportLocalVariables["hoistoP_ARV_PICKS6"] ?? "";
      String rescueARVPICKS1 = formDesignerImportLocalVariables["rescuE_ARV_PICKS1"] ?? "";
      String rescueARVPICKS2 = formDesignerImportLocalVariables["rescuE_ARV_PICKS2"] ?? "";
      String rescueARVPICKS3 = formDesignerImportLocalVariables["rescuE_ARV_PICKS3"] ?? "";
      String rescueARVPICKS4 = formDesignerImportLocalVariables["rescuE_ARV_PICKS4"] ?? "";
      String rescueARVPICKS5 = formDesignerImportLocalVariables["rescuE_ARV_PICKS5"] ?? "";
      String rescueARVPICKS6 = formDesignerImportLocalVariables["rescuE_ARV_PICKS6"] ?? "";
      String rescueARVPICKS7 = formDesignerImportLocalVariables["rescuE_ARV_PICKS7"] ?? "";
      String rescueARVPICKS8 = formDesignerImportLocalVariables["rescuE_ARV_PICKS8"] ?? "";
      String rescueARVPICKS9 = formDesignerImportLocalVariables["rescuE_ARV_PICKS9"] ?? "";
      String rescueARVPICKS10 = formDesignerImportLocalVariables["rescuE_ARV_PICKS10"] ?? "";
      String rescueARVPICKS11 = formDesignerImportLocalVariables["rescuE_ARV_PICKS11"] ?? "";
      String rescueARVPICKS12 = formDesignerImportLocalVariables["rescuE_ARV_PICKS12"] ?? "";
      String rescueARVPICKS13 = formDesignerImportLocalVariables["rescuE_ARV_PICKS13"] ?? "";
      String rescueARVPICKS14 = formDesignerImportLocalVariables["rescuE_ARV_PICKS14"] ?? "";
      String rescueARVPICKS15 = formDesignerImportLocalVariables["rescuE_ARV_PICKS15"] ?? "";
      String hoistOp2Ups = formDesignerImportLocalVariables["hoistOp_2Ups"] ?? "";
      String trNPilot2UPS1 = formDesignerImportLocalVariables["trN_Pilot_2UPS1"] ?? "";
      String trNPilot2UPS2 = formDesignerImportLocalVariables["trN_Pilot_2UPS2"] ?? "";
      String trNPilot2UPS3 = formDesignerImportLocalVariables["trN_Pilot_2UPS3"] ?? "";
      String trNPilot2UPS4 = formDesignerImportLocalVariables["trN_Pilot_2UPS4"] ?? "";
      String trNPilot2UPS5 = formDesignerImportLocalVariables["trN_Pilot_2UPS5"] ?? "";
      String trNPilot2UPS6 = formDesignerImportLocalVariables["trN_Pilot_2UPS6"] ?? "";
      String hoistOp2UPS1 = formDesignerImportLocalVariables["hoistoP_2UPS1"] ?? "";
      String hoistOp2UPS2 = formDesignerImportLocalVariables["hoistoP_2UPS2"] ?? "";
      String hoistOp2UPS3 = formDesignerImportLocalVariables["hoistoP_2UPS3"] ?? "";
      String hoistOp2UPS4 = formDesignerImportLocalVariables["hoistoP_2UPS4"] ?? "";
      String hoistOp2UPS5 = formDesignerImportLocalVariables["hoistoP_2UPS5"] ?? "";
      String hoistOp2UPS6 = formDesignerImportLocalVariables["hoistoP_2UPS6"] ?? "";
      String rescue2UPS1 = formDesignerImportLocalVariables["rescuE_2UPS1"] ?? "";
      String rescue2UPS2 = formDesignerImportLocalVariables["rescuE_2UPS2"] ?? "";
      String rescue2UPS3 = formDesignerImportLocalVariables["rescuE_2UPS3"] ?? "";
      String rescue2UPS4 = formDesignerImportLocalVariables["rescuE_2UPS4"] ?? "";
      String rescue2UPS5 = formDesignerImportLocalVariables["rescuE_2UPS5"] ?? "";
      String rescue2UPS6 = formDesignerImportLocalVariables["rescuE_2UPS6"] ?? "";
      String rescue2UPS7 = formDesignerImportLocalVariables["rescuE_2UPS7"] ?? "";
      String rescue2UPS8 = formDesignerImportLocalVariables["rescuE_2UPS8"] ?? "";
      String rescue2UPS9 = formDesignerImportLocalVariables["rescuE_2UPS9"] ?? "";
      String rescue2UPS10 = formDesignerImportLocalVariables["rescuE_2UPS10"] ?? "";
      String rescue2UPS11 = formDesignerImportLocalVariables["rescuE_2UPS11"] ?? "";
      String rescue2UPS12 = formDesignerImportLocalVariables["rescuE_2UPS12"] ?? "";
      String rescue2UPS13 = formDesignerImportLocalVariables["rescuE_2UPS13"] ?? "";
      String rescue2UPS14 = formDesignerImportLocalVariables["rescuE_2UPS14"] ?? "";
      String rescue2UPS15 = formDesignerImportLocalVariables["rescuE_2UPS15"] ?? "";
      String hoistOpTagLine = formDesignerImportLocalVariables["hoistOp_TagLine"] ?? "";
      String hoistOpTAGLINES1 = formDesignerImportLocalVariables["hoistoP_TAG_LINES1"] ?? "";
      String hoistOpTAGLINES2 = formDesignerImportLocalVariables["hoistoP_TAG_LINES2"] ?? "";
      String hoistOpTAGLINES3 = formDesignerImportLocalVariables["hoistoP_TAG_LINES3"] ?? "";
      String hoistOpTAGLINES4 = formDesignerImportLocalVariables["hoistoP_TAG_LINES4"] ?? "";
      String hoistOpTAGLINES5 = formDesignerImportLocalVariables["hoistoP_TAG_LINES5"] ?? "";
      String hoistOpTAGLINES6 = formDesignerImportLocalVariables["hoistoP_TAG_LINES6"] ?? "";
      String rescueTAGLINES1 = formDesignerImportLocalVariables["rescuE_TAG_LINES1"] ?? "";
      String rescueTAGLINES2 = formDesignerImportLocalVariables["rescuE_TAG_LINES2"] ?? "";
      String rescueTAGLINES3 = formDesignerImportLocalVariables["rescuE_TAG_LINES3"] ?? "";
      String rescueTAGLINES4 = formDesignerImportLocalVariables["rescuE_TAG_LINES4"] ?? "";
      String rescueTAGLINES5 = formDesignerImportLocalVariables["rescuE_TAG_LINES5"] ?? "";
      String rescueTAGLINES6 = formDesignerImportLocalVariables["rescuE_TAG_LINES6"] ?? "";
      String rescueTAGLINES7 = formDesignerImportLocalVariables["rescuE_TAG_LINES7"] ?? "";
      String rescueTAGLINES8 = formDesignerImportLocalVariables["rescuE_TAG_LINES8"] ?? "";
      String rescueTAGLINES9 = formDesignerImportLocalVariables["rescuE_TAG_LINES9"] ?? "";
      String rescueTAGLINES10 = formDesignerImportLocalVariables["rescuE_TAG_LINES10"] ?? "";
      String rescueTAGLINES11 = formDesignerImportLocalVariables["rescuE_TAG_LINES11"] ?? "";
      String rescueTAGLINES12 = formDesignerImportLocalVariables["rescuE_TAG_LINES12"] ?? "";
      String rescueTAGLINES13 = formDesignerImportLocalVariables["rescuE_TAG_LINES13"] ?? "";
      String rescueTAGLINES14 = formDesignerImportLocalVariables["rescuE_TAG_LINES14"] ?? "";
      String rescueTAGLINES15 = formDesignerImportLocalVariables["rescuE_TAG_LINES15"] ?? "";
      String trNPilotEMERGENCYOPS1 = formDesignerImportLocalVariables["trN_Pilot_EMERGENCY_OPS1"] ?? "";
      String trNPilotEMERGENCYOPS2 = formDesignerImportLocalVariables["trN_Pilot_EMERGENCY_OPS2"] ?? "";
      String trNPilotEMERGENCYOPS3 = formDesignerImportLocalVariables["trN_Pilot_EMERGENCY_OPS3"] ?? "";
      String trNPilotEMERGENCYOPS4 = formDesignerImportLocalVariables["trN_Pilot_EMERGENCY_OPS4"] ?? "";
      String trNPilotEMERGENCYOPS5 = formDesignerImportLocalVariables["trN_Pilot_EMERGENCY_OPS5"] ?? "";
      String trNPilotEMERGENCYOPS6 = formDesignerImportLocalVariables["trN_Pilot_EMERGENCY_OPS6"] ?? "";
      String hoistOpEMERGENCYOPERATIONS1 = formDesignerImportLocalVariables["hoistoP_EMERGENCY_OPERATIONS1"] ?? "";
      String hoistOpEMERGENCYOPERATIONS2 = formDesignerImportLocalVariables["hoistoP_EMERGENCY_OPERATIONS2"] ?? "";
      String hoistOpEMERGENCYOPERATIONS3 = formDesignerImportLocalVariables["hoistoP_EMERGENCY_OPERATIONS3"] ?? "";
      String hoistOpEMERGENCYOPERATIONS4 = formDesignerImportLocalVariables["hoistoP_EMERGENCY_OPERATIONS4"] ?? "";
      String hoistOpEMERGENCYOPERATIONS5 = formDesignerImportLocalVariables["hoistoP_EMERGENCY_OPERATIONS5"] ?? "";
      String hoistOpEMERGENCYOPERATIONS6 = formDesignerImportLocalVariables["hoistoP_EMERGENCY_OPERATIONS6"] ?? "";
      String rescueEMERGENCYOPS1 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS1"] ?? "";
      String rescueEMERGENCYOPS2 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS2"] ?? "";
      String rescueEMERGENCYOPS3 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS3"] ?? "";
      String rescueEMERGENCYOPS4 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS4"] ?? "";
      String rescueEMERGENCYOPS5 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS5"] ?? "";
      String rescueEMERGENCYOPS6 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS6"] ?? "";
      String rescueEMERGENCYOPS7 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS7"] ?? "";
      String rescueEMERGENCYOPS8 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS8"] ?? "";
      String rescueEMERGENCYOPS9 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS9"] ?? "";
      String rescueEMERGENCYOPS10 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS10"] ?? "";
      String rescueEMERGENCYOPS11 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS11"] ?? "";
      String rescueEMERGENCYOPS12 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS12"] ?? "";
      String rescueEMERGENCYOPS13 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS13"] ?? "";
      String rescueEMERGENCYOPS14 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS14"] ?? "";
      String rescueEMERGENCYOPS15 = formDesignerImportLocalVariables["rescuE_EMERGENCY_OPS15"] ?? "";
      int strHoistOp1 = formDesignerImportLocalVariables["hoistOp1"] ?? 0;
      int strHoistOp2 = formDesignerImportLocalVariables["hoistOp2"] ?? 0;
      int strHoistOp3 = formDesignerImportLocalVariables["hoistOp3"] ?? 0;
      int strHoistOp4 = formDesignerImportLocalVariables["hoistOp4"] ?? 0;
      int strHoistOp1Qty = formDesignerImportLocalVariables["hoistOp1_Qty"] ?? 0;
      int strHoistOp2Qty = formDesignerImportLocalVariables["hoistOp2_Qty"] ?? 0;
      int strHoistOp3Qty = formDesignerImportLocalVariables["hoistOp3_Qty"] ?? 0;
      int strHoistOp4Qty = formDesignerImportLocalVariables["hoistOp4_Qty"] ?? 0;
      int strRecueTech1 = formDesignerImportLocalVariables["recueTech1"] ?? 0;
      int strRecueTech2 = formDesignerImportLocalVariables["recueTech2"] ?? 0;
      int strRecueTech3 = formDesignerImportLocalVariables["recueTech3"] ?? 0;
      int strRecueTech4 = formDesignerImportLocalVariables["recueTech4"] ?? 0;
      int strRecueTech5 = formDesignerImportLocalVariables["recueTech5"] ?? 0;
      int strRescueTech1Qty = formDesignerImportLocalVariables["rescueTech1_Qty"] ?? 0;
      int strRescueTech2Qty = formDesignerImportLocalVariables["rescueTech2_Qty"] ?? 0;
      int strRescueTech3Qty = formDesignerImportLocalVariables["rescueTech3_Qty"] ?? 0;
      int strRescueTech4Qty = formDesignerImportLocalVariables["rescueTech4_Qty"] ?? 0;
      int strRescueTech5Qty = formDesignerImportLocalVariables["rescueTech5_Qty"] ?? 0;
      int strPicDayAuto = formDesignerImportLocalVariables["picDayAuto"] ?? 0;
      int strSicDayAuto = formDesignerImportLocalVariables["sicDayAuto"] ?? 0;
      int strPicNightAuto = formDesignerImportLocalVariables["picNightAuto"] ?? 0;
      int strSicNightAuto = formDesignerImportLocalVariables["sicNightAuto"] ?? 0;
      String picDayFlightTime = formDesignerImportLocalVariables["piC_Day_Flight_Time"] ?? "";
      String siC1DayFlightTime = formDesignerImportLocalVariables["siC1_Day_Flight_Time"] ?? "";
      String tfO1DayFlightTime = formDesignerImportLocalVariables["tfO1_Day_Flight_Time"] ?? "";
      String tfO2DayFlightTime = formDesignerImportLocalVariables["tfO2_Day_Flight_Time"] ?? "";
      String tfO3DayFlightTime = formDesignerImportLocalVariables["tfO3_Day_Flight_Time"] ?? "";
      String siC1Solo = formDesignerImportLocalVariables["siC1_Solo"] ?? "";
      String piCHoistOPS = formDesignerImportLocalVariables["piC_Hoist_OPS"] ?? "";
      String siC1HoistOPS = formDesignerImportLocalVariables["siC1_Hoist_OPS"] ?? "";
      String piCTrack = formDesignerImportLocalVariables["piC_Track"] ?? "";
      String siC1Track = formDesignerImportLocalVariables["siC1_Track"] ?? "";
      String tfO1TimeInCityAircraft = formDesignerImportLocalVariables["tfO1_TIME_IN_CITY_AIRCRAFT"] ?? "";
      String tfO2TimeInCityAircraft = formDesignerImportLocalVariables["tfO2_TIME_IN_CITY_AIRCRAFT"] ?? "";
      String tfO3TimeInCityAircraft = formDesignerImportLocalVariables["tfO3_TIME_IN_CITY_AIRCRAFT"] ?? "";
      String picNVGLandings = formDesignerImportLocalVariables["piC_NVG_Landings"] ?? "";
      String siC1NVGLandings = formDesignerImportLocalVariables["siC1_NVG_Landings"] ?? "";
      String tfO1FLIRSearch = formDesignerImportLocalVariables["tfO1_FLIR_SEARCH"] ?? "";
      String tfO2FLIRSearch = formDesignerImportLocalVariables["tfO2_FLIR_SEARCH"] ?? "";
      String tfO3FLIRSearch = formDesignerImportLocalVariables["tfO3_FLIR_SEARCH"] ?? "";
      String tfO1FOOTPursuits = formDesignerImportLocalVariables["tfO1_FOOT_PURSUITS"] ?? "";
      String tfO2FOOTPursuits = formDesignerImportLocalVariables["tfO2_FOOT_PURSUITS"] ?? "";
      String tfO3FOOTPursuits = formDesignerImportLocalVariables["tfO3_FOOT_PURSUITS"] ?? "";
      String tfO1VehiclePursuits = formDesignerImportLocalVariables["tfO1_VEHICLE_PURSUITS"] ?? "";
      String tfO2VehiclePursuits = formDesignerImportLocalVariables["tfO2_VEHICLE_PURSUITS"] ?? "";
      String tfO3VehiclePursuits = formDesignerImportLocalVariables["tfO3_VEHICLE_PURSUITS"] ?? "";
      String hoistHoistOperator = formDesignerImportLocalVariables["hoisT_Hoist_Operator"] ?? "";
      String hoistRescueTechnician = formDesignerImportLocalVariables["hoisT_Rescue_Technician"] ?? "";
      String hoistTotalTrainingHours = formDesignerImportLocalVariables["hoisT_Total_Training_Hours"] ?? "";
      String hoistBasketHoists = formDesignerImportLocalVariables["hoisT_Basket_Hoists"] ?? "";
      String hoistHOTSEATHoists = formDesignerImportLocalVariables["hoisT_HOTSEAT_Hoists"] ?? "";
      String oh58TT = formDesignerImportLocalVariables["oh58TT"] ?? "";
      String md500TT = formDesignerImportLocalVariables["md500TT"] ?? "";
      String piCBasketLitterShortHaul = formDesignerImportLocalVariables["piC_BasketLitterShortHaul"] ?? "";
      String siCBasketLitterShortHaul = formDesignerImportLocalVariables["siC_BasketLitterShortHaul"] ?? "";
      String cC1BasketLitterShortHaul = formDesignerImportLocalVariables["cC1_BasketLitterShortHaul"] ?? "";
      String cC2BasketLitterShortHaul = formDesignerImportLocalVariables["cC2_BasketLitterShortHaul"] ?? "";
      String cC3BasketLitterShortHaul = formDesignerImportLocalVariables["cC3_BasketLitterShortHaul"] ?? "";
      String cC4BasketLitterShortHaul = formDesignerImportLocalVariables["cC4_BasketLitterShortHaul"] ?? "";
      String hpR1User = formDesignerImportLocalVariables["hpR1_User"] ?? "";
      String hpR2User = formDesignerImportLocalVariables["hpR2_User"] ?? "";
      String hpR3User = formDesignerImportLocalVariables["hpR3_User"] ?? "";
      String hpR4User = formDesignerImportLocalVariables["hpR4_User"] ?? "";
      String hpR1BasketLitterShortHaul = formDesignerImportLocalVariables["hpR1_BasketLitterShortHaul"] ?? "";
      String hpR2BasketLitterShortHaul = formDesignerImportLocalVariables["hpR2_BasketLitterShortHaul"] ?? "";
      String hpR3BasketLitterShortHaul = formDesignerImportLocalVariables["hpR3_BasketLitterShortHaul"] ?? "";
      String hpR4BasketLitterShortHaul = formDesignerImportLocalVariables["hpR4_BasketLitterShortHaul"] ?? "";
      String piCBasketLitterInsertionExtraction = formDesignerImportLocalVariables["piC_BasketLitterInsertionExtraction"] ?? "";
      String siCBasketLitterInsertionExtraction = formDesignerImportLocalVariables["siC_BasketLitterInsertionExtraction"] ?? "";
      String cC1BasketLitterInsertionExtraction = formDesignerImportLocalVariables["cC1_BasketLitterInsertionExtraction"] ?? "";
      String cC2BasketLitterInsertionExtraction = formDesignerImportLocalVariables["cC2_BasketLitterInsertionExtraction"] ?? "";
      String cC3BasketLitterInsertionExtraction = formDesignerImportLocalVariables["cC3_BasketLitterInsertionExtraction"] ?? "";
      String cC4BasketLitterInsertionExtraction = formDesignerImportLocalVariables["cC4_BasketLitterInsertionExtraction"] ?? "";
      String hpR1BasketLitterInsertionExtraction = formDesignerImportLocalVariables["hpR1_BasketLitterInsertionExtraction"] ?? "";
      String hpR2BasketLitterInsertionExtraction = formDesignerImportLocalVariables["hpR2_BasketLitterInsertionExtraction"] ?? "";
      String hpR3BasketLitterInsertionExtraction = formDesignerImportLocalVariables["hpR3_BasketLitterInsertionExtraction"] ?? "";
      String hpR4BasketLitterInsertionExtraction = formDesignerImportLocalVariables["hpR4_BasketLitterInsertionExtraction"] ?? "";
      String trT1User = formDesignerImportLocalVariables["trT1_User"] ?? "";
      String trT2User = formDesignerImportLocalVariables["trT2_User"] ?? "";
      String trT3User = formDesignerImportLocalVariables["trT3_User"] ?? "";
      String trT4User = formDesignerImportLocalVariables["trT4_User"] ?? "";
      String trT1BasketLitterInsertionExtraction = formDesignerImportLocalVariables["trT1_BasketLitterInsertionExtraction"] ?? "";
      String trT2BasketLitterInsertionExtraction = formDesignerImportLocalVariables["trT2_BasketLitterInsertionExtraction"] ?? "";
      String trT3BasketLitterInsertionExtraction = formDesignerImportLocalVariables["trT3_BasketLitterInsertionExtraction"] ?? "";
      String trT4BasketLitterInsertionExtraction = formDesignerImportLocalVariables["trT4_BasketLitterInsertionExtraction"] ?? "";
      String piCEquipmentInsertionExtraction = formDesignerImportLocalVariables["piC_EquipmentInsertionExtraction"] ?? "";
      String siCEquipmentInsertionExtraction = formDesignerImportLocalVariables["siC_EquipmentInsertionExtraction"] ?? "";
      String cC1EquipmentInsertionExtraction = formDesignerImportLocalVariables["cC1_EquipmentInsertionExtraction"] ?? "";
      String cC2EquipmentInsertionExtraction = formDesignerImportLocalVariables["cC2_EquipmentInsertionExtraction"] ?? "";
      String cC3EquipmentInsertionExtraction = formDesignerImportLocalVariables["cC3_EquipmentInsertionExtraction"] ?? "";
      String cC4EquipmentInsertionExtraction = formDesignerImportLocalVariables["cC4_EquipmentInsertionExtraction"] ?? "";
      String hpR1EquipmentInsertionExtraction = formDesignerImportLocalVariables["hpR1_EquipmentInsertionExtraction"] ?? "";
      String hpR2EquipmentInsertionExtraction = formDesignerImportLocalVariables["hpR2_EquipmentInsertionExtraction"] ?? "";
      String hpR3EquipmentInsertionExtraction = formDesignerImportLocalVariables["hpR3_EquipmentInsertionExtraction"] ?? "";
      String hpR4EquipmentInsertionExtraction = formDesignerImportLocalVariables["hpR4_EquipmentInsertionExtraction"] ?? "";
      String trT1EquipmentInsertionExtraction = formDesignerImportLocalVariables["trT1_EquipmentInsertionExtraction"] ?? "";
      String trT2EquipmentInsertionExtraction = formDesignerImportLocalVariables["trT2_EquipmentInsertionExtraction"] ?? "";
      String trT3EquipmentInsertionExtraction = formDesignerImportLocalVariables["trT3_EquipmentInsertionExtraction"] ?? "";
      String trT4EquipmentInsertionExtraction = formDesignerImportLocalVariables["trT4_EquipmentInsertionExtraction"] ?? "";
      String piCRescuerInsertionExtraction = formDesignerImportLocalVariables["piC_RescuerInsertionExtraction"] ?? "";
      String siCRescuerInsertionExtraction = formDesignerImportLocalVariables["siC_RescuerInsertionExtraction"] ?? "";
      String cC1RescuerInsertionExtraction = formDesignerImportLocalVariables["cC1_RescuerInsertionExtraction"] ?? "";
      String cC2RescuerInsertionExtraction = formDesignerImportLocalVariables["cC2_RescuerInsertionExtraction"] ?? "";
      String cC3RescuerInsertionExtraction = formDesignerImportLocalVariables["cC3_RescuerInsertionExtraction"] ?? "";
      String cC4RescuerInsertionExtraction = formDesignerImportLocalVariables["cC4_RescuerInsertionExtraction"] ?? "";
      String hpR1RescuerInsertionExtraction = formDesignerImportLocalVariables["hpR1_RescuerInsertionExtraction"] ?? "";
      String hpR2RescuerInsertionExtraction = formDesignerImportLocalVariables["hpR2_RescuerInsertionExtraction"] ?? "";
      String hpR3RescuerInsertionExtraction = formDesignerImportLocalVariables["hpR3_RescuerInsertionExtraction"] ?? "";
      String hpR4RescuerInsertionExtraction = formDesignerImportLocalVariables["hpR4_RescuerInsertionExtraction"] ?? "";
      String trT1RescuerInsertionExtraction = formDesignerImportLocalVariables["trT1_RescuerInsertionExtraction"] ?? "";
      String trT2RescuerInsertionExtraction = formDesignerImportLocalVariables["trT2_RescuerInsertionExtraction"] ?? "";
      String trT3RescuerInsertionExtraction = formDesignerImportLocalVariables["trT3_RescuerInsertionExtraction"] ?? "";
      String trT4RescuerInsertionExtraction = formDesignerImportLocalVariables["trT4_RescuerInsertionExtraction"] ?? "";
      String piCPickOffRescue = formDesignerImportLocalVariables["piC_PickOffRescue"] ?? "";
      String siCPickOffRescue = formDesignerImportLocalVariables["siC_PickOffRescue"] ?? "";
      String cC1PickOffRescue = formDesignerImportLocalVariables["cC1_PickOffRescue"] ?? "";
      String cC2PickOffRescue = formDesignerImportLocalVariables["cC2_PickOffRescue"] ?? "";
      String cC3PickOffRescue = formDesignerImportLocalVariables["cC3_PickOffRescue"] ?? "";
      String cC4PickOffRescue = formDesignerImportLocalVariables["cC4_PickOffRescue"] ?? "";
      String hpR1PickOffRescue = formDesignerImportLocalVariables["hpR1_PickOffRescue"] ?? "";
      String hpR2PickOffRescue = formDesignerImportLocalVariables["hpR2_PickOffRescue"] ?? "";
      String hpR3PickOffRescue = formDesignerImportLocalVariables["hpR3_PickOffRescue"] ?? "";
      String hpR4PickOffRescue = formDesignerImportLocalVariables["hpR4_PickOffRescue"] ?? "";
      String piCCaptureRescue = formDesignerImportLocalVariables["piC_CaptureRescue"] ?? "";
      String siCCaptureRescue = formDesignerImportLocalVariables["siC_CaptureRescue"] ?? "";
      String cC1CaptureRescue = formDesignerImportLocalVariables["cC1_CaptureRescue"] ?? "";
      String cC2CaptureRescue = formDesignerImportLocalVariables["cC2_CaptureRescue"] ?? "";
      String cC3CaptureRescue = formDesignerImportLocalVariables["cC3_CaptureRescue"] ?? "";
      String cC4CaptureRescue = formDesignerImportLocalVariables["cC4_CaptureRescue"] ?? "";
      String hpR1CaptureRescue = formDesignerImportLocalVariables["hpR1_CaptureRescue"] ?? "";
      String hpR2CaptureRescue = formDesignerImportLocalVariables["hpR2_CaptureRescue"] ?? "";
      String hpR3CaptureRescue = formDesignerImportLocalVariables["hpR3_CaptureRescue"] ?? "";
      String hpR4CaptureRescue = formDesignerImportLocalVariables["hpR4_CaptureRescue"] ?? "";
      String piCLargeAnimal = formDesignerImportLocalVariables["piC_LargeAnimal"] ?? "";
      String siCLargeAnimal = formDesignerImportLocalVariables["siC_LargeAnimal"] ?? "";
      String cC1LargeAnimal = formDesignerImportLocalVariables["cC1_LargeAnimal"] ?? "";
      String cC2LargeAnimal = formDesignerImportLocalVariables["cC2_LargeAnimal"] ?? "";
      String cC3LargeAnimal = formDesignerImportLocalVariables["cC3_LargeAnimal"] ?? "";
      String cC4LargeAnimal = formDesignerImportLocalVariables["cC4_LargeAnimal"] ?? "";
      String hpR1LargeAnimal = formDesignerImportLocalVariables["hpR1_LargeAnimal"] ?? "";
      String hpR2LargeAnimal = formDesignerImportLocalVariables["hpR2_LargeAnimal"] ?? "";
      String hpR3LargeAnimal = formDesignerImportLocalVariables["hpR3_LargeAnimal"] ?? "";
      String hpR4LargeAnimal = formDesignerImportLocalVariables["hpR4_LargeAnimal"] ?? "";
      String piCVessel = formDesignerImportLocalVariables["piC_Vessel"] ?? "";
      String siCVessel = formDesignerImportLocalVariables["siC_Vessel"] ?? "";
      String cC1Vessel = formDesignerImportLocalVariables["cC1_Vessel"] ?? "";
      String cC2Vessel = formDesignerImportLocalVariables["cC2_Vessel"] ?? "";
      String cC3Vessel = formDesignerImportLocalVariables["cC3_Vessel"] ?? "";
      String cC4Vessel = formDesignerImportLocalVariables["cC4_Vessel"] ?? "";
      String hpR1Vessel = formDesignerImportLocalVariables["hpR1_Vessel"] ?? "";
      String hpR2Vessel = formDesignerImportLocalVariables["hpR2_Vessel"] ?? "";
      String hpR3Vessel = formDesignerImportLocalVariables["hpR3_Vessel"] ?? "";
      String hpR4Vessel = formDesignerImportLocalVariables["hpR4_Vessel"] ?? "";
      String piCSwiftStanding = formDesignerImportLocalVariables["piC_SwiftStanding"] ?? "";
      String siCSwiftStanding = formDesignerImportLocalVariables["siC_SwiftStanding"] ?? "";
      String cC1SwiftStanding = formDesignerImportLocalVariables["cC1_SwiftStanding"] ?? "";
      String cC2SwiftStanding = formDesignerImportLocalVariables["cC2_SwiftStanding"] ?? "";
      String cC3SwiftStanding = formDesignerImportLocalVariables["cC3_SwiftStanding"] ?? "";
      String cC4SwiftStanding = formDesignerImportLocalVariables["cC4_SwiftStanding"] ?? "";
      String hpR1SwiftStanding = formDesignerImportLocalVariables["hpR1_SwiftStanding"] ?? "";
      String hpR2SwiftStanding = formDesignerImportLocalVariables["hpR2_SwiftStanding"] ?? "";
      String hpR3SwiftStanding = formDesignerImportLocalVariables["hpR3_SwiftStanding"] ?? "";
      String hpR4SwiftStanding = formDesignerImportLocalVariables["hpR4_SwiftStanding"] ?? "";
      String piCHoverJumpHeliStep = formDesignerImportLocalVariables["piC_HoverJumpHeliStep"] ?? "";
      String siCHoverJumpHeliStep = formDesignerImportLocalVariables["siC_HoverJumpHeliStep"] ?? "";
      String cC1HoverJumpHeliStep = formDesignerImportLocalVariables["cC1_HoverJumpHeliStep"] ?? "";
      String cC2HoverJumpHeliStep = formDesignerImportLocalVariables["cC2_HoverJumpHeliStep"] ?? "";
      String cC3HoverJumpHeliStep = formDesignerImportLocalVariables["cC3_HoverJumpHeliStep"] ?? "";
      String cC4HoverJumpHeliStep = formDesignerImportLocalVariables["cC4_HoverJumpHeliStep"] ?? "";
      String hpR1HoverJumpHeliStep = formDesignerImportLocalVariables["hpR1_HoverJumpHeliStep"] ?? "";
      String hpR2HoverJumpHeliStep = formDesignerImportLocalVariables["hpR2_HoverJumpHeliStep"] ?? "";
      String hpR3HoverJumpHeliStep = formDesignerImportLocalVariables["hpR3_HoverJumpHeliStep"] ?? "";
      String hpR4HoverJumpHeliStep = formDesignerImportLocalVariables["hpR4_HoverJumpHeliStep"] ?? "";
      String trT1HoverJumpHeliStep = formDesignerImportLocalVariables["trT1_HoverJumpHeliStep"] ?? "";
      String trT2HoverJumpHeliStep = formDesignerImportLocalVariables["trT2_HoverJumpHeliStep"] ?? "";
      String trT3HoverJumpHeliStep = formDesignerImportLocalVariables["trT3_HoverJumpHeliStep"] ?? "";
      String trT4HoverJumpHeliStep = formDesignerImportLocalVariables["trT4_HoverJumpHeliStep"] ?? "";
      String piCNVGLandings = formDesignerImportLocalVariables["piC_NVGLandings"] ?? "";
      String siCNVGLandings = formDesignerImportLocalVariables["siC_NVGLandings"] ?? "";
      String piCNVGWaterDrops = formDesignerImportLocalVariables["piC_NVGWaterDrops"] ?? "";
      String siCNVGWaterDrops = formDesignerImportLocalVariables["siC_NVGWaterDrops"] ?? "";
      String cC1NVGWaterDrops = formDesignerImportLocalVariables["cC1_NVGWaterDrops"] ?? "";
      String cC2NVGWaterDrops = formDesignerImportLocalVariables["cC2_NVGWaterDrops"] ?? "";
      String cC3NVGWaterDrops = formDesignerImportLocalVariables["cC3_NVGWaterDrops"] ?? "";
      String cC4NVGWaterDrops = formDesignerImportLocalVariables["cC4_NVGWaterDrops"] ?? "";
      String cC1NVGHoverOperation = formDesignerImportLocalVariables["cC1_NVGHoverOperation"] ?? "";
      String cC2NVGHoverOperation = formDesignerImportLocalVariables["cC2_NVGHoverOperation"] ?? "";
      String cC3NVGHoverOperation = formDesignerImportLocalVariables["cC3_NVGHoverOperation"] ?? "";
      String cC4NVGHoverOperation = formDesignerImportLocalVariables["cC4_NVGHoverOperation"] ?? "";
      String piCCheckFlight = formDesignerImportLocalVariables["piC_CheckFlight"] ?? "";
      String siCCheckFlight = formDesignerImportLocalVariables["siC_CheckFlight"] ?? "";
      String cC1CheckFlight = formDesignerImportLocalVariables["cC1_CheckFlight"] ?? "";
      String cC2CheckFlight = formDesignerImportLocalVariables["cC2_CheckFlight"] ?? "";
      String cC3CheckFlight = formDesignerImportLocalVariables["cC3_CheckFlight"] ?? "";
      String cC4CheckFlight = formDesignerImportLocalVariables["cC4_CheckFlight"] ?? "";
      String hpR1CheckFlight = formDesignerImportLocalVariables["hpR1_CheckFlight"] ?? "";
      String hpR2CheckFlight = formDesignerImportLocalVariables["hpR2_CheckFlight"] ?? "";
      String hpR3CheckFlight = formDesignerImportLocalVariables["hpR3_CheckFlight"] ?? "";
      String hpR4CheckFlight = formDesignerImportLocalVariables["hpR4_CheckFlight"] ?? "";
      String hpR1NightHoverOperation = formDesignerImportLocalVariables["hpR1_NightHoverOperation"] ?? "";
      String hpR2NightHoverOperation = formDesignerImportLocalVariables["hpR2_NightHoverOperation"] ?? "";
      String hpR3NightHoverOperation = formDesignerImportLocalVariables["hpR3_NightHoverOperation"] ?? "";
      String hpR4NightHoverOperation = formDesignerImportLocalVariables["hpR4_NightHoverOperation"] ?? "";
      String trT1NightHoverOperation = formDesignerImportLocalVariables["trT1_NightHoverOperation"] ?? "";
      String trT2NightHoverOperation = formDesignerImportLocalVariables["trT2_NightHoverOperation"] ?? "";
      String trT3NightHoverOperation = formDesignerImportLocalVariables["trT3_NightHoverOperation"] ?? "";
      String trT4NightHoverOperation = formDesignerImportLocalVariables["trT4_NightHoverOperation"] ?? "";
      String hpR1NightFlightTime = formDesignerImportLocalVariables["hpR1_NightFlightTime"] ?? "";
      String hpR2NightFlightTime = formDesignerImportLocalVariables["hpR2_NightFlightTime"] ?? "";
      String hpR3NightFlightTime = formDesignerImportLocalVariables["hpR3_NightFlightTime"] ?? "";
      String hpR4NightFlightTime = formDesignerImportLocalVariables["hpR4_NightFlightTime"] ?? "";
      String trT1NightFlightTime = formDesignerImportLocalVariables["trT1_NightFlightTime"] ?? "";
      String trT2NightFlightTime = formDesignerImportLocalVariables["trT2_NightFlightTime"] ?? "";
      String trT3NightFlightTime = formDesignerImportLocalVariables["trT3_NightFlightTime"] ?? "";
      String trT4NightFlightTime = formDesignerImportLocalVariables["trT4_NightFlightTime"] ?? "";
      String piCActivitiesEradication = formDesignerImportLocalVariables["piC_ActivitiesEradication"] ?? "";
      String coPilotActivitiesEradication = formDesignerImportLocalVariables["coPilot_ActivitiesEradication"] ?? "";
      String piCActivitiesNVGLandings = formDesignerImportLocalVariables["piC_ActivitiesNVGLandings"] ?? "";
      String coPilotActivitiesNVGLandings = formDesignerImportLocalVariables["coPilot_ActivitiesNVGLandings"] ?? "";
      String piCDayFlightTime = formDesignerImportLocalVariables["piC_DayFlightTime"] ?? "";
      String coPilotDayFlightTime = formDesignerImportLocalVariables["coPilot_DayFlightTime"] ?? "";
      String piCLongLine = formDesignerImportLocalVariables["piC_LongLine"] ?? "";
      String coPilotLongLine = formDesignerImportLocalVariables["coPilot_LongLine"] ?? "";
      String specLongLine1 = formDesignerImportLocalVariables["spec_LongLine_1"] ?? "";
      String specLongLine2 = formDesignerImportLocalVariables["spec_LongLine_2"] ?? "";
      String specLongLine3 = formDesignerImportLocalVariables["spec_LongLine_3"] ?? "";
      String specLongLine4 = formDesignerImportLocalVariables["spec_LongLine_4"] ?? "";
      String specLongLine5 = formDesignerImportLocalVariables["spec_LongLine_5"] ?? "";
      String specLongLine6 = formDesignerImportLocalVariables["spec_LongLine_6"] ?? "";
      String specLongLine7 = formDesignerImportLocalVariables["spec_LongLine_7"] ?? "";
      String specLongLine8 = formDesignerImportLocalVariables["spec_LongLine_8"] ?? "";
      String specLongLine9 = formDesignerImportLocalVariables["spec_LongLine_9"] ?? "";
      String specLongLine10 = formDesignerImportLocalVariables["spec_LongLine_10"] ?? "";
      String piCHECHumanExternalCargo = formDesignerImportLocalVariables["piC_HECHumanExternalCargo"] ?? "";
      String coPilotHECHumanExternalCargo = formDesignerImportLocalVariables["coPilot_HECHumanExternalCargo"] ?? "";
      String specHECHumanExternalCargo1 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_1"] ?? "";
      String specHECHumanExternalCargo2 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_2"] ?? "";
      String specHECHumanExternalCargo3 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_3"] ?? "";
      String specHECHumanExternalCargo4 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_4"] ?? "";
      String specHECHumanExternalCargo5 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_5"] ?? "";
      String specHECHumanExternalCargo6 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_6"] ?? "";
      String specHECHumanExternalCargo7 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_7"] ?? "";
      String specHECHumanExternalCargo8 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_8"] ?? "";
      String specHECHumanExternalCargo9 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_9"] ?? "";
      String specHECHumanExternalCargo10 = formDesignerImportLocalVariables["spec_HECHumanExternalCargo_10"] ?? "";
      String cCHeliSling = formDesignerImportLocalVariables["cC_HeliSling"] ?? "";
      String cCDeploymentSingle = formDesignerImportLocalVariables["cC_DeploymentSingle"] ?? "";
      String crewRESCUESPECIALIST1 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST1"] ?? "";
      String crewRESCUESPECIALIST2 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST2"] ?? "";
      String crewRESCUESPECIALIST3 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST3"] ?? "";
      String crewRESCUESPECIALIST4 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST4"] ?? "";
      String crewRESCUESPECIALIST5 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST5"] ?? "";
      String crewRESCUESPECIALIST6 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST6"] ?? "";
      String crewRESCUESPECIALIST7 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST7"] ?? "";
      String crewRESCUESPECIALIST8 = formDesignerImportLocalVariables["crew_RESCUESPECIALIST8"] ?? "";
      String rSDeploymentSingle = formDesignerImportLocalVariables["rS_DeploymentSingle"] ?? "";
      String cCDeploymentTandem = formDesignerImportLocalVariables["cC_DeploymentTandem"] ?? "";
      String rSDeploymentTandem = formDesignerImportLocalVariables["rS_DeploymentTandem"] ?? "";
      int piCDayOps = formDesignerImportLocalVariables["piC_DayOps"] ?? 0;
      String cCExtractionSingle = formDesignerImportLocalVariables["cC_ExtractionSingle"] ?? "";
      String rSExtractionSingle = formDesignerImportLocalVariables["rS_ExtractionSingle"] ?? "";
      String cCExtractionTandem = formDesignerImportLocalVariables["cC_ExtractionTandem"] ?? "";
      String rSExtractionTandem = formDesignerImportLocalVariables["rS_ExtractionTandem"] ?? "";
      String crewTFO1 = formDesignerImportLocalVariables["crew_TFO1"] ?? "";
      String crewTFO2 = formDesignerImportLocalVariables["crew_TFO2"] ?? "";
      int tfOIMCCurrency = formDesignerImportLocalVariables["tfO_IMCCURRENCY"] ?? 0;
      int cCIMCCurrency = formDesignerImportLocalVariables["cC_IMCCURRENCY"] ?? 0;
      String cCQuickStropSingle = formDesignerImportLocalVariables["cC_QuickstropSingle"] ?? "";
      String rSQuickStropSingle = formDesignerImportLocalVariables["rS_QuickstropSingle"] ?? "";
      String cCQuickStropTandem = formDesignerImportLocalVariables["cC_QuickStropTandem"] ?? "";
      String rSQuickStropTandem = formDesignerImportLocalVariables["rS_QuickStropTandem"] ?? "";
      String cCPEPSingle = formDesignerImportLocalVariables["cC_PEPSingle"] ?? "";
      String rSPEPSingle = formDesignerImportLocalVariables["rS_PEPSingle"] ?? "";
      String cCPEPTandem = formDesignerImportLocalVariables["cC_PEPTandem"] ?? "";
      String rSPEPTandem = formDesignerImportLocalVariables["rS_PEPTandem"] ?? "";
      String cCAVEDSingle = formDesignerImportLocalVariables["cC_AVEDSingle"] ?? "";
      String rSAVEDSingle = formDesignerImportLocalVariables["rS_AVEDSingle"] ?? "";
      String cCAVEDTandem = formDesignerImportLocalVariables["cC_AVEDTandem"] ?? "";
      String rSAVEDTandem = formDesignerImportLocalVariables["rS_AVEDTandem"] ?? "";
      String piCBambiBucket = formDesignerImportLocalVariables["piC_BambiBucket"] ?? "";
      String piCHoistOpsLand = formDesignerImportLocalVariables["piC_HoistOpsLand"] ?? "";
      String cCHoistOpsLand = formDesignerImportLocalVariables["cC_HoistOpsLand"] ?? "";
      String rSHoistOpsLand = formDesignerImportLocalVariables["rS_HoistOpsLand"] ?? "";
      int piCSwatOps = formDesignerImportLocalVariables["piC_SWATOps"] ?? 0;
      String cCRescuerHarnessSingle = formDesignerImportLocalVariables["cC_RescuerHarnessSingle"] ?? "";
      String rSRescuerHarnessSingle = formDesignerImportLocalVariables["rS_RescuerHarnessSingle"] ?? "";
      String crewSWAT1 = formDesignerImportLocalVariables["crew_SWAT1"] ?? "";
      String crewSWAT2 = formDesignerImportLocalVariables["crew_SWAT2"] ?? "";
      String crewSWAT3 = formDesignerImportLocalVariables["crew_SWAT3"] ?? "";
      String crewSWAT4 = formDesignerImportLocalVariables["crew_SWAT4"] ?? "";
      String crewSWAT5 = formDesignerImportLocalVariables["crew_SWAT5"] ?? "";
      String crewSWAT6 = formDesignerImportLocalVariables["crew_SWAT6"] ?? "";
      String crewSWAT7 = formDesignerImportLocalVariables["crew_SWAT7"] ?? "";
      String crewSWAT8 = formDesignerImportLocalVariables["crew_SWAT8"] ?? "";
      String swaTHoist = formDesignerImportLocalVariables["swaT_Hoist"] ?? "";
      String piCFastRope = formDesignerImportLocalVariables["piC_FastRope"] ?? "";
      String swaTFastRope = formDesignerImportLocalVariables["swaT_FastRope"] ?? "";
      int piCNightOps = formDesignerImportLocalVariables["piC_NightOps"] ?? 0;
      String piCHoistOpsWater = formDesignerImportLocalVariables["piC_HoistOpsWater"] ?? "";
      String cCHoistOpsWater = formDesignerImportLocalVariables["cC_HoistOpsWater"] ?? "";
      String rSHoistOpsWater = formDesignerImportLocalVariables["rS_HoistOpsWater"] ?? "";
      String swatAUF = formDesignerImportLocalVariables["swaT_AUF"] ?? "";
      String strLongLineOps = formDesignerImportLocalVariables["longLineOps"] ?? "";
      String strRepelOps = formDesignerImportLocalVariables["repelOps"] ?? "";
      String strTFO1RepelOps = formDesignerImportLocalVariables["tfO1RepelOps"] ?? "";
      String strTFO2RepelOps = formDesignerImportLocalVariables["tfO2RepelOps"] ?? "";
      String strTFO3RepelOps = formDesignerImportLocalVariables["tfO3RepelOps"] ?? "";
      String strTFO4RepelOps = formDesignerImportLocalVariables["tfO4RepelOps"] ?? "";
      String strTFO1CrewChiefOps = formDesignerImportLocalVariables["tfO1CrewChiefOps"] ?? "";
      String strTFO2CrewChiefOps = formDesignerImportLocalVariables["tfO2CrewChiefOps"] ?? "";
      String strTFO3CrewChiefOps = formDesignerImportLocalVariables["tfO3CrewChiefOps"] ?? "";
      String strTFO4CrewChiefOps = formDesignerImportLocalVariables["tfO4CrewChiefOps"] ?? "";
      String strBambiBucketOps = formDesignerImportLocalVariables["bambiBucketOps"] ?? "";

      Map<String, TextEditingController> textFieldControllers = <String, TextEditingController>{};
      RxDouble sizedBoxHeight = 2.0.obs;
      final ScrollController scrollController1 = ScrollController();
      final ScrollController scrollController2 = ScrollController();
      FormWidgets.formDialogBox2(
        dialogTitleIcon: Icons.book_outlined,
        dialogTitle: "Import Close Out Form To Pilot Log Book",
        expandedModal: true,
        actionButtonTitle: formDesignerImportAllData["userList"] == "" ? null : "Save & Complete Import",
        actionButtonIcon: Icons.save,
        onActionButton: () async {
          LoaderHelper.loaderWithGif();
          Keyboard.close();
          String user = "";
          String includeUser = "";
          String flightDate = textFieldControllers["flightDate"]?.text ?? "";
          String aircraftNNumber =
              aircraftDropDownData.isNotEmpty
                  ? aircraftDropDownData
                      .singleWhere((element) => element["aircraft"] == textFieldControllers["aircraftNNumber"]?.text, orElse: () => aircraftDropDownData.first)["id"]
                      .toString()
                  : "0";
          String routeFrom = textFieldControllers["routeFrom"]?.text ?? "";
          String routeTo = textFieldControllers["routeTo"]?.text ?? "";
          String viaPoints = textFieldControllers["viaPoints"]?.text ?? "";
          String remarks = textFieldControllers["remarks"]?.text ?? "";
          String durationOfFlight = "";
          String pilotTimePIC = "";
          String pilotTimeSIC = "";
          String pilotTimeCC = "";
          String pilotTimeSafetyPilot = "";
          String pilotTimeDualReceived = "";
          String pilotTimeSoloReceived = "";
          String dayTakeOffs = "";
          String nightTakeOffs = "";
          String conditionsNight = "";
          String nvgTime = "";
          String nvgOperations = "";
          String approachInstrument = "";
          String approachNonInstrument = "";
          String holds = "";
          String conditionsActualInstrument = "";
          String conditionsSimulatedInstrument = "";
          String far91Time = "";
          String far135Time = "";
          String activity0 = "";
          String activity1 = "";
          String activity2 = "";
          String activity3 = "";
          String activity4 = "";
          String activity5 = "";
          String activity6 = "";
          String activity7 = "";
          String activity8 = "";
          String activity9 = "";
          String activity10 = "";
          String activity11 = "";
          String activity12 = "";
          String activity13 = "";
          String activity14 = "";
          String activity15 = "";
          String activity16 = "";
          String activity17 = "";
          String activity18 = "";
          String activity19 = "";
          String activity20 = "";
          String activity21 = "";
          String activity22 = "";
          String activity23 = "";
          String activity24 = "";
          String activity25 = "";
          String activity26 = "";
          String activity27 = "";
          String activity28 = "";
          String activity29 = "";

          for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++) {
            user = (user != "" ? "$user," : user) + arrUsersInForm(0, usersListing);
            includeUser =
                (includeUser != "" ? "$includeUser," : includeUser) +
                (textFieldControllers["includeUser$usersListing"]?.text ??
                    ""); //?? (systemID == 2 && arrUsersInForm(0, usersListing) != strUserIDCreatingForm.toString() ? "No" : "Yes")
            durationOfFlight =
                (durationOfFlight != "" ? "$durationOfFlight," : durationOfFlight) +
                ((textFieldControllers["durationOfFlight$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["durationOfFlight$usersListing"]?.text ?? "") : "0");
            pilotTimePIC =
                (pilotTimePIC != "" ? "$pilotTimePIC," : pilotTimePIC) +
                ((textFieldControllers["pilotTimePIC$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["pilotTimePIC$usersListing"]?.text ?? "") : "0");
            pilotTimeSIC =
                (pilotTimeSIC != "" ? "$pilotTimeSIC," : pilotTimeSIC) +
                ((textFieldControllers["pilotTimeSIC$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["pilotTimeSIC$usersListing"]?.text ?? "") : "0");
            pilotTimeCC =
                (pilotTimeCC != "" ? "$pilotTimeCC," : pilotTimeCC) +
                ((textFieldControllers["pilotTimeCC$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["pilotTimeCC$usersListing"]?.text ?? "") : "0");
            pilotTimeSafetyPilot =
                (pilotTimeSafetyPilot != "" ? "$pilotTimeSafetyPilot," : pilotTimeSafetyPilot) +
                ((textFieldControllers["pilotTimeSafetyPilot$usersListing"]?.text.isNotEmpty ?? false)
                    ? (textFieldControllers["pilotTimeSafetyPilot$usersListing"]?.text ?? "")
                    : "0");
            pilotTimeDualReceived =
                (pilotTimeDualReceived != "" ? "$pilotTimeDualReceived," : pilotTimeDualReceived) +
                ((textFieldControllers["pilotTimeDualReceived$usersListing"]?.text.isNotEmpty ?? false)
                    ? (textFieldControllers["pilotTimeDualReceived$usersListing"]?.text ?? "")
                    : "0");
            pilotTimeSoloReceived =
                (pilotTimeSoloReceived != "" ? "$pilotTimeSoloReceived," : pilotTimeSoloReceived) +
                ((textFieldControllers["pilotTimeSoloReceived$usersListing"]?.text.isNotEmpty ?? false)
                    ? (textFieldControllers["pilotTimeSoloReceived$usersListing"]?.text ?? "")
                    : "0");
            dayTakeOffs =
                (dayTakeOffs != "" ? "$dayTakeOffs," : dayTakeOffs) +
                ((textFieldControllers["dayTakeOffs$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["dayTakeOffs$usersListing"]?.text ?? "") : "0");
            nightTakeOffs =
                (nightTakeOffs != "" ? "$nightTakeOffs," : nightTakeOffs) +
                ((textFieldControllers["nightTakeOffs$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["nightTakeOffs$usersListing"]?.text ?? "") : "0");
            conditionsNight =
                (conditionsNight != "" ? "$conditionsNight," : conditionsNight) +
                ((textFieldControllers["conditionsNight$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["conditionsNight$usersListing"]?.text ?? "") : "0");
            nvgTime =
                (nvgTime != "" ? "$nvgTime," : nvgTime) +
                ((textFieldControllers["nvgTime$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["nvgTime$usersListing"]?.text ?? "") : "0");
            nvgOperations =
                (nvgOperations != "" ? "$nvgOperations," : nvgOperations) +
                ((textFieldControllers["nvgOperations$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["nvgOperations$usersListing"]?.text ?? "") : "0");
            approachInstrument =
                (approachInstrument != "" ? "$approachInstrument," : approachInstrument) +
                ((textFieldControllers["approachInstrument$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["approachInstrument$usersListing"]?.text ?? "") : "0");
            approachNonInstrument =
                (approachNonInstrument != "" ? "$approachNonInstrument," : approachNonInstrument) +
                ((textFieldControllers["approachNonInstrument$usersListing"]?.text.isNotEmpty ?? false)
                    ? (textFieldControllers["approachNonInstrument$usersListing"]?.text ?? "")
                    : "0");
            holds =
                (holds != "" ? "$holds," : holds) +
                ((textFieldControllers["holds$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["holds$usersListing"]?.text ?? "") : "0");
            conditionsActualInstrument =
                (conditionsActualInstrument != "" ? "$conditionsActualInstrument," : conditionsActualInstrument) +
                ((textFieldControllers["conditionsActualInstrument$usersListing"]?.text.isNotEmpty ?? false)
                    ? (textFieldControllers["conditionsActualInstrument$usersListing"]?.text ?? "")
                    : "0");
            conditionsSimulatedInstrument =
                (conditionsSimulatedInstrument != "" ? "$conditionsSimulatedInstrument," : conditionsSimulatedInstrument) +
                ((textFieldControllers["conditionsSimulatedInstrument$usersListing"]?.text.isNotEmpty ?? false)
                    ? (textFieldControllers["conditionsSimulatedInstrument$usersListing"]?.text ?? "")
                    : "0");
            far91Time =
                (far91Time != "" ? "$far91Time," : far91Time) +
                ((textFieldControllers["far_91_Time$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["far_91_Time$usersListing"]?.text ?? "") : "0");
            far135Time =
                (far135Time != "" ? "$far135Time," : far135Time) +
                ((textFieldControllers["far_135_Time$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["far_135_Time$usersListing"]?.text ?? "") : "0");

            for (var activity in activitySectionData) {
              switch (activity["activityId"].toLowerCase()) {
                case "activity0":
                  activity0 =
                      (activity0 != "" ? "$activity0," : activity0) +
                      ((textFieldControllers["activity0$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity0$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity1":
                  activity1 =
                      (activity1 != "" ? "$activity1," : activity1) +
                      ((textFieldControllers["activity1$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity1$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity2":
                  activity2 =
                      (activity2 != "" ? "$activity2," : activity2) +
                      ((textFieldControllers["activity2$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity2$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity3":
                  activity3 =
                      (activity3 != "" ? "$activity3," : activity3) +
                      ((textFieldControllers["activity3$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity3$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity4":
                  activity4 =
                      (activity4 != "" ? "$activity4," : activity4) +
                      ((textFieldControllers["activity4$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity4$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity5":
                  activity5 =
                      (activity5 != "" ? "$activity5," : activity5) +
                      ((textFieldControllers["activity5$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity5$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity6":
                  activity6 =
                      (activity6 != "" ? "$activity6," : activity6) +
                      ((textFieldControllers["activity6$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity6$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity7":
                  activity7 =
                      (activity7 != "" ? "$activity7," : activity7) +
                      ((textFieldControllers["activity7$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity7$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity8":
                  activity8 =
                      (activity8 != "" ? "$activity8," : activity8) +
                      ((textFieldControllers["activity8$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity8$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity9":
                  activity9 =
                      (activity9 != "" ? "$activity9," : activity9) +
                      ((textFieldControllers["activity9$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity9$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity10":
                  activity10 =
                      (activity10 != "" ? "$activity10," : activity10) +
                      ((textFieldControllers["activity10$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity10$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity11":
                  activity11 =
                      (activity11 != "" ? "$activity11," : activity11) +
                      ((textFieldControllers["activity11$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity11$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity12":
                  activity12 =
                      (activity12 != "" ? "$activity12," : activity12) +
                      ((textFieldControllers["activity12$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity12$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity13":
                  activity13 =
                      (activity13 != "" ? "$activity13," : activity13) +
                      ((textFieldControllers["activity13$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity13$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity14":
                  activity14 =
                      (activity14 != "" ? "$activity14," : activity14) +
                      ((textFieldControllers["activity14$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity14$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity15":
                  activity15 =
                      (activity15 != "" ? "$activity15," : activity15) +
                      ((textFieldControllers["activity15$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity15$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity16":
                  activity16 =
                      (activity16 != "" ? "$activity16," : activity16) +
                      ((textFieldControllers["activity16$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity16$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity17":
                  activity17 =
                      (activity17 != "" ? "$activity17," : activity17) +
                      ((textFieldControllers["activity17$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity17$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity18":
                  activity18 =
                      (activity18 != "" ? "$activity18," : activity18) +
                      ((textFieldControllers["activity18$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity18$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity19":
                  activity19 =
                      (activity19 != "" ? "$activity19," : activity19) +
                      ((textFieldControllers["activity19$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity19$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity20":
                  activity20 =
                      (activity20 != "" ? "$activity20," : activity20) +
                      ((textFieldControllers["activity20$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity20$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity21":
                  activity21 =
                      (activity21 != "" ? "$activity21," : activity21) +
                      ((textFieldControllers["activity21$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity21$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity22":
                  activity22 =
                      (activity22 != "" ? "$activity22," : activity22) +
                      ((textFieldControllers["activity22$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity22$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity23":
                  activity23 =
                      (activity23 != "" ? "$activity23," : activity23) +
                      ((textFieldControllers["activity23$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity23$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity24":
                  activity24 =
                      (activity24 != "" ? "$activity24," : activity24) +
                      ((textFieldControllers["activity24$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity24$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity25":
                  activity25 =
                      (activity25 != "" ? "$activity25," : activity25) +
                      ((textFieldControllers["activity25$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity25$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity26":
                  activity26 =
                      (activity26 != "" ? "$activity26," : activity26) +
                      ((textFieldControllers["activity26$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity26$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity27":
                  activity27 =
                      (activity27 != "" ? "$activity27," : activity27) +
                      ((textFieldControllers["activity27$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity27$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity28":
                  activity28 =
                      (activity28 != "" ? "$activity28," : activity28) +
                      ((textFieldControllers["activity28$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity28$usersListing"]?.text ?? "") : "0");
                  break;
                case "activity29":
                  activity29 =
                      (activity29 != "" ? "$activity29," : activity29) +
                      ((textFieldControllers["activity29$usersListing"]?.text.isNotEmpty ?? false) ? (textFieldControllers["activity29$usersListing"]?.text ?? "") : "0");
                  break;
              }
            }
          }

          Response response = await FormsApiProvider().postFormDesignerImport(
            formId: int.parse(formId),
            user: user,
            includeUser: includeUser,
            flightDate: flightDate,
            aircraftNNumber: aircraftNNumber,
            routeFrom: routeFrom,
            routeTo: routeTo,
            viaPoints: viaPoints,
            remarks: remarks,
            durationOfFlight: durationOfFlight,
            pilotTimePIC: pilotTimePIC,
            pilotTimeSIC: pilotTimeSIC,
            pilotTimeCC: pilotTimeCC,
            pilotTimeSafetyPilot: pilotTimeSafetyPilot,
            pilotTimeDualReceived: pilotTimeDualReceived,
            pilotTimeSoloReceived: pilotTimeSoloReceived,
            dayTakeOffs: dayTakeOffs,
            nightTakeOffs: nightTakeOffs,
            conditionsNight: conditionsNight,
            nvgTime: nvgTime,
            nvgOperations: nvgOperations,
            approachInstrument: approachInstrument,
            approachNonInstrument: approachNonInstrument,
            holds: holds,
            conditionsActualInstrument: conditionsActualInstrument,
            conditionsSimulatedInstrument: conditionsSimulatedInstrument,
            far91Time: far91Time,
            far135Time: far135Time,
            activity0: activity0,
            activity1: activity1,
            activity2: activity2,
            activity3: activity3,
            activity4: activity4,
            activity5: activity5,
            activity6: activity6,
            activity7: activity7,
            activity8: activity8,
            activity9: activity9,
            activity10: activity10,
            activity11: activity11,
            activity12: activity12,
            activity13: activity13,
            activity14: activity14,
            activity15: activity15,
            activity16: activity16,
            activity17: activity17,
            activity18: activity18,
            activity19: activity19,
            activity20: activity20,
            activity21: activity21,
            activity22: activity22,
            activity23: activity23,
            activity24: activity24,
            activity25: activity25,
            activity26: activity26,
            activity27: activity27,
            activity28: activity28,
            activity29: activity29,
          );
          if (response.statusCode == 200) {
            var formDesignerPostData = response.data;
            String userMessage = (formDesignerPostData["userMessage"]?.toString() ?? "").split("||").first.replaceFirst("Flight", " Flight");
            Get.back();
            EasyLoading.dismiss();
            SnackBarHelper.openSnackBar(title: "Import Into Pilot Log Book", message: userMessage);
          }
          EasyLoading.dismiss();
        },
        child:
            formDesignerImportAllData["userList"] == ""
                ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Unable To Locate Any Users On This Form. Please Verify Your Form Information And Re-Import This Close Out.",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
                : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width > 480 ? 320 : 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Obx(() {
                                  GlobalKey userListHeightKey = GlobalKey();
                                  arrUsersInFormRows == 0
                                      ? WidgetConstant.widgetSize(userListHeightKey).then((value) => FormDesignerJs.userListHeight.value = value?.height ?? 0.0)
                                      : null;
                                  return Container(
                                    key: arrUsersInFormRows == 0 ? userListHeightKey : null,
                                    alignment: Alignment.center,
                                    height: (userListHeight.value != 0.0 && arrUsersInFormRows != 0) ? userListHeight.value - 3 : null,
                                    margin: const EdgeInsets.only(bottom: 3.0),
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
                                    child: const Text("Create Log Entry User?", style: TextStyle(color: Colors.white)),
                                  );
                                }),
                                const FixedSubSections(
                                  sectionName: "Demographics",
                                  sectionData: [
                                    {"name": "Flight Date", "height": 70.0},
                                    {"name": "Aircraft", "height": 70.0},
                                    {"name": "Airports", "height": 190.0},
                                    {"name": "Remarks", "height": 150.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "Times",
                                  sectionData: [
                                    {"name": "Duration Of Flight", "height": 70.0},
                                    {"name": "PIC Time", "height": 70.0},
                                    {"name": "SIC Time", "height": 70.0},
                                    {"name": "Cross Country Time", "height": 70.0},
                                    {"name": "Instructor Time (CFI)", "height": 70.0},
                                    {"name": "Dual Time Received", "height": 70.0},
                                    {"name": "Solo Time Received", "height": 70.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "Day",
                                  sectionData: [
                                    {"name": "Take Offs/Ldgs", "height": 70.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "Night",
                                  sectionData: [
                                    {"name": "Take Offs/Ldgs", "height": 70.0},
                                    {"name": "Flight Time", "height": 70.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "NVG",
                                  sectionData: [
                                    {"name": "NVG Time", "height": 70.0},
                                    {"name": "NVG Operations", "height": 70.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "Approaches",
                                  sectionData: [
                                    {"name": "Precision", "height": 70.0},
                                    {"name": "Non-Precision", "height": 70.0},
                                    {"name": "Holds", "height": 70.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "Conditions",
                                  sectionData: [
                                    {"name": "Actual Instrument", "height": 70.0},
                                    {"name": "Simulated Instrument", "height": 70.0},
                                  ],
                                ),
                                const FixedSubSections(
                                  sectionName: "FAR Part",
                                  sectionData: [
                                    {"name": "91 Time", "height": 70.0},
                                    {"name": "135 Time", "height": 70.0},
                                  ],
                                ),
                                FixedSubSections(position: "last", sectionName: "Activities", sectionData: activitySectionData),
                              ],
                            ),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              controller:
                                  scrollController1..addListener(() {
                                    scrollController2.jumpTo(scrollController1.offset);
                                  }),
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: arrUsersInFormRows > 2 ? 180.0 * arrUsersInFormRows : 420),
                                child: Column(
                                  children: [
                                    //User List with Include User
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: ScrollableUserList(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              arrUsersInForm: arrUsersInForm(1, usersListing),
                                              controller: textFieldControllers.putIfAbsent(
                                                "includeUser$usersListing",
                                                () => TextEditingController(
                                                  text: systemID == 2 && arrUsersInForm(0, usersListing) != strUserIDCreatingForm.toString() ? "No" : "Yes",
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Demographics with Flight Date, Aircraft, Airports, Remarks
                                    //Flight Date
                                    Obx(() {
                                      return Container(
                                        height: 70,
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                          top:
                                              arrUsersInFormRows == 0
                                                  ? Get.width > 480
                                                      ? userListHeight.value
                                                      : userListHeight.value + sectionHeight.value
                                                  : sectionHeight.value,
                                          left: 3.0,
                                        ),
                                        color: ColorConstants.primary.withValues(alpha: 0.3),
                                        child: SizedBox(
                                          width: 200,
                                          child: Center(
                                            child: DynamicDateField(
                                              req: false,
                                              fieldName: 'flightDate',
                                              dateType: "FlightDate_Older",
                                              controller: textFieldControllers.putIfAbsent("flightDate", () => TextEditingController(text: strFlightDate)),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    //Aircraft
                                    Container(
                                      height: 70,
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 3.0),
                                      color: ColorConstants.primary.withValues(alpha: 0.5),
                                      child: DynamicDropDown(
                                        enableSearch: false,
                                        fieldName: "aircraftNNumber",
                                        dropDownKey: 'aircraft',
                                        dropDownController: textFieldControllers.putIfAbsent("aircraftNNumber", () => TextEditingController(text: strAircraft)),
                                        dropDownData: aircraftDropDownData,
                                      ),
                                    ),
                                    //Airports
                                    Container(
                                      height: 190,
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 3.0),
                                      color: ColorConstants.primary.withValues(alpha: 0.3),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 420,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: DynamicTextField(
                                                    title: "From",
                                                    req: false,
                                                    fieldName: "routeFrom",
                                                    hintText: "Airport Code",
                                                    controller: textFieldControllers.putIfAbsent("routeFrom", () => TextEditingController(text: strRouteFrom)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0),
                                                  child: IconButton(
                                                    icon: const Icon(Icons.forward),
                                                    visualDensity: VisualDensity.compact,
                                                    padding: EdgeInsets.zero,
                                                    iconSize: 22.0,
                                                    color: ColorConstants.button,
                                                    splashRadius: 15.0,
                                                    onPressed: () {
                                                      textFieldControllers["routeTo"]?.text = textFieldControllers["routeFrom"]?.text ?? "";
                                                      Keyboard.close();
                                                    },
                                                  ),
                                                ),
                                                Flexible(
                                                  child: DynamicTextField(
                                                    title: "To",
                                                    req: false,
                                                    fieldName: "routeTo",
                                                    hintText: "Airport Code",
                                                    controller: textFieldControllers.putIfAbsent("routeTo", () => TextEditingController(text: strRouteTo)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 420,
                                            child: DynamicTextField(
                                              title: "Via",
                                              req: false,
                                              fieldName: "viaPoints",
                                              hintText: "Airport Codes",
                                              controller: textFieldControllers.putIfAbsent("viaPoints", () => TextEditingController(text: strViaPoints)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Remarks
                                    Container(
                                      height: 150,
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 3.0),
                                      color: ColorConstants.primary.withValues(alpha: 0.5),
                                      child: SizedBox(
                                        width: 420,
                                        child: DynamicTextField(
                                          req: false,
                                          fieldName: "remarks",
                                          hintText: "Flight Remarks",
                                          dataType: "remarks",
                                          controller: textFieldControllers.putIfAbsent("remarks", () => TextEditingController(text: strRemarks)),
                                        ),
                                      ),
                                    ),
                                    //Times with Duration Of Flight, PIC Time, SIC Time, Cross Country Time, Instructor Time (CFI), Dual Time Received, Solo Time Received
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //Duration Of Flight
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "durationOfFlight-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("durationOfFlight$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["durationOfFlight${usersListing + 1}"]?.text =
                                                          textFieldControllers["durationOfFlight$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = strDurationOfFlight.toString();
                                                switch (systemID) {
                                                  case 28: //'TEXAS DPS' '-- Email Bryan Kolb 2020-08-18'
                                                    if (arrUsersInForm(0, usersListing).trim() != strPilotID.toString().trim() &&
                                                        arrUsersInForm(0, usersListing).trim() != strCoPilotID.toString().trim()) {
                                                      strValue = "0";
                                                    }
                                                    break;
                                                  case 199: //'USDA'
                                                    if (arrUsersInForm(0, usersListing).trim() != strCrew1.trim()) strValue = strCrew1Hours;
                                                    if (arrUsersInForm(0, usersListing).trim() != strCrew2.trim()) strValue = strCrew2Hours;
                                                    if (arrUsersInForm(0, usersListing).trim() != strCrew3.trim()) strValue = strCrew3Hours;
                                                    if (arrUsersInForm(0, usersListing).trim() != strCrew4.trim()) strValue = strCrew4Hours;
                                                    if (arrUsersInForm(0, usersListing).trim() != strCrew5.trim()) strValue = strCrew5Hours;
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //PIC Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "pilotTimePIC-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("pilotTimePIC$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["pilotTimePIC${usersListing + 1}"]?.text = textFieldControllers["pilotTimePIC$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "";
                                                //'---------------- PIC TIME FORCED TO SPECIFIC FIELD --------------------'
                                                switch (systemID) {
                                                  case 2 || 3: //'HCSO & SAPD'
                                                    if (strUserIDCreatingForm.toString().trim() == arrUsersInForm(0, usersListing).trim()) strValue = strPICTime.toString();
                                                    break;
                                                  case 5: //'MDFR'
                                                    if (bool.parse(arrUsersInForm(5, usersListing)) &&
                                                        strPICTimeUsed == -1 &&
                                                        arrUsersInForm(0, usersListing).trim() != strPilotID.toString().trim()) {
                                                      strPICTimeUsed = usersListing;
                                                      strValue = strPICTime.toString();
                                                    }
                                                    break;
                                                  case 18: //'--Maricopa'
                                                    if (piCId.trim() == arrUsersInForm(1, usersListing).trim()) strValue = piCPicTime;
                                                    break;
                                                  case 28: //'--TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotPIC;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotPICTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = strCoPilotPICTime;
                                                    break;
                                                  case 46: //'AZDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCPilot1.trim()) strValue = picPIC;
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotPicTime;
                                                    break;
                                                  case 59: //'LVPD'
                                                    if (strUserIDCreatingForm.toString() == arrUsersInForm(0, usersListing).trim()) strValue = strPICTime.toString();
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strPICTimePic;
                                                    break;
                                                  case 85: //'Utah'
                                                    if (bool.parse(arrUsersInForm(5, usersListing)) &&
                                                        strPICTimeUsed == -1 &&
                                                        arrUsersInForm(0, usersListing).trim() == piC1ID.toString().trim()) {
                                                      strPICTimeUsed = usersListing;
                                                      strValue = strPICTime.toString();
                                                    }

                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot1.trim()) strValue = trNPilotPIC1;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot2.trim()) strValue = trNPilotPIC2;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot3.trim()) strValue = trNPilotPIC3;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot4.trim()) strValue = trNPilotPIC4;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot5.trim()) strValue = trNPilotPIC5;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot6.trim()) strValue = trNPilotPIC6;
                                                    break;
                                                  case 91: //'Atlanta
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) {
                                                      strPICTimeUsed = usersListing;
                                                      strValue = picPIC;
                                                    }
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC2PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3PIC;
                                                    break;
                                                  case 101: //'Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) {
                                                      strPICTimeUsed = usersListing;
                                                      strValue = picPIC;
                                                    }
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC2PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3PIC;
                                                    break;
                                                  case 104: //'Orange Fire'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCUser.trim()) strValue = piCPICTime;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCPICTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotPICTime;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (arrUsersInForm(0, usersListing).trim() == crewPIC1.trim()) strValue = piCPICTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == crewPIC2.trim()) strValue = piCPICTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == crewPIC3.trim()) strValue = piCPICTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == crewPIC4.trim()) strValue = piCPICTime;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strPIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strPIC;
                                                    break;
                                                  default:
                                                    if (bool.parse(arrUsersInForm(5, usersListing)) &&
                                                        strPICTimeUsed == -1 &&
                                                        ((strFirstUserFieldID == 0) || (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()))) {
                                                      strPICTimeUsed = usersListing;
                                                      strValue = strPICTime.toString();
                                                    }
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //SIC Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "pilotTimeSIC-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("pilotTimeSIC$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["pilotTimeSIC${usersListing + 1}"]?.text = textFieldControllers["pilotTimeSIC$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "";
                                                switch (systemID) {
                                                  case 2: //'SAPD - Per Trollinger at ALEA don't give sic time to Observer
                                                    break;
                                                  case 3: //'HCSO
                                                    if (strUserIDCreatingForm.toString().trim() != arrUsersInForm(0, usersListing).trim()) strValue = strSICTime.toString();
                                                    break;
                                                  case 18: //'--Maricopa'
                                                    if (siCId.trim() == arrUsersInForm(0, usersListing).trim()) strValue = siCSicTime;
                                                    break;
                                                  case 28: //'--TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotSIC;
                                                    break;
                                                  case 46: //'AZDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCPilot2.trim()) strValue = sicSIC;
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotSicTime;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strSICTimeSic;
                                                    break;
                                                  case 85: //'Utah'
                                                    if (arrUsersInForm(0, usersListing).trim() == piC2ID.toString().trim()) strValue = strSICTime.toString();
                                                    break;
                                                  case 91: //'Atlanta
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = "0";
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1PIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC2PIC;
                                                    break;
                                                  case 104: //'Orange Fire'
                                                    if (arrUsersInForm(0, usersListing).trim() == siCUser.trim()) strValue = siCSICTime;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    // 'Nada'
                                                    break;
                                                  default:
                                                    if (bool.parse(arrUsersInForm(5, usersListing)) &&
                                                        strSICTimeUsed == -1 &&
                                                        strPICTimeUsed != -1 &&
                                                        strPICTimeUsed != usersListing) {
                                                      //'Only show sic after PIC time has been used and PIC has not been used by this person
                                                      strSICTimeUsed = usersListing;
                                                      strValue = strSICTime.toString();
                                                    }
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Cross Country Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "pilotTimeCC-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("pilotTimeCC$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () => textFieldControllers["pilotTimeCC${usersListing + 1}"]?.text = textFieldControllers["pilotTimeCC$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotXCountry;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotXCountry;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strXCountryPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strXCountrySic;
                                                    break;
                                                  case 86: //'TX Parks And Wildlife'
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strTxWildPilotXCountryTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strTxWildCoPilotXCountryTime;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picXCountry;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1XCountry;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1XCountry;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCCrossCountryTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotCrossCountryTime;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCXCountry;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCXCountry;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCXCountry;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCXCountry;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strXCountry;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strXCountry;
                                                    break;
                                                  default:
                                                    if (strCrossCountry > 0) strValue = strCrossCountry.toString();
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Instructor Time (CFI)
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "pilotTimeSafetyPilot-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("pilotTimeSafetyPilot$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["pilotTimeSafetyPilot${usersListing + 1}"]?.text =
                                                          textFieldControllers["pilotTimeSafetyPilot$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "";
                                                switch (systemID) {
                                                  case 2: //'SAPD'
                                                    switch (arrUsersInForm(0, usersListing)) {
                                                      case "85" || "93" || "97" || "109": //'SAPD:  85=Torres 93=Brittan 97=Brittan #2 109=Huckabee
                                                        if (strUserIDCreatingForm.toString().trim() != arrUsersInForm(0, usersListing).trim()) {
                                                          strValue = strPICTime.toString(); //'Only give them CFI time if they are not the PIC
                                                        }
                                                        break;
                                                    }
                                                    break;
                                                  case 5: //'MDFR'
                                                    if (bool.parse(arrUsersInForm(5, usersListing)) &&
                                                        strPICTimeUsed != usersListing &&
                                                        arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) {
                                                      //'Only show sic after PIC time has been used and PIC has not been used by this person
                                                      strSICTimeUsed = usersListing;
                                                      strValue = strSICTime.toString();
                                                    }
                                                    break;
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim() && coPilotInstructor == "on") {
                                                      strValue = coPilotSIC;
                                                    }
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCInstructorTimeCFI;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotInstructorTimeCFI;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim() && strInstructorTime == "on") strValue = strPIC;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strXCountry;
                                                    break;
                                                }

                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Dual Time Received
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "pilotTimeDualReceived-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("pilotTimeDualReceived$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["pilotTimeDualReceived${usersListing + 1}"]?.text =
                                                          textFieldControllers["pilotTimeDualReceived$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "";
                                                switch (systemID) {
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCDualTimeReceived;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotDualTimeReceived;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Solo Time Received
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "pilotTimeSoloReceived-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("pilotTimeSoloReceived$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["pilotTimeSoloReceived${usersListing + 1}"]?.text =
                                                          textFieldControllers["pilotTimeSoloReceived$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "";
                                                switch (systemID) {
                                                  case 86: //'TX Parks And Wildlife'
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strTxWildPilotSoloTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strTxWildCoPilotSoloTime;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCSoloTimeReceived;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotSoloTimeReceived;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCSolo;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCSolo;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCSolo;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCSolo;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strSolo;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strSolo;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Day with Take Offs/Ldgs
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //Take Offs/Ldgs
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "dayTakeOffs-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("dayTakeOffs$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () => textFieldControllers["dayTakeOffs${usersListing + 1}"]?.text = textFieldControllers["dayTakeOffs$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotDayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotDayLandings;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    strValue = "0";
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotDayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = strCoPilotDayLandings;
                                                    break;
                                                  case 46: //'AZDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCPilot2.trim()) {
                                                      strValue = siCDayLandings;
                                                    } else {
                                                      strValue = piCDayLandings;
                                                    }
                                                    break;
                                                  case 57: //'NJSP'
                                                    strValue = "0";
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotDayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotDayLandings;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strDayLandingsPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strDayLandingsSic;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picDayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1DayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1DayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1DayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2DayLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3DayLandings;
                                                    break;
                                                  case 104: //'Orange Fire'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCUser.trim()) strValue = piCDayTakeOffsLdgs;
                                                    if (arrUsersInForm(0, usersListing).trim() == siCUser.trim()) strValue = siCDayTakeOffsLdgs;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCDayTakeOffsLdgs;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotDayTakeOffsLdgs;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCDayLandings;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCDayLandings;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCDayLandings;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCDayLandings;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strDayLandings.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strDayLandings.toString();
                                                    break;
                                                  default:
                                                    strValue = strDayLandings.toString();
                                                    break;
                                                }
                                                return (num.tryParse(strValue) ?? 0).toInt();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Night with Take Offs/Ldgs, Flight Time
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //Take Offs/Ldgs
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "nightTakeOffs-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("nightTakeOffs$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["nightTakeOffs${usersListing + 1}"]?.text =
                                                          textFieldControllers["nightTakeOffs$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotNightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotNightLandings;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotNightFlightLandings.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) {
                                                      strValue = strCoPilotNightFlightLandings.toString();
                                                    }
                                                    break;
                                                  case 46: //'AZDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCPilot2.trim()) {
                                                      strValue = siCNightLandings;
                                                    } else {
                                                      strValue = piCNightLandings;
                                                    }
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotNightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotNightLandings;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strNightLandingsPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strNightLandingsSic;
                                                    break;
                                                  case 86: //'TX Parks And Wildlife'
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strTxWildPilotNightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strTxWildCoPilotNightLandings;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picNightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1NightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1NightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1NightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2NightLandings;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3NightLandings;
                                                    break;
                                                  case 104: //'Orange Fire'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCUser.trim()) strValue = piCNightTakeOffsLdgs;
                                                    if (arrUsersInForm(0, usersListing).trim() == siCUser.trim()) strValue = siCNightTakeOffsLdgs;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCNightTakeOffsLdgs;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotNightTakeOffsLdgs;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCNightLandings;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCNightLandings;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCNightLandings;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCNightLandings;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strNightLandings.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strNightLandings.toString();
                                                  default:
                                                    strValue = strNightLandings.toString();
                                                    break;
                                                }
                                                return (num.tryParse(strValue) ?? 0).toInt();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Flight Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "conditionsNight-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("conditionsNight$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["conditionsNight${usersListing + 1}"]?.text =
                                                          textFieldControllers["conditionsNight$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotNightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotNightFlightTime;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotNightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = strCoPilotNightFlightTime;
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotNightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotNightFlightTime;
                                                    break;
                                                  case 61: //'Sable'
                                                    if (arrUsersInForm(0, usersListing).trim() == strCrew1.trim()) strValue = strNightFlightTimeCrew1;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCrew2.trim()) strValue = strNightFlightTimeCrew2;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCrew3.trim()) strValue = strNightFlightTimeCrew3;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCrew4.trim()) strValue = strNightFlightTimeCrew4;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strNightFlightTimePic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strNightFlightTimeSic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo1.trim()) strValue = strNightFlightTimeTfo1;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo2.trim()) strValue = strNightFlightTimeTfo2;
                                                    break;
                                                  case 85: //'Utah'
                                                    if (arrUsersInForm(0, usersListing).trim() == hoistOpHoistOperator1.trim()) strValue = hoistOpNightTime1;
                                                    if (arrUsersInForm(0, usersListing).trim() == hoistOpHoistOperator2.trim()) strValue = hoistOpNightTime2;
                                                    if (arrUsersInForm(0, usersListing).trim() == hoistOpHoistOperator3.trim()) strValue = hoistOpNightTime3;
                                                    if (arrUsersInForm(0, usersListing).trim() == hoistOpHoistOperator4.trim()) strValue = hoistOpNightTime4;
                                                    if (arrUsersInForm(0, usersListing).trim() == hoistOpHoistOperator5.trim()) strValue = hoistOpNightTime5;
                                                    if (arrUsersInForm(0, usersListing).trim() == hoistOpHoistOperator6.trim()) strValue = hoistOpNightTime6;

                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist1.trim()) strValue = rescueNightTime1;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist2.trim()) strValue = rescueNightTime2;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist3.trim()) strValue = rescueNightTime3;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist4.trim()) strValue = rescueNightTime4;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist5.trim()) strValue = rescueNightTime5;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist6.trim()) strValue = rescueNightTime6;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist7.trim()) strValue = rescueNightTime7;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist8.trim()) strValue = rescueNightTime8;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist9.trim()) strValue = rescueNightTime9;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist10.trim()) strValue = rescueNightTime10;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist11.trim()) strValue = rescueNightTime11;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist12.trim()) strValue = rescueNightTime12;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist13.trim()) strValue = rescueNightTime13;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist14.trim()) strValue = rescueNightTime14;
                                                    if (arrUsersInForm(0, usersListing).trim() == rescueRescueSpecialist15.trim()) strValue = rescueNightTime15;
                                                    break;
                                                  case 86: //'TX Parks And Wildlife'
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strTxWildPilotNightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strTxWildCoPilotNightFlightTime;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picNightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1NightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1NightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1NightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2NightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3NightFlightTime;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCNightFlightTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotNightFlightTime;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCNightFlightTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCNightFlightTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCNightFlightTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCNightFlightTime;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strNightFlightTime.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strNightFlightTime.toString();
                                                  default:
                                                    strValue = strNightFlightTime.toString();
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //NVG with NVG Time, NVG Operations
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //NVG Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "nvgTime-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("nvgTime$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () => textFieldControllers["nvgTime${usersListing + 1}"]?.text = textFieldControllers["nvgTime$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfo1TFO.trim()) strValue = tfo1NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfo2TFO.trim()) strValue = tfo2NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfo3TFO.trim()) strValue = tfo3NVGTime;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotNVGTIME;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = strCoPilotNVGTIME;
                                                    break;
                                                  case 46: //'AZDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCPilot2.trim()) {
                                                      strValue = siCNVGTime;
                                                    } else {
                                                      strValue = piCNVGTime;
                                                    }
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotNvgTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotNvgTime;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strNVGTimePic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strNVGTimeSic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo1.trim()) strValue = strNVGTimeTfo1;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo2.trim()) strValue = strNVGTimeTfo2;
                                                    break;
                                                  case 85: //'Utah'
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot1.trim()) strValue = trNPilotNVGTime1;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot2.trim()) strValue = trNPilotNVGTime2;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot3.trim()) strValue = trNPilotNVGTime3;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot4.trim()) strValue = trNPilotNVGTime4;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot5.trim()) strValue = trNPilotNVGTime5;
                                                    if (arrUsersInForm(0, usersListing).trim() == trNPilotPilot6.trim()) strValue = trNPilotNVGTime6;
                                                    break;
                                                  case 86: //'TX Parks And Wildlife'
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strTxWildPilotNvgTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strTxWildCoPilotNvgTime;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3NVGTime;
                                                    break;
                                                  case 104: //'Orange Fire'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCUser.trim()) strValue = piCNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == siCUser.trim()) strValue = siCNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC1User.trim()) strValue = cC1NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC2User.trim()) strValue = cC2NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC3User.trim()) strValue = cC3NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC4User.trim()) strValue = cC4NVGTime;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotNVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID1.trim()) strValue = specNVGTime1;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID2.trim()) strValue = specNVGTime2;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID3.trim()) strValue = specNVGTime3;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID4.trim()) strValue = specNVGTime4;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID5.trim()) strValue = specNVGTime5;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID6.trim()) strValue = specNVGTime6;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID7.trim()) strValue = specNVGTime7;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID8.trim()) strValue = specNVGTime8;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID9.trim()) strValue = specNVGTime9;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID10.trim()) strValue = specNVGTime10;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF1)) strValue = cCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF2)) strValue = cCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF3)) strValue = cCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF4)) strValue = cCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF5)) strValue = cCNVGTime;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF6)) strValue = cCNVGTime;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strNVGTime.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strNVGTime.toString();

                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO1.toString().trim()) strValue = strTFO1NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO2.toString().trim()) strValue = strTFO2NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO3.toString().trim()) strValue = strTFO3NVGTime;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO4.toString().trim()) strValue = strTFO4NVGTime;
                                                  default:
                                                    strValue = arrUsersInForm(3, usersListing).trim();
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //NVG Operations
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "nvgOperations-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("nvgOperations$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["nvgOperations${usersListing + 1}"]?.text =
                                                          textFieldControllers["nvgOperations$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotNVGOPS;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotNVGOPS;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfo1TFO.trim()) strValue = tfo1NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfo2TFO.trim()) strValue = tfo2NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfo3TFO.trim()) strValue = tfo3NVGOps;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotNVGO.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = strCoPilotNVGO.toString();
                                                    break;
                                                  case 46: //'AZDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCPilot2.trim()) {
                                                      strValue = siCNVGOperations;
                                                    } else {
                                                      strValue = piCNVGOperations;
                                                    }
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotNvgOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotNvgOperations;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strNVGEventPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strNVGEventSic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo1.trim()) strValue = strNVGEventTfo1;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo2.trim()) strValue = strNVGEventTfo2;
                                                    break;
                                                  case 86: //'TX Wildlife'
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strTxWildPilotNvgOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strTxWildCoPilotNvgOperations;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picNVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO1ID.trim()) strValue = tfO1NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO2ID.trim()) strValue = tfO2NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == tfO3ID.trim()) strValue = tfO3NVGOps;
                                                    break;
                                                  case 93: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == picId.trim()) strValue = picNvgOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == sicId.trim()) strValue = sicNvgOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == medic1Id.trim()) strValue = medic1NvgOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == medic2Id.trim()) strValue = medic2NvgOps;
                                                    break;
                                                  case 104: //'Orange Fire'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCUser.trim()) strValue = piCNVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == siCUser.trim()) strValue = siCNVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC1User.trim()) strValue = cC1NVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC2User.trim()) strValue = cC2NVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC3User.trim()) strValue = cC3NVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == cC4User.trim()) strValue = cC4NVGOperations;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCNVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotNVGOperations;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID1.trim()) strValue = specNVGOperations1;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID2.trim()) strValue = specNVGOperations2;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID3.trim()) strValue = specNVGOperations3;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID4.trim()) strValue = specNVGOperations4;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID5.trim()) strValue = specNVGOperations5;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID6.trim()) strValue = specNVGOperations6;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID7.trim()) strValue = specNVGOperations7;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID8.trim()) strValue = specNVGOperations8;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID9.trim()) strValue = specNVGOperations9;
                                                    if (arrUsersInForm(0, usersListing).trim() == specID10.trim()) strValue = specNVGOperations10;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF1)) strValue = cCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF2)) strValue = cCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF3)) strValue = cCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF4)) strValue = cCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF5)) strValue = cCNvgOps;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewCREWCHIEF6)) strValue = cCNvgOps;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strNVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strNVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO1.toString().trim()) strValue = strTFO1NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO2.toString().trim()) strValue = strTFO2NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO3.toString().trim()) strValue = strTFO3NVGOps;
                                                    if (arrUsersInForm(0, usersListing).trim() == strTFO4.toString().trim()) strValue = strTFO4NVGOps;
                                                    break;
                                                  default:
                                                    strValue = arrUsersInForm(4, usersListing).trim();
                                                    break;
                                                }
                                                return (num.tryParse(strValue) ?? 0).toInt();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Approaches with Precision, Non-Precision, Holds
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //Precision
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "approachInstrument-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("approachInstrument$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["approachInstrument${usersListing + 1}"]?.text =
                                                          textFieldControllers["approachInstrument$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotPrecisionApproaches;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotPrecisionApproaches;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotInstrumentApproach.toString();
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) {
                                                      strValue = strCoPilotInstrumentApproach.toString();
                                                    }
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotApproaches;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotApproaches;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strPrecisionApproachesPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strPrecisionApproachesSic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo1.trim()) strValue = strPrecisionApproachesTfo1;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo2.trim()) strValue = strPrecisionApproachesTfo2;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) {
                                                      strValue = (int.parse(picPrecisionApproaches) + int.parse(picNONPrecisionApproaches)).toString();
                                                    }
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) {
                                                      strValue = (int.parse(siC1PrecisionApproaches) + int.parse(siC1NONPrecisionApproaches)).toString();
                                                    }
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) {
                                                      strValue = (int.parse(siC1PrecisionApproaches) + int.parse(siC1NONPrecisionApproaches)).toString();
                                                    }
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCApproachesInstrument;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotApproachesInstrument;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCPrecisionApproaches;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCPrecisionApproaches;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCPrecisionApproaches;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCPrecisionApproaches;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strPrecisionApproaches;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strPrecisionApproaches;
                                                    break;
                                                  default:
                                                    if (bool.parse(arrUsersInForm(5, usersListing))) strValue = strApproachInstrument.toString();
                                                    break;
                                                }
                                                return (num.tryParse(strValue) ?? 0).toInt();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Non-Precision
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "approachNonInstrument-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("approachNonInstrument$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["approachNonInstrument${usersListing + 1}"]?.text =
                                                          textFieldControllers["approachNonInstrument$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotNONPrecisionApproaches;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotNONPrecisionApproaches;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strNONPrecisionApproachesPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strNONPrecisionApproachesSic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo1.trim()) strValue = strNONPrecisionApproachesTfo1;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsTfo2.trim()) strValue = strNONPrecisionApproachesTfo2;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCApproachesNonInstrument;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotApproachesNonInstrument;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCNONPrecisionApproaches;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCNONPrecisionApproaches;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCNONPrecisionApproaches;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCNONPrecisionApproaches;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strNONPrecisionApproaches;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strNONPrecisionApproaches;
                                                    break;
                                                }
                                                return (num.tryParse(strValue) ?? 0).toInt();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Holds
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "holds-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("holds$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward: () => textFieldControllers["holds${usersListing + 1}"]?.text = textFieldControllers["holds$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotHold;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotHold;
                                                    break;
                                                  case 41: //'Pinellas'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = strPilotHold;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = strCoPilotHold;
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotHolds;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotHolds;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = piCHold;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1Hold;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1Hold;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCApproachesHolds;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotApproachesHolds;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCHold;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCHold;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCHold;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCHold;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strHold;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strHold;
                                                    break;
                                                  default:
                                                    if (bool.parse(arrUsersInForm(5, usersListing))) {
                                                      strValue = strHold; //strHolds; //Not Initialized in the formDesignerImportLocalVariables of Classic ASP
                                                    }
                                                    break;
                                                }
                                                return (num.tryParse(strValue) ?? 0).toInt();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Conditions with Actual Instrument, Simulated Instrument
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //Actual Instrument
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "conditionsActualInstrument-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("conditionsActualInstrument$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["conditionsActualInstrument${usersListing + 1}"]?.text =
                                                          textFieldControllers["conditionsActualInstrument$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotIFRAct;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotIFRAct;
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotApproachesActual;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotApproachesActual;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strIFRActPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strIFRActSic;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picIFRAct;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1IFRAct;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1IFRAct;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCConditionsActualInstrument;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotConditionsActualInstrument;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCIfrAct;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCIfrAct;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCIfrAct;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCIfrAct;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strIFRAct;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strIFRAct;
                                                    break;
                                                  default:
                                                    if (bool.parse(arrUsersInForm(5, usersListing))) strValue = strConditionsActualInstrument.toString();
                                                    break;
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Simulated Instrument
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "conditionsSimulatedInstrument-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("conditionsSimulatedInstrument$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["conditionsSimulatedInstrument${usersListing + 1}"]?.text =
                                                          textFieldControllers["conditionsSimulatedInstrument$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                String strValue = "0";
                                                switch (systemID) {
                                                  case 28: //'TXDPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotIFRSim;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotIFRSim;
                                                    break;
                                                  case 57: //'NJSP'
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspPilotId.toString().trim()) strValue = strNjspPilotApproachesSimulated;
                                                    if (arrUsersInForm(0, usersListing).trim() == strNjspCoPilotId.toString().trim()) strValue = strNjspCoPilotApproachesSimulated;
                                                    break;
                                                  case 63: //'EPS'
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsPic.trim()) strValue = strIFRSimPic;
                                                    if (arrUsersInForm(0, usersListing).trim() == strEpsSic.trim()) strValue = strIFRSimSic;
                                                    break;
                                                  case 91 || 101: //'Atlanta + Nashville
                                                    if (arrUsersInForm(0, usersListing).trim() == piCID.trim()) strValue = picIFRSim;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC1ID.trim()) strValue = siC1IFRSim;
                                                    if (arrUsersInForm(0, usersListing).trim() == siC2ID.trim()) strValue = siC1IFRSim;
                                                    break;
                                                  case 106: //'-- Nashville HP --'
                                                    if (arrUsersInForm(0, usersListing).trim() == piCId.trim()) strValue = piCConditionsSimulatedInstrument;
                                                    if (arrUsersInForm(0, usersListing).trim() == coPilotId.trim()) strValue = coPilotConditionsSimulatedInstrument;
                                                    break;
                                                  case 107: //'-- Seminole --'
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC1)) strValue = piCIfrSim;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC2)) strValue = piCIfrSim;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC3)) strValue = piCIfrSim;
                                                    if (int.parse(arrUsersInForm(0, usersListing)) == int.parse(crewPIC4)) strValue = piCIfrSim;
                                                    break;
                                                  case 117: //'-- Georgia DNR --'
                                                    if (arrUsersInForm(0, usersListing).trim() == strPilot.toString().trim()) strValue = strIFRSim;
                                                    if (arrUsersInForm(0, usersListing).trim() == strCoPilot.toString().trim()) strValue = strIFRSim;
                                                    break;
                                                  default:
                                                    if (bool.parse(arrUsersInForm(5, usersListing))) strValue = strConditionsSimulatedInstrument.toString();
                                                }
                                                return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //FAR Part with 91 Time, 135 Time
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    //91 Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "far_91_Time-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("far_91_Time$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.3,
                                              onTapForward:
                                                  () => textFieldControllers["far_91_Time${usersListing + 1}"]?.text = textFieldControllers["far_91_Time$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                double strValue = 0;
                                                if (strFAR91Time > 0) strValue = strFAR91Time;
                                                return strValue.toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //135 Time
                                    Row(
                                      children: [
                                        for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                          Flexible(
                                            child: DataInputField(
                                              usersListing: usersListing,
                                              arrUsersInFormRows: arrUsersInFormRows,
                                              fieldName: "far_135_Time-$usersListing",
                                              controller: textFieldControllers.putIfAbsent("far_135_Time$usersListing", () => TextEditingController()),
                                              colorOpacity: 0.5,
                                              onTapForward:
                                                  () =>
                                                      textFieldControllers["far_135_Time${usersListing + 1}"]?.text = textFieldControllers["far_135_Time$usersListing"]?.text ?? "",
                                              setConditions: () {
                                                double strValue = 0;
                                                if (strFAR135Time > 0) strValue = strFAR135Time;
                                                return strValue.toPrecision(1);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    //Activities
                                    Obx(() => SizedBox(height: Get.width > 480 ? sizedBoxHeight.value : sectionHeight.value + 2.0)),
                                    for (int i = 0; i < activitySectionData.length; i++)
                                      Row(
                                        children: [
                                          for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                            Flexible(
                                              child: DataInputField(
                                                usersListing: usersListing,
                                                arrUsersInFormRows: arrUsersInFormRows,
                                                fieldName: "${activitySectionData[i]["activityId"]}-$usersListing",
                                                controller: textFieldControllers.putIfAbsent("${activitySectionData[i]["activityId"]}$usersListing", () => TextEditingController()),
                                                colorOpacity: i % 2 == 0 ? 0.3 : 0.5,
                                                borderRadius:
                                                    i == activitySectionData.length - 1 && usersListing == arrUsersInFormRows - 1
                                                        ? const BorderRadius.only(bottomRight: Radius.circular(10))
                                                        : null,
                                                onTapForward:
                                                    () =>
                                                        textFieldControllers["${activitySectionData[i]["activityId"]}${usersListing + 1}"]?.text =
                                                            textFieldControllers["${activitySectionData[i]["activityId"]}$usersListing"]?.text ?? "",
                                                setConditions: () {
                                                  int x = int.tryParse((activitySectionData[i]["activityId"]?.toString() ?? "").numericOnly()) ?? 0;

                                                  int thisUserId = int.parse(arrUsersInForm(0, usersListing));
                                                  String strValue = strThisAmount.toString();

                                                  switch (systemID) {
                                                    case 5: //'MDFR'
                                                      switch (x) {
                                                        //'Activity # From User Role'
                                                        case 1 || 2: //'Hide From Flight Medics (1=Search Patterns,2=Hoist)'
                                                          if (arrUsersInForm(5, usersListing).trim() == "false") strValue = "0";
                                                          break;
                                                        case 11 || 12: //'Hide From Pilots (11=Stokes,12=Strop,)'
                                                          if (arrUsersInForm(5, usersListing).trim() == "true") strValue = "0";
                                                          break;
                                                      }
                                                      break;
                                                    case 28: //'TXDPS'
                                                      switch (x) {
                                                        //'Activity # From User Role'
                                                        case 5: //'Track Helo'
                                                          if (rotorFixedWing != "Fixed Wing Single-En" && rotorFixedWing != "Fixed Wing Multi-Eng") {
                                                            //'-- Only if this aircraft is Helo for #5'
                                                            if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotTrack;
                                                            if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotTrack;
                                                          }
                                                          break;
                                                        case 6: //'Track Fixed Wing'
                                                          if (rotorFixedWing == "Fixed Wing Single-En" || rotorFixedWing == "Fixed Wing Multi-Eng") {
                                                            //'-- Only if this aircraft is Helo for #6'
                                                            if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotTrack;
                                                            if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotTrack;
                                                          }
                                                          break;
                                                        case 7: //'Hoist Ops Land'
                                                          if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotHoistOpsLand;
                                                          if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotHoistOpsLand;
                                                          if (arrUsersInForm(0, usersListing).trim() == tfo1TFO.trim()) strValue = tfo1HoistOpsLand;
                                                          if (arrUsersInForm(0, usersListing).trim() == tfo2TFO.trim()) strValue = tfo2HoistOpsLand;
                                                          if (arrUsersInForm(0, usersListing).trim() == tfo3TFO.trim()) strValue = tfo3HoistOpsLand;
                                                          break;
                                                        case 8: //'Hoist Ops Water'
                                                          if (arrUsersInForm(0, usersListing).trim() == strPilotID.toString().trim()) strValue = pilotHoistOpsWater;
                                                          if (arrUsersInForm(0, usersListing).trim() == strCoPilotID.toString().trim()) strValue = coPilotHoistOpsWater;
                                                          if (arrUsersInForm(0, usersListing).trim() == tfo1TFO.trim()) strValue = tfo1HoistOpsWater;
                                                          if (arrUsersInForm(0, usersListing).trim() == tfo2TFO.trim()) strValue = tfo2HoistOpsWater;
                                                          if (arrUsersInForm(0, usersListing).trim() == tfo3TFO.trim()) strValue = tfo3HoistOpsWater;
                                                          break;
                                                      }
                                                      break;
                                                    case 41: //'Pinellas'
                                                      switch (x) {
                                                        case 5: //'Track Intercept'
                                                          if (thisUserId == strPilotID) strValue = strPilotTrackIntercept.toString();
                                                          if (thisUserId == strCoPilotID) strValue = strCoPilotTrackIntercept.toString();
                                                          break;
                                                      }
                                                      break;
                                                    case 46: //'AZDPS'
                                                      switch (x) {
                                                        case 0: //'Vertical Reference Operation'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCVerticalRefOpSOShortHaul;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCVerticalRefOpSOShortHaul;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCVerticalRefOpSOShortHaul;
                                                          break;
                                                        case 1: //'Vertical Reference Op Over H20 / SO Over H20'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCVerticalReferenceOpOverH20SOOverH20;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCVerticalReferenceOpOverH20SOOverH20;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCVerticalReferenceOpOverH20SOOverH20;
                                                          break;
                                                        case 2: //'Vertical Reference Time / SO Time'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCVerticalRefTimeSOTime;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCVerticalRefTimeSOTime;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCVerticalRefTimeSOTime;
                                                          break;
                                                        case 3: //'Hoist Insertion Day'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCHoistInsertionDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCHoistInsertionDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistInsertionDay;
                                                          break;
                                                        case 4: //'Hoist Insertion Day SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCHoistInsertionDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistInsertionDaySO;
                                                          break;
                                                        case 5: //'Hoist Insertion Night'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCHoistInsertionNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCHoistInsertionNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistInsertionNight;
                                                          break;
                                                        case 6: //'Hoist Insertion Night'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCHoistInsertionNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistInsertionNightSO;
                                                          break;
                                                        case 7: //'Hoist Extraction Day'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCHoistExtractionDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCHoistExtractionDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistExtractionDay;
                                                          break;
                                                        case 8: //'NVG Aided to Unaided Transition'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCNVGAidedUnAidedTransition;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCNVGAidedUnAidedTransition;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCNVGAidedUnAidedTransition;
                                                          break;
                                                        case 9: //'Hoist Extraction Day SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCHoistExtractionDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistExtractionDaySO;
                                                          break;
                                                        case 10: //'Short Haul'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCShortHaul;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCShortHaul;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicShortHaul;
                                                          break;
                                                        case 11: //'Hoist Extraction Night'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCHoistExtractionNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCHoistExtractionNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistExtractionNight;
                                                          break;
                                                        case 12: //'Hoist Extraction Night SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCHoistExtractionNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoistExtractionNightSO;
                                                          break;
                                                        case 13: //'Rappel'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCRappel;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCRappel;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicRappel;
                                                          break;
                                                        case 14: //'Rappel SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCRappel;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicRappelSO;
                                                          break;
                                                        case 15: //'Toe In'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCToeIn;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCToeIn;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCToeIn;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicToeIn;
                                                          break;
                                                        case 16: //'One Skid'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCOneSkid;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCOneSkid;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCOneSkid;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicOneSkid;
                                                          break;
                                                        case 17: //'Hover Ingress/Egress'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCHoverIngressEgress;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCHoverIngressEgress;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCHoverIngressEgress;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicHoverIngressEgress;
                                                          break;
                                                        case 18: //'Paramedic_DoubleUpExtraction'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicDoubleUpExtraction;
                                                          break;
                                                        case 19: //'Paramedic_DoubleUpExtractionSO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicDoubleUpExtractionSO;
                                                          break;
                                                        case 20: //'Litter Hoist with Tagline Day'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCLitterHoistWithTaglineDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCLitterHoistWithTaglineDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterHoistWithTaglineDay;
                                                          break;
                                                        case 21: //'Litter Hoist with Tagline Day SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCLitterHoistWithTaglineDay;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterHoistWithTaglineDaySO;
                                                          break;
                                                        case 22: //'Litter Hoist with Tagline Night'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot1) strValue = piCLitterHoistWithTaglineNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCPilot2) strValue = siCLitterHoistWithTaglineNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterHoistWithTaglineNight;
                                                          break;
                                                        case 23: //'Litter Hoist with Tagline Night SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCLitterHoistWithTaglineNight;
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterHoistWithTaglineNightSO;
                                                          break;
                                                        case 24: //'Paramedic_LitterDouble_UpwithTaglineDay'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterDoubleUpWithTaglineDay;
                                                          break;
                                                        case 25: //'Paramedic_LitterDoubleUpwithTaglineDaySO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterDoubleUpWithTaglineDaySO;
                                                          break;
                                                        case 26: //'Paramedic_LitterDouble_UpwithTaglineNight'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterDoubleUpWithTaglineNight;
                                                          break;
                                                        case 27: //'Paramedic_LitterDoubleUpwithTaglineNightSO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCRS) strValue = paramedicLitterDoubleUpWithTaglineNightSO;
                                                          break;
                                                        case 28: //'Short Haul SO'
                                                          if (arrUsersInForm(0, usersListing).trim() == piCSO) strValue = piCShortHaul;
                                                          break;
                                                      }
                                                      break;
                                                    case 53: //'OCSO'
                                                      if (x == 1) {
                                                        //'TFO Time is PIC Time for Non-Pilots'
                                                        if (arrUsersInForm(5, usersListing).trim() == "false") strValue = strPICTime.toString(); //Response.Write strPICTime
                                                      }
                                                      break;
                                                    case 57: //'-NJSP'
                                                      switch (x) {
                                                        case 0: //'-- Hoist Sic Day'
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotHoistCycle;
                                                          break;
                                                        case 1: //'-- Hoist Sic Night'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotNightHoistCycle;
                                                          break;
                                                        case 2: //'-- Hoist Pilot Day'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotHoistCycle;
                                                          break;
                                                        case 3: //'-- Hoist Pilot Night'
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotNightHoistCycle;
                                                          break;
                                                        case 4: //'-- Hoist Crew Chief Day'
                                                          if (thisUserId == strNjspCrewChiefId) strValue = strNjspCCHoistCycleDay;
                                                          break;
                                                        case 5: //'-- Hoist Crew Chief Night'
                                                          if (thisUserId == strNjspCrewChiefId) strValue = strNjspCCHoistCycleNight;
                                                          break;
                                                        case 6: //'Agusta Day Currency'
                                                          if (aircraftType == "Agusta S.p.A.") {
                                                            if (thisUserId == strNjspPilotId) strValue = strNjspPilotDayLandings;
                                                            if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotDayLandings;
                                                          }
                                                          break;
                                                        case 7: //'Bell Day Currency'
                                                          if (aircraftType == "Bell Helicopter Textron Canada Limited") {
                                                            if (thisUserId == strNjspPilotId) strValue = strNjspPilotDayLandings;
                                                            if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotDayLandings;
                                                          }
                                                          break;
                                                        case 8: //'Agusta Approach Currency'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotApproachILS;
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotApproachILS;
                                                          break;
                                                        case 9: //'Agusta Night Currency'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotApproachLPV;
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotApproachLPV;
                                                          break;
                                                        case 10: //'Agusta NVG Currency --Joaquin to find out rules (NVG Ops or Time?) 2017-05-16'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotApproachLNAV;
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotApproachLNAV;
                                                          break;
                                                        case 11: //'Bell Night Currency'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotApproachLOC;
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotApproachLOC;
                                                          break;
                                                        case 12: //'Bell NVG Currency --Joaquin to find out rules (NVG Ops or Time?) 2017-05-16'
                                                          if (thisUserId == strNjspPilotId) strValue = strNjspPilotApproachVOR;
                                                          if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotApproachVOR;
                                                          break;
                                                        case 13: //'Fast Rope'
                                                          if (thisUserId == strNjspCrewChiefId) strValue = strNjspCCFastRope;
                                                          break;
                                                        case 14: //'Agusta Night Currency'
                                                          //'Response.Write thisUserId & "/" & strNjspPilotId
                                                          if (aircraftType == "Agusta S.p.A.") {
                                                            if (thisUserId == strNjspPilotId) strValue = strNjspPilotNightLandings;
                                                            if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotNightLandings;
                                                          }
                                                          break;
                                                        case 15: //'Agusta NVG Currency --Joaquin to find out rules (NVG Ops or Time?) 2017-05-16'
                                                          break;
                                                        case 16: //'Bell Night Currency'
                                                          if (aircraftType == "Bell Helicopter Textron Canada Limited") {
                                                            if (thisUserId == strNjspPilotId) strValue = strNjspPilotNightLandings;
                                                            if (thisUserId == strNjspCoPilotId) strValue = strNjspCoPilotNightLandings;
                                                          }
                                                          break;
                                                        case 17: //'Bell NVG Currency --Joaquin to find out rules (NVG Ops or Time?) 2017-05-16'
                                                          break;
                                                      }
                                                      break;
                                                    case 85: //'Utah'
                                                      switch (x) {
                                                        case 2: //'Toe IN
                                                          if (thisUserId == piC1ID || thisUserId == piC2ID) strValue = piCToeIN;
                                                          break;
                                                        case 3: //'OneSkid
                                                          if (thisUserId == int.parse(hoistOpID)) strValue = hoistOpOneSkid;
                                                          break;
                                                        case 4: //'Total Number Of Picks
                                                          if (thisUserId == piC1ID || thisUserId == piC2ID) strValue = piCTotalNumberPicks;

                                                          if (thisUserId == int.parse(trNPilotPilot1)) strValue = trNPilotTotalPicks1;
                                                          if (thisUserId == int.parse(trNPilotPilot2)) strValue = trNPilotTotalPicks2;
                                                          if (thisUserId == int.parse(trNPilotPilot3)) strValue = trNPilotTotalPicks3;
                                                          if (thisUserId == int.parse(trNPilotPilot4)) strValue = trNPilotTotalPicks4;
                                                          if (thisUserId == int.parse(trNPilotPilot5)) strValue = trNPilotTotalPicks5;
                                                          if (thisUserId == int.parse(trNPilotPilot6)) strValue = trNPilotTotalPicks6;

                                                          if (thisUserId == int.parse(hoistOpHoistOperator1)) strValue = hoistOpTotalOfPicks1;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator2)) strValue = hoistOpTotalOfPicks2;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator3)) strValue = hoistOpTotalOfPicks3;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator4)) strValue = hoistOpTotalOfPicks4;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator5)) strValue = hoistOpTotalOfPicks5;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator6)) strValue = hoistOpTotalOfPicks6;

                                                          if (thisUserId == int.parse(rescueRescueSpecialist1)) strValue = rescueTotalOfPicks1;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist2)) strValue = rescueTotalOfPicks2;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist3)) strValue = rescueTotalOfPicks3;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist4)) strValue = rescueTotalOfPicks4;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist5)) strValue = rescueTotalOfPicks5;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist6)) strValue = rescueTotalOfPicks6;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist7)) strValue = rescueTotalOfPicks7;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist8)) strValue = rescueTotalOfPicks8;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist9)) strValue = rescueTotalOfPicks9;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist10)) strValue = rescueTotalOfPicks10;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist11)) strValue = rescueTotalOfPicks11;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist12)) strValue = rescueTotalOfPicks12;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist13)) strValue = rescueTotalOfPicks13;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist14)) strValue = rescueTotalOfPicks14;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist15)) strValue = rescueTotalOfPicks15;
                                                          break;
                                                        case 5: //'HoistOp_Ares
                                                          if (thisUserId == int.parse(hoistOpID)) strValue = hoistOpAres;
                                                          if (thisUserId == int.parse(trNPilotPilot1)) strValue = trNPilotARESPICKS1;
                                                          if (thisUserId == int.parse(trNPilotPilot2)) strValue = trNPilotARESPICKS2;
                                                          if (thisUserId == int.parse(trNPilotPilot3)) strValue = trNPilotARESPICKS3;
                                                          if (thisUserId == int.parse(trNPilotPilot4)) strValue = trNPilotARESPICKS4;
                                                          if (thisUserId == int.parse(trNPilotPilot5)) strValue = trNPilotARESPICKS5;
                                                          if (thisUserId == int.parse(trNPilotPilot6)) strValue = trNPilotARESPICKS6;

                                                          if (thisUserId == int.parse(hoistOpHoistOperator1)) strValue = hoistOpOfARESPICKS1;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator2)) strValue = hoistOpOfARESPICKS2;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator3)) strValue = hoistOpOfARESPICKS3;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator4)) strValue = hoistOpOfARESPICKS4;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator5)) strValue = hoistOpOfARESPICKS5;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator6)) strValue = hoistOpOfARESPICKS6;

                                                          if (thisUserId == int.parse(rescueRescueSpecialist1)) strValue = rescueARESPICKS1;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist2)) strValue = rescueARESPICKS2;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist3)) strValue = rescueARESPICKS3;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist4)) strValue = rescueARESPICKS4;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist5)) strValue = rescueARESPICKS5;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist6)) strValue = rescueARESPICKS6;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist7)) strValue = rescueARESPICKS7;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist8)) strValue = rescueARESPICKS8;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist9)) strValue = rescueARESPICKS9;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist10)) strValue = rescueARESPICKS10;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist11)) strValue = rescueARESPICKS11;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist12)) strValue = rescueARESPICKS12;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist13)) strValue = rescueARESPICKS13;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist14)) strValue = rescueARESPICKS14;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist15)) strValue = rescueARESPICKS15;
                                                          break;
                                                        case 6: //'HoistOp_Arv
                                                          if (thisUserId == int.parse(hoistOpID)) strValue = hoistOpArv;

                                                          if (thisUserId == int.parse(trNPilotPilot1)) strValue = trNPilotARVPICKS1;
                                                          if (thisUserId == int.parse(trNPilotPilot2)) strValue = trNPilotARVPICKS2;
                                                          if (thisUserId == int.parse(trNPilotPilot3)) strValue = trNPilotARVPICKS3;
                                                          if (thisUserId == int.parse(trNPilotPilot4)) strValue = trNPilotARVPICKS4;
                                                          if (thisUserId == int.parse(trNPilotPilot5)) strValue = trNPilotARVPICKS5;
                                                          if (thisUserId == int.parse(trNPilotPilot6)) strValue = trNPilotARVPICKS6;

                                                          if (thisUserId == int.parse(hoistOpHoistOperator1)) strValue = hoistOpARVPICKS1;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator2)) strValue = hoistOpARVPICKS2;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator3)) strValue = hoistOpARVPICKS3;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator4)) strValue = hoistOpARVPICKS4;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator5)) strValue = hoistOpARVPICKS5;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator6)) strValue = hoistOpARVPICKS6;

                                                          if (thisUserId == int.parse(rescueRescueSpecialist1)) strValue = rescueARVPICKS1;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist2)) strValue = rescueARVPICKS2;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist3)) strValue = rescueARVPICKS3;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist4)) strValue = rescueARVPICKS4;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist5)) strValue = rescueARVPICKS5;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist6)) strValue = rescueARVPICKS6;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist7)) strValue = rescueARVPICKS7;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist8)) strValue = rescueARVPICKS8;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist9)) strValue = rescueARVPICKS9;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist10)) strValue = rescueARVPICKS10;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist11)) strValue = rescueARVPICKS11;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist12)) strValue = rescueARVPICKS12;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist13)) strValue = rescueARVPICKS13;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist14)) strValue = rescueARVPICKS14;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist15)) strValue = rescueARVPICKS15;
                                                          break;
                                                        case 7: //'HoistOp_2Ups
                                                          if (thisUserId == int.parse(hoistOpID)) strValue = hoistOp2Ups;
                                                          if (thisUserId == int.parse(trNPilotPilot1)) strValue = trNPilot2UPS1;
                                                          if (thisUserId == int.parse(trNPilotPilot2)) strValue = trNPilot2UPS2;
                                                          if (thisUserId == int.parse(trNPilotPilot3)) strValue = trNPilot2UPS3;
                                                          if (thisUserId == int.parse(trNPilotPilot4)) strValue = trNPilot2UPS4;
                                                          if (thisUserId == int.parse(trNPilotPilot5)) strValue = trNPilot2UPS5;
                                                          if (thisUserId == int.parse(trNPilotPilot6)) strValue = trNPilot2UPS6;

                                                          if (thisUserId == int.parse(hoistOpHoistOperator1)) strValue = hoistOp2UPS1;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator2)) strValue = hoistOp2UPS2;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator3)) strValue = hoistOp2UPS3;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator4)) strValue = hoistOp2UPS4;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator5)) strValue = hoistOp2UPS5;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator6)) strValue = hoistOp2UPS6;

                                                          if (thisUserId == int.parse(rescueRescueSpecialist1)) strValue = rescue2UPS1;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist2)) strValue = rescue2UPS2;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist3)) strValue = rescue2UPS3;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist4)) strValue = rescue2UPS4;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist5)) strValue = rescue2UPS5;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist6)) strValue = rescue2UPS6;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist7)) strValue = rescue2UPS7;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist8)) strValue = rescue2UPS8;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist9)) strValue = rescue2UPS9;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist10)) strValue = rescue2UPS10;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist11)) strValue = rescue2UPS11;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist12)) strValue = rescue2UPS12;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist13)) strValue = rescue2UPS13;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist14)) strValue = rescue2UPS14;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist15)) strValue = rescue2UPS15;
                                                          break;
                                                        case 8: //'HoistOp_TagLine
                                                          if (thisUserId == int.parse(hoistOpID)) strValue = hoistOpTagLine;

                                                          if (thisUserId == int.parse(hoistOpHoistOperator1)) strValue = hoistOpTAGLINES1;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator2)) strValue = hoistOpTAGLINES2;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator3)) strValue = hoistOpTAGLINES3;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator4)) strValue = hoistOpTAGLINES4;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator5)) strValue = hoistOpTAGLINES5;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator6)) strValue = hoistOpTAGLINES6;

                                                          if (thisUserId == int.parse(rescueRescueSpecialist1)) strValue = rescueTAGLINES1;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist2)) strValue = rescueTAGLINES2;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist3)) strValue = rescueTAGLINES3;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist4)) strValue = rescueTAGLINES4;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist5)) strValue = rescueTAGLINES5;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist6)) strValue = rescueTAGLINES6;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist7)) strValue = rescueTAGLINES7;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist8)) strValue = rescueTAGLINES8;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist9)) strValue = rescueTAGLINES9;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist10)) strValue = rescueTAGLINES10;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist11)) strValue = rescueTAGLINES11;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist12)) strValue = rescueTAGLINES12;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist13)) strValue = rescueTAGLINES13;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist14)) strValue = rescueTAGLINES14;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist15)) strValue = rescueTAGLINES15;

                                                          break;
                                                        case 9: //'E Ops'
                                                          if (thisUserId == int.parse(trNPilotPilot1)) strValue = trNPilotEMERGENCYOPS1;
                                                          if (thisUserId == int.parse(trNPilotPilot2)) strValue = trNPilotEMERGENCYOPS2;
                                                          if (thisUserId == int.parse(trNPilotPilot3)) strValue = trNPilotEMERGENCYOPS3;
                                                          if (thisUserId == int.parse(trNPilotPilot4)) strValue = trNPilotEMERGENCYOPS4;
                                                          if (thisUserId == int.parse(trNPilotPilot5)) strValue = trNPilotEMERGENCYOPS5;
                                                          if (thisUserId == int.parse(trNPilotPilot6)) strValue = trNPilotEMERGENCYOPS6;

                                                          if (thisUserId == int.parse(hoistOpHoistOperator1)) strValue = hoistOpEMERGENCYOPERATIONS1;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator2)) strValue = hoistOpEMERGENCYOPERATIONS2;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator3)) strValue = hoistOpEMERGENCYOPERATIONS3;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator4)) strValue = hoistOpEMERGENCYOPERATIONS4;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator5)) strValue = hoistOpEMERGENCYOPERATIONS5;
                                                          if (thisUserId == int.parse(hoistOpHoistOperator6)) strValue = hoistOpEMERGENCYOPERATIONS6;

                                                          if (thisUserId == int.parse(rescueRescueSpecialist1)) strValue = rescueEMERGENCYOPS1;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist2)) strValue = rescueEMERGENCYOPS2;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist3)) strValue = rescueEMERGENCYOPS3;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist4)) strValue = rescueEMERGENCYOPS4;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist5)) strValue = rescueEMERGENCYOPS5;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist6)) strValue = rescueEMERGENCYOPS6;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist7)) strValue = rescueEMERGENCYOPS7;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist8)) strValue = rescueEMERGENCYOPS8;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist9)) strValue = rescueEMERGENCYOPS9;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist10)) strValue = rescueEMERGENCYOPS10;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist11)) strValue = rescueEMERGENCYOPS11;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist12)) strValue = rescueEMERGENCYOPS12;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist13)) strValue = rescueEMERGENCYOPS13;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist14)) strValue = rescueEMERGENCYOPS14;
                                                          if (thisUserId == int.parse(rescueRescueSpecialist15)) strValue = rescueEMERGENCYOPS15;
                                                          break;
                                                      }
                                                      break;
                                                    case 86: //'TX Wildlife'
                                                      switch (x) {
                                                        case 5: //'Hoist Ops
                                                          if (thisUserId == strHoistOp1) strValue = strHoistOp1Qty.toString();
                                                          if (thisUserId == strHoistOp2) strValue = strHoistOp2Qty.toString();
                                                          if (thisUserId == strHoistOp3) strValue = strHoistOp3Qty.toString();
                                                          if (thisUserId == strHoistOp4) strValue = strHoistOp4Qty.toString();

                                                          if (thisUserId == strRecueTech1) strValue = strRescueTech1Qty.toString();
                                                          if (thisUserId == strRecueTech2) strValue = strRescueTech2Qty.toString();
                                                          if (thisUserId == strRecueTech3) strValue = strRescueTech3Qty.toString();
                                                          if (thisUserId == strRecueTech4) strValue = strRescueTech4Qty.toString();
                                                          if (thisUserId == strRecueTech5) strValue = strRescueTech5Qty.toString();
                                                          break;
                                                        case 10: //'Day Auto
                                                          if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strPicDayAuto.toString();
                                                          if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strSicDayAuto.toString();
                                                          break;
                                                        case 11: //'Night Auto
                                                          if (arrUsersInForm(0, usersListing).trim() == strTxWildPilotId.toString().trim()) strValue = strPicNightAuto.toString();
                                                          if (arrUsersInForm(0, usersListing).trim() == strTxWildCoPilotId.toString().trim()) strValue = strSicNightAuto.toString();
                                                          break;
                                                      }
                                                      break;
                                                    case 91: //'Atlanta
                                                      switch (x) {
                                                        case 0: //'Day Flight Time
                                                          if (thisUserId == int.parse(piCID)) strValue = picDayFlightTime;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1DayFlightTime;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1DayFlightTime;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1DayFlightTime;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2DayFlightTime;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3DayFlightTime;
                                                          break;
                                                        case 1: //'Night Flight Time
                                                          if (thisUserId == int.parse(piCID)) strValue = picNightFlightTime;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1NightFlightTime;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1NightFlightTime;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1NightFlightTime;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2NightFlightTime;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3NightFlightTime;
                                                          break;
                                                        case 2: //'PIC
                                                          if (thisUserId == int.parse(piCID)) strValue = picPIC;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1PIC;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1PIC;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1PIC;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2PIC;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3PIC;
                                                          break;
                                                        case 3: //'Day Landings
                                                          if (thisUserId == int.parse(piCID)) strValue = picDayLandings;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1DayLandings;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1DayLandings;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1DayLandings;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2DayLandings;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3DayLandings;
                                                          break;
                                                        case 4: //'Night Landings:
                                                          if (thisUserId == int.parse(piCID)) strValue = picNightLandings;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1NightLandings;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1NightLandings;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1NightLandings;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2NightLandings;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3NightLandings;
                                                          break;
                                                        case 5: //'X-Country
                                                          if (thisUserId == int.parse(piCID)) strValue = picXCountry;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1XCountry;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1XCountry;
                                                          break;
                                                        case 6: //'Solo
                                                          if (thisUserId == int.parse(piCID)) strValue = piCSolo;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1Solo;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1Solo;
                                                          break;
                                                        case 7: //'Hoist OPS
                                                          if (thisUserId == int.parse(piCID)) strValue = piCHoistOPS;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1HoistOPS;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1HoistOPS;
                                                          break;
                                                        case 8: //'IFR (Sim)
                                                          if (thisUserId == int.parse(piCID)) strValue = picIFRSim;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1IFRSim;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1IFRSim;
                                                          break;
                                                        case 9: //'IFR (Act)
                                                          if (thisUserId == int.parse(piCID)) strValue = picIFRAct;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1IFRAct;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1IFRAct;
                                                          break;
                                                        case 10: //'Precision Approaches:
                                                          if (thisUserId == int.parse(piCID)) strValue = picPrecisionApproaches;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1PrecisionApproaches;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1PrecisionApproaches;
                                                          break;
                                                        case 11: //'Non-Precision Approaches:
                                                          if (thisUserId == int.parse(piCID)) strValue = picNONPrecisionApproaches;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1NONPrecisionApproaches;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1NONPrecisionApproaches;
                                                          break;
                                                        case 12: //'Track:
                                                          if (thisUserId == int.parse(piCID)) strValue = piCTrack;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1Track;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1Track;
                                                          break;
                                                        case 13: //'Time In City A/C
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1TimeInCityAircraft;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2TimeInCityAircraft;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3TimeInCityAircraft;
                                                          break;
                                                        case 14: //'NVG Time:
                                                          if (thisUserId == int.parse(piCID)) strValue = picNVGTime;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1NVGTime;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1NVGTime;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1NVGTime;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2NVGTime;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3NVGTime;
                                                          break;
                                                        case 15: //'NVG OPS:
                                                          if (thisUserId == int.parse(piCID)) strValue = picNVGOps;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1NVGOps;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1NVGOps;
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1NVGOps;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2NVGOps;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3NVGOps;
                                                          break;
                                                        case 16: //'NVG Landings
                                                          if (thisUserId == int.parse(piCID)) strValue = picNVGLandings;
                                                          if (thisUserId == int.parse(siC1ID)) strValue = siC1NVGLandings;
                                                          if (thisUserId == int.parse(siC2ID)) strValue = siC1NVGLandings;
                                                          break;
                                                        case 17: //'FLIR Search:
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1FLIRSearch;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2FLIRSearch;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3FLIRSearch;
                                                          break;
                                                        case 18: //'FOOT PURSUITS:
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1FOOTPursuits;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2FOOTPursuits;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3FOOTPursuits;
                                                          break;
                                                        case 19: //'VEHICLE PURSUITS:
                                                          if (thisUserId == int.parse(tfO1ID)) strValue = tfO1VehiclePursuits;
                                                          if (thisUserId == int.parse(tfO2ID)) strValue = tfO2VehiclePursuits;
                                                          if (thisUserId == int.parse(tfO3ID)) strValue = tfO3VehiclePursuits;
                                                          break;
                                                        case 20: //'Type of Hoist:
                                                          break;
                                                        case 21: //'Total Training Hours:
                                                          if (thisUserId == int.parse(hoistHoistOperator) || thisUserId == int.parse(hoistRescueTechnician)) {
                                                            if (hoistTotalTrainingHours.contains(RegExp(r'^\d{2}:\d{2}$')) == false) hoistTotalTrainingHours = "00:00";
                                                            //if (hoistTotalTrainingHours.isDateTime == false) hoistTotalTrainingHours = "00:00";
                                                            //hoistTotalTrainingHours = DateTimeHelper.timeFormatDefault.format(DateTime.tryParse(hoistTotalTrainingHours) ?? DateTime(0));
                                                            List<String> hoistHoursSplit = hoistTotalTrainingHours.split(":");
                                                            double hoistTime = (((int.parse(hoistHoursSplit[0]) * 60) + int.parse(hoistHoursSplit[1])) / 60);
                                                            strValue = hoistTime.toString();
                                                          }
                                                          break;
                                                        case 22: //'Basket Hoists:
                                                          if (thisUserId == int.parse(hoistHoistOperator) || thisUserId == int.parse(hoistRescueTechnician)) {
                                                            strValue = hoistBasketHoists;
                                                          }
                                                          break;
                                                        case 23: //'HOTSEAT HOIST:
                                                          if (thisUserId == int.parse(hoistHoistOperator) || thisUserId == int.parse(hoistRescueTechnician)) {
                                                            strValue = hoistHOTSEATHoists;
                                                          }
                                                          break;
                                                        case 24: //'Activity24
                                                          break;
                                                      }
                                                      break;
                                                    case 101: //'Nashville
                                                      switch (x) {
                                                        case 7: //'OH-58 TT
                                                          //'if (thisUserId == PIC_ID)
                                                          strValue = (double.tryParse(oh58TT) ?? 0).toStringAsFixed(1); //'PIC_Day_Flight_Time
                                                          break;
                                                        case 8: //'Md500 TT
                                                          //'if (thisUserId == PIC_ID)
                                                          strValue = (double.tryParse(md500TT) ?? 0).toStringAsFixed(1); //'PIC_Day_Flight_Time
                                                          break;
                                                      }
                                                      break;
                                                    case 104: //'Orange Fire'
                                                      switch (x) {
                                                        case 1: //'Basket Litter Short Haul [1]'
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCBasketLitterShortHaul;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCBasketLitterShortHaul;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3BasketLitterShortHaul;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4BasketLitterShortHaul;
                                                          break;
                                                        case 2: //'Basket Litter Insertion / Extraction [2]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCBasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCBasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(trT1User)) strValue = trT1BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(trT2User)) strValue = trT2BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(trT3User)) strValue = trT3BasketLitterInsertionExtraction;
                                                          if (thisUserId == int.parse(trT4User)) strValue = trT4BasketLitterInsertionExtraction;
                                                          break;
                                                        case 3: //'Equipment Insertion / Extraction [3]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCEquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCEquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(trT1User)) strValue = trT1EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(trT2User)) strValue = trT2EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(trT3User)) strValue = trT3EquipmentInsertionExtraction;
                                                          if (thisUserId == int.parse(trT4User)) strValue = trT4EquipmentInsertionExtraction;
                                                          break;
                                                        case 4: //'Rescuer Insertion / Extraction [4]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCRescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCRescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(trT1User)) strValue = trT1RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(trT2User)) strValue = trT2RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(trT3User)) strValue = trT3RescuerInsertionExtraction;
                                                          if (thisUserId == int.parse(trT4User)) strValue = trT4RescuerInsertionExtraction;
                                                          break;
                                                        case 5: //'Pick Off Rescue [5]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCPickOffRescue;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCPickOffRescue;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1PickOffRescue;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2PickOffRescue;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3PickOffRescue;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4PickOffRescue;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1PickOffRescue;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2PickOffRescue;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3PickOffRescue;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4PickOffRescue;
                                                          break;
                                                        case 6: //'Capture Rescue [6]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCCaptureRescue;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCCaptureRescue;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1CaptureRescue;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2CaptureRescue;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3CaptureRescue;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4CaptureRescue;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1CaptureRescue;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2CaptureRescue;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3CaptureRescue;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4CaptureRescue;
                                                          break;
                                                        case 7: //'Large Animal [7]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCLargeAnimal;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCLargeAnimal;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1LargeAnimal;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2LargeAnimal;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3LargeAnimal;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4LargeAnimal;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1LargeAnimal;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2LargeAnimal;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3LargeAnimal;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4LargeAnimal;
                                                          break;
                                                        case 8: //'Vessel [8]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCVessel;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCVessel;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1Vessel;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2Vessel;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3Vessel;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4Vessel;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1Vessel;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2Vessel;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3Vessel;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4Vessel;
                                                          break;
                                                        case 9: //'Swift / Standing [9]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCSwiftStanding;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCSwiftStanding;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1SwiftStanding;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2SwiftStanding;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3SwiftStanding;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4SwiftStanding;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1SwiftStanding;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2SwiftStanding;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3SwiftStanding;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4SwiftStanding;
                                                          break;
                                                        case 10: //'Hover Jump / HeliStep [10]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCHoverJumpHeliStep;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCHoverJumpHeliStep;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(trT1User)) strValue = trT1HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(trT2User)) strValue = trT2HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(trT3User)) strValue = trT3HoverJumpHeliStep;
                                                          if (thisUserId == int.parse(trT4User)) strValue = trT4HoverJumpHeliStep;
                                                          break;
                                                        case 11: //'PIC [11]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCPICTime;
                                                          break;
                                                        case 12: //'Day Landings [12]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCDayTakeOffsLdgs;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCDayTakeOffsLdgs;
                                                          break;
                                                        case 13: //'Night Landings [13]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCNightTakeOffsLdgs;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCNightTakeOffsLdgs;
                                                          break;
                                                        case 14: //'NVG Time [14]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCNVGTime;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCNVGTime;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1NVGTime;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2NVGTime;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3NVGTime;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4NVGTime;
                                                          break;
                                                        case 15: //'NVG  Landing [15]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCNVGLandings;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCNVGLandings;
                                                          break;
                                                        case 16: //'NVG Water Drops [16]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCNVGWaterDrops;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCNVGWaterDrops;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1NVGWaterDrops;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2NVGWaterDrops;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3NVGWaterDrops;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4NVGWaterDrops;
                                                          break;
                                                        case 17: //'NVG Hover Operation [17]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCNVGOperations;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCNVGOperations;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1NVGHoverOperation;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2NVGHoverOperation;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3NVGHoverOperation;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4NVGHoverOperation;
                                                          break;
                                                        case 18: //'Check Flight [18]
                                                          if (thisUserId == int.parse(piCUser)) strValue = piCCheckFlight;
                                                          if (thisUserId == int.parse(siCUser)) strValue = siCCheckFlight;
                                                          if (thisUserId == int.parse(cC1User)) strValue = cC1CheckFlight;
                                                          if (thisUserId == int.parse(cC2User)) strValue = cC2CheckFlight;
                                                          if (thisUserId == int.parse(cC3User)) strValue = cC3CheckFlight;
                                                          if (thisUserId == int.parse(cC4User)) strValue = cC4CheckFlight;
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1CheckFlight;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2CheckFlight;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3CheckFlight;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4CheckFlight;
                                                          break;
                                                        case 19: //'Night Hover Operation [19]
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1NightHoverOperation;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2NightHoverOperation;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3NightHoverOperation;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4NightHoverOperation;
                                                          if (thisUserId == int.parse(trT1User)) strValue = trT1NightHoverOperation;
                                                          if (thisUserId == int.parse(trT2User)) strValue = trT2NightHoverOperation;
                                                          if (thisUserId == int.parse(trT3User)) strValue = trT3NightHoverOperation;
                                                          if (thisUserId == int.parse(trT4User)) strValue = trT4NightHoverOperation;
                                                          break;
                                                        case 20: //'Night Flight Time [20]
                                                          if (thisUserId == int.parse(hpR1User)) strValue = hpR1NightFlightTime;
                                                          if (thisUserId == int.parse(hpR2User)) strValue = hpR2NightFlightTime;
                                                          if (thisUserId == int.parse(hpR3User)) strValue = hpR3NightFlightTime;
                                                          if (thisUserId == int.parse(hpR4User)) strValue = hpR4NightFlightTime;
                                                          if (thisUserId == int.parse(trT1User)) strValue = trT1NightFlightTime;
                                                          if (thisUserId == int.parse(trT2User)) strValue = trT2NightFlightTime;
                                                          if (thisUserId == int.parse(trT3User)) strValue = trT3NightFlightTime;
                                                          if (thisUserId == int.parse(trT4User)) strValue = trT4NightFlightTime;
                                                          break;
                                                      }
                                                      break;
                                                    case 106: //'-- Nashville HP --'
                                                      switch (x) {
                                                        case 0: //'--Eradication
                                                          if (thisUserId == int.parse(piCId)) strValue = piCActivitiesEradication;
                                                          if (thisUserId == int.parse(coPilotId)) strValue = coPilotActivitiesEradication;
                                                          break;
                                                        case 1: //'--NVG Landings
                                                          if (thisUserId == int.parse(piCId)) strValue = piCActivitiesNVGLandings;
                                                          if (thisUserId == int.parse(coPilotId)) strValue = coPilotActivitiesNVGLandings;
                                                          break;
                                                        case 2: //'--Day Flight Time
                                                          if (thisUserId == int.parse(piCId)) strValue = piCDayFlightTime;
                                                          if (thisUserId == int.parse(coPilotId)) strValue = coPilotDayFlightTime;
                                                          break;
                                                        case 3: //'--Long Line'
                                                          if (thisUserId == int.parse(piCId)) strValue = piCLongLine;
                                                          if (thisUserId == int.parse(coPilotId)) strValue = coPilotLongLine;
                                                          if (thisUserId == int.parse(specID1)) strValue = specLongLine1;
                                                          if (thisUserId == int.parse(specID2)) strValue = specLongLine2;
                                                          if (thisUserId == int.parse(specID3)) strValue = specLongLine3;
                                                          if (thisUserId == int.parse(specID4)) strValue = specLongLine4;
                                                          if (thisUserId == int.parse(specID5)) strValue = specLongLine5;
                                                          if (thisUserId == int.parse(specID6)) strValue = specLongLine6;
                                                          if (thisUserId == int.parse(specID7)) strValue = specLongLine7;
                                                          if (thisUserId == int.parse(specID8)) strValue = specLongLine8;
                                                          if (thisUserId == int.parse(specID9)) strValue = specLongLine9;
                                                          if (thisUserId == int.parse(specID10)) strValue = specLongLine10;
                                                          break;
                                                        case 4: //'--HEC'
                                                          if (thisUserId == int.parse(piCId)) strValue = piCHECHumanExternalCargo;
                                                          if (thisUserId == int.parse(coPilotId)) strValue = coPilotHECHumanExternalCargo;
                                                          if (thisUserId == int.parse(specID1)) strValue = specHECHumanExternalCargo1;
                                                          if (thisUserId == int.parse(specID2)) strValue = specHECHumanExternalCargo2;
                                                          if (thisUserId == int.parse(specID3)) strValue = specHECHumanExternalCargo3;
                                                          if (thisUserId == int.parse(specID4)) strValue = specHECHumanExternalCargo4;
                                                          if (thisUserId == int.parse(specID5)) strValue = specHECHumanExternalCargo5;
                                                          if (thisUserId == int.parse(specID6)) strValue = specHECHumanExternalCargo6;
                                                          if (thisUserId == int.parse(specID7)) strValue = specHECHumanExternalCargo7;
                                                          if (thisUserId == int.parse(specID8)) strValue = specHECHumanExternalCargo8;
                                                          if (thisUserId == int.parse(specID9)) strValue = specHECHumanExternalCargo9;
                                                          if (thisUserId == int.parse(specID10)) strValue = specHECHumanExternalCargo10;
                                                          break;
                                                      }
                                                      break;
                                                    case 107: //'Seminole'
                                                      switch (x) {
                                                        case 0: //'--Semi Annual Recurring Training [0]
                                                          break;
                                                        case 1: //'--HeliSling [1]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCHeliSling;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCHeliSling;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCHeliSling;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCHeliSling;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCHeliSling;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCHeliSling;
                                                          break;
                                                        case 2: //'--Deployment Single [2]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCDeploymentSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCDeploymentSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCDeploymentSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCDeploymentSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCDeploymentSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSDeploymentSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSDeploymentSingle;
                                                          break;
                                                        case 3: //'--Deployment Tandem [3]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCDeploymentTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCDeploymentTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCDeploymentTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCDeploymentTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCDeploymentTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSDeploymentTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSDeploymentTandem;
                                                          break;
                                                        case 4: //'--Day Ops [4]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCDayOps.toString();
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCDayOps.toString();
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCDayOps.toString();
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCDayOps.toString();
                                                          break;
                                                        case 5: //'--Extraction Single [5]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCExtractionSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCExtractionSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCExtractionSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCExtractionSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCExtractionSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSExtractionSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSExtractionSingle;
                                                          break;
                                                        case 6: //'--Extraction Tandem [6]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCExtractionTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCExtractionTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCExtractionTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCExtractionTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCExtractionTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSExtractionTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSExtractionTandem;
                                                          break;
                                                        case 7: //'--IIMC Training [7]
                                                          if (thisUserId == int.parse(crewTFO1)) strValue = tfOIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewTFO2)) strValue = tfOIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCIMCCurrency.toString();
                                                          break;
                                                        case 8: //'--Quick Strop Single [8]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCQuickStropSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCQuickStropSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCQuickStropSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCQuickStropSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCQuickStropSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSQuickStropSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSQuickStropSingle;
                                                          break;
                                                        case 9: //'--Quick Strop Tandem [9]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCQuickStropTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCQuickStropTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCQuickStropTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCQuickStropTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCQuickStropTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSQuickStropTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSQuickStropTandem;
                                                          break;
                                                        case 10: //'--PEP Single [10]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCPEPSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCPEPSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCPEPSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCPEPSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCPEPSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSPEPSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSPEPSingle;
                                                          break;
                                                        case 11: //'--PEP Tandem [11]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCPEPTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCPEPTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCPEPTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCPEPTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCPEPTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSPEPTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSPEPTandem;
                                                          break;
                                                        case 12: //'--AVED Single [12]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCAVEDSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCAVEDSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCAVEDSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCAVEDSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCAVEDSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSAVEDSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSAVEDSingle;
                                                          break;
                                                        case 13: //'--AVED Tandem [13]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCAVEDTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCAVEDTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCAVEDTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCAVEDTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCAVEDTandem;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSAVEDTandem;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSAVEDTandem;
                                                          break;
                                                        case 14: //'--Bambi Bucket [14]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCBambiBucket;
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCBambiBucket;
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCBambiBucket;
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCBambiBucket;
                                                          break;
                                                        case 15: //'--Hoist Ops Land [15]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSHoistOpsLand;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSHoistOpsLand;
                                                          break;
                                                        case 16: //'--SWAT Ops [16]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCSwatOps.toString();
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCSwatOps.toString();
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCSwatOps.toString();
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCSwatOps.toString();
                                                          break;
                                                        case 17: //'--Rescuer Harness Single [17]
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSRescuerHarnessSingle;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSRescuerHarnessSingle;
                                                          break;
                                                        case 18: //'--Hoist [18]
                                                          if (thisUserId == int.parse(crewSWAT1)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT2)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT3)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT4)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT5)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT6)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT7)) strValue = swaTHoist;
                                                          if (thisUserId == int.parse(crewSWAT8)) strValue = swaTHoist;
                                                          break;
                                                        case 19: //'--Fast Rope [19]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCFastRope;
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCFastRope;
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCFastRope;
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCFastRope;
                                                          if (thisUserId == int.parse(crewSWAT1)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT2)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT3)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT4)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT5)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT6)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT7)) strValue = swaTFastRope;
                                                          if (thisUserId == int.parse(crewSWAT8)) strValue = swaTFastRope;

                                                          break;
                                                        case 20: //'--Night Ops [20]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCNightOps.toString();
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCNightOps.toString();
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCNightOps.toString();
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCNightOps.toString();
                                                          break;
                                                        case 21: //'--TFO Currency Shift Hours [21]
                                                          break;
                                                        case 22: //'--TFO Flight Hours [22]
                                                          break;
                                                        case 23: //'--Hours Crew Chief Time [23]
                                                          break;
                                                        case 24: //'--Hoist Ops Water [24]
                                                          if (thisUserId == int.parse(crewPIC1)) strValue = piCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewPIC2)) strValue = piCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewPIC3)) strValue = piCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewPIC4)) strValue = piCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewCREWCHIEF1)) strValue = cCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewCREWCHIEF2)) strValue = cCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewCREWCHIEF3)) strValue = cCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewCREWCHIEF4)) strValue = cCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewCREWCHIEF5)) strValue = cCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewCREWCHIEF6)) strValue = cCHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST1)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST2)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST3)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST4)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST5)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST6)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST7)) strValue = rSHoistOpsWater;
                                                          if (thisUserId == int.parse(crewRESCUESPECIALIST8)) strValue = rSHoistOpsWater;
                                                          break;
                                                        case 25: //'--Night Ops [25]
                                                          break;
                                                        case 26: //'--HeliSling [26]
                                                          break;
                                                        case 27: //'--Helicast Deployment [27]
                                                          break;
                                                        case 28: //'--AUF (Firearms Qualification) [28]
                                                          if (thisUserId == int.parse(crewSWAT1)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT2)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT3)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT4)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT5)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT6)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT7)) strValue = swatAUF;
                                                          if (thisUserId == int.parse(crewSWAT8)) strValue = swatAUF;
                                                          break;
                                                        case 29: //'--Pinch Hitter [29]
                                                          if (thisUserId == int.parse(crewTFO1)) strValue = tfOIMCCurrency.toString();
                                                          if (thisUserId == int.parse(crewTFO2)) strValue = tfOIMCCurrency.toString();
                                                          break;
                                                      }
                                                      break;
                                                    case 117: //'-- Georgia DNR --'
                                                      switch (x) {
                                                        case 0: //'Long-Line Ops [0]
                                                          if (thisUserId == strPilot) strValue = strLongLineOps;
                                                          if (thisUserId == strCoPilot) strValue = strLongLineOps;
                                                          break;
                                                        case 1: //'Repel Ops [1]
                                                          if (thisUserId == strPilot) strValue = strRepelOps;
                                                          if (thisUserId == strCoPilot) strValue = strRepelOps;
                                                          if (thisUserId == strTFO1) strValue = strTFO1RepelOps;
                                                          if (thisUserId == strTFO2) strValue = strTFO2RepelOps;
                                                          if (thisUserId == strTFO3) strValue = strTFO3RepelOps;
                                                          if (thisUserId == strTFO4) strValue = strTFO4RepelOps;
                                                          break;
                                                        case 2: //'Crew Chief Ops [2]
                                                          if (thisUserId == strTFO1) strValue = strTFO1CrewChiefOps;
                                                          if (thisUserId == strTFO2) strValue = strTFO2CrewChiefOps;
                                                          if (thisUserId == strTFO3) strValue = strTFO3CrewChiefOps;
                                                          if (thisUserId == strTFO4) strValue = strTFO4CrewChiefOps;
                                                          break;
                                                        case 3: //'NVG OPS [3]
                                                          if (thisUserId == strPilot) strValue = strNVGOps;
                                                          if (thisUserId == strCoPilot) strValue = strNVGOps;
                                                          if (thisUserId == strTFO1) strValue = strTFO1NVGOps;
                                                          if (thisUserId == strTFO2) strValue = strTFO4NVGOps;
                                                          if (thisUserId == strTFO3) strValue = strTFO4NVGOps;
                                                          if (thisUserId == strTFO4) strValue = strTFO4NVGOps;
                                                          break;
                                                        case 4: //'Bambi Bucket Ops [4]
                                                          if (thisUserId == strPilot) strValue = strBambiBucketOps;
                                                          if (thisUserId == strCoPilot) strValue = strBambiBucketOps;
                                                          break;
                                                      }
                                                      break;
                                                  }
                                                  return (double.tryParse(strValue) ?? 0).toPrecision(1);
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: Get.width > 480 ? 320 : 200,
                      right: 0.0, //width: arrUsersInFormRows > 2 ? 180.0 * arrUsersInFormRows : 420,
                      child: SingleChildScrollView(
                        controller: scrollController2,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          width: arrUsersInFormRows > 2 ? 180.0 * arrUsersInFormRows : 420,
                          child: Row(
                            children: [
                              for (int usersListing = 0; usersListing <= arrUsersInFormRows - 1; usersListing++)
                                Flexible(
                                  child: Container(
                                    alignment: arrUsersInFormRows == 1 ? Alignment.centerLeft : Alignment.center,
                                    margin: const EdgeInsets.only(left: 3.0, bottom: 3.0),
                                    padding: EdgeInsets.symmetric(horizontal: arrUsersInFormRows == 1 ? 8.0 : 5.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: ColorConstants.primary,
                                      borderRadius: usersListing == arrUsersInFormRows - 1 ? const BorderRadius.only(topRight: Radius.circular(10)) : null,
                                    ),
                                    child: Text(arrUsersInForm(1, usersListing), style: const TextStyle(color: Colors.white)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      );
    }
    EasyLoading.dismiss();
  }

  ///Done by Rahat - 100%
  void signatureCheckSaveButton({required String strFormFieldID}) {
    if ((jsClass['reDrawSignature_$strFormFieldID']?.isEmpty == false) && (values['reDrawSignature_${strFormFieldID}_Name'] ?? "") != '') {
      showField['reDrawSignature_$strFormFieldID'] = false;
    } else {
      showField['reDrawSignature_$strFormFieldID'] = true;
    }
  }

  ///Done by Rahat - 100%
  void openResult({url}) {
    if (values["OpenInNewWindow"] == "true") {
      //window.open(url,name);
    } else {
      //document.location =url;
    }
  }
}

class FixedSubSections extends StatelessWidget {
  final String sectionName;
  final List sectionData;

  final String? position;

  const FixedSubSections({super.key, required this.sectionName, required this.sectionData, this.position});

  @override
  Widget build(BuildContext context) {
    GlobalKey sectionHeightKey = GlobalKey();
    RxDouble height = 0.0.obs;
    WidgetConstant.widgetSize(sectionHeightKey).then((value) => height.value = value?.height ?? 0.0);
    Get.width > 480
        ? FormDesignerJs.sectionHeight.value = 0.0
        : WidgetConstant.widgetSize(sectionHeightKey).then((value) => FormDesignerJs.sectionHeight.value = value?.height ?? 0.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child:
          Get.width > 480
              ? Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: Obx(() {
                      return Container(
                        height: height.value != 0.0 ? height.value : null,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: ColorConstants.primary,
                          borderRadius: position == "last" ? const BorderRadius.only(bottomLeft: Radius.circular(10)) : null,
                        ),
                        child: Text("$sectionName:", style: const TextStyle(color: Colors.white)),
                      );
                    }),
                  ),
                  Flexible(
                    flex: 5,
                    child: Column(
                      key: sectionHeightKey,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < sectionData.length; i++)
                          Container(
                            height: sectionData[i]["height"] != 0.0 ? sectionData[i]["height"] : null,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5.0),
                            color:
                                i % 2 == 0
                                    ? sectionName == "Day"
                                        ? ColorConstants.primary.withValues(alpha: 0.5)
                                        : ColorConstants.primary.withValues(alpha: 0.3)
                                    : ColorConstants.primary.withValues(alpha: 0.5),
                            child: Text("${sectionData[i]["name"]}:"),
                          ),
                      ],
                    ),
                  ),
                ],
              )
              : Column(
                children: [
                  Container(
                    key: sectionHeightKey,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(color: ColorConstants.primary),
                    child: Text("$sectionName:", style: const TextStyle(color: Colors.white)),
                  ),
                  for (int i = 0; i < sectionData.length; i++)
                    Container(
                      height: sectionData[i]["height"] != 0.0 ? sectionData[i]["height"] : null,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color:
                            i % 2 == 0
                                ? sectionName == "Day"
                                    ? ColorConstants.primary.withValues(alpha: 0.5)
                                    : ColorConstants.primary.withValues(alpha: 0.3)
                                : ColorConstants.primary.withValues(alpha: 0.5),
                        borderRadius: position == "last" && i == sectionData.length - 1 ? const BorderRadius.only(bottomLeft: Radius.circular(10)) : null,
                      ),
                      child: Text("${sectionData[i]["name"]}:"),
                    ),
                ],
              ),
    );
  }
}

class ScrollableUserList extends StatelessWidget {
  final int usersListing;
  final int arrUsersInFormRows;
  final String arrUsersInForm;
  final TextEditingController controller;

  const ScrollableUserList({super.key, required this.usersListing, required this.arrUsersInFormRows, required this.arrUsersInForm, required this.controller});

  @override
  Widget build(BuildContext context) {
    GlobalKey userListHeightKey = GlobalKey();
    usersListing == 0 ? WidgetConstant.widgetSize(userListHeightKey).then((value) => FormDesignerJs.userListHeight.value = value?.height ?? 0.0) : null;

    return Column(
      key: usersListing == 0 ? userListHeightKey : null,
      children: [
        Container(
          alignment: arrUsersInFormRows == 1 ? Alignment.centerLeft : Alignment.center,
          margin: const EdgeInsets.only(left: 3.0, bottom: 3.0),
          padding: EdgeInsets.symmetric(horizontal: arrUsersInFormRows == 1 ? 8.0 : 5.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: ColorConstants.primary,
            borderRadius: usersListing == arrUsersInFormRows - 1 ? const BorderRadius.only(topRight: Radius.circular(10)) : null,
          ),
          child: Text(arrUsersInForm, style: const TextStyle(color: Colors.white)),
        ),
        Container(
          alignment: arrUsersInFormRows == 1 ? Alignment.centerLeft : Alignment.center,
          margin: const EdgeInsets.only(left: 3.0, bottom: 3.0),
          color: ColorConstants.primary,
          child: DynamicDropDown(
            enableSearch: false,
            fieldName: "includeUser$usersListing",
            dropDownKey: "name",
            dropDownController: controller,
            dropDownData: const [
              {"value": "Yes", "name": "Yes"},
              {"value": "No", "name": "No"},
            ],
          ),
        ),
      ],
    );
  }
}

class DataInputField extends StatelessWidget {
  final int usersListing;
  final int arrUsersInFormRows;
  final String fieldName;
  final TextEditingController controller;
  final double colorOpacity;
  final BorderRadiusGeometry? borderRadius;
  final void Function() onTapForward;
  final num Function() setConditions;

  const DataInputField({
    super.key,
    required this.usersListing,
    required this.arrUsersInFormRows,
    required this.fieldName,
    required this.controller,
    required this.colorOpacity,
    this.borderRadius,
    required this.onTapForward,
    required this.setConditions,
  });

  @override
  Widget build(BuildContext context) {
    num strValue = setConditions();
    (strValue == 0 || strValue == 0.0 || strValue.isNaN || strValue.isFinite == false) ? controller.text = "" : controller.text = strValue.toString();

    return Container(
      height: 70.0,
      margin: const EdgeInsets.only(left: 3.0),
      decoration: BoxDecoration(color: ColorConstants.primary.withValues(alpha: colorOpacity), borderRadius: borderRadius),
      child: Row(
        mainAxisAlignment: arrUsersInFormRows == 1 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          SizedBox(width: 130, child: DynamicTextField(fieldName: fieldName, controller: controller, dataType: "number")),
          if (usersListing != arrUsersInFormRows - 1)
            IconButton(
              icon: const Icon(Icons.forward),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              iconSize: 22.0,
              color: ColorConstants.button,
              splashRadius: 15.0,
              onPressed: () {
                onTapForward();
                Keyboard.close();
              },
            ),
        ],
      ),
    );
  }
}
