// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'mel_index/mel_index_device_view.dart';
import 'mel_index_logic.dart';

class MelIndexPage extends GetView<MelIndexLogic> {
  const MelIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelIndexLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelIndexDeviceView(),
            landscape: (context) => MelIndexDeviceView(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelIndexDeviceView(),
            landscape: (context) => MelIndexDeviceView(),
          ),
        ),
      ),
    );
  }
}
