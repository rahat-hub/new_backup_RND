import 'dart:ui';

import 'package:aviation_rnd/shared/services/device_orientation.dart' as orientation;
import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../widgets/appbar.dart';
import '../../../widgets/drawer_widgets.dart';
import '../dashboard_logic.dart';

class DashboardTablet extends GetView<DashboardLogic> {
  const DashboardTablet({super.key});

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
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(SizeConstants.boxRadius - 20),
                                    color: controller.isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.1),
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
                                ),
                              );
                            }),
                            if (orientation.DeviceOrientation.isLandscape && controller.dutyTimeInOutShow) controller.dutyTimeInOutButtonView(),
                            if (orientation.DeviceOrientation.isLandscape)
                              Obx(() {
                                return Material(
                                  elevation: 5,
                                  shadowColor: ColorConstants.yellow.withValues(alpha: 0.4),
                                  color: controller.isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius),
                                    side: BorderSide(width: 3, color: controller.isDark.value != true ? ColorConstants.primary : ColorConstants.black),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(SizeConstants.boxRadius - 20),
                                      color: controller.isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.1),
                                    ),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: controller.liveServerTimeViewReturn()),
                                  ),
                                );
                              }),
                            Obx(() => controller.themeSwitch()),
                          ],
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing - 5),
                        if (orientation.DeviceOrientation.isPortrait && controller.dutyTimeInOutShow)
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(SizeConstants.boxRadius - 20),
                                      color: controller.isDark.value != true ? ColorConstants.background.withValues(alpha: 0.4) : ColorConstants.background.withValues(alpha: 0.1),
                                    ),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: controller.liveServerTimeViewReturn()),
                                  ),
                                );
                              }),
                              controller.dutyTimeInOutButtonView(),
                            ],
                          ),
                        const SizedBox(height: SizeConstants.contentSpacing - 5),
                        //Mid Level & Bottom Level (1)
                        Expanded(child: controller.menuItemWidget(crossAxisItemCount: (Get.width / 210).round())),
                        //Only Bottom Level (2)
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
