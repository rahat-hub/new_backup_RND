import 'dart:convert';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

import '../modules/work_order_modules/work_order_jobs/work_order_jobs_models/save_inv_chilt_item.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class WorkOrdersApiProvider {
  final Dio api = ApiProvider.api;

  Future<Response?>? getWorkOrderIndexFilterDropdownApiData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/viewFilter",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Work Order Index Filter data view (/workOrder/viewFilter): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Internet Connection & Try again.");
      return null;
    }
  }

  Future<Response?>? getWorkOrdersIndexSearchApiData({required Map workOrdersSearchData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderSearch",
          data: jsonEncode(workOrdersSearchData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Work Order Index data view (/workOrder/workOrderSearch): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  Future<Response?>? getWorkOrderDetailsApiData({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/details",
          data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "workOrderId": int.parse(workOrderId)}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Work Order Details data view (/workOrder/details): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Internet Connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderRepopulateList({required String groupId, required String itemName, required String itemId, required String action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/jsonfeed/repopulatelist",
            data: jsonEncode({
              "systemId": UserSessionInfo.systemId.toString(),
              "userId": UserSessionInfo.userId.toString(),
              "Action": action,
              "ItemName": itemName,
              "ItemId": itemId,
              "GroupId": groupId,
            }),
            options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}));
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        if (kDebugMode) {
          print(
              "Error on Parts Request(/jsonfeed/repopulatelist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response
                  ?.data["errorMessage"]}");
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response;
      }
    } else {
      await EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return null;
    }
  }

  Future<Response?>? postWorkOrdersEditUpdateApiData({required Map workOrderUpdateApiData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/saveWorkOrder",
          data: jsonEncode(workOrderUpdateApiData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Work Order Edit data view (/workOrder/saveWorkOrder): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e
                .response?.data["errorMessage"]}",
          );
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

  Future<Response?>? aircraftInfoApiCall({required String aircraftId}) async {
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

  Future<Response?>? workOrderAircraftDataApiCall({required String type}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/discrepancies/changeEventDiscrepancyType",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId.toString(),
            'userId': UserSessionInfo.userId.toString(),
            'discrepancyType': type,
            'itemChanged': '0',
            'unitId': '0',
            'componentTypeIdSpecific': '0'
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
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Create changeEventWorkOrderType Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderComponentTypeSpecificDropdownDataApiCall({required String discrepancyType, required String aircraftUnitId}) async {
    try {
      var response = await api.post(
        "/discrepancies/changeEventDiscrepancyUnit",
        data: jsonEncode({
          "systemId": UserSessionInfo.systemId.toString(),
          "userId": UserSessionInfo.userId.toString(),
          "discrepancyType": discrepancyType.toString(),
          "itemChanged": '1',
          "unitId": aircraftUnitId.toString(),
          "componentTypeIdSpecific": '0'
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

  Future<Response?>? postWorkOrdersCreateUpdateApiData({required Map workOrderCreateApiData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/createWorkOrder",
          data: jsonEncode(workOrderCreateApiData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print("Error on Work Order Create data view (/workOrder/createWorkOrder): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",);
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


  //----WorkOrderDetails---API_CALL_DATA

  Future<Response?>? workOrderDetailsApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderDetails",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId.toString(),
            'workOrderId': int.parse(workOrderId)
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
              "Error on Work Order Details (/workOrder/workOrderDetails): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Details Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderGetContactInformationApiCall({required String contactsId, required String name}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getContactInformation",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'contactsId': int.parse(contactsId),
            'name': name,
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
              "Error on Work Order Current Contact Information (/workOrder/getContactInformation): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Current Contact Information. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderGetAllCloseOutLineItemsApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getAllCloseOutLineItems",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order All Close Out Line Items (/workOrder/getAllCloseOutLineItems): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Close Out Line Items. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderGetWoStatusMechanicsAssignedApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/woStatusMechanicsAssigned",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order Status MechanicsAssigned (/workOrder/woStatusMechanicsAssigned): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Status Mechanics Assigned. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderDeleteApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/deleteWorkOrder",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId.toString(),
            'userId': UserSessionInfo.userId.toString(),
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order Delete ID: $workOrderId (/workOrder/deleteWorkOrder): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Delete Id Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderGetAllActiveUsersAndMechanicListingApiCall({required String urlKey}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.get(
          "/workOrder/$urlKey",
          data: jsonEncode({}),
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
              "Error on Work Order Get Active Users(/workOrder/$urlKey): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Active Users Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderJobsBarcodeApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/jobsBarcode",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order Jobs Barcode Data: $workOrderId (/workOrder/jobsBarcode): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Barcode Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderGetAllCustomerApiCall() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getAllCustomer",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'id': 2,
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
              "Error on Work Order Get Billing Information Data: [All Customers] (/workOrder/getAllCustomer): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Get Billing Information Data: [All Customers]. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderGetAllVendorsApiCall() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getAllVendors",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'id': 1,
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
              "Error on Work Order Get Billing Information Data: [All Vendors] (/workOrder/getAllVendors): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else {
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Get Billing Information Data: [All Vendors]. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderBillingInformationApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getWorkOrderBillingData",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order Billing Information (/workOrder/getWorkOrderBillingData): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Billing Information Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderUpdateBillingInformationApiCall({required Map informationData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/updateBillingInformation",
          data: jsonEncode(informationData),
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
              "Error on Work Order Update Billing Information (/workOrder/updateBillingInformation): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Update Billing Information Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderCheckLineItemsExistApiCall({required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderCheckLineItemsExist",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order Save and Complete Check Line Items Exist (/workOrder/workOrderCheckLineItemsExist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Save and Complete Check Line Items Exist Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? getAcDemographicsDataApiCall({required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/acDemographicsData",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'jobId': int.parse(jobId),
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
              "Error on Work Order Ac Demographics Data (/workOrder/jobId): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Ac Demographics Data. \nCheck connection & Try again.");
      return null;
    }
  }

  // workOrderGetContactInformationApiCall({required String name, required String contactsId}) async {
  //   if (InternetCheckerHelperLogic.internetConnected) {
  //     try {
  //       var response = await api.post(
  //         "/workOrder/getWorkOrderBillingData",
  //         data: jsonEncode({
  //           'systemId': UserSessionInfo.systemId,
  //           'userId': UserSessionInfo.userId,
  //           'contactsId': int.parse(contactsId),
  //           "name": name
  //         }),
  //         options: Options(
  //           headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
  //         ),
  //       );
  //       return response;
  //     } on DioException catch (e) {
  //       EasyLoading.dismiss();
  //       Get.back();
  //       SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
  //       if (kDebugMode) {
  //         print(
  //             "Error on Work Order Billing Information (/workOrder/getWorkOrderBillingData): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
  //       }
  //       return e.response;
  //     }
  //   }
  //   else{
  //     EasyLoading.dismiss();
  //     Get.back(closeOverlays: true);
  //     SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Billing Information Data. \nCheck connection & Try again.");
  //     return null;
  //   }
  // }

//--------------Work Order Jobs Api Data.

///>>>>>>>Rahat<<<<<<<<<<<<<<

  Future<Response?>? workOrderJobsFullDataApiCall({required String workOrderId, required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobDetails",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'workOrderId': int.parse(workOrderId),
            'jobId': int.parse(jobId)
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobDetails): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Remove_Create
  Future<Response?>? workOrderJobsPartsRemoveAddApiCall({required Map addingData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobPartRemoveAdd",
          data: jsonEncode(addingData),
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
              "Error on Work Order Jobs Parts Remove Add (/workOrder/workOrderJobPartRemoveAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Remove Add Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Remove_Update_Get
  Future<Response?>? workOrderJobsPartsRemoveUpdateGetDataApiCall({required String partsRemoveId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/partsRemovedEditModalDataById",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'partsRemoveId': int.parse(partsRemoveId)
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
              "Error on Work Order Jobs Parts Remove Update Get Data (/workOrder/partsRemovedEditModalDataById): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Remove Update Get Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Remove_Update
  Future<Response?>? workOrderJobsPartsRemoveUpdatePostApiCall({required Map addingData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobPartRemoveUpdate",
          data: jsonEncode(addingData),
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
              "Error on Work Order Jobs Parts Remove Update (/workOrder/workOrderJobPartRemoveUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Remove Update Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Remove_Delete
  Future<Response?>? workOrderJobsPartsRemoveDeleteApiCall({required String partsRemoveId, required String workOrderId, required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobPartRemoveDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'id': int.parse(partsRemoveId),
            'workOrderId': int.parse(workOrderId),
            'jobId': int.parse(jobId),
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
              "Error on Work Order Jobs Parts Remove Delete (/workOrder/workOrderJobPartRemoveDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Remove Delete. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Install_Create
  Future<Response?>? workOrderJobsPartsInstallAddApiCall({required Map addingData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobPartInstallAdd",
          data: jsonEncode(addingData),
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
              "Error on Work Order Jobs Parts Install Add (/workOrder/workOrderJobPartInstallAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Install Add Data. \nCheck connection & Try again.");
      return null;
    }
  }
  //---Parts_Install_Update_Get
  Future<Response?>? workOrderJobsPartsInstallUpdateGetDataApiCall({required String partsInstallId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/partsInstalledEditModalDataById",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'partsRemoveId': int.parse(partsInstallId)
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
              "Error on Work Order Jobs Parts Install Update Get Data (/workOrder/partsInstalledEditModalDataById): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Install Update Get Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Install_Update
  Future<Response?>? workOrderJobsPartsInstallUpdatePostApiCall({required Map addingData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobPartInstallUpdate",
          data: jsonEncode(addingData),
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
              "Error on Work Order Jobs Parts Install Update (/workOrder/workOrderJobPartInstallUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Install Update Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Parts_Install_Delete
  Future<Response?>? workOrderJobsPartsInstalledDeleteApiCall({required String partsRemoveId, required String workOrderId, required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobPartInstallDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'id': int.parse(partsRemoveId),
            'workOrderId': int.parse(workOrderId),
            'jobId': int.parse(jobId),
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
              "Error on Work Order Jobs Parts Installed Delete (/workOrder/workOrderJobPartInstallDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Installed Delete. \nCheck connection & Try again.");
      return null;
    }
  }


  //---Labor_Users_&_Labors_Rates_DropDownData

  Future<Response?>? workOrderLaborDropDownLoadApiCall() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobLaborAdd",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
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
              "Error on Work Order Jobs Labor Dropdown Data (/workOrder/workOrderJobLaborAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Labor Dropdown Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Labor_Add
  Future<Response?>? workOrderLaborAddApiCall({required Map addLaborData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/addWorkOrderJobLabor",
          data: jsonEncode(addLaborData),
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
              "Error on Work Order Jobs Labor Add Data (/workOrder/addWorkOrderJobLabor): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Labor Add Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Labor_Update_Data_Get_Call
  Future<Response?>? workOrderJobsLaborUpdateGetDataApiCall({required String laborId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobLaborEdit",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'laborId': int.parse(laborId)
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
              "Error on Work Order Jobs Labor Update Get Data (/workOrder/workOrderJobLaborEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Labor Update Get Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Labor_Update_Post_Call
  Future<Response?>? workOrderLaborUpdateApiCall({required Map updateLaborData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/updateWorkOrderJobLaborEdit",
          data: jsonEncode(updateLaborData),
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
              "Error on Work Order Jobs Labor Update Data (/workOrder/updateWorkOrderJobLaborEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Labor Update Data. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Labor_Delete
  Future<Response?>? workOrderJobsLaborDeleteApiCall({required String laborId, required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobLaborDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'laborId': int.parse(laborId),
            'jobId': int.parse(jobId),
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
              "Error on Work Order Jobs Labor Delete (/workOrder/workOrderJobLaborDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Labor Delete. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Work_Order_Jobs_Details_Signature

  Future<Response?>? workOrderJobsDetailsSignatureApiCall({required bool isMechanic, required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobsSign",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'isMechanic': isMechanic,
            'jobId': int.parse(jobId),
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
              "Error on Work Order Jobs Details Signature (/workOrder/workOrderJobsSign): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Details Signature. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Work_Order_Jobs_Data_Edit
  Future<Response?>? workOrderEditJobsGetDataApiCall({required String itemTypeId, required String jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getWoEditJobData",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'itemtypeid': int.parse(itemTypeId),
            'jobId': int.parse(jobId),
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
              "Error on Work Order Edit Jobs Data (/workOrder/getWoEditJobData): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Edit Jobs Jobs. \nCheck connection & Try again.");
      return null;
    }
  }

  //---Work_Order_Jobs_New_Create
  Future<Response?>? workOrderJobsNewCreateApiCall({required String jobAddWoId, required String newJobActionDesc}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/woJobAdd",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'jobAddWoId': int.parse(jobAddWoId),
            'newJobActionDesc': newJobActionDesc,
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
              "Error on Work Order Jobs Create New (/workOrder/woJobAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Create New. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderSaveAndCompleteApiCall({required Map saveAndComData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/saveCompleteWorkOrder",
          data: jsonEncode(saveAndComData),
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
              "Error on Work Order Save And Complete Api Data (/workOrder/saveCompleteWorkOrder): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Save And Complete Api Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderEditJobsGetLogBookPreviewApiCall({required int previewId, required int aircraftId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/getLogBookPreview",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'previewId': previewId,
            'aircraftId': aircraftId,
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
              "Error on Work Order Jobs Logbook Preview Data Data (/workOrder/getLogBookPreview): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Logbook Preview Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? updateItemCaFromWorkOrderJobApiCall({required int itemId, required String correctiveAction}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/updateItemCaFromWorkOrderJob",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'itemId': itemId,
            'correctiveAction': correctiveAction,
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
              "Error on Update Item Ca From WorkOrder Job Data (/workOrder/updateItemCaFromWorkOrderJob): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Update Item Ca From WorkOrder Job Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderJobsDeleteApiCall({required String jobId, required String workOrderId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/DeleteWorkOrderJobs",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'jobId': int.parse(jobId),
            'workOrderId': int.parse(workOrderId),
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
              "Error on Work Order Jobs Delete (/workOrder/DeleteWorkOrderJobs): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Delete. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?>? workOrderJobsEditApiCall({required Map updateJobData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/jobUpdate",
          data: jsonEncode(updateJobData),
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
              "Error on Work Order Jobs Update (/workOrder/jobUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Update. \nCheck connection & Try again.");
      return null;
    }
  }


  Future<Response?>? workOrderJobsPartsRequestDeleteApiCall({required String partsRequestId}) async  {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/partsRequestDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'parstRequestId': int.parse(partsRequestId)
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
              "Error on Work Order Jobs Parts Request Delete (/workOrder/partsRequestDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Parts Request Delete. \nCheck connection & Try again.");
      return null;
    }
  }


///>>>>>>>Tayeb<<<<<<<<<<<<<<

  Future<Response?> workOrderJobNonInvAdd({required Map woJobNonInvAddData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobNonInvAdd",
          data: jsonEncode(woJobNonInvAddData),
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobNonInvAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrdersJobsNonInventoryById({required int nonInvId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrdersJobsNonInventoryById",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'nonInvId': nonInvId
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrdersJobsNonInventoryById): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> updateWorkOrderJobNonInvEdit({required Map woJobNonInvUpdateData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/updateWorkOrderJobNonInvEdit",
          data: jsonEncode(woJobNonInvUpdateData),
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
              "Error on Work Order Jobs Full Data (/workOrder/updateWorkOrderJobNonInvEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobNonInvDelete({required int id, required int workOrderId, required int jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobNonInvDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'id': id,
            'workOrderId': workOrderId,
            'jobId': jobId
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobNonInvDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> mechanicUsers({required int vendorId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/mechanicUsers",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'nonInvId': vendorId
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
              "Error on Work Order Jobs Full Data (/workOrder/mechanicUsers): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> rePopulateList({required String actionName,String groupId = "0",String itemId = "0"}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/jsonfeed/repopulatelist",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'Action': actionName,
            "ItemName": "0",
            "ItemId": itemId,
            "GroupId": groupId,
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
              "Error on Work Order Jobs Full Data (/jsonfeed/repopulatelist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobMechanicAdd({required int jobId, required int workOrderId,required int vendorId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobMechanicAdd",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'jobId': jobId,
            "workOrderId": workOrderId,
            "vendorId": vendorId,
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobMechanicAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> woMechanicsAssignedForJobDelete({required int id}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderMechanicsAssignedForJobDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "id" : id
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderMechanicsAssignedForJobDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobDocEdit({required int workOrderId,required int jobId,required int id}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobDocEdit",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "workOrderId" : workOrderId,
            "jobId" : jobId,
            "id" : id,
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobDocEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobDocDelete({required int workOrderId,required int jobId,required int id}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobDocDelete",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "workOrderId" : workOrderId,
            "jobId" : jobId,
            "id" : id,
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobDocDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobDocUpdate({required int workOrderId,required int jobId,required int id,required String documentDate,required String documentDescription}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobDocUpdate",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "workOrderId" : workOrderId,
            "jobId" : jobId,
            "id" : id,
            "documentDate" : documentDate,
            "documentDescription" : documentDescription
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobDocUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderInventoryFilter() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderInventoryFilter",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderInventoryFilter): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> searchWoInventoryByOptions() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/searchWoInventoryByOptions",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'nameOrPartNumber': "",
            'description': "",
            'locationId': 0,
            'locationSubId': 0,
            'serialNumber': "",
            'categoryId': 0,
            'manufacturerId': 0,
            'row': "",
            'shelf': "",
            'bin': "",
            'aisle': "",
            'maxResults': 100,
            'showExpiringCounts': false,
            'locationName': "",
            'subLocationName': "",
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
              "Error on Work Order Jobs Full Data (/workOrder/searchWoInventoryByOptions): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> inventoryDetailsWithSelector({required int id, required int itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/inventoryDetailsWithSelector",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            'id': id,
            'itemId': itemId,
            'locationId': 0,
            'locationSubId': 0,
            'serialNumber': "",
            'categoryId': 0,
            'manufacturerId': 0,
            'row': "",
            'shelf': "",
            'bin': "",
            'aisle': "",
            'maxResults': 100,
            'showExpiringCounts': false,
            'locationName': "",
            'subLocationName': "",
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
              "Error on Work Order Jobs Full Data (/workOrder/inventoryDetailsWithSelector): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobInvAdd({required int itemId,required int workOrderId,required int jobId,required String itemIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobInvAdd",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "itemId" : itemId,
            "workOrderId" : workOrderId,
            "jobId" : jobId,
            "itemIdList" : itemIdList,
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobInvAdd): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobInvItemEdit({required int parentId,required int workOrderId,required int jobId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobInvItemEdit",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "workOrderId" : workOrderId,
            "jobId" : jobId,
            "parentId" : parentId
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobInvItemEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> itemChildDetails({required int parentId,required int itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/itemChildDetails",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "parentId" : parentId,
            "itemId" : itemId,
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
              "Error on Work Order Jobs Full Data (/workOrder/itemChildDetails): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> itemCostAnalysis({required int subBaseId,required int itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/itemCostAnalysis",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "basesubId" : subBaseId,
            "itemId" : itemId,
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
              "Error on Work Order Jobs Full Data (/workOrder/itemCostAnalysis): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> commonLocation({required int itemId,required int subId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/commonLocation",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "subId" : subId,
            "itemId" : itemId,
            "actionName" : "GetPreviousRowShelfBin_2"
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
              "Error on Work Order Jobs Full Data (/workOrder/commonLocation): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> itemChildHistory({required int itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/itemChildHistory",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "itemId" : itemId,
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
              "Error on Work Order Jobs Full Data (/workOrder/itemChildHistory): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobInvReturn({required WorkOrderJobInvReturn objParam}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobInvReturn",
          data: jsonEncode({
            'systemId': objParam.systemId,
            'userId': objParam.userId,
            "jobId" : objParam.jobId,
            "childId" : objParam.childId,
            "workOrderId" : objParam.workOrderId
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobInvReturn): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobInvItemDeleteItem({required WorkOrderJobInvReturn objParam}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobInvItemDeleteItem",
          data: jsonEncode({
            'systemId': objParam.systemId,
            'userId': objParam.userId,
            "jobId" : objParam.jobId,
            "childId" : objParam.childId,
            "workOrderId" : objParam.workOrderId
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobInvItemDeleteItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> workOrderJobInvItemUpdateInvoicePrice({required WorkOrderJobInvReturn objParam}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/workOrderJobInvItemUpdateInvoicePrice",
          data: jsonEncode({
            'systemId': objParam.systemId,
            'userId': objParam.userId,
            "jobId" : objParam.jobId,
            "childId" : objParam.childId,
            "workOrderId" : objParam.workOrderId,
            "id" : objParam.id,
            "invoicePrice" : objParam.invoicePrice
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
              "Error on Work Order Jobs Full Data (/workOrder/workOrderJobInvItemUpdateInvoicePrice): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

  Future<Response?> exportCompliance({required int itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/workOrder/exportCompliance",
          data: jsonEncode({
            'systemId': UserSessionInfo.systemId,
            'userId': UserSessionInfo.userId,
            "itemId" : itemId
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
              "Error on Work Order Jobs Full Data (/workOrder/exportCompliance): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response;
      }
    }
    else{
      EasyLoading.dismiss();
      Get.back(closeOverlays: true);
      SnackBarHelper.openSnackBar(isError: true, message: "Unable to Load Work Order Jobs Full Data. \nCheck connection & Try again.");
      return null;
    }
  }

}
