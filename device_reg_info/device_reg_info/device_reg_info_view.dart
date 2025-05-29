// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'device_reg_info_logic.dart';
import 'device_reg_info_view/device_reg_info_view.dart';

class DeviceRegInfoPage extends GetView<DeviceRegInfoLogic> {
  const DeviceRegInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DeviceRegInfoLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder:
            (context, sizingInformation) => ScreenTypeLayout.builder(
              mobile: (context) => OrientationLayoutBuilder(portrait: (context) => DeviceRegInfoPageView(), landscape: (context) => DeviceRegInfoPageView()),
              tablet: (context) => OrientationLayoutBuilder(portrait: (context) => DeviceRegInfoPageView(), landscape: (context) => DeviceRegInfoPageView()),
            ),
      ),
    );
  }
}
