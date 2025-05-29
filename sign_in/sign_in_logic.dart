import 'dart:async';
import 'dart:io';

import 'package:aviation_rnd/core/custom_lib/lib/encryption/encryption.dart';
import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/api_provider.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:local_auth/local_auth.dart';

import '../../provider/flight_operation_and_documents_api_provider.dart';
import '../../widgets/widgets.dart';

class SignInLogic extends GetxController {
  RxBool isLoadingLoggingIn = false.obs;

  RxBool isDark = ThemeColorMode.isDark.obs;

  RxBool obscureText = true.obs;

  bool supportState = false;
  final LocalAuthentication auth = LocalAuthentication();

  RxBool checkbox = false.obs;
  TextEditingController saveUserName = TextEditingController();

  RxBool isFaceID = false.obs;
  RxBool biometricSignatureEnable = false.obs;

  @override
  void onInit() async {
    super.onInit();
    if (StoragePrefs().lsHasData(key: StorageConstants.rememberUserName)) {
      checkbox.value = await StoragePrefs().lsRead(key: StorageConstants.rememberUserName)["checkBoxStatus"];
      if (checkbox.value) {
        saveUserName.text = await StoragePrefs().lsRead(key: StorageConstants.rememberUserName)["userName"];
      }
    }

    if (await StoragePrefs().ssHasData(key: StorageConstants.biometricSignatureKey1) && await StoragePrefs().ssHasData(key: StorageConstants.biometricSignatureKey2)) {
      biometricSignatureEnable.value = StoragePrefs().lsRead(key: StorageConstants.biometricSignatureEnable) ?? false;
    } else {
      biometricSignatureEnable.value = false;
    }

    if (!kIsWeb) {
      await getBiometricMode();
    }

    await StoragePrefs().lsDelete(key: StorageConstants.viewFormFilterSelectedData);
    await StoragePrefs().lsDelete(key: StorageConstants.riskAssessmentFilterSelectedData);
    await StoragePrefs().lsDelete(key: StorageConstants.workOrderTabSelectedIndexData);
  }

  SwitchWidget themeSwitch() {
    return SwitchWidget(
      initialValue: isDark.value,
      activeText: "DARK",
      inactiveText: "LIGHT",
      onChanged: (value) {
        if (value != null) {
          isDark.value = value;
          ThemeColorMode.setThemeColor(isDark.value ? "dark" : "light");
        }
      },
    );
  }

