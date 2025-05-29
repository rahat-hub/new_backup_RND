import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

import '../../../provider/forms_api_provider.dart';

class FormsIndexLogic extends GetxController {
  var isLoading = false.obs;
  var isLoadingData = false.obs;

  var formTypeList = [].obs;
  var selectedFormType = {}.obs;

  var recordNumbers = [].obs;
  var selectedRecordsNo = {}.obs;

  var userNameList = [].obs;
  var selectedUserName = {}.obs;
  var selectCurrentUser = true;

  var aircraftTypeList = [].obs;
  var selectedAircraftType = {}.obs;

  var formStatus = [].obs;
  var selectedFormStatus = {}.obs;

  var routingDecisions = [].obs;
  var selectedRoutingDecision = {}.obs;

  var currentUserName = "".obs;

  var viewFormsJson = {}.obs;

  var itemList = [].obs;

  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  var selectedStartDate = "".obs;
  var selectedEndDate = "".obs;

  var newFillOutFormData = {}.obs;
  var userMessage = "".obs;

  var disableKeyboard = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadViewFormFilterData();
  }

  Future<void> loadViewFormFilterData() async {
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    Response response = await FormsApiProvider().viewFormFilterData();
    if (response.statusCode == 200) {
      if (UserPermission.pilotAdmin.value ||
          UserPermission.formAuditor.value ||
          UserSessionInfo.systemId == 28 ||
          UserSessionInfo.systemId == 68 ||
          UserPermission.faaViewOnly.value) {
        selectCurrentUser = false;
      }

      if (response.data["data"]["form_type"].isNotEmpty) {
        formTypeList.addAll(response.data["data"]["form_type"]);
      } else {
        formTypeList.addAll([
          {"id": 0, "name": "All"},
          {"id": 0, "name": "No Form Types Found"},
        ]);
      }

      userNameList.add({"id": response.data["data"]["userid"], "name": "-- ${response.data["data"]["user_name"]} --"});

      if (!selectCurrentUser) {
        userNameList.addAll(response.data["data"]["personnel_name"]);
      }

      selectedStartDate.value = DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now.subtract(const Duration(days: 15))).toString();
      startDateController.text = selectedStartDate.value;
      selectedEndDate.value = DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now);
      endDateController.text = selectedEndDate.value;
      aircraftTypeList.addAll(response.data["data"]["aircraft"]);
      formStatus.addAll(response.data["data"]["open_completed"]);
      recordNumbers.addAll(response.data["data"]["records_to_display"]);
      routingDecisions.addAll(response.data["data"]["routing_decision"]);
      currentUserName.value = response.data["data"]["user_name"];

      setInitialSelectedData();
      await loadViewFormAllData(onInit: true);
    }
  }

  void setInitialSelectedData() {
    if (StoragePrefs().lsHasData(key: StorageConstants.viewFormFilterSelectedData)) {
      selectedFormType.value = StoragePrefs().lsRead(key: StorageConstants.viewFormFilterSelectedData)["form_id"] ?? {};
      selectedUserName.value = StoragePrefs().lsRead(key: StorageConstants.viewFormFilterSelectedData)["allUserId"] ?? {};
      selectedStartDate.value = StoragePrefs().lsRead(key: StorageConstants.viewFormFilterSelectedData)["date_start"] ?? selectedStartDate.value;
      startDateController.text = selectedStartDate.value;
      selectedEndDate.value = StoragePrefs().lsRead(key: StorageConstants.viewFormFilterSelectedData)["date_end"] ?? selectedEndDate.value;
      endDateController.text = selectedEndDate.value;
      selectedRecordsNo.value = StoragePrefs().lsRead(key: StorageConstants.viewFormFilterSelectedData)["number_of_results"] ?? {};
      selectedRoutingDecision.value = StoragePrefs().lsRead(key: StorageConstants.viewFormFilterSelectedData)["routing_decision"] ?? {};
    }
  }

  Future<void> loadViewFormAllData({bool refreshed = false, bool onInit = false}) async {
    viewFormsJson.clear();
    itemList.clear();

    isLoadingData.value = true;
    if (!refreshed && !onInit) {
      LoaderHelper.loaderWithGif();
    }

    Response response = await FormsApiProvider().viewFormAllData(
      refreshed,
      data: {
        "form_id":
            selectedFormType.isNotEmpty
                ? selectedFormType["id"].toString()
                : formTypeList.isNotEmpty
                ? formTypeList[0]["id"].toString()
                : "0",
        "allUserId":
            selectedUserName.isNotEmpty
                ? selectedUserName["id"].toString()
                : userNameList.isNotEmpty
                ? selectCurrentUser
                    ? userNameList[0]["id"].toString()
                    : userNameList[1]["id"].toString()
                : "0",
        "system_id": UserSessionInfo.systemId.toString(),
        "user_id": UserSessionInfo.userId.toString(),
        "date_start": selectedStartDate.value,
        "date_end": selectedEndDate.value,
        "ac_searched_for":
            selectedAircraftType.isNotEmpty
                ? selectedAircraftType["id"].toString()
                : aircraftTypeList.isNotEmpty
                ? aircraftTypeList[0]["id"].toString()
                : "0",
        "open_closed_status":
            selectedFormStatus.isNotEmpty
                ? selectedFormStatus["id"].toString()
                : formStatus.isNotEmpty
                ? formStatus[0]["id"].toString()
                : "B",
        "number_of_results":
            selectedRecordsNo.isNotEmpty
                ? selectedRecordsNo["id"].toString()
                : recordNumbers.isNotEmpty
                ? recordNumbers[0]["id"].toString()
                : "10",
        "routing_decision":
            selectedRoutingDecision.isNotEmpty
                ? selectedRoutingDecision["id"].toString()
                : routingDecisions.isNotEmpty
                ? routingDecisions[0]["id"].toString()
                : "0",
      },
    );

    if (response.statusCode == 200) {
      viewFormsJson.addAll(response.data["data"]);
    }
    isLoading.value = false;
    isLoadingData.value = false;
    await EasyLoading.dismiss();
    if (Get.arguments == "afterDelete" && !refreshed) {
      SnackBarHelper.openSnackBar(isError: true, message: "${Get.parameters["formName"]} (ID:${Get.parameters["formId"]}) Deleted Successfully");
    }
  }

  Future<void> saveFilterSelectedValues() async {
    await StoragePrefs().lsWrite(
      key: StorageConstants.viewFormFilterSelectedData,
      value: {
        "form_id": selectedFormType,
        "allUserId": selectedUserName,
        "date_start": selectedStartDate.value,
        "date_end": selectedEndDate.value,
        "open_closed_status": selectedFormStatus,
        "number_of_results": selectedRecordsNo,
        "routing_decision": selectedRoutingDecision,
      },
    );
  }

  Future<void> getNewFillOutFormId({required String masterFormId}) async {
    Response response = await FormsApiProvider().createNewFillOutFormId(masterFormId: masterFormId);
    if (response.statusCode == 200) {
      newFillOutFormData.addAll(response.data["data"]);
      userMessage.value =
          response.data["userMessage"].replaceAll("Form Form", "Form") ??
          "New ${newFillOutFormData["form_name"]}${newFillOutFormData["form_name"].endsWith("Form") ? "" : " Form"} Created (ID: ${newFillOutFormData["form_id"]})";
    }
  }
}
