import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class MelApiProvider {
  final Dio api = ApiProvider.api;

  ///MEL : INDEX
  melIndexData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/index",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print("Error on Mel Index Data(/mel/index): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  ///MEL : DETAILS
  melDetailsData({required int melId, required String melType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/details",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "melId": melId, "melType": melType}),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print("Error on Mel Details Data(/mel/details): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///MEL : EDIT
  melEditData({required int melId, required String melType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/getUpdate",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "melId": melId, "melType": melType}),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Mel Edit/getUpdate Data(/mel/getUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  melUpdatePostData({required Map<String, dynamic> melUpdateData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/postUpdate",
          data: jsonEncode(melUpdateData),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print("Error on Mel Upload Data(/mel/postUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  ///MEL : MEL_Aircraft_Types
  melGetAircraftTypesData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/getMelAircraftTypes",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Mel Aircraft Types Data(/mel/getMelAircraftTypes): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  melGetAircraftTypesDetailsData({required String acTypeId, required String acType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/getMelAircraftTypesDetails",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "acTypeId": acTypeId, "acType": acType}),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Mel Aircraft Types Details Data(/mel/getMelAircraftTypesDetails): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  melAircraftTypesDetailsFileDelete({required String melId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/mel/deleteMel",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "melId": melId,
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Mel Aircraft Types Details Data File Delete(/mel/deleteMel): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  melElectronicSignatureValidation({String? userId, String? systemId, required String userPassword}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/user/validatePassword",
          data: jsonEncode({
            "userId": userId ?? UserSessionInfo.userId.toString(),
            "systemId": systemId ?? UserSessionInfo.systemId.toString(),
            "password": userPassword.toString(),
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on System Electronic Signature(/user/validatePassword): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }
}
