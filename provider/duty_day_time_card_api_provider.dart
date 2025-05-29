import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class DutyDayTimeCardApiProvider {
  final Dio api = ApiProvider.api;

  getDutyDayTimeCardInitialData({required String? relId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/flightlog/pilotlogbookuserdata",
          data: jsonEncode({
            "logbookid": relId,
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
              "Error on getDutyDayTimeCardInitialData(/flightlog/pilotlogbookuserdata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e
                  .response?.data["errorMessage"]}");
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

  userTimeCardDetailsDataApiCall({required Map<String, dynamic> timeCardApiCallData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/viewtimecarddata",
          data: jsonEncode(timeCardApiCallData),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on userTimeCardDetailsDataApiCall(/dutytime/viewtimecarddata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  userTimeCardDetailsCosign({required Map? userTimeCardDetailsData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/dutytimecosign",
          data: jsonEncode(userTimeCardDetailsData),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on userTimeCardDetailsCosign(/dutytime/dutytimecosign): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  userTimeCardDetailsUpdateDutyTimePostApiCall({required Map? userTimeCardDetailsUpdatePostData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/updatedutydaytime",
          data: jsonEncode(userTimeCardDetailsUpdatePostData),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on userTimeCardDetailsUpdateDutyTimePostApiCall(/dutytime/updatedutydaytime): Error Type: ${e.response?.statusMessage} (${e.response
                  ?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  viewDutyDayTimeCardData(
      {required String userId, required String userRole, required String startDate, required String endDate, String? navigationStatus, required List<int> listItemData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/viewtimecarddata",
          data: jsonEncode({
            "userid": userId,
            "userrole": userRole,
            "startdate": startDate,
            "enddate": endDate,
            "navigationstatus": navigationStatus ?? "",
            "listitemto": listItemData,
            "IslstItemToStoreLocal": true,
            "isflightlogoption": false,
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on viewDutyDayTimeCardData(/dutytime/viewtimecarddata): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        Get.back();
        if (e.response?.statusCode == 404) {
          SnackBarHelper.openSnackBar(isError: false, message: "No Data Found!");
        } else {
          SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
        }
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  returnToTimeCard() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/returntimecard",
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
        if (kDebugMode) {
          print(
              "Error on returnToTimeCard(/dutytime/returntimecard): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  returnToTimeCardUserRole({required String userRoleId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/userroles",
          data: jsonEncode({
            "user_roleid": userRoleId.toString(),
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on returnToTimeCardUserRole(/dutytime/userroles): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
        Get.back();
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      Get.back();
    }
  }

  //Duty Time In Out - Dashboard
  dutyTimeInOutFirstDataApiCall() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/dutyTime",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userid": UserSessionInfo.userId.toString(),
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on dutyTimeInOutFirstDataApiCall(/dutytime/dutyTime): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  dutyTimeGetBesTimeApiCall({required String baseId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/getBaseTime",
          data: jsonEncode({"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "baseId": baseId}),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on dutyTimeGetBesTimeApiCall(/dutytime/getBaseTime): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  dutyTimeChangeBaseApiCall({required String baseId, required String farPartId, required String dualPilotId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/getBaseTime",
          data: jsonEncode(
              {"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "baseId": baseId, "farPartId": farPartId, "dualPilotId": dualPilotId}),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on dutyTimeChangeBaseApiCall(/dutytime/getBaseTime): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  dutyTimeRecordTimeStampApiCall({required Map recordTimeStampData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/recordTimeStamp",
          data: jsonEncode(recordTimeStampData),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on dutyTimeRecordTimeStampApiCall(/dutytime/recordTimeStamp): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  dutyTimeGetMissedTimeStampOutApiCall() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/getMissedTimeStampOut",
          data: jsonEncode({
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on dutyTimeGetMissedTimeStampOutApiCall(/dutytime/getMissedTimeStampOut): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e
                  .response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }

  dutyTimeRecordMissedTimeStampApiCall({required String timeStamp}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dutytime/recordMissedTimeStamp",
          data: jsonEncode({"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "timeStamp": timeStamp}),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              "Error on dutyTimeRecordMissedTimeStampApiCall(/dutytime/recordMissedTimeStamp): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e
                  .response?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nCheck Connection & Try Again.");
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
    }
  }
}
