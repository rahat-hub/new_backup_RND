// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'mel_edit/mel_edit_mobile.dart';
import 'mel_edit/mel_edit_tablet.dart';
import 'mel_edit_logic.dart';

class MelEditPage extends GetView<MelEditLogic> {
  const MelEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelEditLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelEditMobilePortrait(),
            landscape: (context) => MelEditMobileLandscape(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelEditTablet(),
            landscape: (context) => MelEditTablet(),
          ),
        ),
      ),
    );
  }
}
