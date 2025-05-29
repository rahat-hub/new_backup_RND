import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../helper/snack_bar_helper.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class RiskAssessmentApiProvider {
  final Dio api = ApiProvider.api;

  metarsTafs({required String airportCode}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/getMetarsTafs",
            data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "airportCode": airportCode.toString()}),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on metarsTafs(/riskAssessment/getMetarsTafs): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  airportQuickPick() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/getAirportQuickPick",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));

        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on airportQuickPick(/riskAssessment/getAirportQuickPick): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  metersTAFSByInstanceId({required String riskId, required String instanceId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/getMetarsTafsByInstanceId",
          data: jsonEncode(
              {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "riskId": riskId.toString(), "instanceId": instanceId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on metarsTafsByInstanceId(/riskAssessment/getMetarsTafsByInstanceId): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  cachedMetarTafs({required String airportCode, required String isCacheData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/getCachedMetarsTafs",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "airportCode": airportCode.toString(),
            "isCacheData": isCacheData.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on cachedMetarTafs(/riskAssessment/getCachedMetarsTafs): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  saveCachedMetarTafs({required String metar, required String taf, required String airportCode, required String metarDateTime}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/saveCachedMetarsTafs",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "Metar": metar.toString(),
            "Taf": taf.toString(),
            "AirportCode": airportCode.toString(),
            "MetarDateTime": metarDateTime.toString()
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on saveCachedMetarTafs(/riskAssessment/saveCachedMetarTafs): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  moonFractionData({required String timeZone}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/getNewMoonFraction", //getMoonFraction",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "timeZone": timeZone.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on moonFractionData(/riskAssessment/getNewMoonFraction): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  getLiveProxyMoonForDate({required String hoursFromUtcTime}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/getLiveProxyMoonForDate",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "hoursFromUtcTime": hoursFromUtcTime.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on moonFractionData(/riskAssessment/getLiveProxyMoonForDate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  saveCacheMoonFraction({required int timeZone, required double moonFraction}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/raSaveCacheMoonFraction",
          data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "timeZone": timeZone, "moonFraction": moonFraction}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on saveCacheMoonFraction(/riskAssessment/raSaveCacheMoonFraction): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  searchAirport({required String searchTerm}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/searchAirport",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "searchTerm": searchTerm.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );

        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on searchAirport(/riskAssessment/searchAirport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///View Filter
  riskAssessmentFormFilterData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/viewFilter",
          data: jsonEncode({
            "SystemID": UserSessionInfo.systemId.toString(),
            "UserID": UserSessionInfo.userId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );

        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on riskAssessmentFormFilterData(/riskAssessment/viewFilter): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///View Index
  riskAssessmentViewFormAllData({required Map<String, String> data}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewIndex",
            data: jsonEncode(data),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on riskAssessmentViewFormAllData(/riskAssessment/viewIndex): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  createRiskAssessment({required bool isDemoQuestion, required String riskTitle}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/create",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "isDemoQuestion": isDemoQuestion.toString().capitalizeFirst,
              "title": riskTitle.toString()
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on createRiskAssessment(/riskAssessment/create): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  demographicsViewUpdate({required String riskId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewUpdate",
            data: jsonEncode({
              "riskId": riskId.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on demographicsViewUpdate(/riskAssessment/viewUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  questionAndTitles({required String riskId, String? instanceId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/riskAssessment/questions",
          data: jsonEncode(
              {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "riskId": riskId.toString(), "instanceId": instanceId ?? "0"}),
          options: Options(headers: {
            "Authorization": "bearer ${await UserSessionInfo.token}",
            "Content-Type": "application/json",
          }),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on questionAndTitles(/riskAssessment/questions): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  viewNewSection({required String riskId, required String sectionColumn, required String sectionId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewNewSection",
            data: jsonEncode({
              "riskId": riskId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "sectionColumn": sectionColumn.toString(),
              "sectionId": sectionId.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on viewNewSection(/riskAssessment/viewNewSection): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///View Section Title
  getDeleteSectionQuestions({required String riskId, required String sectionId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/deleteSectionQuestion",
            data: jsonEncode(
                {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "riskId": riskId.toString(), "sectionId": sectionId.toString()}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getDeleteSectionQuestions(/riskAssessment/deleteSectionQuestion): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///Update New Section
  createOrUpdateNewSection(
      {required String riskId,
      required String sectionId,
      required String formId,
      required String columnNumber,
      required String afterSectionId,
      required String sectionTitle,
      required String copyDefault,
      required String isUpdate}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/updateNewSection",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "riskAssessmentSection": {
                "SystemId": UserSessionInfo.systemId.toString(),
                "UserId": UserSessionInfo.userId.toString(),
                "SectionId": sectionId.toString(),
                "FormId": formId.toString(),
                "ColumnNumber": columnNumber.toString(),
                "SectionTitle": sectionTitle.toString(),
                "AfterSectionId": afterSectionId.toString(),
                "CopyDefault": copyDefault.toString(),
                "IsUpdate": isUpdate.toString(),
              },
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getCreateNewSection(/riskAssessment/updateNewSection): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///View New Section Question
  getViewNewSectionQuestionData(
      {required String riskId,
      required String sectionId,
      required String sectionColumn,
      required String sectionOrder,
      required String questionId,
      required String haveSubQuestions,
      required String sendNotification}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewNewSectionQuestion",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "sectionId": sectionId.toString(),
              "sectionColumn": sectionColumn.toString(),
              "sectionOrder": sectionOrder.toString(),
              "questionId": questionId.toString(),
              "questionHasSubQuestions": haveSubQuestions.toString(),
              "sendInstantNotification": sendNotification.toString()
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getViewNewSectionFilterData(/riskAssessment/viewNewSectionQuestion): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  questionTypeChangeEvent({required String riskId, required String questionTypeId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/questionTypeChangeEvent",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "questionTypeId": questionTypeId.toString()
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on questionTypeChangeEvent(/riskAssessment/questionTypeChangeEvent): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  saveUpdateQuestion(
      {required String formId,
      required String instanceId,
      bool? isNewAddQuestion,
      required String questionId,
      required String sectionId,
      required String questionOrder,
      String? questionTitle,
      required String questionValue,
      required String questionType,
      required String questionTypeMathType,
      required String questionTypeComparison,
      required String questionTypeComparisonValue0,
      required String questionTypeComparisonValue1,
      String? questionWxIntensity,
      String? questionWxDescriptor,
      String? questionWxPrecipitation,
      String? questionWxObscuration,
      String? questionWxOther,
      required String questionRAParentId,
      String? subQuestionTitles,
      String? subQuestionValues,
      bool? questionSendNotification,
      String? optionType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/saveUpdateQuestionV2",
            data: jsonEncode({
              "UserID": UserSessionInfo.userId,
              "SystemID": UserSessionInfo.systemId,
              "FormId": int.tryParse(formId.toString()) ?? 0,
              "InstanceId": int.tryParse(instanceId.toString()) ?? 0,
              "IsNewAddQuestion": isNewAddQuestion ?? true,
              "QuestionId": int.tryParse(questionId.toString()) ?? 0,
              "SectionId": int.tryParse(sectionId.toString()) ?? 0,
              "QuestionOrder": int.tryParse(questionOrder.toString()) ?? 0,
              "QuestionTitle": questionTitle?.toString() ?? "",
              "QuestionValue": int.tryParse(questionValue.toString()) ?? 0,
              "QuestionType": int.tryParse(questionType.toString()) ?? 0,
              "QuestionTypeMathType": int.tryParse(questionTypeMathType.toString()) ?? 0,
              "QuestionTypeComparison": int.tryParse(questionTypeComparison.toString()) ?? 0,
              "QuestionTypeComparisonValue0": double.tryParse(questionTypeComparisonValue0.toString()) ?? 0.00,
              "QuestionTypeComparisonValue1": double.tryParse(questionTypeComparisonValue1.toString()) ?? 0.00,
              "QuestionWxIntensity": questionWxIntensity?.toString() ?? "",
              "QuestionWxDescriptor": questionWxDescriptor?.toString() ?? "",
              "QuestionWxPrecipitation": questionWxPrecipitation?.toString() ?? "",
              "QuestionWxObscuration": questionWxObscuration?.toString() ?? "",
              "QuestionWxOther": questionWxOther?.toString() ?? "",
              "QuestionRAParentId": int.tryParse(questionRAParentId.toString()) ?? 0,
              "SubQuestionTitles": subQuestionTitles?.toString() ?? "",
              "SubQuestionValues": subQuestionValues?.toString() ?? "",
              "QuestionSendNotification": questionSendNotification ?? false,
              "OptionType": optionType?.toString() ?? "insert",
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on saveUpdateQuestion(/riskAssessment/saveUpdateQuestionV2): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  viewFormQuestion({required String riskId, required String formQuestionId, required String formSubQuestionId, required String hasSubQuestion}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewFormQuestion",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "formQuestionId": formQuestionId.toString(),
              "formSubQuestionId": formSubQuestionId.toString(),
              "hasSubQuestion": hasSubQuestion.toString()
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on viewFormQuestion(/riskAssessment/viewFormQuestion): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///Edit Risk Assessment Form
  saveRiskAssessmentForm(
      {required String riskId,
      String? lastRevised,
      String? formTitle,
      String? demographicField1,
      String? leftSideTitle,
      String? rightSideTitle,
      required String lowRiskValue,
      String? lowRiskMitigation,
      required String mediumRiskValue,
      String? mediumRiskMitigation,
      String? highRiskMitigation,
      required String highRiskValue,
      String? extraHighRiskMitigation,
      bool? showFieldCrew,
      bool? showFieldDispatchNumber,
      bool? showFieldAircraft,
      bool? showFieldBase,
      bool? showFieldShift}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/editRiskAssessmentForm",
            data: jsonEncode({
              "SystemId": UserSessionInfo.systemId,
              "UserId": UserSessionInfo.userId,
              "RiskId": int.tryParse(riskId.toString()) ?? 0,
              "LastRevised": lastRevised ?? "0001-01-01T00:00:00",
              "FormTitle": formTitle ?? "New Risk Assessment",
              "DemographicField1": demographicField1 ?? "Dispatch Number",
              "LeftSideTitle": leftSideTitle ?? "Pilot And Aircraft Risk Factors",
              "RightSideTitle": rightSideTitle ?? "Environmental Risk Factors",
              "LowRiskValue": int.tryParse(lowRiskValue.toString()) ?? 10,
              "LowRiskMitigation": lowRiskMitigation ?? "Go Fly!",
              "MediumRiskValue": int.tryParse(mediumRiskValue.toString()) ?? 40,
              "MediumRiskMitigation": mediumRiskMitigation ?? "Fly - Mitigate Risks as Necessary",
              "HighRiskMitigation": highRiskMitigation ?? "DFO Review Required",
              "HighRiskValue": int.tryParse(highRiskValue.toString()) ?? 60,
              "ExtraHighRiskMitigation": extraHighRiskMitigation ?? "Attempt To Mitigate Or Decline",
              "ShowFieldCrew": showFieldCrew ?? true,
              "ShowFieldDispatchNumber": showFieldDispatchNumber ?? true,
              "ShowFieldAircraft": showFieldAircraft ?? true,
              "ShowFieldBase": showFieldBase ?? true,
              "ShowFieldShift": showFieldShift ?? true,
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on saveRiskAssessmentForm(/riskAssessment/editRiskAssessmentForm): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  currencyForUser({required String userId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/currencyForUser",
            data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": userId.toString()}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }, receiveTimeout: const Duration(milliseconds: 50000)));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on currencyForUser(/riskAssessment/currencyForUser): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  completeRiskAssessment(
      {required int formID,
      int? crew1,
      int? crew2,
      int? crew3,
      String? demographicField,
      int? aircraftID,
      int? baseID,
      String? shift,
      String? narrative,
      String? qIdList,
      String? qSmartListIds,
      String? qSmartListPoints,
      String? questionsRaListIds,
      String? questionsRaListPoints,
      String? questionsRaListInstanceIds,
      String? questionsRaListUserIds,
      String? questionMitigation,
      int? riskMatrixTotal,
      String? raMitigation,
      int? isSigned,
      String? metarIdList,
      String? crewDutyTimeIn0,
      String? crewDutyTimeIn1,
      String? crewDutyTimeIn2,
      String? crewDutyTimeIn3,
      String? clientIP}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/completeRiskAssessmentForm",
            data: jsonEncode({
              "FormId": formID,
              "Crew1": crew1 ?? 0,
              "Crew2": crew2 ?? 0,
              "Crew3": crew3 ?? 0,
              "DemographicField1Value": demographicField ?? "",
              "AircraftId": aircraftID ?? 0,
              "Base": baseID ?? 0,
              "Shift": shift ?? "",
              "Narrative": narrative ?? "",
              "QuestionIdList": qIdList ?? "",
              "QuestionSmartListIds": qSmartListIds ?? "",
              "QuestionSmartListPoints": qSmartListPoints ?? "",
              "QuestionRaListIds": questionsRaListIds ?? "",
              "QuestionRaListPoints": questionsRaListPoints ?? "",
              "QuestionRaListInstanceIds": questionsRaListInstanceIds ?? "",
              "QuestionRaListUserIds": questionsRaListUserIds ?? "",
              "QuestionMitigation": questionMitigation ?? "",
              "FinalTotal": riskMatrixTotal ?? 0,
              "UserMitigation": raMitigation ?? "",
              "IsSigned": isSigned ?? 0,
              "MetarIdList": metarIdList ?? "",
              "CrewDutyTimeIn0": crewDutyTimeIn0 ?? "",
              "CrewDutyTimeIn1": crewDutyTimeIn1 ?? "",
              "CrewDutyTimeIn2": crewDutyTimeIn2 ?? "",
              "CrewDutyTimeIn3": crewDutyTimeIn3 ?? "",
              "ClientIP": clientIP ?? "",
              "SystemId": UserSessionInfo.systemId,
              "UserId": UserSessionInfo.userId
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on completeRiskAssessment(/riskAssessment/completeRiskAssessmentForm): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  coSignDropDownData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/coSign",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on coSignDropDownData(/riskAssessment/coSign): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  coSignElectronically(
      {required String instanceId,
      required String ipAddress,
      required String approveOrDeny,
      required String denialCode,
      required String denialReasonText,
      required String approveMitigationReasonText,
      required String passCode}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/coSignElectronically",
            data: jsonEncode({
              "SystemID": UserSessionInfo.systemId.toString(),
              "UserID": UserSessionInfo.userId.toString(),
              "InstanceID": instanceId.toString(),
              "IPAddress": ipAddress.toString(),
              "ApproveOrDeny": approveOrDeny.toString(),
              "DenialCode": denialCode.toString(),
              "DenialReasonText": denialReasonText.toString(),
              "ApproveMitigationReasonText": approveMitigationReasonText.toString(),
              "PassCode": passCode.toString()
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on coSignElectronically(/riskAssessment/coSignElectronically): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  deleteRaQuestion({required String riskId, required String questionId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/deleteRAQuestion",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "questionId": questionId.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on deleteRaQuestion(/riskAssessment/deleteRAQuestion): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  deleteRiskAssessmentForm({required String riskId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/deleteRiskAssessmentForm",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on deleteRiskAssessmentForm(/riskAssessment/deleteRiskAssessmentForm): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  fillOutDetails({required String instanceId, required String riskId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/fillOutDetails",
            data: jsonEncode(
                {"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "instanceId": instanceId.toString(), "riskId": riskId.toString()}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on fillOutDetails(/riskAssessment/fillOutDetails): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///View Fill Out Form
  getRiskAssessmentFillOutFormAllData({required String riskFormId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewFillout",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "riskFormId": riskFormId.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getRiskAssessmentFillOutFormAllData(/riskAssessment/viewFillout): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  getRiskAssessmentCrewDutyTimes({required int crewId0, required int crewId1, required int crewId2, required int crewId3}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/getRiskAssessmentCrewDutyTimes",
            data: jsonEncode(
                {"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "crewId0": crewId0, "crewId1": crewId1, "crewId2": crewId2, "crewId3": crewId3}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getRiskAssessmentCrewDutyTimes(/riskAssessment/getRiskAssessmentCrewDutyTimes): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  validatePassword({String? u, required String password, String? formId, String? sMode}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/forms/validatePassword", //validatePassword", -> "formId //performSignatureValidation", -> "formID"
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": u ?? UserSessionInfo.userId.toString(),
              "formId": formId ?? "",
              "formFieldId": "",
              "password": password,
              "sMode": sMode ?? "ValidateOnly"
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on validatePassword(/forms/validatePassword): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        //SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  raRecentUserValues({required int raParentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/raRecentUserValues",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId,
              "userId": UserSessionInfo.userId,
              "raParentId": raParentId,
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on raRecentUserValues(/riskAssessment/raRecentUserValues): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  raPriorAnswers({required int formId, int? excludeSmart}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/raPriorAnswers",
            data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "formId": formId, "excludeSmart": excludeSmart ?? 0}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on raPriorAnswers(/riskAssessment/raPriorAnswers): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  raAnswers({required int formId, int? excludeSmart}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/raAnswers",
            data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "formId": formId, "excludeSmart": excludeSmart ?? 0}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on raAnswers(/riskAssessment/raAnswers): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  raHeaders({required int formId, int? excludeSmart}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/raHeaders",
            data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "formId": formId, "excludeSmart": excludeSmart ?? 0}),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on raHeaders(/riskAssessment/raHeaders): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  //Not Used
  getEditViewSectionTitle(
      {required String riskId,
      required String sectionId,
      required String sectionTitle,
      required String sectionOrder,
      required String sectionColumn,
      required String copyDefault}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/viewSectionTitle",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "sectionId": sectionId.toString(),
              "sectionTitle": sectionTitle.toString(),
              "sectionOrder": sectionOrder.toString(),
              "sectionColumn": sectionColumn.toString(),
              "copyDefault": copyDefault.toString(),
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getEditViewSectionTitle(/riskAssessment/viewSectionTitle): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  getUpdateSectionTitle(
      {required String riskId,
      required String sectionId,
      required String formId,
      required String columnNumber,
      required String afterSectionId,
      required String sectionTitle,
      required String systemId1,
      required String userId1,
      required String copyDefault,
      required String isUpdate}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/updateSectionTitle",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "riskAssessmentSection": {
                "SystemId": systemId1.toString(),
                "UserId": userId1.toString(),
                "SectionId": sectionId.toString(),
                "FormId": riskId.toString(),
                "ColumnNumber": columnNumber.toString(),
                "SectionTitle": sectionTitle.toString(),
                "AfterSectionId": afterSectionId.toString(),
                "CopyDefault": copyDefault,
                "IsUpdate": isUpdate
              }
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on getUpdateSectionTitle(/riskAssessment/updateSectionTitle): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  sectionChangeEvent({required String riskId, required String sectionId, required String questionId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/riskAssessment/sectionChangeEvent",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "riskId": riskId.toString(),
              "sectionId": sectionId.toString(),
              "questionId": questionId.toString()
            }),
            options: Options(headers: {
              "Authorization": "bearer ${await UserSessionInfo.token}",
              "Content-Type": "application/json",
            }));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on sectionChangeEvent(/riskAssessment/sectionChangeEvent): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }
}
