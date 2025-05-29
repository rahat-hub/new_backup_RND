import 'dart:convert';

import 'package:aviation_rnd/shared/constants/constants.dart';
import 'package:aviation_rnd/shared/services/storage_prefs.dart';

abstract class LoggedInData {
  /// This is a private constructor.
  LoggedInData._();

  /// Get Login Token
  static Future<String> token() async => jsonEncode(await StoragePrefs().ssRead(key: StorageConstants.token));

  /// Logged in user session data
  static String userSessionData() => jsonEncode(StoragePrefs().lsRead(key: StorageConstants.userSessionData));

  /// Logged in user info data
  static String userInfo() => jsonEncode(StoragePrefs().lsRead(key: StorageConstants.userInfo));

  /// Logged in user permission data
  static String userPermissionData() => jsonEncode(StoragePrefs().lsRead(key: StorageConstants.userPermissionData));
}

abstract final class UserSessionInfo {
  /// This is a private constructor.
  UserSessionInfo._();

  static Future<void> setToken(String token) => StoragePrefs().ssWrite(key: StorageConstants.token, value: token);

  static Future<void> setUserInfo(Map<String, dynamic> userInfoData) => StoragePrefs().lsWrite(
    key: StorageConstants.userInfo,
    value: <String, dynamic>{
      "userId": userInfoData["userId"].toString(),
      "empId": userInfoData["empId"],
      "userName": userInfoData["userName"],
      "roleTitle": userInfoData["roleTitle"],
      "systemId": userInfoData["systemId"].toString(),
      "systemName": userInfoData["systemName"],
    },
  );

  static Future<void> setSessionData(Map<String, dynamic> userSessionData) => StoragePrefs().lsWrite(key: StorageConstants.userSessionData, value: userSessionData);

  static String _getUserInfo(String key) => (StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.userInfo)?[key] as String?)?.trim() ?? "";

  static String _getSessionData(String key) => (StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.userSessionData)?[key] as String?)?.trim() ?? "";

  static Future<String?> get token => StoragePrefs().ssRead(key: StorageConstants.token);

  static String get userLoginId => _getUserInfo("empId");

  static int get userId => int.tryParse(_getUserInfo("userId")) ?? 0;

  static String get userFullName => _getUserInfo("userName");

  static String get userFirstName => _getSessionData("firstName");

  static String get userLastName => _getSessionData("lastName");

  static String get userEmail => _getSessionData("email");

  static String get userContactPhone => _getSessionData("contactPhone");

  static String get userRole => _getUserInfo("roleTitle");

  static int get systemId => int.tryParse(_getUserInfo("systemId")) ?? 0;

  static String get systemName => _getUserInfo("systemName");

  static String get systemLogo1 => "/Downloaded_Files/${_getSessionData("strLogo1")}";

  static String get systemLogo2 => "/Downloaded_Files/${_getSessionData("strLogo2")}";

  static Map<String, String> get all => <String, String>{
    "userId": userId.toString(),
    "empId": userLoginId,
    "userName": userFullName,
    "roleTitle": userRole,
    "systemId": systemId.toString(),
    "systemName": systemName,
    "firstName": userFirstName,
    "lastName": userLastName,
    "email": userEmail,
    "contactPhone": userContactPhone,
  };
}
