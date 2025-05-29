// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'fill_out_form/fill_out_form_mobile.dart';
import 'fill_out_form/fill_out_form_tablet.dart';
import 'fill_out_form_logic.dart';

class FillOutFormPage extends GetView<FillOutFormLogic> {
  const FillOutFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FillOutFormLogic>();
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
                  portrait: (context) => FillOutFormMobilePortrait(),
                  landscape: (context) => FillOutFormMobileLandscape(),
                ),
            tablet: (context) => OrientationLayoutBuilder(
                  portrait: (context) => FillOutFormTablet(),
                  landscape: (context) => FillOutFormTablet(),
                )),
      ),
    );
  }
}
