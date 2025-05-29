import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

abstract class AppbarConstant {
  static customAppBar({
    required BuildContext? context,
    bool isDynamicTitle = false,
    Widget? dynamicTitle,
    String? title,
    bool centerTitle = true,
    bool textScrollForLongTitleMobile = false,
    bool menuEnable = false,
    bool backButtonEnable = true,
    void Function()? backTap,
    bool actionEnable = false,
    void Function()? actionTap,
  }) {
    if (DeviceOrientation.isLandscape && Keyboard.isOpen) {
      return null;
    } else {
      return AppBar(
          backgroundColor: Theme.of(context ?? Get.context!).colorScheme.surface,
          leading: !menuEnable && backButtonEnable
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: InkWell(
                    radius: 60,
                    borderRadius: BorderRadius.circular(50),
                    onTap: backTap,
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back, color: ThemeColorMode.isLight ? ColorConstants.black : null, size: 28),
                    ),
                  ),
                )
              : menuEnable
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: Builder(builder: (context) {
                        return InkWell(
                          radius: 60,
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: const Icon(Icons.menu, color: ColorConstants.primary, size: 28),
                          ),
                        );
                      }),
                    )
                  : const SizedBox(),
          actions: [
            if (actionEnable)
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                child: InkWell(
                  radius: 60,
                  borderRadius: BorderRadius.circular(50),
                  onTap: actionTap,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 8),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(Icons.logout, color: ColorConstants.red, size: 28),
                  ),
                ),
              )
          ],
          title: isDynamicTitle
              ? dynamicTitle
              : textScrollForLongTitleMobile
                  ? TextScroll((title ?? "").trim(),
                      velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                      delayBefore: const Duration(milliseconds: 1500),
                      pauseBetween: const Duration(milliseconds: 500),
                      numberOfReps: 5,
                      intervalSpaces: 5,
                      style: Theme.of(context ?? Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(context ?? Get.context!).textTheme.displayMedium!.fontSize))
                  : Text(title ?? "",
                      style:
                          Theme.of(context ?? Get.context!).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(context ?? Get.context!).textTheme.displayMedium!.fontSize!) + 5)),
          centerTitle: centerTitle,
          elevation: 3,
          shadowColor: Theme.of(context ?? Get.context!).shadowColor);
    }
  }
}
