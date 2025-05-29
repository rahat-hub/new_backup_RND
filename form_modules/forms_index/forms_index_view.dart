// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/form_modules/forms_index/forms_index_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'forms_index/forms_index_mobile.dart';
import 'forms_index/forms_index_tablet.dart';

class FormsIndexPage extends GetView<FormsIndexLogic> {
  const FormsIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FormsIndexLogic>();
    return GestureDetector(
      onTap: () {
        Keyboard.close(context: context);
        controller.disableKeyboard.value = true;
      },
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => FormsIndexMobilePortrait(),
            landscape: (context) => FormsIndexMobileLandscape(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => ViewFormIndexTablet(),
            landscape: (context) => ViewFormIndexTablet(),
          ),
        ),
      ),
    );
  }
}
