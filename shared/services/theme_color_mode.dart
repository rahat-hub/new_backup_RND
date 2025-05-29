import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:aviation_rnd/shared/constants/constant_storages.dart';
import 'package:aviation_rnd/shared/services/storage_prefs.dart';
import 'package:get/get.dart';

abstract class ThemeColorMode {
  /// Private constructor to hide the constructor.
  ThemeColorMode._();

  ///Get the current theme color mode
  static String get current => StoragePrefs().lsRead(key: StorageConstants.currentThemeMode);

  ///Returns true if the current theme color mode is light
  static bool get isLight => StoragePrefs().lsRead(key: StorageConstants.currentThemeMode) == "light";

  ///Returns true if the current theme color mode is dark
  static bool get isDark => StoragePrefs().lsRead(key: StorageConstants.currentThemeMode) == "dark";

  /// This is the logic for changing theme with status bar color for SWITCH
  /// Function for changing theme color
  static Future<void> setThemeColor(String themeColor) async {
    if (themeColor == "dark") {
      AdaptiveTheme.of(Get.context!).setDark();
      await StoragePrefs().lsWrite(key: StorageConstants.currentThemeMode, value: "dark");
    } else if (themeColor == "light") {
      AdaptiveTheme.of(Get.context!).setLight();
      await StoragePrefs().lsWrite(key: StorageConstants.currentThemeMode, value: "light");
    }
  }
}
