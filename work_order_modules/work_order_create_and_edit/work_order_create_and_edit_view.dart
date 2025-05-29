// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/work_order_modules/work_order_create_and_edit/work_order_create_and_edit/work_order_create_and_edit_device_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'work_order_create_and_edit_logic.dart';

class WorkOrderCreateAndEditPage extends StatelessWidget {
  const WorkOrderCreateAndEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<WorkOrderCreateAndEditLogic>();
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder:
            (context, sizingInformation) => ScreenTypeLayout.builder(
              mobile:
                  (context) =>
                      OrientationLayoutBuilder(portrait: (context) => WorkOrderCreateAndEditDeviceView(), landscape: (context) => WorkOrderCreateAndEditDeviceView()),
              tablet:
                  (context) =>
                      OrientationLayoutBuilder(portrait: (context) => WorkOrderCreateAndEditDeviceView(), landscape: (context) => WorkOrderCreateAndEditDeviceView()),
            ),
      ),
    );
  }
}
