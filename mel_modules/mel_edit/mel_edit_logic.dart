import 'dart:ui';

import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/mel_api_provider.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/shared/utils/device_type.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/text_fields.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;

import '../../../helper/date_time_helper.dart';
import '../../../shared/services/device_orientation.dart';
import '../../../shared/services/theme_color_mode.dart';
import '../../../shared/utils/logged_in_data.dart';

class MelEditLogic extends GetxController {
  var isDark = false.obs;

  var isLoading = false.obs;

  var obscureText = true.obs;

  var electronicSignatureEnable = false.obs;

  var saveAndUploadButtonShow = false.obs;

  RxMap<String, bool> melBoolData = <String, bool>{
    "discrepancyPlacardInstalled": false,
    "discrepancyPartsOnOrder": false,
    "correctiveActionOwnerNotified": false,
    "correctiveActionPlacardRemoved": false,
    "extendedMel": false,
  }.obs;

  RxMap<String, bool> melCategory = <String, bool>{
    "categoryA": false,
    "categoryB": false,
    "categoryC": false,
    "categoryD": false,
    "categoryNotSelected": false,
  }.obs;

  var repairCategoryA =
      "[Repair Category A: This category item must be repaired within the time interval specified in the 'Remarks or Exceptions' column of the aircraft operator's approved MEL. For time intervals specified in 'calendar days' or 'flight days', the day the malfunction was recorded in the aircraft maintenance record/logbook is excluded. For all other time intervals (i.e., flights, flight legs, cycles, hours, etc.), repair tracking begins at the point when the malfunction is deferred in accordance with the operator's approved MEL.]";

  var repairCategoryB =
      "[Repair Category B: This category item must be repaired within 3 consecutive calendar-days (72 hours) excluding the day the malfunction was recorded in the aircraft maintenance record/logbook. For example, if it were recorded at 10 a.m. on January 26th, the 3-day interval would begin at midnight the 26th and end at midnight the 29th.]";

  var repairCategoryC =
      "[Repair Category C: This category item must be repaired within 10 consecutive calendar-days (240 hours) excluding the day the malfunction was recorded in the aircraft maintenance record/logbook. For example, if it were recorded at 10 a.m. on January 26th, the 10-day interval would begin at midnight the 26th and end at midnight February 5th.]";

  var repairCategoryD =
      "[Repair Category D: This category item must be repaired within 120 consecutive calendar-days (2880 hours) excluding the day the malfunction was recorded in the aircraft maintenance record/logbook.]";

  RxMap<String, TextEditingController> melEditTextEditingFieldController = <String, TextEditingController>{}.obs;

  var melEditData = {}.obs;

  Map<String, dynamic> melEditPostData = {
    "userId": UserSessionInfo.userId.toString(),
    "systemId": UserSessionInfo.systemId.toString(),
    "melId": Get.parameters["melId"],
    "correctiveAction": "",
    "mELItemNumber": "",
    "logPage": "",
    "correctiveActionLogPage": "",
    "revisionNumber": "",
    "deferredDate": "",
    "expirationDate": "",
    "clearedDate": "",
    "isPlacardInstalled": null,
    "isPlacardRemoved": null,
    "isPartsOnOrder": null,
    "isOwnerNotified": null,
    "lastEditBy": 0,
    "lastEditAt": "",
    "category": "",
    "isExtended": null,
    "purchaseNumber": "",
    "isUpload": false
  };

  var melEditPostDataMatch = {}.obs;

  @override
  void onInit() async {
    super.onInit();
    await apiDataSet();
    await melDataSet();
    await postCallDataSet();
    melEditPostDataMatch.addAll(melEditPostData);
  }

