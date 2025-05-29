import 'dart:ui';

import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../shared/constants/constant_colors.dart';
import '../../../shared/utils/logged_in_data.dart';
import '../../../widgets/drawer_widgets.dart';
import '../dashboard_logic.dart';

class DashboardMobilePortrait extends GetView<DashboardLogic> {
  const DashboardMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DashboardLogic>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop && controller.onWillPop()) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: context,
          title: UserSessionInfo.systemName,
          textScrollForLongTitleMobile: true,
          centerTitle: true,
          menuEnable: true,
          backButtonEnable: false,
          actionEnable: true,
          actionTap: () async {
            await controller.logout();
          },
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerNavigationBar.headerDrawerNavigationBar(userName: UserSessionInfo.userFullName, imageText: UserSessionInfo.userFullName[0], userRole: UserSessionInfo.userRole),
              Obx(() {
                return Text(controller.currentServerTime.value);
              }),
              DrawerNavigationBar.pageDrawerNavigationBar(isBioEditPermission: controller.isBioEditPermission, biometricSignatureEnable: controller.biometricSignatureEnable),
            ],
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse
                ? Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/dash_board_background_image.png"), fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Top Level
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Obx(() {
                              return Material(
                                elevation: 5,
                                shadowColor: ColorConstants.yellow.withValues(alpha: 0.4),
                                color: controller.isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius),
                                  side: BorderSide(width: 3, color: controller.isDark.value != true ? ColorConstants.primary : ColorConstants.black),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                                        color: controller.isDark.value != true ? ColorConstants.primary : ColorConstants.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'User: ',
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 1),
                                        ),
                                        TextSpan(
                                          text: UserSessionInfo.userFullName,
                                          style: TextStyle(
                                            color: ColorConstants.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Obx(() => controller.themeSwitch()),
                          ],
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing - 5),
                        if (controller.dutyTimeInOutShow) Row(mainAxisAlignment: MainAxisAlignment.end, children: [Flexible(child: controller.dutyTimeInOutButtonView())]),
                        const SizedBox(height: SizeConstants.contentSpacing - 5), //Mid Level & Bottom Level (1)
                        Expanded(child: controller.menuItemWidget(crossAxisItemCount: (Get.width / 205).round())), //Only Bottom Level (2)
                      ],
                    ),
                  ),
                )
                : const SizedBox();
          }),
        ),
      ),
    );
  }
}

class DashboardMobileLandscape extends GetView<DashboardLogic> {
  const DashboardMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DashboardLogic>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop && controller.onWillPop()) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: context,
          title: UserSessionInfo.systemName,
          textScrollForLongTitleMobile: true,
          centerTitle: true,
          menuEnable: true,
          backButtonEnable: false,
          actionEnable: true,
          actionTap: () async {
            await controller.logout();
          },
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerNavigationBar.headerDrawerNavigationBar(userName: UserSessionInfo.userFullName, imageText: UserSessionInfo.userFullName[0], userRole: UserSessionInfo.userRole),
              DrawerNavigationBar.pageDrawerNavigationBar(isBioEditPermission: controller.isBioEditPermission, biometricSignatureEnable: controller.biometricSignatureEnable),
            ],
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.isFalse
                ? Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/dash_board_background_image.png"), fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Top Level
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Obx(() {
                              return Material(
                                elevation: 5,
                                shadowColor: ColorConstants.yellow.withValues(alpha: 0.4),
                                color: controller.isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius),
                                  side: BorderSide(width: 3, color: controller.isDark.value != true ? ColorConstants.primary : ColorConstants.black),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                                        color: controller.isDark.value != true ? ColorConstants.primary : ColorConstants.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'User: ',
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 1),
                                        ),
                                        TextSpan(
                                          text: UserSessionInfo.userFullName,
                                          style: TextStyle(
                                            color: ColorConstants.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(width: SizeConstants.contentSpacing * 4),
                            if (controller.dutyTimeInOutShow) controller.dutyTimeInOutButtonView(),
                            Obx(() => controller.themeSwitch()),
                          ],
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing), //Mid Level & Bottom Level (1)
                        Expanded(child: controller.menuItemWidget(crossAxisItemCount: (Get.width / 200).round())), //Only Bottom Level (2)
                      ],
                    ),
                  ),
                )
                : const SizedBox();
          }),
        ),
      ),
    );
  }
}
