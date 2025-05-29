// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/discrepancy_modules/discrepancy_index/discrepancy_index/discrepancy_index_device_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'discrepancy_index_logic.dart';

class DiscrepancyIndexPage extends GetView<DiscrepancyIndexLogic> {
  const DiscrepancyIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DiscrepancyIndexLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => DiscrepancyIndexDeviceView(),
            landscape: (context) => DiscrepancyIndexDeviceView(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => DiscrepancyIndexDeviceView(),
            landscape: (context) => DiscrepancyIndexDeviceView(),
          ),
        ),
      ),
    );
  }
}
