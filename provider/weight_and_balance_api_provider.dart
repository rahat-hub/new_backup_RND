import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/api_provider.dart';
import 'package:aviation_rnd/shared/utils/logged_in_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

class WeightAndBalanceApiProvider {
  final Dio api = ApiProvider.api;

  Future<Response<dynamic>?>? getMissionProfileOptionDropDownData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/getSystemMissionProfileOption",
          data: jsonEncode(<String, String>{"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString()}),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Weight & Balance Mission Profile getMissionProfileOptionDropDownData(/weightBalance/getSystemMissionProfileOption): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response<dynamic>?>? getAllWeightBalanceOptionsTabsData({String? parentId, String? optionId, bool? loadOnlyDefaultOptions}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/getAllWeightBalanceOptionsMapping",
          data: jsonEncode(<String, String>{
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "parentId": parentId ?? "0",
            "optionsId": optionId ?? "0",
            "isDefaultOptions": loadOnlyDefaultOptions != null
                ? loadOnlyDefaultOptions
                      ? "1"
                      : "0"
                : "-1",
          }),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getAllWeightBalanceOptionsTabsData(/weightBalance/getAllWeightBalanceOptionsMapping): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response<dynamic>?>? enableWeightBalanceOptions({List<Map<String, dynamic>> weightBalanceOptions = const <Map<String, dynamic>>[]}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/saveDefaultOptions",
          data: jsonEncode(<String, dynamic>{"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "optionsList": weightBalanceOptions}),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on enableAllWeightBalanceDefaultOptions(/weightBalance/saveDefaultOptions): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response<dynamic>?>? createNewWeightBalanceParentWithChildItem({required Map<String, dynamic> missionProfileAllInfo}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/createWeightBalanceParentChild",
          data: jsonEncode(missionProfileAllInfo),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on createNewWeightBalanceParentWithChildItem(/weightBalance/createWeightBalanceParentChild): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response<dynamic>?>? getAllWeightBalanceInfo({required String parentId, String? optionId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/getAllWeightBalance",
          data: jsonEncode(<String, String>{
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "parentId": parentId,
            "optionId": optionId ?? "0",
          }),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getAllWeightBalanceInfo(/weightBalance/getAllWeightBalance): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response<dynamic>?>? updateMissionProfileInfo({required Map<String, dynamic> missionProfileAllInfo}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/updateMissionProfile",
          data: jsonEncode(missionProfileAllInfo),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Weight & Balance Update Mission Profile data view updateMissionProfileInfo(/weightBalance/updateMissionProfile): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response<dynamic>?>? postCreateMissionProfileNameApiData({required String missionProfileName}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response<dynamic> response = await api.post(
          "/weightBalance/createMissionName",
          data: jsonEncode(<String, Object>{"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "missionName": missionProfileName}),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Weight & Balance Create data view (/weightBalance/createMissionName): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${(e.response?.data as Map<String, dynamic>)["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }
}
