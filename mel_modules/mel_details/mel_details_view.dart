// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'mel_details/mel_details_view.dart';
import 'mel_details_logic.dart';

class MelDetailsPage extends GetView<MelDetailsLogic> {
  const MelDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelDetailsLogic>();
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelDetailsView(),
            landscape: (context) => MelDetailsView(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelDetailsView(),
            landscape: (context) => MelDetailsView(),
          ),
        ),
      ),
    );
  }
}
