import 'dart:convert';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

import '../helper/snack_bar_helper.dart';
import '../shared/constants/constant_urls.dart';
import '../shared/utils/logged_in_data.dart';

class ApiProvider {
  static Dio api = Dio(BaseOptions(baseUrl: UrlConstants.currentApiURL, connectTimeout: const Duration(milliseconds: 20000), receiveTimeout: const Duration(milliseconds: 20000)));

  Future<Response> getToken({required String key1, required String key2, required String grantType}) async {
    Map<String, String> params = {};
    params['username'] = key1;
    params['password'] = key2;
    params['grant_type'] = grantType;

    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post("/token", data: params, options: Options(headers: {"Content-Type": "application/x-www-form-urlencoded"}));

        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("Error on getToken(/token): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data}");
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> tokenAuthenticate({required String? token}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.get("/login/authenticate", options: Options(headers: {"Authorization": "bearer ${token.toString()}"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on tokenAuthenticate(/login/authenticate): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> authorize({required String token}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.get("/login/authorize", options: Options(headers: {"Authorization": "bearer ${token.toString()}"}));
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("Error on authorize(/login/authorize): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}");
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> dawAdminUserChangeDropdownData() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dawAdmin/getChangeToSystemUser",
          data: jsonEncode({"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on get system user change Data(/dawAdmin/getChangeToSystemUser): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> dawAdminSystemUserChangePost({required String selectedSystemUser}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dawAdmin/postChangeToSystemUser",
          data: jsonEncode({"userId": UserSessionInfo.userId.toString(), "systemId": UserSessionInfo.systemId.toString(), "ChangeUserId": selectedSystemUser.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on post system user change Data(/dawAdmin/postChangeToSystemUser): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> postChangeToAnotherService({required String changeSystemId}) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/dawAdmin/postChangeToAnotherService",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString(), "changeSystemId": changeSystemId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("response : ${e.response}");
          print(
            "Error on Help Desk(/dawAdmin/postChangeToAnotherService): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<Response> getSystemDateTime() async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        Response response = await api.post(
          "/user/systemDateTime",
          data: jsonEncode({"systemId": UserSessionInfo.systemId.toString(), "userId": UserSessionInfo.userId.toString()}),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "application/json"}),
        );
        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
            "Error on getSystemDateTime(/user/systemDateTime): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }
}
