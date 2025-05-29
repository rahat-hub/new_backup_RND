import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class DiscrepancyNewApiProvider {
  final Dio api = ApiProvider.api;

  ///-----------------Index_Page_Discrepancy

  discrepancyIndexFilterData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/viewFilter",
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
          print(
              "Error on Discrepancy Index Filter data view (/discrepancies/viewFilter): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Index Data. \nCheck connection & Try again.");
      return null;
    }
  }

  ataCodeData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/viewAtaCode",
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
          print(
              "Error on ATA Code(/discrepancies/viewAtaCode): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Index Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyIndexPageViewData({required Map discrepancyFilterApiData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/viewData",
          data: jsonEncode(discrepancyFilterApiData),
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
          print(
              "Error on Discrepancy Index View Data(/discrepancies/viewData): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Index Data. \nCheck connection & Try again.");
      return null;
    }
  }

  ///----------------Details_View_Discrepancy

  discrepancyViewData({required String discrepancyId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/details",
          data: jsonEncode({
            "system_id": UserSessionInfo.systemId.toString(),
            "user_id": UserSessionInfo.userId.toString(),
            "discrepanciesId": discrepancyId.toString(),
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
              "Error on Discrepancy View Data (/discrepancies/details): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy View Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyViewAttachmentDeleteApiCall({required String attachmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/removeAttachment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "attachmentId": attachmentId,
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
              "Error on Discrepancy View Data (/discrepancies/removeAttachment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy View Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyDetailsForAirPerformSignatureApiCall({required String discrepancyId, required String userPassword}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          '/discrepancies/updateAirPerformed',
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "discrepancyId": discrepancyId,
            "userPassword": userPassword
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
              "Error on Discrepancy View Data (/discrepancies/updateAirPerformed): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy View Data. \nCheck connection & Try again.");
      return null;
    }
  }

  ///----------------Edit_View_Discrepancy

  discrepancyEditViewData({required String discrepancyId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/viewUpdate",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "discrepancyId": discrepancyId.toString()}),
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
              "Error on Edit Discrepancy View (/discrepancies/viewUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Edit View Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyEditSaveApiCallData({required Map saveEditData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/update",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "createDiscrepancy": saveEditData,
          }),
          options: Options(
            headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
          ),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.offNamedUntil(Routes.discrepancyIndex, ModalRoute.withName(Routes.dashBoard));
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Edit Discrepancy update Data (/discrepancies/update): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.offNamedUntil(Routes.discrepancyIndex, ModalRoute.withName(Routes.dashBoard));
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to update Discrepancy Edit Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyUserNotifierApiCallData({required String aircraftId, required String discrepancyType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/notifiedUsers",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "aircraftId": aircraftId,
            "discrepancyType": discrepancyType
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
              "Error on Edit Discrepancy update Data (/discrepancies/notifiedUsers): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to update Discrepancy Edit Data. \nCheck connection & Try again.");
      return null;
    }
  }

  ///----------------Create_View_Discrepancy

  discrepancyCreateViewData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/viewCreate",
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
              "Error on Create new Discrepancy View (/discrepancies/viewCreate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Create View Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyTypeChangeApiCall({required String discrepancyId, required String itemChange, required String unitId, required String componentTypeIdSpecific}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/changeEventDiscrepancyType",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "discrepancyType": discrepancyId.toString(),
            "itemChanged": itemChange,
            "unitId": unitId,
            "componentTypeIdSpecific": componentTypeIdSpecific
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
              "Error on Create new Discrepancy changeEventDiscrepancyType (/discrepancies/changeEventDiscrepancyType): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Create changeEventDiscrepancyType Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyAircraftInfoApiCall({required String aircraftId}) async {
    try {
      var response = await api.post(
        "/discrepancies/aircraftInfo",
        data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "aircraftId": aircraftId}),
        options: Options(
          headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
        ),
      );
      return response;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Aircraft Info. \nCheck connection & Try again.");
      return e.response;
    }
  }

  discrepancyComponentOnAircraftDropdownDataLoad(
      {required String discrepancyType, required String aircraftUnitId, String itemChanged = '1', String componentTypeIdSpecific = '0'}) async {
    try {
      var response = await api.post(
        "/discrepancies/changeEventDiscrepancyUnit",
        data: jsonEncode({
          "systemId": UserSessionInfo.systemId.toString(),
          "userId": UserSessionInfo.userId.toString(),
          "discrepancyType": discrepancyType.toString(),
          "itemChanged": itemChanged,
          "unitId": aircraftUnitId.toString(),
          "componentTypeIdSpecific": componentTypeIdSpecific
        }),
        options: Options(
          headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
        ),
      );
      return response;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Component on Aircraft Info Data. \nCheck connection & Try again.");
      return e.response;
    }
  }

  discrepancyComponentOnAircraftThirdDropdownDataLoad(
      {required String discrepancyId, required String itemChange, required String aircraftUnitId, required String componentTypeIdSpecific}) async {
    try {
      var response = await api.post(
        "/discrepancies/changeEventComponentSpecificType",
        data: jsonEncode({
          "systemId": UserSessionInfo.systemId.toString(),
          "userId": UserSessionInfo.userId.toString(),
          "discrepancyType": discrepancyId,
          "itemChanged": itemChange,
          "unitId": aircraftUnitId,
          "componentTypeIdSpecific": componentTypeIdSpecific
        }),
        options: Options(
          headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
        ),
      );
      return response;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Component on Aircraft Info Data. \nCheck connection & Try again.");
      return e.response;
    }
  }

  discrepancyCreateSaveApiCall({required Map createDiscrepancyData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/create",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "createDiscrepancy": createDiscrepancyData,
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
              "Error on Discrepancy Index View Data(/discrepancies/create): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy Index Data. \nCheck connection & Try again.");
      return null;
    }
  }

  discrepancyCreateElectronicSignatureValidateUserPassword({required String empId, required String userPassword}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          '/electronicSignature/validateUserPassword',
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "empId": empId, "password": userPassword}),
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
              "Error on Discrepancy View Data (/electronicSignature/validateUserPassword): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Discrepancy View Data. \nCheck connection & Try again.");
      return null;
    }
  }
}