  Future<void> getBiometricMode() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    if (Platform.isIOS) {
      await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureSupport, value: true);
      if (availableBiometrics.contains(BiometricType.face)) {
        isFaceID.value = true;
        await StoragePrefs().lsWrite(key: StorageConstants.isFaceId, value: true);
      } else {
        isFaceID.value = false;
        await StoragePrefs().lsWrite(key: StorageConstants.isFaceId, value: false);
      }
    } else {
      isFaceID.value = false;
      await StoragePrefs().lsWrite(key: StorageConstants.isFaceId, value: false);
      if (availableBiometrics.contains(BiometricType.strong) || availableBiometrics.contains(BiometricType.fingerprint)) {
        await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureSupport, value: true);
      } else {
        await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureSupport, value: false);
      }
    }
  }

  Future<void> biometricAuth() async {
    try {
      bool authenticated = await auth.authenticate(localizedReason: 'Scan your fingerprint to authenticate', options: const AuthenticationOptions(stickyAuth: true));
      if (authenticated == true) {
        await getToken(
          key1: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.biometricSignatureKey1) ?? ""),
          key2: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.biometricSignatureKey2) ?? ""),
        );
      } else {
        Get.back();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      SnackBarHelper.openSnackBar(isError: true, message: "Biometric data couldn't be verified.\nPlease try again later.");
    }
  }

  Future<void> getToken({required String key1, required String key2}) async {
    try {
      Keyboard.close(); //1
      LoaderHelper.loaderWithGif(); //2
      isLoadingLoggingIn.value = true; //3
      Response tknResponse = await ApiProvider().getToken(key1: key1, key2: key2, grantType: "password"); //4

      if (tknResponse.statusCode == 200) {
        Map tknResponseData = tknResponse.data;

        DateTimeHelper.currentDateTime = tknResponseData["systemDateTime24Hours"] ?? "";

        await UserSessionInfo.setToken(tknResponseData["access_token"]);

        await StoragePrefs().lsWrite(key: StorageConstants.tokenIssuedAt, value: DateTime.now().toString());
        await StoragePrefs().lsWrite(key: StorageConstants.tokenExpiresIn, value: tknResponseData["expires_in"].toString());

        await UserSessionInfo.setUserInfo(tknResponseData.cast<String, dynamic>());

        String? token = await UserSessionInfo.token;

        await tokenAuthenticate(token: token).then((value) async {
          if (value) {
            if (checkbox.value) {
              await StoragePrefs().lsWrite(key: StorageConstants.rememberUserName, value: {"checkBoxStatus": checkbox.value, "userName": key1});
            } else {
              await StoragePrefs().lsWrite(key: StorageConstants.rememberUserName, value: {"checkBoxStatus": checkbox.value, "userName": ''});
            }

            final String encryptedKey1 = await Encryption.encrypt(value: key1);
            final String encryptedKey2 = await Encryption.encrypt(value: key2);

            await StoragePrefs().ssWrite(key: StorageConstants.key1, value: encryptedKey1);
            await StoragePrefs().ssWrite(key: StorageConstants.key2, value: encryptedKey2);

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
            isLoadingLoggingIn.value = false;
            Get.offAllNamed(Routes.dashBoard, arguments: {"flightOpsRequiredFiles": flightOpsRequiredFiles});
            SnackBarHelper.openSnackBar(isComplete: true, message: "Logged in successfully.");
          }
        });
      } else if (tknResponse.statusCode == 400) {
        await StoragePrefs().lsWrite(key: StorageConstants.rememberUserName, value: {"checkBoxStatus": checkbox.value, "userName": ''});
        EasyLoading.dismiss();
        isLoadingLoggingIn.value = false;
        if (tknResponse.data["error"] == "invalid_grant") {
          SnackBarHelper.openSnackBar(isError: true, title: "Invalid Login Attempt", message: "Provided Username or Password is Incorrect!");
        } else {
          SnackBarHelper.openSnackBar(isError: true, message: "Invalid Login Attempt!");
        }
      } else if (tknResponse.statusCode == 0) {
        isLoadingLoggingIn.value = false;
      } else {
        EasyLoading.dismiss();
        isLoadingLoggingIn.value = false;
        SnackBarHelper.openSnackBar(isError: true, message: "Service Unavailable!\nPlease try again later.");
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoadingLoggingIn.value = false;
      SnackBarHelper.openSnackBar(isError: true, message: "Service Unavailable!\nPlease try again.");
    }
  }

  Future<bool> tokenAuthenticate({String? token}) async {
    var result = false;

    var response = await ApiProvider().tokenAuthenticate(token: token);

    if (response.statusCode == 200 && response.data["data"]["users"]["system"]["logInSuccess"] == 1) {
      Map responseData = response.data["data"];

      Map<String, dynamic> userSessionData = responseData["users"]["system"].cast<String, dynamic>();
      userSessionData.remove("id");
      userSessionData.addIf(!userSessionData.containsKey("userId"), "userId", responseData["users"]["id"].toString());
      userSessionData.addIf(!userSessionData.containsKey("roleTitle"), "roleTitle", responseData["users"]["roleTitle"]);
      userSessionData.update("systemId", (value) => value.toString());
      await UserSessionInfo.setSessionData(userSessionData);

      Map<String, dynamic> permissions = responseData["users"]["permission"].cast<String, dynamic>();
      permissions.addAll(responseData["showDutyTime"] ?? {});
      await StoragePrefs().lsWrite(key: StorageConstants.userPermissionData, value: permissions);

      result = true;
      if (userSessionData["bannerMessage"].replaceAll("Logged In  ", "").trim().isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          SnackBarHelper.openSnackBar(
            isWarning: true,
            message: userSessionData["bannerMessage"].replaceAll("Logged In  ", "").trim(),
            durationInSec: (userSessionData["bannerMessage"].trim().split(" ").length / 3).round(),
          );
        });
      }
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Authorization has been denied for this request!");
      isLoadingLoggingIn.value = false;
      result = false;
    } else {
      isLoadingLoggingIn.value = false;
    }
    return result;
  }
}
