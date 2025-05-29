import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:aviation_rnd/core/custom_lib/lib/encryption/encryption.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/provider/api_provider.dart';
import 'package:aviation_rnd/provider/duty_day_time_card_api_provider.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/text_fields.dart';
import 'package:aviation_rnd/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide DeviceOrientation;
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../helper/date_time_helper.dart';
import '../../helper/dialog_helper.dart';
import '../../helper/permission_helper.dart';
import '../../helper/snack_bar_helper.dart';
import '../../routes/app_pages.dart';
import '../../widgets/text_widgets.dart';

class DashboardLogic extends GetxController with GetTickerProviderStateMixin {
  DateTime? currentBackPressTime;

  var isLoading = false.obs;
  var isDark = ThemeColorMode.isDark.obs;

  var isBioEditPermission = false.obs;
  var biometricSignatureEnable = false.obs;

  var itemData = <Map<String, dynamic>>[];

  Timer? tokenTimer;

  var inOutTimeDropdownData = <Map<String, dynamic>>[].obs;
  var selectedInOutTimeDropdown = <String, dynamic>{}.obs;

  var baseDropdownData = <Map<String, dynamic>>[].obs;
  var selectedBaseDropdown = <String, dynamic>{}.obs;

  var changeBaseDropDownData = <Map<String, dynamic>>[].obs;
  var selectedChangeBaseDropdown = <String, dynamic>{}.obs;

  var farPartDropdownData = <Map<String, dynamic>>[].obs;
  var selectedFarPartDropdown = <String, dynamic>{}.obs;

  var dualPilotDropdownData = <Map<String, dynamic>>[].obs;
  var selectedDualPilotDropdown = <String, dynamic>{}.obs;

  Timer? intervalID;

  var baseTime = "".obs;

  late TabController addDutyDayTabController;

  var inTimeOutTimeTabIndex = 0.obs;

  var lastBaseId = 0;
  var lastTsType = 0;
  var useFarPart = 0;

  var inOutTimeTextController = <String, TextEditingController>{};

  var recordTimeStampApiData = {
    "userId": UserSessionInfo.userId.toString(),
    "systemId": UserSessionInfo.systemId.toString(),
    "tsTypeId": "",
    "baseId": "",
    "farPartId": "",
    "dualPilotId": "",
  };

  var errorMassage = "Unknown Error".obs;

  var hiddenErrorMassage = false.obs;

  var hiddenRecordMissedDutyTimeOutButton = false.obs;

  var fieldValidationKey = <String, GlobalKey<FormFieldState>>{};

  var systemDateTime = {"systemDate": "", "systemTime": ""}.obs;

  var dutyTimeInOutShow = false;

  var showKeyboard = false.obs;

  var currentServerTime = ''.obs;
  late Timer timer;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    updateTime(); // Initialize time immediately
    timer = Timer.periodic(const Duration(milliseconds: 1015), (timer) {
      updateTime(); // Update time every second
    });

    getItemData();

