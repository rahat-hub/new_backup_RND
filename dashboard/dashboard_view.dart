// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/shared/services/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'dashboard/dashboard_mobile.dart';
import 'dashboard/dashboard_tablet.dart';
import 'dashboard_logic.dart';

class DashboardPage extends GetView<DashboardLogic> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DashboardLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
              portrait: (context) => DashboardMobilePortrait(),
              landscape: (context) => DashboardMobileLandscape(),
            ),
            tablet: (context) => OrientationLayoutBuilder(
              portrait: (context) => DashboardTablet(),
              landscape: (context) => DashboardTablet(),
            ),
          );
        },
      ),
    );
  }
}