  apiDataSet({reFresh = false}) async {
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    Response data = await MelApiProvider().melEditData(melId: int.parse(Get.parameters["melId"] ?? "0"), melType: Get.parameters["melType"] ?? "Mel");

    if (data.statusCode == 200) {
      if (reFresh == true) {
        melEditData.clear();
        melEditData.addAll(data.data["data"] as Map);
        melBoolData["discrepancyPlacardInstalled"] = melEditData["isPlacardInstalled"];
        melBoolData["discrepancyPartsOnOrder"] = melEditData["isPartsOnOrder"];
        melBoolData["correctiveActionOwnerNotified"] = melEditData["isOwnerNotified"];
        melBoolData["correctiveActionPlacardRemoved"] = melEditData["isPlacardRemoved"];

        melCategory["categoryA"] = melEditData["isCategoryA"];
        melCategory["categoryB"] = melEditData["isCategoryB"];
        melCategory["categoryC"] = melEditData["isCategoryC"];
        melCategory["categoryD"] = melEditData["isCategoryD"];

        saveAndUploadButtonShow.value = melEditData["isExtended"];
        //await someDataCheck();
      } else {
        melEditData.addAll(data.data["data"] as Map);
        melBoolData["discrepancyPlacardInstalled"] = melEditData["isPlacardInstalled"];
        melBoolData["discrepancyPartsOnOrder"] = melEditData["isPartsOnOrder"];
        melBoolData["correctiveActionOwnerNotified"] = melEditData["isOwnerNotified"];
        melBoolData["correctiveActionPlacardRemoved"] = melEditData["isPlacardRemoved"];

        saveAndUploadButtonShow.value = melEditData["isExtended"];

        melCategory["categoryA"] = melEditData["isCategoryA"];
        melCategory["categoryB"] = melEditData["isCategoryB"];
        melCategory["categoryC"] = melEditData["isCategoryC"];
        melCategory["categoryD"] = melEditData["isCategoryD"];
        //await someDataCheck();
      }
    }
    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  melDataSet() {
    melEditTextEditingFieldController.putIfAbsent("mel_item", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("revision", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("po_number", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("log_page_discrepancy", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("date_deferred", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("expiration_date", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("log_page_corrective_action", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("clear_date_corrective_action", () => TextEditingController());
    melEditTextEditingFieldController.putIfAbsent("corrective_action", () => TextEditingController());

    melEditTextEditingFieldController["mel_item"]!.text = melEditData["mELItemNumber"];
    melEditTextEditingFieldController["revision"]!.text = melEditData["revisionNumber"];
    melEditTextEditingFieldController["po_number"]!.text = melEditData["purchaseNumber"];
    melEditTextEditingFieldController["log_page_discrepancy"]!.text = melEditData["logPage"];
    melEditTextEditingFieldController["date_deferred"]!.text = melEditData["deferredDate"] == "01/01/1900" ? "mm/dd/yyyy" : melEditData["deferredDate"];
    melEditTextEditingFieldController["expiration_date"]!.text = melEditData["expirationDate"] == "01/01/1900" ? "mm/dd/yyyy" : melEditData["expirationDate"];
    melEditTextEditingFieldController["log_page_corrective_action"]!.text = melEditData["correctiveActionLogPage"];
    melEditTextEditingFieldController["clear_date_corrective_action"]!.text = melEditData["clearedDate"];
    melEditTextEditingFieldController["corrective_action"]!.text = melEditData["correctiveAction"];
  }

  postCallDataSet() {
    melEditPostData["melId"] = melEditData["melId"];
    melEditPostData["correctiveAction"] = melEditData["correctiveAction"];
    melEditPostData["mELItemNumber"] = melEditData["mELItemNumber"];
    melEditPostData["logPage"] = melEditData["logPage"];
    melEditPostData["correctiveActionLogPage"] = melEditData["correctiveActionLogPage"];
    melEditPostData["revisionNumber"] = melEditData["revisionNumber"];
    melEditPostData["deferredDate"] = melEditData["deferredDate"];
    melEditPostData["expirationDate"] = melEditData["expirationDate"];
    melEditPostData["clearedDate"] = melEditData["clearedDate"];
    melEditPostData["isPlacardInstalled"] = melEditData["isPlacardInstalled"];
    melEditPostData["isPlacardRemoved"] = melEditData["isPlacardRemoved"];
    melEditPostData["isPartsOnOrder"] = melEditData["isPartsOnOrder"];
    melEditPostData["isOwnerNotified"] = melEditData["isOwnerNotified"];
    melEditPostData["lastEditBy"] = melEditData["lastEditBy"];
    melEditPostData["lastEditAt"] = melEditData["lastEditAt"];
    melEditPostData["category"] = melEditData["category"];
    melEditPostData["isExtended"] = melEditData["isExtended"];
    melEditPostData["purchaseNumber"] = melEditData["purchaseNumber"];
    melEditPostData["isUpload"] = melEditData["isUpload"];
  }

  returnMelDetailsView({title, titleValue, subTitleValue, createdBy = false}) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.bold)),
        const SizedBox(width: SizeConstants.contentSpacing),
        titleValue.length > 50
            ? Flexible(child: Text(titleValue, softWrap: true, overflow: TextOverflow.visible))
            : createdBy
                ? RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                        text: titleValue,
                        style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                        children: <TextSpan>[
                          const TextSpan(text: "("),
                          TextSpan(text: subTitleValue, style: const TextStyle(color: Colors.blue)),
                          const TextSpan(text: ")"),
                        ]),
                  )
                : Text(titleValue == "" ? "None" : titleValue, softWrap: true, style: TextStyle(color: titleValue == "" ? Colors.red : null))
      ],
    );
  }

  returnMelTitleView({title}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
      child: Text(title, style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.bold)),
    );
  }

  returnMelTitleValueView({value, subValue, createdBy = false}) {
    return value.length > 50
        ? Flexible(child: Text(value, softWrap: true, overflow: TextOverflow.visible))
        : createdBy
            ? value == ""
                ? Text(value == "" ? "None" : value, softWrap: true, style: TextStyle(color: value == "" ? Colors.red : null))
                : RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                        text: value,
                        style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                        children: <TextSpan>[
                          const TextSpan(text: "("),
                          TextSpan(text: subValue, style: const TextStyle(color: Colors.blue)),
                          const TextSpan(text: ")"),
                        ]),
                  )
            : Text(value == "" || value == null ? "None" : value, softWrap: true, style: TextStyle(color: value == "" ? Colors.red : null));
  }

  returnCategoryMEL({onTap, melCategoryValue, onChangeValue, category, isTablet = false}) {
    return Transform.scale(
      scale: isTablet ? 0.6 : 0.7,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(
              color: ColorConstants.green,
              width: 2.0,
            )),
        onTap: onTap,
        leading: Transform.scale(
          scale: isTablet ? 1.4 : 1.2,
          child: Checkbox(
            checkColor: Colors.white,
            side: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            activeColor: Colors.green,
            value: melCategoryValue,
            shape: const CircleBorder(),
            onChanged: (val) => onChangeValue(val),
          ),
        ),
        trailing: Text(category, style: TextStyle(color: Colors.black, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize!, fontWeight: FontWeight.bold)),
      ),
    );
  }

  returnRepairCategory({String? value}) {
    switch (value) {
      case 'A':
        return Material(
          color: DeviceType.isTablet ? ColorConstants.primary.withValues(alpha: 0.2) : ColorConstants.primary.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(repairCategoryA, softWrap: true),
          ),
        );
      case 'B':
        return Material(
          color: DeviceType.isTablet ? ColorConstants.primary.withValues(alpha: 0.2) : ColorConstants.primary.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(repairCategoryB),
          ),
        );
      case 'C':
        return Material(
          color: DeviceType.isTablet ? ColorConstants.primary.withValues(alpha: 0.2) : ColorConstants.primary.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(repairCategoryC),
          ),
        );
      case 'D':
        return Material(
          color: DeviceType.isTablet ? ColorConstants.primary.withValues(alpha: 0.2) : ColorConstants.primary.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(repairCategoryD),
          ),
        );
    }
  }

  customCategoryADialogView() {
    melEditTextEditingFieldController.putIfAbsent("categoryA", () => TextEditingController());
    melEditTextEditingFieldController["categoryA"]!.text = "0";
    return showDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Padding(
            padding: DeviceType.isTablet ? const EdgeInsets.fromLTRB(150.0, 100.0, 150.0, 100.0) : const EdgeInsets.all(5.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Dialog(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: const BorderSide(color: ColorConstants.primary, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(SizeConstants.contentSpacing),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text("Deferment Days for Category A",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2))),
                        const SizedBox(height: SizeConstants.contentSpacing + 5),
                        Text("Your Deferment Days for Category-A MEL", style: TextStyle(color: Colors.blue, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! - 2)),
                        const SizedBox(height: SizeConstants.contentSpacing + 5),
                        FormBuilderField(
                          name: "categoryA",
                          builder: (FormFieldState<dynamic> field) {
                            return TextFieldConstant.discrepancyAdditionalTextFields(
                                controller: melEditTextEditingFieldController.putIfAbsent("categoryA", () => TextEditingController()),
                                field: field,
                                title: "Enter Days",
                                showSuffixIcon: true,
                                keyboardType: TextInputType.number,
                                hintText: "0",
                                onPressedPlus: () {
                                  var a = int.parse(melEditTextEditingFieldController["categoryA"]!.text.toString()) + 1;
                                  melEditTextEditingFieldController["categoryA"]?.text = a.toString();
                                },
                                onPressedMinimized: () {
                                  // if(int.parse(melEditTextEditingFieldController["categoryA"]!.text.toString()) > 0) {
                                  //   var a = int.parse(melEditTextEditingFieldController["categoryA"]!.text.toString()) - 1;
                                  //   melEditTextEditingFieldController["categoryA"]?.text = a.toString();
                                  // }
                                  var a = int.parse(melEditTextEditingFieldController["categoryA"]!.text.toString()) - 1;
                                  melEditTextEditingFieldController["categoryA"]?.text = a.toString();
                                });
                          },
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 30),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          ButtonConstant.dialogButton(
                            title: "Confirm Category A",
                            btnColor: ColorConstants.primary,
                            borderColor: ColorConstants.grey,
                            onTapMethod: () async {
                              if (int.parse(melEditTextEditingFieldController["categoryA"]!.text.toString()) > 0) {
                                await expirationDateCount(dateCount: melEditTextEditingFieldController["categoryA"]?.text);
                                melEditPostData["category"] = 'A';
                                Get.back();
                              } else {
                                melEditTextEditingFieldController["categoryA"]!.text = "0";
                                SnackBarHelper.openSnackBar(isError: true, message: "Please put only non negative integer");
                              }
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing),
                          ButtonConstant.dialogButton(
                            title: "Cancel",
                            btnColor: ColorConstants.red,
                            borderColor: ColorConstants.grey,
                            onTapMethod: () {
                              melCategory["categoryA"] = false;
                              Get.back();
                            },
                          ),
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  expirationDateCount({dateCount}) {
    melEditTextEditingFieldController.putIfAbsent("expiration_date", () => TextEditingController());

    late final DateTime date;

    if (melEditTextEditingFieldController["date_deferred"]!.text == 'mm/dd/yyyy') {
      date = DateTimeHelper.now;
      melEditTextEditingFieldController["date_deferred"]!.text = DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now);
      melEditPostData["deferredDate"] = melEditTextEditingFieldController["date_deferred"]!.text;
    } else {
      date = DateTimeHelper.dateFormatDefault.parse(melEditTextEditingFieldController["date_deferred"]!.text);
    }

    final result = date.add(Duration(days: int.parse(dateCount)));
    var result1 = result.toString();
    var abc = result1.split(' ');
    var abc1 = abc[0].split('-');
    var newAbc = '${abc1[1]}/${abc1[2]}/${abc1[0]}';

    melEditTextEditingFieldController["expiration_date"]!.text = newAbc;

    melEditPostData["expirationDate"] = melEditTextEditingFieldController["expiration_date"]!.text;
  }

  melEditElectronicSignature({password}) async {
    Response data = await MelApiProvider().melElectronicSignatureValidation(userPassword: password);
    if (data.statusCode == 200) {
      if (data.data["data"]["validatePasswordFlag"] == true) {
        await postCallForMelDataChange();
      } else {
        melEditTextEditingFieldController["electronic_sig_user_password"]!.text = "";
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
      }
    }
  }

  postCallForMelDataChange() async {
    LoaderHelper.loaderWithGif();

    Response data = await MelApiProvider().melUpdatePostData(melUpdateData: melEditPostData);
    await EasyLoading.dismiss();
    if (data.statusCode == 200) {
      if (data.data["data"]["isUpload"] == true) {
        Get.offNamed(Routes.fileUpload, arguments: "melDetails", parameters: {"melId": Get.parameters["melId"].toString(), "melType": "Mel"});
      } else {
        Get.offNamed(Routes.melDetails, parameters: {"melId": data.data["data"]["melId"].toString(), "melType": "Mel"});
      }
    } else {
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
    }
  }

  someDataCheck() async {
    melEditTextEditingFieldController["date_deferred"]!.text = "mm/dd/yyyy";
    melEditTextEditingFieldController["expiration_date"]!.text = "mm/dd/yyyy";
    melEditPostData["deferredDate"] = "";
    melEditPostData["expirationDate"] = "";
  }

  melElectronicSignatureDialog() async {
    melEditTextEditingFieldController.putIfAbsent("electronic_sig_user_name", () => TextEditingController());
    melEditTextEditingFieldController["electronic_sig_user_name"]!.text = UserSessionInfo.userFullName;

    return showDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Padding(
            padding: DeviceType.isTablet
                ? DeviceOrientation.isLandscape
                    ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0)
                    : const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 50.0)
                : const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Dialog(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                    side: const BorderSide(color: ColorConstants.primary, width: 2),
                  ),
                  child: Material(
                    color: ColorConstants.primary.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Center(
                          child: Text(
                            "Electronic Signature",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        Text("By Clicking Below, You Are Certifying The Item Is Accurate & Complete.",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.normal)),
                        FormBuilderField(
                          name: "electronic_signature_user_name",
                          builder: (FormFieldState<dynamic> field) {
                            return TextFieldConstant.discrepancyAdditionalTextFields(
                                controller: melEditTextEditingFieldController.putIfAbsent("electronic_sig_user_name", () => TextEditingController()),
                                field: field,
                                title: "User Name",
                                readOnly: true,
                                showSuffixIcon: false,
                                //keyboardType: TextInputType.number,
                                hintText: "user Name");
                          },
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        FormBuilderField(
                          name: "electronic_signature_user_password",
                          validator: melEditTextEditingFieldController.putIfAbsent("electronic_sig_user_password", () => TextEditingController()).text.isNotEmpty
                              ? null
                              : FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "Password is Required!")]),
                          builder: (FormFieldState<dynamic> field) {
                            return Obx(() {
                              return TextFieldConstant.discrepancyAdditionalTextFields(
                                  controller: melEditTextEditingFieldController.putIfAbsent("electronic_sig_user_password", () => TextEditingController()),
                                  field: field,
                                  title: "Password",
                                  showSuffixIcon: true,
                                  isPassword: true,
                                  obscureTextShow: obscureText.value,
                                  obscureTextShowFunc: () {
                                    obscureText.value ? obscureText.value = false : obscureText.value = true;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: "Password");
                            });
                          },
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          ButtonConstant.dialogButton(
                            title: "Cancel",
                            btnColor: ColorConstants.red,
                            borderColor: ColorConstants.grey,
                            onTapMethod: () {
                              melEditTextEditingFieldController["electronic_sig_user_password"]!.text = "";
                              Get.back();
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing),
                          ButtonConstant.dialogButton(
                            title: "Confirm",
                            btnColor: ColorConstants.primary,
                            borderColor: ColorConstants.grey,
                            onTapMethod: () async {
                              LoaderHelper.loaderWithGif();
                              await melEditElectronicSignature(password: melEditTextEditingFieldController["electronic_sig_user_password"]!.text);
                            },
                          ),
                        ])
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
