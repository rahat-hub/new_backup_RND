// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/form_modules/view_user_form/view_user_form/view_user_form_mobile.dart';
import 'package:aviation_rnd/modules/form_modules/view_user_form/view_user_form/view_user_form_tablet.dart';
import 'package:aviation_rnd/modules/form_modules/view_user_form/view_user_form_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';

class ViewUserFormPage extends GetView<ViewUserFormLogic> {
  const ViewUserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ViewUserFormLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
                  portrait: (context) => ViewUserFormMobilePortrait(),
                  landscape: (context) => ViewUserFormMobileLandscape(),
                ),
            tablet: (context) => OrientationLayoutBuilder(
                  portrait: (context) => ViewUserFormTablet(),
                  landscape: (context) => ViewUserFormTablet(),
                )),
      ),
    );
  }
}
