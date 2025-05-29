import 'dart:io';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/provider/work_orders_api_provider.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../routes/app_pages.dart';
import '../work_order_details_logic.dart';

class Demographics extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const Demographics({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    String contactPhone = UserSessionInfo.userContactPhone;

    aircraftValueDataTableLoad() {
      List tableHeaderName = [controller.demographicsTabData['discrepancyEquipmentType'], 'Starting', 'Ending'];

      List tableRowDataValues = [];

      if (controller.demographicsTabData['startACTT'] > 0 || controller.demographicsTabData['endACTT'] > 0) {
        tableRowDataValues.add({
          'title': 'ACTT',
          'starting': controller.demographicsTabData['startACTT'].toString(),
          'ending': controller.demographicsTabData['endACTT'].toString(),
        });
      }

      if (controller.demographicsTabData['startHobbs'] > 0 || controller.demographicsTabData['endHobbs'] > 0) {
        tableRowDataValues.add({
          'title': 'Hobbs',
          'starting': controller.demographicsTabData['startHobbs'].toString(),
          'ending': controller.demographicsTabData['endHobbs'].toString(),
        });
      }

      if (controller.demographicsTabData['startHobbsBillable'] > 0 || controller.demographicsTabData['endHobbsBillable'] > 0) {
        tableRowDataValues.add({
          'title': 'Hobbs - Billable',
          'starting': controller.demographicsTabData['startHobbsBillable'].toString(),
          'ending': controller.demographicsTabData['endHobbsBillable'].toString(),
        });
      }

      if (controller.demographicsTabData['startTorqueEvents'] > 0 || controller.demographicsTabData['endTorqueEvents'] > 0) {
        tableRowDataValues.add({
          'title': 'Torque Events',
          'starting': controller.demographicsTabData['startTorqueEvents'].toString(),
          'ending': controller.demographicsTabData['endTorqueEvents'].toString(),
        });
      }

      if (controller.demographicsTabData['startLandings'] > 0 || controller.demographicsTabData['endLandings'] > 0) {
        tableRowDataValues.add({
          'title': 'Landings',
          'starting': controller.demographicsTabData['startLandings'].toString(),
          'ending': controller.demographicsTabData['endLandings'].toString(),
        });
      }

      if (controller.demographicsTabData['startRunOnLandings'] > 0 || controller.demographicsTabData['endRunOnLandings'] > 0) {
        tableRowDataValues.add({
          'title': 'Run On Landings',
          'starting': controller.demographicsTabData['startRunOnLandings'].toString(),
          'ending': controller.demographicsTabData['endRunOnLandings'].toString(),
        });
      }

      if (controller.demographicsTabData['startAuxHobbs'] > 0 || controller.demographicsTabData['endAuxHobbs'] > 0) {
        tableRowDataValues.add({
          'title': 'Aux Hobbs',
          'starting': controller.demographicsTabData['startAuxHobbs'].toString(),
          'ending': controller.demographicsTabData['endAuxHobbs'].toString(),
        });
      }

      if (controller.demographicsTabData['startEngine1TT'] > 0 || controller.demographicsTabData['endEngine1TT'] > 0) {
        tableRowDataValues.add({
          'title': 'Engine 1 TT',
          'starting': controller.demographicsTabData['startEngine1TT'].toString(),
          'ending': controller.demographicsTabData['endEngine1TT'].toString(),
        });
      }

      if (controller.demographicsTabData['startEngine1Starts'] > 0 || controller.demographicsTabData['endEngine1Starts'] > 0) {
        tableRowDataValues.add({
          'title': 'Engine 1 Starts',
          'starting': controller.demographicsTabData['startEngine1Starts'].toString(),
          'ending': controller.demographicsTabData['endEngine1Starts'].toString(),
        });
      }

      if (controller.workOrderDetailsFullData['engineNpShown'] == true &&
          (controller.demographicsTabData['startNPCycles'] > 0 || controller.demographicsTabData['endNPCycles'] > 0)) {
        tableRowDataValues.add({
          'title': controller.workOrderDetailsFullData['engineNpName'],
          'starting': controller.demographicsTabData['startNPCycles'].toString(),
          'ending': controller.demographicsTabData['endNPCycles'].toString(),
        });
      }

      if (controller.workOrderDetailsFullData['engineNg2Shown'] == true &&
          (controller.demographicsTabData['startEngine1NG2'] > 0 || controller.demographicsTabData['endEngine1NG2'] > 0)) {
        tableRowDataValues.add({
          'title': controller.workOrderDetailsFullData['engineNg2Name'],
          'starting': controller.demographicsTabData['startEngine1NG2'].toString(),
          'ending': controller.demographicsTabData['endEngine1NG2'].toString(),
        });
      }

      if (controller.demographicsTabData['startEngine1Flights'] > 0 || controller.demographicsTabData['endEngine1Flights'] > 0) {
        tableRowDataValues.add({
          'title': 'Engine 1 Flights',
          'starting': controller.demographicsTabData['startEngine1Flights'].toString(),
          'ending': controller.demographicsTabData['endEngine1Flights'].toString(),
        });
      }

      if (controller.workOrderDetailsFullData['engineCyclesShown'] == true &&
          (controller.demographicsTabData['startEngine1Cycles'] > 0 || controller.demographicsTabData['endEngine1Cycles'] > 0)) {
        tableRowDataValues.add({
          'title': 'Engine 1 Cycles',
          'starting': controller.demographicsTabData['startEngine1Cycles'].toString(),
          'ending': controller.demographicsTabData['endEngine1Cycles'].toString(),
        });
      }

      if (controller.demographicsTabData['startEngine1CreepDamagePercentage'] > 0 || controller.demographicsTabData['endEngine1CreepDamagePercentage'] > 0) {
        tableRowDataValues.add({
          'title': 'Engine 1 Creep %',
          'starting': controller.demographicsTabData['startEngine1CreepDamagePercentage'].toString(),
          'ending': controller.demographicsTabData['endEngine1CreepDamagePercentage'].toString(),
        });
      }

      if (controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2TT'] > 0 || controller.demographicsTabData['endEngine2TT'] > 0)) {
        tableRowDataValues.add({
          'title': 'Engine 2 TT',
          'starting': controller.demographicsTabData['startEngine2TT'].toString(),
          'ending': controller.demographicsTabData['endEngine2TT'].toString(),
        });
      }

      if (controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2Starts'] > 0 || controller.demographicsTabData['endEngine2Starts'] > 0)) {
        tableRowDataValues.add({
          'title': 'Engine 2 Starts',
          'starting': controller.demographicsTabData['startEngine2Starts'].toString(),
          'ending': controller.demographicsTabData['endEngine2Starts'].toString(),
        });
      }

      if (controller.workOrderDetailsFullData['engineNpShown'] == true &&
          controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startNPCycles2'] > 0 || controller.demographicsTabData['endNPCycles2'] > 0)) {
        tableRowDataValues.add({
          'title': controller.workOrderDetailsFullData['engineNpName'],
          'starting': controller.demographicsTabData['startNPCycles2'].toString(),
          'ending': controller.demographicsTabData['endNPCycles2'].toString(),
        });
      }

      if (controller.workOrderDetailsFullData['engineNpShown'] == true &&
          controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2NG2'] > 0 || controller.demographicsTabData['endEngine2NG2'] > 0)) {
        tableRowDataValues.add({
          'title': controller.workOrderDetailsFullData['engineNg2Name'],
          'starting': controller.demographicsTabData['startEngine2NG2'].toString(),
          'ending': controller.demographicsTabData['endEngine2NG2'].toString(),
        });
      }

      if (controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2NG2'] > 0 || controller.demographicsTabData['endEngine2NG2'] > 0)) {
        tableRowDataValues.add({
          'title': controller.workOrderDetailsFullData['engineNg2Name'],
          'starting': controller.demographicsTabData['startEngine2NG2'].toString(),
          'ending': controller.demographicsTabData['endEngine2NG2'].toString(),
        });
      }

      if (controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2Flights'] > 0 || controller.demographicsTabData['endEngine2Flights'] > 0)) {
        tableRowDataValues.add({
          'title': 'Engine 2 Flights',
          'starting': controller.demographicsTabData['startEngine2Flights'].toString(),
          'ending': controller.demographicsTabData['endEngine2Flights'].toString(),
        });
      }

      if (controller.workOrderDetailsFullData['engineCyclesShown'] == true &&
          controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2Cycles'] > 0 || controller.demographicsTabData['endEngine2Cycles'] > 0)) {
        tableRowDataValues.add({
          'title': 'Engine 2 Cycles',
          'starting': controller.demographicsTabData['startEngine2Cycles'].toString(),
          'ending': controller.demographicsTabData['endEngine2Cycles'].toString(),
        });
      }

      if (controller.demographicsTabData['engine2Enabled'] == 1 &&
          (controller.demographicsTabData['startEngine2CreepDamagePercentage'] > 0 || controller.demographicsTabData['endEngine2CreepDamagePercentage'] > 0)) {
        tableRowDataValues.add({
          'title': 'Engine 2 Creep %',
          'starting': controller.demographicsTabData['startEngine2CreepDamagePercentage'].toString(),
          'ending': controller.demographicsTabData['endEngine2CreepDamagePercentage'].toString(),
        });
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DataTable(
            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
            border: TableBorder.all(
              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
            ),
            clipBehavior: Clip.antiAlias,
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    tableHeaderName[0],
                    style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
                        .of(Get.context!)
                        .textTheme
                        .headlineMedium
                        ?.fontSize),
                  ),
                ),
              ),
            ],
            rows: List.generate(tableRowDataValues.length, (index) {
              return DataRow(
                color:
                index % 2 == 0
                    ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                    : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                cells: [
                  DataCell(
                    Text(
                      tableRowDataValues[index]['title'],
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: Theme
                          .of(Get.context!)
                          .textTheme
                          .headlineMedium!
                          .fontSize! - 1),
                    ),
                  ),
                ],
              );
            }),
          ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                // border: TableBorder(
                //   top: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                //   right: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                //   bottom: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                //   horizontalInside: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                //   verticalInside: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                //   borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                // ),
                border: TableBorder.all(
                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                ),
                clipBehavior: Clip.antiAlias,
                columns: [
                  DataColumn(
                    label: Center(
                      child: Text(
                        tableHeaderName[1],
                        style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
                            .of(Get.context!)
                            .textTheme
                            .headlineMedium
                            ?.fontSize),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        tableHeaderName[2],
                        style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
                            .of(Get.context!)
                            .textTheme
                            .headlineMedium
                            ?.fontSize),
                      ),
                    ),
                  ),
                ],
                rows: List.generate(tableRowDataValues.length, (index) {
                  return DataRow(
                    color:
                    index % 2 == 0
                        ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                        : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            tableRowDataValues[index]['starting'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium!
                                .fontSize! - 1),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            tableRowDataValues[index]['ending'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium!
                                .fontSize! - 1),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                //crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 5.0,
                runSpacing: 5.0,
                children: [
                  Row(
                    spacing: 5.0,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Bill Form: ',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: UserSessionInfo.systemName,
                              style: TextStyle(
                                color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium
                                    ?.fontSize,
                              ),
                              children: <TextSpan>[],
                            ),
                          ),
                          if (controller.demographicsTabData['serviceAddress1']
                              .toString()
                              .isNotNullOrEmpty)
                            RichText(
                              text: TextSpan(
                                text: controller.demographicsTabData['serviceAddress1'],
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                          if (controller.demographicsTabData['serviceAddress2']
                              .toString()
                              .isNotNullOrEmpty)
                            RichText(
                              text: TextSpan(
                                text: controller.demographicsTabData['serviceAddress2'],
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                          if (controller.demographicsTabData['serviceAddress3']
                              .toString()
                              .isNotNullOrEmpty)
                            RichText(
                              text: TextSpan(
                                text: controller.demographicsTabData['serviceAddress3'],
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! + 1,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                          if (controller.demographicsTabData['serviceAddress4']
                              .toString()
                              .isNotNullOrEmpty)
                            RichText(
                              text: TextSpan(
                                text: controller.demographicsTabData['serviceAddress4'],
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! + 1,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                          if (contactPhone.isNotEmpty && contactPhone != '000.000.0000' && contactPhone != '(000)-000-0000')
                            RichText(
                              text: TextSpan(
                                text: contactPhone,
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Date: ',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: DateFormat('EEEE, MMMM d, y').format(DateTime.parse(controller.demographicsTabData['createdAt'] ?? '')),
                              style: TextStyle(
                                color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize! + 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 5.0,
                runSpacing: 5.0,
                children: [
                  if (controller.demographicsTabData['status'] != 'Completed')
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: MaterialCommunityIcons.file_document_edit_outline,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: 'Edit Bill To Information',
                      borderColor: ColorConstants.black,
                      onPressed: () async {
                        LoaderHelper.loaderWithGifAndText('Loading...');
                        await controller.billingInformationApiCall();
                        await updateWorkOrderBillingInformationDialog(context: Get.context);
                      },
                    ),
                  Row(
                    spacing: 5.0,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Bill To: ',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                      Column(
                        children: [
                          if (controller.demographicsTabData['woBillingTitle'].toString().isNotNullOrEmpty)
                            RichText(
                              text: TextSpan(
                                text: controller.demographicsTabData['woBillingTitle'],
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                ),
                                children: <TextSpan>[
                                  if (controller.demographicsTabData['woBillingAddress1'].toString().isNotNullOrEmpty)
                                    TextSpan(
                                      text: ',\t${controller.demographicsTabData['woBillingAddress1']}\n',
                                      style: TextStyle(
                                        color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
                                      ),
                                    ),
                                  if (controller.demographicsTabData['woBillingAddress2']
                                      .toString()
                                      .isNotNullOrEmpty)
                                    TextSpan(
                                      text: '${controller.demographicsTabData['woBillingAddress2']}\n',
                                      style: TextStyle(
                                        color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
                                      ),
                                    ),
                                  if (controller.demographicsTabData['woBillingPhone']
                                      .toString()
                                      .isNotNullOrEmpty)
                                    TextSpan(
                                      text: '${controller.demographicsTabData['woBillingPhone']}\n',
                                      style: TextStyle(
                                        color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
                                      ),
                                    ),
                                  if (controller.demographicsTabData['woBillingEmail']
                                      .toString()
                                      .isNotNullOrEmpty)
                                    TextSpan(
                                      text: '${controller.demographicsTabData['woBillingEmail']}\n',
                                      style: TextStyle(
                                        color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
                                      ),
                                    ),
                                  if (controller.demographicsTabData['woBillingCountry']
                                      .toString()
                                      .isNotNullOrEmpty)
                                    TextSpan(
                                      text: '${controller.demographicsTabData['woBillingCountry']}',
                                      style: TextStyle(
                                        color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                        fontSize: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .headlineMedium
                                            ?.fontSize,
                                      ),
                                    ),
                                ],
                              ),
                            )
                          else
                            RichText(
                              text: TextSpan(
                                text: 'No Billing Recipient Selected',
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (controller.demographicsTabData['discrepancyType'] == 0)
                    aircraftValueDataTableLoad()
                  else
                    Row(
                      spacing: 5.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Equipment: ',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.demographicsTabData['discrepancyEquipmentType'],
                                style: TextStyle(
                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 5.0,
                runSpacing: 5.0,
                children: [
                  DiscrepancyAndWorkOrdersMaterialButton(
                    icon: MaterialCommunityIcons.file_document_edit_outline,
                    iconColor: ColorConstants.white,
                    buttonColor: ColorConstants.primary,
                    buttonText: 'View / Edit Discrepancy',
                    borderColor: ColorConstants.black,
                    onPressed: () {
                      Get.toNamed(Routes.discrepancyDetailsNew,
                          arguments: controller.workOrderId.toString(), parameters: {"discrepancyId": controller.workOrderId.toString(), "routeForm": "workOrderDetails"});
                    },
                  ),
                  if (controller.demographicsTabData['woCheckOut'] == true &&
                      controller.demographicsTabData['cntItemsInv'] > 0 &&
                      controller.demographicsTabData['status'] != 'Completed')
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: MaterialCommunityIcons.floppy,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.button,
                      buttonText: 'Document Reason All Items Not Returned',
                      borderColor: ColorConstants.primary,
                      onPressed: () {},
                    ),
                  if (controller.demographicsTabData['woCheckOut'] == true &&
                      controller.demographicsTabData['cntItemsInv'] > 0 &&
                      controller.demographicsTabData['status'] != 'Completed')
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: MaterialCommunityIcons.chevron_double_left,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.yellow,
                      buttonText: 'Return All Items And Close',
                      borderColor: ColorConstants.black,
                      onPressed: () {},
                    ),
                  Row(
                    spacing: 5.0,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Initial Problem: ',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: controller.demographicsTabData['discrepancy'],
                          style: TextStyle(
                            color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium!
                                .fontSize! + 2,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 5.0,
                runSpacing: 5.0,
                children: [
                  if (controller.demographicsTabData['status'] == 'Completed' &&
                      (controller.demographicsTabData['woCheckOut'] == true ||
                          (controller.demographicsTabData['woCheckOut'] == false || UserPermission.coSignAcLogs.value == true)))
                    DiscrepancyAndWorkOrdersMaterialButton(
                      icon: MaterialCommunityIcons.file_document_edit_outline,
                      iconColor: ColorConstants.white,
                      buttonColor: ColorConstants.primary,
                      buttonText: 'Re-Open WO & Discrepancy',
                      borderColor: ColorConstants.black,
                      onPressed: () {},
                    ),
                  Wrap(
                    spacing: 5.0,
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Work Order / Discrepancy Status: ',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: controller.demographicsTabData['status'],
                          style: TextStyle(
                            color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium!
                                .fontSize! + 2,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  updateWorkOrderBillingInformationDialog({required BuildContext? context}) {
    RxList modalVendorType = [
      {
        'id': '0',
        'name': 'Use Current Information',
      },
      {
        'id': '1',
        'name': 'Select From All Vendors',
      },
      {
        'id': '2',
        'name': 'Select From All Clients',
      },
    ].obs;

    RxMap selectedModalVendorType = {}.obs;

    RxList clVendorAndCustomers = [].obs;
    RxMap selectedClVendorAndCustomers = {}.obs;

    RxBool vendorAndClintFieldShow = false.obs;


    return DiscrepancyAndWorkOrdersCustomDialog.showDialogBox(
      context: context,
      dialogTitle: 'Update Work Order Billing Information',
      enableWidget: true,
      children: [
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Card(
                color: Colors.grey[100],
                shape: Border.all(),
                child: Column(
                  children: [
                    DiscrepancyAndWorkOrdersDropDown(
                      expands: true,
                      dropDownController: controller.workOrderDetailsTextController.putIfAbsent('modalVendorType', () => TextEditingController()),
                      dropDownKey: 'name',
                      dropDownData: modalVendorType,
                      hintText: selectedModalVendorType.isNotEmpty
                          ? selectedModalVendorType['name']
                          : modalVendorType.isNotEmpty
                          ? modalVendorType[0]['name']
                          : "-- Select From Type --",
                      fieldName: "Load From Existing Vendor",
                      onChanged: (value) async {
                        selectedModalVendorType.value = value;

                        clVendorAndCustomers.clear();
                        vendorAndClintFieldShow.value = false;
                        selectedClVendorAndCustomers.clear();

                        if(selectedModalVendorType['id'] == '1') {
                          LoaderHelper.loaderWithGifAndText('Loading...');
                          Response? data = await WorkOrdersApiProvider().workOrderGetAllVendorsApiCall();
                          if(data?.statusCode == 200) {
                            clVendorAndCustomers.add({
                              'id': 0,
                              'name': '-- Selected Vendor --'
                            });
                            clVendorAndCustomers.addAll(data?.data['data']['vendorList']);

                            selectedClVendorAndCustomers.addAll(clVendorAndCustomers[0]);

                            await EasyLoading.dismiss();
                            vendorAndClintFieldShow.value = true;
                          }
                        }
                        else if(selectedModalVendorType['id'] == '2') {
                          LoaderHelper.loaderWithGifAndText('Loading...');
                          Response? data = await WorkOrdersApiProvider().workOrderGetAllCustomerApiCall();
                          if(data?.statusCode == 200) {
                            clVendorAndCustomers.add({
                              'id': 0,
                              'company': '-- Select Customer --'
                            });
                            clVendorAndCustomers.addAll(data?.data['data']['customerList']);
                            selectedClVendorAndCustomers.addAll(clVendorAndCustomers[0]);
                            await EasyLoading.dismiss();
                            vendorAndClintFieldShow.value = true;
                          }
                        }



                      },
                    ),
                    if(vendorAndClintFieldShow.value)
                      DiscrepancyAndWorkOrdersDropDown(
                        expands: true,
                        dropDownController: controller.workOrderDetailsTextController.putIfAbsent('clVendor', () => TextEditingController()),
                        dropDownKey: selectedModalVendorType['id'] == '2' ?  'company' : 'name',
                        dropDownData: clVendorAndCustomers,
                        hintText:
                        selectedClVendorAndCustomers.isNotEmpty
                            ? selectedClVendorAndCustomers['name']
                            : clVendorAndCustomers.isNotEmpty
                            ? clVendorAndCustomers[0]['name']
                            : "-- Select From Type --",
                        onChanged: (value) async {
                          selectedClVendorAndCustomers.value = value;
                          LoaderHelper.loaderWithGifAndText('Loading...');
                          await controller.getContactInformationApiCall(
                              name: selectedModalVendorType['id'] == '1' ? 'Vendor' : 'Customer',
                              id: selectedClVendorAndCustomers['id'].toString()
                          );
                        },
                      ),
                  ],
                ),
              ),

              Card(
                color: Colors.grey[300],
                child: DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderDetailsTextController.putIfAbsent('woBillingTitle', () => TextEditingController()),
                  dataType: 'text',
                  fieldName: 'Billing To Name',
                  onChanged: (value) {
                    controller.updateBillingInformationApiData['woBillingTitle'] = value;
                  },
                ),
              ),
              Card(
                color: Colors.grey[100],
                child: DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderDetailsTextController.putIfAbsent('woBillingAddress1', () => TextEditingController()),
                  dataType: 'text',
                  fieldName: 'Billing Address',
                  onChanged: (value) {
                    controller.updateBillingInformationApiData['woBillingAddress1'] = value;
                  },
                ),
              ),
              Card(
                color: Colors.grey[300],
                child: DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderDetailsTextController.putIfAbsent('woBillingAddress2', () => TextEditingController()),
                  dataType: 'text',
                  fieldName: 'Billing City, State Zip',
                  onChanged: (value) {
                    controller.updateBillingInformationApiData['woBillingAddress2'] = value;
                  },
                ),
              ),
              Card(
                color: Colors.grey[100],
                child: DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderDetailsTextController.putIfAbsent('woBillingCountry', () => TextEditingController()),
                  dataType: 'text',
                  fieldName: 'Billing Country',
                  onChanged: (value) {
                    controller.updateBillingInformationApiData['woBillingCountry'] = value;
                  },
                ),
              ),
              Card(
                color: Colors.grey[300],
                child: DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderDetailsTextController.putIfAbsent('woBillingPhone', () => TextEditingController()),
                  dataType: 'text',
                  fieldName: 'Billing Phone',
                  onChanged: (value) {
                    controller.updateBillingInformationApiData['woBillingPhone'] = value;
                  },
                ),
              ),
              Card(
                color: Colors.grey[100],
                child: DiscrepancyAndWorkOrdersTextField(
                  textFieldController: controller.workOrderDetailsTextController.putIfAbsent('woBillingEmail', () => TextEditingController()),
                  dataType: 'text',
                  fieldName: 'Billing Email',
                  onChanged: (value) {
                    controller.updateBillingInformationApiData['woBillingEmail'] = value;
                  },
                ),
              ),
            ],
          );
        }),
      ],
      actions: [
        DiscrepancyAndWorkOrdersMaterialButton(
          icon: Icons.clear,
          iconColor: ColorConstants.white,
          buttonColor: ColorConstants.red,
          buttonText: 'cancel',
          borderColor: ColorConstants.black,
          onPressed: () {
            selectedClVendorAndCustomers.clear();
            selectedModalVendorType.clear();

            modalVendorType.clear();
            clVendorAndCustomers.clear();

            Get.back(closeOverlays: true);
          },
        ),
        DiscrepancyAndWorkOrdersMaterialButton(
          icon: MaterialCommunityIcons.folder_upload,
          iconColor: ColorConstants.white,
          buttonColor: ColorConstants.button,
          buttonText: 'Update Billing Information',
          borderColor: ColorConstants.primary,
          onPressed: () async {
            controller.updateBillingInformationApiData['id'] = int.parse(controller.workOrderId);
            LoaderHelper.loaderWithGifAndText('updating...');
            Response? data = await WorkOrdersApiProvider().workOrderUpdateBillingInformationApiCall(informationData: controller.updateBillingInformationApiData);
            if(data?.statusCode == 200) {
              Get.back(closeOverlays: true);
              //await controller.apiCallData();
              SnackBarHelper.openSnackBar(isError: false, message: data?.data['userMessage']);
              await EasyLoading.dismiss();
            }

          },
        ),
      ],
    );
  }
}

class Jobs extends StatelessWidget {

  final WorkOrderDetailsLogic controller;

  const Jobs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    List jobs = controller.workOrderDetailsFullData['workOrderJobs'];

    returnJobCorrectiveActionView({required int i}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: 15.0,
        children: [
          RichText(
            text: TextSpan(
              text: jobs[i]['actionDescription'],
              style: TextStyle(
                color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                fontWeight: FontWeight.w400,
                fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! - 1
              ),
              children: <TextSpan>[],
            ),
          ),
          DiscrepancyAndWorkOrdersMaterialButton(
            buttonText: 'Show Details',
            buttonColor: ColorConstants.primary,
            borderColor: ColorConstants.black,
            onPressed: () {
              // openDialogToShowJobsInformation
              controller.openDialogToShowJobCorrectiveActionDetails(jobsData: jobs[i]);
            },
          )
        ],
      );
    }

    returnOptionsView({required int i}) {
      return DiscrepancyAndWorkOrdersMaterialButton(
        buttonText: 'View Jobs',
        icon: Icons.folder,
        buttonColor: ColorConstants.primary,
        // buttonHeight: 50.0,
        onPressed: () {
          LoaderHelper.loaderWithGif();
          Get.toNamed(
              Routes.workOrderJobs,
              parameters: {
                'workOrderId': controller.workOrderId,
                'jobsId': jobs[i]['id'].toString(),
                'initialIndex': '0',
              }
          );
        },
      );
    }

    returnStatusCodeView({required int i}) {
      valuePass({required String value, required Color? iconColor}) {
        return Row(
          spacing: 10.0,
          children: [
            Icon(Icons.circle_rounded, size: 25, color: iconColor),
            Text(value, style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center),
          ],
        );
      }

      switch(jobs[i]['statusCode']) {
        case 0:
          return valuePass(value: 'In Progress', iconColor: Colors.blue[900]);
        case 1:
          return valuePass(value: 'Awaiting Parts', iconColor: ColorConstants.red);
        case 3:
          return valuePass(value: 'Waiting QC', iconColor: ColorConstants.orange);
        case 4:
          return valuePass(value: 'Waiting LC', iconColor: ColorConstants.orange);
        case 5:
          return valuePass(value: 'Waiting FCF', iconColor: ColorConstants.orange);
        default:
          return valuePass(value: 'Completed', iconColor: ColorConstants.button);
      }
    }

    returnSignView({required int i}) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [
          // RichText(
          //   text: TextSpan(
          //     text: 'Mechanic:\t',
          //     style: TextStyle(
          //       color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
          //       fontWeight: FontWeight.normal,
          //       // fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize!,
          //     ),
          //     children: <TextSpan>[
          //       TextSpan(
          //         text: '',
          //         style: TextStyle(
          //             color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
          //             // fontWeight: FontWeight.w700,
          //             // fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 1,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            children: [
              Text('Mechanic:\t\t', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center),
              InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text('${jobs[i]['signedMechanicName']} At ${jobs[i]['signedMechanicDateTime']}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize!), textAlign: TextAlign.center),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(closeOverlays: true),
                          child: Text("Close", style: TextStyle(fontWeight: FontWeight.w700, fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 2), textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(jobs[i]['signedMechanicId'] > 0 ? 'Yes': 'No', style: TextStyle(color: jobs[i]['signedMechanicId'] > 0 ? Colors.green : null, fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! - 1), textAlign: TextAlign.center),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            children: [
              Text('QC:\t\t', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center),
              InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text('${jobs[i]['signedQcName']} At ${jobs[i]['signedQcDateTime']}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize!), textAlign: TextAlign.center),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(closeOverlays: true),
                          child: Text("Close", style: TextStyle(fontWeight: FontWeight.w700, fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 2), textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(jobs[i]['signedQcId'] > 0 ? 'Yes': 'No', style: TextStyle(color: jobs[i]['signedQcId'] > 0 ? Colors.green : null, fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! - 1), textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      );
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Row(
                    children: [
                      DataTable(
                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                        border: TableBorder.all(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                        clipBehavior: Clip.antiAlias,
                        dataRowMinHeight: 85.0,
                        dataRowMaxHeight: 125.0,
                        columns: [
                          DataColumn(label: Center(child: Text('#', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                        ],
                        rows: List.generate(jobs.length, (index) {
                          return DataRow(
                              color: WidgetStatePropertyAll(index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4)),
                              cells: [
                            DataCell(Center(child: Text('${index + 1}', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                          ]);
                        }),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                            clipBehavior: Clip.antiAlias,
                            dataRowMinHeight: 85.0,
                            dataRowMaxHeight: 125.0,
                            columns: [
                              DataColumn(label: Center(child: Text('Category', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('ATA', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('MNC', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Reference', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: SizedBox(width: 600.0, child: Text('Job/ Corrective Action', style: controller.workOrderDetailsTableColumHeaderViewReturn())))),
                              DataColumn(label: Center(child: Text('Status', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Mechanic Assigned', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('QC', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LC', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('FCF', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Sign', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Options', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                            ],
                            rows: List.generate(jobs.length, (index) {
                              return DataRow(
                                  color: WidgetStatePropertyAll(index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4)),
                                  cells: [
                                    DataCell(Center(child: Text('${jobs[index]['categoryName']}', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(jobs[index]['ataMcnNumber'].toString().replaceAll('||', ' ').split(' ').first, style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(jobs[index]['mcnNumber'].toString().replaceAll('||', ' ').split(' ').last, style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text('${jobs[index]['referenceNumber']}', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(returnJobCorrectiveActionView(i: index)),
                                    DataCell(Center(child: returnStatusCodeView(i: index))),
                                    DataCell(Center(child: Text('${jobs[index]['mechanicsAssigned'] == "" ? "Not Assigned" : jobs[index]['mechanicsAssigned']}', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(jobs[index]['qcRequired'] ? 'Yes' : 'No', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(jobs[index]['leakCheckRequired'] ? 'Yes' : 'No', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(jobs[index]['fcfRequired'] ? 'Yes' : 'No', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: returnSignView(i: index))),
                                    DataCell(Center(child: SizedBox(width: 130.0,child: returnOptionsView(i: index)))),
                                  ]);
                            }),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PartsRemoved extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const PartsRemoved({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List partsRemoved = controller.workOrderDetailsFullData['partsRemoved'];

    List<Map<String, dynamic>> uniqueList = [];
    Set<String> seenDescriptions = {};

    for (var item in partsRemoved) {
      if (!seenDescriptions.contains(item['description'])) {
        seenDescriptions.add(item['description']);
        uniqueList.add(item);
      }
    }

    int quantityTotal = uniqueList.fold(0, (sum, item) => sum + (item['quantity'] as int));

    for (var elements in partsRemoved) {
      elements.update('tsn', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : value);
      elements.update('tso', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : value);
      elements.update('tsi', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : value);

      elements.update('csn', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : value);
      elements.update('cso', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : value);
      elements.update('csi', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : value);

      elements.update('lsn', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : double.parse(value.toString()).toInt());
      elements.update('lso', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : double.parse(value.toString()).toInt());
      elements.update('lsi', (value) =>
      (value
          .toString()
          .isNullOrEmpty || value == 0 || value == 0.0) ? '' : double.parse(value.toString()).toInt());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.0,
                    children: [
                      Icon(MaterialCommunityIcons.close_circle_outline, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.primary, size: 30),
                      RichText(
                        text: TextSpan(
                          text: 'Parts Removed',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium!
                                .fontSize! + 1,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                    ],
                  ),
                  if(partsRemoved.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                        border: TableBorder.all(
                          color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        columns: [
                          DataColumn(label: Center(child: Text('Description', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('TSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('TSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('TSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('CSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('CSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('CSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('LSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('LSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('LSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                        ],
                        rows: [
                          ...partsRemoved.map((entry) {
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                int index = partsRemoved.indexOf(entry);
                                return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                              }),
                              cells: [
                                DataCell(Center(child: Text(
                                    entry['description'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(child: Text(
                                    entry['partNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(child: Text(
                                    entry['serialNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['jobNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['quantity'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['tsn'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['tso'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['tsi'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['csn'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['cso'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['csi'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['lsn'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['lso'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(entry['lsi'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),

                              ],
                            );
                          }),
                          DataRow(
                            color: WidgetStateProperty.all(ColorConstants.primary),
                            cells: [
                              DataCell(Center(child: Text('Total', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text(
                                  quantityTotal.toStringAsFixed(0), style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                              DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                        border: TableBorder.all(
                          color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        columns: [
                          DataColumn(label: Center(child: Text('Description', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('TSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('TSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('TSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('CSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('CSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('CSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('LSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('LSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('LSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                        ],
                        rows: [],
                      ),
                    ),

                  if(partsRemoved.isEmpty)
                    RichText(
                      text: TextSpan(
                        text: ' No Parts Removed',
                        style: TextStyle(
                          color: ColorConstants.red,
                          fontWeight: FontWeight.w500,
                          fontSize: Theme
                              .of(Get.context!)
                              .textTheme
                              .headlineMedium!
                              .fontSize! + 2,
                        ),
                        children: <TextSpan>[],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PartsInstalled extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const PartsInstalled({super.key, required this.controller});




  @override
  Widget build(BuildContext context) {
    List partsInstalled = controller.workOrderDetailsFullData['partsInstalled'];

    List<Map<String, dynamic>> uniqueList = [];
    Set<String> seenDescriptions = {};

    for (var item in partsInstalled) {
      if (!seenDescriptions.contains(item['description'])) {
        seenDescriptions.add(item['description']);
        uniqueList.add(item);
      }
    }

    int jobTotal = uniqueList.fold(0, (sum, item) => sum + (item['jobNumber'] as int));

    for (var elements in partsInstalled) {
      // elements.update((value) => elements['lsn']);
      elements.update('lsn', (value) => double.parse(value.toString()).toInt());
      elements.update('lso', (value) => double.parse(value.toString()).toInt());
      elements.update('lsi', (value) => double.parse(value.toString()).toInt());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10.0,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5.0,
                        children: [
                          Icon(MaterialCommunityIcons.plus_circle_outline, color: ColorConstants.primary, size: 30),
                          RichText(
                            text: TextSpan(
                              text: 'Parts Installed',
                              style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize! + 1,
                              ),
                              children: <TextSpan>[],
                            ),
                          ),
                        ],
                      ),
                      if(partsInstalled.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Center(child: Text('Description', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('TSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('TSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('TSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('CSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('CSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('CSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                            ],
                            rows: [
                              ...partsInstalled.map((entry) {
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                    int index = partsInstalled.indexOf(entry);
                                    return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                                  }),
                                  cells: [
                                    DataCell(Center(child: Text(
                                        entry['description'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['partNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['serialNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['jobNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['quantity'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['tsn'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['tso'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['tsi'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['csn'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['cso'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['csi'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['lsn'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['lso'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(
                                        child: Text(entry['lsi'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),

                                  ],
                                );
                              }),
                              DataRow(
                                color: WidgetStateProperty.all(ColorConstants.primary),
                                cells: [
                                  DataCell(Center(child: Text('Total', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text(
                                      jobTotal.toStringAsFixed(0), style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                  DataCell(Center(child: Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center))),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Center(child: Text('Description', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('TSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('TSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('TSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('CSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('CSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('CSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LSN', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LSO', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                              DataColumn(label: Center(child: Text('LSI', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                            ],
                            rows: [],
                          ),
                        ),
                      if(partsInstalled.isEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No Parts Installed',
                            style: TextStyle(
                              color: ColorConstants.red,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! + 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PartsRequest extends StatelessWidget {

  final WorkOrderDetailsLogic controller;

  const PartsRequest({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    List partsRequest = controller.workOrderDetailsFullData['partsRequestDataList'];

    if(partsRequest.isNotNullOrEmpty) {
      partsRequest.sort((a, b) => a['jobId'].compareTo(b['jobId']));
    }

    int counter = 1;
    int? lastJobId;

    Map approvalStatus = {
      'status': {
        'approved': 0,
        'rejected': 0,
        'pending': 0,
      },
      'totalItems': 0,
      'totalCost': 0.0,
      'coresRequired': 0,
      'warrantyItems': 0
    };

    for(int i = 0; i < partsRequest.length; i++) {
      //status count
      switch(partsRequest[i]['approvalStatus']) {
        case 3:
          approvalStatus['status']['rejected'] += 1;
          break;
        case 1:
          approvalStatus['status']['pending'] += 1;
          break;
        case 2:
          approvalStatus['status']['approved'] += 1;
          break;
      }

      //totalCostCount
      approvalStatus['totalCost'] += double.parse(partsRequest[i]['price'].toString()) * double.parse(partsRequest[i]['quantity'].toString());

      //totalItemCount
      approvalStatus['totalItems'] += partsRequest[i]['quantity'];

      //totalCoreRequired
      if(partsRequest[i]['coreRequired']) {
        approvalStatus['coresRequired'] += 1;
      }

      //totalWarrantyItems
      if(partsRequest[i]['warranty']) {
        approvalStatus['warrantyItems'] += 1;
      }

    }

    moreStatusYesNoReturn({required bool value}) {
      if(value == true) {
        return Container(
          padding: EdgeInsets.fromLTRB(10.0, 8.0, 15.0, 8.0),
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5.0,
            children: [
              Icon(MaterialCommunityIcons.check_bold, color: ColorConstants.button, size: 25.0),
              Text('Yes', style: controller.workOrderDetailsTableRowDataViewReturn())
            ],
          ),
        );
      }
      else if(value == false) {
        return Container(
          padding: EdgeInsets.fromLTRB(10.0, 8.0, 15.0, 8.0),
          decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5.0,
            children: [
              Icon(Icons.clear, color: ColorConstants.red, size: 25.0),
              Text('No', style: controller.workOrderDetailsTableRowDataViewReturn(color: ColorConstants.red))
            ],
          ),
        );
      }
      else {
        return SizedBox();
      }
    }

    approvalStatusReturn({required int value}) {
      switch(value) {
        case 2:
          return Container(
            padding: EdgeInsets.fromLTRB(10.0, 8.0, 15.0, 8.0),
            decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5.0,
              children: [
                Icon(MaterialCommunityIcons.check_bold, color: ColorConstants.button, size: 25.0),
                Text('Accepted', style: controller.workOrderDetailsTableRowDataViewReturn(color: ColorConstants.button))
              ],
            ),
          );
        case 1:
          return Container(
            padding: EdgeInsets.fromLTRB(10.0, 8.0, 15.0, 8.0),
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5.0,
              children: [
                Icon(MaterialCommunityIcons.clock_outline, color: ColorConstants.primary, size: 30.0),
                Text('Pending', style: controller.workOrderDetailsTableRowDataViewReturn(color: ColorConstants.primary))
              ],
            ),
          );
        case 3:
          return Container(
            padding: EdgeInsets.fromLTRB(10.0, 8.0, 15.0, 8.0),
            decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5.0,
              children: [
                Icon(MaterialCommunityIcons.block_helper, color: ColorConstants.red, size: 25.0),
                Text('Rejected', style: controller.workOrderDetailsTableRowDataViewReturn(color: ColorConstants.red))
              ],
            ),
          );
        default:
          return SizedBox();
      }
    }

    commentsTableRowViewReturn({required int i}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.0,
        children: [
          Text(partsRequest[i]['comment'], style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center),
          RichText(
            text: TextSpan(
              text: 'Last Update By ',
              style: controller.workOrderDetailsTableRowDataViewReturn(color: Colors.black87.withValues(alpha: 0.8)),
              children: <TextSpan>[
                TextSpan(
                  text: partsRequest[i]['lastEditByName'],
                  style: TextStyle(
                    color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 1,
                  ),
                ),
                TextSpan(
                  text: ' At ${partsRequest[i]['lastEditAt']}',
                ),
              ],
            ),
          )
        ],
      );
    }


    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        borderOnForeground: true,
        margin: EdgeInsets.all(5.0),
        shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
        color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  if(DeviceType.isTablet)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5.0,
                      children: [
                        Icon(Icons.request_page_rounded, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.primary, size: 30),
                        RichText(
                          text: TextSpan(
                            text: 'Parts Request',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 1,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                      ],
                    ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 20.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: ColorConstants.button),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                              child: Text('${approvalStatus['status']['approved']} Approved', style: TextStyle(color: ColorConstants.button, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize! + 2)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: ColorConstants.red),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                              child: Text('${approvalStatus['status']['rejected']} Rejected', style: TextStyle(color: ColorConstants.red, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize! + 2)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: ColorConstants.primary),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                              child: Text('${approvalStatus['status']['pending']} Pending', style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize! + 2)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DiscrepancyAndWorkOrdersMaterialButton(
                    buttonText: 'Approval Status',
                    icon: Icons.approval,
                    buttonColor: ColorConstants.primary,
                    borderColor: ColorConstants.black,
                    onPressed: () {
                      controller.workOrderDetailsPartsRequestDialogView(status: approvalStatus);
                    },
                  )
                ],
              ),
              Row(
                children: [
                  DataTable(
                    headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                    border: TableBorder.all(
                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    dataRowMaxHeight: 80.0,
                    columns: [
                      DataColumn(label: Center(child: Text('item #', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                    ],
                    rows: [
                      ...partsRequest.map((entry) {
                        int index = partsRequest.indexOf(entry);
                        return DataRow(
                          color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                            return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                          }),
                          cells: [
                            DataCell(
                              // onTap: () => controller.partsRemoveDialogView(type: 'remove', option: 'update', id: entry['id']),
                              Center(
                                child: Text(
                                  '${index + 1}',
                                  style: controller.workOrderDetailsTableRowDataViewReturn(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      if (partsRequest.isEmpty) DataRow(cells: [DataCell(Center(child: SizedBox()))]),

                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                        border: TableBorder.all(
                          color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                        ),
                        dataRowMaxHeight: 80.0,
                        clipBehavior: Clip.antiAlias,
                        columns: [
                          DataColumn(label: Center(child: Text('Job No', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Description', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Price', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Total Cost', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Comments', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Core Required', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Warranty', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                          DataColumn(label: Center(child: Text('Approval Status', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),

                        ],
                        rows: [
                          ...partsRequest.map((entry) {
                            int index = partsRequest.indexOf(entry);

                            if(lastJobId != null && entry['jobId'] != lastJobId) {
                              counter++;
                            }

                            lastJobId = entry['jobId'];

                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                              }),
                              cells: [
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Text(counter.toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center)))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Text(entry['partNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center)))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Text(entry['description'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center)))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Text(entry['quantity'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center)))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Text('\$${entry['price']}', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center)))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Text('\$${double.parse(entry['price'].toString()) * double.parse(entry['quantity'].toString())}', style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center)))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: commentsTableRowViewReturn(i: index))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: moreStatusYesNoReturn(value: entry['coreRequired'])))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: moreStatusYesNoReturn(value: entry['warranty'])))),
                                DataCell(Padding(padding: const EdgeInsets.all(5.0), child: Center(child: approvalStatusReturn(value: entry['approvalStatus'])))),
                              ],
                            );
                          }),

                          if (partsRequest.isEmpty)
                            DataRow(
                              cells: [
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: ' No Parts Request Found',
                                      style: TextStyle(
                                        color: ColorConstants.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 2,
                                      ),
                                      children: <TextSpan>[],
                                    ),
                                  ),
                                )),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                                DataCell(Center(child: Text(''))),
                              ],
                            ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryItems extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const InventoryItems({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List inventoryItem = controller.workOrderDetailsFullData['inventoryItems'];

    double totalQuantity = inventoryItem.fold(0, (sum, item) => sum + item["quantity"]);
    double totalPrice = inventoryItem.fold(0, (sum, item) => sum + item["total"]);


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10.0,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5.0,
                        children: [
                          Icon(MaterialCommunityIcons.wrench, color: ColorConstants.primary, size: 30),
                          RichText(
                            text: TextSpan(
                              text: 'Inventory Items',
                              style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize! + 1,
                              ),
                              children: <TextSpan>[],
                            ),
                          ),
                        ],
                      ),
                      if(inventoryItem.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Item Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('PO Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Price', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Price', style: controller.workOrderDetailsTableColumHeaderViewReturn()))
                            ],
                            rows: [
                              ...inventoryItem.map((entry) {
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                    int index = inventoryItem.indexOf(entry);
                                    return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                                  }),
                                  cells: [
                                    DataCell(Center(child: Text(
                                        entry['itemName'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['partNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['serialNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['poNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['jobNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['quantity'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        '\$ ${entry['invoicePrice'].toStringAsFixed(2)}', style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text('\$ ${entry['total'].toStringAsFixed(2)}', style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                  ],
                                );
                              }),
                              DataRow(
                                color: WidgetStateProperty.all(ColorConstants.primary),
                                cells: [
                                  DataCell(Text('')),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text('Total', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Center(child: Text(totalQuantity.toStringAsFixed(0), style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Center(child: Text('\$${totalPrice.toStringAsFixed(2)}', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Item Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('PO Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Price', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Price', style: controller.workOrderDetailsTableColumHeaderViewReturn()))
                            ],
                            rows: [],
                          ),
                        ),
                      if(inventoryItem.isEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No Inventory Items Added',
                            style: TextStyle(
                              color: ColorConstants.red,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! + 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NonInventoryItems extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const NonInventoryItems({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List nonInventoryItem = controller.workOrderDetailsFullData['nonInventoryItems'];

    double totalQuantity = nonInventoryItem.fold(0, (sum, item) => sum + item["quantity"]);
    double totalPrice = nonInventoryItem.fold(0, (sum, item) => sum + item["total"]);


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10.0,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5.0,
                        children: [
                          Icon(MaterialCommunityIcons.briefcase, color: ColorConstants.primary, size: 30),
                          RichText(
                            text: TextSpan(
                              text: 'Non Inventory Items',
                              style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize! + 1,
                              ),
                              children: <TextSpan>[],
                            ),
                          ),
                        ],
                      ),
                      if(nonInventoryItem.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Item Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('PO Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Price', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Price', style: controller.workOrderDetailsTableColumHeaderViewReturn()))
                            ],
                            rows: [
                              ...nonInventoryItem.map((entry) {
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                    int index = nonInventoryItem.indexOf(entry);
                                    return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                                  }),
                                  cells: [
                                    DataCell(Center(child: Text(
                                        entry['itemName'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['partNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['serialNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['poNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['jobNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        entry['quantity'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text('\$ ${entry['cost'].toStringAsFixed(2)}', style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text('\$ ${entry['total'].toStringAsFixed(2)}', style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                  ],
                                );
                              }),
                              DataRow(
                                color: WidgetStateProperty.all(ColorConstants.primary),
                                cells: [
                                  DataCell(Text('')),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text('Total', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Center(child: Text(totalQuantity.toStringAsFixed(0), style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                                  DataCell(Text('', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Center(child: Text('\$${totalPrice.toStringAsFixed(2)}', style: controller.workOrderDetailsTableColumHeaderViewReturn()))),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Item Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Part Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Serial Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('PO Number', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Quantity', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Price', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Price', style: controller.workOrderDetailsTableColumHeaderViewReturn()))
                            ],
                            rows: [],
                          ),
                        ),
                      if(nonInventoryItem.isEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No Inventory Items Added',
                            style: TextStyle(
                              color: ColorConstants.red,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! + 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Labor extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const Labor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List laborData = controller.workOrderDetailsFullData['labor'];

    double totalHours = laborData.fold(0, (sum, item) => sum + item["laborHours"]);
    double totalCost = laborData.fold(0, (sum, item) => sum + item["total"]);

    //----Total Labor Hours By Job---
    final Map<int, double> totalHoursByJob = {};
    for (var entry in laborData) {
      final job = entry['jobNumber'] as int;
      final hours = entry['laborHours'] as double;
      totalHoursByJob[job] = (totalHoursByJob[job] ?? 0) + hours;
    }
    final jobEntries = totalHoursByJob.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    //----Total Labor Hours By User---
    final Map<String, double> totalHoursByUser = {};
    for (var entry in laborData) {
      final name = entry['name'] as String;
      final hours = entry['laborHours'] as double;
      totalHoursByUser[name] = (totalHoursByUser[name] ?? 0) + hours;
    }

    final userEntries = totalHoursByUser.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MaterialCommunityIcons.account_group, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, size: 30),
                          RichText(
                            text: TextSpan(
                              text: 'Labor Hours',
                              style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium
                                    ?.fontSize,
                              ),
                              children: <TextSpan>[],
                            ),
                          ),
                        ],
                      ),
                      if(laborData.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Hours', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Rate', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Cost', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                            ],
                            rows: [
                              ...laborData.map((entry) {
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                    int index = laborData.indexOf(entry);
                                    return index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4);
                                  }),
                                  cells: [
                                    DataCell(Center(child: Text(
                                        entry['jobNumber'].toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(entry['name'], style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(entry['laborHours'].toStringAsFixed(2), style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text('\$${entry['laborRate'].toStringAsFixed(2)}', style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text('\$${entry['total'].toStringAsFixed(2)}', style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center))),
                                  ],
                                );
                              }),
                              DataRow(
                                color: WidgetStateProperty.all(ColorConstants.primary),
                                cells: [
                                  const DataCell(Text('')),
                                  DataCell(Text('Total', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  DataCell(Text(totalHours.toStringAsFixed(2), style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                  const DataCell(Text('')),
                                  DataCell(Text('\$${totalCost.toStringAsFixed(2)}', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Hours', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Rate', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Cost', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                            ],
                            rows: [],
                          ),
                        ),
                      if(laborData.isEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No Labor Added',
                            style: TextStyle(
                              color: ColorConstants.red,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! + 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),
                  if(laborData.isNotEmpty)
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MaterialCommunityIcons.account_group, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, size: 30),
                            RichText(
                              text: TextSpan(
                                text: 'Total Labor Hours By Job',
                                style: TextStyle(
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Hours', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                            ],
                            rows: List<DataRow>.generate(
                              jobEntries.length,
                                  (index) {
                                final e = jobEntries[index];
                                return DataRow(
                                  color: WidgetStatePropertyAll(
                                    index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4),
                                  ),
                                  cells: [
                                    DataCell(
                                        Center(child: Text(e.key.toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        e.value.toStringAsFixed(2), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  if(laborData.isNotEmpty)
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MaterialCommunityIcons.account_group, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, size: 30),
                            RichText(
                              text: TextSpan(
                                text: 'Total Labor Hours By User',
                                style: TextStyle(
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium
                                      ?.fontSize,
                                ),
                                children: <TextSpan>[],
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [
                              DataColumn(label: Text('Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                              DataColumn(label: Text('Total Hours', style: controller.workOrderDetailsTableColumHeaderViewReturn())),
                            ],
                            rows: List<DataRow>.generate(
                              userEntries.length,
                                  (index) {
                                final e = userEntries[index];
                                return DataRow(
                                  color: WidgetStatePropertyAll(
                                    index.isEven ? ColorConstants.primary.withValues(alpha: 0.1) : ColorConstants.primary.withValues(alpha: 0.4),
                                  ),
                                  cells: [
                                    DataCell(
                                        Center(child: Text(e.key.toString(), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                    DataCell(Center(child: Text(
                                        e.value.toStringAsFixed(2), style: controller.workOrderDetailsTableRowDataViewReturn(), textAlign: TextAlign.center))),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Documents extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const Documents({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MaterialCommunityIcons.clipboard_outline, color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, size: 30),
                      RichText(
                        text: TextSpan(
                          text: 'Work Order Documents',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 5.0,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [DataColumn(label: Center(child: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())))],
                            rows: List.generate(controller.workOrderDetailsFullData['documents'].length, (index) {
                              return DataRow(
                                color:
                                index % 2 == 0
                                    ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                    : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                                cells: [
                                  DataCell(
                                    Center(
                                      child: Text(
                                        controller.workOrderDetailsFullData['documents'][index]['jobNumber'].toString(),
                                        style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                border: TableBorder.all(
                                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                ),

                                clipBehavior: Clip.antiAlias,
                                columns: [
                                  DataColumn(
                                    label: Center(child: Text('Date', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text('Description', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(child: Text('View', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center)),
                                  ),
                                ],
                                rows: List.generate(controller.workOrderDetailsFullData['documents'].length, (index) {
                                  return DataRow(
                                    color:
                                    index % 2 == 0
                                        ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                        : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                                    cells: [
                                      DataCell(
                                        Center(
                                          child: Text(
                                            controller.workOrderDetailsFullData['documents'][index]['docDate'].toString(),
                                            style: controller.workOrderDetailsTableRowDataViewReturn(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            controller.workOrderDetailsFullData['documents'][index]['docDescription'].toString(),
                                            style: controller.workOrderDetailsTableRowDataViewReturn(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        onTap: () async {
                                          await FileControl.getPathAndViewFile(
                                            fileId: controller.workOrderDetailsFullData['documents'][index]['uploadId'].toString(),
                                            fileName: controller.workOrderDetailsFullData['documents'][index]['docFileName'].toString(),
                                          );
                                        },
                                        Center(
                                          child: Icon(
                                            controller.documentsViewIconReturns(
                                              types: FileControl.fileType(fileName: controller.workOrderDetailsFullData['documents'][index]['docFileName']),
                                            ),
                                            size: 30.0,
                                            color: ColorConstants.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (controller.workOrderDetailsFullData['documents']
                          .cast<Map<String, dynamic>>()
                          .isEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No Documents Added',
                            style: TextStyle(
                              color: ColorConstants.red,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! + 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WOStatus extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const WOStatus({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MaterialCommunityIcons.account, color: ColorConstants.button, size: 30),
                      RichText(
                        text: TextSpan(
                          text: 'Active Jobs',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 5.0,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [DataColumn(label: Center(child: Text('Name', style: controller.workOrderDetailsTableColumHeaderViewReturn())))],
                            rows: List.generate(controller.woStatusActiveJobs.length, (index) {
                              return DataRow(
                                color:
                                index % 2 == 0
                                    ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                    : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                                cells: [
                                  DataCell(
                                    Center(
                                      child: Text(
                                        controller.woStatusActiveJobs[index]['name'],
                                        style: controller.workOrderDetailsTableRowDataViewReturn(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                border: TableBorder.all(
                                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                ),

                                clipBehavior: Clip.antiAlias,
                                columns: [
                                  DataColumn(
                                    label: Center(
                                      child: Text('Job # Assigned', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(child: Text('Status', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Center(child: Text('Labor', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text('Job Description', style: controller.workOrderDetailsTableColumHeaderViewReturn(), textAlign: TextAlign.center),
                                    ),
                                  ),
                                ],
                                rows: List.generate(controller.woStatusActiveJobs.length, (index) {
                                  return DataRow(
                                    color:
                                    index % 2 == 0
                                        ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                        : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                                    cells: [
                                      DataCell(
                                        Center(
                                          child: Text(
                                            controller.woStatusActiveJobs[index]['jobNum'].toString(),
                                            style: controller.workOrderDetailsTableRowDataViewReturn(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            Icon(MaterialCommunityIcons.circle, size: 25, color: controller.woStatusActiveJobs[index]['jobStatusColor']),
                                            Text(
                                              controller.woStatusActiveJobs[index]['jobStatus'].toString(),
                                              style: controller.workOrderDetailsTableRowDataViewReturn(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            controller.woStatusActiveJobs[index]['labor'].toString(),
                                            style: controller.workOrderDetailsTableRowDataViewReturn(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            controller.woStatusActiveJobs[index]['jobDesc'].toString(),
                                            style: controller.workOrderDetailsTableRowDataViewReturn(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (controller.woStatusActiveJobs.isNullOrEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No Active Jobs',
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! - 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MaterialCommunityIcons.account_outline, color: ColorConstants.red, size: 30),
                      RichText(
                        text: TextSpan(
                          text: 'In-Active Jobs',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 5.0,
                    children: [
                      Row(
                        children: [
                          DataTable(
                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                            border: TableBorder.all(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            columns: [DataColumn(label: Center(child: Text('Job #', style: controller.workOrderDetailsTableColumHeaderViewReturn())))],
                            rows: List.generate(controller.woStatusInActiveJobs.length, (index) {
                              return DataRow(
                                color:
                                index % 2 == 0
                                    ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                    : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                                cells: [
                                  DataCell(
                                    Center(
                                      child: Text(
                                        controller.woStatusInActiveJobs[index]['jobNum'].toString(),
                                        style: controller.workOrderDetailsTableRowDataViewReturn(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                border: TableBorder.all(
                                  color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                ),
                                clipBehavior: Clip.antiAlias,
                                columns: [DataColumn(label: Center(child: Text('Job Description', style: controller.workOrderDetailsTableColumHeaderViewReturn())))],
                                rows: List.generate(controller.woStatusInActiveJobs.length, (index) {
                                  return DataRow(
                                    color:
                                    index % 2 == 0
                                        ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                        : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                                    cells: [
                                      DataCell(
                                        Center(child: Text(controller.woStatusInActiveJobs[index]['desc'], style: controller.workOrderDetailsTableRowDataViewReturn())),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (controller.woStatusInActiveJobs.isNullOrEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'No In-Active Jobs',
                            style: TextStyle(
                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! - 2,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckList extends StatelessWidget {
  final WorkOrderDetailsLogic controller;

  const CheckList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SizeConstants.contentSpacing - 5,
        children: [
          Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.all(5.0),
            shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
            color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 5.0,
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Work Order #${controller.workOrderId} Check List',
                        style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme
                            .of(Get.context!)
                            .textTheme
                            .headlineMedium
                            ?.fontSize),
                        children: <TextSpan>[],
                      ),
                    ),
                  ),
                  aircraftBasicAndDiscrepancyValues(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Obx(() =>
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10.0,
                          children: [
                            if (!controller.editCheckList.value)
                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.print_outlined,
                                iconColor: ColorConstants.white,
                                buttonColor: ColorConstants.primary,
                                buttonText: 'Print Check List',
                                borderColor: ColorConstants.black,
                                onPressed: () async {
                                  if (Platform.isAndroid) {
                                    if (await Permission.manageExternalStorage.isGranted) {
                                      Get.to(() =>
                                          ViewPrintSavePdf(
                                              pdfFile: (pageFormat) =>
                                                  controller.pDFViewForWorkOrderCheckList(
                                                      pageFormat: pageFormat,
                                                      // tableHeaderData: tableHeaderData,
                                                      // tableValueKey: tableValueKey,
                                                      // tableBottomHeaderData: tableBottomHeaderData,
                                                      pdfTitle: 'Work Order Check List'),
                                              fileName: 'str_Work_Order_Checklist_pdf',
                                              initialPageFormat: PdfPageFormat.a4.landscape));
                                    } else {
                                      PermissionHelper.storagePermissionAccess();
                                    }
                                  }
                                  else {
                                    Get.to(() =>
                                        ViewPrintSavePdf(
                                            pdfFile: (pageFormat) =>
                                                controller.pDFViewForWorkOrderCheckList(
                                                    pageFormat: pageFormat,
                                                    // tableHeaderData: tableHeaderData,
                                                    // tableValueKey: tableValueKey,
                                                    // tableBottomHeaderData: tableBottomHeaderData,
                                                    pdfTitle: 'Work Order Check List'),
                                            fileName: 'str_Work_Order_Checklist_pdf',
                                            initialPageFormat: PdfPageFormat.a4.landscape));
                                  }
                                },
                              ),

                            if (!controller.editCheckList.value)
                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.credit_score,
                                iconColor: ColorConstants.white,
                                buttonColor: ColorConstants.primary,
                                buttonText: 'Edit Check List',
                                borderColor: ColorConstants.black,
                                onPressed: () {
                                  controller.editCheckList.value = true;
                                },
                              ),

                            if (controller.editCheckList.value)
                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.add_box_rounded,
                                iconColor: ColorConstants.white,
                                buttonColor: ColorConstants.primary,
                                buttonText: 'Create New Category',
                                borderColor: ColorConstants.black,
                                onPressed: () {
                                  // editCheckList.value = true;
                                },
                              ),

                            if (controller.editCheckList.value)
                              DiscrepancyAndWorkOrdersMaterialButton(
                                icon: Icons.clear,
                                iconColor: ColorConstants.white,
                                buttonColor: ColorConstants.red,
                                buttonText: 'Cancel Edit',
                                borderColor: ColorConstants.black,
                                onPressed: () {
                                  controller.editCheckList.value = false;
                                },
                              ),
                          ],
                        ),),
                  ),
                  // for(int i = 0; i < controller.workOrderDetailsFullData['woCheckList'].length; i++)
                  Obx(() => !controller.editCheckList.value ? drawWoCheckListDetailsMode() : drawWoCheckListEditMode(controller.isEditingCategory),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  aircraftBasicAndDiscrepancyValues() {
    return Wrap(
      spacing: 5.0,
      runSpacing: 10.0,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue[700], borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Aircraft:\t${controller.workOrderDetailsFullData['objWoBasicDemographicsData']['serialNumber'].toString()}',
                      style: TextStyle(
                        color: ColorConstants.white,
                        fontWeight: FontWeight.w700,
                        fontSize: Theme
                            .of(Get.context!)
                            .textTheme
                            .headlineMedium!
                            .fontSize! + 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      spacing: DeviceType.isTablet ? 20.0 : 50.0,
                      runSpacing: DeviceType.isTablet ? 10.0 : 5.0,
                      children: [

                        ///--{Aircraft_Total_Time,Flight_Hobbs}
                        RichText(
                          text: TextSpan(
                            text: 'Aircraft Total Time:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.workOrderDetailsFullData['objWoBasicDemographicsData']['actt'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Flight Hobbs:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.workOrderDetailsFullData['objWoBasicDemographicsData']['hobbsBillable'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),

                        ///--{Maintenance_Hobbs,Landings}
                        RichText(
                          text: TextSpan(
                            text: 'Maintenance Hobbs:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.workOrderDetailsFullData['objWoBasicDemographicsData']['hobbs'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                            controller.workOrderDetailsFullData['objWoBasicDemographicsData']['strLandingsName']
                                .toString()
                                .isNotNullOrEmpty
                                ? controller.workOrderDetailsFullData['objWoBasicDemographicsData']['strLandingsName'].toString()
                                : 'Landings:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.workOrderDetailsFullData['objWoBasicDemographicsData']['landings'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),

                        ///--{Torque_Events,Run_On_Landings}
                        RichText(
                          text: TextSpan(
                            text: 'Torque Events:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.workOrderDetailsFullData['objWoBasicDemographicsData']['torqueEvents'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Run On Landings:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.workOrderDetailsFullData['objWoBasicDemographicsData']['runOnLandings'].toString(),
                                style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 10),
        engineCardView(),
      ],
    );
  }

  engineCardView() {
    String sn = "";
    String engModel = "";
    double totalTime = 0.0;
    double starts = 0.0;
    double ng2 = 0.0;
    // double np = 0.0;
    // double flight = 0.0;
    double cycle = 0.0;

    for (int i = 1; i < 3;) {
      switch (i) {
        case 1:
          sn = controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1SN'];
          engModel = controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1Model'];
          totalTime = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1TT'].toString());
          starts = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1Starts'].toString());
          ng2 = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1NG2'].toString());
          // np = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['npCycles'].toString());
          // flight = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1Flights'].toString());
          cycle = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine1Cycles'].toString());
          break;

        case 2:
          sn = controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2SN'];
          engModel = controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2Model'];
          totalTime = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2TT'].toString());
          starts = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2Starts'].toString());
          ng2 = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2NG2'].toString());
          // np = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['npCycle2'].toString());
          // flight = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2Flights'].toString());
          cycle = double.parse(controller.workOrderDetailsFullData['objWoBasicDemographicsData']['engine2Cycles'].toString());
          break;
      }

      if (sn
          .toString()
          .isNotNullOrEmpty && sn != '0') {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue[700], borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Engine #$i:\t$sn',
                      style: TextStyle(
                        color: ColorConstants.white,
                        fontWeight: FontWeight.w700,
                        fontSize: Theme
                            .of(Get.context!)
                            .textTheme
                            .headlineMedium!
                            .fontSize! + 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [

                        ///--{Engine_Model,Total_Time}
                        RichText(
                          text: TextSpan(
                            text: 'ENG #{$i} Model:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[TextSpan(text: engModel.toString(), style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black))],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Total Time:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[TextSpan(text: totalTime.toString(), style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black))],
                          ),
                        ),

                        ///--{Engine_Starts, Engine_N1}
                        RichText(
                          text: TextSpan(
                            text: 'ENG #{$i} Starts:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[TextSpan(text: starts.round().toString(), style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black))],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'ENG #{$i} N1:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[TextSpan(text: ng2.round().toString(), style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black))],
                          ),
                        ),

                        ///--{Cycles, Null}
                        RichText(
                          text: TextSpan(
                            text: 'Cycles:\t',
                            style: TextStyle(
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                            ),
                            children: <TextSpan>[TextSpan(text: cycle.round().toString(), style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black))],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    }
  }

  drawWoCheckListDetailsMode() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in controller.workOrderDetailsFullData['woCheckList']) {
      grouped.putIfAbsent(item['categoryName'], () => []).add(item);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
      grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5.0,
          children: [
            DiscrepancyAndWorkOrdersTextField(
              textFieldController: controller.workOrderDetailsTextController.putIfAbsent('category_5_${entry.key}', () => TextEditingController(text: entry.key)),
              maxCharacterLength: 100,
              dataType: 'text',
              readOnly: true,
              textFieldWidth: Get.width,
              onChanged: (value) {},
            ),

            Row(
              children: [
                DataTable(
                  headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                  border: TableBorder.all(
                    color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  columns: [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Initial',
                          style: TextStyle(
                            color: ColorConstants.white,
                            fontWeight: FontWeight.w800,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows:
                  entry.value.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              item['initial'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! - 1),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                      // border: TableBorder(
                      //   top: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                      //   right: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                      //   bottom: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                      //   horizontalInside: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                      //   verticalInside: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
                      //   borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                      // ),
                      border: TableBorder.all(
                        color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      columns: [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Task',
                              style: TextStyle(
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w800,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium
                                    ?.fontSize,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Reference',
                              style: TextStyle(
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w800,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium
                                    ?.fontSize,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Attachment',
                              style: TextStyle(
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w800,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium
                                    ?.fontSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows:
                      entry.value.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text(
                                  item['task'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! - 1),
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  item['reference'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! - 1),
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  item['uploadFile'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! - 1),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            // DataTable(
            //   columns: const [
            //     DataColumn(label: Text('Initial')),
            //     DataColumn(label: Text('Task')),
            //     DataColumn(label: Text('Reference')),
            //     DataColumn(label: Text('Attachment')),
            //   ],
            //   rows: entry.value.map((item) {
            //     return DataRow(
            //       cells: [
            //         DataCell(Text(item['initial'] ?? '')),
            //         DataCell(Text(item['task'] ?? '')),
            //         DataCell(Text(item['reference'] ?? '')),
            //         DataCell(Text(item['uploadFile'] ?? '')),
            //       ],
            //     );
            //   }).toList(),
            // ),
            Container(width: Get.width, height: 1, color: ThemeColorMode.isDark ? Colors.grey[800] : ColorConstants.black),
          ],
        );
      }).toList(),
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     if(nowName != abc[0]['categoryName'])
    //       DiscrepancyAndWorkOrdersTextField(
    //       textFieldController: controller.workOrderDetailsTextController.putIfAbsent('category_5_name$i', () => TextEditingController(text: controller.workOrderDetailsFullData['woCheckList'][i]['categoryName'])),
    //       maxCharacterLength: 9,
    //       dataType: 'text',
    //       readOnly: true,
    //       textFieldWidth:
    //       DeviceType.isTablet
    //           ? DeviceOrientation.isLandscape
    //           ? (Get.width / 3) - 80
    //           : (Get.width / 2) - 80
    //           : Get.width,
    //       onChanged: (value) {
    //
    //       },
    //     ),
    //     Row(
    //       children: [
    //         DataTable(
    //           columns: [
    //             DataColumn(label: Text('Initial')),
    //           ],
    //           rows: List.generate(abc.length, (index) {
    //             return DataRow(
    //               cells: [
    //                 DataCell(Text('${abc[index]['initial']}')),
    //               ]
    //             );
    //           }),
    //         ),
    //         SingleChildScrollView(
    //             scrollDirection: Axis.horizontal,
    //             child: DataTable(
    //               columns: [
    //                 DataColumn(label: Text('Task')),
    //                 DataColumn(label: Text('Reference')),
    //                 DataColumn(label: Text('Attachment')),
    //               ],
    //               rows: List.generate(abc.length, (index) {
    //                 return DataRow(
    //                     cells: [
    //                       DataCell(Text('${abc[index]['task']}')),
    //                       DataCell(Text('${abc[index]['reference']}')),
    //                       DataCell(Text('${abc[index]['uploadFile']}')),
    //                     ]
    //                 );
    //               }),
    //             )
    //         )
    //       ],
    //     ),
    //   ],
    // );
  }

  drawWoCheckListEditMode(RxMap<String, bool> isEditingCategory) {
    // final Map<String, List<Map<String, dynamic>>> grouped = {};
    // for (var item in controller.workOrderDetailsFullData['woCheckList']) {
    //   grouped.putIfAbsent(item['categoryName'], () => []).add(item);
    // }
    // RxBool test = false.obs;
    //
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: grouped.entries.map((entry) {
    //     return Obx(() {
    //
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         spacing: 5.0,
    //         children: [
    //           Wrap(
    //             children: [
    //               DiscrepancyAndWorkOrdersMaterialButton(
    //                 buttonText: 'Add New',
    //                 buttonTextColor: ThemeColorMode.isDark ? ColorConstants.grey : ColorConstants.white,
    //                 buttonColor: ColorConstants.button,
    //                 onPressed: () {},
    //               ),
    //               DiscrepancyAndWorkOrdersTextField(
    //                 textFieldController: controller.workOrderDetailsTextController.putIfAbsent('category_5_${entry.key}', () => TextEditingController(text: entry.key)),
    //                 maxCharacterLength: 100,
    //                 dataType: 'text',
    //                 readOnly: true,
    //                 textFieldWidth: Get.width,
    //                 onChanged: (value) {},
    //               ),
    //               DiscrepancyAndWorkOrdersMaterialButton(
    //                 buttonText: !test.value ? 'Edit' : 'Save',
    //                 buttonTextColor: ThemeColorMode.isDark ? ColorConstants.grey : ColorConstants.white,
    //                 buttonColor: !test.value ? ColorConstants.primary : ColorConstants.button,
    //                 onPressed: () {
    //                   test.value = !test.value;
    //                 },
    //               ),
    //               if(test.value)
    //                 DiscrepancyAndWorkOrdersMaterialButton(
    //                   buttonText: 'Cancel',
    //                   buttonTextColor: ThemeColorMode.isDark ? ColorConstants.grey : ColorConstants.white,
    //                   buttonColor:  ColorConstants.red,
    //                   onPressed: () {
    //                     test.value = false;
    //                   },
    //                 ),
    //             ],
    //           ),
    //
    //           Row(
    //             children: [
    //               DataTable(
    //                 headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
    //                 border: TableBorder.all(
    //                   color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
    //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
    //                 ),
    //                 clipBehavior: Clip.antiAlias,
    //                 columns: [
    //                   DataColumn(label: Center(child: Text('Initial', style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
    //                       .of(Get.context!)
    //                       .textTheme
    //                       .headlineMedium
    //                       ?.fontSize)))),
    //                 ],
    //                 rows: entry.value.map((item) {
    //                   return DataRow(
    //                     cells: [
    //                       DataCell(Center(child: Text(item['initial'] ?? '', style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
    //                           .of(Get.context!)
    //                           .textTheme
    //                           .headlineMedium!
    //                           .fontSize! - 1)))),
    //                     ],
    //                   );
    //                 }).toList(),
    //               ),
    //               Flexible(
    //                 child: SingleChildScrollView(
    //                     scrollDirection: Axis.horizontal,
    //                     child: DataTable(
    //                       headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
    //                       // border: TableBorder(
    //                       //   top: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
    //                       //   right: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
    //                       //   bottom: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
    //                       //   horizontalInside: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
    //                       //   verticalInside: BorderSide(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, width: 1),
    //                       //   borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
    //                       // ),
    //                       border: TableBorder.all(
    //                         color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
    //                         borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
    //                       ),
    //                       clipBehavior: Clip.antiAlias,
    //                       columns: [
    //                         DataColumn(label: Center(child: Text('Task', style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
    //                             .of(Get.context!)
    //                             .textTheme
    //                             .headlineMedium
    //                             ?.fontSize)))),
    //                         DataColumn(label: Center(child: Text('Reference', style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
    //                             .of(Get.context!)
    //                             .textTheme
    //                             .headlineMedium
    //                             ?.fontSize)))),
    //                         DataColumn(label: Center(child: Text('Attachment', style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w800, fontSize: Theme
    //                             .of(Get.context!)
    //                             .textTheme
    //                             .headlineMedium
    //                             ?.fontSize)))),
    //                       ],
    //                       rows: entry.value.map((item) {
    //                         return DataRow(
    //                           cells: [
    //                             DataCell(Center(child: Text(item['task'] ?? '', style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
    //                                 .of(Get.context!)
    //                                 .textTheme
    //                                 .headlineMedium!
    //                                 .fontSize! - 1)))),
    //                             DataCell(Center(child: Text(item['reference'] ?? '', style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
    //                                 .of(Get.context!)
    //                                 .textTheme
    //                                 .headlineMedium!
    //                                 .fontSize! - 1)))),
    //                             DataCell(Center(child: Text(item['uploadFile'] ?? '', style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
    //                                 .of(Get.context!)
    //                                 .textTheme
    //                                 .headlineMedium!
    //                                 .fontSize! - 1)))),
    //                           ],
    //                         );
    //                       }).toList(),
    //                     )
    //                 ),
    //               )
    //             ],
    //           ),
    //
    //           // DataTable(
    //           //   columns: const [
    //           //     DataColumn(label: Text('Initial')),
    //           //     DataColumn(label: Text('Task')),
    //           //     DataColumn(label: Text('Reference')),
    //           //     DataColumn(label: Text('Attachment')),
    //           //   ],
    //           //   rows: entry.value.map((item) {
    //           //     return DataRow(
    //           //       cells: [
    //           //         DataCell(Text(item['initial'] ?? '')),
    //           //         DataCell(Text(item['task'] ?? '')),
    //           //         DataCell(Text(item['reference'] ?? '')),
    //           //         DataCell(Text(item['uploadFile'] ?? '')),
    //           //       ],
    //           //     );
    //           //   }).toList(),
    //           // ),
    //           Container(
    //             width: Get.width,
    //             height: 1,
    //             color: ThemeColorMode.isDark ? Colors.grey[800] : ColorConstants.black,
    //           ),
    //         ],
    //       );
    //     });
    //   }).toList(),
    // );

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in controller.workOrderDetailsFullData['woCheckList']) {
      grouped.putIfAbsent(item['categoryName'], () => []).add(item);
      isEditingCategory.putIfAbsent(item['categoryName'], () => false);
    }

    final groupedList = grouped.entries.toList();

    TextStyle cellTextStyle() {
      return TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
          .of(Get.context!)
          .textTheme
          .headlineMedium!
          .fontSize! - 1);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(groupedList.length, (index) {
        final entry = groupedList[index];
        final category = entry.key;
        final items = entry.value;

        return Card(
          elevation: 5,
          borderOnForeground: true,
          margin: EdgeInsets.all(5.0),
          shadowColor: ColorConstants.primary.withValues(alpha: 0.8),
          color: ThemeColorMode.isDark ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: ColorConstants.primary.withValues(alpha: 0.5))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    DiscrepancyAndWorkOrdersMaterialButton(
                      buttonText: 'Add New',
                      buttonTextColor: ThemeColorMode.isDark ? ColorConstants.grey : ColorConstants.white,
                      buttonColor: ColorConstants.button,
                      onPressed: () {},
                    ),
                    Obx(() {
                      return DiscrepancyAndWorkOrdersTextField(
                        textFieldController: controller.workOrderDetailsTextController.putIfAbsent('category_5_$category', () => TextEditingController(text: category)),
                        maxCharacterLength: 100,
                        dataType: 'text',
                        readOnly: !(isEditingCategory[category] ?? false) ? true : false,
                        textFieldWidth: Get.width,
                        onChanged: (value) {},
                      );
                    }),
                    Obx(() {
                      return DiscrepancyAndWorkOrdersMaterialButton(
                        buttonText: !(isEditingCategory[category] ?? false) ? 'Edit' : 'Save',
                        buttonTextColor: ThemeColorMode.isDark ? ColorConstants.grey : ColorConstants.white,
                        buttonColor: !(isEditingCategory[category] ?? false) ? ColorConstants.primary : ColorConstants.button,
                        onPressed: () {
                          isEditingCategory[category] = !(isEditingCategory[category] ?? false);
                        },
                      );
                    }),
                    Obx(
                          () =>
                      (isEditingCategory[category] ?? false)
                          ? DiscrepancyAndWorkOrdersMaterialButton(
                        buttonText: 'Cancel',
                        buttonTextColor: ThemeColorMode.isDark ? ColorConstants.grey : ColorConstants.white,
                        buttonColor: ColorConstants.red,
                        onPressed: () {
                          isEditingCategory[category] = false;
                        },
                      )
                          : SizedBox(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    DataTable(
                      headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                      border: TableBorder.all(
                        color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      columns: [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Initial',
                              style: TextStyle(
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w800,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .headlineMedium
                                    ?.fontSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows:
                      items.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text(
                                  item['initial'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! - 1),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                          border: TableBorder.all(
                            color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          columns:
                          ['Task', 'Reference', 'Attachment'].map((colName) {
                            return DataColumn(
                              label: Center(
                                child: Text(
                                  colName,
                                  style: TextStyle(
                                    color: ColorConstants.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .headlineMedium
                                        ?.fontSize,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          rows:
                          items.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Center(child: Text(item['task'] ?? '', style: cellTextStyle()))),
                                DataCell(Center(child: Text(item['reference'] ?? '', style: cellTextStyle()))),
                                DataCell(Center(child: Text(item['uploadFile'] ?? '', style: cellTextStyle()))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(color: ThemeColorMode.isDark ? Colors.grey[800] : ColorConstants.black),
              ],
            ),
          ),
        );
      }),
    );
  }
}
