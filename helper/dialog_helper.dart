import 'dart:ui';

import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DialogHelper {
  DialogHelper._();

  //Siam's block START
  // -------------> start here to code

  static Future<void> openCommonDialogBox({
    BuildContext? context,
    bool enableWidget = false,
    List<Widget> children = const <Widget>[],
    String message = "Coming soon...",
    bool centerTitle = false,
    String title = "Message",
    String? widgetButtonTitle,
    void Function()? onTap,
  }) => showDialog<void>(
    useRootNavigator: false,
    context: context ?? Get.context!,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
            side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
          ),
          title: centerTitle
              ? Center(child: Text(title, style: Theme.of(Get.context!).textTheme.headlineLarge))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineLarge!.fontSize! - 3, letterSpacing: 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: InkWell(
                        child: const Icon(Icons.cancel, size: 30, color: Colors.red),
                        onTap: () => Get.back(closeOverlays: true),
                      ),
                    ),
                  ],
                ),
          titlePadding: const EdgeInsets.only(left: 12, top: 5, right: 5, bottom: 5),
          content: enableWidget
              ? SingleChildScrollView(child: Column(children: children))
              : Text(message, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.bodyLarge!.fontSize, letterSpacing: 2)),
          actions: <Widget>[
            ButtonConstant.dialogButton(
              title: enableWidget ? "Cancel" : "Close",
              borderColor: ColorConstants.red,
              btnColor: ColorConstants.white,
              textColor: ColorConstants.black,
              onTapMethod: () => Get.back(closeOverlays: true),
            ),
            if (enableWidget) ButtonConstant.dialogButton(title: widgetButtonTitle, borderColor: ColorConstants.green, onTapMethod: onTap),
          ],
        ),
      ),
    ),
  );

  //Siam's block END

  //Surjit's block START
  // -------------> start here to code

  static Future<void> flightLogDialogBox({
    required Widget child,
    BuildContext? context,
    void Function()? onCancel,
    void Function()? onAnotherButton,
    String? anotherButtonTitle,
    String cancelButtonTitle = "Cancel",
    Color anotherBtnColor = ColorConstants.button,
    String? dialogTitle,
    Color? dialogTitleColor,
    Color? backgroundColor,
    bool centerTitle = false,
    bool scrollable = false,
  }) => showDialog<void>(
    useSafeArea: false,
    useRootNavigator: false,
    context: context ?? Get.context!,
    builder: (BuildContext context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        elevation: 10,
        scrollable: scrollable,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
          side: const BorderSide(color: ColorConstants.primary, width: 2),
        ),
        title: Text(dialogTitle ?? "", textAlign: centerTitle ? TextAlign.center : null),
        titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        titleTextStyle: TextStyle(
          color: dialogTitleColor ?? (ThemeColorMode.isLight ? ColorConstants.black : null),
          fontSize: Theme.of(Get.context!).textTheme.headlineLarge!.fontSize! - 3,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: ThemeColorMode.isLight ? ColorConstants.black : null,
          fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        content: child,
        actions: (DeviceType.isMobile && DeviceOrientation.isLandscape && Keyboard.isOpen)
            ? null
            : <Widget>[
                ButtonConstant.dialogButton(title: cancelButtonTitle, borderColor: ColorConstants.red, onTapMethod: onCancel),
                if (anotherButtonTitle != null) ButtonConstant.dialogButton(title: anotherButtonTitle, borderColor: anotherBtnColor, onTapMethod: onAnotherButton),
              ],
      ),
    ),
  );

  //Surjit's block END
}
