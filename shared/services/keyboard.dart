import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class Keyboard {
  /// Private constructor to hide the constructor.
  Keyboard._();

  /// Returns the current status of the keyboard.
  static String get currentStatus => Get.mediaQuery.viewInsets.bottom.isEqual(0) ? "closed" : "open";

  /// Returns true if the keyboard is open.
  static bool get isOpen => Get.mediaQuery.viewInsets.bottom.isGreaterThan(0);

  /// Returns true if the keyboard is closed.
  static bool get isClose => Get.mediaQuery.viewInsets.bottom.isEqual(0);

  /// Close the keyboard.
  static void get closed => FocusManager.instance.primaryFocus?.unfocus();

  /// Close the keyboard.
  static void close({BuildContext? context}) {
    context != null ? FocusScope.of(context).unfocus() : FocusManager.instance.primaryFocus?.unfocus();
    //Get.focusScope?.unfocus();
  }
}
