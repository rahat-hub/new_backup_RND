import 'dart:io';

import 'package:aviation_rnd/shared/constants/constant_storages.dart';
import 'package:aviation_rnd/shared/services/storage_prefs.dart';

abstract final class DeviceInfoHelper {
  DeviceInfoHelper._();

  static Future<void> setDeviceInfo(Map<String, dynamic> deviceInfoData) => StoragePrefs().lsWrite(
    key: StorageConstants.deviceInfoData,
    value: Platform.isIOS
        ? <String, dynamic>{
            'deviceManufacturer': 'Apple Inc',
            'operatingSystem': deviceInfoData['systemName'],
            'deviceName': (deviceInfoData['utsname'] as Map<dynamic, dynamic>)['nodename'],
            'model': deviceInfoData['model'],
            'modelName': deviceInfoData['modelName'],
            'systemOSVersion': deviceInfoData['systemVersion'],
            'identifierForVendor': deviceInfoData['identifierForVendor'],
          }
        : <String, dynamic>{
            'deviceManufacturer': deviceInfoData['deviceManufacturer'],
            'operatingSystem': deviceInfoData['operatingSystem'],
            'deviceName': deviceInfoData['deviceName'],
            'model': deviceInfoData['model'],
            'modelName': deviceInfoData['modelName'],
            'systemOSVersion': deviceInfoData['systemOSVersion'],
            'identifierForVendor': deviceInfoData['identifierForVendor'],
          },
  );

  static String _getDeviceInfo(String key) => (StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.deviceInfoData)?[key] as String?)?.trim() ?? "";

  static String get deviceManufacturer => _getDeviceInfo('deviceManufacturer');

  static String get operatingSystem => _getDeviceInfo('operatingSystem');

  static String get deviceName => _getDeviceInfo('deviceName');

  static String get model => _getDeviceInfo('model');

  static String get modelName => _getDeviceInfo('modelName');

  static String get systemOSVersion => _getDeviceInfo('systemOSVersion');

  static String get identifierForVendor => _getDeviceInfo('identifierForVendor');
}

abstract final class AppInfoHelper {
  AppInfoHelper._();

  static Future<void> setAppInfoMetaData(Map<String, dynamic> appInfoMetaData) => StoragePrefs().lsWrite(
    key: StorageConstants.appInfoMetaData,
    value: <String, dynamic>{
      'appName': appInfoMetaData['appName'],
      'packageName': appInfoMetaData['packageName'],
      'version': appInfoMetaData['version'],
      'buildNumber': appInfoMetaData['buildNumber'],
    },
  );

  static String _getAppInfoMetaData(String key) => StoragePrefs().lsHasData(key: StorageConstants.appInfoMetaData)
      ? ((StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.appInfoMetaData)?[key] as String?)?.trim() ?? "")
      : "";

  static String get appName => _getAppInfoMetaData('appName');

  static String get packageName => _getAppInfoMetaData('packageName');

  static String get version => _getAppInfoMetaData('version');

  static String get buildNumber => _getAppInfoMetaData('buildNumber');
}

abstract final class DeviceGPSInfoHelper {
  DeviceGPSInfoHelper._();

  static Future<void> setGPSInfoData(Map<String, dynamic> gpsInfoData) => StoragePrefs().lsWrite(
    key: StorageConstants.gpsInfoData,
    value: <String, dynamic>{
      'latitude': gpsInfoData['latitude'],
      'longitude': gpsInfoData['longitude'],
      'altitude': gpsInfoData['altitude'],
      'street': gpsInfoData['street'],
      'subLocality': gpsInfoData['subLocality'],
      'locality': gpsInfoData['locality'],
      'city': gpsInfoData['city'],
      'postalCode': gpsInfoData['postalCode'],
      'state': gpsInfoData['state'],
      'country': gpsInfoData['country'],
    },
  );

  static String _getGPSInfo(String key) => (StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.gpsInfoData)?[key] as String?)?.trim() ?? "";

  static String get latitude => _getGPSInfo('latitude');

  static String get longitude => _getGPSInfo('longitude');

  static String get altitude => _getGPSInfo('altitude');

  static String get street => _getGPSInfo('street');

  static String get subLocality => _getGPSInfo('subLocality');

  static String get locality => _getGPSInfo('locality');

  static String get city => _getGPSInfo('city');

  static String get postalCode => _getGPSInfo('postalCode');

  static String get state => _getGPSInfo('state');

  static String get country => _getGPSInfo('country');
}

abstract final class DeviceIpAddressHelper {
  DeviceIpAddressHelper._();

  static Future<void> setIpAddressData(Map<String, dynamic> ipAddressData) => StoragePrefs().lsWrite(
    key: StorageConstants.ipAddressData,
    value: <String, dynamic>{
      'ip': ipAddressData['ip'],
      'city': ipAddressData['city'],
      'region': ipAddressData['region'],
      'country': ipAddressData['country'],
      'loc': ipAddressData['loc'],
      'org': ipAddressData['org'],
      'postal': ipAddressData['postal'],
      'timezone': ipAddressData['timezone'],
    },
  );

  static String _getIpAddressData(String key) => StoragePrefs().lsHasData(key: StorageConstants.ipAddressData)
      ? ((StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.ipAddressData)?[key] as String?)?.trim() ?? "")
      : "";

  static String get ip => _getIpAddressData('ip');

  static String get city => _getIpAddressData('city');

  static String get region => _getIpAddressData('region');

  static String get country => _getIpAddressData('country');

  static String get loc => _getIpAddressData('loc');

  static String get org => _getIpAddressData('org');

  static String get postal => _getIpAddressData('postal');

  static String get timezone => _getIpAddressData('timezone');
}
