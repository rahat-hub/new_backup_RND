import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/api_provider.dart';
import 'package:aviation_rnd/shared/utils/logged_in_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DefaultReportsApiProvider {
  final Dio api = ApiProvider.api;

  /// *************** START RAHAT's BLOCKS *****************

  Future<Response?> getReportAircraftPurchasePriceApiData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftPurchasePrice",
          data: jsonEncode(<String, String>{"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString()}),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftPurchasePrice): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAircraftActivityApiData({required String strDateStart, required String strDateEnd, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftActivity",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": strDateStart,
            "endDate": strDateEnd,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftActivity): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAccessoryMileageApiData({required String typeIdList, required String userIdList, required String baseIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAccessoryMileage",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "typeIdList": typeIdList,
            "userIdList": userIdList,
            "baseIdList": baseIdList,
          }),
          options: Options(headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAccessoryMileage): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAccessoryStatusApiData({required String typeIdList, required String userIdList, required String baseIdList, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAccessoryStatus",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "typeIdList": typeIdList,
            "userIdList": userIdList,
            "baseIdList": baseIdList,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAccessoryStatus): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAircraftInspectionRemainsApiData({required String aircraftInspectionIdList, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftInspectionRemains",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "aircraftInspectionIdList": aircraftInspectionIdList,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftInspectionRemains): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAircraftItemsPerformedApiData({required String startDate, required String endDate, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftItemsPerformed",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftItemsPerformed): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAircraftOOSReportApiData({
    required String startDate,
    required String endDate,
    required String aircraftIdList,
    required String typeIdList,
    required String conditionIdList,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftOOSReport",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
            "typeIdList": typeIdList,
            "conditionIdList": conditionIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftOOSReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAircraftOperationalExpensesSummaryApiData({required String startDate, required String endDate, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getAircraftOperationalExpensesALL",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getAircraftOperationalExpensesALL): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportComponentValuationApiData({required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportComponentValuation",
          data: jsonEncode(<String, String>{"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "aircraftIdList": aircraftIdList}),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportComponentValuation): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportComponentsForecasterApiData({required String aircraftIdList, required String componentIdList, String? partNumber}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportComponentsForecaster",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "aircraftIdList": aircraftIdList,
            "componentIdList": componentIdList,
            "partNumber": partNumber ?? "",
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportComponentsForecaster): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportCloseOutFormVsLogbookApiData({required String startDate, required String endDate, required String userIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportCloseOutVsLogbook",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "userIdList": userIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportCloseOutVsLogbook): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportComponentRemovedApiData({required String reportType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportComponentsRemoved",
          data: jsonEncode(<String, String>{"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "reportType": reportType}),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportComponentsRemoved): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAircraftTotalTimesAsOfDateApiData({required String startDate, required String endDate, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftTotalTimesAsOfDate",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftTotalTimesAsOfDate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAserGraphsApiData({required String startDate, required String endDate, required String reportType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAserGraphs",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "reportType": reportType,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAserGraphs): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportAserReviewApiData({required String startDate, required String endDate, required String reportType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAserReviews",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "reportType": reportType,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAserReviews): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFAARegistrationsApiData({required String reportType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportFAARegistrations",
          data: jsonEncode(<String, String>{"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "reportType": reportType}),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportFAARegistrations): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFlightLogBookApiData({
    required String startDate,
    required String endDate,
    required String reportType,
    required String aircraftTypesList,
    required String userIdList,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportFlightLogBookReport",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "reportType": reportType,
            "aircraftTypesList": aircraftTypesList,
            "userIdList": userIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportFlightLogBookReport): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFormExportApiData({
    required String startDate,
    required String endDate,
    required String reportType,
    required String aircraftIdList,
    required String formIdList,
    required String userIdList,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportPDFBatch",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
            "formIdList": formIdList,
            "userIdList": userIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportPDFBatch): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFuelFarmStatusApiData({required String reportType}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportFuelStatus",
          data: jsonEncode(<String, String>{"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "reportType": reportType}),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportFuelStatus): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFuelFarmUsageApiData({required String reportType, required String startDate, required String endDate, required String fuelFarmIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Fuel_Usage",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
            "fuelFarmIdList": fuelFarmIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Fuel_Usage): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFuelUsedSummaryAveragesApiData({
    required String reportType,
    required String startDate,
    required String endDate,
    required String fuelFarmIdList,
    required String aircraftIdList,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Fuel_Used_Summary_Averages",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
            "fuelFarmIdList": fuelFarmIdList,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Fuel_Used_Summary_Averages): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportFuelLoadsApiData({required String reportType, required String startDate, required String endDate, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Fuel_Loads",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Fuel_Loads): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportLaserStrikesApiData({required String reportType, required String startDate, required String endDate}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Laser_Strikes",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Laser_Strikes): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportMechanicApiData({required String reportType, required String startDate, required String endDate, required String mechanicIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Mechanic_Report",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
            "mechanicIdList": mechanicIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Mechanic_Report): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getReportModsPerformedApiData({required String reportType, required String modNumber}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_MODs",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "modNumber": modNumber,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_MODs): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  /// *************** END RAHAT's BLOCKS *****************

  /// ********************** START TAYEB BLOCK ***********

  Future<Response?> getReportAircraftOperationalExpensesApiData({required String startDate, required String endDate, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAircraftOperationalExpenses",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAircraftOperationalExpenses): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getAircraftOperationalExpensesALLTypeApiData({required String startDate, required String endDate}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getAircraftOperationalExpensesALLType",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "startDate": startDate,
            "endDate": endDate,
            "aircraftIdList": "",
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getAircraftOperationalExpensesALLType): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportAser({
    required String startDate,
    required String endDate,
    required String reportType,
    required String customDropdown1,
    required String customDropdown2,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportAser",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": reportType,
            "startDate": startDate,
            "endDate": endDate,
            "custom_Dropdown_1": customDropdown1,
            "custom_Dropdown_2": customDropdown2,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportAser): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportDiscrepanciesCost({required String startDate, required String endDate, required String customDropdown1, required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportDiscrepanciesCost",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": "Discrepancies_Cost",
            "startDate": startDate,
            "endDate": endDate,
            "discrepancyDateType": "CreatedAt",
            "discrepancyStatus": "",
            "aircraftIdList": aircraftIdList,
            "custom_Dropdown_1": customDropdown1,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportDiscrepanciesCost): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportDiscrepancies({
    required String discrepancyDateType,
    required String discrepancyStatus,
    required String startDate,
    required String endDate,
    required String customDropdown1,
    required String aircraftIdList,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/getDefaultReportDiscrepancies",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": "Discrepancies",
            "startDate": startDate,
            "endDate": endDate,
            "discrepancyDateType": discrepancyDateType,
            "discrepancyStatus": discrepancyStatus,
            "aircraftOrAccessoryIdList": aircraftIdList,
            "custom_Dropdown_1": customDropdown1,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/getDefaultReportDiscrepancies): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportHazardPlans() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_HazardPlans",
          data: jsonEncode(<String, String>{"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "reportType": "HazardPlans"}),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_HazardPlans): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportInventoryListingReport({required String startDate, required String endDate, required String baseIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Inventory_Listing_Report",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": "Inventory_Listing_Report",
            "startDate": startDate,
            "endDate": endDate,
            "baseIdList": baseIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Inventory_Listing_Report): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportMaintenanceForecast1015({required String aircraftIdList}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Maintenance_Forecast_10_15",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": "Maintenance_Forecast_10_15",
            "aircraftIdList": aircraftIdList,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Maintenance_Forecast_10_15): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  Future<Response?> getDefaultReportOperationalBudgetExpenditures({required String startDate, required String endDate}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        final Response response = await api.post(
          "/reports/get_DefaultReport_Operational_Budget_Expendatures",
          data: jsonEncode(<String, String>{
            "userId": UserSessionInfo.userId.toString(),
            "systemId": UserSessionInfo.systemId.toString(),
            "reportType": "Operational_Budget_Expendatures",
            "startDate": startDate,
            "endDate": endDate,
          }),
          options: Options(
            headers: <String, dynamic>{"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"},
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        return response;
      } on DioException catch (e) {
        await EasyLoading.dismiss();
        await SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Reports getReportTypeData(/reports/get_DefaultReport_Operational_Budget_Expendatures): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
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

  /// ********************** END TAYEB BLOCK *************
}
