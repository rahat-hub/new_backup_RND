// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/splash/splash/splash_tablet.dart';
import 'package:aviation_rnd/modules/splash/splash_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../shared/services/keyboard.dart';
import 'Splash/splash_mobile.dart';

class SplashPage extends GetView<SplashLogic> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
              portrait: (context) => SplashMobilePortrait(),
              landscape: (context) => SplashMobileLandscape(),
            ),
            tablet: (context) => OrientationLayoutBuilder(
              portrait: (context) => SplashTablet(),
              landscape: (context) => SplashTablet(),
            ),
          );
        },
      ),
    );
  }
}
