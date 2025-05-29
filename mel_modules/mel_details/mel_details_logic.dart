import 'dart:ui';

import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/mel_api_provider.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';

class MelDetailsLogic extends GetxController {
  RxBool isLoading = false.obs;

  RxBool discrepancyPlacardInstalled = false.obs;
  RxBool discrepancyPartsOnOrder = false.obs;
  RxBool correctiveActionOwnerNotified = false.obs;
  RxBool correctiveActionPlacardRemoved = false.obs;

  RxList melFiles = [].obs;

  RxMap<String, String> melCreateEditTime = {
    "createdAt": "",
    "lastEditAt": "",
  }.obs;

  RxList melCreateTime = [].obs;

  RxList melEditTime = [].obs;

  RxList melCorrectiveAction = [].obs;

  RxMap melDetailsData = {}.obs;

  @override
  void onInit() async {
    super.onInit();
    await melDetailsApiCall();
    await melCreateEditTimeProcessing();
  }

  melDetailsApiCall({bool refresh = false}) async {
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    Response data = await MelApiProvider().melDetailsData(melId: int.parse(Get.parameters["melId"] ?? "0"), melType: Get.parameters["melType"] ?? "Mel");

    if (data.statusCode == 200) {
      if (refresh == true) {
        melDetailsData.clear();
        melDetailsData.addAll(data.data["data"] as Map);
        discrepancyPlacardInstalled.value = data.data["data"]["isPlacardInstalled"];
        discrepancyPartsOnOrder.value = data.data["data"]["isPartsOnOrder"];
        correctiveActionOwnerNotified.value = data.data["data"]["isOwnerNotified"];
        correctiveActionPlacardRemoved.value = data.data["data"]["isPlacardRemoved"];

        if (melDetailsData["melFiles"] != null) {
          melFiles.addAll(melDetailsData["melFiles"]);
        }

        await someDataCheck();
      } else {
        melDetailsData.addAll(data.data["data"] as Map);
        discrepancyPlacardInstalled.value = data.data["data"]["isPlacardInstalled"];
        discrepancyPartsOnOrder.value = data.data["data"]["isPartsOnOrder"];
        correctiveActionOwnerNotified.value = data.data["data"]["isOwnerNotified"];
        correctiveActionPlacardRemoved.value = data.data["data"]["isPlacardRemoved"];

        if (melDetailsData["melFiles"] != null) {
          melFiles.addAll(melDetailsData["melFiles"]);
        }

        await someDataCheck();
      }
    }
    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  melCreateEditTimeProcessing() {
    melCreateEditTime["createdAt"] = melDetailsData["createdAt"];
    melCreateEditTime["lastEditAt"] = melDetailsData["lastEditAt"];

    melCreateTime.value = melCreateEditTime["createdAt"]!.split(' ');
    melEditTime.value = melCreateEditTime["lastEditAt"]!.split(' ');

    melCorrectiveAction.value = melDetailsData["discrepancy"].split('.');

    //print(melCorrectiveAction.length);

    //melDetailsData["createdAt"] = "${melCreateTime[0]}\n${melCreateTime[1]}${melCreateTime[2]}";
    //melDetailsData["createdAt"] = "${melEditTime[0]}\n${melEditTime[1]}${melEditTime[2]}";
  }

  melDetailsViewTablet() {
    return Column(
      children: [
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(width: 2, color: ColorConstants.primary)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Material(
                  color: ColorConstants.grey.withValues(alpha: 0.5),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: Column(
                      children: [
                        Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: DeviceOrientation.isPortrait ? {2: const FixedColumnWidth(0.0), 4: FixedColumnWidth(Get.width / 3.5)} : null,
                          children: <TableRow>[
                            TableRow(children: [
                              returnMelTitleView(title: "Created By: "),
                              returnMelTitleValueView(value: melDetailsData["createdByName"] ?? "", createdBy: true, subValue: melDetailsData["createdByCert"] ?? ""),
                              const SizedBox(),
                              if (DeviceOrientation.isLandscape) const SizedBox(),
                              returnMelTitleView(title: "Created At: "),
                              returnMelTitleValueView(value: melDetailsData["createdAt"] ?? "")
                            ]),
                          ],
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        const DottedLine(
                          direction: Axis.horizontal,
                          lineThickness: 2.0,
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: DeviceOrientation.isPortrait ? {2: const FixedColumnWidth(0.0), 4: FixedColumnWidth(Get.width / 3.5)} : null,
                          children: <TableRow>[
                            TableRow(children: [
                              returnMelTitleView(title: "Last Edited By:"),
                              returnMelTitleValueView(value: melDetailsData["lastEditedByName"] ?? "", createdBy: true, subValue: melDetailsData["lastEditedByCert"] ?? ""),
                              const SizedBox(),
                              if (DeviceOrientation.isLandscape) const SizedBox(),
                              returnMelTitleView(title: "Last Edit At: "),
                              returnMelTitleValueView(value: melDetailsData["lastEditAt"] ?? "")
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: ColorConstants.primary,
                height: SizeConstants.contentSpacing * 5,
                width: Get.width,
                child: Center(
                    child: Text("Discrepancy",
                        style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold))),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {2: FixedColumnWidth(0.0)},
                children: <TableRow>[
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Placard Installed:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: discrepancyPlacardInstalled.value,
                            onChanged: null,
                            inactiveThumbColor: discrepancyPlacardInstalled.value ? Colors.green : Colors.white,
                            inactiveTrackColor: discrepancyPlacardInstalled.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        returnMelTitleView(title: "Part's On Order:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: discrepancyPartsOnOrder.value
                              ? Row(
                                  children: [
                                    Switch(
                                      value: discrepancyPartsOnOrder.value,
                                      onChanged: null,
                                      inactiveThumbColor: discrepancyPartsOnOrder.value ? Colors.green : Colors.white,
                                      inactiveTrackColor: discrepancyPartsOnOrder.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                    ),
                                    Text("[#: ${melDetailsData["purchaseNumber"]}]")
                                  ],
                                )
                              : Switch(
                                  value: discrepancyPartsOnOrder.value,
                                  onChanged: null,
                                  inactiveThumbColor: discrepancyPartsOnOrder.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: discrepancyPartsOnOrder.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                        ),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Aircraft:"),
                        returnMelTitleValueView(value: "${melDetailsData["aircraftName"]} [SN: ${melDetailsData["serialNumber"]}]"),
                        const SizedBox(height: 60.0),
                        returnMelTitleView(title: "Log Page #:"),
                        returnMelTitleValueView(value: melDetailsData["logPage"] ?? "")
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Model:"),
                        returnMelTitleValueForMelItem(value: melDetailsData["aircraftType"] ?? "", isTablet: true),
                        //returnMelTitleValueView(value: melDetailsData["aircraftType"] == "" ? "" :"${melDetailsData["aircraftType"]} [FAA MMEL]"),
                        const SizedBox(height: 60.0),
                        returnMelTitleView(title: "Date Deferred: "),
                        returnMelTitleValueView(value: melDetailsData["deferredDate"] ?? "")
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "MEL Item #:"),
                        returnMelTitleValueView(value: melDetailsData["mELItemNumber"] ?? ""),
                        const SizedBox(height: 60.0),
                        returnMelTitleView(title: "Expiration Date:"),
                        returnMelTitleValueView(value: melDetailsData["expirationDate"] ?? "")
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Revision #:"),
                        returnMelTitleValueView(value: melDetailsData["revisionNumber"] ?? ""),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox()
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Category:"),
                        returnMelTitleValueView(value: melDetailsData["category"] ?? ""),
                        const SizedBox(height: 60.0),
                        returnMelTitleView(title: "Extended:"),
                        melDetailsData["isExtended"] != true
                            ? returnMelTitleValueView(value: melDetailsData["isExtended"].toString())
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  color: ColorConstants.black.withValues(alpha: 0.3),
                                  onPressed: () async {
                                    await melFileViewDialog();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: SizeConstants.contentSpacing * 2 + 5),
                                      const SizedBox(width: SizeConstants.contentSpacing - 5),
                                      Expanded(
                                        child: Text(
                                          "View Documents",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! - 3, color: Colors.white, letterSpacing: 1.1),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ]),
                ],
              ),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.2),
                child: SizedBox(
                  height: 60.0 + (melDetailsData["discrepancy"].length ?? 1 * 0.3),
                  child: Row(
                    children: [returnMelTitleView(title: "Discrepancy: "), returnMelTitleValueView(value: melDetailsData["discrepancy"])],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SizeConstants.contentSpacing - 5),
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(width: 2, color: ColorConstants.primary)),
          child: Column(
            children: [
              Container(
                height: SizeConstants.contentSpacing * 5,
                decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), topLeft: Radius.circular(5.0))),
                width: Get.width,
                child: Center(
                    child: Text("Corrective Action",
                        style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold))),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {2: const FixedColumnWidth(0.0), 3: FixedColumnWidth(Get.width / 4)},
                children: <TableRow>[
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Owner Notified:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: correctiveActionOwnerNotified.value,
                            onChanged: null,
                            inactiveThumbColor: correctiveActionOwnerNotified.value ? Colors.green : Colors.white,
                            inactiveTrackColor: correctiveActionOwnerNotified.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        returnMelTitleView(title: "Placard Removed: "),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: correctiveActionPlacardRemoved.value,
                            onChanged: null,
                            inactiveThumbColor: correctiveActionPlacardRemoved.value ? Colors.green : Colors.white,
                            inactiveTrackColor: correctiveActionPlacardRemoved.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                          ),
                        ),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Log Page: "),
                        returnMelTitleValueView(value: melDetailsData["correctiveActionLogPage"]),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox(),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        returnMelTitleView(title: "Cleared Date:"),
                        returnMelTitleValueView(value: melDetailsData["clearedDate"]),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox(),
                      ]),
                ],
              ),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.4),
                child: SizedBox(
                  height: 60.0 + (melDetailsData["correctiveAction"].length * 0.3),
                  child: Row(
                    children: [returnMelTitleView(title: "Corrective Action: "), returnMelTitleValueView(value: melDetailsData["correctiveAction"])],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  melDetailsViewMobile() {
    return Column(
      children: [
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(width: 2, color: ColorConstants.primary)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: DeviceOrientation.isPortrait
                    ? Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const {2: FixedColumnWidth(0.0)},
                        children: <TableRow>[
                          TableRow(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0), topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.4),
                              ),
                              children: [
                                returnMelTitleView(title: "Created By: "),
                                returnMelTitleValueView(value: melDetailsData["createdByName"], createdBy: true, subValue: melDetailsData["createdByCert"]),
                                const SizedBox(height: 60.0),
                              ]),
                          TableRow(
                              decoration: BoxDecoration(
                                //borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.2),
                              ),
                              children: [returnMelTitleView(title: "Created At: "), returnMelTitleValueView(value: melDetailsData["createdAt"]), const SizedBox(height: 60.0)]),
                          TableRow(
                              decoration: BoxDecoration(
                                //borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.4),
                              ),
                              children: [
                                returnMelTitleView(title: "Last Edited By:"),
                                returnMelTitleValueView(value: melDetailsData["lastEditedByName"], createdBy: true, subValue: melDetailsData["lastEditedByCert"]),
                                const SizedBox(height: 60.0)
                              ]),
                          TableRow(
                              decoration: BoxDecoration(
                                //borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.2),
                              ),
                              children: [returnMelTitleView(title: "Last Edit At: "), returnMelTitleValueView(value: melDetailsData["lastEditAt"]), const SizedBox(height: 60.0)]),
                        ],
                      )
                    : Material(
                        color: ColorConstants.grey.withValues(alpha: 0.5),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: Column(
                              children: [
                                Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FixedColumnWidth(150.0),
                                    1: FixedColumnWidth(250.0),
                                    2: FixedColumnWidth(30.0),
                                    3: FixedColumnWidth(150.0),
                                    4: FixedColumnWidth(250.0)
                                  },
                                  children: <TableRow>[
                                    TableRow(children: [
                                      returnMelTitleView(title: "Created By: "),
                                      returnMelTitleValueView(value: melDetailsData["createdByName"], createdBy: true, subValue: melDetailsData["createdByCert"]),
                                      const SizedBox(),
                                      returnMelTitleView(title: "Created At: "),
                                      returnMelTitleValueView(value: melDetailsData["createdAt"])
                                    ]),
                                  ],
                                ),
                                const SizedBox(height: SizeConstants.contentSpacing + 10),
                                const DottedLine(
                                  direction: Axis.horizontal,
                                  lineThickness: 2.0,
                                ),
                                const SizedBox(height: SizeConstants.contentSpacing + 10),
                                Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FixedColumnWidth(150.0),
                                    1: FixedColumnWidth(250.0),
                                    2: FixedColumnWidth(30.0),
                                    3: FixedColumnWidth(150.0),
                                    4: FixedColumnWidth(250.0)
                                  },
                                  children: <TableRow>[
                                    TableRow(children: [
                                      returnMelTitleView(title: "Last Edited By:"),
                                      returnMelTitleValueView(value: melDetailsData["lastEditedByName"], createdBy: true, subValue: melDetailsData["lastEditedByCert"]),
                                      const SizedBox(),
                                      returnMelTitleView(title: "Last Edit At: "),
                                      returnMelTitleValueView(value: melDetailsData["lastEditAt"])
                                    ]),
                                  ],
                                ),
                              ],
                            )),
                      ),
              ),
              Container(
                color: ColorConstants.primary,
                height: SizeConstants.contentSpacing * 5,
                width: Get.width,
                child: Center(
                    child: Text("Discrepancy",
                        style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold))),
              ),
              DeviceOrientation.isPortrait
                  ? Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const {2: FixedColumnWidth(0.0)},
                      children: <TableRow>[
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Placard Installed:"),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: discrepancyPlacardInstalled.value,
                                  onChanged: null,
                                  inactiveThumbColor: discrepancyPlacardInstalled.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: discrepancyPlacardInstalled.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Aircraft:"),
                              returnMelTitleValueView(value: "${melDetailsData["aircraftName"]} [SN: ${melDetailsData["serialNumber"]}]"),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Model:"),
                              returnMelTitleValueForMelItem(value: melDetailsData["aircraftType"]),
                              //returnMelTitleValueView(value: "${melDetailsData["aircraftType"]} [FAA MMEL]"),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "MEL Item #:"),
                              returnMelTitleValueView(value: melDetailsData["mELItemNumber"]),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Revision #:"),
                              returnMelTitleValueView(value: melDetailsData["revisionNumber"]),
                              const SizedBox(height: 60.0),
                              // const SizedBox(),
                              // const SizedBox()
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Category:"),
                              returnMelTitleValueView(value: melDetailsData["category"]),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: [
                              returnMelTitleView(title: "Part's On Order:"),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: discrepancyPartsOnOrder.value
                                    ? Row(
                                        children: [
                                          Switch(
                                            value: discrepancyPartsOnOrder.value,
                                            onChanged: null,
                                            inactiveThumbColor: discrepancyPartsOnOrder.value ? Colors.green : Colors.white,
                                            inactiveTrackColor: discrepancyPartsOnOrder.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                          ),
                                          Text("[#: ${melDetailsData["purchaseNumber"]}]")
                                        ],
                                      )
                                    : Switch(
                                        value: discrepancyPartsOnOrder.value,
                                        onChanged: null,
                                        inactiveThumbColor: discrepancyPartsOnOrder.value ? Colors.green : Colors.white,
                                        inactiveTrackColor: discrepancyPartsOnOrder.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                      ),
                              ),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: [
                              returnMelTitleView(title: "Log Page #:"),
                              returnMelTitleValueView(value: melDetailsData["logPage"]),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: [
                              returnMelTitleView(title: "Date Deferred: "),
                              returnMelTitleValueView(value: melDetailsData["deferredDate"]),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: [
                              returnMelTitleView(title: "Expiration Date:"),
                              returnMelTitleValueView(value: melDetailsData["expirationDate"]),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: [
                              returnMelTitleView(title: "Extended:"),
                              melDetailsData["isExtended"] != true
                                  ? returnMelTitleValueView(value: melDetailsData["isExtended"].toString())
                                  : Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        color: ColorConstants.black.withValues(alpha: 0.3),
                                        onPressed: () async {
                                          await melFileViewDialog();
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: SizeConstants.contentSpacing * 2 + 5),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "\tView Documents\t",
                                                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! - 3, color: Colors.white, letterSpacing: 1.1),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 60.0),
                            ]),
                      ],
                    )
                  : Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const {2: FixedColumnWidth(0.0)},
                      children: <TableRow>[
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Placard Installed:"),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: discrepancyPlacardInstalled.value,
                                  onChanged: null,
                                  inactiveThumbColor: discrepancyPlacardInstalled.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: discrepancyPlacardInstalled.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(height: 60.0),
                              returnMelTitleView(title: "Part's On Order:"),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: discrepancyPartsOnOrder.value
                                    ? Row(
                                        children: [
                                          Switch(
                                            value: discrepancyPartsOnOrder.value,
                                            onChanged: null,
                                            inactiveThumbColor: discrepancyPartsOnOrder.value ? Colors.green : Colors.white,
                                            inactiveTrackColor: discrepancyPartsOnOrder.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                          ),
                                          Text("[#: ${melDetailsData["purchaseNumber"]}]")
                                        ],
                                      )
                                    : Switch(
                                        value: discrepancyPartsOnOrder.value,
                                        onChanged: null,
                                        inactiveThumbColor: discrepancyPartsOnOrder.value ? Colors.green : Colors.white,
                                        inactiveTrackColor: discrepancyPartsOnOrder.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                      ),
                              ),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Aircraft:"),
                              returnMelTitleValueView(value: "${melDetailsData["aircraftName"]} [SN: ${melDetailsData["serialNumber"]}]"),
                              const SizedBox(height: 60.0),
                              returnMelTitleView(title: "Log Page #:"),
                              returnMelTitleValueView(value: melDetailsData["logPage"])
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Model:"),
                              returnMelTitleValueForMelItem(value: melDetailsData["aircraftType"]),
                              //returnMelTitleValueView(value: "${melDetailsData["aircraftType"]} [FAA MMEL]"),
                              const SizedBox(height: 60.0),
                              returnMelTitleView(title: "Date Deferred: "),
                              returnMelTitleValueView(value: melDetailsData["deferredDate"])
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "MEL Item #:"),
                              returnMelTitleValueView(value: melDetailsData["mELItemNumber"]),
                              const SizedBox(height: 60.0),
                              returnMelTitleView(title: "Expiration Date:"),
                              returnMelTitleValueView(value: melDetailsData["expirationDate"])
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Revision #:"),
                              returnMelTitleValueView(value: melDetailsData["revisionNumber"]),
                              const SizedBox(height: 60.0),
                              const SizedBox(),
                              const SizedBox()
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Category:"),
                              returnMelTitleValueView(value: melDetailsData["category"]),
                              const SizedBox(height: 60.0),
                              returnMelTitleView(title: "Extended:"),
                              returnMelTitleValueView(value: melDetailsData["isExtended"].toString())
                            ]),
                      ],
                    ),
              Material(
                color: DeviceOrientation.isPortrait ? ColorConstants.primary.withValues(alpha: 0.4) : ColorConstants.primary.withValues(alpha: 0.2),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                child: SizedBox(
                  height: DeviceOrientation.isPortrait ? 60.0 + (30.0 + melDetailsData["discrepancy"].length * 0.6) : 60.0 + (10.0 + melDetailsData["discrepancy"].length * 0.2),
                  width: Get.width,
                  child: DeviceOrientation.isPortrait
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Column(
                            children: [
                              returnMelTitleView(title: "Discrepancy"),
                              returnMelTitleValueView(value: melDetailsData["discrepancy"]),
                            ],
                          ),
                        )
                      : Row(
                          children: [returnMelTitleView(title: "Discrepancy: "), returnMelTitleValueView(value: melDetailsData["discrepancy"])],
                        ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: SizeConstants.contentSpacing + 10),
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(width: 2, color: ColorConstants.primary)),
          child: Column(
            children: [
              Container(
                height: SizeConstants.contentSpacing * 5,
                decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), topLeft: Radius.circular(5.0))),
                width: Get.width,
                child: Center(
                    child: Text("Corrective Action",
                        style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold))),
              ),
              DeviceOrientation.isPortrait
                  ? Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: {2: const FixedColumnWidth(0.0), 3: FixedColumnWidth(Get.width / 4)},
                      children: <TableRow>[
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Owner Notified:"),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: correctiveActionOwnerNotified.value,
                                  onChanged: null,
                                  inactiveThumbColor: correctiveActionOwnerNotified.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: correctiveActionOwnerNotified.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(height: 60.0),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Log Page: "),
                              returnMelTitleValueView(value: melDetailsData["correctiveActionLogPage"]),
                              const SizedBox(height: 60.0),
                              // const SizedBox(),
                              // const SizedBox(),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Cleared Date:"),
                              returnMelTitleValueView(value: melDetailsData["clearedDate"]),
                              const SizedBox(height: 60.0),
                              // const SizedBox(),
                              // const SizedBox(),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Placard Removed: "),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: correctiveActionPlacardRemoved.value,
                                  onChanged: null,
                                  inactiveThumbColor: correctiveActionPlacardRemoved.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: correctiveActionPlacardRemoved.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(height: 60.0),
                              // const SizedBox(),
                              // const SizedBox(),
                            ]),
                      ],
                    )
                  : Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: {2: const FixedColumnWidth(0.0), 3: FixedColumnWidth(Get.width / 4)},
                      children: <TableRow>[
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Owner Notified:"),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: correctiveActionOwnerNotified.value,
                                  onChanged: null,
                                  inactiveThumbColor: correctiveActionOwnerNotified.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: correctiveActionOwnerNotified.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(height: 60.0),
                              returnMelTitleView(title: "Placard Removed: "),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: correctiveActionPlacardRemoved.value,
                                  onChanged: null,
                                  inactiveThumbColor: correctiveActionPlacardRemoved.value ? Colors.green : Colors.white,
                                  inactiveTrackColor: correctiveActionPlacardRemoved.value ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.4),
                                ),
                              ),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.4),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Log Page: "),
                              returnMelTitleValueView(value: melDetailsData["correctiveActionLogPage"]),
                              const SizedBox(height: 60.0),
                              const SizedBox(),
                              const SizedBox(),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: ColorConstants.primary.withValues(alpha: 0.2),
                            ),
                            children: <Widget>[
                              returnMelTitleView(title: "Cleared Date:"),
                              returnMelTitleValueView(value: melDetailsData["clearedDate"]),
                              const SizedBox(height: 60.0),
                              const SizedBox(),
                              const SizedBox()
                            ]),
                      ],
                    ),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.4),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                child: SizedBox(
                  height: DeviceOrientation.isPortrait
                      ? 60.0 + (30.0 + melDetailsData["correctiveAction"].length * 0.6)
                      : 60.0 + (10.0 + melDetailsData["correctiveAction"].length * 0.2),
                  width: Get.width,
                  child: DeviceOrientation.isPortrait
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Column(
                            children: [returnMelTitleView(title: "Corrective Action: "), returnMelTitleValueView(value: melDetailsData["correctiveAction"])],
                          ),
                        )
                      : Row(
                          children: [returnMelTitleView(title: "Corrective Action: "), returnMelTitleValueView(value: melDetailsData["correctiveAction"])],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  returnMelDetailsView({required String title, required String titleValue, required String subTitleValue, bool createdBy = false}) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.bold)),
        const SizedBox(width: SizeConstants.contentSpacing),
        titleValue.length > 50
            ? Flexible(child: Text(titleValue, softWrap: true, overflow: TextOverflow.visible))
            : createdBy
                ? RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                        text: titleValue,
                        style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                        children: <TextSpan>[
                          const TextSpan(text: "("),
                          TextSpan(text: subTitleValue, style: const TextStyle(color: Colors.blue)),
                          const TextSpan(text: ")"),
                        ]),
                  )
                : Text(titleValue == "" ? "None" : titleValue, softWrap: true, style: TextStyle(color: titleValue == "" ? Colors.red : null))
      ],
    );
  }

  returnMelTitleView({required String title}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
      child: Text(title, style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.bold)),
    );
  }

  returnMelTitleValueView({required String value, String? subValue, bool createdBy = false}) {
    return value.length > 50
        ? Flexible(child: Text(value, softWrap: true, overflow: TextOverflow.visible))
        : createdBy
            ? value == ""
                ? Text(value == "" ? "None" : value, softWrap: true, style: TextStyle(color: value == "" ? Colors.red : null))
                : RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                        text: value,
                        style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                        children: <TextSpan>[
                          const TextSpan(text: "("),
                          TextSpan(text: subValue, style: const TextStyle(color: Colors.blue)),
                          const TextSpan(text: ")"),
                        ]),
                  )
            : Text(value == "" ? "None" : value, softWrap: true, style: TextStyle(color: value == "" ? Colors.red : null));
  }

  someDataCheck() async {
    if (melDetailsData["deferredDate"] == "01/01/1900") {
      melDetailsData["deferredDate"] = "";
    }

    if (melDetailsData["expirationDate"] == "01/01/1900") {
      melDetailsData["expirationDate"] = "";
    }

    if (melDetailsData["clearedDate"] == "01/01/1900") {
      melDetailsData["clearedDate"] = "";
    }
  }

  returnMelTitleValueForMelItem({required String value, bool isTablet = false}) {
    return value == ""
        ? Text("None", softWrap: true, style: TextStyle(color: Colors.red, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1))
        : isTablet
            ? DeviceOrientation.isPortrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                      ),
                      const SizedBox(width: SizeConstants.contentSpacing + 10),
                      InkWell(
                        onTap: () async {
                          Uri url = Uri.parse(UrlConstants.masterMinimumEquipmentListLink);
                          var urlLaunchAble = await canLaunchUrl(url);
                          if (urlLaunchAble) {
                            await launchUrl(url);
                          } else {
                            SnackBarHelper.openSnackBar(isError: true, message: "URL can't be launched.");
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              "[",
                              style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                            ),
                            Icon(Icons.open_in_new, color: Colors.red, size: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 8),
                            Text(
                              "FAA MMEL]",
                              style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Text(
                        value,
                        style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                      ),
                      const SizedBox(width: SizeConstants.contentSpacing + 10),
                      InkWell(
                        onTap: () async {
                          Uri url = Uri.parse(UrlConstants.masterMinimumEquipmentListLink);
                          var urlLaunchAble = await canLaunchUrl(url);
                          if (urlLaunchAble) {
                            await launchUrl(url);
                          } else {
                            SnackBarHelper.openSnackBar(isError: true, message: "URL can't be launched.");
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              "[",
                              style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                            ),
                            Icon(Icons.open_in_new, color: Colors.red, size: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 8),
                            Text(
                              "FAA MMEL]",
                              style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                  ),
                  const SizedBox(width: SizeConstants.contentSpacing + 10),
                  InkWell(
                    onTap: () async {
                      Uri url = Uri.parse(UrlConstants.masterMinimumEquipmentListLink);
                      var urlLaunchAble = await canLaunchUrl(url);
                      if (urlLaunchAble) {
                        await launchUrl(url);
                      } else {
                        SnackBarHelper.openSnackBar(isError: true, message: "URL can't be launched.");
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          "[",
                          style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                        ),
                        Icon(Icons.open_in_new, color: Colors.red, size: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 8),
                        Text(
                          "FAA MMEL]",
                          style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
                        )
                      ],
                    ),
                  ),
                ],
              );
  }

  melFileViewDialog() {
    return showDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Padding(
            padding: DeviceType.isTablet
                ? DeviceOrientation.isLandscape
                    ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0)
                    : const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 50.0)
                : const EdgeInsets.all(5.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Dialog(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: const BorderSide(color: ColorConstants.primary, width: 2),
                ),
                child: Material(
                  color: ColorConstants.primary.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "View Documents",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        melFiles.isEmpty
                            ? const Text(
                                "No documents attached with this Mel",
                                style: TextStyle(color: Colors.red),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: melFiles.length,
                                itemBuilder: (context, item) {
                                  return MaterialButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    color: ColorConstants.black.withValues(alpha: 0.3),
                                    onPressed: () async {
                                      await FileControl.getPathAndViewFile(fileId: melFiles[item]["uploadsId"].toString(), fileName: "New item ${item + 1}");
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: SizeConstants.contentSpacing * 2 + 5),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextScroll(
                                            melFiles[item]["fileName"],
                                            velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                                            delayBefore: const Duration(milliseconds: 1500),
                                            numberOfReps: 5,
                                            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
