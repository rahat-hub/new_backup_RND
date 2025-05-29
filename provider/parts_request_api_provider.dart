import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../helper/snack_bar_helper.dart';
import '../shared/utils/logged_in_data.dart';
import 'api_provider.dart';

class PartsRequestApiProvider {
  final Dio api = ApiProvider.api;

  createNewPR() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/createNewPR",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/createNewPR): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  partsRequestFilter({required String groupId, required String itemName, required String itemId, required String action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/jsonfeed/repopulatelist",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "Action": action.toString(),
            "ItemName": itemName.toString(),
            "ItemId": itemId.toString(),
            "GroupId": groupId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        if (kDebugMode) {
          print(
            "Error on Parts Request(/jsonfeed/repopulatelist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  partsRequestViewFormData({
    requestPriority,
    requestorId,
    numberResult,
    requestStatus,
    requestReceivedBy,
    requestItem,
    dateForm,
    dateTo,
    String? vendorId = "0",
    String? workOrder = "0",
    notes,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/searchPR",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "requestPriority": requestPriority.toString(),
            "requestorId": requestorId.toString(),
            "requestStatus": requestStatus.toString(),
            "numberResults": numberResult.toString(),
            "requestReceivedBy": requestReceivedBy.toString(),
            "requestItem": requestItem.toString(),
            "dateFrom": dateForm.toString(),
            "dateTo": dateTo.toString(),
            "vendorId": vendorId,
            "workOrder": workOrder,
            "notes": notes.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/searchPR): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  partsRequestViewFormDataFromDelete() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/searchPR",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "requestPriority": "0",
            "requestorId": "0",
            "requestStatus": "-1",
            "numberResults": "100",
            "requestReceivedBy": "",
            "requestItem": "",
            "dateFrom": "",
            "dateTo": "",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/searchPR): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  partsRequestDetails({prId, lastViewedPartsRequest, addItem, addItemQty, action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/details",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "lastViewedPartsRequest": lastViewedPartsRequest.toString(),
            "addItem": addItem.toString(),
            "addItemQty": addItemQty.toString(),
            "action": action.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/details): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  partsRequestEditItem({prId, prItemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/getEditItem",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "prItemId": prItemId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/editItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  checkInventoryLevels({invParentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/invQtyLookup",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "id": invParentId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/invQtyLookup): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prJsonFeed({action, groupId = "0", itemName = "0"}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/jsonfeed/repopulatelist",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "Action": action.toString(),
            "ItemName": itemName.toString(),
            "ItemId": "0",
            "GroupId": groupId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/jsonfeed/repopulatelist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prJsonFeed1({action, item, itemId, groupId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/jsonfeed/repopulatelist",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "Action": action.toString(),
            "Item": "0",
            "ItemId": "0",
            "GroupId": "0",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/jsonfeed/repopulatelist): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  shipToAddress({shipToType, shipToTypeSpecific}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/shipToAddress",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "shipToType": shipToType.toString(), "shipToTypeSpecific": shipToTypeSpecific.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/shipToAddress): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  workOrderSearch({woSearchType, woSearchAC, wOSearchStatus, wOSearchDateRange, wOSearchDRS, wOSearchDRE}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prWorkOrderSearch",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "WOSearchType": woSearchType.toString(),
            "WOSearchAC": woSearchAC.toString(),
            "WOSearchStatus": wOSearchStatus.toString(),
            "WOSearchDateRange": wOSearchDateRange.toString(),
            "WOSearchDRS": wOSearchDRS.toString(),
            "WOSearchDRE": wOSearchDRE.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prWorkOrderSearch): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  addNewSV({serviceVariableName}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addNewSV",
          data: jsonEncode({"SystemId": UserSessionInfo.systemId.toString(), "UserId": UserSessionInfo.userId.toString(), "serviceVariableName": serviceVariableName.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addNewSV): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  deleteItem({prId, itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/deletePRItem",
          data: jsonEncode({"SystemId": UserSessionInfo.systemId.toString(), "UserId": UserSessionInfo.userId.toString(), "prId": prId.toString(), "itemId": itemId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/deleteItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  postUpdateItem({prItemId, prId, requestedDate, quantity, unitCost, reasonCode, workOrderId, mxManualPage, coreRequired}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postUpdateItem",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRItemId": prItemId.toString(),
            "PRId": prId.toString(),
            "RequestedDate": requestedDate.toString(),
            "Quantity": quantity.toString(),
            "UnitCost": unitCost.toString(),
            "ReasonCode": reasonCode.toString(),
            "WorkOrderId": workOrderId.toString(),
            "MxManualPage": mxManualPage.toString(),
            "CoreRequired": coreRequired.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postUpdateItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  addToBid({prItemId, prId, prBidId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addToBid",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "prBidId": prBidId.toString(),
            "prItemId": prItemId.toString(),
            "prId": prId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addToBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  searchItem({searchId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/searchInventoryItem",
          data: jsonEncode({"SystemId": UserSessionInfo.systemId.toString(), "UserId": UserSessionInfo.userId.toString(), "searchId": searchId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/searchItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  addInventoryItem({itemName, partNumber, category, manufacturer}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addInventoryItem",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "ItemId": 0,
            "ItemName": itemName.toString(),
            "PartNumber": partNumber.toString(),
            "Category": category.toString(),
            "Manufacturer": manufacturer.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addInventoryItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  addPRItem({prId, addItemPNpID, addItemWONumber, addReasonId, requestByDate, addItemCost, addItemQuantity, addItemmxManualPage, addCoreRequired}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addPRItem",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "AddItemPNpID": addItemPNpID.toString(),
            "AddItemWONumber": addItemWONumber.toString(),
            "AddReasonId": addReasonId.toString(),
            "RequestByDate": requestByDate.toString(),
            "AddItemCost": addItemCost.toString(),
            "AddItemQuantity": addItemQuantity.toString(),
            "AddItemmxManualPage": addItemmxManualPage.toString(),
            "AddCoreRequired": addCoreRequired.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addPRItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  addPRNewNote({prId, note}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addPRNewNote",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "prId": prId.toString(), "note": note.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addPRNewNote): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  addInventoryItemAnyway({itemName, partNumber, category, manufacture}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addInventoryItemAnyway",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "ItemId": 0,
            "ItemName": itemName.toString(),
            "PartNumber": partNumber.toString(),
            "Category": category.toString(),
            "Manufacturer": manufacture.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addInventoryItemAnyway): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prEquipmentTypeChange({equipmentId, requestType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prEquipmentTypeChange",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "equipmentId": equipmentId.toString(),
            "requestType": requestType.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prEquipmentTypeChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prDelete({prId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prDelete",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "prId": prId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prDelete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prUpdate({
    prId,
    requestorId,
    requestType,
    requestPriority,
    shipToType,
    shipToTypeSpecific,
    shippingAddress,
    equipmentID,
    equipmentTT,
    equipmentE1TT,
    equipmentE2TT,
    equipmentE3TT,
    equipmentE4TT,
    equipmentSN,
    equipmentE1SN,
    equipmentE2SN,
    equipmentE3SN,
    equipmentE4SN,
    requestStatus,
    notifyId,
    registration,
    receivedBy,
    actionName,
    receivedByContactInfo,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prUpdate",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "RequestorId": requestorId.toString(),
            "RequestType": requestType.toString(),
            "RequestPriority": requestPriority.toString(),
            "ShipToType": shipToType.toString(),
            "ShipToTypeSpecific": shipToTypeSpecific.toString(),
            "ShippingAddress": shippingAddress.toString(),
            "EquipmentID": equipmentID.toString(),
            "EquipmentTT": equipmentTT.toString(),
            "EquipmentE1TT": equipmentE1TT.toString(),
            "EquipmentE2TT": equipmentE2TT.toString(),
            "EquipmentE3TT": equipmentE3TT.toString(),
            "EquipmentE4TT": equipmentE4TT.toString(),
            "EquipmentSN": equipmentSN.toString(),
            "EquipmentE1SN": equipmentE1SN.toString(),
            "EquipmentE2SN": equipmentE2SN.toString(),
            "EquipmentE3SN": equipmentE3SN.toString(),
            "EquipmentE4SN": equipmentE4SN.toString(),
            "RequestStatus": requestStatus.toString(),
            "NotifyId": notifyId.toString(),
            "Registration": registration.toString(),
            "ReceivedBy": receivedBy.toString(),
            "ActionName": actionName.toString(),
            "ReceivedByContactInfo": receivedByContactInfo.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prUpdate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prCompleteAddingItemsAdvance({
    prId,
    requestorId,
    requestType,
    requestPriority,
    shipToType,
    shipToTypeSpecific,
    shippingAddress,
    equipmentID,
    equipmentTT,
    equipmentE1TT,
    equipmentE2TT,
    equipmentE3TT,
    equipmentE4TT,
    equipmentSN,
    equipmentE1SN,
    equipmentE2SN,
    equipmentE3SN,
    equipmentE4SN,
    requestStatus,
    notifyId,
    registration,
    receivedBy,
    actionName,
    receivedByContactInfo,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prCompleteAddingItemsAdvance",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "RequestorId": requestorId.toString(),
            "RequestType": requestType.toString(),
            "RequestPriority": requestPriority.toString(),
            "ShipToType": shipToType.toString(),
            "ShipToTypeSpecific": shipToTypeSpecific.toString(),
            "ShippingAddress": shippingAddress.toString(),
            "EquipmentID": equipmentID.toString(),
            "EquipmentTT": equipmentTT.toString(),
            "EquipmentE1TT": equipmentE1TT.toString(),
            "EquipmentE2TT": equipmentE2TT.toString(),
            "EquipmentE3TT": equipmentE3TT.toString(),
            "EquipmentE4TT": equipmentE4TT.toString(),
            "EquipmentSN": equipmentSN.toString(),
            "EquipmentE1SN": equipmentE1SN.toString(),
            "EquipmentE2SN": equipmentE2SN.toString(),
            "EquipmentE3SN": equipmentE3SN.toString(),
            "EquipmentE4SN": equipmentE4SN.toString(),
            "RequestStatus": requestStatus.toString(),
            "NotifyId": notifyId.toString(),
            "Registration": registration.toString(),
            "ReceivedBy": receivedBy.toString(),
            "ActionName": actionName.toString(),
            "ReceivedByContactInfo": receivedByContactInfo.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prCompleteAddingItemsAdvance): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  loadPrCreateDropDown() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/getPRCreateBid",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/getPRCreateBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  createPrBids({prId, vendorId, prBidAutoId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postPRCreateBid",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "vendorId": vendorId.toString(),
            "prBidAutoId": prBidAutoId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postPRCreateBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prAddItemTOBid({prId, bidId, itemId, quantity}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postPRAddItemToBid",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "bidId": bidId.toString(),
            "itemId": itemId.toString(),
            "quantity": quantity.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postPRAddItemToBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prItemsToBidInventoryTypeChange({prId, itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prItemsToBidInventoryTypeChange",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "prId": prId.toString(), "itemId": itemId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prItemsToBidInventoryTypeChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  postEditBidItems({prId, bidId, contactMethod, notes, costsCore, costsShipping, costsLabor, costsTaxes, costsOther, items}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postEditBidItems",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "BidId": bidId.toString(),
            "ContactMethod": contactMethod.toString(),
            "Notes": notes.toString(),
            "CostsCore": costsCore.toString(),
            "CostsShipping": costsShipping.toString(),
            "CostsLabor": costsLabor.toString(),
            "CostsTaxes": costsTaxes.toString(),
            "CostsOther": costsOther.toString(),
            "Items": items,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postEditBidItems): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  getEmailBid({prId, prBidId, emailOrView}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/getEmailBid",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "prBidId": prBidId.toString(),
            "emailOrView": emailOrView.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/getEmailBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  postEmailBid({prId, prBidId, emailToType, userSelected, vendorContact, emailToSpecifiedAddress, actionName, emailOrView}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postEmailBid",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "BidId": prBidId.toString(),
            "EmailToType": emailToType.toString(),
            "UserSelected": userSelected.toString(),
            "VendorContact": vendorContact.toString(),
            "EmailToSpecifiedAddress": emailToSpecifiedAddress.toString(),
            "ActionName": actionName.toString(),
            "EmailOrView": emailOrView.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postEmailBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  viewEmailBid({prId, bidId, emailToType, userSelected, vendorContact, emailToSpecifiedAddress, actionName, emailOrView}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postEmailBid",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "BidId": bidId.toString(),
            "EmailToType": emailToType.toString(),
            "UserSelected": userSelected.toString(),
            "VendorContact": vendorContact.toString(),
            "EmailToSpecifiedAddress": emailToSpecifiedAddress.toString(),
            "ActionName": actionName.toString(),
            "EmailOrView": emailOrView.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postEmailBid): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prEditBidActions({prId, prBidId, prBidItemId, action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prEditBidActions",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "prBidId": prBidId.toString(),
            "prBidItemId": prBidItemId.toString(),
            "action": action.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prEditBidActions): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prBidItemActions({prId, prBidId, prBidItemId, quantityRequested, costEach, quantityAvailable}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prbidItemEdit",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "prBidId": prBidId.toString(),
            "prBidItemId": prBidItemId.toString(),
            "quantityRequested": quantityRequested.toString(),
            "costEach": costEach.toString(),
            "quantityAvailable": quantityAvailable.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prbidItemEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prBidItemAction({prId, prBidId, prBidItemId, action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prBidItemAction",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId.toString(),
            "prBidId": prBidId.toString(),
            "prBidItemId": prBidItemId.toString(),
            "action": action.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prBidItemAction): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prUpdateItemPrice({prBidItemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prUpdateItemPrice",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "prBidItemId": prBidItemId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prUpdateItemPrice): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prGetPOEditShipmentCompletion({prBidItemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prGetPOEditShipmentCompletion",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "prBidItemId": prBidItemId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prGetPOEditShipmentCompletion): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prBaseAndItems({prShipId, prItemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prBaseAndItems",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prShipId": prShipId.toString(),
            "prItemId": prItemId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prBaseAndItems): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prItemsOnShipment({prShipId, prItemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prItemsOnShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prShipId": prShipId.toString(),
            "prItemId": prItemId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prItemsOnShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prItemLocation({prItemId, prSubBaseId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prItemLocation",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prItemId": prItemId.toString(),
            "prSubBaseId": prSubBaseId.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prItemLocation): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prUpdateShipmentSingleItem({prShipId, prShipItemId, jsonData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prUpdateShipmentSingleItem",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prShipId": prShipId.toString(),
            "prShipItemId": prShipItemId.toString(),
            "jsonData": jsonData.toString(),
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prUpdateShipmentSingleItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  completePOShipment({prId, prBidId, prShipmentId, prShipReceiveDate, isItemsLocationNotifyRequestor, assignToBase}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/completePOShipment",
          data: jsonEncode({
            "SystemId": UserSessionInfo.systemId.toString(),
            "UserId": UserSessionInfo.userId.toString(),
            "PRId": prId.toString(),
            "PRBidId": prBidId.toString(),
            "PRShipmentId": prShipmentId.toString(),
            "PRShipReceiveDate": prShipReceiveDate,
            "IsItemsLocationNotifyRequestor": isItemsLocationNotifyRequestor.toString(),
            "AssignToBase": assignToBase,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/completePOShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  vendorOptions() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/LoadOptions/GenerateOptions",
          data: jsonEncode({"OptionsType": "Vendor"}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/LoadOptions/GenerateOptions): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  /// ------------------- Start RAHAT Block ________________

  prPurchaseOrderPOEditDataApiCall({required poEditData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postPOEdit",
          data: jsonEncode(poEditData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postPOEdit): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderCreateCoreShipmentDataPostApiCall({required createCoreShipmentData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postNewPOCoreShipment",
          data: jsonEncode(createCoreShipmentData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postNewPOCoreShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderEditCoreShipmentDataApiCall({required editCoreShipmentData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postEditPOCoreShipment",
          data: jsonEncode(editCoreShipmentData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postEditPOCoreShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderDeleteCoreShipmentDataGetApiCall({required prId, required prBidId, required coreShipmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/getDeleteCoreShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId,
            "prBidId": prBidId,
            "coreShipmentId": coreShipmentId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/getDeleteCoreShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderDeleteCoreShipmentDataPostApiCall({required prId, required prBidId, required coreShipmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postDeleteCoreShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId,
            "prBidId": prBidId,
            "coreShipmentId": coreShipmentId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postDeleteCoreShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderCreateShipmentDataPostApiCall({required createShipmentData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postNewPOShipment",
          data: jsonEncode(createShipmentData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postNewPOShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderEditShipmentDataGetApiCall({required prId, required prBidId, required prShipmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prGetShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId,
            "prBidId": prBidId,
            "prShipmentId": prShipmentId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prGetShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderEditShipmentDataPostApiCall({required editShipmentData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/prUpdateShipment",
          data: jsonEncode(editShipmentData),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/prUpdateShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderAddAllItemsToShipmentDataPostApiCall({required prId, required prBidId, required shipmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/addItemsToShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId,
            "prBidId": prBidId,
            "shipmentId": shipmentId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/addItemsToShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderDeleteShipmentDataGetApiCall({required prId, required prBidId, required shipmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/getDeleteShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId,
            "prBidId": prBidId,
            "shipmentId": shipmentId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/getDeleteShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderDeleteShipmentDataPostApiCall({required prId, required prBidId, required shipmentId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/postDeleteShipment",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId.toString(),
            "userId": UserSessionInfo.userId.toString(),
            "prId": prId,
            "prBidId": prBidId,
            "shipmentId": shipmentId,
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/postDeleteShipment): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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

  prPurchaseOrderPDFViewDataApiCall({required prId, required prBidId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/partsRequest/printPO",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "prId": prId, "prBidId": prBidId}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on Parts Request(/partsRequest/printPO): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
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
