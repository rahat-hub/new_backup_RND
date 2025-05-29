// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/shared/services/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'discrepancy_details_new_logic.dart';
import 'discrepancy_details_new_page/discrepancy_details_new_view_page.dart';

class DiscrepancyDetailsNewPage extends GetView<DiscrepancyDetailsNewLogic> {
  const DiscrepancyDetailsNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DiscrepancyDetailsNewLogic>();
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => DiscrepancyDetailsNewViewPage(),
            landscape: (context) => DiscrepancyDetailsNewViewPage(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => DiscrepancyDetailsNewViewPage(),
            landscape: (context) => DiscrepancyDetailsNewViewPage(),
          ),
        ),
      ),
    );
  }
}
