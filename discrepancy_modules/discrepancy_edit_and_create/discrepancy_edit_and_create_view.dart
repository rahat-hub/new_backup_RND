// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'discrepancy_edit_and_create_logic.dart';
import 'discrepancy_edit_and_create_page/discrepancy_edit_and_create_view_page.dart';

class DiscrepancyEditAndCreatePage extends StatelessWidget {
  const DiscrepancyEditAndCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DiscrepancyEditAndCreateLogic>();
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => DiscrepancyEditAndCreateViewPage(),
            landscape: (context) => DiscrepancyEditAndCreateViewPage(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => DiscrepancyEditAndCreateViewPage(),
            landscape: (context) => DiscrepancyEditAndCreateViewPage(),
          ),
        ),
      ),
    );
  }
}
