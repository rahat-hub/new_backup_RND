import 'dart:convert';
import 'dart:math';

import 'package:aviation_rnd/modules/form_modules/view_user_form/view_user_form/view_user_form_top_bottom_layers.dart';
import 'package:aviation_rnd/shared/services/pdf_styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/date_time_helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../helper/pdf_helper.dart';
import '../../../helper/snack_bar_helper.dart';
import '../../../provider/forms_api_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/constants/constant_assets.dart';
import '../../../shared/constants/constant_colors.dart';
import '../../../shared/constants/constant_urls.dart';
import '../../../shared/services/keyboard.dart';
import '../../../shared/services/theme_color_mode.dart';
import '../../../shared/utils/logged_in_data.dart';
import '../../../widgets/form_widgets.dart';
import '../form_designer_js.dart';

class ViewUserFormLogic extends GetxController with GetTickerProviderStateMixin, FormDesignerJs {
  var viewUserFormAllData = {}.obs;
  var viewUserFormData = {}.obs;

  var pageList = [].obs;
  var rowsData = [].obs;
  var pdfData = [].obs;

  var myTabs = <Tab>[].obs;
  late Rx<TabController> tabController;

  //var screenshotController = ScreenshotController();
  var viewUserFormInputControllers = <String, TextEditingController>{}.obs;
  var viewUserFormValidator = <String, GlobalKey<FormFieldState>>{}.obs;
  var signatureController = <String, SignatureController>{}.obs;

  var widgetsForEachRow = <Widget>[].obs;
  var widgetsForEachTab = <Widget>[].obs;

  var formsViewDetails = <String, dynamic>{}.obs;
  var formFieldValues = <String, String>{}.obs;
  var formAttachmentFiles = [].obs;
  var showMore = false.obs;
  var createdFields = [].obs;
  var userDropDownData = [].obs;
  var selectedUserData = {}.obs;

  var formName = "".obs;
  var isLoading = false.obs;

  var postProcessingAllData = <String, dynamic>{};
  var doPostProcessing = false;
  var emailSarAndShiftSummaryReports = false;

  @override
  void onInit() async {
    super.onInit();
    await initFormDesignerPostProcessing();
    await getInitialViewUserFormData(doPostProcessing: doPostProcessing.toString());
  }

  Future<void> initFormDesignerPostProcessing() async {
    isLoading.value = true;
    await LoaderHelper.loaderWithGif();

    Response postProcessingResponse = await FormsApiProvider().formDesignerPostProcessingReports(
      fillOutFormId: Get.parameters["formId"] ?? lastViewedFormId,
      saveAndComplete: Get.parameters["saveAndComplete"] ?? "",
      alreadyCompleted: Get.parameters["alreadyCompleted"] ?? "",
      linkedFormFieldAction: Get.parameters["linkedFormFieldAction"] ?? "",
      showStatusMessage: Get.parameters["showStatusMessage"] ?? "false",
      optionalAction: "",
    );

    if (postProcessingResponse.statusCode == 200) {
      postProcessingAllData = postProcessingResponse.data["data"];
      doPostProcessing = postProcessingAllData["doPostProcessing"] ?? false;
      emailSarAndShiftSummaryReports = postProcessingAllData["emailSarAndShiftSummaryReports"] ?? false;
    }
  }

  Future<void> getInitialViewUserFormData({bool reload = false, String doPostProcessing = "false"}) async {
    if (reload) {
      isLoading.value = true;
      await LoaderHelper.loaderWithGif();
    }

    Response response = await FormsApiProvider().getInitialViewUserFormData(
      fillOutFormId: Get.parameters["formId"] ?? viewUserFormAllData["formId"],
      masterFormId: Get.parameters["masterFormId"] ?? formsViewDetails["formId"],
      lastViewedFormId: lastViewedFormId,
      doPostProcessing: doPostProcessing,
    );
    if (response.statusCode == 200) {
      viewUserFormAllData.clear();
      viewUserFormData.clear();
      formsViewDetails.clear();
      pageList.clear();

      viewUserFormAllData.addAll(response.data["data"]);
      viewUserFormData.addAll(viewUserFormAllData["viewUserForm"]);
      formsViewDetails.addAll(viewUserFormData["formsViewDetails"]);
      formName.value = formsViewDetails["formName"];

      for (int i = 0; i < viewUserFormData["objFormEditUsersChoicesList"].length; i++) {
        formFieldValues.addIf(
          true,
          viewUserFormData["objFormEditUsersChoicesList"][i]["formFieldId"].toString(),
          viewUserFormData["objFormEditUsersChoicesList"][i]["formFieldValue"].toString(),
        );
      }

      formAttachmentFiles.value = viewUserFormData["objFormUploadFiles"] ?? [];

      pageList.addAll(viewUserFormAllData["tabs"]);

      await getAndSetTab(reload);
    }
  }

  Future<void> getAndSetTab(bool refreshed) async {
    myTabs.clear();
    for (int i = 0; i < pageList.length; i++) {
      myTabs.add(Tab(height: 42 * Get.textScaleFactor, child: Text(pageList[i]["tabName"])));
    }
    tabController = TabController(length: myTabs.length, vsync: this).obs;

    await tabView(refreshed: refreshed);
  }

