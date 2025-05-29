import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../../helper/snack_bar_helper.dart';
import '../../shared/utils/logged_in_data.dart';
import '../api_provider.dart';

class CustomReportsApiProvider {
  final Dio api = ApiProvider.api;

  /// ********************** START TAYEB BLOCK *************

  getCustomReports() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCustomReports",
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
              "Error on Reports(/reports/getCustomReports): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  getCustomReportsEdit({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCustomReportsEdit",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCustomReportsEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  reportCategory() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/loadOptions/GenerateOptions",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "optionsType": "AllReportsCategories",
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCustomReportsEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  customReportUpdateDemo(
      {required String customReportId,
      required String formId,
      required String reportName,
      required String defaultPromptDateRange,
      required String groupedOutput,
      required String showFormIdInResults,
      required String pdfFontSize,
      required String reportCategory}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportUpdateDemo",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "customReportId": customReportId.toString(),
              "formId": formId.toString(),
              "reportName": reportName.toString(),
              "defaultPromptDateRange": defaultPromptDateRange.toString(),
              "groupedOutput": groupedOutput.toString(),
              "showFormIdInResults": showFormIdInResults.toString(),
              "pdfFontSize": pdfFontSize.toString(),
              "reportCategory": reportCategory.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportUpdateDemo): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  deleteReport({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/deleteReport",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("Error on Reports(/reports/deleteReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  customReportsLoadFilters({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportsLoadFilters",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportsLoadFilters): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  customReportsLoadOutputFields({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportsLoadOutputFields",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportsLoadOutputFields): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  customReportsLoadOutputMathAliases({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportsLoadOutputMathAliases",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportsLoadOutputMathAliases): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  customReportsLoadOutputMathFields({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportsLoadOutputMathFields",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportsLoadOutputMathFields): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postCustomReportsFilterAdd({required int customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postCustomReportsFilterAdd",
            data: jsonEncode({
              "UserId": UserSessionInfo.userId.toString(),
              "SystemId": UserSessionInfo.systemId.toString(),
              "ReportId": customReportsId,
              "ComparisonType": 1,
              "PromptUserForValue": false,
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postCustomReportsFilterAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  customReportsOutputFieldsAdd({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportsOutputFieldsAdd",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportsOutputFieldsAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  createOutputMathField({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/createOutputMathField",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/createOutputMathField): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  getCustomReportEditActionsData({required String actionId, required String reportId, required String formId, required String actionName}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCustomReportEditActionsData",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "reportId": reportId.toString(),
              "formId": formId.toString(),
              "actionName": actionName.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCustomReportEditActionsData): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  getCRLoadComparisons({required String fieldId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCRLoadComparisons",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "fieldId": fieldId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCRLoadComparisons): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  getCRFilterFieldChoicesInput({required String actionId, required String formId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCRFilterFieldChoicesInput",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "formId": formId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCRFilterFieldChoicesInput): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  getCRFilterReferencesFormField({required String actionId, required String formId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCRFilterReferencesformfield",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "formId": formId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCRFilterReferencesformfield): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  getCRLoadFiltersValues({required String actionId, required String fieldId, required String comparisonType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCRLoadFiltersValues",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "fieldId": fieldId.toString(),
              "comparisionType": comparisonType.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCRLoadFiltersValues): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  crAddChoiceFilters({required String actionId, required String choiceName}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/crAddChoiceFilters",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "choiceName": choiceName.toString()
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/crAddChoiceFilters): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postCreateCustomReports() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postCreateCustomReports",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postCreateCustomReports): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postUpdateCustomReportsFilter(
      {required int filterId,
      required int prompt,
      required int comparisonTypeId,
      required String valueSelected,
      required int filterOneOrMany,
      required int filterFieldId,
      required String checkBoxValue}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postUpdateCustomReportsFilter",
            data: jsonEncode({
              "userId": UserSessionInfo.userId,
              "systemId": UserSessionInfo.systemId,
              "filterId": filterId,
              "promptForValue": prompt,
              "comparisonType": comparisonTypeId,
              "valueText": valueSelected,
              "filterOneOrMany": filterOneOrMany,
              "filterFieldId": filterFieldId,
              "valueSelect": checkBoxValue
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postUpdateCustomReportsFilter): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postDeleteCustomReportsFilter({required String filterId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postDeleteCustomReportsFilter",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "filterId": filterId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postDeleteCustomReportsFilter): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postUpdateCustomReportsOutput(
      {required int reportId,
      required int outputId,
      required String columnName,
      required int outputOrder,
      required int widthPercentage,
      required int alignment,
      required int showTotal,
      required int oneFieldOrMany,
      required int formField}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postUpdateCustomReportsOutput",
            data: jsonEncode({
              "userId": UserSessionInfo.userId,
              "systemId": UserSessionInfo.systemId,
              "reportId": reportId,
              "outputId": outputId,
              "columnName": columnName,
              "outputOrder": outputOrder,
              "widthPercentage": widthPercentage,
              "alignment": alignment,
              "showTotal": showTotal,
              "oneFieldOrMany": oneFieldOrMany,
              "formFieldId": formField,
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postUpdateCustomReportsOutput): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postDeleteCustomReportsOutput({required String filterId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postDeleteCustomReportsOutput",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "filterId": filterId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postDeleteCustomReportsOutput): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postUpdateCustomReportsOutputMath(
      {required String reportId,
      required String outputFieldMathId,
      required String columnName,
      required String outputOrder,
      required String widthPercentage,
      required String alignment,
      required String showTotal,
      required String formula}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postUpdateCustomReportsOutputMath",
            data: jsonEncode({
              "userId": UserSessionInfo.userId,
              "systemId": UserSessionInfo.systemId,
              "reportId": reportId.toString(),
              "outputFieldMathId": outputFieldMathId.toString(),
              "columnName": columnName.toString(),
              "outputOrder": outputOrder.toString(),
              "widthPercentage": widthPercentage.toString(),
              "alignment": alignment.toString(),
              "showTotal": showTotal.toString(),
              "formula": formula.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postUpdateCustomReportsOutputMath): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postDeleteCustomReportsOutputMath({required String filterId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postDeleteCustomReportsOutputMath",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "filterId": filterId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postDeleteCustomReportsOutputMath): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  postCustomReportValidate({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/postCustomReportValidate",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/postCustomReportValidate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        // its only for validate Report
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  getColumnAliasesAvailableForMath({required String customReportsId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getColumnAliasesAvailableForMath",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportsId": customReportsId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getColumnAliasesAvailableForMath): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        // its only for validate Report
        SnackBarHelper.openSnackBar(isError: true, message: "Unable To Validated Report Due To The Following Errors");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  getCRFieldChoicesOutput({required String actionId, required String formId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCRFieldChoicesOutput",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "formId": formId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCRFieldChoicesOutput): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        // its only for validate Report
        SnackBarHelper.openSnackBar(isError: true, message: "Unable To Validated Report Due To The Following Errors");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  getCRFieldChoicesOutputForManyField({required String actionId, required String formId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/getCRFieldChoicesOutputforManyfield",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "actionId": actionId.toString(),
              "formId": formId.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/getCRFieldChoicesOutputforManyfield): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        // its only for validate Report
        SnackBarHelper.openSnackBar(isError: true, message: "Unable To Validated Report Due To The Following Errors");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  customReportsShow({required String customReportId, required String postData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/reports/customReportsShow",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customReportId": customReportId.toString(),
              "postData": postData.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Reports(/reports/customReportsShow): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        // its only for validate Report
        SnackBarHelper.openSnackBar(isError: true, message: "Unable To Validated Report Due To The Following Errors");
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  /// ********************** END TAYEB BLOCK ***************
}
