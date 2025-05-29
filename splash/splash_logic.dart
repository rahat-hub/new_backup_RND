import 'dart:io';
import 'dart:ui';

import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/shared/utils/device_type.dart';
import 'package:device_safety_info/device_safety_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../helper/internet_checker_helper/internet_checker_helper_logic.dart';
import '../../helper/snack_bar_helper.dart';
import '../../provider/api_provider.dart';
import '../../provider/flight_operation_and_documents_api_provider.dart';
import '../../shared/constants/constant_colors.dart';
import '../../shared/constants/constant_storages.dart';
import '../../shared/constants/constant_urls.dart';
import '../../shared/services/storage_prefs.dart';
import '../../shared/utils/logged_in_data.dart';

class SplashLogic extends GetxController {
  bool isRootedDevice = false;

  @override
  void onInit() async {
    super.onInit();
    if (!kIsWeb && !Platform.isWindows && !Platform.isMacOS) {
      await checkDeviceRooted();
    }

    if (isRootedDevice) {
      await openDialogBox();
    } else {
      await initialLoginInformationCheck();
    }
  }

  Future<void> checkDeviceRooted() async {
    isRootedDevice = await DeviceSafetyInfo.isRootedDevice;
  }

  Future<void> openDialogBox() {
    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return Padding(
          padding: DeviceType.isTablet ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0) : const EdgeInsets.all(5.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AbsorbPointer(
              absorbing: true,
              child: Dialog(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
                child: Material(
                  color: ColorConstants.primary.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Warning !!! ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ColorConstants.red, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 20),
                        if (Platform.isAndroid)
                          Center(
                            child: Text(
                              "You device seems rooted. So, this device is not supported",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w500),
                            ),
                          ),
                        if (Platform.isIOS)
                          Center(
                            child: Text(
                              "You device seems jail broken. So, this device is not supported",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> initialLoginInformationCheck() async {
    if (!kIsWeb && Platform.isIOS && !InternetCheckerHelperLogic().initialized) await InternetCheckerHelperLogic().onInit(); //Get.find<InternetCheckerHelperLogic>();

    if (InternetCheckerHelperLogic.internetConnected) {
      http.Response currentEndpointResponse = await http
          .get(Uri.parse(UrlConstants.currentApiURL))
          .timeout(const Duration(seconds: 15), onTimeout: () => http.Response("false", 408))
          .catchError((e) {
            if (kDebugMode) print("Error: $e");
            return http.Response("false", 100);
          });

      if (currentEndpointResponse.statusCode != 200) {
        EasyLoading.dismiss();
        Get.offAllNamed(Routes.logIn);
        SnackBarHelper.openSnackBar(isError: true, message: "Server is not responding!\nPlease check your network connection.");
      } else {
        if (await StoragePrefs().ssHasData(key: StorageConstants.token) && StoragePrefs().lsHasData(key: StorageConstants.userInfo)) {
          await tokenValidation();
        } else {
          EasyLoading.dismiss();
          Get.offAllNamed(Routes.logIn);
        }
      }
    } else {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.logIn);
      SnackBarHelper.openSnackBar(isError: true, message: "No Internet Connection!");
    }

    if (kDebugMode) {
      print(UrlConstants.currentApiURL);
    }
  }

  Future<void> tokenValidation() async {
    try {
      var token = await UserSessionInfo.token;

      var response = await ApiProvider().tokenAuthenticate(token: token);

      if (response.statusCode == 200 && response.data["data"]["users"]["system"]["logInSuccess"] == 1) {
        Map responseData = response.data["data"];

        if (await StoragePrefs().ssHasData(key: StorageConstants.key1) && await StoragePrefs().ssHasData(key: StorageConstants.key2)) {
          Map<String, dynamic> userSessionData = responseData["users"]["system"].cast<String, dynamic>();
          userSessionData.remove("id");
          userSessionData.addIf(!userSessionData.containsKey("userId"), "userId", responseData["users"]["id"].toString());
          userSessionData.addIf(!userSessionData.containsKey("roleTitle"), "roleTitle", responseData["users"]["roleTitle"]);
          userSessionData.update("systemId", (value) => value.toString());
          await UserSessionInfo.setSessionData(userSessionData);

          Map<String, dynamic> permissions = responseData["users"]["permission"].cast<String, dynamic>();
          permissions.addAll(responseData["showDutyTime"] ?? {});
          await StoragePrefs().lsWrite(key: StorageConstants.userPermissionData, value: permissions);

          await ApiProvider()
              .getSystemDateTime()
              .then((response) {
                if (response.statusCode == 200) {
                  DateTimeHelper.currentDateTime = response.data["data"]["systemDateTime24Hours"];
                }
              })
              .catchError((e) {
                if (kDebugMode) {
                  print("Error: $e");
                }
              });

          int? flightOpsRequiredFiles;
          await FlightOperationAndDocumentsApiProvider()
              .flightOperationAndDocumentsIndexData(showSnackBar: false)
              .then((response) {
                if (response?.statusCode == 200) {
                  flightOpsRequiredFiles = response?.data["data"]["flightOpsTree"].first["children"]?.length ?? 0;
                }
              })
              .catchError((e) {
                if (kDebugMode) {
                  print("Error: $e");
                }
              });

          EasyLoading.dismiss();
          Get.offAllNamed(Routes.dashBoard, arguments: {"flightOpsRequiredFiles": flightOpsRequiredFiles});
        } else {
          EasyLoading.dismiss();
          Get.offAllNamed(Routes.logIn);
          SnackBarHelper.openSnackBar(isError: true, message: "An error occurred!\nPlease log in again.");
        }
      } else if (response.statusCode == 200 && response.data["data"]["users"]["system"]["logInSuccess"] == 0) {
        EasyLoading.dismiss();
        Get.offAllNamed(Routes.logIn);
        SnackBarHelper.openSnackBar(isError: false, message: "Session Expired!\nPlease log in again.");
        await StoragePrefs().ssDelete(key: StorageConstants.key1);
        await StoragePrefs().ssDelete(key: StorageConstants.key2);
        await StoragePrefs().ssDelete(key: StorageConstants.token);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        Get.offAllNamed(Routes.logIn);
        SnackBarHelper.openSnackBar(isError: false, message: "Session Expired!\nLogged out successfully.");
        await StoragePrefs().ssDelete(key: StorageConstants.key1);
        await StoragePrefs().ssDelete(key: StorageConstants.key2);
        await StoragePrefs().ssDelete(key: StorageConstants.token);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        Get.offAllNamed(Routes.logIn);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while connecting to server...!");
      } else if (response.statusCode == 0) {
        Get.offAllNamed(Routes.logIn);
      } else {
        EasyLoading.dismiss();
        Get.offAllNamed(Routes.logIn);
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.offAllNamed(Routes.logIn);
      SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while connecting to server!");
    }
  }
}