  Future<void> tabView({bool refreshed = false}) async {
    widgetsForEachTab.clear();
    rowsData.clear();
    pdfData.clear();
    num a = 0;

    for (int i = 0; i < pageList.length; i++) {
      rowsData.add(pageList[i]["rows"]);

      for (int j = 0; j < pageList[i]["rows"].length; j++) {
        for (int k = 0; k < rowsData[i][j]["columns"].length; k++) {
          if (rowsData[i][j]["columns"][k]["cssClassName"] != null && rowsData[i][j]["columns"][k]["cssClassName"] != '') {
            var fieldClass = rowsData[i][j]["columns"][k]["cssClassName"].toString().split(" ");
            for (var key in fieldClass) {
              jsClass[key.trim()]?.addIf(jsClass[key.trim()]?.contains(rowsData[i][j]["columns"][k]["id"].toString()) == false, rowsData[i][j]["columns"][k]["id"].toString());
            }
          }
        }
      }

      for (int j = 0; j < pageList[i]["rows"].length; j++) {
        for (int k = 0; k < rowsData[i][j]["columns"].length; k++) {
          switch (rowsData[i][j]["columns"][k]["formFieldType"] as int) {
            case 4: //"DROP DOWN - ACCESSIBLE AIRCRAFT":
              strACPrimaryField = int.tryParse(viewUserFormAllData["acPrimaryField"].toString()) ?? 0;
              if (formFieldValues[strACPrimaryField.toString()] != null) {
                Response response = await formsApiProvider.generalAPICall(
                  apiCallType: "POST",
                  showSnackBar: false,
                  url: "/forms/load_ac_data",
                  postData: {
                    "system_id": UserSessionInfo.systemId.toString(),
                    "user_id": UserSessionInfo.userId.toString(),
                    "aircraft_id": formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString(),
                  },
                );
                if (response.statusCode == 200 && response.data["data"].isNotEmpty) {
                  var data = response.data["data"]["0"];
                  strStartsName = data["1000"]; //Starts Name
                  strBillableHobbsName = data["1001"]; //Billable Hobbs Name
                  strEngine2Enabled = data["1002"]; //Engine 2 Enabled?

                  await setupAircraftFields(strStartsName: strStartsName, strBillableHobbsName: strBillableHobbsName, strEngine2Enabled: strEngine2Enabled);
                }
              }
              break;

            case 28: //"TEXT FIELD (EXTENDED)":
              if (int.tryParse(formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString()) != null) {
                await loadExtendedField(
                  strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                  strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                  strNarrativeID: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString(),
                );
              }
              break;

            case 152: //"MEDICATION SELECTOR":
              if (int.tryParse(formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString()) != null) {
                await loadExtendedField(
                  strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                  strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                  strNarrativeID: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString(),
                );
              }
              if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                await saveSelectMultipleFinalVenom(
                  strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                  strFormFieldNarrativeID: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString(),
                  strData: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()],
                );
              }
              break;

            case 35 || 199: //"FLIGHT OPS DOCUMENT SELECTOR" || "DROP DOWN VIA SERVICE TABLE VALUES":
              if (rowsData[i][j]["columns"][k]["formFieldStSelectMany"] && !rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"]) {
                if (int.tryParse(formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString()) != null) {
                  await loadExtendedField(
                    strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                    strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                    strNarrativeID: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString(),
                  );
                }
              }
              break;
          }
        }
        pdfData.add(rowsData[i][j]["columns"]);

        if (pdfData.length > a) {
          pdfData[a.toInt()][0].putIfAbsent("tabName", () => "Page Name: ${pageList[i]["tabName"]}");
          a += pageList[i]["rows"].length;
        }
      }
    }

    for (int i = 0; i < pageList.length; i++) {
      widgetsForEachTab.add(rowView(i));
    }

    isLoading.value = false;
    await EasyLoading.dismiss();
    lastViewedFormId = Get.parameters["formId"] ?? viewUserFormAllData["formId"].toString();
    if (Get.arguments == "afterSave" && !refreshed) {
      await initialPostProcessing();

      SnackBarHelper.openSnackBar(
        title: Get.parameters["performCloseOut"]?.toUpperCase() == "YES" ? "Save & Submit Form" : "Save Form",
        message: "${Get.parameters["formName"]} ${Get.parameters["performCloseOut"]?.toUpperCase() == "YES" ? "Save & Submitted Successfully" : "Saved Successfully"}",
      );
    }
  }

  RefreshIndicator rowView(i) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration.zero, () async {
          await getInitialViewUserFormData(reload: true);
        });
      },
      child: ListView.builder(
        itemCount: pageList[i]["rows"].length,
        shrinkWrap: true,
        itemBuilder: (context, j) {
          return Padding(
            padding:
                createdFields.contains(rowsData[i][j]["columns"].length > 1 ? rowsData[i][j]["columns"][1]["id"].toString() : rowsData[i][j]["columns"][0]["id"].toString()) &&
                        widgetsForEachRow.isEmpty
                    ? const EdgeInsets.symmetric(horizontal: 5.0)
                    : const EdgeInsets.all(5.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(5),
              shadowColor: Colors.blue,
              color:
                  rowsData[i][j]["formRowBgColor"] != ""
                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                      : ThemeColorMode.isDark
                      ? Colors.grey[900]
                      : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Wrap(
                  alignment: rowsData[i][j]["columns"][0]["formFieldType"] == 127 && rowsData[i][j]["columns"].length == 2 ? WrapAlignment.start : WrapAlignment.spaceBetween,
                  children: widgetView(i: i, j: j),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> widgetView({i, j}) {
    widgetsForEachRow.clear();
    for (int k = 0; k < rowsData[i][j]["columns"].length; k++) {
      switch (rowsData[i][j]["columns"][k]["formFieldType"] as int) {
        //General Fields
        /*case "------ FIELDS FOR PILOT PROFILES -------":
        case "--------------GENERAL FIELDS---------------":
        case "---- FIELDS FOR SELECTED AIRCRAFT ----":
        case "--------- FORMATTING FIELDS ----------":
        case "---- FIELDS FOR PRATT WHITNEY --":
        case "--------- FUEL FARM FIELDS ----------":
        case "--------- FORM CHOOSER ----------":
        case "--------- SIGNATURE FIELDS ----------":
        case "---- FIELDS SHOWN IF NPNG AIRCRAFT ----------":
        case "---------------- APU FIELDS ------------------":
        case "--------- MISC AIRCRAFT FIELDS ----------":
        case "--------- AUTOMATION FIELDS ----------":
        case "--------- USER ROLES ----------":


          break;*/

        //Text Fields
        case 1: //"TEXT FIELD (STANDARD)":
        case 37: //"NUMBER - INTEGER/WHOLE NUMBER":
        case 38: //"NUMBER - DECIMAL 1 PLACE":
        case 39: //"NUMBER - DECIMAL 2 PLACES":
        case 40: //"NUMBER - DECIMAL 3 PLACES":
        case 41: //"NUMBER - DECIMAL 4 PLACES":
        case 42: //"ACCESSORIES SELECTOR - HOBBS AUGMENT":
        case 43: //"ACCESSORIES SELECTOR - CYCLES AUGMENT":
        case 122: //"FAR PART 91 HOURS (TOTAL)":
        case 123: //"FAR PART 135 HOURS (TOTAL)":
        case 125: //UNKNOWN
        case 126: //"HIDDEN DATA FIELD":
        case 24: //"DATE (FLIGHT DATE)":
        case 5: //"DATE (OTHER DATE)":
        case 7: //"TIME (HH:MM)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue:
                  formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] == "1900-01-01"
                      ? null
                      : formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? (rowsData[i][j]["columns"][k]["formFieldType"] == 5 ? "" : null),
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case 28: //"TEXT FIELD (EXTENDED)":
          widgetsForEachRow.add(
            GetBuilder<ViewUserFormLogic>(
              init: ViewUserFormLogic(),
              builder: (controller) {
                return TextWithIconButton(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  multiple: rowsData[i][j]["columns"].length > 1,
                  fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                  fieldValue: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] ?? "",
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                );
              },
            ),
          );
          break;

        //Check Boxes
        //Automation Fields
        case 2: //"CHECK BOX (YES/NO)":
        case 143: //"FAA LASER STRIKE REPORTING":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: "",
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              icon:
                  formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] != null
                      ? formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] == "on"
                          ? Icons.check_box
                          : Icons.check_box_outline_blank
                      : rowsData[i][j]["columns"][k]["defaultValue"].toLowerCase() == "checked"
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
              iconColor:
                  formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] != null
                      ? formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] == "on"
                          ? ColorConstants.primary
                          : ColorConstants.grey
                      : rowsData[i][j]["columns"][k]["defaultValue"].toLowerCase() == "checked"
                      ? ColorConstants.primary
                      : ColorConstants.grey,
            ),
          );
          break;

        //Dropdowns
        case 4: //"DROP DOWN - ACCESSIBLE AIRCRAFT":
        case 6: //"DROP DOWN - ALL USERS":
        case 27: //"DROP DOWN - NUMBERS 0-50":
        case 31: //"DROP DOWN - NUMBERS 0-100":
        case 32: //"DROP DOWN - NUMBERS 0-150":
        case 25: //"DROP DOWN - CUSTOMERS":
        case 250: //"ACCESSORIES SELECTOR":
        case 3: //"DROP DOWN - FOR TRIGGERED FIELDS ONLY":
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()]) {
              fieldValue = element["name"];
            }
          });
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue:
                  rowsData[i][j]["columns"][k]["formFieldType"] == 6
                      ? fieldValue ?? ""
                      : rowsData[i][j]["columns"][k]["accessibleAircraft"]["aircraft"].isEmpty
                      ? fieldValue?.replaceAll(RegExp(r'[-*]'), "")
                      : rowsData[i][j]["columns"][k]["accessibleAircraft"]["aircraft"],
              bold: (rowsData[i][j]["columns"][k]["formFieldType"] == 6 || rowsData[i][j]["columns"][k]["formFieldType"] == 250) ? true : null,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        //Hybrid or Combined
        case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
              fieldValue = element["name"];
            }
          });
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue:
                  rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"]
                      ? formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()]
                      : rowsData[i][j]["columns"][k]["formFieldStSelectMany"]
                      ? extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != ""
                          ? extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                          : null
                      : fieldValue,
              bold: rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"] && rowsData[i][j]["columns"][k]["formFieldStSelectMany"] ? true : null,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        //CloseOut Form Fields
        case 160: //"ACCESSORIES WITH CYCLES+HOBBS":
          var fieldValues = formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()]?.split(",");
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == fieldValues?[0]) {
              fieldValue = element["name"];
            }
          });
          widgetsForEachRow.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithIconButton(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  multiple: rowsData[i][j]["columns"].length > 1,
                  fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                  fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextWithIconButton(
                          id: rowsData[i][j]["columns"][k]["id"],
                          rowColor: rowsData[i][j]["formRowBgColor"],
                          multiple: rowsData[i][j]["columns"].length > 1,
                          fieldName: "Cycles Start",
                          fieldValue: fieldValue != "None" ? (fieldValues?[1] ?? "") : "",
                          hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                        ),
                        TextWithIconButton(
                          id: rowsData[i][j]["columns"][k]["id"],
                          rowColor: rowsData[i][j]["formRowBgColor"],
                          multiple: rowsData[i][j]["columns"].length > 1,
                          fieldName: "Cycles To Add",
                          fieldValue: fieldValue != "None" ? (fieldValues?[2] ?? "") : "",
                          hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                        ),
                        TextWithIconButton(
                          id: rowsData[i][j]["columns"][k]["id"],
                          rowColor: rowsData[i][j]["formRowBgColor"],
                          multiple: rowsData[i][j]["columns"].length > 1,
                          fieldName: "Cycles End",
                          fieldValue: fieldValue != "None" ? (fieldValues?[3] ?? "") : "",
                          hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextWithIconButton(
                          id: rowsData[i][j]["columns"][k]["id"],
                          rowColor: rowsData[i][j]["formRowBgColor"],
                          multiple: rowsData[i][j]["columns"].length > 1,
                          fieldName: "Hobbs Start",
                          fieldValue: fieldValue != "None" ? (fieldValues?[4] ?? "") : "",
                          hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                        ),
                        TextWithIconButton(
                          id: rowsData[i][j]["columns"][k]["id"],
                          rowColor: rowsData[i][j]["formRowBgColor"],
                          multiple: rowsData[i][j]["columns"].length > 1,
                          fieldName: "Hobbs To Add",
                          fieldValue: fieldValue != "None" ? (fieldValues?[5] ?? "") : "",
                          hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                        ),
                        TextWithIconButton(
                          id: rowsData[i][j]["columns"][k]["id"],
                          rowColor: rowsData[i][j]["formRowBgColor"],
                          multiple: rowsData[i][j]["columns"].length > 1,
                          fieldName: "Hobbs End",
                          fieldValue: fieldValue != "None" ? (fieldValues?[6] ?? "") : "",
                          hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
          break;

        //Select Multiple
        case 35: //"FLIGHT OPS DOCUMENT SELECTOR":
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue:
                  extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != ""
                      ? extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                      : null,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case 152: //"MEDICATION SELECTOR":
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case 26: //"GPS COORDINATES - DDD MM.MMM FORMAT":
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue:
                  formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] != null
                      ? formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString().replaceAll("N", "' \"N").replaceAll("W", "' \"W")
                      : "",
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              icon: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? Icons.public : null,
              iconColor: ColorConstants.icon,
              onTap: () async {
                var strThisCoordinates = formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString().trim();
                if (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] == null) strThisCoordinates = "";
                strThisCoordinates = strThisCoordinates.replaceAll("°", "").replaceAll("N", "").replaceAll("W", "");
                var strThisCoordinatesSplit = strThisCoordinates.split(" ");
                var gpsN0 = int.parse(strThisCoordinatesSplit[0]);
                var gpsN1 = double.parse(strThisCoordinatesSplit[1]);
                var gpsW0 = int.parse(strThisCoordinatesSplit[2]);
                var gpsW1 = double.parse(strThisCoordinatesSplit[3]);

                if (gpsN0 > 0) {
                  var gpsLat = (((gpsN1) / 60) + gpsN0).toStringAsFixed(6);
                  var gpsLong = (((gpsW1) / 60) + gpsW0).toStringAsFixed(6);

                  Uri url = Uri.parse("${UrlConstants.googleMapsLocation}/$gpsLat,-$gpsLong");
                  var urlLaunchAble = await canLaunchUrl(url);
                  if (urlLaunchAble) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    SnackBarHelper.openSnackBar(isError: true, message: "Map URL can't be launched!");
                  }
                } else {
                  SnackBarHelper.openSnackBar(isError: true, message: "Invalid Location Data!");
                }
              },
            ),
          );
          break;

        //Field for Pilot Profiles

        //Text Fields
        case 61: //"PIC TIME":
        case 62: //"SIC TIME":
        case 63: //"NVG TIME":
        case 64: //"DAY FLIGHT TIME":
        case 65: //"NIGHT FLIGHT TIME":
        case 68: //"INSTRUMENT TIME (ACTUAL)":
        case 69: //"INSTRUMENT TIME (SIMULATED)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: double.tryParse(formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        //Dropdowns
        case 66: //"DAY LANDINGS":
        case 67: //"NIGHT LANDINGS":
        case 70: //"APPROACHES (ILS)":
        case 71: //"APPROACHES (LOCALIZER)":
        case 72: //"APPROACHES (LPV)":
        case 73: //"APPROACHES (LNAV)":
        case 74: //"APPROACHES (VOR)":
        case 75: //"OPERATIONS (HNVGO)":
        case 91: //"AIRCRAFT REPOSITION TO BASE":
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
              fieldValue = double.tryParse(element["name"].toString())?.toStringAsFixed(1) ?? element["name"] ?? "0.0";
            }
          });
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        //Fields for Selected Aircraft
        //Fields Shown IF NPNG Aircraft
        //Fields For Pratt Whitney
        //Apu Fields
        //Fuel Farm Fields
        //Fields Shown If Cycles IM/PT/CT
        //Fields For CAT/AVCS/MTOW Aircraft
        //CloseOut Form Fields
        case 8 || 9 || 12 || 14 || 97 || 110 || 13 || 15 || 107 || 119 || 76 || 79 || 82 || 85 || 88 || 101 || 104 || 113 || 116 || 29 || 94 || 33: //CloseOut Fields (Forward)
        case 131 || 134 || 137 || 140 || 145 || 148 || 44 || 47 || 151 || 163 || 166 || 169 || 172 || 175 || 178 || 181 || 184 || 187 || 190 || 193 || 196:
        case 251 || 254 || 257 || 260: //--- These fields don't have a traditional header / title
          /*case 8: //"AIRCRAFT FLT HOBBS (START)":
        case 9: //"AIRCRAFT BILL-MISC HOBBS (START)":
        case 145: //"AUX HOBBS (START)":
        case 151: //"AIRCRAFT TOTAL TIME (START)":
        case 29: //"LANDINGS (START)":
        case 94: //"LANDINGS - RUN ON (START)":
        case 33: //"TORQUE EVENTS (START)":
        case 44: //"HOIST CYCLES (START)":
        case 47: //"HOOK CYCLES (START)":
        case 12: //"E1: STARTS/N1/NG/CCY/CT/CT (START)":
        case 14: //"E2: STARTS/N1/NG/CCY/CT/CT (START)":
        case 97: //"E3: STARTS/N1/NG/CCY/CT/CT (START)":
        case 110: //"E4: STARTS/N1/NG/CCY/CT/CT (START)":
        case 85: //"E1: N2/PCY/PT1/PT1 (START)":
        case 88: //"E2: N2/PCY/PT1/PT1 (START)":
        case 101: //"E3: N2/PCY/PT1/PT1 (START)":
        case 113: //"E4: N2/PCY/PT1/PT1 (START)":
        case 76: //"E1: TOTAL TIME (START)":
        case 79: //"E2: TOTAL TIME (START)":
        case 104: //"E3: TOTAL TIME (START)":
        case 116: //"E4: TOTAL TIME (START)":
        case 13: //"E1: NPNF/ICY/IMP/IMP (START)":
        case 15: //"E2: NPNF/ICY/IMP/IMP (START)":
        case 107: //"E3: NPNF/ICY/IMP/IMP (START)":
        case 119: //"E4: NPNF/ICY/IMP/IMP (START)":
        case 131: //"E1: PRATT ENGINE CYCLES (START)":
        case 134: //"E2: PRATT ENGINE CYCLES (START)":
        case 137: //"E3: PRATT ENGINE CYCLES (START)":
        case 140: //"E4: PRATT ENGINE CYCLES (START)":
        case 82: //"APU: TOTAL TIME (START)":
        case 148: //"FUEL FARM FILLED BEGINNING AMOUNT":
        case 163: //"E1: CT COVER (START)":
        case 166: //"E2: CT COVER (START)":
        case 169: //"E1: CT CREEP (START)":
        case 172: //"E2: CT CREEP (START)":
        case 175: //"E1: HP COMPRESSOR (START)":
        case 178: //"E2: HP COMPRESSOR (START)":
        case 181: //"E1: PT 1 CREEP (START)":
        case 184: //"E2: PT 1 CREEP (START)":
        case 187: //"E1: PT 2 CREEP (START)":
        case 190: //"E2: PT 2 CREEP (START)":
        case 193: //"E1: PT 2 DISC (START)":
        case 196: //"E2: PT 2 DISC (START)":
        case 251: //"CAT.A Operations (Start)":
        case 254: //"AVCS INOP (Start)":
        case 257: //"MTOW FHS (Start)":
        case 260: //"MTOW LDS (Start)":*/
          var fieldName = rowsData[i][j]["columns"][k]["fieldName"].toUpperCase().replaceAll(" (START)", '').replaceAll(" BEGINNING AMOUNT", '');
          if (rowsData[i][j]["columns"].length > k + 1 &&
              (rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}" ||
                  rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}")) {
            if (rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}") {
              if (rowsData[i][j]["columns"].length > k + 2) {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j]["columns"][k + 1]["id"].toString());
                createdFields.add(rowsData[i][j]["columns"][k + 2]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k + 1]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k + 1]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"])["label"]} (To Add)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k + 1]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                      ),
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k + 2]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k + 2]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k + 2]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k + 2]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k + 2]["formFieldType"])["label"]} (Ending)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k + 2]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k + 2]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                      ),
                    ],
                  ),
                );
              } else {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j]["columns"][k + 1]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k + 1]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k + 1]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"])["label"]} (To Add)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k + 1]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                      ),
                    ],
                  ),
                );
              }
            } else if (rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}") {
              if (rowsData[i][j]["columns"].length > k + 2) {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j]["columns"][k + 1]["id"].toString());
                createdFields.add(rowsData[i][j]["columns"][k + 2]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k + 1]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k + 1]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"])["label"]} (Ending)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k + 1]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                      ),
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k + 2]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k + 2]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k + 2]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k + 2]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k + 2]["formFieldType"])["label"]} (To Add)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k + 2]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k + 2]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                      ),
                    ],
                  ),
                );
              } else {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j]["columns"][k + 1]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k + 1]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k + 1]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"])["label"]} (Ending)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k + 1]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k + 1]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                      ),
                    ],
                  ),
                );
              }
            }
          } else if (rowsData[i].length > j + 1 &&
              rowsData[i][j + 1]["columns"].length > k &&
              (rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}" ||
                  rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}")) {
            if (rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}") {
              if (rowsData[i].length > j + 2) {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j + 1]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j + 2]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][j + 1]["formRowBgColor"] != ""
                                ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextWithIconButton(
                            id: rowsData[i][j + 1]["columns"][k]["id"],
                            rowColor: rowsData[i][j + 1]["formRowBgColor"],
                            multiple: rowsData[i][j + 1]["columns"].length > 1,
                            fieldName: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                            closeOutFieldMode:
                                "${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j + 1]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"])["label"]} (To Add)",
                            fieldValue:
                                closeOutAircraftFields(
                                  id: rowsData[i][j + 1]["columns"][k]["id"].toString(),
                                  strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"],
                                )["fieldValue"],
                            hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                          ),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][j + 2]["formRowBgColor"] != ""
                                ? rowsData[i][j + 2]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][j + 2]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][j + 2]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextWithIconButton(
                            id: rowsData[i][j + 2]["columns"][k]["id"],
                            rowColor: rowsData[i][j + 2]["formRowBgColor"],
                            multiple: rowsData[i][j + 2]["columns"].length > 1,
                            fieldName: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                            closeOutFieldMode:
                                "${htmlValues[rowsData[i][j + 2]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j + 2]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j + 2]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j + 2]["columns"][k]["formFieldType"])["label"]} (Ending)",
                            fieldValue:
                                closeOutAircraftFields(
                                  id: rowsData[i][j + 2]["columns"][k]["id"].toString(),
                                  strFormFieldType: rowsData[i][j + 2]["columns"][k]["formFieldType"],
                                )["fieldValue"],
                            hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j + 1]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][j + 1]["formRowBgColor"] != ""
                                ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextWithIconButton(
                            id: rowsData[i][j + 1]["columns"][k]["id"],
                            rowColor: rowsData[i][j + 1]["formRowBgColor"],
                            multiple: rowsData[i][j + 1]["columns"].length > 1,
                            fieldName: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                            closeOutFieldMode:
                                "${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j + 1]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"])["label"]} (To Add)",
                            fieldValue:
                                closeOutAircraftFields(
                                  id: rowsData[i][j + 1]["columns"][k]["id"].toString(),
                                  strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"],
                                )["fieldValue"],
                            hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else if (rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}") {
              if (rowsData[i].length > j + 2) {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j + 1]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j + 2]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][j + 1]["formRowBgColor"] != ""
                                ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextWithIconButton(
                            id: rowsData[i][j + 1]["columns"][k]["id"],
                            rowColor: rowsData[i][j + 1]["formRowBgColor"],
                            multiple: rowsData[i][j + 1]["columns"].length > 1,
                            fieldName: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                            closeOutFieldMode:
                                "${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j + 1]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"])["label"]} (Ending)",
                            fieldValue:
                                closeOutAircraftFields(
                                  id: rowsData[i][j + 1]["columns"][k]["id"].toString(),
                                  strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"],
                                )["fieldValue"],
                            hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                          ),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][j + 2]["formRowBgColor"] != ""
                                ? rowsData[i][j + 2]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][j + 2]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][j + 2]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextWithIconButton(
                            id: rowsData[i][j + 2]["columns"][k]["id"],
                            rowColor: rowsData[i][j + 2]["formRowBgColor"],
                            multiple: rowsData[i][j + 2]["columns"].length > 1,
                            fieldName: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                            closeOutFieldMode:
                                "${htmlValues[rowsData[i][j + 2]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j + 2]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j + 2]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j + 2]["columns"][k]["formFieldType"])["label"]} (To Add)",
                            fieldValue:
                                closeOutAircraftFields(
                                  id: rowsData[i][j + 2]["columns"][k]["id"].toString(),
                                  strFormFieldType: rowsData[i][j + 2]["columns"][k]["formFieldType"],
                                )["fieldValue"],
                            hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.add(rowsData[i][j + 1]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  Column(
                    children: [
                      TextWithIconButton(
                        id: rowsData[i][j]["columns"][k]["id"],
                        rowColor: rowsData[i][j]["formRowBgColor"],
                        multiple: rowsData[i][j]["columns"].length > 1,
                        fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(
                              id: rowsData[i][j]["columns"][k]["id"].toString(),
                              strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"],
                            )["fieldValue"],
                        hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][j + 1]["formRowBgColor"] != ""
                                ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextWithIconButton(
                            id: rowsData[i][j + 1]["columns"][k]["id"],
                            rowColor: rowsData[i][j + 1]["formRowBgColor"],
                            multiple: rowsData[i][j + 1]["columns"].length > 1,
                            fieldName: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                            closeOutFieldMode:
                                "${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j + 1]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"])["label"]} (Ending)",
                            fieldValue:
                                closeOutAircraftFields(
                                  id: rowsData[i][j + 1]["columns"][k]["id"].toString(),
                                  strFormFieldType: rowsData[i][j + 1]["columns"][k]["formFieldType"],
                                )["fieldValue"],
                            hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          } else {
            createdFields.add(rowsData[i][j]["columns"][k]["id"].toString());
            widgetsForEachRow.add(
              TextWithIconButton(
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                multiple: rowsData[i][j]["columns"].length > 1,
                fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                closeOutFieldMode:
                    "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Forward)",
                fieldValue:
                    closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["fieldValue"],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          }
          break;

        case 55 || 56 || 57 || 58 || 98 || 111 || 59 || 60 || 108 || 120 || 77 || 80 || 83 || 86 || 89 || 102 || 105 || 114 || 117 || 22 || 95 || 23: //CloseOut Fields (To Add)
        case 132 || 135 || 138 || 141 || 146 || 149 || 45 || 48 || 158 || 164 || 167 || 170 || 173 || 176 || 179 || 182 || 185 || 188 || 191 || 194 || 197:
        case 252 || 255 || 258 || 261: //--- These fields don't have a traditional header / title
          /*case 55: //"AIRCRAFT FLT HOBBS (TO ADD)":
        case 56: //"AIRCRAFT BILL-MISC HOBBS (TO ADD)":
        case 146: //"AUX HOBBS (TO ADD)":
        case 158: //"AIRCRAFT TOTAL TIME (TO ADD)":
        case 22: //"LANDINGS (TO ADD)":
        case 95: //"LANDINGS - RUN ON (TO ADD)":
        case 23: //"TORQUE EVENTS (TO ADD)":
        case 45: //"HOIST CYCLES (TO ADD)":
        case 48: //"HOOK CYCLES (TO ADD)":
        case 57: //"E1: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 58: //"E2: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 98: //"E3: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 111: //"E4: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 86: //"E1: N2/PCY/PT1/PT1 (TO ADD)":
        case 89: //"E2: N2/PCY/PT1/PT1 (TO ADD)":
        case 102: //"E3: N2/PCY/PT1/PT1 (TO ADD)":
        case 114: //"E4: N2/PCY/PT1/PT1 (TO ADD)":
        case 77: //"E1: TOTAL TIME (TO ADD)":
        case 80: //"E2: TOTAL TIME (TO ADD)":
        case 105: //"E3: TOTAL TIME (TO ADD)":
        case 117: //"E4: TOTAL TIME (TO ADD)":
        case 59: //"E1: NPNF/ICY/IMP/IMP (TO ADD)":
        case 60: //"E2: NPNF/ICY/IMP/IMP (TO ADD)":
        case 108: //"E3: NPNF/ICY/IMP/IMP (TO ADD)":
        case 120: //"E4: NPNF/ICY/IMP/IMP (TO ADD)":
        case 132: //"E1: PRATT ENGINE CYCLES (TO ADD)":
        case 135: //"E2: PRATT ENGINE CYCLES (TO ADD)":
        case 138: //"E3: PRATT ENGINE CYCLES (TO ADD)":
        case 141: //"E4: PRATT ENGINE CYCLES (TO ADD)":
        case 83: //"APU: TOTAL TIME (TO ADD)":
        case 149: //"FUEL FARM FILLED TO ADD":
        case 164: //"E1: CT COVER (TO ADD)":
        case 167: //"E2: CT COVER (TO ADD)":
        case 170: //"E1: CT CREEP (TO ADD)":
        case 173: //"E2: CT CREEP (TO ADD)":
        case 176: //"E1: HP COMPRESSOR (TO ADD)":
        case 179: //"E2: HP COMPRESSOR (TO ADD)":
        case 182: //"E1: PT 1 CREEP (TO ADD)":
        case 185: //"E2: PT 1 CREEP (TO ADD)":
        case 188: //"E1: PT 2 CREEP (TO ADD)":
        case 191: //"E2: PT 2 CREEP (TO ADD)":
        case 194: //"E1: PT 2 DISC (TO ADD)":
        case 197: //"E2: PT 2 DISC (TO ADD)":
        case 252: //"CAT.A Operations (To Add)":
        case 255: //"AVCS INOP (To Add)":
        case 258: //"MTOW FHS (To Add)":
        case 261: //"MTOW LDS (To Add)":*/
          if (!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString())) {
            widgetsForEachRow.add(
              TextWithIconButton(
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                multiple: rowsData[i][j]["columns"].length > 1,
                fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                closeOutFieldMode:
                    "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (To Add)",
                fieldValue:
                    closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["fieldValue"],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          }
          break;

        case 16 || 17 || 18 || 19 || 100 || 112 || 20 || 21 || 109 || 121 || 78 || 81 || 84 || 87 || 90 || 103 || 106 || 115 || 118 || 30 || 96 || 34: //CloseOut Fields (End)
        case 133 || 136 || 139 || 142 || 147 || 150 || 46 || 49 || 159 || 165 || 168 || 171 || 174 || 177 || 180 || 183 || 186 || 189 || 192 || 195 || 198:
        case 253 || 256 || 259 || 262: //--- These fields don't have a traditional header / title
          /*case 16: //"AIRCRAFT FLT HOBBS (END)":
        case 17: //"AIRCRAFT BILL-MISC HOBBS (END)":
        case 147: //"AUX HOBBS (END)":
        case 159: //"AIRCRAFT TOTAL TIME (END)":
        case 30: //"LANDINGS (END)":
        case 96: //"LANDINGS - RUN ON (END)":
        case 34: //"TORQUE EVENTS (END)":
        case 46: //"HOIST CYCLES (END)":
        case 49: //"HOOK CYCLES (END)":
        case 18: //"E1: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 19: //"E2: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 100: //"E3: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 112: //"E4: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 87: //"E1: N2/PCY/PT1/PT1 (END)":
        case 90: //"E2: N2/PCY/PT1/PT1 (END)":
        case 103: //"E3: N2/PCY/PT1/PT1 (END)":
        case 115: //"E4: N2/PCY/PT1/PT1 (END)":
        case 78: //"E1: TOTAL TIME (END)":
        case 81: //"E2: TOTAL TIME (END)":
        case 106: //"E3: TOTAL TIME (END)":
        case 118: //"E4: TOTAL TIME (END)":
        case 20: //"E1: NPNF/ICY/IMP/IMP (END)":
        case 21: //"E2: NPNF/ICY/IMP/IMP (END)":
        case 109: //"E3: NPNF/ICY/IMP/IMP (END)":
        case 121: //"E4: NPNF/ICY/IMP/IMP (END)":
        case 133: //"E1: PRATT ENGINE CYCLES (END)":
        case 136: //"E2: PRATT ENGINE CYCLES (END)":
        case 139: //"E3: PRATT ENGINE CYCLES (END)":
        case 142: //"E4: PRATT ENGINE CYCLES (END)":
        case 84: //"APU: TOTAL TIME (END)":
        case 150: //"FUEL FARM FILLED ENDING AMOUNT":
        case 165: //"E1: CT COVER (END)":
        case 168: //"E2: CT COVER (END)":
        case 171: //"E1: CT CREEP (END)":
        case 174: //"E2: CT CREEP (END)":
        case 177: //"E1: HP COMPRESSOR (END)":
        case 180: //"E2: HP COMPRESSOR (END)":
        case 183: //"E1: PT 1 CREEP (END)":
        case 186: //"E2: PT 1 CREEP (END)":
        case 189: //"E1: PT 2 CREEP (END)":
        case 192: //"E2: PT 2 CREEP (END)":
        case 195: //"E1: PT 2 DISC (END)":
        case 198: //"E2: PT 2 DISC (END)":
        case 253: //"CAT.A Operations (END)":
        case 256: //"AVCS INOP (END)":
        case 259: //"MTOW FHS (END)":
        case 262: //"MTOW LDS (END)":*/
          if (!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString())) {
            widgetsForEachRow.add(
              TextWithIconButton(
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                multiple: rowsData[i][j]["columns"].length > 1,
                fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                closeOutFieldMode:
                    "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Ending)",
                fieldValue:
                    closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["fieldValue"],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          }
          break;

        case 154: //"E1: CREEP DAMAGE PERCENT (END)":
        case 155: //"E2: CREEP DAMAGE PERCENT (END)":
        case 156: //"E3: CREEP DAMAGE PERCENT (END)":
        case 157: //"E4: CREEP DAMAGE PERCENT (END)":
          if (!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString())) {
            widgetsForEachRow.add(
              TextWithIconButton(
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                multiple: rowsData[i][j]["columns"].length > 1,
                fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                closeOutFieldMode:
                    "${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["label"]} (Ending)",
                fieldValue:
                    closeOutAircraftFields(id: rowsData[i][j]["columns"][k]["id"].toString(), strFormFieldType: rowsData[i][j]["columns"][k]["formFieldType"])["fieldValue"],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          }
          break;

        //MISC Aircraft Fields
        //Text Fields
        case 36: //"UPDATE AC FUEL IN LBS":
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        //Formatting Fields
        //Field Formatters
        case 10: //"SPACER":
          if (rowsData[i][j]["columns"].length == 1) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.spacer(hidden: rowsData[i][j]["columns"][k]["columnHidden"]),
            );
          } else if (k == 0 && rowsData[i][j]["columns"].length > 8) {
            widgetsForEachRow.add(exceptionalFormTabularDesign(i, j, k)); //For Arizona DPS FW(55)_Z- Do not use-Employee Daily Summary - 160hr(503),
            // Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 40hr(517), Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 160hr(504),
            // Arizona DPS RW(46)_Z- Do not use-Employee Daily Summary - 160hr(493), Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 40hr(498),
            // Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 160hr(506), //NC HIGHWAY PATROL(68)_Mission Request or Flight Plan(408)
          }
          break;
        case 11: //"NEW LINE":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.newLine(hidden: rowsData[i][j]["columns"][k]["columnHidden"]),
          );
          exceptionalFormManualDesigns(i, j, k); //For Airtec Inc(90)_Daily Fuel Log(660), EXPLORAIR(100)_CONTROL COMBUSTIBLES AOG(700)
          break;

        //Headers
        case 50: //"HEADER CENTERED (BLUE)":
          if (rowsData[i][j]["columns"].length > 2 &&
              (rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"]) &&
              (rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"]) &&
              (rowsData[i].length > j + 1 &&
                  ((rowsData[i][j + 1]["columns"][0]["formFieldName"] == "") &&
                      (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)))) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredBlue(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            exceptionalFormManualDesigns(i, j, k); //For Hillsborough County Sheriffs Aviation(3)_Weekly Fuel Farm Inspection(90),
            // LEE County Sheriff(48)_Fuel Farm Inspection(297), MARTIN COUNTY SHERIFF(118)_Flight Activity Form(888),
            //Orange County Sheriffs Office(53)_TFO Trainee Daily Observation Report(412)
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredBlue(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredBlue(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;
        case 52: //"HEADER CENTERED (GREEN)":
          //For Las Vegas Metropolitan PD(59)_SAR 120 Training(710)
          if (Get.parameters["masterFormId"].toString() == "710") {
            for (var element in rowsData[i][j]["columns"]) {
              createdFields.add(element["id"].toString());
            }
            widgetsForEachRow.addIf(
              k == 0,
              FormWidgets.headerCenteredGreen(
                hidden: rowsData[i][j]["columns"][0]["columnHidden"],
                name: rowsData[i][j]["columns"][0]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][0]["acronymTitle"],
                multiple: false,
              ),
            );
          }

          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["formFieldName"] == "" &&
                  (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredGreen(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            exceptionalFormManualDesigns(
              i,
              j,
              k,
            ); //For Miami Dade Fire Rescue(5)_Daily Cmdr or Pilot(77), Miami Dade Fire Rescue(5)_OIC FM(79), HeliService USA(141)_AIRCRAFT DFL(1030)
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredGreen(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredGreen(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;
        case 54: //"HEADER CENTERED (ORANGE)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["formFieldName"] == "" &&
                  (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredOrange(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredOrange(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredOrange(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;
        case 53: //"HEADER CENTERED (RED)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["formFieldName"] == "" &&
                  (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredRed(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredRed(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredRed(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;
        case 51: //"HEADER CENTERED (WHITE)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["formFieldName"] == "" &&
                  (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredWhite(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredWhite(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredWhite(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;
        case 92: //"HEADER CENTERED (CUSTOM)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["formFieldName"] == "" &&
                  (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredCustom(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredCustom(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredCustom(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;
        case 127: //"HEADER (CUSTOM)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["formFieldName"] == "" &&
                  (rowsData[i][j + 1]["columns"][0]["formFieldType"] == 1 || rowsData[i][j + 1]["columns"][0]["formFieldType"] == 2)
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCustom(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                //nameAlign: rowsData[i][j]["columns"][k]["formFieldAlign"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCustom(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                //nameAlign: rowsData[i][j]["columns"][k]["formFieldAlign"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCustom(
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                //nameAlign: rowsData[i][j]["columns"][k]["formFieldAlign"],
                multiple: rowsData[i][j]["columns"].length > 1,
              ),
            );
          }
          break;

        //Signature
        case 99: //"SIGNATURE - ELECTRONIC":
          String fieldValue = "";
          if (rowsData[i][j]["columns"][k]["top100ElectronicSignatureData"].isNotEmpty) {
            List signatureData = rowsData[i][j]["columns"][k]["top100ElectronicSignatureData"];
            for (var info in signatureData) {
              fieldValue += "${info["signedByName"]} At ${info["signedTime"]} From ${info["ipAddress"]}${signatureData.indexOf(info) == signatureData.length - 1 ? "" : "\n"}";
            }
          }

          widgetsForEachRow.add(
            rowsData[i][j]["columns"][k]["top100ElectronicSignatureData"].isNotEmpty
                ? TextWithIconButton(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  multiple: rowsData[i][j]["columns"].length > 1,
                  fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                  fieldValue: fieldValue,
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                )
                : SignatureElectronicView(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                  controller: viewUserFormInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  userName: UserSessionInfo.userFullName,
                  formName: formsViewDetails["formName"],
                  nameAlign: rowsData[i][j]["columns"][k]["formFieldAlign"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  userDropDownData: userDropDownData,
                  selectedUserData: selectedUserData,
                  onDialogPopUp: () async {
                    userDropDownData.clear();
                    selectedUserData.clear();
                    signatureMode = 0;
                    Response response = await formsApiProvider.generalAPICall(
                      apiCallType: "POST",
                      url: "/forms/getElectronicSignFormData",
                      postData: {
                        "systemId": UserSessionInfo.systemId.toString(),
                        "userId": UserSessionInfo.userId.toString(),
                        "formId": Get.parameters["formId"].toString(),
                        "fieldId": rowsData[i][j]["columns"][k]["id"].toString(),
                      },
                    );
                    if (response.statusCode == 200) {
                      userDropDownData.addAll(response.data["data"]["electronicSignatureFormData"]["objPersonnelList"]);
                    }
                    performSignature(strFieldID: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onChangedUser: (value) {
                    selectedUserData.value = value;
                  },
                  onTapSignForm: () async {
                    Keyboard.close();
                    LoaderHelper.loaderWithGif();
                    await performSignatureValidation(
                      userID: selectedUserData["id"],
                      password: viewUserFormInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text,
                    ).then((value) async {
                      if (value) {
                        Get.back();
                        EasyLoading.dismiss();
                        onInit();
                        SnackBarHelper.openSnackBar(
                          isError: false,
                          message: "Signature Recorded At ${DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now)} (Form ID: ${Get.parameters["formId"]})",
                        );
                      }
                    });
                    EasyLoading.dismiss();
                  },
                ),
          );
          break;
        case 124: //"SIGNATURE - PEN":
          if (rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureData"] != null &&
              rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureData"] != "{}" &&
              rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureData"] != "") {
            var drawSignaturePointData = {};
            List<Point>? signaturePointList = [];

            drawSignaturePointData = jsonDecode(rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureData"]);

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
            signaturePointLists.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), signaturePointList);
            signatureController.putIfAbsent(
              rowsData[i][j]["columns"][k]["id"].toString(),
              () => SignatureController(disabled: true, penStrokeWidth: 2, penColor: ColorConstants.black, exportBackgroundColor: Colors.blue),
            );
            signatureController[rowsData[i][j]["columns"][k]["id"].toString()]?.points = signaturePointLists[rowsData[i][j]["columns"][k]["id"].toString()]!;
          }
          widgetsForEachRow.add(
            SignaturePenView(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              signatureController: signatureController.putIfAbsent(
                rowsData[i][j]["columns"][k]["id"].toString(),
                () => SignatureController(disabled: true, penStrokeWidth: 2, penColor: ColorConstants.black, exportBackgroundColor: Colors.blue),
              ),
              signatureName:
                  rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureName"] != ""
                      ? rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureName"]
                      : null,
              signatureTime:
                  rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureTime"] != ""
                      ? rowsData[i][j]["columns"][k]["electronicSignaturePenData"]["signatureTime"]
                      : null,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        //Automation Fields
        case 153: //"GENERATE AUTOMATIC ID (YYYYDDMM###)":
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;
        case 144: //"RISK ASSESSMENT CHOOSER":
          widgetsForEachRow.add(
            GetBuilder<ViewUserFormLogic>(
              init: ViewUserFormLogic(),
              builder: (controller) {
                return TextWithIconButton(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  multiple: rowsData[i][j]["columns"].length > 1,
                  fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                  fieldValue:
                      (rowsData[i][j]["columns"][k]["riskAssessmentData"]["id"] ?? 0) > 0
                          ? "${rowsData[i][j]["columns"][k]["riskAssessmentData"]["dateCreated"]} [Value: ${rowsData[i][j]["columns"][k]["riskAssessmentData"]["riskMatrixValue"]}]"
                          : "None",
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  icon: (rowsData[i][j]["columns"][k]["riskAssessmentData"]["id"] ?? 0) > 0 ? Icons.search : null,
                  iconColor: ColorConstants.primary,
                  onTap:
                      (rowsData[i][j]["columns"][k]["riskAssessmentData"]["id"] ?? 0) > 0
                          ? () {
                            Get.toNamed(
                              Routes.viewRiskAssessment,
                              arguments: "ViewUserForm",
                              parameters: {"riskId": "3", "instanceId": rowsData[i][j]["columns"][k]["riskAssessmentData"]["id"].toString()},
                            );
                          }
                          : null,
                );
              },
            ),
          );
          break;

        //User Roles
        case 1000: //"UR: (ANY PILOT)"/"UR: ALL PILOTS":
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
              fieldValue = element["name"];
            }
          });
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), "") ?? "",
              bold: true,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case >= 200 && < 250: // DropDown UR: User Roles (200-249)
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
              fieldValue = element["name"];
            }
          });
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
              bold: true,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case > 262 && < 350: // Accessory Type Fields (263-349)
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: rowsData[i][j]["columns"][k]["formFieldType"] == 0 ? "" : formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
              bold: true,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case >= 350 && < 450: // DropDown Form Chooser (350-449)
          String? fieldValue;
          rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
            if (element["id"] == (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
              fieldValue = element["name"];
            }
          });
          widgetsForEachRow.add(
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
              bold: true,
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              icon: fieldValue != null ? Icons.search : null,
              iconColor: ColorConstants.primary,
              onTap:
                  fieldValue != null
                      ? () => Get.offNamed(
                        Routes.viewUserForm,
                        arguments: "fromViewUserForm",
                        parameters: {
                          "formId": formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0",
                          "masterFormId": "",
                          "previousFormId": Get.parameters["formId"].toString(),
                        },
                      )
                      : null,
            ),
          );
          break;

        case 1100 || 1101 || 1102: // Flight Log (From, Via, To)
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TextWithIconButton(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              multiple: rowsData[i][j]["columns"].length > 1,
              fieldName:
                  rowsData[i][j]["columns"][k]["formFieldName"] != ""
                      ? "${rowsData[i][j]["columns"][k]["formFieldName"]}${(rowsData[i][j]["columns"][k]["formFieldName"].toLowerCase().contains("from") || rowsData[i][j]["columns"][k]["formFieldName"].toLowerCase().contains("via") || rowsData[i][j]["columns"][k]["formFieldName"].toLowerCase().contains("to")) ? "" : " (${rowsData[i][j]["columns"][k]["formFieldType"] == 1100
                              ? "From"
                              : rowsData[i][j]["columns"][k]["formFieldType"] == 1101
                              ? "Via"
                              : "To"})"}"
                      : "",
              fieldValue: formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        default:
          if (rowsData[i][j]["columns"][k]["fieldName"] == "" && rowsData[i][j]["columns"][k]["elementType"].toString() == "select") {
            String? fieldValue;
            rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
              if (element["id"] == (formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
                fieldValue = element["name"];
              }
            });
            widgetsForEachRow.add(
              TextWithIconButton(
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                multiple: rowsData[i][j]["columns"].length > 1,
                fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                bold: true,
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          } else if (rowsData[i][j]["columns"][k]["fieldName"] == "" && rowsData[i][j]["columns"][k]["formFieldType"] == 0) {
            widgetsForEachRow.add(
              TextWithIconButton(
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                multiple: rowsData[i][j]["columns"].length > 1,
                fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
                fieldValue: rowsData[i][j]["columns"][k]["formFieldType"] == 0 ? "" : formFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          } else if (kDebugMode) {
            widgetsForEachRow.add(
              Text(
                "Field -${rowsData[i][j]["columns"][k]["formFieldName"]}- is not created.\nField Type (${rowsData[i][j]["columns"][k]["formFieldType"]}): -${rowsData[i][j]["columns"][k]["fieldName"]}-\n",
                style: const TextStyle(color: ColorConstants.red),
              ),
            );
          }
      }
    }
    return widgetsForEachRow;
  }

  Map<String, String> closeOutAircraftFields({required id, required int strFormFieldType}) {
    int strDecimals = 1;
    String strLabel = "";

    switch (strFormFieldType) {
      case 22 || 23 || 29 || 30 || 33 || 34 || 94 || 95 || 96 || 44 || 45 || 46 || 47 || 48 || 49:
        strDecimals = 0;
        break;
      default:
        strDecimals = 1;
        break;
    }
    switch (strStartsName) {
      case "STARTS":
        switch (strFormFieldType) {
          case 12 || 57 || 18 || 14 || 58 || 19 || 97 || 98 || 100 || 110 || 111 || 112:
            strLabel = " Starts";
            strDecimals = 0;
          case 13 || 59 || 20 || 15 || 60 || 21 || 107 || 108 || 109 || 119 || 120 || 121:
            strLabel = " NP";
          case 85 || 86 || 87 || 88 || 89 || 90 || 101 || 102 || 103 || 113 || 114 || 115:
            strLabel = " NG2";
          case 131 || 132 || 133 || 134 || 135 || 136 || 137 || 138 || 139 || 140 || 141 || 142:
            strLabel = " Cycles";
        }
      case "N1N2":
        switch (strFormFieldType) {
          case 12 || 57 || 18 || 14 || 58 || 19 || 97 || 98 || 100 || 110 || 111 || 112:
            strLabel = " N1";
            strDecimals = 2;
          case 13 || 59 || 20 || 15 || 60 || 21 || 107 || 108 || 109 || 119 || 120 || 121:
            strLabel = " NP/NF";
          case 85 || 86 || 87 || 88 || 89 || 90 || 101 || 102 || 103 || 113 || 114 || 115:
            strLabel = " N2";
            strDecimals = 2;
          case 131 || 132 || 133 || 134 || 135 || 136 || 137 || 138 || 139 || 140 || 141 || 142:
            strLabel = " Cycles";
        }
      case "NPNG":
        switch (strFormFieldType) {
          case 12 || 57 || 18 || 14 || 58 || 19 || 97 || 98 || 100 || 110 || 111 || 112:
            strLabel = " NG";
            strDecimals = 2;
          case 13 || 59 || 20 || 15 || 60 || 21 || 107 || 108 || 109 || 119 || 120 || 121:
            strLabel = " NP/NF";
            strDecimals = 2;
          case 85 || 86 || 87 || 88 || 89 || 90 || 101 || 102 || 103 || 113 || 114 || 115:
            strLabel = " NG2";
          case 131 || 132 || 133 || 134 || 135 || 136 || 137 || 138 || 139 || 140 || 141 || 142:
            strLabel = " Cycles";
        }
      case "IPC" || "IMPPTCT":
        switch (strFormFieldType) {
          case 12 || 57 || 18 || 14 || 58 || 19 || 97 || 98 || 100 || 110 || 111 || 112:
            switch (strStartsName) {
              case "IPC":
                strLabel = " CCY";
              case "IMPPTCT":
                strLabel = " CT Disc";
            }
            strDecimals = 0;
          case 13 || 59 || 20 || 15 || 60 || 21 || 107 || 108 || 109 || 119 || 120 || 121:
            switch (strStartsName) {
              case "IPC":
                strLabel = " ICY";
              case "IMPPTCT":
                strLabel = " Impeller";
            }
            strDecimals = 0;
          case 85 || 86 || 87 || 88 || 89 || 90 || 101 || 102 || 103 || 113 || 114 || 115:
            switch (strStartsName) {
              case "IPC":
                strLabel = " PCY";
              case "IMPPTCT":
                strLabel = " PT 1 Disc";
            }
            strDecimals = 0;
          case 131 || 132 || 133 || 134 || 135 || 136 || 137 || 138 || 139 || 140 || 141 || 142:
            strLabel = " Cycles";
            strDecimals = 0;
          case 163 || 164 || 165 || 166 || 167 || 168:
            strLabel = " CT Cover";
            strDecimals = 0;
          case 169 || 170 || 171 || 172 || 173 || 174:
            strLabel = " CT Creep";
            strDecimals = 0;
          case 175 || 176 || 177 || 178 || 179 || 180:
            strLabel = " HP Compressor";
            strDecimals = 0;
          case 181 || 182 || 183 || 184 || 185 || 186:
            strLabel = " PT 1 Creep";
            strDecimals = 0;
          case 187 || 188 || 189 || 190 || 191 || 192:
            strLabel = " PT 2 Creep";
            strDecimals = 0;
          case 193 || 194 || 195 || 196 || 197 || 198:
            strLabel = " PT 2 Disc";
            strDecimals = 0;
        }
      default:
        strDecimals = 1;
        strLabel = "";
        break;
    }
    var formattedFieldValue = num.tryParse(formFieldValues[id.toString()].toString())?.toStringAsFixed(strDecimals) ?? "0";

    return {"fieldValue": formattedFieldValue, "label": strLabel};
  }

  List<Widget> multiHeaderFields(i, j, k) {
    var m = 0;
    var n = rowsData[i].length - (j + 1);
    var multiHeaderFieldWidgets = <Widget>[];
    while (m < n && rowsData[i][j]["columns"][0]["cssClassName"] != rowsData[i][j + (m + 1)]["columns"][0]["cssClassName"]) {
      var l = m;
      if (rowsData[i][j + (l + 1)]["columns"].length > k && rowsData[i][j + (l + 1)]["columns"][k]["formFieldType"] == 1) {
        createdFields.addIf(!createdFields.contains(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()), rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
        multiHeaderFieldWidgets.add(
          TextWithIconButton(
            id: rowsData[i][j + (l + 1)]["columns"][k]["id"],
            rowColor: rowsData[i][j + (l + 1)]["formRowBgColor"],
            multiple: rowsData[i][j + (l + 1)]["columns"].length > 1,
            fieldName: rowsData[i][j + (l + 1)]["columns"][k]["formFieldName"],
            fieldValue: formFieldValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()],
            hidden: rowsData[i][j + (l + 1)]["columns"][k]["columnHidden"],
          ),
        );
      } else if (rowsData[i][j + (l + 1)]["columns"].length > k && rowsData[i][j + (l + 1)]["columns"][k]["formFieldType"] == 2) {
        createdFields.addIf(!createdFields.contains(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()), rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
        multiHeaderFieldWidgets.add(
          TextWithIconButton(
            id: rowsData[i][j + (l + 1)]["columns"][k]["id"],
            rowColor: rowsData[i][j + (l + 1)]["formRowBgColor"],
            multiple: rowsData[i][j + (l + 1)]["columns"].length > 1,
            fieldName: rowsData[i][j + (l + 1)]["columns"][k]["formFieldName"],
            fieldValue: "",
            hidden: rowsData[i][j + (l + 1)]["columns"][k]["columnHidden"],
            icon:
                formFieldValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] != null
                    ? formFieldValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] == "on"
                        ? Icons.check_box
                        : Icons.check_box_outline_blank
                    : rowsData[i][j + (l + 1)]["columns"][k]["defaultValue"].toLowerCase() == "checked"
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
            iconColor:
                formFieldValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] != null
                    ? formFieldValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] == "on"
                        ? ColorConstants.primary
                        : ColorConstants.grey
                    : rowsData[i][j + (l + 1)]["columns"][k]["defaultValue"].toLowerCase() == "checked"
                    ? ColorConstants.primary
                    : ColorConstants.grey,
          ),
        );
      }
      m++;
    }
    return multiHeaderFieldWidgets;
  }

  Widget exceptionalFormTabularDesign(i, j, k) {
    switch (Get.parameters["masterFormId"].toString()) {
      case "493": //Arizona DPS RW(46)_Z- Do not use-Employee Daily Summary - 160hr(493)
      case "498": //Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 40hr(498)
      case "503": //Arizona DPS FW(55)_Z- Do not use-Employee Daily Summary - 160hr(503)
      case "504": //Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 160hr(504)
      case "506": //Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 160hr(506)
      case "517": //Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 40hr(517)
        var m = j;

        while (m < rowsData[i].length && rowsData[i][m]["columns"][1]["formFieldType"] != 99) {
          for (var l = 0; l < rowsData[i][m]["columns"].length; l++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][m]["columns"][k + l]["id"].toString()), rowsData[i][m]["columns"][k + l]["id"].toString());
          }
          m++;
        }

        List<Widget> tableRowWidgets(l) {
          var rowWidgetList = <Widget>[];
          for (var m = 1; m <= 8; m++) {
            rowWidgetList.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                child: TextWithIconButton(
                  id: rowsData[i][j + l]["columns"][k + m]["id"],
                  rowColor: rowsData[i][j + l]["formRowBgColor"],
                  multiple: rowsData[i][j + l]["columns"].length > 1,
                  fieldName: rowsData[i][j + l]["columns"][k + m]["formFieldName"],
                  fieldValue: formFieldValues[rowsData[i][j + l]["columns"][k + m]["id"].toString()],
                  hidden: rowsData[i][j + l]["columns"][k + m]["columnHidden"],
                ),
              ),
            );
          }

          return rowWidgetList;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 1
                          : 2
                      : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Align(alignment: Alignment.centerRight, child: Icon(Icons.swipe, color: Colors.white, size: 28 * Get.textScaleFactor)),
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 1]["formRowBgColor"],
                    name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 1]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 2]["formRowBgColor"],
                    name: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 2]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 2]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 3]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 3]["formRowBgColor"],
                    name: rowsData[i][j + 3]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 3]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 3]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 4]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 4]["formRowBgColor"],
                    name: rowsData[i][j + 4]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 4]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 4]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 5]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 5]["formRowBgColor"],
                    name: rowsData[i][j + 5]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 5]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 5]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 6]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 6]["formRowBgColor"],
                    name: rowsData[i][j + 6]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 6]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 6]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 7]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 7]["formRowBgColor"],
                    name: rowsData[i][j + 7]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 7]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 7]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    hidden: rowsData[i][j + 8]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    name: rowsData[i][j + 8]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 8]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 8]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.spacer(hidden: rowsData[i][j]["columns"][k]["columnHidden"], height: 5.0),
                ],
              ),
            ),
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 4
                          : 6
                      : 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: const FixedColumnWidth(180),
                    children: <TableRow>[
                      rowsData[i][j]["columns"][k + 1]["formFieldType"] == 50
                          ? TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                              color:
                                  rowsData[i][j]["formRowBgColor"] != ""
                                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 3]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 3]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 3]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 4]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 4]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 4]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 5]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 5]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 5]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 6]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 6]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 6]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 7]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 7]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 7]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  hidden: rowsData[i][j]["columns"][k + 8]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 8]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 8]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                            ],
                          )
                          : rowsData[i][j]["columns"][k + 1]["formFieldType"] == 52
                          ? TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                              color:
                                  rowsData[i][j]["formRowBgColor"] != ""
                                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 3]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 3]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 3]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 4]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 4]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 4]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 5]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 5]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 5]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 6]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 6]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 6]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 7]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 7]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 7]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  hidden: rowsData[i][j]["columns"][k + 8]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 8]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 8]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                            ],
                          )
                          : TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                              color:
                                  rowsData[i][j]["formRowBgColor"] != ""
                                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 3]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 3]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 3]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 4]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 4]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 4]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 5]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 5]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 5]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 6]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 6]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 6]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 7]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 7]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 7]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  hidden: rowsData[i][j]["columns"][k + 8]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 8]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 8]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                            ],
                          ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 1]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(1),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 2]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 2]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 2]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 2]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(2),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 3]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 3]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 3]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 3]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(3),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 4]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 4]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 4]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 4]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(4),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 5]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 5]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 5]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 5]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(5),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 6]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 6]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 6]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 6]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(6),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 7]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 7]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 7]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 7]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(7),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 8]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 8]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 8]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 8]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case "408": //NC HIGHWAY PATROL(68)_Mission Request or Flight Plan(408)
        var m = j;
        Map<int, FixedColumnWidth> columnWidths = {};
        var columnWidgets = <Widget>[];
        var tableWidgets = <TableRow>[];

        for (m; m < rowsData[i].length && rowsData[i][m]["columns"].length > 14; m++) {
          var tableRowWidgets = <Widget>[];
          for (var n = 0; n < rowsData[i][m]["columns"].length; n++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][m]["columns"][n]["id"].toString()), rowsData[i][m]["columns"][n]["id"].toString());
            switch (rowsData[i][m]["columns"][n]["formFieldType"] as int) {
              case 10: //"SPACER":
                if (m == j && n == 0) {
                  columnWidgets.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.swipe, color: ThemeColorMode.isDark ? Colors.white : Colors.black, size: 28, applyTextScaling: true),
                      ),
                    ),
                  );
                } else if (m != j) {
                  tableRowWidgets.add(FormWidgets.spacer(hidden: rowsData[i][j]["columns"][k]["columnHidden"]));
                }
                break;
              case 51: //"HEADER CENTERED (WHITE)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredWhite(
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredWhite(
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                break;
              case 127: //"HEADER (CUSTOM)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCustom(
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          nameAlign: "R",
                          //rowsData[i][m]["columns"][n]["formFieldAlign"],
                          height: ((28 * Get.textScaleFactor).ceilToDouble() + 50.0),
                          multiple: false,
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCustom(
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          nameAlign: "R",
                          //rowsData[i][m]["columns"][n]["formFieldAlign"],
                          height: ((28 * Get.textScaleFactor).ceilToDouble() + 50.0),
                          multiple: false,
                        ),
                      ),
                    );
                break;
              case 52: //"HEADER CENTERED (GREEN)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                break;
              case 1: //"TEXT FIELD (STANDARD)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    );
                break;
              case 69: //"INSTRUMENT TIME (SIMULATED)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    );
                break;
              case 64: //"DAY FLIGHT TIME":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    );
                break;
              case 65: //"NIGHT FLIGHT TIME":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    );
                break;
              case 63: //"NVG TIME":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: double.tryParse(formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    );
                break;
            }
          }
          tableWidgets.add(
            TableRow(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                color:
                    rowsData[i][m]["formRowBgColor"] != ""
                        ? rowsData[i][m]["formRowBgColor"].toString().length == 4
                            ? hexToColor("${rowsData[i][m]["formRowBgColor"]}000")
                            : hexToColor(rowsData[i][m]["formRowBgColor"])
                        : ThemeColorMode.isDark
                        ? Colors.grey[900]
                        : Colors.white,
              ),
              children: tableRowWidgets,
            ),
          );
        }

        for (var o = 0; o < rowsData[i][j]["columns"].length - 2; o++) {
          columnWidths.addIf(true, o, o % 2 == 0 ? const FixedColumnWidth(180) : const FixedColumnWidth(80));
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 1
                          : 2
                      : 1,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: columnWidgets),
            ),
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 4
                          : 6
                      : 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, columnWidths: columnWidths, children: tableWidgets),
                ),
              ),
            ),
          ],
        );

      default:
        return Text(
          "Contact with Digital AirWare.\n System Name: ${UserSessionInfo.systemName},Form Name: ${Get.parameters["formName"]}",
          style: const TextStyle(color: Colors.red),
        );
    }
  }

  void exceptionalFormManualDesigns(i, j, k) {
    switch (Get.parameters["masterFormId"].toString()) {
      case "660": //Airtec Inc(90)_Daily Fuel Log(660)
      case "700": //EXPLORAIR(100)_CONTROL COMBUSTIBLES AOG(700)
        var l = j + 1;

        for (l; l < rowsData[i].length && rowsData[i][l]["columns"][0]["formFieldType"] != 11; l++) {
          for (var id in rowsData[i][l]["columns"]) {
            createdFields.addIf(!createdFields.contains(id["id"].toString()), id["id"].toString());
          }
        }

        switch (j) {
          case 2:
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                      name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                      acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 2]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 2]["formRowBgColor"],
                    multiple: rowsData[i][j + 2]["columns"].length > 1,
                    fieldName: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                    fieldValue:
                        closeOutAircraftFields(
                          id: rowsData[i][j + 2]["columns"][k]["id"].toString(),
                          strFormFieldType: rowsData[i][j + 2]["columns"][k]["formFieldType"],
                        )["fieldValue"],
                    hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 3]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 3]["formRowBgColor"],
                    multiple: rowsData[i][j + 3]["columns"].length > 1,
                    fieldName: rowsData[i][j + 3]["columns"][k]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 3]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 3]["columns"][k]["columnHidden"],
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][j + 1]["columns"][k + 2]["columnHidden"],
                      name: rowsData[i][j + 1]["columns"][k + 2]["formFieldName"],
                      acronymTitle: rowsData[i][j + 1]["columns"][k + 2]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 2]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 2]["formRowBgColor"],
                    multiple: rowsData[i][j + 2]["columns"].length > 1,
                    fieldName: rowsData[i][j + 2]["columns"][k + 2]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()],
                    hidden: rowsData[i][j + 2]["columns"][k + 2]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 3]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 3]["formRowBgColor"],
                    multiple: rowsData[i][j + 3]["columns"].length > 1,
                    fieldName: rowsData[i][j + 3]["columns"][k + 2]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()],
                    hidden: rowsData[i][j + 3]["columns"][k + 2]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 4]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 4]["formRowBgColor"],
                    multiple: rowsData[i][j + 4]["columns"].length > 1,
                    fieldName: rowsData[i][j + 4]["columns"][k + 1]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()],
                    hidden: rowsData[i][j + 4]["columns"][k + 1]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 5]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 5]["formRowBgColor"],
                    multiple: rowsData[i][j + 5]["columns"].length > 1,
                    fieldName: rowsData[i][j + 5]["columns"][k + 1]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()],
                    hidden: rowsData[i][j + 5]["columns"][k + 1]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 6]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 6]["formRowBgColor"],
                    multiple: rowsData[i][j + 6]["columns"].length > 1,
                    fieldName: rowsData[i][j + 6]["columns"][k + 1]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()],
                    hidden: rowsData[i][j + 6]["columns"][k + 1]["columnHidden"],
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(FormWidgets.newLine(hidden: false));
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][j + 7]["columns"][k]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 8]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    multiple: rowsData[i][j + 8]["columns"].length > 1,
                    fieldName: rowsData[i][j + 8]["columns"][k]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 8]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 8]["columns"][k]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 9]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    multiple: rowsData[i][j + 9]["columns"].length > 1,
                    fieldName: rowsData[i][j + 9]["columns"][k]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 9]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 9]["columns"][k]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k + 1]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k + 1]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 11]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    multiple: rowsData[i][j + 11]["columns"].length > 1,
                    fieldName: rowsData[i][j + 11]["columns"][k]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 11]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 11]["columns"][k]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 11]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    multiple: rowsData[i][j + 11]["columns"].length > 1,
                    fieldName: rowsData[i][j + 11]["columns"][k + 1]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()],
                    hidden: rowsData[i][j + 11]["columns"][k + 1]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 12]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 12]["formRowBgColor"],
                    multiple: rowsData[i][j + 12]["columns"].length > 1,
                    fieldName: rowsData[i][j + 12]["columns"][k]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 12]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 12]["columns"][k]["columnHidden"],
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][j + 7]["columns"][k + 2]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k + 2]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k + 2]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 8]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    multiple: rowsData[i][j + 8]["columns"].length > 1,
                    fieldName: rowsData[i][j + 8]["columns"][k + 2]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()],
                    hidden: rowsData[i][j + 8]["columns"][k + 2]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 9]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    multiple: rowsData[i][j + 9]["columns"].length > 1,
                    fieldName: rowsData[i][j + 9]["columns"][k + 2]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()],
                    hidden: rowsData[i][j + 9]["columns"][k + 2]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k + 3]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k + 3]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k + 3]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k + 4]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k + 4]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 11]["columns"][k + 3]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    multiple: rowsData[i][j + 11]["columns"].length > 1,
                    fieldName: rowsData[i][j + 11]["columns"][k + 3]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()],
                    hidden: rowsData[i][j + 11]["columns"][k + 3]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 11]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    multiple: rowsData[i][j + 11]["columns"].length > 1,
                    fieldName: rowsData[i][j + 11]["columns"][k + 4]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()],
                    hidden: rowsData[i][j + 11]["columns"][k + 4]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 12]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 12]["formRowBgColor"],
                    multiple: rowsData[i][j + 12]["columns"].length > 1,
                    fieldName: rowsData[i][j + 12]["columns"][k + 2]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()],
                    hidden: rowsData[i][j + 12]["columns"][k + 2]["columnHidden"],
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][j + 7]["columns"][k + 4]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k + 4]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k + 4]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 8]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    multiple: rowsData[i][j + 8]["columns"].length > 1,
                    fieldName: rowsData[i][j + 8]["columns"][k + 4]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()],
                    hidden: rowsData[i][j + 8]["columns"][k + 4]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 9]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    multiple: rowsData[i][j + 9]["columns"].length > 1,
                    fieldName: rowsData[i][j + 9]["columns"][k + 4]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()],
                    hidden: rowsData[i][j + 9]["columns"][k + 4]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k + 6]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k + 6]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k + 7]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k + 7]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k + 7]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 11]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    multiple: rowsData[i][j + 11]["columns"].length > 1,
                    fieldName: rowsData[i][j + 11]["columns"][k + 6]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()],
                    hidden: rowsData[i][j + 11]["columns"][k + 6]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 11]["columns"][k + 7]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    multiple: rowsData[i][j + 11]["columns"].length > 1,
                    fieldName: rowsData[i][j + 11]["columns"][k + 7]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()],
                    hidden: rowsData[i][j + 11]["columns"][k + 7]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 12]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 12]["formRowBgColor"],
                    multiple: rowsData[i][j + 12]["columns"].length > 1,
                    fieldName: rowsData[i][j + 12]["columns"][k + 4]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()],
                    hidden: rowsData[i][j + 12]["columns"][k + 4]["columnHidden"],
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][j + 7]["columns"][k + 6]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k + 6]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k + 6]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 8]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    multiple: rowsData[i][j + 8]["columns"].length > 1,
                    fieldName: rowsData[i][j + 8]["columns"][k + 6]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()],
                    hidden: rowsData[i][j + 8]["columns"][k + 6]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 9]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    multiple: rowsData[i][j + 9]["columns"].length > 1,
                    fieldName: rowsData[i][j + 9]["columns"][k + 6]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()],
                    hidden: rowsData[i][j + 9]["columns"][k + 6]["columnHidden"],
                  ),
                  TextWithIconButton(
                    id: rowsData[i][j + 10]["columns"][k + 9]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    multiple: rowsData[i][j + 10]["columns"].length > 1,
                    fieldName: rowsData[i][j + 10]["columns"][k + 9]["formFieldName"],
                    fieldValue: formFieldValues[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()],
                    hidden: rowsData[i][j + 10]["columns"][k + 9]["columnHidden"],
                  ),
                ],
              ),
            );
          case 15:
            var m = j;
            var n = j + 7;
            var tableWidgets1 = <TableRow>[];
            var tableWidgets2 = <TableRow>[];

            while (m < rowsData[i].length && rowsData[i][16]["columns"][1]["cssClassName"] != rowsData[i][m + 1]["columns"][0]["cssClassName"]) {
              var tableRowWidgets = <Widget>[];
              for (var o = 0; o < rowsData[i][m + 1]["columns"].length; o++) {
                switch (rowsData[i][m + 1]["columns"][o]["formFieldType"] as int) {
                  case 10: //"SPACER":
                    break;
                  case 52: //"HEADER CENTERED (GREEN)":
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          hidden: rowsData[i][m + 1]["columns"][o]["columnHidden"],
                          name: rowsData[i][m + 1]["columns"][o]["formFieldName"],
                          acronymTitle: rowsData[i][m + 1]["columns"][o]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                    break;
                  case 1: //"TEXT FIELD (STANDARD)":
                    var p = m;
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][p + 1]["columns"][o]["id"],
                          rowColor: rowsData[i][p + 1]["formRowBgColor"],
                          multiple: rowsData[i][p + 1]["columns"].length > 1,
                          fieldName: rowsData[i][p + 1]["columns"][o]["formFieldName"],
                          fieldValue: formFieldValues[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                          hidden: rowsData[i][p + 1]["columns"][o]["columnHidden"],
                          center: true,
                        ),
                      ),
                    );
                    break;
                  case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
                    var p = m;
                    String? fieldValue;
                    rowsData[i][p + 1]["columns"][o]["elementData"].forEach((element) {
                      if (element["id"] == (formFieldValues[rowsData[i][p + 1]["columns"][o]["id"].toString()] ?? "0")) {
                        fieldValue = element["name"];
                      }
                    });
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][p + 1]["columns"][o]["id"],
                          rowColor: rowsData[i][p + 1]["formRowBgColor"],
                          multiple: rowsData[i][p + 1]["columns"].length > 1,
                          fieldName: rowsData[i][p + 1]["columns"][o]["formFieldName"],
                          fieldValue:
                              rowsData[i][p + 1]["columns"][o]["formFieldAbilityToAdd"]
                                  ? formFieldValues[rowsData[i][p + 1]["columns"][o]["id"].toString()]
                                  : rowsData[i][p + 1]["columns"][o]["formFieldStSelectMany"]
                                  ? extendedFieldsValue[rowsData[i][p + 1]["columns"][o]["id"].toString()] != ""
                                      ? extendedFieldsValue[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.replaceAll("^^^#", ", ")
                                      : null
                                  : fieldValue,
                          bold: rowsData[i][p + 1]["columns"][o]["formFieldAbilityToAdd"] && rowsData[i][p + 1]["columns"][o]["formFieldStSelectMany"] ? true : null,
                          hidden: rowsData[i][p + 1]["columns"][o]["columnHidden"],
                          center: true,
                        ),
                      ),
                    );
                    break;
                }
              }
              tableWidgets1.add(
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    color:
                        rowsData[i][m + 1]["formRowBgColor"] != ""
                            ? rowsData[i][m + 1]["formRowBgColor"].toString().length == 4
                                ? hexToColor("${rowsData[i][m + 1]["formRowBgColor"]}000")
                                : hexToColor(rowsData[i][m + 1]["formRowBgColor"])
                            : ThemeColorMode.isDark
                            ? Colors.grey[900]
                            : Colors.white,
                  ),
                  children: tableRowWidgets,
                ),
              );
              m++;
            }

            while (n < rowsData[i].length) {
              var tableRowWidgets = <Widget>[];
              for (var o = 0; o < rowsData[i][n]["columns"].length; o++) {
                switch (rowsData[i][n]["columns"][o]["formFieldType"] as int) {
                  case 10: //"SPACER":
                    break;
                  case 52: //"HEADER CENTERED (GREEN)":
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          hidden: rowsData[i][n]["columns"][o]["columnHidden"],
                          name: rowsData[i][n]["columns"][o]["formFieldName"],
                          acronymTitle: rowsData[i][n]["columns"][o]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                    break;
                  case 1: //"TEXT FIELD (STANDARD)":
                    var p = n;
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextWithIconButton(
                          id: rowsData[i][p]["columns"][o]["id"],
                          rowColor: rowsData[i][p]["formRowBgColor"],
                          multiple: rowsData[i][p]["columns"].length > 1,
                          fieldName: rowsData[i][p]["columns"][o]["formFieldName"],
                          fieldValue: formFieldValues[rowsData[i][p]["columns"][o]["id"].toString()],
                          hidden: rowsData[i][p]["columns"][o]["columnHidden"],
                          center: true,
                        ),
                      ),
                    );
                    break;
                }
              }
              tableWidgets2.add(
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    color:
                        rowsData[i][n]["formRowBgColor"] != ""
                            ? rowsData[i][n]["formRowBgColor"].toString().length == 4
                                ? hexToColor("${rowsData[i][n]["formRowBgColor"]}000")
                                : hexToColor(rowsData[i][n]["formRowBgColor"])
                            : ThemeColorMode.isDark
                            ? Colors.grey[900]
                            : Colors.white,
                  ),
                  children: tableRowWidgets,
                ),
              );
              n++;
            }

            widgetsForEachRow.add(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: FixedColumnWidth(
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 4.1)
                              : (Get.width / 4.16)
                          : (Get.width / 2.3),
                    ),
                    children: tableWidgets1,
                  ),
                ),
              ),
            );
            widgetsForEachRow.add(FormWidgets.newLine(hidden: false));
            widgetsForEachRow.add(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: FixedColumnWidth(
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3.07)
                              : (Get.width / 3.12)
                          : (Get.width / 2.3),
                    ),
                    children: tableWidgets2,
                  ),
                ),
              ),
            );
        }
        break;
      case "90": //Hillsborough County Sheriffs Aviation(3)_Weekly Fuel Farm Inspection(90)
      case "297": //LEE County Sheriff(48)_Fuel Farm Inspection(297)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];

        for (l; l < rowsData[i].length && rowsData[i][l]["columns"].length > 1; l++) {
          for (var id in rowsData[i][l]["columns"]) {
            createdFields.addIf(!createdFields.contains(id["id"].toString()), id["id"].toString());
          }
          for (var n = 0; n < rowsData[i][l]["columns"].length; n++) {
            switch (rowsData[i][l]["columns"][n]["formFieldType"] as int) {
              case 50: //"HEADER CENTERED (BLUE)":
                columnWidgets1.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredBlue(
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 54: //"HEADER CENTERED (ORANGE)":
                columnWidgets2.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredOrange(
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 10: //"SPACER":
                break;
              case 1: //"TEXT FIELD (STANDARD)":
                var m = l;
                n == 0
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
              case 5: //"DATE (OTHER DATE)":
                var m = l;
                n == 0
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
            }
          }
        }

        widgetsForEachRow.add(Column(children: columnWidgets1));
        widgetsForEachRow.add(Column(children: columnWidgets2));
        break;
      case "888": //MARTIN COUNTY SHERIFF(118)_Flight Activity Form(888)
        if (rowsData[i][j]["columns"].length == 3) {
          for (var id in rowsData[i][j]["columns"]) {
            createdFields.addIf(!createdFields.contains(id["id"].toString()), id["id"].toString());
          }

          widgetsForEachRow.addIf(
            k == 1,
            SizedBox(
              width:
                  Get.width > 480
                      ? Get.width > 980
                          ? (Get.width / 3) - ((12 / 3) * 9)
                          : (Get.width / 2) - ((12 / 2) * 8)
                      : Get.width - 5,
              child: FormWidgets.headerCenteredBlue(
                hidden: rowsData[i][j]["columns"][1]["columnHidden"],
                name: rowsData[i][j]["columns"][1]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][1]["acronymTitle"],
                multiple: false,
              ),
            ),
          );
          widgetsForEachRow.addIf(
            k == 2,
            SizedBox(
              width:
                  Get.width > 480
                      ? Get.width > 980
                          ? (Get.width / 3) - ((12 / 3) * 9)
                          : (Get.width / 2) - ((12 / 2) * 8)
                      : Get.width - 5,
              child: FormWidgets.headerCenteredBlue(
                hidden: rowsData[i][j]["columns"][2]["columnHidden"],
                name: rowsData[i][j]["columns"][2]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][2]["acronymTitle"],
                multiple: false,
              ),
            ),
          );
        }
        break;
      case "412": //Orange County Sheriffs Office(53)_TFO Trainee Daily Observation Report(412)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];
        var columnWidgets3 = <Widget>[];

        for (l; (l < rowsData[i].length) && (l == j || (rowsData[i][j]["columns"][0]["formFieldType"] != rowsData[i][l]["columns"][0]["formFieldType"])); l++) {
          createdFields.addIf(!createdFields.contains(rowsData[i][l]["columns"][k]["id"].toString()), rowsData[i][l]["columns"][k]["id"].toString());
          switch (rowsData[i][l]["columns"][k]["formFieldType"] as int) {
            case 50: //"HEADER CENTERED (BLUE)":
              columnWidgets1.addIf(
                k == 0,
                SizedBox(
                  width:
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3) - ((12 / 3) * 9)
                              : (Get.width / 2) - ((12 / 2) * 8)
                          : Get.width - 5,
                  child: FormWidgets.headerCenteredBlue(
                    hidden: rowsData[i][l]["columns"][k]["columnHidden"],
                    name: rowsData[i][l]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][l]["columns"][k]["acronymTitle"],
                    multiple: false,
                  ),
                ),
              );
              columnWidgets2.addIf(
                k == 1,
                SizedBox(
                  width:
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3) - ((12 / 3) * 9)
                              : (Get.width / 2) - ((12 / 2) * 8)
                          : Get.width - 5,
                  child: FormWidgets.headerCenteredBlue(
                    hidden: rowsData[i][l]["columns"][k]["columnHidden"],
                    name: rowsData[i][l]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][l]["columns"][k]["acronymTitle"],
                    multiple: false,
                  ),
                ),
              );
              columnWidgets3.addIf(
                k == 2,
                SizedBox(
                  width:
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3) - ((12 / 3) * 9)
                              : (Get.width / 2) - ((12 / 2) * 8)
                          : Get.width - 5,
                  child: FormWidgets.headerCenteredBlue(
                    hidden: rowsData[i][l]["columns"][k]["columnHidden"],
                    name: rowsData[i][l]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][l]["columns"][k]["acronymTitle"],
                    multiple: false,
                  ),
                ),
              );
              break;
            case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
              var m = l;
              String? fieldValue;
              rowsData[i][m]["columns"][k]["elementData"].forEach((element) {
                if (element["id"] == (formFieldValues[rowsData[i][m]["columns"][k]["id"].toString()] ?? "0")) {
                  fieldValue = element["name"];
                }
              });
              columnWidgets1.addIf(
                k == 0,
                TextWithIconButton(
                  id: rowsData[i][m]["columns"][k]["id"],
                  rowColor: rowsData[i][m]["formRowBgColor"],
                  multiple: rowsData[i][m]["columns"].length > 1,
                  fieldName: rowsData[i][m]["columns"][k]["formFieldName"],
                  fieldValue:
                      rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]
                          ? formFieldValues[rowsData[i][m]["columns"][k]["id"].toString()]
                          : rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                          ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()] != ""
                              ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : null
                          : fieldValue,
                  bold: rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"] && rowsData[i][m]["columns"][k]["formFieldStSelectMany"] ? true : null,
                  hidden: rowsData[i][m]["columns"][k]["columnHidden"],
                ),
              );
              columnWidgets2.addIf(
                k == 1,
                TextWithIconButton(
                  id: rowsData[i][m]["columns"][k]["id"],
                  rowColor: rowsData[i][m]["formRowBgColor"],
                  multiple: rowsData[i][m]["columns"].length > 1,
                  fieldName: rowsData[i][m]["columns"][k]["formFieldName"],
                  fieldValue:
                      rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]
                          ? formFieldValues[rowsData[i][m]["columns"][k]["id"].toString()]
                          : rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                          ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()] != ""
                              ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : null
                          : fieldValue,
                  bold: rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"] && rowsData[i][m]["columns"][k]["formFieldStSelectMany"] ? true : null,
                  hidden: rowsData[i][m]["columns"][k]["columnHidden"],
                ),
              );
              columnWidgets3.addIf(
                k == 2,
                TextWithIconButton(
                  id: rowsData[i][m]["columns"][k]["id"],
                  rowColor: rowsData[i][m]["formRowBgColor"],
                  multiple: rowsData[i][m]["columns"].length > 1,
                  fieldName: rowsData[i][m]["columns"][k]["formFieldName"],
                  fieldValue:
                      rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]
                          ? formFieldValues[rowsData[i][m]["columns"][k]["id"].toString()]
                          : rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                          ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()] != ""
                              ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : null
                          : fieldValue,
                  bold: rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"] && rowsData[i][m]["columns"][k]["formFieldStSelectMany"] ? true : null,
                  hidden: rowsData[i][m]["columns"][k]["columnHidden"],
                ),
              );
              break;
          }
        }

        widgetsForEachRow.add(Column(children: columnWidgets1));
        widgetsForEachRow.add(Column(children: columnWidgets2));
        widgetsForEachRow.add(Column(children: columnWidgets3));
        break;
      case "77": //Miami Dade Fire Rescue(5)_Daily Cmdr or Pilot(77)
      case "79": //Miami Dade Fire Rescue(5)_OIC FM(79)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];

        for (
          l;
          l < rowsData[i].length &&
              !(rowsData[i][l]["columns"][k]["formFieldName"].toString().contains("Risk") || rowsData[i][l]["columns"][k]["formFieldName"].toString().contains("Daily"));
          l++
        ) {
          for (var n = 0; n < rowsData[i][l]["columns"].length; n++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][l]["columns"][n]["id"].toString()), rowsData[i][l]["columns"][n]["id"].toString());
            switch (rowsData[i][l]["columns"][n]["formFieldType"] as int) {
              case 10: //"SPACER":
                break;
              case 52: //"HEADER CENTERED (GREEN)":
                columnWidgets1.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 54: //"HEADER CENTERED (ORANGE)":
                columnWidgets2.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredOrange(
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 250: //"ACCESSORIES SELECTOR":
                var m = l;
                String? fieldValue;
                rowsData[i][m]["columns"][n]["elementData"].forEach((element) {
                  if (element["id"] == (formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] ?? "0")) {
                    fieldValue = element["name"];
                  }
                });
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
              case 4: //"DROP DOWN - ACCESSIBLE AIRCRAFT":
                var m = l;
                String? fieldValue;
                rowsData[i][m]["columns"][n]["elementData"].forEach((element) {
                  if (element["id"] == (formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] ?? "0")) {
                    fieldValue = element["name"];
                  }
                });
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );

                break;
              case 8: //"AIRCRAFT FLT HOBBS (START)":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][m]["columns"][n]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][m]["columns"][n]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][m]["columns"][n]["id"].toString(), strFormFieldType: rowsData[i][m]["columns"][n]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(id: rowsData[i][m]["columns"][n]["id"].toString(), strFormFieldType: rowsData[i][m]["columns"][n]["formFieldType"])["fieldType"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        closeOutFieldMode:
                            "${htmlValues[rowsData[i][m]["columns"][n]["id"].toString()] != null ? " " : ""}${htmlValues[rowsData[i][m]["columns"][n]["id"].toString()] ?? closeOutAircraftFields(id: rowsData[i][m]["columns"][n]["id"].toString(), strFormFieldType: rowsData[i][m]["columns"][n]["formFieldType"])["label"]} (Forward)",
                        fieldValue:
                            closeOutAircraftFields(id: rowsData[i][m]["columns"][n]["id"].toString(), strFormFieldType: rowsData[i][m]["columns"][n]["formFieldType"])["fieldType"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
              case 1: //"TEXT FIELD (STANDARD)":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
              case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
                var m = l;
                String? fieldValue;
                rowsData[i][m]["columns"][n]["elementData"].forEach((element) {
                  if (element["id"] == (formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] ?? "0")) {
                    fieldValue = element["name"];
                  }
                });
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue:
                            rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"]
                                ? formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()]
                                : rowsData[i][m]["columns"][n]["formFieldStSelectMany"]
                                ? extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()] != ""
                                    ? extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]?.replaceAll("^^^#", ", ")
                                    : null
                                : fieldValue,
                        bold: rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"] && rowsData[i][m]["columns"][n]["formFieldStSelectMany"] ? true : null,
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue:
                            rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"]
                                ? formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()]
                                : rowsData[i][m]["columns"][n]["formFieldStSelectMany"]
                                ? extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()] != ""
                                    ? extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]?.replaceAll("^^^#", ", ")
                                    : null
                                : fieldValue,
                        bold: rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"] && rowsData[i][m]["columns"][n]["formFieldStSelectMany"] ? true : null,
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
              case 27: //"DROP DOWN - NUMBERS 0-50":
                var m = l;
                String? fieldValue;
                rowsData[i][m]["columns"][n]["elementData"].forEach((element) {
                  if (element["id"] == (formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] ?? "0")) {
                    fieldValue = element["name"];
                  }
                });
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                      ),
                    );
                break;
              case 2: //"CHECK BOX (YES/NO)":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: "",
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        icon:
                            formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] != null
                                ? formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] == "on"
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank
                                : rowsData[i][m]["columns"][n]["defaultValue"].toLowerCase() == "checked"
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                        iconColor:
                            formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] != null
                                ? formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] == "on"
                                    ? ColorConstants.primary
                                    : ColorConstants.grey
                                : rowsData[i][m]["columns"][n]["defaultValue"].toLowerCase() == "checked"
                                ? ColorConstants.primary
                                : ColorConstants.grey,
                      ),
                    )
                    : columnWidgets2.add(
                      TextWithIconButton(
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        multiple: rowsData[i][m]["columns"].length > 1,
                        fieldName: rowsData[i][m]["columns"][n]["formFieldName"],
                        fieldValue: "",
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        icon:
                            formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] != null
                                ? formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] == "on"
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank
                                : rowsData[i][m]["columns"][n]["defaultValue"].toLowerCase() == "checked"
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                        iconColor:
                            formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] != null
                                ? formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()] == "on"
                                    ? ColorConstants.primary
                                    : ColorConstants.grey
                                : rowsData[i][m]["columns"][n]["defaultValue"].toLowerCase() == "checked"
                                ? ColorConstants.primary
                                : ColorConstants.grey,
                      ),
                    );
                break;
            }
          }
        }

        widgetsForEachRow.add(Column(children: columnWidgets1));
        widgetsForEachRow.add(Column(children: columnWidgets2));
        break;
      case "1030": //HeliService USA(141)_AIRCRAFT DFL(1030)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];

        for (l; l < rowsData[i].length && rowsData[i][j - 1]["columns"][0]["formFieldType"] != rowsData[i][l]["columns"][0]["formFieldType"]; l++) {
          for (var n = 0; n < rowsData[i][l]["columns"].length; n++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][l]["columns"][n]["id"].toString()), rowsData[i][l]["columns"][n]["id"].toString());
            if (rowsData[i][j]["columns"][0]["formFieldName"].contains("ENGINE")) {
              switch (rowsData[i][l]["columns"][n]["formFieldType"] as int) {
                case 10: //"SPACER":
                  break;
                case 52: //"HEADER CENTERED (GREEN)":
                  columnWidgets1.addIf(
                    k == 0 && n == 0,
                    SizedBox(
                      width:
                          Get.width > 480
                              ? Get.width > 980
                                  ? (Get.width / 3) - ((12 / 3) * 9)
                                  : (Get.width / 2) - ((12 / 2) * 8)
                              : Get.width - 5,
                      child: FormWidgets.headerCenteredGreen(
                        hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                        name: rowsData[i][l]["columns"][n]["formFieldName"],
                        acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                        multiple: false,
                      ),
                    ),
                  );
                  columnWidgets2.addIf(
                    k == 1 && n == 1,
                    SizedBox(
                      width:
                          Get.width > 480
                              ? Get.width > 980
                                  ? (Get.width / 3) - ((12 / 3) * 9)
                                  : (Get.width / 2) - ((12 / 2) * 8)
                              : Get.width - 5,
                      child: FormWidgets.headerCenteredGreen(
                        hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                        name: rowsData[i][l]["columns"][n]["formFieldName"],
                        acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                        multiple: false,
                      ),
                    ),
                  );
                  break;
                case 50: //"HEADER CENTERED (BLUE)":
                  break;
                case 1: //"TEXT FIELD (STANDARD)":
                  var m = l;
                  columnWidgets1.addIf(
                    k == 0 && n == 2,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][l]["formRowBgColor"] != ""
                                ? rowsData[i][l]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][l]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][l]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: TextWithIconButton(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            multiple: rowsData[i][m]["columns"].length > 1,
                            fieldName: rowsData[i][m]["columns"][0]["formFieldName"],
                            fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          ),
                        ),
                      ),
                    ),
                  );
                  columnWidgets2.addIf(
                    k == 1 && n == 4,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][l]["formRowBgColor"] != ""
                                ? rowsData[i][l]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][l]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][l]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: TextWithIconButton(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            multiple: rowsData[i][m]["columns"].length > 1,
                            fieldName: rowsData[i][m]["columns"][0]["formFieldName"],
                            fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          ),
                        ),
                      ),
                    ),
                  );
                  break;
              }
            } else {
              if (k == 0 && rowsData[i][l]["columns"][n]["formFieldType"] == 1) {
                var m = l;
                widgetsForEachRow.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          rowsData[i][l]["formRowBgColor"] != ""
                              ? rowsData[i][l]["formRowBgColor"].toString().length == 4
                                  ? hexToColor("${rowsData[i][l]["formRowBgColor"]}000")
                                  : hexToColor(rowsData[i][l]["formRowBgColor"])
                              : ThemeColorMode.isDark
                              ? Colors.grey[900]
                              : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: TextWithIconButton(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          multiple: rowsData[i][m]["columns"].length > 1,
                          fieldName: rowsData[i][m]["columns"][n]["formFieldName"] == "" ? "No. ${n == 2 ? 1 : 2} BEARING ERROR" : rowsData[i][m]["columns"][n]["formFieldName"],
                          fieldValue: formFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }
        }

        if (rowsData[i][j]["columns"][0]["formFieldName"].contains("ENGINE")) {
          widgetsForEachRow.add(Column(children: columnWidgets1));
          widgetsForEachRow.add(Column(children: columnWidgets2));
        }
        break;
      default:
        break;
    }
  }

  Future<void> initialPostProcessing() async {
    if (doPostProcessing) {
      if ((viewUserFormData["closeOutFormImport"] ?? false) && ((viewUserFormData["importPilotLogAfterCloseOut"] ?? "") == "Yes")) {
        await importCloseOut(formId: Get.parameters["formId"] ?? viewUserFormAllData["formId"].toString());
      }
      if ((viewUserFormData["faaLaserStrikeURL"] ?? "") != "") {
        Uri url = Uri.parse(viewUserFormData["faaLaserStrikeURL"] ?? "");
        var urlLaunchAble = await canLaunchUrl(url);
        if (urlLaunchAble) {
          await launchUrl(url);
        } else {
          SnackBarHelper.openSnackBar(isError: true, message: "FAA Laser Strike URL can't be Launched.");
        }
      }

      if (emailSarAndShiftSummaryReports) {
        if ((postProcessingAllData["objFormReportAttachment"]["fileName"] ?? "") != "") {
          Response emailPostResponse = await FormsApiProvider().postEmailProcessingReport(
            fileName: postProcessingAllData["objFormReportAttachment"]["fileName"],
            subject: postProcessingAllData["objFormReportAttachment"]["subject"],
            address: postProcessingAllData["objFormReportAttachment"]["address"],
            formId: postProcessingAllData["objFormReportAttachment"]["formId"],
            subAction: postProcessingAllData["objFormReportAttachment"]["subAction"],
          );

          if (emailPostResponse.statusCode == 200) {
            //--Collier County Aviation Bureau ( Flight Log )
            if ((viewUserFormData["systemId"] ?? UserSessionInfo.systemId).toString() == "130" &&
                (viewUserFormData["formType"] ?? Get.parameters["masterFormId"]).toString() == "917") {
              await LoaderHelper.loaderWithGifAndText("Generating Daily Report....");
              Map<String, dynamic>? dailyFlightLogReportData = postProcessingAllData["objEmailDailyFlightLogReport917Data"] as Map<String, dynamic>?;
              String fileTitle = "Daily Report Generated (${viewUserFormData["formId"] ?? Get.parameters["formId"]})";
              String outputFileName = "${fileTitle}_${DateFormat('MM-dd-yyyy_HH-mm-ss').format(DateTimeHelper.now)}_${Random().nextInt(100000000)}".replaceAll(" ", "_");

              await EasyLoading.dismiss();
              SnackBarHelper.openSnackBar(isError: false, title: "Daily Flight Log Report", message: "Daily Flight Log Report Generated Successfully.");
              Get.to(
                () => ViewPrintSavePdf(
                  pdfFile:
                      (pageFormat) => ViewUserFormTopBottomLayers().postFormProcessingEmailReport917(
                        pageFormat: pageFormat,
                        msg: dailyFlightLogReportData,
                        strTitle: fileTitle,
                        createdAt: DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now),
                        emailTo: UserSessionInfo.userFullName,
                        formIDForAttachments: "${viewUserFormData["formId"] ?? Get.parameters["formId"]}",
                      ),
                  initialPageFormat: PdfPageFormat.a4.landscape,
                  fileName: outputFileName,
                ),
              );
            }
          }
        }
      }
    }
  }

  Future<Uint8List> viewFormPdf({PdfPageFormat? pageFormat, required String mode}) async {
    final doc = pdf.Document();

    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    ByteData? logoImage;
    await rootBundle.load(AssetConstants.logo).then((value) => logoImage = value);

    doc.addPage(
      pdf.MultiPage(
        theme: themeData,
        maxPages: 700,
        margin: pdf.EdgeInsets.fromLTRB(mode == "Print" ? 55.0 : 30.0, mode == "Print" ? 45.0 : 20.0, mode == "Print" ? 55.0 : 45.0, mode == "Print" ? 45.0 : 55.0),
        pageFormat: pageFormat,
        crossAxisAlignment: pdf.CrossAxisAlignment.center,
        header:
            (context) =>
                mode == "ViewForm"
                    ? pdf.Padding(
                      padding: const pdf.EdgeInsets.only(bottom: 8.0),
                      child: pdf.Column(
                        children: [
                          pdf.Row(
                            crossAxisAlignment: pdf.CrossAxisAlignment.start,
                            children: [
                              pdf.Expanded(child: pdf.Text(formName.value, style: const pdf.TextStyle(fontSize: 16), textAlign: pdf.TextAlign.left)),
                              pdf.Expanded(
                                child: pdf.Text(
                                  "Owner: ${formsViewDetails["userNameCreated"].toString()}",
                                  style: const pdf.TextStyle(fontSize: 16),
                                  textAlign: pdf.TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          pdf.Row(
                            mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                            children: [
                              pdf.Text("Form ID: ${viewUserFormAllData["formId"].toString()}", style: const pdf.TextStyle(fontSize: 16)),
                              if (context.pageNumber == 1) pdf.Expanded(child: pdf.Image(pdf.MemoryImage(logoImage!.buffer.asUint8List()))),
                              pdf.Text("Status: ${formsViewDetails["completedBy"] != 0 ? "Completed" : "In Progress"}", style: const pdf.TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    )
                    : context.pageNumber == 1
                    ? pdf.Padding(
                      padding: const pdf.EdgeInsets.only(bottom: 8.0),
                      child: pdf.Column(
                        children: [
                          pdf.Row(
                            children: [
                              pdf.Expanded(child: pdf.Image(pdf.MemoryImage(logoImage!.buffer.asUint8List()))),
                              pdf.Column(
                                children: [
                                  pdf.Text(UserSessionInfo.systemName.toString(), style: const pdf.TextStyle(fontSize: 16)),
                                  pdf.Text("User: ${formsViewDetails["userNameCreated"].toString()}", style: const pdf.TextStyle(fontSize: 16), textAlign: pdf.TextAlign.right),
                                ],
                              ),
                            ],
                          ),
                          pdf.Row(
                            children: [
                              pdf.Expanded(child: pdf.Text(formName.value, style: pdf.TextStyle(fontSize: 18, fontWeight: pdf.FontWeight.bold), textAlign: pdf.TextAlign.left)),
                              pdf.Expanded(
                                child: pdf.Column(
                                  crossAxisAlignment: pdf.CrossAxisAlignment.end,
                                  children: [
                                    pdf.RichText(
                                      textAlign: pdf.TextAlign.right,
                                      text: pdf.TextSpan(
                                        style: const pdf.TextStyle(fontSize: 16),
                                        children: [
                                          const pdf.TextSpan(text: "Created By: "),
                                          pdf.TextSpan(text: formsViewDetails["userNameCreated"], style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
                                          const pdf.TextSpan(text: " At "),
                                          pdf.TextSpan(text: formsViewDetails["createdAt"], style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    formsViewDetails["completedBy"] == 0
                                        ? pdf.Text("Status: In Progress", style: const pdf.TextStyle(fontSize: 16))
                                        : pdf.RichText(
                                          textAlign: pdf.TextAlign.right,
                                          text: pdf.TextSpan(
                                            style: const pdf.TextStyle(fontSize: 16),
                                            children: [
                                              const pdf.TextSpan(text: "Completed By: "),
                                              pdf.TextSpan(text: formsViewDetails["userNameCompleted"], style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
                                              const pdf.TextSpan(text: " At "),
                                              pdf.TextSpan(text: formsViewDetails["completedAt"], style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
                                              formsViewDetails["completedIpAddress"] != ""
                                                  ? pdf.TextSpan(text: " From ${formsViewDetails["completedIpAddress"]}")
                                                  : const pdf.TextSpan(),
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    : pdf.SizedBox(),
        footer:
            (context) =>
                mode == "ViewForm"
                    ? pdf.Row(
                      children: [
                        pdf.Expanded(child: pdf.Text(UserSessionInfo.systemName.toString(), style: const pdf.TextStyle(fontSize: 16))),
                        pdf.Expanded(
                          child: pdf.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pdf.TextStyle(fontSize: 16), textAlign: pdf.TextAlign.center),
                        ),
                        pdf.Expanded(
                          child: pdf.Text(
                            DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now),
                            style: const pdf.TextStyle(fontSize: 16),
                            textAlign: pdf.TextAlign.right,
                          ),
                        ),
                      ],
                    )
                    : pdf.SizedBox(),
        build: (context) {
          return [
            pdf.ListView.builder(
              itemCount: pdfData.length,
              itemBuilder: (context, i) {
                return pdf.Column(
                  crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
                  children: [
                    if (pdfData[i][0]["tabName"] != null)
                      pdf.Padding(
                        padding: const pdf.EdgeInsets.symmetric(vertical: 5),
                        child: pdf.Text(
                          pdfData[i][0]["tabName"],
                          style: pdf.TextStyle(
                            fontSize: Theme.of(Get.context!).textTheme.bodyMedium?.fontSize,
                            fontWeight: pdf.FontWeight.bold,
                            decoration: pdf.TextDecoration.underline,
                          ),
                        ),
                      ),
                    pdf.Padding(
                      padding: const pdf.EdgeInsets.symmetric(horizontal: 2),
                      child: pdf.Wrap(
                        alignment: pdfData[i][0]["fieldName"].toString().contains("Centered") && pdfData[i].length == 1 ? pdf.WrapAlignment.center : pdf.WrapAlignment.spaceBetween,
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: [for (var j = 0; j < pdfData[i].length; j++) widgetsForPdf(i: i, j: j, mode: mode)],
                      ),
                    ),
                    if (pdfData[i][0]["formFieldType"] != 10 && pdfData[i][0]["formFieldType"] != 11)
                      pdf.Padding(
                        padding: const pdf.EdgeInsets.symmetric(vertical: 5),
                        child: pdf.Divider(height: 1, color: mode == "ViewForm" ? PdfColors.red : PdfColors.black, thickness: 2.0),
                      ),
                  ],
                );
              },
            ),
          ];
        },
      ),
    );
    return await doc.save();
  }

  pdf.Widget widgetsForPdf({required int i, required int j, required String mode}) {
    switch (pdfData[i][j]["formFieldType"] as int) {
      //General Fields
      // case "------ FIELDS FOR PILOT PROFILES -------":
      // case "--------------GENERAL FIELDS---------------":
      // case "---- FIELDS FOR SELECTED AIRCRAFT ----":
      // case "--------- FORMATTING FIELDS ----------":
      // case "---- FIELDS FOR PRATT WHITNEY --":
      // case "--------- FUEL FARM FIELDS ----------":
      // case "--------- FORM CHOOSER ----------":
      // case "--------- SIGNATURE FIELDS ----------":
      // case "---- FIELDS SHOWN IF NPNG AIRCRAFT ----------":
      // case "---------------- APU FIELDS ------------------":
      // case "--------- MISC AIRCRAFT FIELDS ----------":
      // case "--------- AUTOMATION FIELDS ----------":
      // case "--------- USER ROLES ----------":

      //break;

      //Text Fields
      case 1: //"TEXT FIELD (STANDARD)":
      case 37: //"NUMBER - INTEGER/WHOLE NUMBER":
      case 38: //"NUMBER - DECIMAL 1 PLACE":
      case 39: //"NUMBER - DECIMAL 2 PLACES":
      case 40: //"NUMBER - DECIMAL 3 PLACES":
      case 41: //"NUMBER - DECIMAL 4 PLACES":
      case 42: //"ACCESSORIES SELECTOR - HOBBS AUGMENT":
      case 43: //"ACCESSORIES SELECTOR - CYCLES AUGMENT":
      case 122: //"FAR PART 91 HOURS (TOTAL)":
      case 123: //"FAR PART 135 HOURS (TOTAL)":
      case 125: //UNKNOWN
      case 126: //"HIDDEN DATA FIELD":
      case 24: //"DATE (FLIGHT DATE)":
      case 5: //"DATE (OTHER DATE)":
      case 7: //"TIME (HH:MM)":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: formFieldValues[pdfData[i][j]["id"].toString()] == "1900-01-01" ? null : formFieldValues[pdfData[i][j]["id"].toString()],
          hidden: pdfData[i][j]["columnHidden"],
        );

      case 28: //"TEXT FIELD (EXTENDED)":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: extendedFieldsValue[pdfData[i][j]["id"].toString()] ?? "",
          hidden: pdfData[i][j]["columnHidden"],
        );

      //Check Boxes
      //Automation Fields
      case 2: //"CHECK BOX (YES/NO)":
      case 143: //"FAA LASER STRIKE REPORTING":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue:
              mode == "ViewForm"
                  ? formFieldValues[pdfData[i][j]["id"].toString()] == "on"
                      ? "Yes"
                      : "No"
                  : "",
          hidden: pdfData[i][j]["columnHidden"],
          icon:
              mode == "Print"
                  ? formFieldValues[pdfData[i][j]["id"].toString()] != null
                      ? formFieldValues[pdfData[i][j]["id"].toString()] == "on"
                          ? 0xe834
                          : 0xe835
                      : pdfData[i][j]["defaultValue"].toLowerCase() == "checked"
                      ? 0xe834
                      : 0xe835
                  : null,
          iconColor:
              formFieldValues[pdfData[i][j]["id"].toString()] != null
                  ? formFieldValues[pdfData[i][j]["id"].toString()] == "on"
                      ? PdfColors.blue
                      : PdfColors.grey
                  : pdfData[i][j]["defaultValue"].toLowerCase() == "checked"
                  ? PdfColors.blue
                  : PdfColors.grey,
        );

      //Dropdowns
      case 4: //"DROP DOWN - ACCESSIBLE AIRCRAFT":
      case 6: //"DROP DOWN - ALL USERS":
      case 27: //"DROP DOWN - NUMBERS 0-50":
      case 31: //"DROP DOWN - NUMBERS 0-100":
      case 32: //"DROP DOWN - NUMBERS 0-150":
      case 25: //"DROP DOWN - CUSTOMERS":
      case 250: //"ACCESSORIES SELECTOR":
      case 3: //"DROP DOWN - FOR TRIGGERED FIELDS ONLY":
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == formFieldValues[pdfData[i][j]["id"].toString()]) {
            fieldValue = element["name"];
          }
        });
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: pdfData[i][j]["formFieldType"] == 6 ? fieldValue ?? "" : pdfData[i][j]["accessibleAircraft"]["aircraft"] ?? fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
          bold: (pdfData[i][j]["formFieldType"] == 6 || pdfData[i][j]["formFieldType"] == 250) ? true : null,
          hidden: pdfData[i][j]["columnHidden"],
        );

      //Hybrid or Combined
      case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == (formFieldValues[pdfData[i][j]["id"].toString()] ?? "0")) {
            fieldValue = element["name"];
          }
        });
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue:
              pdfData[i][j]["formFieldAbilityToAdd"]
                  ? formFieldValues[pdfData[i][j]["id"].toString()]
                  : pdfData[i][j]["formFieldStSelectMany"]
                  ? extendedFieldsValue[pdfData[i][j]["id"].toString()] != ""
                      ? extendedFieldsValue[pdfData[i][j]["id"].toString()]?.replaceAll("^^^#", ", ")
                      : null
                  : fieldValue,
          bold: pdfData[i][j]["formFieldAbilityToAdd"] && pdfData[i][j]["formFieldStSelectMany"] ? true : null,
          hidden: pdfData[i][j]["columnHidden"],
        );

      //CloseOut Form Fields
      case 160: //"ACCESSORIES WITH CYCLES+HOBBS":
        var fieldValues = formFieldValues[pdfData[i][j]["id"].toString()]?.split(",");
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == (fieldValues?[0])) {
            fieldValue = element["name"];
          }
        });
        return pdf.Wrap(
          spacing: 8.0,
          children: [
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: pdfData[i][j]["formFieldName"],
              fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
              hidden: pdfData[i][j]["columnHidden"],
            ),
            pdf.SizedBox(width: 8.0),
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: "Cycles Start",
              fieldValue: fieldValue != "None" ? (fieldValues?[1] ?? "") : "",
              hidden: pdfData[i][j]["columnHidden"],
            ),
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: "Cycles To Add",
              fieldValue: fieldValue != "None" ? (fieldValues?[2] ?? "") : "",
              hidden: pdfData[i][j]["columnHidden"],
            ),
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: "Cycles End",
              fieldValue: fieldValue != "None" ? (fieldValues?[3] ?? "") : "",
              hidden: pdfData[i][j]["columnHidden"],
            ),
            pdf.SizedBox(width: 8.0),
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: "Hobbs Start",
              fieldValue: fieldValue != "None" ? (fieldValues?[4] ?? "") : "",
              hidden: pdfData[i][j]["columnHidden"],
            ),
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: "Hobbs To Add",
              fieldValue: fieldValue != "None" ? (fieldValues?[5] ?? "") : "",
              hidden: pdfData[i][j]["columnHidden"],
            ),
            FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: "Hobbs End",
              fieldValue: fieldValue != "None" ? (fieldValues?[6] ?? "") : "",
              hidden: pdfData[i][j]["columnHidden"],
            ),
          ],
        );

      //Select Multiple
      case 35: //"FLIGHT OPS DOCUMENT SELECTOR":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: extendedFieldsValue[pdfData[i][j]["id"].toString()] != "" ? extendedFieldsValue[pdfData[i][j]["id"].toString()]?.replaceAll("^^^#", ", ") : null,
          hidden: pdfData[i][j]["columnHidden"],
        );

      case 152: //"MEDICATION SELECTOR":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: extendedFieldsValue[pdfData[i][j]["id"].toString()],
          hidden: pdfData[i][j]["columnHidden"],
        );

      case 26: //"GPS COORDINATES - DDD MM.MMM FORMAT":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue:
              formFieldValues[pdfData[i][j]["id"].toString()] != null
                  ? formFieldValues[pdfData[i][j]["id"].toString()].toString().replaceAll("N", "' \"N").replaceAll("W", "' \"W")
                  : "",
          hidden: pdfData[i][j]["columnHidden"],
          icon:
              mode == "Print"
                  ? formFieldValues[pdfData[i][j]["id"].toString()] != null
                      ? 0xe80b
                      : null
                  : null,
          iconColor: PdfColors.green,
        );

      //Field for Pilot Profiles

      //Text Fields
      case 61: //"PIC TIME":
      case 62: //"SIC TIME":
      case 63: //"NVG TIME":
      case 64: //"DAY FLIGHT TIME":
      case 65: //"NIGHT FLIGHT TIME":
      case 68: //"INSTRUMENT TIME (ACTUAL)":
      case 69: //"INSTRUMENT TIME (SIMULATED)":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: double.tryParse(formFieldValues[pdfData[i][j]["id"].toString()].toString())?.toStringAsFixed(1) ?? "0.0",
          hidden: pdfData[i][j]["columnHidden"],
        );

      //Dropdowns
      case 66: //"DAY LANDINGS":
      case 67: //"NIGHT LANDINGS":
      case 70: //"APPROACHES (ILS)":
      case 71: //"APPROACHES (LOCALIZER)":
      case 72: //"APPROACHES (LPV)":
      case 73: //"APPROACHES (LNAV)":
      case 74: //"APPROACHES (VOR)":
      case 75: //"OPERATIONS (HNVGO)":
      case 91: //"AIRCRAFT REPOSITION TO BASE":
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == (formFieldValues[pdfData[i][j]["id"].toString()] ?? "0")) {
            fieldValue = double.tryParse(element["name"].toString())?.toStringAsFixed(1) ?? element["name"] ?? "0.0";
          }
        });
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
          hidden: pdfData[i][j]["columnHidden"],
        );

      //Fields for Selected Aircraft
      //Fields Shown IF NPNG Aircraft
      //Apu Fields
      //Fuel Farm Fields
      //CloseOut Form Fields
      case 8 || 9 || 12 || 14 || 97 || 110 || 13 || 15 || 107 || 119 || 76 || 79 || 82 || 85 || 88 || 101 || 104 || 113 || 116 || 29 || 94 || 33: //CloseOut Fields (Forward)
      case 131 || 134 || 137 || 140 || 145 || 148 || 44 || 47 || 151 || 163 || 166 || 169 || 172 || 175 || 178 || 181 || 184 || 187 || 190 || 193 || 196:
      case 251 || 254 || 257 || 260: //--- These fields don't have a traditional header / title
        /*case 8: //"AIRCRAFT FLT HOBBS (START)":
        case 9: //"AIRCRAFT BILL-MISC HOBBS (START)":
        case 145: //"AUX HOBBS (START)":
        case 151: //"AIRCRAFT TOTAL TIME (START)":
        case 29: //"LANDINGS (START)":
        case 94: //"LANDINGS - RUN ON (START)":
        case 33: //"TORQUE EVENTS (START)":
        case 44: //"HOIST CYCLES (START)":
        case 47: //"HOOK CYCLES (START)":
        case 12: //"E1: STARTS/N1/NG/CCY/CT/CT (START)":
        case 14: //"E2: STARTS/N1/NG/CCY/CT/CT (START)":
        case 97: //"E3: STARTS/N1/NG/CCY/CT/CT (START)":
        case 110: //"E4: STARTS/N1/NG/CCY/CT/CT (START)":
        case 85: //"E1: N2/PCY/PT1/PT1 (START)":
        case 88: //"E2: N2/PCY/PT1/PT1 (START)":
        case 101: //"E3: N2/PCY/PT1/PT1 (START)":
        case 113: //"E4: N2/PCY/PT1/PT1 (START)":
        case 76: //"E1: TOTAL TIME (START)":
        case 79: //"E2: TOTAL TIME (START)":
        case 104: //"E3: TOTAL TIME (START)":
        case 116: //"E4: TOTAL TIME (START)":
        case 13: //"E1: NPNF/ICY/IMP/IMP (START)":
        case 15: //"E2: NPNF/ICY/IMP/IMP (START)":
        case 107: //"E3: NPNF/ICY/IMP/IMP (START)":
        case 119: //"E4: NPNF/ICY/IMP/IMP (START)":
        case 131: //"E1: PRATT ENGINE CYCLES (START)":
        case 134: //"E2: PRATT ENGINE CYCLES (START)":
        case 137: //"E3: PRATT ENGINE CYCLES (START)":
        case 140: //"E4: PRATT ENGINE CYCLES (START)":
        case 82: //"APU: TOTAL TIME (START)":
        case 148: //"FUEL FARM FILLED BEGINNING AMOUNT":
        case 163: //"E1: CT COVER (START)":
        case 166: //"E2: CT COVER (START)":
        case 169: //"E1: CT CREEP (START)":
        case 172: //"E2: CT CREEP (START)":
        case 175: //"E1: HP COMPRESSOR (START)":
        case 178: //"E2: HP COMPRESSOR (START)":
        case 181: //"E1: PT 1 CREEP (START)":
        case 184: //"E2: PT 1 CREEP (START)":
        case 187: //"E1: PT 2 CREEP (START)":
        case 190: //"E2: PT 2 CREEP (START)":
        case 193: //"E1: PT 2 DISC (START)":
        case 196: //"E2: PT 2 DISC (START)":
        case 251: //"CAT.A Operations (Start)":
        case 254: //"AVCS INOP (Start)":
        case 257: //"MTOW FHS (Start)":
        case 260: //"MTOW LDS (Start)":*/
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          closeOutFieldMode:
              "${htmlValues[pdfData[i][j]["id"].toString()] != null ? " " : ""}${htmlValues[pdfData[i][j]["id"].toString()] ?? closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["label"]} (Forward)",
          fieldValue: closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["fieldValue"],
          hidden: pdfData[i][j]["columnHidden"],
        );

      case 55 || 56 || 57 || 58 || 98 || 111 || 59 || 60 || 108 || 120 || 77 || 80 || 83 || 86 || 89 || 102 || 105 || 114 || 117 || 22 || 95 || 23: //CloseOut Fields (To Add)
      case 132 || 135 || 138 || 141 || 146 || 149 || 45 || 48 || 158 || 164 || 167 || 170 || 173 || 176 || 179 || 182 || 185 || 188 || 191 || 194 || 197:
      case 252 || 255 || 258 || 261: //--- These fields don't have a traditional header / title
        /*case 55: //"AIRCRAFT FLT HOBBS (TO ADD)":
        case 56: //"AIRCRAFT BILL-MISC HOBBS (TO ADD)":
        case 146: //"AUX HOBBS (TO ADD)":
        case 158: //"AIRCRAFT TOTAL TIME (TO ADD)":
        case 22: //"LANDINGS (TO ADD)":
        case 95: //"LANDINGS - RUN ON (TO ADD)":
        case 23: //"TORQUE EVENTS (TO ADD)":
        case 45: //"HOIST CYCLES (TO ADD)":
        case 48: //"HOOK CYCLES (TO ADD)":
        case 57: //"E1: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 58: //"E2: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 98: //"E3: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 111: //"E4: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 86: //"E1: N2/PCY/PT1/PT1 (TO ADD)":
        case 89: //"E2: N2/PCY/PT1/PT1 (TO ADD)":
        case 102: //"E3: N2/PCY/PT1/PT1 (TO ADD)":
        case 114: //"E4: N2/PCY/PT1/PT1 (TO ADD)":
        case 77: //"E1: TOTAL TIME (TO ADD)":
        case 80: //"E2: TOTAL TIME (TO ADD)":
        case 105: //"E3: TOTAL TIME (TO ADD)":
        case 117: //"E4: TOTAL TIME (TO ADD)":
        case 59: //"E1: NPNF/ICY/IMP/IMP (TO ADD)":
        case 60: //"E2: NPNF/ICY/IMP/IMP (TO ADD)":
        case 108: //"E3: NPNF/ICY/IMP/IMP (TO ADD)":
        case 120: //"E4: NPNF/ICY/IMP/IMP (TO ADD)":
        case 132: //"E1: PRATT ENGINE CYCLES (TO ADD)":
        case 135: //"E2: PRATT ENGINE CYCLES (TO ADD)":
        case 138: //"E3: PRATT ENGINE CYCLES (TO ADD)":
        case 141: //"E4: PRATT ENGINE CYCLES (TO ADD)":
        case 83: //"APU: TOTAL TIME (TO ADD)":
        case 149: //"FUEL FARM FILLED TO ADD":
        case 164: //"E1: CT COVER (TO ADD)":
        case 167: //"E2: CT COVER (TO ADD)":
        case 170: //"E1: CT CREEP (TO ADD)":
        case 173: //"E2: CT CREEP (TO ADD)":
        case 176: //"E1: HP COMPRESSOR (TO ADD)":
        case 179: //"E2: HP COMPRESSOR (TO ADD)":
        case 182: //"E1: PT 1 CREEP (TO ADD)":
        case 185: //"E2: PT 1 CREEP (TO ADD)":
        case 188: //"E1: PT 2 CREEP (TO ADD)":
        case 191: //"E2: PT 2 CREEP (TO ADD)":
        case 194: //"E1: PT 2 DISC (TO ADD)":
        case 197: //"E2: PT 2 DISC (TO ADD)":
        case 252: //"CAT.A Operations (To Add)":
        case 255: //"AVCS INOP (To Add)":
        case 258: //"MTOW FHS (To Add)":
        case 261: //"MTOW LDS (To Add)":*/
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          closeOutFieldMode:
              "${htmlValues[pdfData[i][j]["id"].toString()] != null ? " " : ""}${htmlValues[pdfData[i][j]["id"].toString()] ?? closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["label"]} (To Add)",
          fieldValue: closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["fieldValue"],
          hidden: pdfData[i][j]["columnHidden"],
        );

      case 16 || 17 || 18 || 19 || 100 || 112 || 20 || 21 || 109 || 121 || 78 || 81 || 84 || 87 || 90 || 103 || 106 || 115 || 118 || 30 || 96 || 34: //CloseOut Fields (End)
      case 133 || 136 || 139 || 142 || 147 || 150 || 46 || 49 || 159 || 165 || 168 || 171 || 174 || 177 || 180 || 183 || 186 || 189 || 192 || 195 || 198:
      case 253 || 256 || 259 || 262: //--- These fields don't have a traditional header / title
        /*case 16: //"AIRCRAFT FLT HOBBS (END)":
        case 17: //"AIRCRAFT BILL-MISC HOBBS (END)":
        case 147: //"AUX HOBBS (END)":
        case 159: //"AIRCRAFT TOTAL TIME (END)":
        case 30: //"LANDINGS (END)":
        case 96: //"LANDINGS - RUN ON (END)":
        case 34: //"TORQUE EVENTS (END)":
        case 46: //"HOIST CYCLES (END)":
        case 49: //"HOOK CYCLES (END)":
        case 18: //"E1: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 19: //"E2: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 100: //"E3: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 112: //"E4: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 87: //"E1: N2/PCY/PT1/PT1 (END)":
        case 90: //"E2: N2/PCY/PT1/PT1 (END)":
        case 103: //"E3: N2/PCY/PT1/PT1 (END)":
        case 115: //"E4: N2/PCY/PT1/PT1 (END)":
        case 78: //"E1: TOTAL TIME (END)":
        case 81: //"E2: TOTAL TIME (END)":
        case 106: //"E3: TOTAL TIME (END)":
        case 118: //"E4: TOTAL TIME (END)":
        case 20: //"E1: NPNF/ICY/IMP/IMP (END)":
        case 21: //"E2: NPNF/ICY/IMP/IMP (END)":
        case 109: //"E3: NPNF/ICY/IMP/IMP (END)":
        case 121: //"E4: NPNF/ICY/IMP/IMP (END)":
        case 133: //"E1: PRATT ENGINE CYCLES (END)":
        case 136: //"E2: PRATT ENGINE CYCLES (END)":
        case 139: //"E3: PRATT ENGINE CYCLES (END)":
        case 142: //"E4: PRATT ENGINE CYCLES (END)":
        case 84: //"APU: TOTAL TIME (END)":
        case 150: //"FUEL FARM FILLED ENDING AMOUNT":
        case 165: //"E1: CT COVER (END)":
        case 168: //"E2: CT COVER (END)":
        case 171: //"E1: CT CREEP (END)":
        case 174: //"E2: CT CREEP (END)":
        case 177: //"E1: HP COMPRESSOR (END)":
        case 180: //"E2: HP COMPRESSOR (END)":
        case 183: //"E1: PT 1 CREEP (END)":
        case 186: //"E2: PT 1 CREEP (END)":
        case 189: //"E1: PT 2 CREEP (END)":
        case 192: //"E2: PT 2 CREEP (END)":
        case 195: //"E1: PT 2 DISC (END)":
        case 198: //"E2: PT 2 DISC (END)":
        case 253: //"CAT.A Operations (END)":
        case 256: //"AVCS INOP (END)":
        case 259: //"MTOW FHS (END)":
        case 262: //"MTOW LDS (END)":*/
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          closeOutFieldMode:
              "${htmlValues[pdfData[i][j]["id"].toString()] != null ? " " : ""}${htmlValues[pdfData[i][j]["id"].toString()] ?? closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["label"]} (Ending)",
          fieldValue: closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["fieldValue"],
          hidden: pdfData[i][j]["columnHidden"],
        );

      case 154: //"E1: CREEP DAMAGE PERCENT (END)":
      case 155: //"E2: CREEP DAMAGE PERCENT (END)":
      case 156: //"E3: CREEP DAMAGE PERCENT (END)":
      case 157: //"E4: CREEP DAMAGE PERCENT (END)":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          closeOutFieldMode:
              "${htmlValues[pdfData[i][j]["id"].toString()] != null ? " " : ""}${htmlValues[pdfData[i][j]["id"].toString()] ?? closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["label"]} (Ending)",
          fieldValue: closeOutAircraftFields(id: pdfData[i][j]["id"].toString(), strFormFieldType: pdfData[i][j]["formFieldType"])["fieldValue"],
          hidden: pdfData[i][j]["columnHidden"],
        );

      //MISC Aircraft Fields
      //Text Fields
      case 36: //"UPDATE AC FUEL IN LBS":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: formFieldValues[pdfData[i][j]["id"].toString()],
          hidden: pdfData[i][j]["columnHidden"],
        );

      //Formatting Fields
      //Field Formatters
      case 10: //"SPACER":
        return pdf.SizedBox.shrink();
      case 11: //"NEW LINE":
        return pdf.SizedBox.shrink();

      //Headers
      case 50: //"HEADER CENTERED (BLUE)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], header: true);
      case 52: //"HEADER CENTERED (GREEN)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], header: true);
      case 54: //"HEADER CENTERED (ORANGE)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], header: true);
      case 53: //"HEADER CENTERED (RED)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], header: true);
      case 51: //"HEADER CENTERED (WHITE)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], header: true);
      case 92: //"HEADER CENTERED (CUSTOM)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], header: true);
      case 127: //"HEADER (CUSTOM)":
        return FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], hidden: pdfData[i][j]["columnHidden"], fieldValue: "");

      //Signature
      case 99: //"SIGNATURE - ELECTRONIC":
        return pdfData[i][j]["top100ElectronicSignatureData"].isNotEmpty
            ? FormWidgets.formPdfWidget(
              id: pdfData[i][j]["id"],
              fieldName: pdfData[i][j]["formFieldName"],
              fieldValue:
                  "${pdfData[i][j]["top100ElectronicSignatureData"][0]["signedByName"]} At ${pdfData[i][j]["top100ElectronicSignatureData"][0]["signedTime"]} From ${pdfData[i][j]["top100ElectronicSignatureData"][0]["ipAddress"]}",
              hidden: pdfData[i][j]["columnHidden"],
            )
            : FormWidgets.formPdfWidget(id: pdfData[i][j]["id"], fieldName: pdfData[i][j]["formFieldName"], fieldValue: "Not Signed", hidden: pdfData[i][j]["columnHidden"]);
      case 124: //"SIGNATURE - PEN":
        if (pdfData[i][j]["electronicSignaturePenData"]["signatureData"] != null &&
            pdfData[i][j]["electronicSignaturePenData"]["signatureData"] != "{}" &&
            pdfData[i][j]["electronicSignaturePenData"]["signatureData"] != "") {
          var drawSignaturePointData = {};
          List<Point>? signaturePointList = [];

          drawSignaturePointData = jsonDecode(pdfData[i][j]["electronicSignaturePenData"]["signatureData"]);

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
          signaturePointLists.addIf(true, pdfData[i][j]["id"].toString(), signaturePointList);
          signatureController.putIfAbsent(
            pdfData[i][j]["id"].toString(),
            () => SignatureController(disabled: true, penStrokeWidth: 2, penColor: ColorConstants.black, exportBackgroundColor: Colors.blue),
          );
          signatureController[pdfData[i][j]["id"].toString()]?.points = signaturePointLists[pdfData[i][j]["id"].toString()]!;
        }
        return FormWidgets.signaturePenViewPdf(
          id: pdfData[i][j]["id"],
          hidden: pdfData[i][j]["columnHidden"],
          fieldName: pdfData[i][j]["formFieldName"],
          signatureName: pdfData[i][j]["electronicSignaturePenData"]["signatureName"] != "" ? pdfData[i][j]["electronicSignaturePenData"]["signatureName"] : null,
          signatureTime: pdfData[i][j]["electronicSignaturePenData"]["signatureTime"] != "" ? pdfData[i][j]["electronicSignaturePenData"]["signatureTime"] : null,
        );

      //Automation Fields
      case 153: //"GENERATE AUTOMATIC ID (YYYYDDMM###)":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: formFieldValues[pdfData[i][j]["id"].toString()],
          hidden: pdfData[i][j]["columnHidden"],
        );
      case 144: //"RISK ASSESSMENT CHOOSER":
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue:
              (pdfData[i][j]["riskAssessmentData"]["id"] ?? 0) > 0
                  ? "${pdfData[i][j]["riskAssessmentData"]["dateCreated"]} [Value: ${pdfData[i][j]["riskAssessmentData"]["riskMatrixValue"]}]"
                  : "None",
          hidden: pdfData[i][j]["columnHidden"],
          icon:
              mode == "Print"
                  ? (pdfData[i][j]["riskAssessmentData"]["id"] ?? 0) > 0
                      ? 0xe8b6
                      : null
                  : null,
          iconColor: PdfColors.blue,
        );

      //User Roles
      case 1000: //"UR: (ANY PILOT)"/"UR: ALL PILOTS":
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == (formFieldValues[pdfData[i][j]["id"].toString()] ?? "0")) {
            fieldValue = element["name"];
          }
        });
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), "") ?? "",
          bold: true,
          hidden: pdfData[i][j]["columnHidden"],
        );

      case >= 200 && < 250: // DropDown UR: User Roles (200-249)
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == (formFieldValues[pdfData[i][j]["id"].toString()] ?? "0")) {
            fieldValue = element["name"];
          }
        });
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
          bold: true,
          hidden: pdfData[i][j]["columnHidden"],
          icon:
              mode == "Print"
                  ? (fieldValue != null && pdfData[i][j]["formFieldType"] >= 350)
                      ? 0xe8b6
                      : null
                  : null,
          iconColor: PdfColors.blue,
        );

      case > 262 && < 350: // Accessory Type Fields (263-349)
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: pdfData[i][j]["formFieldType"] == 0 ? "" : formFieldValues[pdfData[i][j]["id"].toString()],
          hidden: pdfData[i][j]["columnHidden"],
          bold: true,
        );

      case >= 350 && < 450: // DropDown Form Chooser (350-449)
        String? fieldValue;
        pdfData[i][j]["elementData"].forEach((element) {
          if (element["id"] == (formFieldValues[pdfData[i][j]["id"].toString()] ?? "0")) {
            fieldValue = element["name"];
          }
        });
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName: pdfData[i][j]["formFieldName"],
          fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
          bold: true,
          hidden: pdfData[i][j]["columnHidden"],
          icon:
              mode == "Print"
                  ? (fieldValue != null && pdfData[i][j]["formFieldType"] >= 350)
                      ? 0xe8b6
                      : null
                  : null,
          iconColor: PdfColors.blue,
        );

      case 1100 || 1101 || 1102: // Flight Log (From, Via, To)
        return FormWidgets.formPdfWidget(
          id: pdfData[i][j]["id"],
          fieldName:
              pdfData[i][j]["formFieldName"] != ""
                  ? "${pdfData[i][j]["formFieldName"]}${(pdfData[i][j]["formFieldName"].toLowerCase().contains("from") || pdfData[i][j]["formFieldName"].toLowerCase().contains("via") || pdfData[i][j]["formFieldName"].toLowerCase().contains("to")) ? "" : " (${pdfData[i][j]["formFieldType"] == 1100
                          ? "From"
                          : pdfData[i][j]["formFieldType"] == 1101
                          ? "Via"
                          : "To"})"}"
                  : "",
          fieldValue: formFieldValues[pdfData[i][j]["id"].toString()],
          hidden: pdfData[i][j]["columnHidden"],
        );

      default:
        if (pdfData[i][j]["fieldName"] == "" && pdfData[i][j]["elementType"].toString() == "select") {
          String? fieldValue;
          pdfData[i][j]["elementData"].forEach((element) {
            if (element["id"] == (formFieldValues[pdfData[i][j]["id"].toString()] ?? "0")) {
              fieldValue = element["name"];
            }
          });
          return FormWidgets.formPdfWidget(
            id: pdfData[i][j]["id"],
            fieldName: pdfData[i][j]["formFieldName"],
            fieldValue: fieldValue?.replaceAll(RegExp(r'[-*]'), ""),
            bold: true,
            hidden: pdfData[i][j]["columnHidden"],
          );
        } else if (pdfData[i][j]["fieldName"] == "" && pdfData[i][j]["formFieldType"] == 0) {
          return FormWidgets.formPdfWidget(
            id: pdfData[i][j]["id"],
            fieldName: pdfData[i][j]["formFieldName"],
            fieldValue: pdfData[i][j]["formFieldType"] == 0 ? "" : formFieldValues[pdfData[i][j]["id"].toString()],
            hidden: pdfData[i][j]["columnHidden"],
          );
        } else if (kDebugMode) {
          return pdf.Text(
            "Field -${pdfData[i][j]["formFieldName"]}- is not created.\nField Type (${pdfData[i][j]["formFieldType"]}): -${pdfData[i][j]["fieldName"]}-\n",
            style: const pdf.TextStyle(color: PdfColors.red),
          );
        } else {
          return pdf.SizedBox.shrink();
        }
    }
  }
}
