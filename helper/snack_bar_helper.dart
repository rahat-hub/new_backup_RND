import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

abstract class SnackBarHelper {
  SnackBarHelper._();

  static Future<void> openSnackBar({int? durationInSec, String? title, String? message, bool isError = false, bool isComplete = false, bool isWarning = false}) async {
    if (Get.isSnackbarOpen) {
      await Future<void>.delayed(const Duration(milliseconds: 500), Get.closeCurrentSnackbar);
    }

    if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      Get.rawSnackbar(
        duration: Duration(seconds: durationInSec ?? 3),
        titleText: title != null ? Text(title, style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: 18, color: ColorConstants.white)) : null,
        messageText: message != null ? Text(message, style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: 16, color: ColorConstants.white)) : null,
        backgroundColor: isError
            ? ColorConstants.red
            : isComplete
            ? ColorConstants.button
            : isWarning
            ? ColorConstants.yellow
            : ColorConstants.primary,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.rawSnackbar(
          duration: Duration(seconds: durationInSec ?? 3),
          titleText: title != null ? Text(title, style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: 18, color: ColorConstants.white)) : null,
          messageText: message != null ? Text(message, style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: 16, color: ColorConstants.white)) : null,
          backgroundColor: isError
              ? ColorConstants.red
              : isComplete
              ? ColorConstants.button
              : isWarning
              ? ColorConstants.yellow
              : ColorConstants.primary,
        );
      });
    }
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> scaffoldSnackBar({required String message, BuildContext? context}) =>
      ScaffoldMessenger.of(context ?? Get.context!).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}
