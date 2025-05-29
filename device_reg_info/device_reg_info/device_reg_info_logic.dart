import 'dart:convert';
import 'dart:io';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helper/device_reg_info_helper.dart';

class DeviceRegInfoLogic extends GetxController {
  RxBool isLoading = false.obs;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  PackageInfo? packageInfo;

  Position? position;

  RxMap<String, dynamic> currentLocationData = <String, dynamic>{}.obs;

  RxMap<String, dynamic> appInformationMetaData = <String, dynamic>{}.obs;

  RxString ipAddress = ''.obs;

  RxMap<String, dynamic> ipAddressData = <String, dynamic>{}.obs;

  RxMap<String, dynamic> deviceRegistrationDemoJson = <String, dynamic>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    // TODO: implement onInit
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    if (Platform.isIOS) {
      BaseDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      await DeviceInfoHelper.setDeviceInfo(iosDeviceInfo.data);
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

      Map<String, dynamic> data = {
        'deviceManufacturer': androidDeviceInfo.data['manufacturer'],
        'operatingSystem': 'AndroidOs',
        'deviceName': androidDeviceInfo.data['name'],
        'model': androidDeviceInfo.data['model'],
        'modelName': androidDeviceInfo.data['device'],
        'systemOSVersion': androidDeviceInfo.version.release,
        'identifierForVendor': androidDeviceInfo.id,
      };

      await DeviceInfoHelper.setDeviceInfo(data);
    }

    packageInfo = await PackageInfo.fromPlatform();

    await getAppMetaDataInformation();

    // print("APP DATA");
    // print(appInformationMetaData);
    // print("APP DATA");

    await AppInfoHelper.setAppInfoMetaData(appInformationMetaData);

    // print("APP DATA2");
    // print(StoragePrefs().lsRead(key: StorageConstants.appInfoMetaData));
    // print("APP DATA2");

    await getCurrentLocation();

    await getCurrentLocationName();

    await getPublicIPAddress();

    await getIpLocationAndIsp();

    await DeviceIpAddressHelper.setIpAddressData(ipAddressData);

    // print(ipAddressData);
    getDeviceRegistrationDemoJson();

    update();

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  RichText returnInformationTextData({required String title, required String value}) {
    return RichText(
      text: TextSpan(
        text: '$title:\t',
        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
        children: <TextSpan>[
          TextSpan(text: value, style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
        ],
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        print("Location services are disabled.");
      }
      SnackBarHelper.openSnackBar(title: "DAW System Info", message: "Location services are disabled. Please enable them in settings.");
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print("Location permissions are denied.");
        }
        SnackBarHelper.openSnackBar(title: "DAW System Info", message: "Location permissions are denied. Please enable them in settings.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print("Location permissions are permanently denied.");
      }
      SnackBarHelper.openSnackBar(title: "DAW System Info", message: "Location permissions are permanently denied. Please enable them in settings.");
    }

    LocationSettings locationSettings = const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 10);

