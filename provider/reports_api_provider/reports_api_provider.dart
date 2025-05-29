import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

import '../../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../../helper/snack_bar_helper.dart';
import '../../shared/utils/logged_in_data.dart';
import '../api_provider.dart';

class ReportsApiProvider {
  final Dio api = ApiProvider.api;

  ///*************** START SURJIT's BLOCKS ***************

  Future<Response?> getReportsIndexData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/index",
            data: jsonEncode({"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString()}),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        if (e.response?.data["errorMessage"]?.toString().contains("out of range") ?? false) {
          SnackBarHelper.openSnackBar(isError: true, message: "There Are No Reports That You Currently Have Access To At This Time.");
        } else {
          SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        }
        if (kDebugMode) {
          print(
              "Error on Reports getReportsIndexData(/reports/index): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  Future<Response?> getReportTypeData({required String reportCategoryId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/reportCategoryOnChange",
            data: jsonEncode({"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "reportCategoryId": reportCategoryId}),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Reports getReportTypeData(/reports/reportCategoryOnChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response?> getUpdateFieldsAPIData({String? reportTypeName, required String reportTypeId, String? lastReportType, Map<String, dynamic>? updateFieldsParameters}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/reportTypeOnChange",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "reportTypeName": reportTypeName,
              "reportTypeId": reportTypeId,
              "lastReportType": lastReportType,
              "updateFields": updateFieldsParameters
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Report Type:$reportTypeId getUpdateFieldsAPIData(/reports/reportTypeOnChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response?> getRAQuestionsSectionsData({required String selectedCustomDropDown1Id, required String type}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/getCustomDropDown1OnChange",
            data: jsonEncode(
                {"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "customDropDown1Id": selectedCustomDropDown1Id, "type": type}),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Reports Index getRAQuestionsSectionsData(/reports/getCustomDropDown1OnChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response?> getComponentsForecastItemsData({required String selectedCategoryId, required String selectedAircraftId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/selected_SelectOne_AC_OnChange",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "customDropDown1Id": selectedCategoryId,
              "selectedSelectOneAC": selectedAircraftId
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Reports Index getComponentsForecastItemsData(/reports/selected_SelectOne_AC_OnChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response?> getExpenseTypeData({required String selectedCustomDropDown1Id, required String type}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/populateDropdownForExpenseTypeSearch",
            data: jsonEncode(
                {"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "customDropDown1Id": selectedCustomDropDown1Id, "type": type}),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Reports Index getExpenseTypeData(/reports/populateDropdownForExpenseTypeSearch): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response?> getAircraftStatisticsData({required String forecastDate, required String selectedAircraftId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post("/reports/AircraftTR_SelectOne_OnChange",
            data: jsonEncode({
              "userId": UserSessionInfo.userId.toString(),
              "systemId": UserSessionInfo.systemId.toString(),
              "forecastDate": forecastDate,
              "selectedSelectOneAC": selectedAircraftId
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Reports Index getAircraftStatisticsData(/reports/AircraftTR_SelectOne_OnChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///*************** END SURJIT's BLOCKS ***************
}
