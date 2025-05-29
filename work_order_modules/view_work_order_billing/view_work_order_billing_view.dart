// ignore_for_file: prefer_const_constructors

import 'package:aviation_rnd/modules/work_order_modules/view_work_order_billing/view_work_order_billing/view_work_order_billing_mobile.dart';
import 'package:aviation_rnd/modules/work_order_modules/view_work_order_billing/view_work_order_billing/view_work_order_billing_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'view_work_order_billing_logic.dart';

class ViewWorkOrderBillingPage extends StatelessWidget {
  const ViewWorkOrderBillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ViewWorkOrderBillingLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
                  portrait: (context) => ViewWorkOrderBillingMobilePortrait(),
                  landscape: (context) => ViewWorkOrderBillingMobileLandscape(),
                ),
            tablet: (context) => OrientationLayoutBuilder(
                  portrait: (context) => ViewWorkOrderBillingTablet(),
                  landscape: (context) => ViewWorkOrderBillingTablet(),
                )),
      ),
    );
  }
}