    await setUserFeatureAccessPermissions();
    await biometricDevicePermissionChecker();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    tokenTimer = Timer.periodic(
      Duration(
        seconds:
            (int.parse(await StoragePrefs().lsRead(key: StorageConstants.tokenExpiresIn)) - 5) -
            DateTime.now().difference(DateTime.parse(await StoragePrefs().lsRead(key: StorageConstants.tokenIssuedAt))).inSeconds,
      ),
      (timer) async {
        await getToken(
          extendToken: true,
          key1: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.key1) ?? ""),
          key2: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.key2) ?? ""),
        );
      },
    );
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  void updateTime() {
    currentServerTime.value = DateFormat('EEEE MMMM d yyyy HH:mm:ss').format(DateTimeHelper.now);
  }

  void getItemData() {
    itemData.clear();
    itemData = [
      {"id": 1, "name": "Forms", "image": AntDesign.form},
      {"id": 2, "name": "Pilot Log Book", "image": MaterialCommunityIcons.airplane},
      {"id": 3, "name": "Discrepancies", "image": Ionicons.ios_document},
      {"id": 4, "name": "MEL", "image": Icons.widgets},
      {"id": 5, "name": "Parts Request", "image": Icons.request_quote},
      {"id": 7, "name": "Flight Ops & Documents", "image": Icons.library_books},
      {"id": 8, "name": "Flight & Duty Logs", "image": Entypo.time_slot},
      {"id": 9, "name": "Operational Expenses", "image": Icons.monetization_on},
      {"id": 10, "name": "Risk Assessment", "image": MaterialIcons.check_circle},
      {"id": 11, "name": "Help Desk", "image": MaterialCommunityIcons.help_circle},
      if (PermissionHelper.specialPermissionAccess) ...{
        {"id": 6, "name": "Work Orders", "image": Icons.newspaper},
        {"id": 12, "name": "Reports", "image": Icons.insert_chart},
        {"id": 13, "name": "Weight & Balance", "image": MaterialCommunityIcons.scale_balance},
        {"id": 14, "name": "Weather", "image": MaterialCommunityIcons.weather_night_partly_cloudy},
        //{"id": 15, "name": "Flight Profile", "image": Icons.person},
        //{"id": 16, "name": "Add Employee", "image": Icons.person_add},
        {"id": 17, "name": "Weight & Balance Mission Profile", "image": MaterialCommunityIcons.scale_balance},
        {"id": 18, "name": "Device Registration Info", "image": Icons.perm_device_information_sharp},
      },
    ];
  }

  void gotoPage({required int id}) {
    switch (id) {
      case 1:
        Get.toNamed(Routes.formsIndex);
        break;

      case 2:
        Get.toNamed(Routes.pilotLogBookIndex);
        break;

      case 3:
        Get.toNamed(Routes.discrepancyIndex);
        break;

      case 4:
        Get.toNamed(Routes.melIndex);
        break;

      case 5:
        Get.toNamed(Routes.partsRequestIndex);
        break;

      case 6:
        Get.toNamed(Routes.workOrderIndex);
        break;

      case 7:
        Get.toNamed(Routes.flightOpsAndDocuments);
        break;

      case 8:
        Get.toNamed(Routes.flightAndDutyTimeLogs);
        break;

      case 9:
        Get.toNamed(Routes.operationalExpenseIndex);
        break;

      case 10:
        Get.toNamed(Routes.riskAssessmentIndex);
        break;

      case 11:
        /*var reload = Get.toNamed(Routes.helpDeskIndex);

        reload?.then((helpDeskTickets) {
          if (helpDeskTickets != null) {
            itemData[itemData.indexWhere((element) => element["id"] == 11)]["name"] = "Help Desk${userPermissionData["bodyChecks"]["helpDeskTickets"]}";
          }
        });*/
        Get.toNamed(Routes.helpDeskIndex);
        break;

      case 12:
        Get.toNamed(Routes.reportsIndex);
        break;

      case 13:
        Get.toNamed(Routes.weightAndBalance);
        break;

      case 16:
        Get.toNamed(Routes.addEmployee);
        break;

      case 17:
        Get.toNamed(Routes.weightAndBalanceNew);
        break;

      case 18:
        Get.toNamed(Routes.deviceRegInfo);
        break;

      default:
        DialogHelper.openCommonDialogBox();
    }
  }

  Future<void> setUserFeatureAccessPermissions() async {
    if (UserSessionInfo.systemId != 68 &&
        !UserPermission.forms.value &&
        !UserPermission.formAuditor.value &&
        !UserPermission.coSignAcLogs.value &&
        !UserPermission.pilot.value &&
        !UserPermission.pilotAdmin.value &&
        !UserPermission.mechanic.value &&
        !UserPermission.mechanicAdmin.value &&
        !UserPermission.faaViewOnly.value) {
      itemData.removeWhere((element) => element["name"] == "Forms");
    }

    if (!UserPermission.pilot.value &&
        !UserPermission.pilotAdmin.value &&
        !UserPermission.mechanicAdmin.value &&
        !UserPermission.mechanic.value &&
        !UserPermission.discrepanciesWo.value &&
        !UserPermission.coSignAcLogs.value &&
        !UserPermission.faaViewOnly.value &&
        !UserPermission.vendor.value) {
      itemData.removeWhere((element) => element["name"] == "Discrepancies");
      itemData.removeWhere((element) => element["name"] == "MEL");
      itemData.removeWhere((element) => element["name"] == "Parts Request");
    }

    if (UserPermission.vendor.value) {
      itemData.removeWhere((element) => element["name"] == "Pilot Log Book");
      itemData.removeWhere((element) => element["name"] == "Risk Assessment");
      itemData.removeWhere((element) => element["name"] == "Flight & Duty Logs");
      itemData.removeWhere((element) => element["name"] == "Operational Expenses");
      itemData.removeWhere((element) => element["name"] == "Help Desk");
    } else if (!UserPermission.operationalExpenses.value) {
      itemData.removeWhere((element) => element["name"] == "Operational Expenses");
    } else if (UserSessionInfo.systemId == 28) {
      itemData[itemData.indexWhere((element) => element["name"] == "Operational Expenses")]["name"] = "Operational Expenses (AR-13)";
    }

    if (!UserPermission.vendor.value && BodyChecks.helpDeskTickets.value > 0) {
      itemData[itemData.indexWhere((element) => element["name"] == "Help Desk")]["name"] = "Help Desk (${BodyChecks.helpDeskTickets.value})";
    }

    if (UserPermission.vendor.value) {
      itemData.removeWhere((element) => element["name"] == "Flight Ops & Documents");
    } else if (!UserPermission.accessFlightOps.value &&
        !UserPermission.mechanic.value &&
        !UserPermission.eng.value &&
        !UserPermission.engAdmin.value &&
        !UserPermission.pilot.value &&
        !UserPermission.formAuditor.value &&
        !UserPermission.superUser.value &&
        !UserPermission.coSignAcLogs.value &&
        !UserPermission.billing.value &&
        !UserPermission.changeUsers.value &&
        !UserPermission.usersAdmin.value &&
        !UserPermission.reports.value &&
        !UserPermission.mechanicAdmin.value &&
        !UserPermission.discrepanciesWo.value &&
        !UserPermission.forms.value &&
        !UserPermission.inventory.value &&
        !UserPermission.pilotAdmin.value) {
      itemData.removeWhere((element) => element["name"] == "Flight Ops & Documents");
    } else if ((Get.arguments["flightOpsRequiredFiles"] ?? 0) > 0) {
      itemData[itemData.indexWhere((element) => element["name"] == "Flight Ops & Documents")]["name"] = "Flight Ops & Documents (${Get.arguments["flightOpsRequiredFiles"]})";
    }

    if (UserPermission.showDutyTime.value && !UserPermission.vendor.value) {
      dutyTimeInOutShow = true;
    }

    /*if (!UserPermission.weightBalance.value) {
      itemData.removeWhere((element) => element["name"] == "Weight & Balance");
      itemData.removeWhere((element) => element["name"] == "Weight & Balance Mission Profile");
    }*/
  }

  Future<void> biometricDevicePermissionChecker() async {
    if (await StoragePrefs().ssHasData(key: StorageConstants.biometricSignatureKey1) && await StoragePrefs().ssHasData(key: StorageConstants.biometricSignatureKey2)) {
      if (await StoragePrefs().ssRead(key: StorageConstants.biometricSignatureKey1) == await Encryption.encrypt(value: UserSessionInfo.userLoginId)) {
        await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEditPermission, value: true);
      } else {
        await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEditPermission, value: false);
      }
    } else {
      await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEnable, value: false);
      await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEditPermission, value: true);
    }

    isBioEditPermission.value = StoragePrefs().lsRead(key: StorageConstants.biometricSignatureEditPermission) ?? false;
    biometricSignatureEnable.value = StoragePrefs().lsRead(key: StorageConstants.biometricSignatureEnable) ?? false;

    isLoading.value = false;
    await EasyLoading.dismiss();

    if (StoragePrefs().lsRead(key: StorageConstants.biometricPermissionFlag) != "1") {
      if (Platform.isAndroid) {
        if (StoragePrefs().lsRead(key: StorageConstants.biometricSignatureSupport) == true) {
          await biometricSignaturePermissionDialog();
        }
        if (!await Permission.manageExternalStorage.isGranted) {
          await deviceFileAccessPermissionDialog();
        }
      } else {
        await biometricSignaturePermissionDialog();
      }
    }
  }

  Future<void> biometricSignaturePermissionDialog() {
    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Dialog(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: ColorConstants.primary, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enable Biometric Signature", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                      const SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Enable Biometric Signature for Quick Login !!!", textAlign: TextAlign.start, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                      const SizedBox(height: SizeConstants.rootContainerSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonConstant.dialogButton(
                            title: "Not Now",
                            borderColor: ColorConstants.red,
                            onTapMethod: () async {
                              Get.back(closeOverlays: true);

                              await StoragePrefs().lsWrite(key: StorageConstants.biometricPermissionFlag, value: "1");
                              await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEnable, value: false);
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing),
                          ButtonConstant.dialogButton(
                            title: "Enable",
                            onTapMethod: () async {
                              Get.back(closeOverlays: true);

                              await StoragePrefs().ssWrite(key: StorageConstants.biometricSignatureKey1, value: await StoragePrefs().ssRead(key: StorageConstants.key1));
                              await StoragePrefs().ssWrite(key: StorageConstants.biometricSignatureKey2, value: await StoragePrefs().ssRead(key: StorageConstants.key2));

                              await StoragePrefs().lsWrite(key: StorageConstants.biometricPermissionFlag, value: "1");

                              biometricSignatureEnable.value = true;
                              await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEnable, value: true);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deviceFileAccessPermissionDialog() {
    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Dialog(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: ColorConstants.primary, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enable File Access Permission", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                      const SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "Grant DAW with the file access permission to open , edit and save files.",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SizeConstants.rootContainerSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonConstant.dialogButton(
                            title: "Not Now",
                            borderColor: ColorConstants.red,
                            onTapMethod: () async {
                              Get.back(closeOverlays: true);

                              await StoragePrefs().lsWrite(key: StorageConstants.biometricPermissionFlag, value: "1");
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing),
                          ButtonConstant.dialogButton(
                            title: "Grant",
                            onTapMethod: () async {
                              Get.back(closeOverlays: true);

                              if (defaultTargetPlatform == TargetPlatform.android) {
                                await Permission.manageExternalStorage.request();

                                await StoragePrefs().lsWrite(key: StorageConstants.biometricPermissionFlag, value: "1");
                              } else {
                                SnackBarHelper.openSnackBar(isError: true, message: "This feature is not available in iOS Devices!");

                                await StoragePrefs().lsWrite(key: StorageConstants.biometricPermissionFlag, value: "1");
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> getToken({required String key1, required String key2, bool extendToken = false}) async {
    bool isSystemChanged = false;
    Response tknResponse = await ApiProvider().getToken(key1: key1, key2: key2, grantType: "password");

    if (tknResponse.statusCode == 200) {
      Map tknResponseData = tknResponse.data;

      DateTimeHelper.currentDateTime = tknResponseData["systemDateTime24Hours"] ?? "";

      if (tknResponseData["systemId"].toString().trim() != UserSessionInfo.systemId.toString()) {
        isSystemChanged = true;
      }

      await UserSessionInfo.setToken(tknResponseData["access_token"]);

      await StoragePrefs().lsWrite(key: StorageConstants.tokenIssuedAt, value: DateTime.now().toString());
      await StoragePrefs().lsWrite(key: StorageConstants.tokenExpiresIn, value: tknResponseData["expires_in"].toString());

      await UserSessionInfo.setUserInfo(tknResponseData.cast<String, dynamic>());

      String? token = await UserSessionInfo.token;

      if (isSystemChanged) {
        var authResponse = await ApiProvider().tokenAuthenticate(token: token);

        if (authResponse.statusCode == 200 && authResponse.data["data"]["users"]["system"]["logInSuccess"] == 1) {
          Map authResponseData = authResponse.data["data"];

          await StoragePrefs().lsDelete(key: StorageConstants.viewFormFilterSelectedData);
          await StoragePrefs().lsDelete(key: StorageConstants.riskAssessmentFilterSelectedData);
          await StoragePrefs().lsDelete(key: StorageConstants.workOrderTabSelectedIndexData);

          Map<String, dynamic> userSessionData = authResponseData["users"]["system"].cast<String, dynamic>();
          userSessionData.remove("id");
          userSessionData.addIf(!userSessionData.containsKey("userId"), "userId", authResponseData["users"]["id"].toString());
          userSessionData.addIf(!userSessionData.containsKey("roleTitle"), "roleTitle", authResponseData["users"]["roleTitle"]);
          userSessionData.update("systemId", (value) => value.toString());
          await UserSessionInfo.setSessionData(userSessionData);

          Map<String, dynamic> permissions = authResponseData["users"]["permission"].cast<String, dynamic>();
          permissions.addAll(authResponseData["showDutyTime"] ?? {});
          await StoragePrefs().lsWrite(key: StorageConstants.userPermissionData, value: permissions);

          EasyLoading.dismiss();
          Get.offAllNamed(Routes.splash);
          SnackBarHelper.openSnackBar(isError: false, message: "System Changed!\nSuccessfully Logged In into New Web System.");
        } else if (authResponse.statusCode == 401) {
          EasyLoading.dismiss();
          Get.offAllNamed(Routes.logIn);
          SnackBarHelper.openSnackBar(
            isError: true,
            message: "An error occurred while ${extendToken ? "extending" : "changing"} your ${extendToken ? "session" : "system"}!\nTry to Log In Again.",
          );
        }
      } else if (extendToken) {
        EasyLoading.dismiss();
        tokenTimer?.cancel();
        onReady();
        SnackBarHelper.openSnackBar(isError: false, message: "Current Session Extended Successfully.");
      }
    } else if (tknResponse.statusCode == 0) {
      EasyLoading.dismiss();
      if (extendToken) {
        Get.offAllNamed(Routes.logIn);
      }
    } else {
      EasyLoading.dismiss();
      if (extendToken) {
        Get.offAllNamed(Routes.logIn);
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while extending your session.\nLog In Again or Contact Digital AirWare.");
      } else {
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while changing your system!\nTry again later.");
      }
    }
    return isSystemChanged;
  }

  Future<void> logout() async {
    await StoragePrefs().ssDelete(key: StorageConstants.key1);
    await StoragePrefs().ssDelete(key: StorageConstants.key2);
    await StoragePrefs().ssDelete(key: StorageConstants.token);
    await StoragePrefs().lsDelete(key: StorageConstants.tokenIssuedAt);
    await StoragePrefs().lsDelete(key: StorageConstants.userSessionData);
    await StoragePrefs().lsDelete(key: StorageConstants.viewFormFilterSelectedData);
    await StoragePrefs().lsDelete(key: StorageConstants.riskAssessmentFilterSelectedData);
    await StoragePrefs().lsDelete(key: StorageConstants.workOrderTabSelectedIndexData);
    tokenTimer?.cancel();
    await EasyLoading.dismiss();
    await SnackBarHelper.openSnackBar(isError: false, message: "Logged out successfully.");
    Get.offAllNamed(Routes.logIn);
  }

  bool onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      SnackBarHelper.openSnackBar(isError: true, message: "Double tap to close app");
      return false;
    }
    //await controller.closeLogout();
    return true;
  }

  Widget themeSwitch() {
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

  Widget menuItemWidget({required int crossAxisItemCount}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisItemCount, childAspectRatio: 1.1, mainAxisSpacing: 12.0, crossAxisSpacing: 12.0),
      itemCount: itemData.length,
      itemBuilder:
          (context, index) => Material(
            elevation: 5,
            shadowColor: ColorConstants.yellow.withValues(alpha: 0.4),
            color: isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius),
              side: BorderSide(width: 3.5, color: isDark.value != true ? ColorConstants.primary : ColorConstants.black),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius),
              onTap: () {
                gotoPage(id: itemData[index]["id"]);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 2.5),
                    child: Icon(itemData[index]["image"] as IconData, size: 40, color: isDark.value != true ? ColorConstants.primary : ColorConstants.black),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.5, bottom: 15.0),
                      child: Obx(() {
                        return TextWidget(
                          text: itemData[index]["name"].toString(),
                          textAlign: TextAlign.center,
                          color: isDark.value != true ? ColorConstants.primary : ColorConstants.black,
                          size: Theme.of(context).textTheme.displaySmall!.fontSize! - 2,
                          weight: FontWeight.w600,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  ///======== For DUTY TIME IN / OUT Function & View

  Future<void> initDutyTime({required int lastBaseId}) async {
    // api Call value
    if (lastBaseId.isNaN) {
      lastBaseId = 0;
    }

    await getBaseTime(baseId: lastBaseId);
  }

  Future<void> getBaseTime({required int baseId}) async {
    int dOffset = 0;
    //ApiCall

    Map data = {}.obs;

    Response response = await DutyDayTimeCardApiProvider().dutyTimeGetBesTimeApiCall(baseId: baseId.toString());
    if (response.statusCode == 200) {
      data.addAll(response.data["data"]["currentTimeAtBase"]);
    }

    var res = data["currTime"]!.split(":");

    var d = DateTimeHelper.now;
    d = d.copyWith(hour: int.parse(res[0]), minute: int.parse(res[1]), second: int.parse(res[2]), millisecond: 0); //set to server time
    var dLoaded = DateTimeHelper.now;
    dOffset = d.difference(dLoaded).inMilliseconds;

    initDt(dOffset: dOffset);
  }

  void initDt({required int dOffset}) {
    intervalID = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      DateTime dNow = DateTimeHelper.now;
      dNow = dNow.copyWith(second: dNow.second + dOffset ~/ 1000);
      int h = dNow.hour;
      int m = dNow.minute;
      int s = dNow.second;
      baseTime.value = "${h < 10 ? "0" : ""}$h:${m < 10 ? "0" : ""}$m:${s < 10 ? "0" : ""}$s";
    });
  }

  Future<void> dutyTimeInOutApiCall() async {
    Response response = await DutyDayTimeCardApiProvider().dutyTimeInOutFirstDataApiCall();

    if (response.statusCode == 200) {
      lastBaseId = response.data["data"]["dutyTime"]["lastBaseId"];
      lastTsType = response.data["data"]["dutyTime"]["lastTsType"];
      useFarPart = response.data["data"]["dutyTime"]["useFarPart"];

      baseDropdownData.clear();
      selectedBaseDropdown.clear();

      inOutTimeDropdownData.clear();
      selectedInOutTimeDropdown.clear();

      farPartDropdownData.clear();
      selectedFarPartDropdown.clear();

      dualPilotDropdownData.clear();
      selectedDualPilotDropdown.clear();

      inOutTimeDropdownData.addAll(response.data["data"]["timeInOutList"].cast<Map<String, dynamic>>());
      dropDownDataSetFunction(dropDownData: inOutTimeDropdownData, selectedDropdownValue: selectedInOutTimeDropdown);

      baseDropdownData.addAll(response.data["data"]["baseList"].cast<Map<String, dynamic>>());
      baseDropdownData.first = {"id": "0", "name": "-- Select Base --", "selected": false};
      baseDropdownData.singleWhere((element) => element["id"] == lastBaseId.toString())["selected"] = true;
      dropDownDataSetFunction(dropDownData: baseDropdownData, selectedDropdownValue: selectedBaseDropdown);

      farPartDropdownData.addAll(response.data["data"]["farPartList"].cast<Map<String, dynamic>>());
      dropDownDataSetFunction(dropDownData: farPartDropdownData, selectedDropdownValue: selectedFarPartDropdown);

      dualPilotDropdownData.addAll(response.data["data"]["dualPilotList"].cast<Map<String, dynamic>>());
      dualPilotDropdownData.sort((a, b) => a["id"].compareTo(b["id"]));
      dropDownDataSetFunction(dropDownData: dualPilotDropdownData, selectedDropdownValue: selectedDualPilotDropdown);

      recordTimeStampApiData["tsTypeId"] = selectedInOutTimeDropdown["id"].toString();
      recordTimeStampApiData["baseId"] = selectedBaseDropdown["id"].toString();
      recordTimeStampApiData["farPartId"] = selectedFarPartDropdown["id"].toString();
      recordTimeStampApiData["dualPilotId"] = selectedDualPilotDropdown["id"].toString();

      changeBaseDropDownData.clear();
      selectedChangeBaseDropdown.clear();

      if (lastTsType == 1) {
        for (int i = 0; i < baseDropdownData.length; i++) {
          if (baseDropdownData[i]["id"] != lastBaseId.toString()) {
            changeBaseDropDownData.add(baseDropdownData[i]);
          }
        }
        selectedChangeBaseDropdown.addAll(changeBaseDropDownData[0]);
      }
    }
  }

  void dropDownDataSetFunction({required List dropDownData, required Map selectedDropdownValue}) {
    for (int i = 0; i < dropDownData.length; i++) {
      if (dropDownData[i]["selected"]) {
        return selectedDropdownValue.addAll(dropDownData[i]);
      }
    }
    return selectedDropdownValue.addAll(dropDownData[0]);
  }

  Widget dutyTimeInOutButtonView() {
    return MaterialButton(
      onPressed: () async {
        LoaderHelper.loaderWithGif();
        if (intervalID?.isActive ?? false) {
          intervalID?.cancel();
        }
        await dutyTimeInOutApiCall();
        await initDutyTime(lastBaseId: lastBaseId);
        await EasyLoading.dismiss();
        await inOutTimeDialogView();
      },
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: ColorConstants.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: ColorConstants.primary)),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            MaterialCommunityIcons.book_multiple,
            color: ThemeColorMode.isDark ? ColorConstants.black : ColorConstants.white,
            size: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! + 3,
          ),
          const SizedBox(width: 3.0),
          TextWidget(
            text: "Duty Time In / Out",
            color: ThemeColorMode.isDark ? ColorConstants.black : ColorConstants.white,
            weight: FontWeight.w700,
            size: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
          ),
        ],
      ),
    );
  }

  Future<void> inOutTimeDialogView() {
    addDutyDayTabController = TabController(length: lastTsType == 1 ? 2 : 1, vsync: this);

    addDutyDayTabController.addListener(() => inTimeOutTimeTabIndex.value = addDutyDayTabController.index);

    inTimeOutTimeTabIndex.value = 0;
    hiddenErrorMassage.value = false;
    hiddenRecordMissedDutyTimeOutButton.value = false;

    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            insetPadding:
                DeviceType.isMobile
                    ? const EdgeInsets.symmetric(horizontal: 5.0)
                    : DeviceOrientation.isLandscape
                    ? EdgeInsets.symmetric(horizontal: Get.width / 6.5)
                    : const EdgeInsets.symmetric(horizontal: 100.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
            title: Row(
              children: [
                Icon(Icons.watch_later, size: 30.0, color: isDark.value != true ? ColorConstants.black : ColorConstants.background),
                Expanded(
                  child: Text(
                    "\tDuty Time Menu\t",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: DeviceType.isMobile ? Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! : Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 3,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Obx(() {
                  return inTimeOutTimeTabIndex.value == 0 ? baseTimeViewReturn() : const SizedBox();
                }),
              ],
            ),
            content: GestureDetector(
              onTap: () => Keyboard.close(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(25),
                    color: ColorConstants.primary.withValues(alpha: 0.3),
                    child: TabBar(
                      splashBorderRadius: BorderRadius.circular(25),
                      isScrollable: true,
                      indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), color: ColorConstants.grey.withValues(alpha: 0.5)),
                      labelColor: ColorConstants.white,
                      unselectedLabelColor: ColorConstants.grey,
                      controller: addDutyDayTabController,
                      tabs: [
                        addDutyDayTabNameIconReturn(tabName: "\tDuty Time", tabIconName: Icons.input, colorName: ColorConstants.button),
                        if (lastTsType == 1) addDutyDayTabNameIconReturn(tabName: "\tChange Base", tabIconName: Icons.location_on_outlined, colorName: ColorConstants.primary),
                      ],
                      labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: SizeConstants.contentSpacing - 5),
                  Obx(() {
                    return Flexible(
                      child: IndexedStack(
                        index: inTimeOutTimeTabIndex.value,
                        children: [
                          Padding(padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0), child: dutyTimeWidgets()),
                          if (lastTsType == 1) Padding(padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0), child: changeBaseWidgets()),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              Obx(() {
                return inTimeOutTimeTabIndex.value == 0
                    ? ButtonConstant.dialogButton(
                      title: "Record Time Stamp",
                      textColor: ColorConstants.background,
                      iconColor: ColorConstants.background,
                      enableIcon: true,
                      btnColor: ColorConstants.button,
                      iconData: Icons.watch_later,
                      borderColor: ColorConstants.black,
                      onTapMethod: () async {
                        if (selectedInOutTimeDropdown["id"] == "0") {
                          await dutyTimeRecordTimeStampApiCall();
                        } else {
                          bool validated = true;
                          String invalidKey = "";
                          fieldValidationKey.forEach((key, value) {
                            value.currentState?.save();
                            if (!key.contains("change") && value.currentState?.validate() == false) {
                              invalidKey = key;
                              validated = false;
                            }
                          });
                          if (validated) {
                            await dutyTimeRecordTimeStampApiCall();
                          } else {
                            SnackBarHelper.openSnackBar(isError: true, message: "$invalidKey is required!!!");
                          }
                        }
                      },
                    )
                    : ButtonConstant.dialogButton(
                      title: "Change Base",
                      textColor: ColorConstants.background,
                      iconColor: ColorConstants.background,
                      enableIcon: true,
                      btnColor: ColorConstants.button,
                      iconData: Icons.watch_later,
                      borderColor: ColorConstants.black,
                      onTapMethod: () async {
                        bool validated = true;
                        fieldValidationKey.forEach((key, value) {
                          value.currentState?.save();
                          if (key.contains("change") && value.currentState?.validate() == false) {
                            validated = false;
                          }
                        });
                        if (validated) {
                          LoaderHelper.loaderWithGif();
                          Response response = await DutyDayTimeCardApiProvider().dutyTimeChangeBaseApiCall(
                            baseId: selectedChangeBaseDropdown["id"].toString(),
                            farPartId: selectedFarPartDropdown["id"].toString(),
                            dualPilotId: selectedDualPilotDropdown["id"].toString(),
                          );

                          if (response.statusCode == 200) {
                            if (intervalID?.isActive ?? false) {
                              intervalID?.cancel();
                            }

                            EasyLoading.dismiss();

                            Get.back();
                          } else {
                            SnackBarHelper.openSnackBar(isError: true, message: "$Key is required!!!");
                          }
                        }
                      },
                    );
              }),
              ButtonConstant.dialogButton(
                title: "Cancel",
                textColor: ColorConstants.background,
                iconColor: Colors.white,
                enableIcon: true,
                btnColor: ColorConstants.red,
                iconData: Icons.clear,
                borderColor: ColorConstants.red,
                onTapMethod: () async {
                  if (intervalID?.isActive ?? false) {
                    intervalID?.cancel();
                  }
                  hiddenErrorMassage.value = false;
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget baseTimeViewReturn() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: isDark.value ? ColorConstants.button : ColorConstants.black)),
      color: isDark.value ? ColorConstants.black.withValues(alpha: 0.8) : ColorConstants.grey.withValues(alpha: 0.4),
      child: Obx(() {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
          child: SizedBox(
            width: DeviceType.isMobile ? 90.0 : 120.0,
            child: Center(
              child: Text(
                baseTime.value,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: DeviceType.isMobile ? Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! : Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 3,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget addDutyDayTabNameIconReturn({required IconData? tabIconName, required String? tabName, required Color? colorName}) {
    return Tab(child: Row(children: [Icon(tabIconName, color: colorName), Text(tabName!, style: TextStyle(color: colorName))]));
  }

  Widget dutyTimeWidgets() {
    return SingleChildScrollView(
      child: Column(
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Obx(() {
            return hiddenErrorMassage.value
                ? RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(Get.context!).style,
                    children: <TextSpan>[
                      const TextSpan(text: "There Was A Problem Submitting Your Time Stamp:\t", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.red)),
                      TextSpan(text: errorMassage.value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                )
                : const SizedBox();
          }),
          Obx(() {
            return hiddenRecordMissedDutyTimeOutButton.value
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ButtonConstant.dialogButton(
                        title: "Record Missed Duty Time Out",
                        textColor: ColorConstants.background,
                        iconColor: ColorConstants.background,
                        enableIcon: true,
                        btnColor: ColorConstants.button,
                        iconData: Icons.watch_later,
                        borderColor: ColorConstants.black,
                        onTapMethod: () async {
                          await LoaderHelper.loaderWithGif();
                          await recordMissedTimeStampOutViewReturn();
                        },
                      ),
                    ),
                  ],
                )
                : const SizedBox();
          }),
          WidgetConstant.customDropDownWidgetNew(
            context: Get.context!,
            contentPaddingEnable: true,
            topPadding: 4.0,
            bottomPadding: 4.0,
            dropDownData: inOutTimeDropdownData,
            dropDownKey: "name",
            title: "Time In / Out",
            hintText: selectedInOutTimeDropdown.isNotEmpty ? selectedInOutTimeDropdown["name"] : inOutTimeDropdownData[0]["name"],
            onChanged: (value) {
              selectedInOutTimeDropdown.addAll(value);
              recordTimeStampApiData["tsTypeId"] = selectedInOutTimeDropdown["id"];

              hiddenErrorMassage.value = false;
              hiddenRecordMissedDutyTimeOutButton.value = false;
            },
          ),
          Obx(() {
            return selectedInOutTimeDropdown["id"] == "1"
                ? Column(
                  spacing: SizeConstants.contentSpacing - 5,
                  children: [
                    WidgetConstant.customDropDownWidgetNew(
                      validationKey: fieldValidationKey.putIfAbsent("duty_time_base", () => GlobalKey<FormFieldState>()),
                      context: Get.context!,
                      needValidation: selectedBaseDropdown["id"] == "0",
                      contentPaddingEnable: true,
                      topPadding: 4.0,
                      bottomPadding: 4.0,
                      dropDownData: baseDropdownData,
                      dropDownKey: "name",
                      title: "Base",
                      hintText: selectedBaseDropdown.isNotEmpty ? selectedBaseDropdown["name"] : baseDropdownData[0]["name"],
                      onChanged: (value) async {
                        selectedBaseDropdown.addAll(value);
                        recordTimeStampApiData["baseId"] = selectedBaseDropdown["id"];

                        if (selectedBaseDropdown["id"] == "0") {
                        } else {
                          LoaderHelper.loaderWithGif();
                          if (intervalID?.isActive ?? false) {
                            intervalID?.cancel();
                          }
                          await getBaseTime(baseId: int.parse(selectedBaseDropdown["id"].toString()));
                          EasyLoading.dismiss();
                        }
                      },
                    ),
                    if (useFarPart == 1) ...{
                      WidgetConstant.customDropDownWidgetNew(
                        context: Get.context!,
                        validationKey: fieldValidationKey.putIfAbsent("duty_time_far_part", () => GlobalKey<FormFieldState>()),
                        contentPaddingEnable: true,
                        needValidation: selectedFarPartDropdown["id"] == "-1",
                        topPadding: 4.0,
                        bottomPadding: 4.0,
                        dropDownData: farPartDropdownData,
                        dropDownKey: "name",
                        title: "FAR Part",
                        hintText: selectedFarPartDropdown.isNotEmpty ? selectedFarPartDropdown["name"] : farPartDropdownData[0]["name"],
                        onChanged: (value) {
                          selectedFarPartDropdown.addAll(value);
                          recordTimeStampApiData["farPartId"] = selectedFarPartDropdown["id"];
                        },
                      ),
                      WidgetConstant.customDropDownWidgetNew(
                        context: Get.context!,
                        validationKey: fieldValidationKey.putIfAbsent("duty_time_dual_pilot", () => GlobalKey<FormFieldState>()),
                        contentPaddingEnable: true,
                        needValidation: selectedDualPilotDropdown["id"] == "-1",
                        topPadding: 4.0,
                        bottomPadding: 4.0,
                        dropDownData: dualPilotDropdownData,
                        dropDownKey: "name",
                        title: "Dual Pilot",
                        hintText: selectedDualPilotDropdown.isNotEmpty ? selectedDualPilotDropdown["name"] : dualPilotDropdownData[0]["name"],
                        onChanged: (value) {
                          selectedDualPilotDropdown.addAll(value);
                          recordTimeStampApiData["dualPilotId"] = selectedDualPilotDropdown["id"];
                        },
                      ),
                    },
                  ],
                )
                : const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget changeBaseWidgets() {
    return SingleChildScrollView(
      child: Column(
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          WidgetConstant.customDropDownWidgetNew(
            validationKey: fieldValidationKey.putIfAbsent("duty_time_change_base", () => GlobalKey<FormFieldState>()),
            needValidation: selectedChangeBaseDropdown["id"] == "0",
            context: Get.context!,
            contentPaddingEnable: true,
            topPadding: 4.0,
            bottomPadding: 4.0,
            dropDownData: changeBaseDropDownData,
            dropDownKey: "name",
            title: "Base",
            hintText: selectedChangeBaseDropdown.isNotEmpty ? selectedChangeBaseDropdown["name"] : changeBaseDropDownData[0]["name"],
            onChanged: (value) {
              selectedChangeBaseDropdown.addAll(value);
            },
          ),
          if (useFarPart == 1) ...{
            WidgetConstant.customDropDownWidgetNew(
              validationKey: fieldValidationKey.putIfAbsent("duty_time_change_far_time", () => GlobalKey<FormFieldState>()),
              needValidation: selectedFarPartDropdown["id"] == "-1",
              context: Get.context!,
              contentPaddingEnable: true,
              topPadding: 4.0,
              bottomPadding: 4.0,
              dropDownData: farPartDropdownData,
              dropDownKey: "name",
              title: "FAR Part",
              hintText: selectedFarPartDropdown.isNotEmpty ? selectedFarPartDropdown["name"] : farPartDropdownData[0]["name"],
              onChanged: (value) {
                selectedFarPartDropdown.addAll(value);
              },
            ),
            WidgetConstant.customDropDownWidgetNew(
              validationKey: fieldValidationKey.putIfAbsent("duty_time_change_dual_pilot", () => GlobalKey<FormFieldState>()),
              needValidation: selectedDualPilotDropdown["id"] == "-1",
              context: Get.context!,
              contentPaddingEnable: true,
              topPadding: 4.0,
              bottomPadding: 4.0,
              dropDownData: dualPilotDropdownData,
              dropDownKey: "name",
              title: "Dual Pilot",
              hintText: selectedDualPilotDropdown.isNotEmpty ? selectedDualPilotDropdown["name"] : dualPilotDropdownData[0]["name"],
              onChanged: (value) {
                selectedDualPilotDropdown.addAll(value);
              },
            ),
          },
        ],
      ),
    );
  }

  Future<void> dutyTimeRecordTimeStampApiCall({bool missTime = false}) async {
    LoaderHelper.loaderWithGif();
    Response response = await DutyDayTimeCardApiProvider().dutyTimeRecordTimeStampApiCall(recordTimeStampData: recordTimeStampApiData);
    if (response.statusCode == 200) {
      switch (response.data["data"]["addTimeStamps"]["errorCode"]) {
        case 0:
          {
            EasyLoading.dismiss();
            Get.back();

            if (missTime) {
              Get.back();
            }
            hiddenErrorMassage.value = false;
            SnackBarHelper.openSnackBar(
              isError: false,
              message: "Time Stamp IN Recorded At ${response.data["data"]["addTimeStamps"]["currTime"]} (Id: ${response.data["data"]["addTimeStamps"]["timeStampId"]})",
            );
          }
        case 1:
          {
            errorMassage.value = "No Base Selected";
            EasyLoading.dismiss();
            SnackBarHelper.openSnackBar(isError: true, message: errorMassage.value);
          }
        case 2:
          {
            errorMassage.value = "You are currently Duty Timed In from your last shift.\nWould you like to record a duty time out?";
            systemDateTime["systemDate"] = response.data["data"]["addTimeStamps"]["currTime"].split(' ').first;
            systemDateTime["systemTime"] = response.data["data"]["addTimeStamps"]["currTime"].split(' ').last;
            hiddenErrorMassage.value = true;
            hiddenRecordMissedDutyTimeOutButton.value = true;
            EasyLoading.dismiss();
          }
        case 3:
          {
            errorMassage.value = "You are not currently clocked In";
            hiddenErrorMassage.value = true;
            EasyLoading.dismiss();
          }
      }
    }
  }

  Future<void> recordMissedTimeStampOutViewReturn() async {
    showKeyboard.value = false;

    Response systemDateTimeApiData = await DutyDayTimeCardApiProvider().dutyTimeGetMissedTimeStampOutApiCall();

    await EasyLoading.dismiss();

    if (systemDateTimeApiData.statusCode == 200) {
      Map systemTimeApiData = {"systemDate": "", "systemTime": ""};

      systemTimeApiData["systemDate"] = systemDateTimeApiData.data["data"]["dateNow"];
      systemTimeApiData["systemTime"] = systemDateTimeApiData.data["data"]["timeNow"];

      inOutTimeTextController.update(
        "missed_time_stamp_date",
        (value) => value..text = systemTimeApiData["systemDate"],
        ifAbsent: () => TextEditingController(text: systemTimeApiData["systemDate"]),
      );
      inOutTimeTextController.update(
        "missed_time_stamp_out_time",
        (value) => value..text = systemTimeApiData["systemTime"],
        ifAbsent: () => TextEditingController(text: systemTimeApiData["systemTime"]),
      );

      return showDialog<void>(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
              insetPadding:
                  DeviceType.isMobile
                      ? const EdgeInsets.symmetric(horizontal: 5.0)
                      : DeviceOrientation.isLandscape
                      ? EdgeInsets.symmetric(horizontal: Get.width / 6.5)
                      : const EdgeInsets.symmetric(horizontal: 100.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.watch_later, size: 30.0, color: isDark.value != true ? ColorConstants.black : ColorConstants.background),
                  Expanded(
                    child: Text(
                      "\tRecord Missed Time Stamp Out\t",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: DeviceType.isMobile ? Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! : Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 3,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              content: GestureDetector(
                onTap: () {
                  Keyboard.close();
                  showKeyboard.value = false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: SizeConstants.contentSpacing + 5),
                      const Text("Date"),
                      FormBuilderField(
                        name: "missed_time_stamp_date",
                        builder: (FormFieldState<dynamic> field) {
                          return Center(
                            child: Obx(() {
                              return TextFieldConstant.dynamicTextField(
                                field: field,
                                controller: inOutTimeTextController.putIfAbsent("missed_time_stamp_date", () => TextEditingController()),
                                readOnly: !showKeyboard.value,
                                showCursor: showKeyboard.value,
                                hasIcon: false,
                                isDense: true,
                                hintText: "mm/dd/yyyy",
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?/?(\d{1,2})?/?(\d{1,4})?'))],
                                onTap: () {
                                  if (!showKeyboard.value) {
                                    DatePicker.showDatePicker(
                                      context,
                                      minDateTime: DateFormat(
                                        "MM/dd/yyyy",
                                      ).parse(systemDateTime["systemDate"] ?? DateTimeHelper.serverDateTime.split(" ").first).subtract(const Duration(days: 30)),
                                      maxDateTime: DateFormat(
                                        "MM/dd/yyyy",
                                      ).parse(systemDateTime["systemDate"] ?? DateTimeHelper.serverDateTime.split(" ").first).add(const Duration(days: 1)),
                                      onConfirm: (date, list) {
                                        field.didChange(date);
                                        inOutTimeTextController["missed_time_stamp_date"]!.text = DateFormat("MM/dd/yyyy").format(date).toString();
                                      },
                                      onCancel: () => showKeyboard.value = true,
                                      initialDateTime: DateFormat("MM/dd/yyyy").parse(systemDateTime["systemDate"] ?? DateTimeHelper.serverDateTime.split(" ").first),
                                      locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                    );
                                  }
                                },
                                onEditingComplete: () => showKeyboard.value = false,
                              );
                            }),
                          );
                        },
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing + 5),
                      const Text("Time"),
                      FormBuilderField(
                        name: "missed_time_stamp_out_time",
                        builder: (FormFieldState<dynamic> field) {
                          return Center(
                            child: Obx(() {
                              return TextFieldConstant.dynamicTextField(
                                field: field,
                                controller: inOutTimeTextController.putIfAbsent("missed_time_stamp_out_time", () => TextEditingController()),
                                readOnly: !showKeyboard.value,
                                showCursor: showKeyboard.value,
                                hasIcon: false,
                                isDense: true,
                                hintText: "HH:mm",
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?:?(\d{1,2})?'))],
                                onTap: () {
                                  if (!showKeyboard.value) {
                                    DatePicker.showDatePicker(
                                      context,
                                      dateFormat: "HH:mm",
                                      pickerMode: DateTimePickerMode.time,
                                      onConfirm: (time, list) {
                                        field.didChange(time);
                                        inOutTimeTextController["missed_time_stamp_out_time"]!.text = DateFormat("HH:mm").format(time).toString();
                                      },
                                      onCancel: () => showKeyboard.value = true,
                                      initialDateTime: DateFormat("HH:mm").parse(systemDateTime["systemTime"] ?? DateTimeHelper.serverDateTime.split(" ").last.substring(0, 5)),
                                      locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                    );
                                  }
                                },
                                onEditingComplete: () => showKeyboard.value = false,
                              );
                            }),
                          );
                        },
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing - 5),
                    ],
                  ),
                ),
              ),
              actions: [
                ButtonConstant.dialogButton(
                  title: "Record Missed Time Stamp",
                  textColor: ColorConstants.background,
                  iconColor: ColorConstants.background,
                  enableIcon: true,
                  btnColor: ColorConstants.button,
                  iconData: Icons.watch_later,
                  borderColor: ColorConstants.black,
                  onTapMethod: () async {
                    String timeStamp = "";
                    timeStamp = "${inOutTimeTextController["missed_time_stamp_date"]!.text} ${inOutTimeTextController["missed_time_stamp_out_time"]!.text}";

                    Response missTimeData = await DutyDayTimeCardApiProvider().dutyTimeRecordMissedTimeStampApiCall(timeStamp: timeStamp);
                    if (missTimeData.statusCode == 200) {
                      await dutyTimeRecordTimeStampApiCall(missTime: true);
                    }
                  },
                ),
                const SizedBox(height: SizeConstants.contentSpacing - 5, width: SizeConstants.contentSpacing + 5),
                ButtonConstant.dialogButton(
                  title: "Cancel",
                  textColor: ColorConstants.background,
                  iconColor: Colors.white,
                  enableIcon: true,
                  btnColor: ColorConstants.red,
                  iconData: Icons.clear,
                  borderColor: ColorConstants.red,
                  onTapMethod: () async {
                    inOutTimeTextController["missed_time_stamp_date"]!.clear();
                    inOutTimeTextController["missed_time_stamp_out_time"]!.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget liveServerTimeViewReturn() {
    return RichText(
      textScaler: TextScaler.linear(Get.textScaleFactor),
      text: TextSpan(
        text: 'System Time:\t',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
          color: isDark.value != true ? ColorConstants.primary : ColorConstants.black,
        ),
        children: [
          TextSpan(
            text: currentServerTime.value,
            style: TextStyle(
              color: isDark.value != true ? ColorConstants.black : ColorConstants.red,
              fontWeight: FontWeight.w600,
              fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 1,
            ),
          ),
        ],
      ),
    );
  }
}
