import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

import '../helper/date_time_helper.dart';
import '../helper/snack_bar_helper.dart';
import '../shared/constants/constant_storages.dart';
import '../shared/constants/constant_urls.dart';
import '../shared/services/storage_prefs.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class FormsApiProvider {
  final Dio api = ApiProvider.api;

  //Surjit's block START
  // -------------> start here to code

  Future<Response> viewFormFilterData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/index",
          data: jsonEncode({"SystemId": UserSessionInfo.systemId.toString(), "UserId": UserSessionInfo.userId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        e.response?.statusCode == 400
            ? SnackBarHelper.openSnackBar(isError: true, message: e.response?.data["remarks"])
            : SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print("Error on viewFormFilterData(/forms/index): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> viewFormAllData(bool refreshed, {required Map<String, String> data}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/view_forms",
          data: jsonEncode(data),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        e.response?.data["errorMessage"] == "Input string was not in a correct format."
            ? SnackBarHelper.openSnackBar(isError: true, message: "Max Date Range Exceed! Please Select Another Start Date.")
            : SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on viewFormAllData(/forms/view_forms): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        await StoragePrefs().lsDelete(key: StorageConstants.viewFormFilterSelectedData);
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      if (!refreshed) {
        Get.back();
      }
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  ///Gives New FillOut Form ID Against MasterForm/ViewForm ID
  Future<Response> createNewFillOutFormId({required String masterFormId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/create_form",
          data: jsonEncode({"system_id": UserSessionInfo.systemId.toString(), "user_id": UserSessionInfo.userId.toString(), "form_type": masterFormId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "Unable to create new Fill Out Form.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on createNewFillOutFormId(/forms/create_form): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  ///Gives Initial Object Data for Java Script Functions Against New FillOutForm ID
  Future<Response> getInitialFillOutFormData({required String fillOutFormId, bool needJavaScriptData = false, bool needMobileViewData = false, bool needAllData = false}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/fillout_form",
          data: jsonEncode({
            "system_id": UserSessionInfo.systemId.toString(),
            "user_id": UserSessionInfo.userId.toString(),
            "form_id": fillOutFormId.toString(),
            "mvc_form_fillout": needJavaScriptData.toString(),
            "mobile_form_fillout": needMobileViewData.toString(),
            "mvc_mobile_form_fillout": needAllData.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        e.response?.statusCode == 400
            ? SnackBarHelper.openSnackBar(isError: true, message: e.response?.data["userMessage"])
            : SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getInitialFillOutFormData(/forms/fillout_form): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}\nneedJavaScriptData: $needJavaScriptData , needMobileViewData: $needMobileViewData",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  ///Gives Initial Object Data for View User Form
  Future<Response> getInitialViewUserFormData({
    required String fillOutFormId,
    required String masterFormId,
    required String lastViewedFormId,
    required String doPostProcessing,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/viewUserForm",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": fillOutFormId.toString(),
            "formType": masterFormId.toString(),
            "lastFormIdViewed": lastViewedFormId.toString(),
            "doPostProcessing": doPostProcessing.toString(),
            "isFormFieldsGetFieldsOnFormList": "false",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        if (e.response?.statusCode == 400 && e.response?.data["userMessage"] != null && e.response?.data["userMessage"] != "") {
          SnackBarHelper.openSnackBar(isError: true, message: e.response?.data["userMessage"]);
        } else {
          SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        }
        if (kDebugMode) {
          print(
            "Error on getInitialViewUserFormData(/forms/viewUserForm): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> submitFormData({
    required String fillOutFormId,
    required String formName,
    required String performCloseOut,
    required String formType,
    required String isCloseOutForm,
    required List formFieldValues,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/submitForm",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": fillOutFormId.toString(),
            "formName": formName.toString(),
            "performCloseOut": performCloseOut.toString(),
            "formType": formType.toString(),
            "isCloseOutForm": isCloseOutForm.toString(),
            "formFieldValues": formFieldValues,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on submitFormData(/forms/submitForm): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> formDesignerPostProcessingReports({
    required String fillOutFormId,
    required String saveAndComplete,
    required String alreadyCompleted,
    String linkedFormFieldAction = "",
    String showStatusMessage = "false",
    String optionalAction = "",
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/formDesignerPostProcessingReports",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": fillOutFormId,
            "saveAndComplete": saveAndComplete,
            "alreadyCompleted": alreadyCompleted,
            "linkedFormFieldAction": linkedFormFieldAction,
            "showStatusMessage": showStatusMessage,
            "optionalAction": optionalAction,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on formDesignerPostProcessingReports(/forms/formDesignerPostProcessingReports): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> postPdfProcessingReport({
    required String formId,
    String? createdAt,
    String? headerText,
    String? emailRecipient,
    String? title,
    String? tableFontSize,
    String? contentMessage,
    String? contentData,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/postPdfProcessingReport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "FormIdForAttachments": formId,
            "createdAt": createdAt ?? DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTimeHelper.now),
            "headerText": headerText ?? "",
            "emailTo": emailRecipient ?? "",
            "title": title ?? "",
            "tableFontSize": tableFontSize ?? "12",
            "contentMessage": contentMessage ?? "",
            "contentData": contentData ?? "",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on postPdfProcessingReport(/forms/postPdfProcessingReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> postEmailProcessingReport({required String formId, String? fileName, String? subject, String? address, String? subAction}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/postEmailProcessingReport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": formId,
            "fileName": fileName ?? "",
            "subject": subject ?? "",
            "address": address ?? "",
            "subAction": subAction ?? "",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on postEmailProcessingReport(/forms/postEmailProcessingReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> postEmailProcessingPrinceGeorgeReport({required String formId, String? fileName, String? subject, String? address, String? subAction}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/postEmailProcessingPrinceGeorgeReport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": formId,
            "fileName": fileName ?? "",
            "subject": subject ?? "",
            "address": address ?? "",
            "subAction": subAction ?? "",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on postEmailProcessingPrinceGeorgeReport(/forms/postEmailProcessingPrinceGeorgeReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> thpIncidentReport({required String fillOutFormId, String? leg, String? trnCrew, String? supp}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        LoaderHelper.loaderWithGif();
        var response = await api.post(
          "/forms/thpIncidentReport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": fillOutFormId.toString(),
            "leg": leg.toString(),
            "trnCrew": trnCrew.toString(),
            "supp": supp.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        EasyLoading.dismiss();
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on formDesignerPostProcessingReports(/forms/thpIncidentReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> cpIncidentReport({required String fillOutFormId, required String leg}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/cpIncidentReport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": fillOutFormId.toString(),
            "leg": leg.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on formDesignerPostProcessingReports(/forms/cpIncidentReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> getFormDesignerImport({required String formId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/getFormDesignerImport",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "formId": formId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on formDesignerPostProcessingReports(/forms/getFormDesignerImport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> postFormDesignerImport({
    required int formId,
    required String user,
    required String includeUser,
    required String flightDate,
    required String aircraftNNumber,
    required String routeFrom,
    required String routeTo,
    required String viaPoints,
    required String remarks,
    required String durationOfFlight,
    required String pilotTimePIC,
    required String pilotTimeSIC,
    required String pilotTimeCC,
    required String pilotTimeSafetyPilot,
    required String pilotTimeDualReceived,
    required String pilotTimeSoloReceived,
    required String dayTakeOffs,
    required String nightTakeOffs,
    required String conditionsNight,
    required String nvgTime,
    required String nvgOperations,
    required String approachInstrument,
    required String approachNonInstrument,
    required String holds,
    required String conditionsActualInstrument,
    required String conditionsSimulatedInstrument,
    required String far91Time,
    required String far135Time,
    required String activity0,
    required String activity1,
    required String activity2,
    required String activity3,
    required String activity4,
    required String activity5,
    required String activity6,
    required String activity7,
    required String activity8,
    required String activity9,
    required String activity10,
    required String activity11,
    required String activity12,
    required String activity13,
    required String activity14,
    required String activity15,
    required String activity16,
    required String activity17,
    required String activity18,
    required String activity19,
    required String activity20,
    required String activity21,
    required String activity22,
    required String activity23,
    required String activity24,
    required String activity25,
    required String activity26,
    required String activity27,
    required String activity28,
    required String activity29,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/postFormDesignerImport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
            "formId": formId,
            "user": user,
            "includeUser": includeUser,
            "flightDate": flightDate,
            "aircraftNNumber": aircraftNNumber,
            "routeFrom": routeFrom,
            "routeTo": routeTo,
            "viaPoints": viaPoints,
            "remarks": remarks,
            "durationOfFlight": durationOfFlight,
            "pilotTimePIC": pilotTimePIC,
            "pilotTimeSIC": pilotTimeSIC,
            "pilotTimeCC": pilotTimeCC,
            "pilotTimeSafetyPilot": pilotTimeSafetyPilot,
            "pilotTimeDualReceived": pilotTimeDualReceived,
            "pilotTimeSoloReceived": pilotTimeSoloReceived,
            "dayTakeOffs": dayTakeOffs,
            "nightTakeOffs": nightTakeOffs,
            "conditionsNight": conditionsNight,
            "nvgTime": nvgTime,
            "nvgOperations": nvgOperations,
            "approachInstrument": approachInstrument,
            "approachNonInstrument": approachNonInstrument,
            "holds": holds,
            "conditionsActualInstrument": conditionsActualInstrument,
            "conditionsSimulatedInstrument": conditionsSimulatedInstrument,
            "far_91_Time": far91Time,
            "far_135_Time": far135Time,
            "activity0": activity0,
            "activity1": activity1,
            "activity2": activity2,
            "activity3": activity3,
            "activity4": activity4,
            "activity5": activity5,
            "activity6": activity6,
            "activity7": activity7,
            "activity8": activity8,
            "activity9": activity9,
            "activity10": activity10,
            "activity11": activity11,
            "activity12": activity12,
            "activity13": activity13,
            "activity14": activity14,
            "activity15": activity15,
            "activity16": activity16,
            "activity17": activity17,
            "activity18": activity18,
            "activity19": activity19,
            "activity20": activity20,
            "activity21": activity21,
            "activity22": activity22,
            "activity23": activity23,
            "activity24": activity24,
            "activity25": activity25,
            "activity26": activity26,
            "activity27": activity27,
            "activity28": activity28,
            "activity29": activity29,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on formDesignerPostProcessingReports(/forms/postFormDesignerImport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> deleteFormAttachment({required String formId, required String fileId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/forms/deleteFormAttachment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "formId": formId.toString(),
            "fileId": fileId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on viewFormFilterData(/forms/deleteFormAttachment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  ///Used For JavaScript Function API Calls
  Future<Response> generalAPICall({
    required String apiCallType,
    required String url,
    Map<String, dynamic>? postData,
    Map<String, String>? getData,
    bool showSnackBar = true,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        if (url != "/forms/formAutoSave" && url != "/forms/loadExtendedField" && url != "/forms/loadExtendedFieldSave" && showSnackBar) {
          LoaderHelper.loaderWithGif();
        }
        late Response response;
        if (apiCallType == "GET") {
          response = await api.get(
            url,
            data: jsonEncode(getData),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
          );
        } else if (apiCallType == "POST") {
          response = await api.post(
            url,
            data: jsonEncode(postData),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
          );
        }
        if (url != "/forms/formAutoSave" && url != "/forms/loadExtendedField" && url != "/forms/loadExtendedFieldSave" && showSnackBar) {
          EasyLoading.dismiss();
        }
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (showSnackBar) {
          SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        }
        if (kDebugMode) {
          print("Error on generalAPICall($url): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> proxyMetar({required String id}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        LoaderHelper.loaderWithGif();
        var response = await Dio(
          BaseOptions(baseUrl: UrlConstants.proxyMetarApiURL, connectTimeout: const Duration(milliseconds: 20000), receiveTimeout: const Duration(milliseconds: 20000)),
        ).get(
          "/data/metar?ids=$id&taf=false", //"/data/metar?ids=$aircraftId&taf=true&hours=0",
          options: Options(headers: {"Content-Type": "application/json", "Accept-Charset": "utf-8"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on proxyMetar(${UrlConstants.proxyMetarApiURL}/data/metar?ids=$id&taf=false): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  //Surjit's block END
}
