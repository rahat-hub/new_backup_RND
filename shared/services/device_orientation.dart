import 'package:flutter/services.dart' as services;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class DeviceOrientation {
  DeviceOrientation._();

  /// Returns the current orientation of the device.
  static String get current => Get.mediaQuery.orientation.name;

  /// Returns true if the device orientation is portrait.
  static bool get isPortrait => Get.mediaQuery.orientation == Orientation.portrait;

  /// Returns true if the device orientation is landscape.
  static bool get isLandscape => Get.mediaQuery.orientation == Orientation.landscape;

  /// Change the current orientation of the device. Use ["All", "Standard", "Portrait", "Landscape"] as mode.
  static Future<void> changeTo({required String mode}) async {
    if (mode.toLowerCase() == "all") {
      await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[
        services.DeviceOrientation.portraitUp,
        services.DeviceOrientation.portraitDown,
        services.DeviceOrientation.landscapeLeft,
        services.DeviceOrientation.landscapeRight,
      ]);
    } else if (mode.toLowerCase() == "standard") {
      await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[
        services.DeviceOrientation.portraitUp,
        services.DeviceOrientation.landscapeLeft,
        services.DeviceOrientation.landscapeRight,
      ]);
    } else if (mode.toLowerCase() == "portrait") {
      await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[services.DeviceOrientation.portraitUp, services.DeviceOrientation.portraitDown]);
    } else if (mode.toLowerCase() == "landscape") {
      await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[services.DeviceOrientation.landscapeLeft, services.DeviceOrientation.landscapeRight]);
    }
  }

  /// Change the current orientation of the device to all.
  static Future<void> changeToAll() async {
    await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[
      services.DeviceOrientation.portraitUp,
      services.DeviceOrientation.portraitDown,
      services.DeviceOrientation.landscapeLeft,
      services.DeviceOrientation.landscapeRight,
    ]);
  }

  /// Change the current orientation of the device to all except Portrait Down.
  static Future<void> changeToAllExceptDown() async {
    await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[
      services.DeviceOrientation.portraitUp,
      services.DeviceOrientation.landscapeLeft,
      services.DeviceOrientation.landscapeRight,
    ]);
  }

  /// Change the current orientation of the device to only Portrait up.
  static Future<void> changeToOnlyPortraitUp() async {
    await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[services.DeviceOrientation.portraitUp]);
  }

  /// Change the current orientation of the device to only Portrait.
  static Future<void> changeToOnlyPortrait() async {
    await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[services.DeviceOrientation.portraitUp, services.DeviceOrientation.portraitDown]);
  }

  /// Change the current orientation of the device to only Landscape.
  static Future<void> changeToLandscape() async {
    await services.SystemChrome.setPreferredOrientations(<services.DeviceOrientation>[services.DeviceOrientation.landscapeLeft, services.DeviceOrientation.landscapeRight]);
  }
}
