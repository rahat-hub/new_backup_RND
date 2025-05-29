import 'dart:io';
import 'dart:ui';

import 'package:aviation_rnd/core/custom_lib/lib/encryption/encryption.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/api_provider.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/widgets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart' as dm;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_ip_address/get_ip_address.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:text_scroll/text_scroll.dart';

import '../helper/date_time_helper.dart';
import '../helper/dialog_helper.dart';
import '../helper/permission_helper.dart';
import '../modules/dashboard/dashboard_logic.dart';
import '../routes/app_pages.dart';
import '../shared/services/device_orientation.dart' as orientation;

class DrawerNavigationBar {
  static UserAccountsDrawerHeader headerDrawerNavigationBar({String? userName, String? userRole, String? imageText}) {
    return UserAccountsDrawerHeader(
      accountName: Text(userName ?? "", style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.bodyMedium!.fontSize)! + 5)),
      accountEmail: Text(userRole ?? "", style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.bodyMedium!.fontSize))),
      currentAccountPicture: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        child: const Center(child: Icon(Icons.person, color: Colors.white, size: 50)),
      ),
      decoration: BoxDecoration(color: Theme.of(Get.context!).canvasColor, shape: BoxShape.rectangle),
    );
  }

  static Flexible pageDrawerNavigationBar({required RxBool isBioEditPermission, required RxBool biometricSignatureEnable}) {
    bool isFaceID = StoragePrefs().lsRead(key: StorageConstants.isFaceId) ?? false;
    bool isBioSupport = StoragePrefs().lsRead(key: StorageConstants.biometricSignatureSupport) ?? false;

    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 0.0),
        child: Column(
          children: <Widget>[
            if (PermissionHelper.specialPermissionAccess)
              ListTile(
                horizontalTitleGap: 8.0,
                leading: Icon(Icons.person, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
                title: Text("My Profile", style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize)),
                onTap: () => DialogHelper.openCommonDialogBox(),
              ), // Find peoples button action
            if (!UserPermission.vendor.value)
              ListTile(
                horizontalTitleGap: 8.0,
                leading: Icon(Icons.list, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
                title: Text("My Flight Log", style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize)),
                onTap: () => Get.toNamed(Routes.pilotLogBookIndex),
              ),
            if (isBioSupport)
              Obx(() {
                return isBioEditPermission.value
                    ? ListTile(
                      horizontalTitleGap: 8.0,
                      leading: ImageIcon(
                        AssetImage(isFaceID ? AssetConstants.iosFaceId : AssetConstants.fingerPrintLogo),
                        color: biometricSignatureEnable.value != false ? Colors.green : Colors.red,
                        size: 38,
                      ),
                      title: TextScroll(
                        biometricSignatureEnable.value != false ? "Biometric Signature Enabled" : "Biometric Signature Disabled",
                        velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                        delayBefore: const Duration(milliseconds: 1500),
                        pauseBetween: const Duration(milliseconds: 500),
                        intervalSpaces: 5,
                        numberOfReps: 5,
                        style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
                      ),
                      trailing: Switch(
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green.withValues(alpha: 0.4),
                        inactiveTrackColor: Colors.red,
                        inactiveThumbColor: Colors.grey,
                        value: biometricSignatureEnable.value,
                        onChanged: (value) async {
                          biometricSignatureEnable.value = value;
                          await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEnable, value: biometricSignatureEnable.value);

                          if (value) {
                            await StoragePrefs().ssWrite(key: StorageConstants.biometricSignatureKey1, value: await StoragePrefs().ssRead(key: StorageConstants.key1));
                            await StoragePrefs().ssWrite(key: StorageConstants.biometricSignatureKey2, value: await StoragePrefs().ssRead(key: StorageConstants.key2));
                          } else {
                            await StoragePrefs().ssDelete(key: StorageConstants.biometricSignatureKey1);
                            await StoragePrefs().ssDelete(key: StorageConstants.biometricSignatureKey2);
                          }
                        },
                      ),
                      onTap: () async {
                        biometricSignatureEnable.value = !biometricSignatureEnable.value;
                        await StoragePrefs().lsWrite(key: StorageConstants.biometricSignatureEnable, value: biometricSignatureEnable.value);

                        if (biometricSignatureEnable.value) {
                          await StoragePrefs().ssWrite(key: StorageConstants.biometricSignatureKey1, value: await StoragePrefs().ssRead(key: StorageConstants.key1));
                          await StoragePrefs().ssWrite(key: StorageConstants.biometricSignatureKey2, value: await StoragePrefs().ssRead(key: StorageConstants.key2));
                        } else {
                          await StoragePrefs().ssDelete(key: StorageConstants.biometricSignatureKey1);
                          await StoragePrefs().ssDelete(key: StorageConstants.biometricSignatureKey2);
                        }
                      },
                    )
                    : ListTile(
                      horizontalTitleGap: 8.0,
                      leading: ImageIcon(AssetImage(isFaceID ? AssetConstants.iosFaceId : AssetConstants.fingerPrintLogo), color: Colors.grey, size: 38),
                      title: TextScroll(
                        "Biometric Signature Disabled",
                        velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                        delayBefore: const Duration(milliseconds: 1500),
                        numberOfReps: 5,
                        intervalSpaces: 20,
                        style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
                      ),
                      trailing: Switch(
                        value: true,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey,
                        onChanged: (a) async {
                          SnackBarHelper.openSnackBar(
                            isError: false,
                            message:
                                "Login as ${await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.biometricSignatureKey1) ?? "")} to Change Biometric Verification Status",
                          );
                        },
                        activeColor: Colors.grey,
                        activeTrackColor: Colors.grey.withValues(alpha: 0.4),
                      ),
                      onTap: () async {
                        SnackBarHelper.openSnackBar(
                          isError: false,
                          message:
                              "Login as ${await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.biometricSignatureKey1) ?? "")} to Change Biometric Verification Status",
                        );
                      },
                    );
              }),
            ListTile(
              horizontalTitleGap: 8.0,
              leading: Icon(Icons.perm_device_info, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
              title: TextScroll(
                "Device Information",
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                delayBefore: const Duration(milliseconds: 1500),
                pauseBetween: const Duration(milliseconds: 500),
                intervalSpaces: 5,
                numberOfReps: 5,
                style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
              ),
              onTap: () async {
                await LoaderHelper.loaderWithGif();
                Map<String, String> deviceInfo = await getDeviceInformation().catchError((e) {
                  if (kDebugMode) {
                    print(e);
                  }
                  return {
                    "deviceName": "Unknown Device",
                    "deviceModel": "Unknown Model",
                    "deviceManufacture": "Unknown Manufacturer",
                    "deviceSerialNumber": "Unknown Serial Number",
                    "deviceIpAddress": "Unknown IP Address",
                  };
                });
                await EasyLoading.dismiss();

                await deviceInformationDialog(
                  deviceName: deviceInfo["deviceName"],
                  deviceModel: deviceInfo["deviceModel"],
                  deviceManufacture: deviceInfo["deviceManufacture"],
                  deviceSerialNumber: deviceInfo["deviceSerialNumber"],
                  deviceIpAddress: deviceInfo["deviceIpAddress"],
                );
              },
            ),
            ListTile(
              horizontalTitleGap: 8.0,
              leading: Icon(Icons.key_sharp, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
              title: TextScroll(
                "Change Password",
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                delayBefore: const Duration(milliseconds: 1500),
                numberOfReps: 5,
                style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
              ),
              onTap: () {
                DialogHelper.openCommonDialogBox(message: "Please Contact your Administrator for Password Reset.");
              },
            ),
            if (PermissionHelper.specialPermissionAccess) ...{
              ListTile(
                horizontalTitleGap: 8.0,
                leading: Icon(Icons.person_outline_outlined, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
                title: TextScroll(
                  "Change To User",
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  delayBefore: const Duration(milliseconds: 1500),
                  pauseBetween: const Duration(milliseconds: 500),
                  intervalSpaces: 5,
                  numberOfReps: 5,
                  style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
                ),
                onTap: () async {
                  await LoaderHelper.loaderWithGif();

                  List<dynamic> systemUserChangeDropdownData = [];
                  await getSystemUserData(systemUserChangeDropdownData: systemUserChangeDropdownData);

                  await EasyLoading.dismiss();
                  await systemUserChangeDialog(dropdownData: systemUserChangeDropdownData);
                },
              ),
              ListTile(
                horizontalTitleGap: 8.0,
                leading: Icon(Icons.settings, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
                title: TextScroll(
                  "Change To System",
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  delayBefore: const Duration(milliseconds: 1500),
                  pauseBetween: const Duration(milliseconds: 500),
                  intervalSpaces: 5,
                  numberOfReps: 5,
                  style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
                ),
                onTap: () async {
                  await LoaderHelper.loaderWithGif();

                  List<dynamic> allSystemDropDownData = [
                    {"id": "144", "name": "5 STATE HELICOPTERS", "selected": false},
                    {"id": "151", "name": "AIRBUS HELICOPTERS", "selected": false},
                    {"id": "60", "name": "AIRCRAFT TEMPLATE", "selected": false},
                    {"id": "90", "name": "AIRtec Inc.", "selected": false},
                    {"id": "138", "name": "ALBUQUERQUE PD", "selected": false},
                    {"id": "55", "name": "Arizona DPS FW", "selected": false},
                    {"id": "46", "name": "Arizona DPS RW", "selected": false},
                    {"id": "103", "name": "Arizona DPS UAS", "selected": false},
                    {"id": "91", "name": "ATLANTA PD", "selected": false},
                    {"id": "139", "name": "AURORA", "selected": false},
                    {"id": "67", "name": "Aurora Flight Sciences", "selected": false},
                    {"id": "75", "name": "Austin Police Department", "selected": false},
                    {"id": "160", "name": "AVCON", "selected": false},
                    {"id": "147", "name": "BENNICK GRADING", "selected": false},
                    {"id": "52", "name": "BOSTON MED FLIGHT", "selected": false},
                    {"id": "93", "name": "Broward County Fire Rescue", "selected": false},
                    {"id": "79", "name": "Broward Sheriffs Office", "selected": false},
                    {"id": "156", "name": "CAREFLITE", "selected": false},
                    {"id": "131", "name": "CAYMAN PRIVATE AVIATION", "selected": false},
                    {"id": "84", "name": "Charlotte County Sheriff", "selected": false},
                    {"id": "130", "name": "COLLIER COUNTY AVIATION BUREAU", "selected": false},
                    {"id": "137", "name": "COLLIER COUNTY MARINE BUREAU", "selected": false},
                    {"id": "134", "name": "COLUMBUS COUNTY SHERIFF", "selected": false},
                    {"id": "98", "name": "COLUMBUS POLICE", "selected": false},
                    {"id": "115", "name": "DAGGARO", "selected": false},
                    {"id": "116", "name": "DEKALB COUNTY PD", "selected": false},
                    {"id": "51", "name": "DELAWARE STATE POLICE", "selected": false},
                    {"id": "1", "name": "Demo", "selected": true},
                    {"id": "149", "name": "EL DORADO COUNTY SHERIFF", "selected": false},
                    {"id": "63", "name": "EPS Flight Operations Unit", "selected": false},
                    {"id": "153", "name": "EUROTEC", "selected": false},
                    {"id": "100", "name": "EXPLORAIR", "selected": false},
                    {"id": "125", "name": "FLORIDA FISH / WILDLIFE", "selected": false},
                    {"id": "99", "name": "FLORIDA MOSQUITO CONTROL", "selected": false},
                    {"id": "83", "name": "Fox Hotel Holdings", "selected": false},
                    {"id": "97", "name": "FURA", "selected": false},
                    {"id": "122", "name": "GA FORESTRY", "selected": false},
                    {"id": "117", "name": "GEORGIA DNR", "selected": false},
                    {"id": "136", "name": "GEORGIA DPS", "selected": false},
                    {"id": "105", "name": "HARRIS COUNTY SHERIFF OFFICE", "selected": false},
                    {"id": "109", "name": "HARRIS COUNTY UAS", "selected": false},
                    {"id": "126", "name": "HELIQWEST", "selected": false},
                    {"id": "141", "name": "HeliService USA", "selected": false},
                    {"id": "3", "name": "Hillsborough County Sheriffs Aviation", "selected": false},
                    {"id": "112", "name": "HOUSTON PD", "selected": false},
                    {"id": "88", "name": "Hunter Construction", "selected": false},
                    {"id": "108", "name": "JAARS", "selected": false},
                    {"id": "152", "name": "JEFFERSON COUNTY SHERIFF", "selected": false},
                    {"id": "150", "name": "KANSAS CITY PD", "selected": false},
                    {"id": "128", "name": "KANSAS HIGHWAY PATROL AVIATION SECTION", "selected": false},
                    {"id": "102", "name": "KERN COUNTY SHERIFF", "selected": false},
                    {"id": "155", "name": "KHM HOLDINGS", "selected": false},
                    {"id": "94", "name": "Las Vegas Metro UAS", "selected": false},
                    {"id": "59", "name": "Las Vegas Metropolitan PD", "selected": false},
                    {"id": "48", "name": "LEE County Sheriff", "selected": false},
                    {"id": "127", "name": "LOUISIANA STATE POLICE AIR SUPPORT UNIT", "selected": false},
                    {"id": "73", "name": "LUMA ENERGY", "selected": false},
                    {"id": "129", "name": "MANATEE COUNTY SHERIFF", "selected": false},
                    {"id": "18", "name": "Maricopa County Sheriffs Office", "selected": false},
                    {"id": "118", "name": "MARTIN COUNTY SHERIFF", "selected": false},
                    {"id": "123", "name": "MD HELICOPTERS", "selected": false},
                    {"id": "50", "name": "Mesa Police Department Aviation Unit", "selected": false},
                    {"id": "5", "name": "Miami Dade Fire Rescue", "selected": false},
                    {"id": "35", "name": "Miami Dade Police Department", "selected": false},
                    {"id": "31", "name": "MIDWEST MEDAIR", "selected": false},
                    {"id": "101", "name": "NASHVILLE POLICE DEPARTMENT", "selected": false},
                    {"id": "154", "name": "NC FOREST SERVICE", "selected": false},
                    {"id": "68", "name": "NC HIGHWAY PATROL", "selected": false},
                    {"id": "57", "name": "NEW JERSEY STATE POLICE", "selected": false},
                    {"id": "124", "name": "NEW MEXICO DPS", "selected": false},
                    {"id": "157", "name": "NEW YORK HELICOPTER", "selected": false},
                    {"id": "71", "name": "Newsome Air LLC", "selected": false},
                    {"id": "66", "name": "NYPD Aviation Unit", "selected": false},
                    {"id": "143", "name": "OKLAHOMA CITY PD", "selected": false},
                    {"id": "148", "name": "OMNI HELICOPTERS GUYANA", "selected": false},
                    {"id": "104", "name": "Orange County Fire Authority", "selected": false},
                    {"id": "53", "name": "Orange County Sheriffs Office", "selected": false},
                    {"id": "25", "name": "Ontario Police Air Support", "selected": false},
                    {"id": "135", "name": "OSCHNER AVIATION", "selected": false},
                    {"id": "169", "name": "OXFORD PD", "selected": false},
                    {"id": "14", "name": "Palm Beach County Sheriffs Office", "selected": false},
                    {"id": "146", "name": "PASADENA PD", "selected": false},
                    {"id": "162", "name": "PEORIA PD", "selected": false},
                    {"id": "121", "name": "PHOENIX PD", "selected": false},
                    {"id": "40", "name": "Pinal County Sheriffs Dpt", "selected": false},
                    {"id": "41", "name": "Pinellas County Sheriffs Office", "selected": false},
                    {"id": "120", "name": "PRINCE GEORGES AVIATION", "selected": false},
                    {"id": "163", "name": "PUTNAM COUNTY SHERIFF", "selected": false},
                    {"id": "161", "name": "RURAL MEDEVAC", "selected": false},
                    {"id": "61", "name": "SABLE AIR UNIT", "selected": false},
                    {"id": "165", "name": "Samaritan Purse", "selected": false},
                    {"id": "2", "name": "San Antonio Police Department", "selected": false},
                    {"id": "142", "name": "SAN MATEO", "selected": false},
                    {"id": "107", "name": "SEMINOLE COUNTY SHERIFF", "selected": false},
                    {"id": "113", "name": "SEMINOLE COUNTY SPECIAL OPERATIONS", "selected": false},
                    {"id": "114", "name": "SR3 Rescue Concepts", "selected": false},
                    {"id": "111", "name": "St. Johns County Marine", "selected": false},
                    {"id": "42", "name": "St. Johns County Sheriff Aviation", "selected": false},
                    {"id": "110", "name": "St. Johns County UAS", "selected": false},
                    {"id": "132", "name": "ST. LOUIS PD", "selected": false},
                    {"id": "140", "name": "STOCKTON PD", "selected": false},
                    {"id": "158", "name": "TACTICAL FLYING", "selected": false},
                    {"id": "47", "name": "TAMPA POLICE AVIATION", "selected": false},
                    {"id": "106", "name": "TENNESSEE HIGHWAY PATROL", "selected": false},
                    {"id": "133", "name": "TEXAS DOT", "selected": false},
                    {"id": "28", "name": "TEXAS DPS", "selected": false},
                    {"id": "81", "name": "TEXAS DPS UAS", "selected": false},
                    {"id": "86", "name": "TEXAS PARKS AND WILDLIFE", "selected": false},
                    {"id": "80", "name": "Twiga Air, LLC", "selected": false},
                    {"id": "11", "name": "US Helicopters Inc", "selected": false},
                    {"id": "119", "name": "USDA", "selected": false},
                    {"id": "164", "name": "UTAH DOT", "selected": false},
                    {"id": "85", "name": "UTAH DPS", "selected": false},
                    {"id": "34", "name": "VectorOne", "selected": false},
                    {"id": "166", "name": "Ventura County Sheriff", "selected": false},
                    {"id": "167", "name": "Virginia State Police Aviation", "selected": false},
                    {"id": "145", "name": "WRIGHT BASE OPTIONS", "selected": false},
                    {"id": "159", "name": "WV AVIATION DIVISION", "selected": false},
                  ];

                  await EasyLoading.dismiss();
                  await systemServiceChangeDialog(dropdownData: allSystemDropDownData);
                },
              ),
              ListTile(
                horizontalTitleGap: 8.0,
                leading: Icon(Entypo.tools, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
                title: TextScroll(
                  "Change To Current Web System",
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  delayBefore: const Duration(milliseconds: 1500),
                  pauseBetween: const Duration(milliseconds: 500),
                  intervalSpaces: 5,
                  numberOfReps: 5,
                  style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize),
                ),
                onTap: () async {
                  await LoaderHelper.loaderWithGif();
                  SnackBarHelper.openSnackBar(isError: false, message: "Switching to Current Web System...");
                  bool isSystemChanged = await DashboardLogic().getToken(
                    key1: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.key1) ?? ""),
                    key2: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.key2) ?? ""),
                  );
                  if (!isSystemChanged) {
                    SnackBarHelper.openSnackBar(isError: false, message: "You are already in Current Web System!");
                  }

                  EasyLoading.dismiss();
                },
              ), //------------
              /*ListTile(
              horizontalTitleGap: 8.0,
              minVerticalPadding: 0.0,
              leading: Icon(Icons.api, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
              title: DropdownButton<dynamic>(
                  icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: 38),
                  iconEnabledColor: ColorConstants.black,
                  iconDisabledColor: Colors.grey[350],
                  hint: Text(
                      selectedApiUrl.isNotEmpty
                          ? selectedApiUrl["name"]
                          : apiUrlData?.firstWhereOrNull((element) => element["url"] == StoragePrefs().lsRead(key: StorageConstants.currentApiURL))["name"],
                      style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize)),
                  itemHeight: 65,
                  menuMaxHeight: Get.height - 200,
                  underline: const SizedBox(),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: ColorConstants.white,
                  isDense: false,
                  items: apiUrlData?.map((value) {
                    return DropdownMenuItem<dynamic>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
                        child: Text("${value["name"]}",
                            style: Theme.of(context ?? Get.context!)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) async {
                    LoaderHelper.loaderWithGif();

                    if (val["url"] != await StoragePrefs().lsRead(key: StorageConstants.currentApiURL)) {
                      var currentIpAddress = await onChangeApiUrl();

                      if (currentIpAddress == val["url"].toString().split("/")[2]) {
                        SnackBarHelper.openSnackBar(isError: false, message: "You can't access ${val["name"]}!\nPlease change your network");
                      } else {
                        if (InternetCheckerHelperLogic.internetConnected) {
                          http.Response currentEndpointResponse =
                              await http.get(Uri.parse(val["url"])).timeout(const Duration(seconds: 5), onTimeout: () => http.Response("false", 408));

                          if (currentEndpointResponse.statusCode == 200) {
                            selectedApiUrl.value = val;

                            if (StoragePrefs().lsHasData(key: StorageConstants.currentApiURL)) await StoragePrefs().lsDelete(key: StorageConstants.currentApiURL);
                            await StoragePrefs().lsWrite(key: StorageConstants.currentApiURL, value: val["url"]);

                            Get.offAllNamed(Routes.splash);
                          } else {
                            SnackBarHelper.openSnackBar(isError: false, message: "You can't access ${val["name"]}!\nPlease check your network");
                          }
                        } else {
                          EasyLoading.dismiss();
                          SnackBarHelper.openSnackBar(isError: true, message: "Network Not Connected!");
                        }
                      }
                    } else {
                      SnackBarHelper.openSnackBar(isError: false, message: "You are already in ${val["name"]}.");
                    }

                    EasyLoading.dismiss();
                  }),
            )*/
            },
            ListTile(
              horizontalTitleGap: 8.0,
              leading: const Icon(Icons.logout, color: Colors.red, size: 38),
              title: Text("Log Out", style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize)),
              onTap: () async {
                await DashboardLogic().logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<Map<String, String>> getDeviceInformation() async {
    final dm.DeviceMarketingNames deviceMarketingNames = dm.DeviceMarketingNames();
    final String deviceName = await deviceMarketingNames.getSingleName().catchError((e) {
      if (kDebugMode) {
        print(e);
      }
      return "Unknown Device";
    });

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;

    String? deviceSerialNumber;
    try {
      deviceSerialNumber =
          await FlutterDeviceImei.instance.getIMEI().catchError((e) {
            if (kDebugMode) {
              print(e);
            }
            return "Unknown Serial Number";
          }) ??
          "Unknown Serial Number";
    } on PlatformException catch (e) {
      deviceSerialNumber = "Unknown Serial Number";
      if (kDebugMode) {
        print(e.message);
      }
    }

    String? currentIPAddress;
    try {
      currentIPAddress =
          await IpAddress().getIpAddress().catchError((e) {
            if (kDebugMode) {
              print(e);
            }
            return "Unknown IP Address";
          }) ??
          "Unknown IP Address";
    } on IpAddressException catch (e) {
      currentIPAddress = "Unknown IP Address";
      if (kDebugMode) {
        print(e.message);
      }
    }

    /*deviceId = await MobileDeviceIdentifierPlatform.instance.getDeviceId() ?? 'Unknown ID';

    if (deviceId != "Unknown ID") {
      deviceId = base64.encode(utf8.encode(deviceId!));
    }*/

    if (kDebugMode) {
      print("***********DeviceInfo********************");
      print(deviceInfo.data);
      print("***********DeviceInfo********************");
    }

    return {
      "deviceName": deviceName,
      "deviceModel": Platform.isIOS ? deviceInfo.data["modelName"] : deviceInfo.data["model"] ?? "Unknown Model",
      "deviceManufacture": Platform.isIOS ? "Apple" : deviceInfo.data["manufacturer"] ?? "Unknown Manufacturer",
      "deviceSerialNumber": deviceSerialNumber,
      "deviceIpAddress": currentIPAddress ?? "Unknown IP Address",
    };
  }

  static Future<void> deviceInformationDialog({String? deviceName, String? deviceModel, String? deviceManufacture, String? deviceSerialNumber, String? deviceIpAddress}) {
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
                          "Device Information",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                        ),
                      ),
                      DeviceType.isMobile
                          ? ListView(
                            shrinkWrap: true,
                            children: [
                              widgetsViewReturnForDeviceDetails(titleName: "Name: ", titleValue: deviceName ?? ""),
                              widgetsViewReturnForDeviceDetails(titleName: "Model: ", titleValue: deviceModel ?? ""),
                              widgetsViewReturnForDeviceDetails(titleName: "Manufacturer: ", titleValue: deviceManufacture ?? ""),
                              widgetsViewReturnForDeviceDetails(titleName: "S/N: ", titleValue: deviceSerialNumber ?? ""),
                              widgetsViewReturnForDeviceDetails(titleName: "IP Address: ", titleValue: deviceIpAddress ?? ""),
                            ],
                          )
                          : ListView(
                            shrinkWrap: true,
                            children: [
                              widgetsViewReturnForDeviceDetails(titleName: "Device Name: ", titleValue: deviceName ?? ""),
                              const SizedBox(height: SizeConstants.contentSpacing),
                              widgetsViewReturnForDeviceDetails(titleName: "Device Model: ", titleValue: deviceModel ?? ""),
                              const SizedBox(height: SizeConstants.contentSpacing),
                              widgetsViewReturnForDeviceDetails(titleName: "Device Manufacturer: ", titleValue: deviceManufacture ?? ""),
                              const SizedBox(height: SizeConstants.contentSpacing),
                              widgetsViewReturnForDeviceDetails(titleName: "Device Serial Number: ", titleValue: deviceSerialNumber ?? ""),
                              const SizedBox(height: SizeConstants.contentSpacing),
                              widgetsViewReturnForDeviceDetails(titleName: "Device IP Address: ", titleValue: deviceIpAddress ?? ""),
                            ],
                          ),
                      const SizedBox(height: SizeConstants.contentSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonConstant.dialogButton(
                            title: "Cancel",
                            btnColor: ColorConstants.primary,
                            borderColor: Colors.red,
                            onTapMethod: () {
                              Get.back();
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing + 20),
                          ButtonConstant.dialogButton(
                            title: "Copy Info",
                            btnColor: ColorConstants.primary,
                            onTapMethod: () async {
                              await copyDeviceInfo(
                                deviceName: deviceName,
                                deviceModel: deviceModel,
                                deviceManufacture: deviceManufacture,
                                deviceSerialNumber: deviceSerialNumber,
                                deviceIpAddress: deviceIpAddress,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> copyDeviceInfo({String? deviceName, String? deviceModel, String? deviceManufacture, String? deviceSerialNumber, String? deviceIpAddress}) async {
    String deviceInformation = "Device: $deviceManufacture $deviceName ( $deviceModel )\nSerial Number: $deviceSerialNumber\nIP Address: $deviceIpAddress";

    await CopyIntoClipboard.copyText(text: deviceInformation, message: "Device Information");
  }

  static RichText widgetsViewReturnForDeviceDetails({String? titleName, String? titleValue}) {
    return RichText(
      textScaler: TextScaler.linear(Get.textScaleFactor),
      text: TextSpan(
        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ThemeColorMode.isLight ? ColorConstants.black : null),
        children: [TextSpan(text: "$titleName", style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "$titleValue")],
      ),
    );
  }

  static Future<void> getSystemUserData({required List systemUserChangeDropdownData}) async {
    systemUserChangeDropdownData.add({"id": 0, "name": "Change To User", "selected": true});

    Response data = await ApiProvider().dawAdminUserChangeDropdownData();

    if (data.statusCode == 200) {
      systemUserChangeDropdownData.addAll(data.data["data"]["userOptions"]);
    }
  }

  static Future<void> systemUserChangeDialog({required List dropdownData}) {
    RxMap<dynamic, dynamic> selectedSystemUser = {}.obs;

    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return Padding(
          padding:
              DeviceType.isTablet
                  ? orientation.DeviceOrientation.isLandscape
                      ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0)
                      : const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 50.0)
                  : const EdgeInsets.all(5.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
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
                          "Change To System User",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing + 10),
                      ResponsiveBuilder(
                        builder:
                            (context, sizingInformation) => FormBuilderField(
                              name: "system_user_change",
                              builder: (FormFieldState<dynamic> field) {
                                return Obx(() {
                                  return WidgetConstant.customDropDownWidget(
                                    showTitle: true,
                                    key: "name",
                                    title: "System Users",
                                    context: context,
                                    hintText:
                                        selectedSystemUser.isNotEmpty
                                            ? selectedSystemUser["name"]
                                            : dropdownData.isNotEmpty
                                            ? dropdownData[0]["name"]
                                            : "",
                                    data: dropdownData,
                                    onChanged: (val) {
                                      selectedSystemUser.value = val;
                                    },
                                  );
                                });
                              },
                            ),
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing + 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonConstant.dialogButton(
                            title: "Cancel",
                            btnColor: ColorConstants.primary,
                            borderColor: Colors.red,
                            onTapMethod: () {
                              Get.back(closeOverlays: true);
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing + 20),
                          ButtonConstant.dialogButton(
                            title: "Change User",
                            btnColor: ColorConstants.primary,
                            onTapMethod: () async {
                              await LoaderHelper.loaderWithGif();
                              if (selectedSystemUser.isEmpty || selectedSystemUser["id"] == 0) {
                                EasyLoading.dismiss();
                                SnackBarHelper.openSnackBar(isError: true, message: "Please Select A System User To Change To Their Profile!");
                                return;
                              }
                              await systemUserChangePostCall(selectedUser: selectedSystemUser["id"].toString());
                              await EasyLoading.dismiss();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> systemUserChangePostCall({required String selectedUser}) async {
    Response tknResponse = await ApiProvider().dawAdminSystemUserChangePost(selectedSystemUser: selectedUser);

    if (tknResponse.statusCode == 200) {
      Map tknResponseData = tknResponse.data["data"]["fullToken"];

      DateTimeHelper.currentDateTime = tknResponseData["systemDateTime24Hours"] ?? "";

      await UserSessionInfo.setToken(tknResponseData["access_token"]);

      await StoragePrefs().lsWrite(key: StorageConstants.tokenIssuedAt, value: DateTime.now().toString());
      await StoragePrefs().lsWrite(key: StorageConstants.tokenExpiresIn, value: tknResponseData["expires_in"].toString());

      await UserSessionInfo.setUserInfo(tknResponseData.cast<String, dynamic>());

      String? token = await UserSessionInfo.token;

      await tokenAuthenticate(token: token).then((value) {
        if (value) {
          EasyLoading.dismiss();
          Get.offAllNamed(Routes.splash);
          SnackBarHelper.openSnackBar(isError: false, message: "System User Changed SuccessFully.");
        }
      });
    }
  }

  static Future<void> systemServiceChangeDialog({List? dropdownData}) {
    RxMap<dynamic, dynamic> selectedSystemService = {}.obs;

    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return Padding(
          padding:
              DeviceType.isTablet
                  ? orientation.DeviceOrientation.isLandscape
                      ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0)
                      : const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 50.0)
                  : const EdgeInsets.all(5.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
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
                          "Change To Another Service",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing + 10),
                      ResponsiveBuilder(
                        builder:
                            (context, sizingInformation) => FormBuilderField(
                              name: "system_service_change",
                              builder: (FormFieldState<dynamic> field) {
                                return Obx(() {
                                  return WidgetConstant.customDropDownWidget(
                                    showTitle: true,
                                    key: "name",
                                    title: "System or Services",
                                    context: context,
                                    hintText: selectedSystemService.isNotEmpty ? selectedSystemService["name"] : UserSessionInfo.systemName,
                                    data: dropdownData,
                                    onChanged: (val) {
                                      selectedSystemService.value = val;
                                    },
                                  );
                                });
                              },
                            ),
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing + 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonConstant.dialogButton(
                            title: "Cancel",
                            btnColor: ColorConstants.primary,
                            borderColor: Colors.red,
                            onTapMethod: () {
                              Get.back(closeOverlays: true);
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing + 10),
                          ButtonConstant.dialogButton(
                            title: "Change System",
                            btnColor: ColorConstants.primary,
                            onTapMethod: () async {
                              await LoaderHelper.loaderWithGif();

                              if (selectedSystemService.isEmpty || selectedSystemService["id"] == 0) {
                                EasyLoading.dismiss();
                                SnackBarHelper.openSnackBar(isError: true, message: "Please Select Another Service To Change System!");
                                return;
                              } else if (UserSessionInfo.systemId.toString() == selectedSystemService["id"].toString()) {
                                EasyLoading.dismiss();
                                SnackBarHelper.openSnackBar(isError: false, message: "You are already in ${selectedSystemService["name"]}!");
                                return;
                              }

                              SnackBarHelper.openSnackBar(isError: false, message: "Switching to New System...");

                              Response response = await ApiProvider().postChangeToAnotherService(changeSystemId: selectedSystemService["id"].toString());

                              if (response.statusCode == 200) {
                                await DashboardLogic().getToken(
                                  key1: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.key1) ?? ""),
                                  key2: await Encryption.decrypt(encryptedValue: await StoragePrefs().ssRead(key: StorageConstants.key2) ?? ""),
                                );
                              }

                              EasyLoading.dismiss();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<bool> tokenAuthenticate({String? token}) async {
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
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Invalid Login Attempt!");
      result = false;
    }
    return result;
  }
}
