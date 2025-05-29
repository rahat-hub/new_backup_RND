import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class DeviceType {
  /// Private constructor to hide the constructor.
  DeviceType._();

  /// Returns the current device type of the device.
  static DeviceScreenType deviceScreenType = getDeviceType(
    MediaQuery.of(Get.context!).size,
    const ScreenBreakpoints(desktop: 950 /*800*/, tablet: 600 /*550*/, watch: 300 /*200*/),
  );

  /// Returns the current device type of the device.
  static String get current => getDeviceType(MediaQuery.of(Get.context!).size, const ScreenBreakpoints(desktop: 950 /*800*/, tablet: 600 /*550*/, watch: 300 /*200*/)).name;

  /// Returns true if the device type is mobile.
  static bool get isMobile =>
      getDeviceType(MediaQuery.of(Get.context!).size, const ScreenBreakpoints(desktop: 950 /*800*/, tablet: 600 /*550*/, watch: 300 /*200*/)) == DeviceScreenType.mobile;

  /// Returns true if the device type is tablet.
  static bool get isTablet =>
      getDeviceType(MediaQuery.of(Get.context!).size, const ScreenBreakpoints(desktop: 950 /*800*/, tablet: 600 /*550*/, watch: 300 /*200*/)) == DeviceScreenType.tablet;

  /// Returns true if the device type is desktop.
  static bool get isDesktop =>
      getDeviceType(MediaQuery.of(Get.context!).size, const ScreenBreakpoints(desktop: 950 /*800*/, tablet: 600 /*550*/, watch: 300 /*200*/)) == DeviceScreenType.desktop;
}
