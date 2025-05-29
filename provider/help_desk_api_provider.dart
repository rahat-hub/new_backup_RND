import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

import '../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../helper/snack_bar_helper.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class HelpDeskApiProvider {
  final Dio api = ApiProvider.api;

  Future<Response?> indexPageViewData({String? search, bool showSnackBar = true}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/helpDesk/index",
            data: jsonEncode({
              "SystemId": UserSessionInfo.systemId.toString(),
              "UserId": UserSessionInfo.userId.toString(),
              "search": search ?? "",
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (showSnackBar) {
          Get.back(closeOverlays: true);
          SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        }
        if (kDebugMode) {
          print("Error on Help Desk(/helpDesk/index): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      if (showSnackBar) {
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      }
      return null;
    }
  }

  indexPageCreateModalData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/helpDesk/getCreate",
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
              "Error on Help Desk(/partsRequest/getCreate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  indexPagePostCreateData({required String groupId, required String priorityId, required String label, required String content}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/helpDesk/postCreate",
            data: jsonEncode({
              "SystemID": UserSessionInfo.systemId.toString(),
              "ServiceID": UserSessionInfo.systemId.toString(),
              "UserID": UserSessionInfo.userId.toString(),
              "Label": label.toString(),
              "GroupID": groupId.toString(),
              "Priority": priorityId.toString(),
              "Content": content.toString(),
              "BaseID": 0,
              "Assigned": 0,
              "Browser_Information": "[Chrome] Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edge/131.0.0.0"
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Help Desk(/partsRequest/postCreate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  helpDeskDetails({required String ticketNum}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/helpDesk/getHelpDeskDetails",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userid": UserSessionInfo.userId.toString(),
              "ticketNum": ticketNum.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Help Desk(/partsRequest/helpDeskDetails): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  updateHelpDesk(
      {required int ticket,
      required String group,
      required String status,
      required String assigned,
      required String priority,
      required String creatingUserId,
      required String currentSystemDateTime}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/helpDesk/updateHelpDesk",
            data: jsonEncode({
              "SystemId": UserSessionInfo.systemId.toString(),
              "UserId": UserSessionInfo.userId.toString(),
              "Ticket": ticket.toString(),
              "Base": 0,
              "Group": group.toString(),
              "Status": status.toString(),
              "Assigned": assigned.toString(),
              "Priority": priority.toString(),
              "User": UserSessionInfo.userId.toString(),
              "CreatingUserID": creatingUserId.toString(),
              "CurrentSystemDateTime": currentSystemDateTime.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on Help Desk(/partsRequest/updateHelpDesk): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  addNote({required int ticketNumber, required String ticketNote, required int checkMail}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/helpDesk/addNote",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "ticketNumber": ticketNumber.toString(),
              "ticketNote": ticketNote.toString(),
              "checkMail": checkMail.toString(),
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("response : ${e.response}");
          print("Error on Help Desk(/helpDesk/addNote): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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
