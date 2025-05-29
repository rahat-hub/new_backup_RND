// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/sign_in/sign_in/sign_in_mobile.dart';
import 'package:aviation_rnd/modules/sign_in/sign_in/sign_in_tablet.dart';
import 'package:aviation_rnd/modules/sign_in/sign_in_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../shared/services/keyboard.dart';

class SignInPage extends GetView<SignInLogic> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SignInLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => SignInMobilePortrait(),
            landscape: (context) => SignInMobileLandscape(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => SignInTablet(),
            landscape: (context) => SignInTablet(),
          ),
        ),
      ),
    );
  }
}