    // Get current position
    position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }

  Future<void> getCurrentLocationName() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(position?.latitude ?? 0.0, position?.longitude ?? 0.0);

      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;

        currentLocationData.addIf(true, 'latitude', position?.latitude.toString() ?? '0.0');
        currentLocationData.addIf(true, 'longitude', position?.longitude.toString() ?? '0.0');
        currentLocationData.addIf(true, 'altitude', position?.altitude.toString() ?? '0.0');
        currentLocationData.addIf(true, 'street', place.street.toString().isNullOrEmpty ? 'N/A' : place.street.toString());
        currentLocationData.addIf(true, 'subLocality', place.subLocality.toString().isNullOrEmpty ? 'N/A' : place.subLocality.toString());
        currentLocationData.addIf(true, 'locality', place.locality.toString().isNullOrEmpty ? 'N/A' : place.locality.toString());
        currentLocationData.addIf(true, 'city', place.subAdministrativeArea.toString().isNullOrEmpty ? 'N/A' : place.subAdministrativeArea.toString());
        currentLocationData.addIf(true, 'postalCode', place.postalCode.toString().isNullOrEmpty ? 'N/A' : place.postalCode.toString());
        currentLocationData.addIf(true, 'state', place.administrativeArea.toString().isNullOrEmpty ? 'N/A' : place.administrativeArea.toString());
        currentLocationData.addIf(true, 'country', place.country.toString().isNullOrEmpty ? 'N/A' : place.country.toString());
      } else {
        currentLocationData.addIf(true, 'latitude', position?.latitude.toString() ?? '0.0');
        currentLocationData.addIf(true, 'longitude', position?.longitude.toString() ?? '0.0');
        currentLocationData.addIf(true, 'altitude', position?.altitude.toString() ?? '0.0');
        currentLocationData.addIf(true, 'street', 'N/A');
        currentLocationData.addIf(true, 'subLocality', 'N/A');
        currentLocationData.addIf(true, 'locality', 'N/A');
        currentLocationData.addIf(true, 'city', 'N/A');
        currentLocationData.addIf(true, 'postalCode', 'N/A');
        currentLocationData.addIf(true, 'state', 'N/A');
        currentLocationData.addIf(true, 'country', 'N/A');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    await DeviceGPSInfoHelper.setGPSInfoData(currentLocationData);
  }

  Future<void> getAppMetaDataInformation() async {
    appInformationMetaData.addIf(true, 'appName', packageInfo!.appName.toString().isNullOrEmpty ? 'N/A' : packageInfo!.appName);
    appInformationMetaData.addIf(true, 'packageName', packageInfo!.packageName.toString().isNullOrEmpty ? 'N/A' : packageInfo!.packageName);
    appInformationMetaData.addIf(true, 'version', packageInfo!.version.toString().isNullOrEmpty ? 'N/A' : packageInfo!.version);
    appInformationMetaData.addIf(true, 'buildNumber', packageInfo!.buildNumber.toString().isNullOrEmpty ? 'N/A' : packageInfo!.buildNumber);
  }

  Future<void> getPublicIPAddress() async {
    final response = await http.get(Uri.parse("https://api64.ipify.org?format=json"));
    if (response.statusCode == 200) {
      String publicIP = jsonDecode(response.body)["ip"];
      ipAddress.value = "Public IP Address: $publicIP";
    } else {
      ipAddress.value = "Failed to get Public IP";
    }
  }

  Future<void> getIpLocationAndIsp() async {
    try {
      // Replace with your own API key for ipinfo.io (optional for basic requests)
      final response = await http.get(Uri.parse("https://ipinfo.io?token=ab898209863a17"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        ipAddressData.addAll(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Failed to retrieve data, $e");
      }
    }
  }

  void getDeviceRegistrationDemoJson() {
    deviceRegistrationDemoJson.addIf(true, 'systemId', UserSessionInfo.systemId.toString());
    deviceRegistrationDemoJson.addIf(true, 'userId', UserSessionInfo.userId.toString());
    deviceRegistrationDemoJson.addIf(true, 'deviceInformation', {
      'deviceManufacturer': DeviceInfoHelper.deviceManufacturer,
      'operatingSystem': DeviceInfoHelper.operatingSystem,
      'deviceName': DeviceInfoHelper.deviceName,
      'model': DeviceInfoHelper.model,
      'modelName': DeviceInfoHelper.modelName,
      'systemOSVersion': DeviceInfoHelper.systemOSVersion,
    });
    deviceRegistrationDemoJson.addIf(true, 'appInformation', {
      'appName': AppInfoHelper.appName,
      'packageName': AppInfoHelper.packageName,
      'version': AppInfoHelper.version,
      'buildNumber': AppInfoHelper.buildNumber,
    });
    deviceRegistrationDemoJson.addIf(true, 'gpsInformation', {
      'latitude': DeviceGPSInfoHelper.latitude,
      'longitude': DeviceGPSInfoHelper.longitude,
      'altitude': DeviceGPSInfoHelper.altitude,
      'street': DeviceGPSInfoHelper.street,
      'subLocality': DeviceGPSInfoHelper.subLocality,
      'locality': DeviceGPSInfoHelper.locality,
      'city': DeviceGPSInfoHelper.city,
      'postalCode': DeviceGPSInfoHelper.postalCode,
      'state': DeviceGPSInfoHelper.state,
      'country': DeviceGPSInfoHelper.country,
    });
    deviceRegistrationDemoJson.addIf(true, 'ipAddressInformation', {
      'ip': DeviceIpAddressHelper.ip,
      'city': DeviceIpAddressHelper.city,
      'region': DeviceIpAddressHelper.region,
      'country': DeviceIpAddressHelper.country,
      'loc': DeviceIpAddressHelper.loc,
      'org': DeviceIpAddressHelper.org,
      'postal': DeviceIpAddressHelper.postal,
      'timezone': DeviceIpAddressHelper.timezone,
    });
  }
}
