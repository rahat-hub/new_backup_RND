import 'package:aviation_rnd/modules/mel_modules/mel_edit/mel_edit_logic.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/widgets/text_fields.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../shared/services/device_orientation.dart';
import '../../../../../shared/services/keyboard.dart';

class MelEditView {
  editMelDataMobileViewReturn(MelEditLogic controller) {
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
                                controller.returnMelTitleView(title: "Created By: "),
                                controller.returnMelTitleValueView(
                                    value: controller.melEditData["createdByName"], createdBy: true, subValue: controller.melEditData["createdByCert"]),
                                const SizedBox(height: 60.0),
                              ]),
                          TableRow(
                              decoration: BoxDecoration(
                                //borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.2),
                              ),
                              children: [
                                controller.returnMelTitleView(title: "Created At: "),
                                controller.returnMelTitleValueView(value: controller.melEditData["createdAt"]),
                                const SizedBox(height: 60.0)
                              ]),
                          TableRow(
                              decoration: BoxDecoration(
                                //borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.4),
                              ),
                              children: [
                                controller.returnMelTitleView(title: "Last Edited By:"),
                                controller.returnMelTitleValueView(
                                    value: controller.melEditData["lastEditedByName"], createdBy: true, subValue: controller.melEditData["lastEditedByCert"]),
                                const SizedBox(height: 60.0)
                              ]),
                          TableRow(
                              decoration: BoxDecoration(
                                //borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                                color: ColorConstants.grey.withValues(alpha: 0.2),
                              ),
                              children: [
                                controller.returnMelTitleView(title: "Last Edit At: "),
                                controller.returnMelTitleValueView(value: controller.melEditData["lastEditAt"]),
                                const SizedBox(height: 60.0)
                              ]),
                        ],
                      )
                    : Material(
                        color: ColorConstants.grey.withValues(alpha: 0.5),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {2: const FixedColumnWidth(0.0), 4: FixedColumnWidth(Get.width / 3.5)},
                            children: <TableRow>[
                              TableRow(children: [
                                controller.returnMelTitleView(title: "Created By: "),
                                controller.returnMelTitleValueView(
                                    value: controller.melEditData["createdByName"], createdBy: true, subValue: controller.melEditData["createdByCert"]),
                                const SizedBox(),
                                controller.returnMelTitleView(title: "Created At: "),
                                controller.returnMelTitleValueView(value: controller.melEditData["createdAt"])
                              ]),
                              TableRow(children: [
                                controller.returnMelTitleView(title: "Last Edited By:"),
                                controller.returnMelTitleValueView(
                                    value: controller.melEditData["lastEditedByName"], createdBy: true, subValue: controller.melEditData["lastEditedByCert"]),
                                const SizedBox(),
                                controller.returnMelTitleView(title: "Last Edit At: "),
                                controller.returnMelTitleValueView(value: controller.melEditData["lastEditAt"])
                              ]),
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
                        controller.returnMelTitleView(title: "Placard Installed:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["discrepancyPlacardInstalled"]!,
                            onChanged: (a) {
                              controller.melBoolData["discrepancyPlacardInstalled"] = a;
                              controller.melEditPostData["isPlacardInstalled"] = controller.melBoolData["discrepancyPlacardInstalled"];
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Aircraft:"),
                        controller.returnMelTitleValueView(value: "${controller.melEditData["aircraftName"]} [SN: ${controller.melEditData["serialNumber"]}]"),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Model:"),
                        controller.returnMelTitleValueView(value: "${controller.melEditData["aircraftType"]} [FAA MMEL]"),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "MEL Item #:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "mel_item",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("mel_item", () => TextEditingController()),
                                    hintText: "MEL item",
                                    onChange: (value) {
                                      controller.melEditPostData["mELItemNumber"] = value;
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Revision #:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "revision",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("revision", () => TextEditingController()),
                                    hintText: "Revision",
                                    onChange: (value) {
                                      controller.melEditPostData["revisionNumber"] = value;
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        // const SizedBox(),
                        // const SizedBox()
                      ]),
                ],
              ),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.4),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: SizedBox(
                    width: Get.width,
                    child: Column(
                      children: [
                        controller.returnMelTitleView(title: "Category"),
                        if (controller.melCategory["categoryA"]! == false &&
                            controller.melCategory["categoryB"]! == false &&
                            controller.melCategory["categoryC"]! == false &&
                            controller.melCategory["categoryD"]! == false)
                          if (controller.melCategory["categoryNotSelected"]! == true)
                            const Text("[You changed Deferred Date. Select a Category for Expiration Date]",
                                textAlign: TextAlign.center, style: TextStyle(color: ColorConstants.red)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "A",
                                    melCategoryValue: controller.melCategory["categoryA"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryA"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      if (value == true) {
                                        controller.customCategoryADialogView();
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryA"] = !controller.melCategory["categoryA"]!;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      controller.someDataCheck();
                                      if (controller.melCategory["categoryA"] == true) {
                                        controller.customCategoryADialogView();
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "B",
                                    melCategoryValue: controller.melCategory["categoryB"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryB"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      controller.melEditPostData["category"] = 'B';
                                      if (value == true) {
                                        controller.expirationDateCount(dateCount: "3");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryB"] = !controller.melCategory["categoryB"]!;
                                      controller.melEditPostData["category"] = 'B';
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      if (controller.melCategory["categoryB"] == true) {
                                        controller.expirationDateCount(dateCount: "3");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "C",
                                    melCategoryValue: controller.melCategory["categoryC"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryC"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      controller.melEditPostData["category"] = 'C';
                                      if (value == true) {
                                        controller.expirationDateCount(dateCount: "10");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryC"] = !controller.melCategory["categoryC"]!;
                                      controller.melEditPostData["category"] = 'C';
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      if (controller.melCategory["categoryC"] == true) {
                                        controller.expirationDateCount(dateCount: "10");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "D",
                                    melCategoryValue: controller.melCategory["categoryD"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryD"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melEditPostData["category"] = 'D';
                                      if (value == true) {
                                        controller.expirationDateCount(dateCount: "120");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryD"] = !controller.melCategory["categoryD"]!;
                                      controller.melEditPostData["category"] = 'D';
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      if (controller.melCategory["categoryD"] == true) {
                                        controller.expirationDateCount(dateCount: "120");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.melCategory["categoryA"] == true) controller.returnRepairCategory(value: 'A'),
              if (controller.melCategory["categoryB"] == true) controller.returnRepairCategory(value: 'B'),
              if (controller.melCategory["categoryC"] == true) controller.returnRepairCategory(value: 'C'),
              if (controller.melCategory["categoryD"] == true) controller.returnRepairCategory(value: 'D'),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {2: FixedColumnWidth(0.0)},
                children: <TableRow>[
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: [
                        controller.returnMelTitleView(title: "Part's On Order:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["discrepancyPartsOnOrder"]!,
                            onChanged: (a) {
                              controller.melBoolData["discrepancyPartsOnOrder"] = a;
                              controller.melEditPostData["isPartsOnOrder"] = a;
                              if (controller.melBoolData["discrepancyPartsOnOrder"] == false) {
                                controller.melEditTextEditingFieldController["po_number"]!.text = "";
                                controller.melEditPostData["purchaseNumber"] = "";
                              }
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  if (controller.melBoolData["discrepancyPartsOnOrder"]! == true)
                    TableRow(
                        decoration: BoxDecoration(
                          color: ColorConstants.primary.withValues(alpha: 0.2),
                        ),
                        children: <Widget>[
                          controller.returnMelTitleView(title: "PO Number:"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                            child: ResponsiveBuilder(
                              builder: (context, sizingInformation) => FormBuilderField(
                                name: "po_number",
                                validator: null,
                                builder: (FormFieldState<dynamic> field) {
                                  return TextFieldConstant.dynamicTextField(
                                      field: field,
                                      controller: controller.melEditTextEditingFieldController.putIfAbsent("po_number", () => TextEditingController()),
                                      hintText: "PO Number",
                                      onChange: (value) {
                                        controller.melEditPostData["purchaseNumber"] = value;
                                      });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 60.0),
                          // const SizedBox(),
                          // const SizedBox()
                        ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: [
                        controller.returnMelTitleView(title: "Log Page #:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "log_page_discrepancy",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("log_page_discrepancy", () => TextEditingController()),
                                    hintText: "Log Page",
                                    onChange: (value) {
                                      controller.melEditPostData["logPage"] = value;
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: [
                        controller.returnMelTitleView(title: "Date Deferred: "),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "date_deferred",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("date_deferred", () => TextEditingController()),
                                    hintText: "mm/dd/yyyy",
                                    onTap: () {
                                      Keyboard.close(context: context);
                                      DatePicker.showDatePicker(context,
                                          minDateTime: DateTime(2010, 1, 1),
                                          maxDateTime: DateTime(2050, 12, 31),
                                          initialDateTime: DateFormat('MM/dd/yyyy').parse(controller.melEditTextEditingFieldController["date_deferred"]!.text),
                                          onConfirm: (date, list) {
                                        controller.melEditTextEditingFieldController["date_deferred"]!.text = DateFormat('MM/dd/yyyy').format(date);
                                        controller.melEditPostData["deferredDate"] = controller.melEditTextEditingFieldController["date_deferred"]!.text;
                                        controller.melCategory["categoryA"] = false;
                                        controller.melCategory["categoryB"] = false;
                                        controller.melCategory["categoryC"] = false;
                                        controller.melCategory["categoryC"] = false;
                                        controller.melEditTextEditingFieldController["expiration_date"]!.text = "mm/dd/yyyy";
                                        controller.melEditPostData["expirationDate"] = "";
                                        controller.melCategory["categoryNotSelected"] = true;
                                        Keyboard.close(context: context);
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: [
                        controller.returnMelTitleView(title: "Expiration Date:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "expiration_date",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("expiration_date", () => TextEditingController()),
                                    readOnly: true,
                                    hintText: "mm/dd/yyyy");
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: [
                        controller.returnMelTitleView(title: "Extended:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["extendedMel"]!,
                            onChanged: (a) {
                              controller.melBoolData["extendedMel"] = a;
                              controller.saveAndUploadButtonShow.value = a;
                              controller.melEditPostData["isExtended"] = controller.melBoolData["extendedMel"];
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                ],
              ),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.2),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                child: SizedBox(
                  height: DeviceOrientation.isPortrait
                      ? 60.0 + (30.0 + controller.melEditData["discrepancy"].length * 0.6)
                      : 60.0 + (10.0 + controller.melEditData["discrepancy"].length * 0.2),
                  width: Get.width,
                  child: DeviceOrientation.isPortrait
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Column(
                            children: [
                              controller.returnMelTitleView(title: "Discrepancy"),
                              controller.returnMelTitleValueView(value: controller.melEditData["discrepancy"]),
                            ],
                          ),
                        )
                      : Row(
                          children: [controller.returnMelTitleView(title: "Discrepancy: "), controller.returnMelTitleValueView(value: controller.melEditData["discrepancy"])],
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
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {2: const FixedColumnWidth(0.0), 3: FixedColumnWidth(Get.width / 4)},
                children: <TableRow>[
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Owner Notified:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["correctiveActionOwnerNotified"]!,
                            onChanged: (a) {
                              controller.melBoolData["correctiveActionOwnerNotified"] = a;
                              controller.melEditPostData["isOwnerNotified"] = controller.melBoolData["correctiveActionOwnerNotified"];
                              if (controller.melBoolData["correctiveActionOwnerNotified"] != controller.melEditData["isOwnerNotified"]) {
                                controller.electronicSignatureEnable.value = true;
                              } else {
                                controller.electronicSignatureEnable.value = false;
                              }
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.2),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Log Page: "),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "log_page_corrective_action",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("log_page_corrective_action", () => TextEditingController()),
                                    hintText: "Log Page",
                                    onChange: (value) {
                                      controller.melEditPostData["correctiveActionLogPage"] = value;
                                      if (controller.melEditData["correctiveActionLogPage"] != value) {
                                        controller.electronicSignatureEnable.value = true;
                                      } else {
                                        controller.electronicSignatureEnable.value = false;
                                      }
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        // const SizedBox(),
                        // const SizedBox(),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Cleared Date:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "clear_date_corrective_action",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("clear_date_corrective_action", () => TextEditingController()),
                                    hintText: "mm/dd/yyyy",
                                    onTap: () {
                                      Keyboard.close(context: context);
                                      DatePicker.showDatePicker(context,
                                          minDateTime: DateTime(2010, 1, 1),
                                          maxDateTime: DateTime(2050, 12, 31),
                                          initialDateTime: DateFormat('MM/dd/yyyy').parse(controller.melEditTextEditingFieldController["clear_date_corrective_action"]!.text),
                                          onConfirm: (date, list) {
                                        controller.melEditTextEditingFieldController["clear_date_corrective_action"]!.text = DateFormat('MM/dd/yyyy').format(date);
                                        controller.melEditPostData["clearedDate"] = controller.melEditTextEditingFieldController["clear_date_corrective_action"]!.text;
                                        if (controller.melEditPostData["clearedDate"] != controller.melEditData["clearedDate"]) {
                                          controller.electronicSignatureEnable.value = true;
                                        } else {
                                          controller.electronicSignatureEnable.value = false;
                                        }
                                        Keyboard.close(context: context);
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        // const SizedBox(),
                        // const SizedBox(),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Placard Removed: "),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["correctiveActionPlacardRemoved"]!,
                            onChanged: (a) {
                              controller.melBoolData["correctiveActionPlacardRemoved"] = a;
                              controller.melEditPostData["isPlacardRemoved"] = controller.melBoolData["correctiveActionPlacardRemoved"];
                              if (controller.melEditPostData["isPlacardRemoved"] != controller.melEditData["isPlacardRemoved"]) {
                                controller.electronicSignatureEnable.value = true;
                              } else {
                                controller.electronicSignatureEnable.value = false;
                              }
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        // const SizedBox(),
                        // const SizedBox(),
                      ]),
                ],
              ),
              Material(
                  color: ColorConstants.primary.withValues(alpha: 0.4),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                  child: Column(
                    children: [
                      controller.returnMelTitleView(title: "Corrective Action: "),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                        child: ResponsiveBuilder(
                          builder: (context, sizingInformation) => FormBuilderField(
                            name: "corrective_action",
                            validator: null,
                            builder: (FormFieldState<dynamic> field) {
                              return TextFieldConstant.dynamicTextField(
                                  field: field,
                                  controller: controller.melEditTextEditingFieldController.putIfAbsent("corrective_action", () => TextEditingController()),
                                  maxLines: 8,
                                  maxCharacter: 500,
                                  hintText: "",
                                  onChange: (value) {
                                    controller.melEditPostData["correctiveAction"] = value;
                                    if (controller.melEditPostData["correctiveAction"] != controller.melEditData["correctiveAction"]) {
                                      controller.electronicSignatureEnable.value = true;
                                    } else {
                                      controller.electronicSignatureEnable.value = false;
                                    }
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  editMelDataTabletViewReturn(MelEditLogic controller) {
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
                          columnWidths: DeviceOrientation.isPortrait
                              ? {0: const FixedColumnWidth(150.0), 1: const FixedColumnWidth(250.0), 2: const FixedColumnWidth(150.0), 3: const FixedColumnWidth(250.0)}
                              : null,
                          children: <TableRow>[
                            TableRow(children: [
                              controller.returnMelTitleView(title: "Created By: "),
                              controller.returnMelTitleValueView(
                                  value: controller.melEditData["createdByName"], createdBy: true, subValue: controller.melEditData["createdByCert"]),
                              //const SizedBox(),
                              controller.returnMelTitleView(title: "Created At: "),
                              controller.returnMelTitleValueView(value: controller.melEditData["createdAt"])
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
                          columnWidths: DeviceOrientation.isPortrait
                              ? {0: const FixedColumnWidth(150.0), 1: const FixedColumnWidth(250.0), 2: const FixedColumnWidth(150.0), 3: const FixedColumnWidth(250.0)}
                              : null,
                          children: <TableRow>[
                            TableRow(children: [
                              controller.returnMelTitleView(title: "Last Edited By:"),
                              controller.returnMelTitleValueView(
                                  value: controller.melEditData["lastEditedByName"], createdBy: true, subValue: controller.melEditData["lastEditedByCert"]),
                              controller.returnMelTitleView(title: "Last Edit At: "),
                              controller.returnMelTitleValueView(value: controller.melEditData["lastEditAt"])
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // child: DeviceOrientation.isPortrait
                //     ? Material(
                //         color: ColorConstants.GREY.withValues(alpha: 0.5),
                //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                //           child: Table(
                //             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //             columnWidths: {2: const FixedColumnWidth(0.0), 4: FixedColumnWidth(Get.width / 3.5)},
                //             children: <TableRow>[
                //               TableRow(children: [
                //                 controller.returnMelTitleView(title: "Created By: "),
                //                 controller.returnMelTitleValueView(
                //                     value: controller.melEditData["createdByName"], createdBy: true, subValue: controller.melEditData["createdByCert"]),
                //                 const SizedBox(),
                //                 controller.returnMelTitleView(title: "Created At: "),
                //                 controller.returnMelTitleValueView(value: controller.melEditData["createdAt"])
                //               ]),
                //               TableRow(children: [
                //                 controller.returnMelTitleView(title: "Last Edited By:"),
                //                 controller.returnMelTitleValueView(
                //                     value: controller.melEditData["lastEditedByName"], createdBy: true, subValue: controller.melEditData["lastEditedByCert"]),
                //                 const SizedBox(),
                //                 controller.returnMelTitleView(title: "Last Edit At: "),
                //                 controller.returnMelTitleValueView(value: controller.melEditData["lastEditAt"])
                //               ]),
                //             ],
                //           ),
                //         ),
                //       )
                //     : Material(
                //         color: ColorConstants.GREY.withValues(alpha: 0.5),
                //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
                //         child: SizedBox(
                //           height: 60.0,
                //           child: Padding(
                //             padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                //             child: Row(
                //               children: [
                //                 controller.returnMelDetailsView(
                //                     title: "Created By:",
                //                     titleValue: controller.melEditData["createdByName"],
                //                     createdBy: true,
                //                     subTitleValue: controller.melEditData["createdByCert"]),
                //                 const Spacer(),
                //                 controller.returnMelDetailsView(title: "Created At:", titleValue: controller.melEditData["createdAt"]),
                //                 const Spacer(),
                //                 controller.returnMelDetailsView(
                //                     title: "Last Edit By:",
                //                     titleValue: controller.melEditData["lastEditedByName"],
                //                     createdBy: true,
                //                     subTitleValue: controller.melEditData["lastEditedByCert"]),
                //                 const Spacer(),
                //                 controller.returnMelDetailsView(title: "Last Edit At:", titleValue: controller.melEditData["lastEditAt"]),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
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
                        controller.returnMelTitleView(title: "Placard Installed:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["discrepancyPlacardInstalled"]!,
                            onChanged: (a) {
                              controller.melBoolData["discrepancyPlacardInstalled"] = a;
                              controller.melEditPostData["isPlacardInstalled"] = controller.melBoolData["discrepancyPlacardInstalled"];
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        controller.returnMelTitleView(title: "Part's On Order:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["discrepancyPartsOnOrder"]!,
                            onChanged: (a) {
                              controller.melBoolData["discrepancyPartsOnOrder"] = a;
                              controller.melEditPostData["isPartsOnOrder"] = controller.melBoolData["discrepancyPartsOnOrder"];
                              if (controller.melBoolData["discrepancyPartsOnOrder"] == false) {
                                controller.melEditTextEditingFieldController["po_number"]!.text = "";
                                controller.melEditPostData["purchaseNumber"] = "";
                              }
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        if (controller.melBoolData["discrepancyPartsOnOrder"] == true)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                            child: ResponsiveBuilder(
                              builder: (context, sizingInformation) => FormBuilderField(
                                name: "po_number",
                                validator: null,
                                builder: (FormFieldState<dynamic> field) {
                                  return TextFieldConstant.dynamicTextField(
                                      field: field,
                                      controller: controller.melEditTextEditingFieldController.putIfAbsent("po_number", () => TextEditingController()),
                                      hintText: "PO Number",
                                      onChange: (value) {
                                        controller.melEditPostData["purchaseNumber"] = value;
                                      });
                                },
                              ),
                            ),
                          )
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Aircraft:"),
                        controller.returnMelTitleValueView(value: "${controller.melEditData["aircraftName"]} [SN: ${controller.melEditData["serialNumber"]}]"),
                        const SizedBox(height: 60.0),
                        controller.returnMelTitleView(title: "Log Page #:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "log_page_discrepancy",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("log_page_discrepancy", () => TextEditingController()),
                                    hintText: "Log Page",
                                    onChange: (value) {
                                      controller.melEditPostData["logPage"] = value;
                                    });
                              },
                            ),
                          ),
                        ),
                        if (controller.melBoolData["discrepancyPartsOnOrder"] == true) const SizedBox()
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Model:"),
                        controller.returnMelTitleValueView(value: "${controller.melEditData["aircraftType"]} [FAA MMEL]"),
                        const SizedBox(height: 60.0),
                        controller.returnMelTitleView(title: "Date Deferred: "),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "date_deferred",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("date_deferred", () => TextEditingController()),
                                    hintText: "mm/dd/yyyy",
                                    onTap: () {
                                      Keyboard.close(context: context);
                                      DatePicker.showDatePicker(context,
                                          minDateTime: DateTime(2010, 1, 1),
                                          maxDateTime: DateTime(2050, 12, 31),
                                          initialDateTime: DateFormat('MM/dd/yyyy').parse(controller.melEditTextEditingFieldController["date_deferred"]!.text),
                                          onConfirm: (date, list) {
                                        controller.melEditTextEditingFieldController["date_deferred"]!.text = DateFormat('MM/dd/yyyy').format(date);
                                        controller.melEditPostData["deferredDate"] = controller.melEditTextEditingFieldController["date_deferred"]!.text;
                                        controller.melCategory["categoryA"] = false;
                                        controller.melCategory["categoryB"] = false;
                                        controller.melCategory["categoryC"] = false;
                                        controller.melCategory["categoryC"] = false;
                                        controller.melEditTextEditingFieldController["expiration_date"]!.text = "mm/dd/yyyy";
                                        controller.melEditPostData["expirationDate"] = "";
                                        controller.melCategory["categoryNotSelected"] = true;
                                        Keyboard.close(context: context);
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
                        if (controller.melBoolData["discrepancyPartsOnOrder"] == true) const SizedBox()
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "MEL Item #:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "mel_item",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("mel_item", () => TextEditingController()),
                                    hintText: "MEL item",
                                    onChange: (value) {
                                      controller.melEditPostData["mELItemNumber"] = value;
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        controller.returnMelTitleView(title: "Expiration Date:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "expiration_date",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("expiration_date", () => TextEditingController()),
                                    hintText: "mm/dd/yyyy");
                              },
                            ),
                          ),
                        ),
                        if (controller.melBoolData["discrepancyPartsOnOrder"] == true) const SizedBox()
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Revision #:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "revision",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("revision", () => TextEditingController()),
                                    hintText: "Revision",
                                    onChange: (value) {
                                      controller.melEditPostData["revisionNumber"] = value;
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox(),
                        if (controller.melBoolData["discrepancyPartsOnOrder"] == true) const SizedBox()
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Extended:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["extendedMel"]!,
                            onChanged: (a) {
                              controller.melBoolData["extendedMel"] = a;
                              controller.saveAndUploadButtonShow.value = a;
                              controller.melEditPostData["isExtended"] = controller.melBoolData["extendedMel"];
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox(),
                        if (controller.melBoolData["discrepancyPartsOnOrder"] == true) const SizedBox()
                      ]),
                ],
              ),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.2),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: SizedBox(
                    width: Get.width,
                    child: Column(
                      children: [
                        controller.returnMelTitleView(title: "Category"),
                        if (controller.melCategory["categoryA"]! == false &&
                            controller.melCategory["categoryB"]! == false &&
                            controller.melCategory["categoryC"]! == false &&
                            controller.melCategory["categoryD"]! == false)
                          if (controller.melCategory["categoryNotSelected"]! == true)
                            const Text("[You changed Deferred Date. Select a Category for Expiration Date]",
                                textAlign: TextAlign.center, style: TextStyle(color: ColorConstants.red)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "A",
                                    melCategoryValue: controller.melCategory["categoryA"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryA"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      if (value == true) {
                                        controller.customCategoryADialogView();
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryA"] = !controller.melCategory["categoryA"]!;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      controller.someDataCheck();
                                      if (controller.melCategory["categoryA"] == true) {
                                        controller.customCategoryADialogView();
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "B",
                                    melCategoryValue: controller.melCategory["categoryB"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryB"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      controller.melEditPostData["category"] = 'B';
                                      if (value == true) {
                                        controller.expirationDateCount(dateCount: "3");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryB"] = !controller.melCategory["categoryB"]!;
                                      controller.melEditPostData["category"] = 'B';
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      if (controller.melCategory["categoryB"] == true) {
                                        controller.expirationDateCount(dateCount: "3");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "C",
                                    melCategoryValue: controller.melCategory["categoryC"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryC"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      controller.melEditPostData["category"] = 'C';
                                      if (value == true) {
                                        controller.expirationDateCount(dateCount: "10");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryC"] = !controller.melCategory["categoryC"]!;
                                      controller.melEditPostData["category"] = 'C';
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryD"] = false;
                                      if (controller.melCategory["categoryC"] == true) {
                                        controller.expirationDateCount(dateCount: "10");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: controller.returnCategoryMEL(
                                    category: "D",
                                    melCategoryValue: controller.melCategory["categoryD"],
                                    onChangeValue: (value) {
                                      controller.melCategory["categoryD"] = value;
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      controller.melEditPostData["category"] = 'D';
                                      if (value == true) {
                                        controller.expirationDateCount(dateCount: "120");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    },
                                    onTap: () {
                                      controller.melCategory["categoryD"] = !controller.melCategory["categoryD"]!;
                                      controller.melEditPostData["category"] = 'D';
                                      controller.melCategory["categoryNotSelected"] = true;
                                      controller.melCategory["categoryA"] = false;
                                      controller.melCategory["categoryB"] = false;
                                      controller.melCategory["categoryC"] = false;
                                      if (controller.melCategory["categoryD"] == true) {
                                        controller.expirationDateCount(dateCount: "120");
                                      } else {
                                        controller.someDataCheck();
                                      }
                                    }),
                              ),
                            ],
                          ),
                      )
                    ]),
                  ),
                ),
              ),
              if (controller.melCategory["categoryA"] == true) controller.returnRepairCategory(value: 'A'),
              if (controller.melCategory["categoryB"] == true) controller.returnRepairCategory(value: 'B'),
              if (controller.melCategory["categoryC"] == true) controller.returnRepairCategory(value: 'C'),
              if (controller.melCategory["categoryD"] == true) controller.returnRepairCategory(value: 'D'),
              Material(
                color: ColorConstants.primary.withValues(alpha: 0.2),
                child: SizedBox(
                  height: 60.0 + (controller.melEditData["discrepancy"].length * 0.3),
                  child: Row(
                    children: [controller.returnMelTitleView(title: "Discrepancy: "), controller.returnMelTitleValueView(value: controller.melEditData["discrepancy"])],
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
                color: ColorConstants.primary,
                height: SizeConstants.contentSpacing * 5,
                width: Get.width,
                child: Center(
                    child: Text("Corrective Action",
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
                        controller.returnMelTitleView(title: "Owner Notified:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["correctiveActionOwnerNotified"]!,
                            onChanged: (a) {
                              controller.melBoolData["correctiveActionOwnerNotified"] = a;
                              controller.melEditPostData["isOwnerNotified"] = controller.melBoolData["correctiveActionOwnerNotified"];
                              if (controller.melBoolData["correctiveActionOwnerNotified"] != controller.melEditData["isOwnerNotified"]) {
                                controller.electronicSignatureEnable.value = true;
                              } else {
                                controller.electronicSignatureEnable.value = false;
                              }
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        controller.returnMelTitleView(title: "Placard Removed:"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: controller.melBoolData["correctiveActionPlacardRemoved"]!,
                            onChanged: (a) {
                              controller.melBoolData["correctiveActionPlacardRemoved"] = a;
                              controller.melEditPostData["isPlacardRemoved"] = controller.melBoolData["correctiveActionPlacardRemoved"];
                              if (controller.melEditPostData["isPlacardRemoved"] != controller.melEditData["isPlacardRemoved"]) {
                                controller.electronicSignatureEnable.value = true;
                              } else {
                                controller.electronicSignatureEnable.value = false;
                              }
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.4),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Log Page:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "log_page_corrective_action",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("log_page_corrective_action", () => TextEditingController()),
                                    hintText: "Log Page",
                                    onChange: (value) {
                                      controller.melEditPostData["correctiveActionLogPage"] = value;
                                      if (controller.melEditData["correctiveActionLogPage"] != value) {
                                        controller.electronicSignatureEnable.value = true;
                                      } else {
                                        controller.electronicSignatureEnable.value = false;
                                      }
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox()
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.2),
                      ),
                      children: <Widget>[
                        controller.returnMelTitleView(title: "Cleared Date:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                          child: ResponsiveBuilder(
                            builder: (context, sizingInformation) => FormBuilderField(
                              name: "clear_date_corrective_action",
                              validator: null,
                              builder: (FormFieldState<dynamic> field) {
                                return TextFieldConstant.dynamicTextField(
                                    field: field,
                                    controller: controller.melEditTextEditingFieldController.putIfAbsent("clear_date_corrective_action", () => TextEditingController()),
                                    hintText: "mm/dd/yyyy",
                                    onTap: () {
                                      Keyboard.close(context: context);
                                      DatePicker.showDatePicker(context,
                                          minDateTime: DateTime(2010, 1, 1),
                                          maxDateTime: DateTime(2050, 12, 31),
                                          initialDateTime: DateFormat('MM/dd/yyyy').parse(controller.melEditTextEditingFieldController["clear_date_corrective_action"]!.text),
                                          onConfirm: (date, list) {
                                        controller.melEditTextEditingFieldController["clear_date_corrective_action"]!.text = DateFormat('MM/dd/yyyy').format(date);
                                        controller.melEditPostData["clearedDate"] = controller.melEditTextEditingFieldController["clear_date_corrective_action"]!.text;
                                        if (controller.melEditPostData["clearedDate"] != controller.melEditData["clearedDate"]) {
                                          controller.electronicSignatureEnable.value = true;
                                        } else {
                                          controller.electronicSignatureEnable.value = false;
                                        }
                                        Keyboard.close(context: context);
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        const SizedBox(),
                        const SizedBox(),
                      ]),
                ],
              ),
              Material(
                  color: ColorConstants.primary.withValues(alpha: 0.4),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                  child: Column(
                    children: [
                      controller.returnMelTitleView(title: "Corrective Action: "),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                        child: ResponsiveBuilder(
                          builder: (context, sizingInformation) => FormBuilderField(
                            name: "corrective_action",
                            validator: null,
                            builder: (FormFieldState<dynamic> field) {
                              return TextFieldConstant.dynamicTextField(
                                  field: field,
                                  controller: controller.melEditTextEditingFieldController.putIfAbsent("corrective_action", () => TextEditingController()),
                                  maxLines: 8,
                                  maxCharacter: 500,
                                  hintText: "",
                                  onChange: (value) {
                                    controller.melEditPostData["correctiveAction"] = value;
                                    if (controller.melEditPostData["correctiveAction"] != controller.melEditData["correctiveAction"]) {
                                      controller.electronicSignatureEnable.value = true;
                                    } else {
                                      controller.electronicSignatureEnable.value = false;
                                    }
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
