import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../shared/utils/logged_in_data.dart';

class OperationalExpensesApiProvider {
  final Dio api = ApiProvider.api;

  ///---------------Operational_Expenses_Index_Api_Load_DATA---------START

  operationExpensesIndexFilterData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/index",
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
              "Error on Operational Expenses Index Filter Data(/operationalExpense/index): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesIndexFilterSpecificChildrenItemTypeData({required String expenseTypeId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/specificChildrenItemType",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "expenseTypeId": expenseTypeId}),
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
              "Error on Operational Expenses Index Filter specificChildrenItemType Data(/operationalExpense/specificChildrenItemType): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesIndexData({required Map operationExpensesSearchData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/operationalExpense/search",
            data: jsonEncode(operationExpensesSearchData),
            options: Options(
                headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}, receiveTimeout: const Duration(milliseconds: 50000)));
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        Get.back(closeOverlays: true);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
              "Error on Operational Expenses Index Data(/operationalExpense/search): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesIndexCreateNew() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/create",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
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
              "Error on Create New Operational Expenses(/operationalExpense/create): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  ///---------------Operational_Expenses_Index_Api_Load_DATA---------END

  ///---------------Operational_Expenses_Details_Api_DATA---------------START

  operationExpensesApiCallForDetailsAndEditData({required String opeId, required String action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/details",
          data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "oeId": opeId.toString(), "action": action}),
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
              "Error on Operational Expenses $action Data(/operationalExpense/details): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForApproveOrDenyExpense({required Map operationalExpenseApproveOrDenyData, required String action}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/approveOrDeny",
          data: jsonEncode(operationalExpenseApproveOrDenyData),
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
              "Error on Operational Expenses Approval Or Deny $action Data(/operationalExpense/approveOrDeny): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  ///---------------Operational_Expenses_Details_Api_DATA---------------END

  ///---------------Operational_Expenses_Edit_Api_DATA---------------START

  operationExpensesApiCallForEditNewAddVendorData({required String vendorName}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/addVendor",
          data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "vendorName": vendorName}),
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
              "Error on Operational Expenses Edit Add New Vendor Data(/operationalExpense/addVendor): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForEditUserListData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/getUsers",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
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
              "Error on Operational Expenses Edit User List Data(/operationalExpense/getUsers): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForExpenseTypeChange({required String expenseType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/expenseTypeChange",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
            "expenseTypeId": int.parse(expenseType),
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
              "Error on Operational Expenses Edit Expense Type Change(/operationalExpense/expenseTypeChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForExpenseChildItemSave(
      {required String oeId, required String childOeId, required String itemId, required String itemAmount, required String description, String? gallonAmount}) async {
    if (kDebugMode) {
      print("**********************************");
      print('OeId: $oeId \n childOeId: $childOeId \n ItemId: $itemId \n ItemAmount: $itemAmount \n Description: $description');
      print("**********************************");
    }

    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/saveChildItem",
          data: jsonEncode({
            "OeId": int.parse(oeId),
            "ChildOeId": int.parse(childOeId),
            "ItemId": int.parse(itemId),
            "ItemAmount": double.parse(itemAmount).toStringAsFixed(2),
            "Description": description,
            //"addGallonAmount": double.parse(gallonAmount).toStringAsFixed(2),
            "SystemId": UserSessionInfo.systemId,
            "UserId": UserSessionInfo.userId,
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
              "Error on Operational Expenses Edit Expense Type Change(/operationalExpense/expenseTypeChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForExpenseChildItemUpdateData({required String oeId, required String itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/getExpenseItem",
          data: jsonEncode({"systemId": UserSessionInfo.systemId, "userId": UserSessionInfo.userId, "oeId": oeId, "itemId": itemId}),
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
              "Error on Operational Expenses Edit Expense Type Item Edit Data(/operationalExpense/getExpenseItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForExpenseChildItemDelete({required String oeId, required String itemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/deleteChildItem",
          data: jsonEncode({
            "oeId": int.parse(oeId),
            "itemId": int.parse(itemId),
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
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
              "Error on Operational Expenses Edit Expense Type Item Delete(/operationalExpense/deleteChildItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForExpenseChildItemUpdate({required Map updateChildItemData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/updateChildItem",
          data: jsonEncode(updateChildItemData),
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
              "Error on Operational Expenses Edit Expense Type Update Data(/operationalExpense/updateChildItem): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForUpdateSaveChanges({required Map saveChangesData}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/update",
          data: jsonEncode(saveChangesData),
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
              "Error on Operational Expenses Edit Save Change Update Data(/operationalExpense/update): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForEditIndexCodeChange({required String indexCode}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/indexCodeChange",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
            "indexCode": int.parse(indexCode),
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
              "Error on Operational Expenses Edit Index Code Change Data(/operationalExpense/indexCodeChange): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  operationExpensesApiCallForDelete({required String opeId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/operationalExpense/delete",
          data: jsonEncode({
            "systemId": UserSessionInfo.systemId,
            "userId": UserSessionInfo.userId,
            "oeId": int.parse(opeId.toString()),
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
              "Error on Operational Expenses Edit Index Code Change Data(/operationalExpense/delete): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
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

  ///---------------Operational_Expenses_Edit_Api_DATA--------------- EDN
}
