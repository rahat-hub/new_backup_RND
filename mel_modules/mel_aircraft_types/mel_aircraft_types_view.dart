// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'mel_aircraft_types/mel_aircraft_types_device_view.dart';
import 'mel_aircraft_types_logic.dart';

class MelAircraftTypesPage extends GetView<MelAircraftTypesLogic> {
  const MelAircraftTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MelAircraftTypesLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelAircraftTypesDeviceView(),
            landscape: (context) => MelAircraftTypesDeviceView(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => MelAircraftTypesDeviceView(),
            landscape: (context) => MelAircraftTypesDeviceView(),
          ),
        ),
      ),
    );
  }
}
