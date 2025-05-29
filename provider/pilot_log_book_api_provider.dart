import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../helper/snack_bar_helper.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class PilotLogBookApiProvider {
  final Dio api = ApiProvider.api;

  getSelectedUserFilterData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/jsonfeed/repopulatelist",
          data: jsonEncode({"Action": "userList", "ItemName": "0", "GroupId": "0", "ItemId": "0"}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getSelectedUserFilterData(/jsonfeed/repopulatelist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  getFilterByTypeFilterData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/jsonfeed/filtertype",
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getFilterByTypeFilterData(/jsonfeed/filtertype): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  getFilterSpecificTypeFilterData({required String filterTyp, required String userId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/filterspecifictypes",
          data: jsonEncode({"FilterType": filterTyp, "UserId": userId}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getFilterSpecificTypeFilterData(/jsonfeed/filterspecifictypes): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  getPilotLogBookIndexTableData({required Map<String, String> data}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/htmltabledata",
          data: jsonEncode(data),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getPilotLogBookIndexTableData(/flightlog/htmltabledata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  createNewFlightLogView() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbookcreateview",
          data: jsonEncode({"system_id": UserSessionInfo.systemId.toString(), "user_id": UserSessionInfo.userId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on createNewFlightLogView(/flightlog/pilotlogbookcreateview): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  editFlightLogView({required String relId, required String userId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbookedit",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": userId.toString(), "logBookId": relId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on editFlightLogView(/flightlog/pilotlogbookedit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  airportSearch({required Map<String, String> data}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/airportsearch",
          data: jsonEncode(data),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on airportSearch(/flightlog/airportsearch): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  countryNameForAirportSearch() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/countryname",
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on countryNameForAirportSearch(/flightlog/countryname): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  getAircraftTypeValue({required Map<String, String> aircraftNumber}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/aircrafttype",
          data: jsonEncode(aircraftNumber),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on getAircraftTypeValue(/flightlog/aircrafttype): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  saveCreateNewFlightLogData({required Map<String, dynamic> data}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbooksavedata",
          data: jsonEncode(data),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on saveCreateNewFlightLogData(/flightlog/pilotlogbooksavedata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  saveEditFlightLogData({required Map<String, dynamic> data}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbookeditdata",
          data: jsonEncode(data),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on saveEditFlightLogData(/flightlog/pilotlogbookeditdata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  flightLogViewDetails({required String userId, required String relId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbookviewdata",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": userId.toString(), "logBookId": relId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on flightLogViewDetails(/flightlog/pilotlogbookviewdata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  deleteFlightLogData({required String id, required String userID}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbookdeletedata",
          data: jsonEncode({"logBookId": id.toString(), "SystemId": UserSessionInfo.systemId.toString(), "UserId": userID.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on deleteFlightLogData(/flightlog/pilotlogbookdeletedata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  cfiCoSign({required String cfiSignId, required String password}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/electronicSignature/cfiCoSign",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "empId": UserSessionInfo.userLoginId.toString(),
            "CfiSignId": cfiSignId,
            "password": password,
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
            "Error on cfiCoSign(/electronicSignature/cfiCoSign): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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
