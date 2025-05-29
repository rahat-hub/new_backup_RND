import 'dart:ui';

import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:signature/signature.dart';

import '../helper/date_time_helper.dart';
import '../helper/dialog_helper.dart';
import 'buttons.dart';

abstract class FormWidgets {
  //*************************************************** Pdf Widgets for View User Form **************************************************************************

  static pdf.Widget formPdfWidget({
    required int id,
    required bool hidden,
    String? fieldName,
    String? closeOutFieldMode,
    bool? header,
    String? fieldValue,
    bool? bold,
    int? icon,
    PdfColor? iconColor,
  }) {
    return hidden
        ? pdf.SizedBox.shrink()
        : pdf.Wrap(
      crossAxisAlignment: pdf.WrapCrossAlignment.center,
      children: [
        pdf.Text(
          "${fieldName ?? ""}${closeOutFieldMode ?? ""}${(fieldName == null || fieldName == "") && closeOutFieldMode == null
              ? ""
              : header == null || header != true
              ? ":"
              : ""} ",
          style: pdf.TextStyle(fontSize: Theme
              .of(Get.context!)
              .textTheme
              .bodyMedium!
              .fontSize! - 2, fontWeight: pdf.FontWeight.bold),
        ),
        if (header == null || header != true)
          pdf.Text(
            fieldValue ?? "None",
            style: pdf.TextStyle(fontSize: Theme
                .of(Get.context!)
                .textTheme
                .bodyMedium!
                .fontSize! - 2, fontWeight: bold != null ? pdf.FontWeight.bold : pdf.FontWeight.normal),
          ),
        if (icon != null) pdf.Padding(padding: const pdf.EdgeInsets.symmetric(horizontal: 5.0), child: pdf.Icon(pdf.IconData(icon), color: iconColor, size: 25)),
      ],
    );
  }

  static pdf.Widget signaturePenViewPdf({required int id, required bool hidden, String? fieldName, String? signatureName, String? signatureTime}) {
    return hidden
        ? pdf.SizedBox.shrink()
        : pdf.Wrap(
      crossAxisAlignment: pdf.WrapCrossAlignment.center,
      children: [
        pdf.Text(
          fieldName.isNotNullOrEmpty ? "${fieldName ?? ""}: " : "",
          style: pdf.TextStyle(fontSize: Theme
              .of(Get.context!)
              .textTheme
              .bodyMedium!
              .fontSize! - 2, fontWeight: pdf.FontWeight.bold),
        ),
        pdf.Text("Signed: ", style: pdf.TextStyle(fontSize: Theme
            .of(Get.context!)
            .textTheme
            .bodyMedium!
            .fontSize! - 2)),
        pdf.Text(
          signatureName != null ? "True," : "False,",
          style: pdf.TextStyle(fontSize: Theme
              .of(Get.context!)
              .textTheme
              .bodyMedium!
              .fontSize! - 2, fontWeight: pdf.FontWeight.bold),
        ),
        pdf.SizedBox(width: 5.0),
        pdf.Text("Name: ", style: pdf.TextStyle(fontSize: Theme
            .of(Get.context!)
            .textTheme
            .bodyMedium!
            .fontSize! - 2)),
        pdf.Text("${signatureName ?? "None"},", style: pdf.TextStyle(fontSize: Theme
            .of(Get.context!)
            .textTheme
            .bodyMedium!
            .fontSize! - 2, fontWeight: pdf.FontWeight.bold)),
        pdf.SizedBox(width: 5.0),
        pdf.Text("Date: ", style: pdf.TextStyle(fontSize: Theme
            .of(Get.context!)
            .textTheme
            .bodyMedium!
            .fontSize! - 2)),
        pdf.Text(signatureTime ?? "None", style: pdf.TextStyle(fontSize: Theme
            .of(Get.context!)
            .textTheme
            .bodyMedium!
            .fontSize! - 2, fontWeight: pdf.FontWeight.bold)),
      ],
    );
  }

  //**************************** Start of General Fields: Text Fields || Date & Times || Check Box || Drop Downs || Hybrid/Combined ****************************
  //General Fields: Text Fields || Date & Times || Check Box || Drop Downs || Hybrid/Combined

  //Drop Downs
  static Widget oldDropDown({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        Container(
                          height: 65,
                          decoration: BoxDecoration(
                            color: !disableUserEditing ? Colors.white : Colors.grey[350],
                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            border: Border.all(color: ColorConstants.black),
                          ),
                          alignment: Alignment.center,
                          child: DropdownButton<dynamic>(
                            icon: Icon(Icons.keyboard_arrow_down, size: SizeConstants.iconSizes(type: SizeConstants.largeIcon)),
                            iconEnabledColor: ColorConstants.black,
                            iconDisabledColor: Colors.grey[350],
                            hint: Padding(
                              padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
                              child: Text(
                                disableUserEditing ? selectedValue = defaultValue ?? name : selectedValue ?? name,
                                style: Theme
                                    .of(
                                  context,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: ColorConstants.black, fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium!
                                    .fontSize! - 3),
                              ),
                            ),
                            itemHeight: 65,
                            menuMaxHeight: Get.height - 200,
                            underline: const SizedBox(),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor: ColorConstants.white,
                            isDense: false,
                            items:
                            disableUserEditing == true
                                ? null
                                : dropDownData?.map((value) {
                              return DropdownMenuItem<dynamic>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
                                  child: Text(
                                    "${value[key]}",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      color: ColorConstants.black,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 3,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (!disableUserEditing) {
                                onChanged(val);
                              }
                            },
                          ),
                        ),
                  ),
                  if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None")
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                      child: Text(
                        "($defaultValue)",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? ColorConstants.grey
                              : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dropDownAccessibleAircraft({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText: disableUserEditing ? selectedValue = defaultValue ?? name : selectedValue ?? name,
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dropDownAllUsers({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText: disableUserEditing ? selectedValue = defaultValue ?? name : selectedValue ?? name,
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dropDownNumbers0_50({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dropDownNumbers0_100({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dropDownNumbers0_150({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dropDownCustomers({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText: disableUserEditing ? selectedValue = defaultValue ?? "" : selectedValue ?? "",
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget accessoriesSelector({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][key].replaceAll("***", "") : "None")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][key].replaceAll("***", "") : "None"),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}".replaceAll("***", ""),
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  //**************************************************************** END OF Drop Downs *************************************************************************

  //Select Multiple

  static Widget flightOpsDocumentSelector({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    disableUserEditing,
    defaultValue,
    onDialogPopUp,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 65),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !disableUserEditing ? Colors.white : Colors.grey[350],
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              border: Border.all(color: ColorConstants.black),
                            ),
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                          disableUserEditing
                                              ? selectedValue = defaultValue ?? "Select $name"
                                              : selectedValue == null || selectedValue == ""
                                              ? "Select $name"
                                              : selectedValue,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: ColorConstants.black,
                                            fontSize: Theme
                                                .of(Get.context!)
                                                .textTheme
                                                .displayMedium!
                                                .fontSize! - 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.open_in_new, size: 30.0, color: ColorConstants.black),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (!disableUserEditing) {
                                  onDialogPopUp();
                                }
                              },
                            ),
                          ),
                        ),
                  ),
                  if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None")
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                      child: Text(
                        "($defaultValue)",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? ColorConstants.grey
                              : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  //****************************************************************** END OF Select Multiple ******************************************************************

  //Hybrid/Combined
  static Widget dropDownViaServiceTableValues({
    hidden,
    addChoices,
    selectMultiple,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    focusNode,
    onTap,
    onEditingComplete,
    selectedValue,
    required List? dropDownData,
    searchDataList,
    required key,
    onChanged,
    onSelect,
    disableUserEditing,
    defaultValue,
    specificDataType,
    hintText,
    onDialogPopUp,
  }) {
    var selectedData = "".obs;
    return showField ?? !hidden
        ? addChoices
            ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                            textScaler: TextScaler.linear(Get.textScaleFactor),
                            text: TextSpan(
                              style: TextStyle(
                                color:
                                rowColor == "" || rowColor == null
                                        ? ThemeColorMode.isLight
                                            ? ColorConstants.black
                                            : ColorConstants.white
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                    ? ColorConstants.black
                                    : ColorConstants.white,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium!
                                    .fontSize! - 2,
                                fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                              ),
                              children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                            ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: acronymTitle,
                            splashRadius: 20,
                            padding: const EdgeInsets.all(4.0),
                            iconSize: 20,
                            constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                    const SizedBox(height: 10),

                    ResponsiveBuilder(
                      builder:
                          (context, sizingInformation) => FormBuilderField(
                            name: "$id",
                            validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder:
                                (FormFieldState<dynamic> field) => TextField(
                                  controller: controller,
                                  cursorColor: Colors.black,
                                  maxLength: maxSize != null ? int.parse(maxSize) : null,
                                  readOnly: disableUserEditing,
                                  focusNode: focusNode,
                                  inputFormatters: [
                                    TextInputFormatter.withFunction((oldValue, newValue) => TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection)),
                                  ],
                                  style: Theme.of(
                                    Get.context!,
                                  ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4, color: ColorConstants.black),
                                  onTap: () {
                                    if (!disableUserEditing) {
                                      onTap();
                                    }
                                  },
                                  onChanged: (String? value) {
                                    if (value != "") {
                                      field.didChange(value);
                                    } else {
                                      field.reset();
                                    }
                                    onChanged(value);
                                  },
                                  onEditingComplete: onEditingComplete,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                    hintText: hintText.isNotEmpty ? hintText : specificDataType?.replaceAll("_", " ") ?? "",
                                    hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                                    helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                    helperStyle: TextStyle(
                                      color:
                                          rowColor == "" || rowColor == null
                                              ? null
                                              : rowColor.toUpperCase() == "#FFFFFF"
                                              ? ColorConstants.black
                                              : ColorConstants.white,
                                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6,
                                    ),
                                    errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6),
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.red),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorText: field.errorText,
                                  ),
                                ),
                          ),
                    ),
                    //const SizedBox(height: 5),
                    Obx(
                          () =>
                      searchDataList[id.toString()] != null
                          ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 180),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(5),
                            shadowColor: ColorConstants.primary,
                            color: Colors.lightBlue[100],
                            child: ListView.builder(
                              //physics: const NeverScrollableScrollPhysics(),
                              itemCount: searchDataList[id.toString()].length,
                              shrinkWrap: true,
                              itemBuilder:
                                  (context, index) =>
                              searchDataList[id.toString()][index]["requestToAdd"] == "1"
                                  ? ListTile(
                                leading: Text("Add '${searchDataList[id.toString()][index]["value"]}' To Database"),
                                onTap: () {
                                  selectedData.value = searchDataList[id.toString()][index]["value"];
                                  var requestToAdd = searchDataList[id.toString()][index]["requestToAdd"];
                                  searchDataList[id.toString()] = [];
                                  onSelect(selectedData.value, requestToAdd);
                                },
                              )
                                  : ListTile(
                                dense: true,
                                leading: Text(searchDataList[id.toString()][index]["value"]),
                                onTap: () {
                                  selectedData.value = searchDataList[id.toString()][index]["value"];
                                  searchDataList[id.toString()] = [];
                                  onSelect(selectedData.value, "0");
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                          : const SizedBox(),
                    ),
          ],
        ),
      ),
    )
            : Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                              ? ColorConstants.black
                                              : ColorConstants.white,
                                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 65),
                          child:
                          selectMultiple
                              ? Container(
                            decoration: BoxDecoration(
                              color: !disableUserEditing ? Colors.white : Colors.grey[350],
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              border: Border.all(color: ColorConstants.black),
                            ),
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                          disableUserEditing
                                              ? selectedValue = defaultValue
                                              : selectedValue == null || selectedValue == ""
                                              ? "Select $specificDataType"
                                              : selectedValue,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: ColorConstants.black,
                                            fontSize: Theme
                                                .of(Get.context!)
                                                .textTheme
                                                .displayMedium!
                                                .fontSize! - 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.open_in_new, size: 30.0, color: ColorConstants.black),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (!disableUserEditing) {
                                  onDialogPopUp();
                                }
                              },
                            ),
                          )
                              : DropdownMenu(
                            enabled: !disableUserEditing,
                            menuHeight: Get.height - 200,
                            textStyle: Theme
                                .of(Get.context!)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              fontSize: (Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium
                                  ?.fontSize)! - 3,
                              color: ColorConstants.black,
                            ),
                            trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                            expandedInsets: EdgeInsets.zero,
                            hintText: disableUserEditing ? selectedValue = defaultValue ?? "" : selectedValue ?? "",
                            helperText:
                            defaultValue == null ||
                                defaultValue == "" ||
                                defaultValue == "0" ||
                                defaultValue == "0.0" ||
                                defaultValue == previousValue ||
                                defaultValue == "None"
                                ? null
                                : "($defaultValue)",
                            errorText: field.errorText,
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                              hintStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: ColorConstants.black,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium!
                                    .fontSize! - 3,
                              ),
                              helperStyle: TextStyle(
                                color:
                                rowColor == "" || rowColor == null
                                    ? null //ColorConstants.GREY
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                    ? ColorConstants.black
                                    : ColorConstants.white,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium!
                                    .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                              ),
                              errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: ColorConstants.black),
                                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: ColorConstants.black),
                                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: ColorConstants.black),
                                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: ColorConstants.red),
                                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              ),
                            ),
                            dropdownMenuEntries:
                            dropDownData == null
                                ? []
                                : dropDownData.map((value) {
                              return DropdownMenuEntry<dynamic>(
                                value: value,
                                label: "${value[key]}",
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(
                                    Theme
                                        .of(
                                      Get.context!,
                                    )
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: (Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium
                                        ?.fontSize)! - 3),
                                  ),
                                ),
                              );
                            }).toList(),
                            onSelected: (val) {
                              field.didChange(val);
                              onChanged(val);
                            },
                          ),
                        ),
                  ),
                  if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None" && selectMultiple)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                      child: Text("($defaultValue)", style: const TextStyle(color: ColorConstants.grey, fontWeight: FontWeight.w100)),
                    ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget accessoriesWithCycleHobbs({
    hidden,
    required name,
    rowColor,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required id,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
    required field1Id,
    field1Controller,
    field1FocusNode,
    field1OnTap,
    field1OnChanged,
    field1OnEditingComplete,
    required field2Id,
    field2Controller,
    field2FocusNode,
    field2OnTap,
    field2OnChanged,
    field2OnEditingComplete,
    required field3Id,
    field3Controller,
    field3FocusNode,
    field3OnTap,
    field3OnChanged,
    field3OnEditingComplete,
    required field4Id,
    field4Controller,
    field4FocusNode,
    field4OnTap,
    field4OnChanged,
    field4OnEditingComplete,
    required field5Id,
    field5Controller,
    field5FocusNode,
    field5OnTap,
    field5OnChanged,
    field5OnEditingComplete,
    required field6Id,
    field6Controller,
    field6FocusNode,
    field6OnTap,
    field6OnChanged,
    field6OnEditingComplete,
  }) {
    return showField ?? !hidden
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
              child: SizedBox(
                width:
                Get.width > 480
                    ? Get.width > 980
                    ? (Get.width / 3) - ((12 / 3) * 9)
                    : (Get.width / 2) - ((12 / 2) * 8)
                    : Get.width - 5,
                child: ResponsiveBuilder(
                  builder:
                      (context, sizingInformation) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (name != "" || req)
                                RichText(
                                  textScaler: TextScaler.linear(Get.textScaleFactor),
                                  text: TextSpan(
                                    style: TextStyle(
                                      color:
                                      rowColor == "" || rowColor == null
                                          ? ThemeColorMode.isLight
                                          ? ColorConstants.black
                                          : ColorConstants.white
                                          : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 2,
                                      fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                    ),
                                    children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                                  ),
                                ),
                              if (acronymTitle != name && acronymTitle != "")
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  tooltip: acronymTitle,
                                  splashRadius: 20,
                                  padding: const EdgeInsets.all(4.0),
                                  iconSize: 20,
                                  constraints: const BoxConstraints(maxHeight: 30),
                                  onPressed: () {},
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FormBuilderField(
                            name: "$id",
                            validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            focusNode: focusNode,
                            builder:
                                (FormFieldState<dynamic> field) =>
                                DropdownMenu(
                                  enabled: !disableUserEditing,
                                  menuHeight: Get.height - 200,
                                  textStyle: Theme
                                      .of(
                                    Get.context!,
                                  )
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3, color: ColorConstants.black),
                                  trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                                  expandedInsets: EdgeInsets.zero,
                                  hintText:
                                  disableUserEditing
                                      ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][key] : "None")
                                      : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][key] : "None"),
                                  helperText:
                                  defaultValue == null ||
                                      defaultValue == "" ||
                                      defaultValue == "0" ||
                                      defaultValue == "0.0" ||
                                      defaultValue == previousValue ||
                                      defaultValue == "None"
                                      ? null
                                      : "($defaultValue)",
                                  errorText: field.errorText,
                                  inputDecorationTheme: InputDecorationTheme(
                                    filled: true,
                                    fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                                    hintStyle: Theme
                                        .of(
                                      context,
                                    )
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: ColorConstants.black, fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 3),
                                    helperStyle: TextStyle(
                                      color:
                                      rowColor == "" || rowColor == null
                                          ? null //ColorConstants.GREY
                                          : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                                    ),
                                    errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.red),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                  ),
                                  dropdownMenuEntries:
                                  dropDownData == null
                                      ? []
                                      : dropDownData.map((value) {
                                    return DropdownMenuEntry<dynamic>(
                                      value: value,
                                      label: "${value[key]}",
                                      style: ButtonStyle(
                                        textStyle: WidgetStatePropertyAll(
                                          Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 3),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onSelected: (val) {
                                    field.didChange(val);
                                    onChanged(val);
                                  },
                                ),
                          ),
                        ],
                      ),
                ),
              ),
            ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width:
                    Get.width > 480
                        ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                  rowColor == "" || rowColor == null
                                      ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                      : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 2,
                                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                ),
                                children: [const TextSpan(text: "Cycle Start"), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedValue != null && selectedValue != dropDownData![0][key])
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) =>
                                FormBuilderField(
                                  name: field1Id,
                                  validator: req ? FormBuilderValidators.required(errorText: "Cycle Start field is required.") : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  builder:
                                      (FormFieldState<dynamic> field) =>
                                      TextField(
                                        controller: field1Controller,
                                        cursorColor: Colors.black,
                                        readOnly: disableUserEditing,
                                        focusNode: field1FocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        style: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 4,
                                          color: ColorConstants.black,
                                        ),
                                        onTap: () {
                                          if (!disableUserEditing) {
                                            field1OnTap();
                                          }
                                        },
                                        onChanged: (String? value) {
                                          if (value != "") {
                                            field.didChange(value);
                                          } else {
                                            field.reset();
                                          }
                                          field1OnChanged(value);
                                        },
                                        onEditingComplete: () => field1OnEditingComplete(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                          hintText: "# to start",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.red),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorText: field.errorText,
                                        ),
                                      ),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width:
                    Get.width > 480
                        ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                  rowColor == "" || rowColor == null
                                      ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                      : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 2,
                                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                ),
                                children: [const TextSpan(text: "Cycle To Add"), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedValue != null && selectedValue != dropDownData![0][key])
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) =>
                                FormBuilderField(
                                  name: field2Id,
                                  validator: req ? FormBuilderValidators.required(errorText: "Cycle Add field is required.") : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  builder:
                                      (FormFieldState<dynamic> field) =>
                                      TextField(
                                        controller: field2Controller,
                                        cursorColor: Colors.black,
                                        readOnly: disableUserEditing,
                                        focusNode: field2FocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        style: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 4,
                                          color: ColorConstants.black,
                                        ),
                                        onTap: () {
                                          if (!disableUserEditing) {
                                            field2OnTap();
                                          }
                                        },
                                        onChanged: (String? value) {
                                          if (value != "") {
                                            field.didChange(value);
                                          } else {
                                            field.reset();
                                          }
                                          field2OnChanged(value);
                                        },
                                        onEditingComplete: () => field2OnEditingComplete(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                          hintText: "# to add",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.red),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorText: field.errorText,
                                        ),
                                      ),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width:
                    Get.width > 480
                        ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                  rowColor == "" || rowColor == null
                                      ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                      : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 2,
                                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                ),
                                children: [const TextSpan(text: "Cycle End"), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedValue != null && selectedValue != dropDownData![0][key])
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) =>
                                FormBuilderField(
                                  name: field3Id,
                                  validator: req ? FormBuilderValidators.required(errorText: "Cycle End field is required.") : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  builder:
                                      (FormFieldState<dynamic> field) =>
                                      TextField(
                                        controller: field3Controller,
                                        cursorColor: Colors.black,
                                        readOnly: disableUserEditing,
                                        focusNode: field3FocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        style: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 4,
                                          color: ColorConstants.black,
                                        ),
                                        onTap: () {
                                          if (!disableUserEditing) {
                                            field3OnTap();
                                          }
                                        },
                                        onChanged: (String? value) {
                                          if (value != "") {
                                            field.didChange(value);
                                          } else {
                                            field.reset();
                                          }
                                          field3OnChanged(value);
                                        },
                                        onEditingComplete: () => field3OnEditingComplete(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                          hintText: "# to end",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.red),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorText: field.errorText,
                                        ),
                                      ),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10.0),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width:
                    Get.width > 480
                        ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                  rowColor == "" || rowColor == null
                                      ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                      : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 2,
                                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                ),
                                children: [const TextSpan(text: "Hobbs To Start"), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedValue != null && selectedValue != dropDownData![0][key])
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) =>
                                FormBuilderField(
                                  name: field4Id,
                                  validator: req ? FormBuilderValidators.required(errorText: "Hobbs Start field is required.") : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  builder:
                                      (FormFieldState<dynamic> field) =>
                                      TextField(
                                        controller: field4Controller,
                                        cursorColor: Colors.black,
                                        readOnly: disableUserEditing,
                                        focusNode: field4FocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d)?'))],
                                        style: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 4,
                                          color: ColorConstants.black,
                                        ),
                                        onTap: () {
                                          if (!disableUserEditing) {
                                            field4OnTap();
                                          }
                                        },
                                        onChanged: (String? value) {
                                          if (value != "") {
                                            field.didChange(value);
                                          } else {
                                            field.reset();
                                          }
                                          field4OnChanged(value);
                                        },
                                        onEditingComplete: () => field4OnEditingComplete(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                          hintText: "# to start",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.red),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorText: field.errorText,
                                        ),
                                      ),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width:
                    Get.width > 480
                        ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                  rowColor == "" || rowColor == null
                                      ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                      : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 2,
                                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                ),
                                children: [const TextSpan(text: "Hobbs To Add"), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedValue != null && selectedValue != dropDownData![0][key])
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) =>
                                FormBuilderField(
                                  name: field5Id,
                                  validator: req ? FormBuilderValidators.required(errorText: "Hobbs Add field is required.") : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  builder:
                                      (FormFieldState<dynamic> field) =>
                                      TextField(
                                        controller: field5Controller,
                                        cursorColor: Colors.black,
                                        readOnly: disableUserEditing,
                                        focusNode: field5FocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d)?'))],
                                        style: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 4,
                                          color: ColorConstants.black,
                                        ),
                                        onTap: () {
                                          if (!disableUserEditing) {
                                            field5OnTap();
                                          }
                                        },
                                        onChanged: (String? value) {
                                          if (value != "") {
                                            field.didChange(value);
                                          } else {
                                            field.reset();
                                          }
                                          field5OnChanged(value);
                                        },
                                        onEditingComplete: () => field5OnEditingComplete(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                          hintText: "# to add",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.red),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorText: field.errorText,
                                        ),
                                      ),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    width:
                    Get.width > 480
                        ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(Get.textScaleFactor),
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                  rowColor == "" || rowColor == null
                                      ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                      : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                                  fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 2,
                                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                                ),
                                children: [const TextSpan(text: "Hobbs End"), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedValue != null && selectedValue != dropDownData![0][key])
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) =>
                                FormBuilderField(
                                  name: field6Id,
                                  validator: req ? FormBuilderValidators.required(errorText: "Hobbs End field is required.") : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  builder:
                                      (FormFieldState<dynamic> field) =>
                                      TextField(
                                        controller: field6Controller,
                                        cursorColor: Colors.black,
                                        readOnly: disableUserEditing,
                                        focusNode: field6FocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d)?'))],
                                        style: Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          fontSize: (Theme
                                              .of(Get.context!)
                                              .textTheme
                                              .displayMedium
                                              ?.fontSize)! - 4,
                                          color: ColorConstants.black,
                                        ),
                                        onTap: () {
                                          if (!disableUserEditing) {
                                            field6OnTap();
                                          }
                                        },
                                        onChanged: (String? value) {
                                          if (value != "") {
                                            field.didChange(value);
                                          } else {
                                            field.reset();
                                          }
                                          field6OnChanged(value);
                                        },
                                        onEditingComplete: () => field6OnEditingComplete(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                          hintText: "# to end",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.black),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: ColorConstants.red),
                                            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                          ),
                                          errorText: field.errorText,
                                        ),
                                      ),
                                ),
                          ),
                      ],
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    )
        : const SizedBox();
  }

  //Not User Need To Modify or Update
  static Widget medicationSelectorIncomplete({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    disableUserEditing,
    defaultValue,
    required onSave,
    onCancel,
  }) {
    var selectedData = "".obs;
    var selectedDataList = [].obs;
    var selectAllCheckBox = false.obs;
    var checkBoxStatus = [].obs;
    for (int j = 0; j < dropDownData!.length; j++) {
      checkBoxStatus.add(false);
    }
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 65),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !disableUserEditing ? Colors.white : Colors.grey[350],
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              border: Border.all(color: ColorConstants.black),
                            ),
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                          disableUserEditing
                                              ? selectedValue = defaultValue ?? "Select $name"
                                              : selectedValue == null || selectedValue == ""
                                              ? "Select $name"
                                              : selectedValue,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: ColorConstants.black,
                                            fontSize: Theme
                                                .of(Get.context!)
                                                .textTheme
                                                .displayMedium!
                                                .fontSize! - 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.open_in_new, size: 30.0, color: ColorConstants.black),
                                  ],
                                ),
                              ),
                              onTap:
                                  () =>
                                  showDialog(
                                    useSafeArea: true,
                                    useRootNavigator: false,
                                    barrierDismissible: true,
                                    context: Get.context!,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: Dialog(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                            side: const BorderSide(color: ColorConstants.primary, width: 2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                    Obx(() {
                                                      return IconButton(
                                                        icon: Icon(!selectAllCheckBox.value ? Icons.select_all : Icons.deselect, size: 30.0),
                                                        color: !selectAllCheckBox.value ? ColorConstants.grey : ColorConstants.black,
                                                        onPressed: () {
                                                          selectAllCheckBox.value = !selectAllCheckBox.value;
                                                          checkBoxStatus.clear();
                                                          selectedDataList.clear();
                                                          for (int i = 0; i < dropDownData.length; i++) {
                                                            checkBoxStatus.add(selectAllCheckBox.value);
                                                            if (selectAllCheckBox.value) {
                                                              selectedDataList.add(dropDownData[i][key]);
                                                            } else {
                                                              selectedDataList.clear();
                                                            }
                                                          }
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: dropDownData.length,
                                                          itemBuilder: (context, i) {
                                                            return Obx(() {
                                                              return CheckboxListTile(
                                                                activeColor: ColorConstants.primary,
                                                                side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                                value: checkBoxStatus[i],
                                                                dense: true,
                                                                title: Text(
                                                                  dropDownData[i][key],
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w400,
                                                                    color: selectAllCheckBox.value || checkBoxStatus[i] ? ColorConstants.black : ColorConstants.grey,
                                                                    letterSpacing: 0.5,
                                                                  ),
                                                                ),
                                                                selected: checkBoxStatus[i],
                                                                onChanged: (val) {
                                                                  checkBoxStatus[i] = val ?? false;
                                                                  if (val ?? false) {
                                                                    selectedDataList.add(dropDownData[i][key]);
                                                                  } else {
                                                                    selectedDataList.removeWhere((item) {
                                                                      return item == dropDownData[i][key];
                                                                    });
                                                                    selectAllCheckBox.value = false;
                                                                  }
                                                                },
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: SizeConstants.rootContainerSpacing),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ButtonConstant.dialogButton(
                                                      title: "Cancel",
                                                      borderColor: ColorConstants.red,
                                                      onTapMethod: () {
                                                        Get.back();
                                                        onCancel();
                                                      },
                                                    ),
                                                    const SizedBox(width: SizeConstants.contentSpacing),
                                                    ButtonConstant.dialogButton(
                                                      title: "Save & Close",
                                                      btnColor: ColorConstants.primary,
                                                      onTapMethod: () {
                                                        selectedData.value = "";
                                                        for (int i = 0; i < selectedDataList.length; i++) {
                                                          if (i + 1 == selectedDataList.length) {
                                                            selectedData.value += "${selectedDataList[i]}";
                                                          } else {
                                                            selectedData.value += "${selectedDataList[i]}, ";
                                                          }
                                                        }
                                                        Get.back();
                                                        onSave(selectedData.value);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        ),
                  ),
                  if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None")
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                      child: Text(
                        "($defaultValue)",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? ColorConstants.grey
                              : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget medicationSelector({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    disableUserEditing,
    defaultValue,
    onDialogPopUp,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 65),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !disableUserEditing ? Colors.white : Colors.grey[350],
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                              border: Border.all(color: ColorConstants.black),
                            ),
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                          disableUserEditing
                                              ? selectedValue = defaultValue ?? "Select $name"
                                              : selectedValue == null || selectedValue == ""
                                              ? "Select $name"
                                              : selectedValue,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: ColorConstants.black,
                                            fontSize: Theme
                                                .of(Get.context!)
                                                .textTheme
                                                .displayMedium!
                                                .fontSize! - 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.open_in_new, size: 30.0, color: ColorConstants.black),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (!disableUserEditing) {
                                  onDialogPopUp();
                                }
                              },
                            ),
                          ),
                        ),
                  ),
                  if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None")
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                      child: Text(
                        "($defaultValue)",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? ColorConstants.grey
                              : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget gpsCoordinatesDDDMMMMM({
    hidden,
    required name,
    rowColor,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required field1Id,
    field1Controller,
    field1FocusNode,
    field1OnTap,
    field1OnChanged,
    field1OnEditingComplete,
    required field2Id,
    field2Controller,
    field2FocusNode,
    field2OnTap,
    field2OnChanged,
    field2OnEditingComplete,
    required field3Id,
    field3Controller,
    field3FocusNode,
    field3OnTap,
    field3OnChanged,
    field3OnEditingComplete,
    required field4Id,
    field4Controller,
    field4FocusNode,
    field4OnTap,
    field4OnChanged,
    field4OnEditingComplete,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (name != "" || req)
              RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                      style: TextStyle(
                        color:
                        rowColor == "" || rowColor == null
                                ? ThemeColorMode.isLight
                                    ? ColorConstants.black
                                    : ColorConstants.white
                                : rowColor.toUpperCase() == "#FFFFFF"
                            ? ColorConstants.black
                            : ColorConstants.white,
                        fontSize: Theme
                            .of(Get.context!)
                            .textTheme
                            .displayMedium!
                            .fontSize! - 2,
                        fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                      ),
                      children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                    ),
              ),
            if (acronymTitle != name && acronymTitle != "")
              IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: acronymTitle,
                    splashRadius: 20,
                    padding: const EdgeInsets.all(4.0),
                    iconSize: 20,
                    constraints: const BoxConstraints(maxHeight: 30),
                onPressed: () {},
              ),
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SizedBox(
                width:
                Get.width > 480
                    ? Get.width > 980
                    ? (Get.width / 3) - ((12 / 3) * 9)
                    : (Get.width / 2) - ((12 / 2) * 8)
                    : Get.width - 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ResponsiveBuilder(
                        builder:
                            (context, sizingInformation) =>
                            FormBuilderField(
                              name: "$field1Id",
                              validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              builder:
                                  (FormFieldState<dynamic> field) =>
                                  TextField(
                                    controller: field1Controller,
                                    cursorColor: Colors.black,
                                    maxLength: 3,
                                    readOnly: disableUserEditing,
                                    focusNode: field1FocusNode,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    style: Theme
                                        .of(
                                      Get.context!,
                                    )
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: (Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium
                                        ?.fontSize)! - 4, color: ColorConstants.black),
                                    onTap: () {
                                      if (!disableUserEditing) {
                                        field1OnTap();
                                      }
                                    },
                                    onChanged: (String? value) {
                                      if (value != "") {
                                        field.didChange(value);
                                      } else {
                                        field.reset();
                                      }
                                      field1OnChanged(value);
                                    },
                                    onEditingComplete: () => field1OnEditingComplete(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                      errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6),
                                      counterText: "",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.red),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorText: field.errorText,
                                    ),
                                  ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                      child: Text(
                        "°",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? null
                              : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ResponsiveBuilder(
                        builder:
                            (context, sizingInformation) =>
                            FormBuilderField(
                              name: "$field2Id",
                              validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              builder:
                                  (FormFieldState<dynamic> field) =>
                                  TextField(
                                    controller: field2Controller,
                                    cursorColor: Colors.black,
                                    maxLength: 6,
                                    readOnly: disableUserEditing,
                                    focusNode: field2FocusNode,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d{1,3})?'))],
                                    style: Theme
                                        .of(
                                      Get.context!,
                                    )
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: (Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium
                                        ?.fontSize)! - 4, color: ColorConstants.black),
                                    onTap: () {
                                      if (!disableUserEditing) {
                                        field2OnTap();
                                      }
                                    },
                                    onChanged: (String? value) {
                                      if (value != "") {
                                        field.didChange(value);
                                      } else {
                                        field.reset();
                                      }
                                      field2OnChanged(value);
                                    },
                                    onEditingComplete: () => field2OnEditingComplete(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                      errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6),
                                      counterText: "",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.red),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorText: field.errorText,
                                    ),
                                  ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "' N",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? null
                              : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SizedBox(
                width:
                Get.width > 480
                    ? Get.width > 980
                    ? (Get.width / 3) - ((12 / 3) * 9)
                    : (Get.width / 2) - ((12 / 2) * 8)
                    : Get.width - 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ResponsiveBuilder(
                        builder:
                            (context, sizingInformation) =>
                            FormBuilderField(
                              name: "$field3Id",
                              validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              builder:
                                  (FormFieldState<dynamic> field) =>
                                  TextField(
                                    controller: field3Controller,
                                    cursorColor: Colors.black,
                                    maxLength: 3,
                                    readOnly: disableUserEditing,
                                    focusNode: field3FocusNode,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    style: Theme
                                        .of(
                                      Get.context!,
                                    )
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: (Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium
                                        ?.fontSize)! - 4, color: ColorConstants.black),
                                    onTap: () {
                                      if (!disableUserEditing) {
                                        field3OnTap();
                                      }
                                    },
                                    onChanged: (String? value) {
                                      if (value != "") {
                                        field.didChange(value);
                                      } else {
                                        field.reset();
                                      }
                                      field3OnChanged(value);
                                    },
                                    onEditingComplete: () => field3OnEditingComplete(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                      errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6),
                                      counterText: "",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.red),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorText: field.errorText,
                                    ),
                                  ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                      child: Text(
                        "°",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? null
                              : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ResponsiveBuilder(
                        builder:
                            (context, sizingInformation) =>
                            FormBuilderField(
                              name: "$field4Id",
                              validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              builder:
                                  (FormFieldState<dynamic> field) =>
                                  TextField(
                                    controller: field4Controller,
                                    cursorColor: Colors.black,
                                    maxLength: 6,
                                    readOnly: disableUserEditing,
                                    focusNode: field4FocusNode,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d{1,3})?'))],
                                    style: Theme
                                        .of(
                                      Get.context!,
                                    )
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: (Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium
                                        ?.fontSize)! - 4, color: ColorConstants.black),
                                    onTap: () {
                                      if (!disableUserEditing) {
                                        field4OnTap();
                                      }
                                    },
                                    onChanged: (String? value) {
                                      if (value != "") {
                                        field.didChange(value);
                                      } else {
                                        field.reset();
                                      }
                                      field4OnChanged(value);
                                    },
                                    onEditingComplete: () => field4OnEditingComplete(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                      errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6),
                                      counterText: "",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.black),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.red),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      errorText: field.errorText,
                                    ),
                                  ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "' W",
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? null
                              : rowColor.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
            if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None")
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                child: ResponsiveBuilder(
                  builder: (context, sizingInformation) => Text("($defaultValue)", style: const TextStyle(color: ColorConstants.grey, fontWeight: FontWeight.w100)),
                ),
              ),
      ],
    )
        : const SizedBox();
  }

  //****************************************************************** END OF Hybrid/Combined ******************************************************************
  //***************************** END OF General Fields: Text Fields || Date & Times || Check Box || Drop Downs || Hybrid/Combined *****************************

  //************************************************* Start of Formatting Fields: Spacer || New Line || Header *************************************************
  //Formatting Fields: Header || Spacer || New Line
  //Spacer & New Line
  static Widget spacer({showField, hidden, height}) {
    return showField ?? !hidden
        ? Padding(
      padding: height == null ? const EdgeInsets.symmetric(vertical: 5.0) : EdgeInsets.zero,
      child: SizedBox(
        height: height ?? 10.0,
        width:
        Get.width > 480
                    ? Get.width > 980
                        ? (Get.width / 3) - ((12 / 3) * 9)
                        : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
      ),
    )
        : const SizedBox();
  }

  static Widget newLine({showField, hidden}) {
    return showField ?? !hidden ? Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: SizedBox(width: Get.width, height: 10)) : const SizedBox();
  }

  //***************************************************************** END of SPACER & NEW LINES ****************************************************************

  //Headers
  static Widget headerCenteredBlue({showField, hidden, required name, acronymTitle, multiple}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: multiple ? null : Get.width - 5,
        child: Material(
          color: hexToColor("#1c4587"),
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                    Text(
                      name ?? "",
                      style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, fontWeight: FontWeight.w700),
                    ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget headerCenteredGreen({showField, hidden, required name, acronymTitle, multiple}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: multiple ? null : Get.width - 5,
        child: Material(
          color: hexToColor("#008000"),
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                    Text(
                      name ?? "",
                      style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, fontWeight: FontWeight.w700),
                    ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget headerCenteredOrange({showField, hidden, required name, acronymTitle, multiple}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: multiple ? null : Get.width - 5,
        child: Material(
          color: hexToColor("#ffa500"),
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                    Text(
                      name ?? "",
                      style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, fontWeight: FontWeight.w700),
                    ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget headerCenteredRed({showField, hidden, required name, acronymTitle, multiple}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: multiple ? null : Get.width - 5,
        child: Material(
          color: hexToColor("#ff0000"),
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                    Text(
                      name ?? "",
                      style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, fontWeight: FontWeight.w700),
                    ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget headerCenteredWhite({showField, hidden, required name, acronymTitle, multiple}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: multiple ? null : Get.width - 5,
        child: Material(
          color: hexToColor("#FFFFFF"),
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                    Text(
                      name ?? "",
                      style: TextStyle(color: ColorConstants.black, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, fontWeight: FontWeight.w700),
                    ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget headerCenteredCustom({showField, hidden, required name, acronymTitle, multiple, rowColor}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: multiple ? null : Get.width - 5,
        child: Material(
          color: rowColor != "" ? hexToColor(rowColor) : null,
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                    Text(
                      name ?? "",
                      style: TextStyle(
                        color:
                            rowColor == "" || rowColor == null
                                ? null
                                : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                        fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget headerCustom({showField, hidden, required String? name, acronymTitle, multiple, rowColor, nameAlign, height}) {
    return showField ?? !hidden
        ? Padding(
      padding: height == null ? const EdgeInsets.symmetric(vertical: 5.0) : EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height ?? 0.0 /*, maxHeight: 140, minWidth: multiple ? 0.0: Get.width - 5*/),
        child: Material(
          color: rowColor != "" ? hexToColor(rowColor) : null,
          borderRadius: height == null ? BorderRadius.circular(5) : const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Wrap(
              alignment:
              nameAlign == "L"
                  ? WrapAlignment.start
                  : nameAlign == "R"
                  ? WrapAlignment.end
                  : WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              children: [
                Text(
                  "${name?.trim() ?? ""} :",
                  style: TextStyle(
                    color:
                    rowColor == "" || rowColor == null
                                ? null
                                : rowColor.toUpperCase() == "#FFFFFF"
                        ? ColorConstants.black
                        : rowColor.toUpperCase() == "#FFFFFF"
                        ? ColorConstants.black
                        : ColorConstants.white,
                    fontSize: Theme
                        .of(Get.context!)
                        .textTheme
                        .displayMedium!
                        .fontSize! - 3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: acronymTitle,
                    splashRadius: 20,
                    padding: const EdgeInsets.all(4.0),
                    iconSize: 20,
                    constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox();
  }

  //********************************************************************** END of HEADERS **********************************************************************
  //************************************************* END OF FORMATTING FIELDS || SPACER || NEW LINE || HEADER *************************************************

  //**********START***{Rahat}************************** Fields For Pilot Profile : Text Fields || Drop Downs ***************************************************
  //Fields For Pilot Profile : Text Fields || Drop Downs
  //---------------Text Fields
  static Widget picTime({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget sicTime({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget nvgTime({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget dayFlightTime({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget nightFlightTime({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget instrumentTimeActual({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget instrumentTimeSimulated({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 5),
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget farPart91HoursTotal({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget farPart135HoursTotal({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  //--------------DropDown
  static Widget dayLandings({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget nightLandings({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget approachesILS({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget approachesLOCALIZER({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget approachesLPV({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget approachesLNAV({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget approachesVOR({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget operationsHNVGO({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  //-------------------------------------------------END OF Fields For Pilot Profile : Text Fields || Drop Down-------------------------------------------------

  //Fields For Selected Aircraft: Text Fields || Drop Downs
  //Fields Shown If NPNG AirCraft: Text Fields
  //Fields For Pratt Whitney: Text Fields
  //APU Fields: Total Time:  Text Fields
  //Fuel Farm Fields: Text Fields
  //-----------------START-------------- Fields for selected Aircraft
  //--------------START---------------- Fields Shown If NPNG AirCraft
  //--------------------START---------- Fields For Pratt Whitney
  //---------------START----------------- APU Fields: APU: Total Time (Start) || APU: Total Time (To Add) || APU: Total Time (End)
  //---------------START---------------- Fuel Farm Fields
  //--------Aircraft Flt Hobbs
  static Widget closeOutFieldsStart({
    bool hidden = false,
    required int id,
    bool req = false,
    bool? showField,
    String? nameAlign,
    String? acronymTitle,
    String? previousValue,
    required String? name,
    String? fieldType,
    String? rowColor,
    TextEditingController? controller,
    String? maxSize,
    bool disableUserEditing = false,
    FocusNode? focusNode,
    void Function()? onTap,
    void Function(String value)? onChanged,
    void Function()? onEditingComplete,
    String? defaultValue,
  }) {
    return (hidden && showField != null ? !showField : hidden)
        ? const SizedBox()
        : Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                      textScaler: TextScaler.linear(Get.textScaleFactor),
                      text: TextSpan(
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontSize: Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium!
                              .fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                        children: [
                          TextSpan(text: "${name != "" ? "$name${fieldType != null ? " " : ""}${fieldType ?? ""}" : (fieldType ?? "")} (Forward)"),
                          TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red)),
                        ],
                      ),
                ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                if (showField ?? true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ResponsiveBuilder(
                      builder:
                          (context, sizingInformation) =>
                          FormBuilderField(
                            name: "$id",
                            validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder:
                                (FormFieldState<dynamic> field) =>
                                TextField(
                                  controller: controller,
                                  cursorColor: Colors.black,
                                  maxLength: maxSize != null ? int.parse(maxSize) : null,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d+)?'))],
                                  readOnly: disableUserEditing,
                                  focusNode: focusNode,
                                  style: Theme
                                      .of(
                                    Get.context!,
                                  )
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 4, color: ColorConstants.black),
                                  onTap: !disableUserEditing ? onTap : null,
                                  onChanged: (String value) {
                                    if (value != "") {
                                      field.didChange(value);
                                    } else {
                                      field.reset();
                                    }
                                    onChanged != null ? onChanged(value) : null;
                                  },
                                  onEditingComplete: onEditingComplete,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                    helperText: defaultValue == null || defaultValue == "" || defaultValue == "0" || defaultValue == previousValue ? null : "($defaultValue)",
                                    helperStyle: TextStyle(
                                      color:
                                      rowColor == "" || rowColor == null
                                          ? null
                                          : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6,
                                    ),
                                    errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6),
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.red),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorText: field.errorText,
                                  ),
                                ),
                          ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  static Widget closeOutFieldsToAdd({
    bool hidden = false,
    required int id,
    bool req = false,
    bool? showField,
    String? nameAlign,
    String? acronymTitle,
    String? previousValue,
    required String? name,
    String? fieldType,
    String? rowColor,
    TextEditingController? controller,
    String? maxSize,
    bool disableUserEditing = false,
    FocusNode? focusNode,
    void Function()? onTap,
    void Function(String value)? onChanged,
    void Function()? onEditingComplete,
    String? defaultValue,
  }) {
    return (hidden && showField != null ? !showField : hidden)
        ? const SizedBox()
        : Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                      textScaler: TextScaler.linear(Get.textScaleFactor),
                      text: TextSpan(
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontSize: Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium!
                              .fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                        children: [
                          TextSpan(text: "${name != "" ? "$name${fieldType != null ? " " : ""}${fieldType ?? ""}" : (fieldType ?? "")} (To Add)"),
                          TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red)),
                        ],
                      ),
                ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                if (showField ?? true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ResponsiveBuilder(
                      builder:
                          (context, sizingInformation) =>
                          FormBuilderField(
                            name: "$id",
                            validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder:
                                (FormFieldState<dynamic> field) =>
                                TextField(
                                  controller: controller,
                                  cursorColor: Colors.black,
                                  maxLength: maxSize != null ? int.parse(maxSize) : null,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d+)?'))],
                                  readOnly: disableUserEditing,
                                  focusNode: focusNode,
                                  style: Theme
                                      .of(
                                    Get.context!,
                                  )
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 4, color: ColorConstants.black),
                                  onTap: !disableUserEditing ? onTap : null,
                                  onChanged: (String value) {
                                    if (value != "") {
                                      field.didChange(value);
                                    } else {
                                      field.reset();
                                    }
                                    onChanged != null ? onChanged(value) : null;
                                  },
                                  onEditingComplete: onEditingComplete,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                    helperText: defaultValue == null || defaultValue == "" || defaultValue == "0" || defaultValue == previousValue ? null : "($defaultValue)",
                                    helperStyle: TextStyle(
                                      color:
                                      rowColor == "" || rowColor == null
                                          ? null
                                          : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6,
                                    ),
                                    errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6),
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.red),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorText: field.errorText,
                                  ),
                                ),
                          ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  static Widget closeOutFieldsEnd({
    bool hidden = false,
    required int id,
    bool req = false,
    bool? showField,
    String? nameAlign,
    String? acronymTitle,
    String? previousValue,
    required String? name,
    String? fieldType,
    String? rowColor,
    TextEditingController? controller,
    String? maxSize,
    bool disableUserEditing = false,
    FocusNode? focusNode,
    void Function()? onTap,
    void Function(String value)? onChanged,
    void Function()? onEditingComplete,
    String? defaultValue,
  }) {
    return (hidden && showField != null ? !showField : hidden)
        ? const SizedBox()
        : Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                      textScaler: TextScaler.linear(Get.textScaleFactor),
                      text: TextSpan(
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontSize: Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium!
                              .fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                        children: [
                          TextSpan(text: "${name != "" ? "$name${fieldType != null ? " " : ""}${fieldType ?? ""}" : (fieldType ?? "")} (Ending)"),
                          TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red)),
                        ],
                      ),
                ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                if (showField ?? true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ResponsiveBuilder(
                      builder:
                          (context, sizingInformation) =>
                          FormBuilderField(
                            name: "$id",
                            validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder:
                                (FormFieldState<dynamic> field) =>
                                TextField(
                                  controller: controller,
                                  cursorColor: Colors.black,
                                  maxLength: maxSize != null ? int.parse(maxSize) : null,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d+)?'))],
                                  readOnly: disableUserEditing,
                                  focusNode: focusNode,
                                  style: Theme
                                      .of(
                                    Get.context!,
                                  )
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 4, color: ColorConstants.black),
                                  onTap: disableUserEditing ? onTap : null,
                                  onChanged: (String value) {
                                    if (value != "") {
                                      field.didChange(value);
                                    } else {
                                      field.reset();
                                    }
                                    onChanged != null ? onChanged(value) : null;
                                  },
                                  onEditingComplete: onEditingComplete,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                    helperText: defaultValue == null || defaultValue == "" || defaultValue == "0" || defaultValue == previousValue ? null : "($defaultValue)",
                                    helperStyle: TextStyle(
                                      color:
                                      rowColor == "" || rowColor == null
                                          ? null
                                          : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6,
                                    ),
                                    errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6),
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.red),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorText: field.errorText,
                                  ),
                                ),
                          ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  //--------Creep Damage Percent END
  static Widget creepDamagePercentEnd({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    fieldType,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
  }) {
    return (hidden && showField != null ? !showField : hidden)
        ? const SizedBox()
        : Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                      textScaler: TextScaler.linear(Get.textScaleFactor),
                      text: TextSpan(
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontSize: Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium!
                              .fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                        children: [
                          TextSpan(text: "${name != "" ? "$name${fieldType != null ? " " : ""}${fieldType ?? ""}" : (fieldType ?? "")} (Ending)"),
                          TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red)),
                        ],
                      ),
                ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                if (showField ?? true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ResponsiveBuilder(
                      builder:
                          (context, sizingInformation) =>
                          FormBuilderField(
                            name: "$id",
                            validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder:
                                (FormFieldState<dynamic> field) =>
                                TextField(
                                  controller: controller,
                                  cursorColor: Colors.black,
                                  maxLength: maxSize != null ? int.parse(maxSize) : null,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d+)?'))],
                                  readOnly: disableUserEditing,
                                  focusNode: focusNode,
                                  style: Theme
                                      .of(
                                    Get.context!,
                                  )
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 4, color: ColorConstants.black),
                                  onTap: () {
                                    if (!disableUserEditing) {
                                      onTap();
                                    }
                                  },
                                  onChanged: (String? value) {
                                    if (value != "") {
                                      field.didChange(value);
                                    } else {
                                      field.reset();
                                    }
                                    onChanged(value);
                                  },
                                  onEditingComplete: onEditingComplete,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                    helperText: defaultValue == null || defaultValue == "" || defaultValue == "0" || defaultValue == previousValue ? null : "($defaultValue)",
                                    helperStyle: TextStyle(
                                      color:
                                      rowColor == "" || rowColor == null
                                          ? null
                                          : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                      fontSize: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .displayMedium!
                                          .fontSize! - 6,
                                    ),
                                    errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6),
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.black),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: ColorConstants.red),
                                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                    ),
                                    errorText: field.errorText,
                                  ),
                                ),
                          ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  //---------Aircraft Reposition To Base|| Drop Down
  static Widget aircraftRepositionToBase({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  //---------------------------------------------- END Of Fields For Selected Aircraft: Text Fields || Drop Down -----------------------------------------------
  //----------------------------------------------------- End of Fields Shown If NPNG AirCraft: Text Fields ----------------------------------------------------
  //------------------------------------------------------- End of Fields For Pratt Whitney: Text Fields -------------------------------------------------------
  //------------------------------------------------------- End of APU Fields: Total Time:  Text Fields --------------------------------------------------------
  //----------------------------------------------------------- End of Fuel Farm Fields: Text Fields -----------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------

  //Misc Aircraft Fields: update AC Fuel In Lbs
  //---------------START-----------------Misc Aircraft Fields: update AC Fuel In Lbs
  static Widget updateAcFuelInLbs({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    maxSize,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) =>
                        FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) =>
                              TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: disableUserEditing,
                                focusNode: focusNode,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d)*(\.)?(\d)?'))],
                                style: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 4, color: ColorConstants.black),
                                onTap: () {
                                  if (!disableUserEditing) {
                                    onTap();
                                  }
                                },
                                onChanged: (String? value) {
                                  if (value != "") {
                                    field.didChange(value);
                                  } else {
                                    field.reset();
                                  }
                                  onChanged(value);
                                },
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  hintText: hintText ?? "Lbs",
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  //------------------------------------------------------------ End of Misc: update AC Fuel In Lbs ------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------

  //---------------------------------------- Done Before : Formatting Fields : GOTO Line 3790 || Signature Fields ----------------------------------------

  static Widget signatureElectronic({showField, hidden, required id, req, nameAlign, required String? fieldName, rowColor}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 540
                    ? Get.width > 1110
                        ? (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5
                    : Get.width - 5,
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      fieldName.isNotNullOrEmpty ? "${fieldName ?? ""}: " : "",
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                ? null
                                : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      "Signature - Save Form To View",
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                ? null
                                : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3,
                          ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget signaturePEN({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    controller,
    signatureController,
    disableUserEditing,
    focusNode,
    onTap,
    onChanged,
    penSignatureDateTime,
    penSignatureDateTimeValue,
    signatureLookUpController,
    onCancelPopUpOnTap,
    onChangeSignatureLookUp,
    signatureClearButtonEnable,
    signatureClearButtonOnTap,
    signatureStoreButtonEnable,
    signatureStoreButtonOnTap,
    signatureRecordId,
    signaturePenAllData,
    signaturePenData,
    signatureUserPointDataOnTap,
    onEditingComplete,
    defaultValue,
    hintText,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 540
                    ? Get.width > 1110
                        ? (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5
                    : Get.width - 5,
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (name != "" || req)
                      RichText(
                            textScaler: TextScaler.linear(Get.textScaleFactor),
                            text: TextSpan(
                              style: TextStyle(
                                color:
                                rowColor == "" || rowColor == null
                                        ? ThemeColorMode.isLight
                                            ? ColorConstants.black
                                            : ColorConstants.white
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                    ? ColorConstants.black
                                    : ColorConstants.white,
                                fontSize: Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium!
                                    .fontSize! - 2,
                                fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                              ),
                              children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                            ),
                      ),
                    if (acronymTitle != name && acronymTitle != "")
                      IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: acronymTitle,
                            splashRadius: 20,
                            padding: const EdgeInsets.all(4.0),
                            iconSize: 20,
                            constraints: const BoxConstraints(maxHeight: 30),
                        onPressed: () {},
                      ),
                  ],
                ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                showDialog(
                                  useSafeArea: true,
                                  useRootNavigator: false,
                                  barrierDismissible: true,
                                  context: Get.context!,
                                  builder: (BuildContext context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                      child: Dialog(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                          side: const BorderSide(color: ColorConstants.primary, width: 2),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              const TextWidget(text: "Signature Lookup", textAlign: TextAlign.center),
                                              const SizedBox(height: SizeConstants.contentSpacing),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        width: Get.width > 480 ? (Get.width / 2) - ((12 / 2) * 11) : Get.width - 5,
                                                        child: Column(
                                                          children: [
                                                            const Text("Name Of Person Signing"),
                                                            ResponsiveBuilder(
                                                              builder:
                                                                  (context, sizingInformation) =>
                                                                  FormBuilderField(
                                                                    name: "signatureName",
                                                                    builder:
                                                                        (FormFieldState<dynamic> field) =>
                                                                        TextField(
                                                                          controller: signatureLookUpController,
                                                                          cursorColor: Colors.black,
                                                                          maxLines: 1,
                                                                          style: Theme
                                                                              .of(Get.context!)
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(
                                                                            fontSize: (Theme
                                                                                .of(Get.context!)
                                                                                .textTheme
                                                                                .displayMedium
                                                                                ?.fontSize)! - 4,
                                                                            color: ColorConstants.black,
                                                                          ),
                                                                          onChanged: (value) => onChangeSignatureLookUp(value),
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                                                            hintText: "Search For Signature",
                                                                            hintStyle: TextStyle(
                                                                              color: ColorConstants.grey,
                                                                              fontSize: (Theme
                                                                                  .of(Get.context!)
                                                                                  .textTheme
                                                                                  .displayMedium
                                                                                  ?.fontSize)! - 5,
                                                                            ),
                                                                            helperText: "Search By First Name, Last Name, Or Both",
                                                                            helperStyle: TextStyle(
                                                                              color:
                                                                              rowColor == "" || rowColor == null
                                                                                  ? null
                                                                                  : rowColor.toUpperCase() == "#FFFFFF"
                                                                                  ? ColorConstants.black
                                                                                  : ColorConstants.white,
                                                                              fontSize: Theme
                                                                                  .of(Get.context!)
                                                                                  .textTheme
                                                                                  .displayMedium!
                                                                                  .fontSize! - 6,
                                                                            ),
                                                                            errorStyle: TextStyle(
                                                                              color: ColorConstants.red,
                                                                              fontSize: Theme
                                                                                  .of(Get.context!)
                                                                                  .textTheme
                                                                                  .displayMedium!
                                                                                  .fontSize! - 6,
                                                                            ),
                                                                            counterText: "",
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: ColorConstants.black),
                                                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                                                            ),
                                                                            border: OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: ColorConstants.black),
                                                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: ColorConstants.black),
                                                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                                                            ),
                                                                            errorBorder: OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: ColorConstants.red),
                                                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                                                            ),
                                                                            errorText: field.errorText,
                                                                          ),
                                                                        ),
                                                                  ),
                                                            ),
                                                            Obx(() {
                                                              return Expanded(
                                                                child:
                                                                signaturePenData.isEmpty
                                                                    ? Text("No Signature Found(${signaturePenAllData["searchTerm"] ?? " "})")
                                                                    : ListView.builder(
                                                                          itemCount: signaturePenData.length,
                                                                          itemBuilder: (context, item) {
                                                                            return InkWell(
                                                                              onTap: () => signatureUserPointDataOnTap(signaturePenData[item]),
                                                                              child: Wrap(
                                                                                children: [
                                                                                  Text("${item + 1}. "),
                                                                                  Text("${signaturePenAllData["signaturePenData"][item]["signatureName"]}"),
                                                                                  Text("${signaturePenAllData["signaturePenData"][item]["fullName"]}"),
                                                                                  Text("${signaturePenAllData["signaturePenData"][item]["savedAt"]}"),
                                                                                  DottedLine(
                                                                                    direction: Axis.horizontal,
                                                                                    lineThickness: 2,
                                                                                    dashColor: Theme.of(Get.context!).dividerColor,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                              );
                                                            }),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: SizeConstants.contentSpacing),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [ButtonConstant.dialogButton(title: "Cancel", borderColor: ColorConstants.red, onTapMethod: onCancelPopUpOnTap)],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              color: ColorConstants.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search, color: ColorConstants.white, size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3),
                                  const SizedBox(width: 3.0),
                                  TextWidget(
                                    text: "Lookup Signature",
                                    color: ColorConstants.white,
                                    size: Theme.of(context).textTheme.headlineMedium!.fontSize,
                                    weight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            if (signatureClearButtonEnable)
                              MaterialButton(
                                onPressed: () => signatureClearButtonOnTap(),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                color: ColorConstants.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.clear, color: ColorConstants.white, size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3),
                                    const SizedBox(width: 3.0),
                                    TextWidget(
                                      text: "Clear Signature",
                                      color: ColorConstants.white,
                                      size: Theme.of(context).textTheme.headlineMedium!.fontSize,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            if (signatureClearButtonEnable && signatureStoreButtonEnable)
                              MaterialButton(
                                onPressed: () => signatureStoreButtonOnTap(),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                color: ColorConstants.button,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save, color: ColorConstants.white, size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3),
                                    const SizedBox(width: 3.0),
                                    TextWidget(
                                      text: "Store Signature on File",
                                      color: ColorConstants.white,
                                      size: Theme.of(context).textTheme.headlineMedium!.fontSize,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                Get.width > 535
                                    ? Get.width > 1100
                                        ? ((Get.width - 1100) / 4)
                                        : ((Get.width - 535) / 2)
                                    : 0.0,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Material(
                                shape: const RoundedRectangleBorder(side: BorderSide(color: ColorConstants.primary, width: 2)),
                                child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: Signature(controller: signatureController, backgroundColor: ColorConstants.white, height: 150),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 25.0, left: 15.0, right: 15.0),
                                child: DottedLine(direction: Axis.horizontal, lineThickness: 2, dashColor: ColorConstants.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing),
                        Text("Name", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                        ResponsiveBuilder(
                          builder:
                              (context, sizingInformation) => FormBuilderField(
                                name: "$id",
                                validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                builder:
                                    (FormFieldState<dynamic> field) => TextField(
                                      controller: controller,
                                      cursorColor: Colors.black,
                                      //maxLength: maxSize != null ? int.parse(maxSize) : null,
                                      readOnly: disableUserEditing,
                                      focusNode: focusNode,
                                      style: Theme.of(
                                        Get.context!,
                                      ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4, color: ColorConstants.black),
                                      onChanged: (String? value) {
                                        if (value != "") {
                                          field.didChange(value);
                                        } else {
                                          field.reset();
                                        }
                                        onChanged(value);
                                      },
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                        helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                        hintText: hintText ?? "Name of Person Signing",
                                        hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                                        helperStyle: TextStyle(
                                          color:
                                              rowColor == "" || rowColor == null
                                                  ? null
                                                  : rowColor.toUpperCase() == "#FFFFFF"
                                                  ? ColorConstants.black
                                                  : ColorConstants.white,
                                          fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6,
                                        ),
                                        errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6),
                                        counterText: "",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: ColorConstants.black),
                                          borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: ColorConstants.black),
                                          borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: ColorConstants.black),
                                          borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: ColorConstants.red),
                                          borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                        ),
                                        errorText: field.errorText,
                                      ),
                                    ),
                              ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing),
                        Text(
                          "Date: ${signatureClearButtonEnable && penSignatureDateTime
                              ? penSignatureDateTimeValue.toString()
                              : signatureClearButtonEnable
                              ? DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now).toString()
                              : "None"}",
                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                        ),
                      ],
                    ),
              ],
            );
          },
        ),
      ),
    )
        : const SizedBox();
  }

  //------------------------------------------------------------ End of Signature Fields ------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------

  //Automation Fields: Drop Down || Check Box
  //------------------START-------- Automation Fields ---------------------
  static Widget generateAutomaticID({hidden, required id, req, showField, nameAlign, acronymTitle, previousValue, required name, rowColor, controller, focusNode, defaultValue}) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (name != "" || req)
                  RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                        ),
                  ),
                if (acronymTitle != name && acronymTitle != "")
                  IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: acronymTitle,
                        splashRadius: 20,
                        padding: const EdgeInsets.all(4.0),
                        iconSize: 20,
                        constraints: const BoxConstraints(maxHeight: 30),
                    onPressed: () {},
                  ),
              ],
            ),
                Padding(
                  padding: name != "" ? const EdgeInsets.only(top: 10.0) : EdgeInsets.zero,
                  child: ResponsiveBuilder(
                    builder:
                        (context, sizingInformation) => FormBuilderField(
                          name: "$id",
                          validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder:
                              (FormFieldState<dynamic> field) => TextField(
                                controller: controller,
                                cursorColor: Colors.black,
                                //maxLength: maxSize != null ? int.parse(maxSize) : null,
                                readOnly: true,
                                focusNode: focusNode,
                                style: Theme.of(
                                  Get.context!,
                                ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4, color: ColorConstants.black),
                                /*onTap: () {
                              if (!disableUserEditing) {
                                onTap();
                              }
                            },
                            onChanged: (String? value) {
                              if (value != "") {
                                field.didChange(value);
                              } else {
                                field.reset();
                              }
                              onChanged(value);
                            },
                            onEditingComplete: onEditingComplete,*/
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorText: field.errorText,
                                ),
                              ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget riskAssessmentChooser({
    required bool hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    TextEditingController? dropDownController,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required String dropDownKey,
    required onChanged,
    onClick,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: DropdownMenu(
                                controller: dropDownController,
                                initialSelection:
                                (dropDownData ?? []).isNotEmpty
                                    ? dropDownData?.cast<Map<String, dynamic>>().firstWhere(
                                      (element) => element[dropDownKey] == (selectedValue ?? dropDownController?.text),
                                  orElse: () => dropDownData.first,
                                )
                                    : null,
                                enabled: !disableUserEditing,
                                menuHeight: Get.height - 200,
                                textStyle: Theme
                                    .of(
                                  Get.context!,
                                )
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: (Theme
                                    .of(Get.context!)
                                    .textTheme
                                    .displayMedium
                                    ?.fontSize)! - 3, color: ColorConstants.black),
                                trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                                expandedInsets: EdgeInsets.zero,
                                hintText:
                                disableUserEditing
                                    ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][dropDownKey] : "-- Select Risk Assessment --")
                                    : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[0][dropDownKey] : "-- Select Risk Assessment --"),
                                helperText:
                                defaultValue == null ||
                                    defaultValue == "" ||
                                    defaultValue == "0" ||
                                    defaultValue == "0.0" ||
                                    defaultValue == previousValue ||
                                    defaultValue == "None"
                                    ? null
                                    : "($defaultValue)",
                                errorText: field.errorText,
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                                  hintStyle: Theme
                                      .of(
                                    context,
                                  )
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: ColorConstants.black, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 3),
                                  helperStyle: TextStyle(
                                    color:
                                    rowColor == "" || rowColor == null
                                        ? null //ColorConstants.GREY
                                        : rowColor.toUpperCase() == "#FFFFFF"
                                        ? ColorConstants.black
                                        : ColorConstants.white,
                                    fontSize: Theme
                                        .of(Get.context!)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                                  ),
                                  errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium!
                                      .fontSize! - 6),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.black),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: ColorConstants.red),
                                    borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                  ),
                                ),
                                dropdownMenuEntries:
                                dropDownData == null
                                    ? []
                                    : dropDownData.map((value) {
                                  return DropdownMenuEntry<dynamic>(
                                    value: value,
                                    label: "${value[dropDownKey]}",
                                    style: ButtonStyle(
                                      textStyle: WidgetStatePropertyAll(
                                        Theme
                                            .of(
                                          Get.context!,
                                        )
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: (Theme
                                            .of(Get.context!)
                                            .textTheme
                                            .displayMedium
                                            ?.fontSize)! - 3),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onSelected: (val) {
                                  field.didChange(val);
                                  onChanged(val);
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: ButtonConstant.buttonWidgetSingleWithIcon(icon: Icons.refresh, height: 55.0, iconSize: 35.0, onTap: onClick),
                              ),
                            ),
                          ],
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urAdministrator({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urBillingSpecialist({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urLeadMechanic({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urLeadPilot({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urMechanic({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urNurse({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText:
                          disableUserEditing
                              ? selectedValue = defaultValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : "")
                              : selectedValue ?? (dropDownData!.isNotEmpty ? dropDownData[1][key] : ""),
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  static Widget urAllPilots({
    hidden,
    required id,
    req,
    showField,
    nameAlign,
    acronymTitle,
    previousValue,
    required name,
    rowColor,
    focusNode,
    required selectedValue,
    required List? dropDownData,
    required key,
    required onChanged,
    disableUserEditing,
    defaultValue,
  }) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: ResponsiveBuilder(
          builder:
              (context, sizingInformation) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (name != "" || req)
                        RichText(
                          textScaler: TextScaler.linear(Get.textScaleFactor),
                          text: TextSpan(
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                  ? ColorConstants.black
                                  : ColorConstants.white
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                          ? ColorConstants.black
                                          : ColorConstants.white,
                                  fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 2,
                              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                            ),
                            children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                          ),
                        ),
                      if (acronymTitle != name && acronymTitle != "")
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: acronymTitle,
                          splashRadius: 20,
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 20,
                          constraints: const BoxConstraints(maxHeight: 30),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  if (name != "") const SizedBox(height: 10),
                  FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "$name field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: focusNode,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        DropdownMenu(
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          textStyle: Theme
                              .of(
                            Get.context!,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme
                              .of(Get.context!)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 3, color: ColorConstants.black),
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          expandedInsets: EdgeInsets.zero,
                          hintText: disableUserEditing ? selectedValue = defaultValue ?? name : selectedValue ?? name,
                          helperText:
                          defaultValue == null ||
                              defaultValue == "" ||
                              defaultValue == "0" ||
                              defaultValue == "0.0" ||
                              defaultValue == previousValue ||
                              defaultValue == "None"
                              ? null
                              : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: Theme
                                .of(
                              context,
                            )
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorConstants.black, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 3),
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null //ColorConstants.GREY
                                  : rowColor.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(Get.context!)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6 /*, fontWeight: FontWeight.w100*/,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                          dropdownMenuEntries:
                          dropDownData == null
                              ? []
                              : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[key]}",
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(
                                  Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: (Theme
                                      .of(Get.context!)
                                      .textTheme
                                      .displayMedium
                                      ?.fontSize)! - 3),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (val) {
                            field.didChange(val);
                            onChanged(val);
                          },
                        ),
                  ),
                ],
              ),
        ),
      ),
    )
        : const SizedBox();
  }

  //-------------------------------Automation Fields: Drop Down || Check Box
  //------------------------------------------------------------------------------------------------------------------------------------------------------------

  static Widget formDynamicDropDown({
    bool? req,
    bool? expands,
    String? title,
    Color? titleColor,
    String? hintText,
    required RxList? dropDownData,
    required String dropDownKey,
    GlobalKey<FormFieldState>? dropDownValidationKey,
    String? validatorKeyName,
    TextEditingController? dropDownController,
    void Function(dynamic)? onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor))),
          FormBuilderField(
            key: dropDownValidationKey,
            name: validatorKeyName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "drop_down",
            validator: req == true ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "${title ?? ""} Field is Required!")]) : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder:
                (field) => Obx(() {
                  return DropdownMenu(
                    controller: dropDownController,
                    initialSelection:
                        (dropDownData ?? []).isNotEmpty
                            ? dropDownData?.cast<Map<String, dynamic>>().firstWhere(
                              (element) => element[dropDownKey] == (hintText ?? dropDownController?.text),
                              orElse: () => dropDownData.first,
                            )
                            : null,
                    hintText: hintText,
                    errorText: field.errorText,
                    menuHeight: Get.height - 200,
                    textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    trailingIcon: Icon(Icons.keyboard_arrow_down, size: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize! + 10, color: ColorConstants.black),
                    expandedInsets: expands == true ? EdgeInsets.zero : null,
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black)),
                    ),
                    dropdownMenuEntries:
                        dropDownData == null
                            ? []
                            : dropDownData.map((value) {
                              return DropdownMenuEntry<dynamic>(
                                value: value,
                                label: "${value[dropDownKey]}",
                                style: ButtonStyle(textStyle: WidgetStateProperty.all(Theme.of(Get.context!).textTheme.bodyMedium)),
                              );
                            }).toList(),
                    onSelected: (val) async {
                      if (dropDownData != null && (dropDownData[0][dropDownKey] != val[dropDownKey])) {
                        field.didChange(val);
                      } else {
                        field.reset();
                      }
                      if (onSelected != null) {
                        onSelected(val);
                      }
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  static Widget formButtonWithIcon({
    IconData? icon,
    Color? iconColor,
    String? title,
    Color? titleColor,
    FontWeight? fontWeight,
    Color? buttonColor,
    Color? borderColor,
    required void Function()? onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor,
      disabledColor: Colors.grey[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: title != null ? const EdgeInsets.only(right: 5.0) : const EdgeInsets.all(0.0),
              child: Icon(icon, color: iconColor ?? ColorConstants.white, size: 20.0),
            ),
          if (title != null)
            Text(title, style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: titleColor ?? ColorConstants.white, fontWeight: fontWeight ?? FontWeight.bold)),
        ],
      ),
    );
  }

  static Future<void> formDialogBox({
    BuildContext? context,
    String? dialogTitle,
    IconData? dialogTitleIcon,
    Color? titleColor,
    bool expandedModal = false,
    List<Widget> children = const <Widget>[],
    String? deleteButtonTitle,
    Color? deleteButtonTitleColor,
    IconData? deleteButtonIcon,
    Color? deleteButtonIconColor,
    Color? deleteButtonColor,
    Color? deleteButtonBorderColor,
    void Function()? onDeleteButton,
    String? actionButtonTitle,
    Color? actionButtonTitleColor,
    IconData? actionButtonIcon,
    Color? actionButtonIconColor,
    Color? actionButtonColor,
    Color? actionButtonBorderColor,
    void Function()? onActionButton,
    String? cancelButtonTitle,
    Color? cancelButtonTitleColor,
    IconData? cancelButtonIcon,
    Color? cancelButtonIconColor,
    Color? cancelButtonColor,
    Color? cancelButtonBorderColor,
    void Function()? onCancelButton,
  }) {
    RxBool? pressed = false.obs;
    return showDialog<void>(
      context: context ?? Get.context!,
      builder:
          (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              insetPadding: expandedModal ? const EdgeInsets.symmetric(horizontal: 5.0, vertical: 24.0) : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dialogTitleIcon != null) Icon(dialogTitleIcon, color: ColorConstants.primary, size: 28.0),
                  Flexible(child: Text(dialogTitle ?? "", textAlign: TextAlign.center)),
                ],
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: titleColor ?? ColorConstants.primary, fontWeight: FontWeight.bold),
              titlePadding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              content: GestureDetector(
                onTap: () => Keyboard.close(context: context),
                child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
              ),
              contentTextStyle: Theme.of(context).textTheme.bodyMedium,
              contentPadding: EdgeInsets.symmetric(horizontal: expandedModal ? 5.0 : 20, vertical: 5.0),
              actions: [
                if (deleteButtonTitle != null)
                  Obx(() {
                    return formButtonWithIcon(
                      title: "${pressed.isTrue ? "Confirm " : ""}$deleteButtonTitle${pressed.isTrue ? "?" : ""}",
                      titleColor: deleteButtonTitleColor ?? ColorConstants.white,
                      icon: deleteButtonIcon ?? Icons.delete_forever_outlined,
                      iconColor: deleteButtonIconColor ?? deleteButtonTitleColor ?? ColorConstants.white,
                      buttonColor: deleteButtonColor ?? ColorConstants.red,
                      borderColor: deleteButtonBorderColor ?? ColorConstants.red,
                      onPressed: () {
                        if (pressed.isFalse) {
                          pressed.value = true;
                        } else if (pressed.isTrue && onDeleteButton != null) {
                          onDeleteButton();
                        }
                      },
                    );
                  }),
                if (actionButtonTitle != null)
                  formButtonWithIcon(
                    title: actionButtonTitle,
                    titleColor: actionButtonTitleColor ?? ColorConstants.white,
                    icon: actionButtonIcon ?? Icons.check_circle_outline,
                    iconColor: actionButtonIconColor ?? actionButtonTitleColor ?? ColorConstants.white,
                    buttonColor: actionButtonColor ?? ColorConstants.primary,
                    borderColor: actionButtonBorderColor ?? ColorConstants.primary,
                    onPressed: onActionButton,
                  ),
                formButtonWithIcon(
                  title: cancelButtonTitle ?? "CLOSE",
                  titleColor: cancelButtonTitleColor ?? ColorConstants.white,
                  icon: cancelButtonIcon ?? Icons.cancel_outlined,
                  iconColor: cancelButtonIconColor ?? cancelButtonTitleColor ?? ColorConstants.white,
                  buttonColor: cancelButtonColor ?? ColorConstants.primary,
                  borderColor: cancelButtonBorderColor ?? ColorConstants.red,
                  onPressed: () {
                    Get.back();
                    onCancelButton != null ? onCancelButton() : null;
                  },
                ),
              ],
            ),
          ),
    );
  }

  static Future<void> formDialogBox2({
    BuildContext? context,
    String? dialogTitle,
    IconData? dialogTitleIcon,
    Color? titleColor,
    bool expandedModal = false,
    Widget? child,
    String? deleteButtonTitle,
    Color? deleteButtonTitleColor,
    IconData? deleteButtonIcon,
    Color? deleteButtonIconColor,
    Color? deleteButtonColor,
    Color? deleteButtonBorderColor,
    void Function()? onDeleteButton,
    String? actionButtonTitle,
    Color? actionButtonTitleColor,
    IconData? actionButtonIcon,
    Color? actionButtonIconColor,
    Color? actionButtonColor,
    Color? actionButtonBorderColor,
    void Function()? onActionButton,
    String? cancelButtonTitle,
    Color? cancelButtonTitleColor,
    IconData? cancelButtonIcon,
    Color? cancelButtonIconColor,
    Color? cancelButtonColor,
    Color? cancelButtonBorderColor,
    void Function()? onCancelButton,
  }) {
    RxBool? pressed = false.obs;
    return showDialog<void>(
      context: context ?? Get.context!,
      builder:
          (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              insetPadding: expandedModal ? const EdgeInsets.symmetric(horizontal: 5.0, vertical: 24.0) : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (dialogTitleIcon != null) Icon(dialogTitleIcon, color: ColorConstants.primary, size: 28.0),
                  Flexible(child: Text(dialogTitle ?? "", textAlign: TextAlign.center)),
                ],
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: titleColor ?? ColorConstants.primary, fontWeight: FontWeight.bold),
              titlePadding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              content: GestureDetector(onTap: () => Keyboard.close(context: context), child: child),
              contentTextStyle: Theme.of(context).textTheme.bodyMedium,
              contentPadding: EdgeInsets.symmetric(horizontal: expandedModal ? 5.0 : 20, vertical: 5.0),
              actions: [
                if (deleteButtonTitle != null)
                  Obx(() {
                    return formButtonWithIcon(
                      title: "${pressed.isTrue ? "Confirm " : ""}$deleteButtonTitle${pressed.isTrue ? "?" : ""}",
                      titleColor: deleteButtonTitleColor ?? ColorConstants.white,
                      icon: deleteButtonIcon ?? Icons.delete_forever_outlined,
                      iconColor: deleteButtonIconColor ?? deleteButtonTitleColor ?? ColorConstants.white,
                      buttonColor: deleteButtonColor ?? ColorConstants.red,
                      borderColor: deleteButtonBorderColor ?? ColorConstants.red,
                      onPressed: () {
                        if (pressed.isFalse) {
                          pressed.value = true;
                        } else if (pressed.isTrue && onDeleteButton != null) {
                          onDeleteButton();
                        }
                      },
                    );
                  }),
                if (actionButtonTitle != null)
                  formButtonWithIcon(
                    title: actionButtonTitle,
                    titleColor: actionButtonTitleColor ?? ColorConstants.white,
                    icon: actionButtonIcon ?? Icons.check_circle_outline,
                    iconColor: actionButtonIconColor ?? actionButtonTitleColor ?? ColorConstants.white,
                    buttonColor: actionButtonColor ?? ColorConstants.primary,
                    borderColor: actionButtonBorderColor ?? ColorConstants.primary,
                    onPressed: onActionButton,
                  ),
                formButtonWithIcon(
                  title: cancelButtonTitle ?? "CLOSE",
                  titleColor: cancelButtonTitleColor ?? ColorConstants.white,
                  icon: cancelButtonIcon ?? Icons.cancel_outlined,
                  iconColor: cancelButtonIconColor ?? cancelButtonTitleColor ?? ColorConstants.white,
                  buttonColor: cancelButtonColor ?? ColorConstants.primary,
                  borderColor: cancelButtonBorderColor ?? ColorConstants.red,
                  onPressed: () {
                    Get.back();
                    onCancelButton != null ? onCancelButton() : null;
                  },
                ),
              ],
            ),
          ),
    );
  }
}

//*************************************************** Widgets for View User Form **************************************************************************

class GeneralMaterialButton extends StatelessWidget {
  final String? buttonText;
  final double? buttonTextSize;
  final Color? buttonTextColor;
  final Color? buttonColor;
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final double? lrPadding;
  final void Function()? onPressed;

  const GeneralMaterialButton({
    super.key,
    this.buttonText,
    this.buttonTextSize,
    this.buttonTextColor,
    this.buttonColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.lrPadding,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: lrPadding ?? 0.0),
      child: MaterialButton(
        //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: buttonColor ?? ColorConstants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconColor ?? ((buttonColor == null || buttonColor == ColorConstants.white) ? ColorConstants.primary : ColorConstants.white),
                size: Theme.of(context).textTheme.displayMedium!.fontSize! + 3,
              ),
            const SizedBox(width: 3.0),
            TextWidget(
              text: buttonText ?? "",
              color: buttonTextColor ?? ((buttonColor == null || buttonColor == ColorConstants.white) ? ColorConstants.primary : ColorConstants.white),
              weight: FontWeight.w700,
              size: buttonTextSize ?? Theme.of(context).textTheme.headlineMedium?.fontSize,
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicTextField extends StatelessWidget {
  final String? dataType;
  final bool req;
  final String? fieldName;
  final GlobalKey<FormFieldState>? validationKey;
  final String? title;
  final TextStyle? titleTextStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isDense;
  final bool readOnly;
  final bool? showCursor;
  final double? inputTextSize;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;

  const DynamicTextField({
    super.key,
    this.dataType,
    this.req = false,
    this.fieldName,
    this.validationKey,
    this.title,
    this.titleTextStyle,
    this.hintText,
    this.hintStyle,
    this.controller,
    this.focusNode,
    this.isDense = true,
    this.readOnly = false,
    this.showCursor,
    this.inputTextSize,
    this.textInputType,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isDense ? const EdgeInsets.all(5.0) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((title != null && title != "") || req)
            Padding(padding: isDense ? const EdgeInsets.only(left: 5.0) : EdgeInsets.zero, child: Text("${title ?? " "}${req ? "*" : ""}", style: titleTextStyle)),
          Padding(
            padding: (title != null && title != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
            child: FormBuilderField(
              key: validationKey,
              name: fieldName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
              validator: req ? FormBuilderValidators.required(errorText: "${title ?? "This"} field is required.") : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder:
                  (FormFieldState<dynamic> field) => TextField(
                    controller: controller,
                    focusNode: focusNode,
                    readOnly: readOnly,
                    showCursor: showCursor,
                    cursorColor: Colors.black,
                    maxLines: dataType == "remarks" || dataType == "comments" ? 5 : 1,
                    keyboardType:
                        dataType == "remarks" || dataType == "comments"
                            ? TextInputType.multiline
                            : dataType == "number"
                            ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                            : textInputType,
                    textInputAction: textInputAction,
                    onTap: onTap,
                    onChanged: (String value) {
                      if (value != "") {
                        field.didChange(value);
                      } else {
                        field.reset();
                      }
                      onChanged != null ? onChanged!(value) : null;
                    },
                    onEditingComplete: onEditingComplete,
                    textAlign: dataType == "remarks" || dataType == "comments" || dataType == "filter" ? TextAlign.start : TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontSize: inputTextSize),
                    decoration: InputDecoration(
                      isDense: isDense,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: hintText,
                      hintStyle: hintStyle,
                      errorText: field.errorText,
                      errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 6),
                      border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: ColorConstants.black),
                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: ColorConstants.black),
                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                      ),
                      errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicDateField extends StatelessWidget {
  final bool req;
  final String? fieldName;
  final GlobalKey<FormFieldState>? validationKey;
  final String? title;
  final TextStyle? titleTextStyle;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isDense;
  final double? inputTextSize;
  final void Function(DateTime)? onConfirm;
  final void Function()? onCancel;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? dateType;

  const DynamicDateField({
    super.key,
    this.req = false,
    this.fieldName,
    this.validationKey,
    this.title,
    this.titleTextStyle,
    required this.controller,
    this.focusNode,
    this.isDense = true,
    this.inputTextSize,
    this.onConfirm,
    this.onCancel,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.dateType,
  });

  @override
  Widget build(BuildContext context) {
    RxBool disableKeyboard = true.obs;

    return Padding(
      padding: isDense ? const EdgeInsets.all(5.0) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((title != null && title != "") || req)
            Padding(padding: isDense ? const EdgeInsets.only(left: 5.0) : EdgeInsets.zero, child: Text("${title ?? " "}${req ? "*" : ""}", style: titleTextStyle)),
          Padding(
            padding: (title != null && title != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
            child: FormBuilderField(
              key: validationKey,
              name: fieldName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "date_field",
              validator: req ? FormBuilderValidators.required(errorText: "${title ?? "This"} field is required.") : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder:
                  (FormFieldState<dynamic> field) => Obx(() {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      readOnly: disableKeyboard.value,
                      showCursor: !disableKeyboard.value,
                      cursorColor: Colors.black,
                      keyboardType: disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?/?(\d{1,2})?/?(\d{1,4})?'))],
                      onTap: () {
                        onTap != null ? onTap!() : null;
                        if (disableKeyboard.value) {
                          DatePicker.showDatePicker(
                            context,
                            minDateTime:
                                dateType == "FlightDate_Older"
                                    ? DateTimeHelper.now.subtract(const Duration(days: 1460))
                                    : dateType == "FlightDate"
                                    ? DateTimeHelper.now.subtract(const Duration(days: 30))
                                    : DateTime(2010, 1, 1),
                            maxDateTime: DateTimeHelper.now.add(const Duration(days: 1)),
                            onConfirm: (date, list) {
                              controller.text = DateTimeHelper.dateFormatDefault.format(date);
                              field.didChange(date);
                              disableKeyboard.value = true;
                              onConfirm != null ? onConfirm!(date) : null;
                            },
                            onCancel: () {
                              disableKeyboard.value = false;
                              onCancel != null ? onCancel!() : null;
                            },
                            initialDateTime: DateTimeHelper.now,
                            locale: DATETIME_PICKER_LOCALE_DEFAULT,
                          );
                        }
                      },
                      onChanged: (String value) {
                        if (value != "") {
                          field.didChange(value);
                        } else {
                          field.reset();
                        }
                        onChanged != null ? onChanged!(value) : null;
                      },
                      onEditingComplete: () {
                        disableKeyboard.value = true;
                        field.didChange(controller.text);
                        FocusScope.of(context).unfocus();
                        onEditingComplete != null ? onEditingComplete!() : null;
                      },
                      onTapOutside: (event) {
                        disableKeyboard.value = true;
                        field.didChange(controller.text);
                        FocusScope.of(context).unfocus();
                        Keyboard.close(context: context);
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontSize: inputTextSize),
                      decoration: InputDecoration(
                        isDense: isDense,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "mm/dd/yyyy",
                        errorText: field.errorText,
                        errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 6),
                        border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ColorConstants.black),
                          borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ColorConstants.black),
                          borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                        ),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicDropDown extends StatelessWidget {
  final bool req;
  final bool expands;
  final String? title;
  final String? hintText;
  final List? dropDownData;
  final String dropDownKey;
  final GlobalKey<FormFieldState>? validationKey;
  final String? fieldName;
  final TextEditingController? dropDownController;
  final bool enableSearch;
  final void Function(dynamic)? onSelected;

  const DynamicDropDown({
    super.key,
    this.req = false,
    this.expands = false,
    this.title,
    this.hintText,
    required this.dropDownData,
    required this.dropDownKey,
    this.validationKey,
    this.fieldName,
    this.dropDownController,
    this.enableSearch = true,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((title != null && title != "") || req) Text("${title ?? ""}${req ? " *" : ""}"),
          Padding(
            padding: (title != null && title != "") ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
            child: FormBuilderField(
              key: validationKey,
              name: fieldName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "drop_down",
              validator: req ? FormBuilderValidators.required(errorText: "${title ?? "This"} Field is Required!") : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder:
                  (field) => DropdownMenu(
                    controller: dropDownController,
                    initialSelection:
                        (dropDownData ?? []).isNotEmpty
                            ? dropDownData?.cast<Map<String, dynamic>>().firstWhere(
                              (element) => element[dropDownKey] == (hintText ?? dropDownController?.text),
                              orElse: () => dropDownData?.first,
                            )
                            : null,
                    enableSearch: enableSearch,
                    menuHeight: Get.height - 200,
                    expandedInsets: expands ? EdgeInsets.zero : null,
                    dropdownMenuEntries:
                        dropDownData == null
                            ? []
                            : dropDownData!.map((value) {
                              return DropdownMenuEntry<dynamic>(
                                value: value,
                                label: "${value[dropDownKey]}",
                                style: ButtonStyle(textStyle: WidgetStateProperty.all(Theme.of(context).textTheme.bodyMedium)),
                              );
                            }).toList(),
                    onSelected: (val) async {
                      if (req && dropDownData?.first[dropDownKey] != val[dropDownKey]) {
                        field.didChange(val);
                      } else if (!req) {
                        field.didChange(val);
                      } else {
                        field.reset();
                      }
                      onSelected != null ? onSelected!(val) : null;
                    },
                    trailingIcon: const Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.black),
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    hintText: hintText,
                    errorText: field.errorText,
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black)),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextWithIconButton extends StatelessWidget {
  final bool hidden;
  final int id;
  final String? fieldName;
  final String? closeOutFieldMode;
  final String? fieldValue;
  final bool? bold;
  final String? rowColor;
  final bool multiple;
  final IconData? icon;
  final Color? iconColor;
  final void Function()? onTap;
  final bool center;

  const TextWithIconButton({
    super.key,
    this.hidden = false,
    required this.id,
    required this.fieldName,
    this.closeOutFieldMode,
    required this.fieldValue,
    this.bold,
    this.rowColor,
    required this.multiple,
    this.icon,
    this.iconColor,
    this.onTap,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return hidden
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width:
        multiple
            ? Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5
            : Get.width - 5,
        child: Wrap(
          alignment: center == true ? WrapAlignment.center : WrapAlignment.start,
          /*crossAxisAlignment: WrapCrossAlignment.center,*/
          children: [
            Text(
              "${fieldName ?? ""}${closeOutFieldMode ?? ""}${(fieldName == null || fieldName == "") && closeOutFieldMode == null ? "" : ":"} ",
              style: TextStyle(
                color:
                rowColor == "" || rowColor == null
                            ? null
                            : rowColor?.toUpperCase() == "#FFFFFF"
                    ? ColorConstants.black
                    : ColorConstants.white,
                fontSize: Theme
                    .of(context)
                    .textTheme
                    .displayMedium!
                    .fontSize! - 3,
                fontWeight: FontWeight.w600,
              ),
            ),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    fieldValue ?? "None",
                    style: TextStyle(
                      color:
                      rowColor == "" || rowColor == null
                              ? null
                              : rowColor?.toUpperCase() == "#FFFFFF"
                          ? ColorConstants.black
                          : ColorConstants.white,
                      fontSize: Theme
                          .of(context)
                          .textTheme
                          .displayMedium!
                          .fontSize! - 3,
                      fontWeight: bold != null ? FontWeight.w600 : FontWeight.normal,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: IconButton(
                      icon: Icon(icon, color: iconColor),
                      splashRadius: 20,
                      padding: const EdgeInsets.all(4.0),
                      iconSize: 25,
                      constraints: const BoxConstraints(maxHeight: 30),
                      onPressed: onTap,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class SignatureElectronicView extends StatelessWidget {
  final bool hidden;
  final int id;
  final String? nameAlign;
  final String? fieldName;
  final String? userName;
  final String? formName;
  final List? userDropDownData;
  final Map selectedUserData;
  final String? rowColor;
  final TextEditingController? controller;
  final Future<void> Function() onDialogPopUp;
  final void Function()? onTapSignForm;
  final void Function(dynamic)? onChangedUser;

  const SignatureElectronicView({
    super.key,
    this.hidden = false,
    required this.id,
    this.nameAlign,
    required this.fieldName,
    this.userName,
    this.formName,
    required this.userDropDownData,
    required this.selectedUserData,
    this.rowColor,
    this.controller,
    required this.onDialogPopUp,
    this.onTapSignForm,
    this.onChangedUser,
  });

  @override
  Widget build(BuildContext context) {
    return hidden
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 540
            ? Get.width > 1110
            ? (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  fieldName.isNotNullOrEmpty ? "${fieldName ?? ""}: " : "",
                      style: TextStyle(
                        color:
                        rowColor == "" || rowColor == null
                            ? null
                            : rowColor?.toUpperCase() == "#FFFFFF"
                            ? ColorConstants.black
                            : ColorConstants.white,
                        fontSize: Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .fontSize! - 3,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                MaterialButton(
                  shape: Border.all(color: Colors.transparent),
                  onPressed: () async {
                    await onDialogPopUp();
                    var obscureTextShow = true.obs;
                    controller?.clear();
                    DialogHelper.openCommonDialogBox(
                          title: "${UserSessionInfo.systemName} Electronic Signature",
                          message: "By Clicking Below, You Are Certifying The Form Is Accurate.",
                          centerTitle: true,
                          enableWidget: true,
                          widgetButtonTitle: "Sign Form",
                          onTap: onTapSignForm,
                          children: [
                            const Text("By Clicking Below, You Are Certifying The Form Is Accurate."),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Expanded(child: Text("Name : ")),
                                Expanded(
                                  flex: 2,
                                  child: DropdownMenu(
                                    menuHeight: Get.height - 200,
                                    textStyle: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                    trailingIcon: Icon(Icons.keyboard_arrow_down, size: 18, color: ColorConstants.black.withValues(alpha: 0.5)),
                                    expandedInsets: EdgeInsets.zero,
                                    hintText: selectedUserData["fullName"] ?? userName,
                                    inputDecorationTheme: InputDecorationTheme(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintStyle: Theme
                                          .of(Get.context!)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                      ),
                                    ),
                                    dropdownMenuEntries:
                                    userDropDownData == null
                                        ? []
                                        : userDropDownData!.map((value) {
                                      return DropdownMenuEntry<dynamic>(
                                                value: value,
                                                label: "${value["fullName"]}",
                                                style: ButtonStyle(
                                                  textStyle: WidgetStatePropertyAll(Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(fontWeight: FontWeight.normal)),
                                                ),
                                      );
                                    }).toList(),
                                    onSelected: onChangedUser,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeConstants.contentSpacing * 2),
                            Row(
                              children: [
                                const Expanded(child: Text("Password :")),
                                Expanded(
                                  flex: 2,
                                  child: FormBuilderField(
                                    name: "password",
                                    validator: FormBuilderValidators.required(errorText: "Password is Required!"),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    builder: (FormFieldState<dynamic> field) {
                                      return Obx(() {
                                        return TextField(
                                          controller: controller,
                                          cursorColor: Colors.black,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                          onChanged: (String value) {
                                            if (value != "") {
                                              field.didChange(value);
                                            } else {
                                              field.reset();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                            hintText: "Password",
                                            hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 6),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: ColorConstants.red),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                            errorText: field.errorText,
                                            suffixIcon: IconButton(
                                              splashRadius: 5,
                                              onPressed: () => obscureTextShow.value = !obscureTextShow.value,
                                              icon: Icon(size: 18, obscureTextShow.value ? Feather.eye : Feather.eye_off, color: ColorConstants.black.withValues(alpha: 0.5)),
                                            ),
                                          ),
                                          obscureText: obscureTextShow.value,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                    );
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_note,
                        color:
                        rowColor == "" || rowColor == null
                            ? null
                            : rowColor?.toUpperCase() == "#FFFFFF"
                                    ? ColorConstants.black
                                    : ColorConstants.white,
                        size: (Theme
                            .of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize)! + 4,
                      ),
                      const SizedBox(width: 3.0),
                      Text(
                        "Electronically Sign This Form",
                            style: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null
                                  : rowColor?.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                              fontSize: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 3, //fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
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
    );
  }
}

class SignaturePenView extends StatelessWidget {
  final bool hidden;
  final int id;
  final String? fieldName;
  final String? rowColor;
  final SignatureController signatureController;
  final String? signatureName;
  final String? signatureTime;

  const SignaturePenView({
    super.key,
    this.hidden = false,
    required this.id,
    required this.fieldName,
    this.rowColor,
    required this.signatureController,
    this.signatureName,
    this.signatureTime,
  });

  @override
  Widget build(BuildContext context) {
    return hidden
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width:
        Get.width > 540
                    ? Get.width > 1110
                        ? (Get.width / 2) - ((12 / 2) * 8)
                        : Get.width - 5
                    : Get.width - 5,
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              fieldName.isNotNullOrEmpty ? "${fieldName ?? ""}: " : "",
              style: TextStyle(
                color:
                rowColor == "" || rowColor == null
                    ? null
                    : rowColor?.toUpperCase() == "#FFFFFF"
                    ? ColorConstants.black
                    : ColorConstants.white,
                fontSize: Theme
                    .of(context)
                    .textTheme
                    .displayMedium!
                    .fontSize! - 3,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                Get.width > 535
                            ? Get.width > 1100
                                ? ((Get.width - 1100) / 4)
                                : ((Get.width - 535) / 2)
                    : 0.0,
              ),
              child: Material(
                shape: const RoundedRectangleBorder(side: BorderSide(color: ColorConstants.primary, width: 2)),
                child: ClipRRect(clipBehavior: Clip.hardEdge, child: Signature(controller: signatureController, backgroundColor: ColorConstants.white, height: 150)),
              ),
            ),
            Row(
              children: [
                Text(
                  "Name: ",
                  style: TextStyle(
                    color:
                    rowColor == "" || rowColor == null
                                ? null
                                : rowColor?.toUpperCase() == "#FFFFFF"
                        ? ColorConstants.black
                        : ColorConstants.white,
                    fontSize: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .fontSize! - 3,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  signatureName ?? "None Recorded",
                  style: TextStyle(
                    color:
                    rowColor == "" || rowColor == null
                                ? null
                                : rowColor?.toUpperCase() == "#FFFFFF"
                        ? ColorConstants.black
                        : ColorConstants.white,
                    fontSize: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .fontSize! - 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Date: ",
                  style: TextStyle(
                    color:
                    rowColor == "" || rowColor == null
                                ? null
                                : rowColor?.toUpperCase() == "#FFFFFF"
                        ? ColorConstants.black
                        : ColorConstants.white,
                    fontSize: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .fontSize! - 3,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  signatureTime ?? "None",
                  style: TextStyle(
                    color:
                    rowColor == "" || rowColor == null
                                ? null
                                : rowColor?.toUpperCase() == "#FFFFFF"
                        ? ColorConstants.black
                        : ColorConstants.white,
                    fontSize: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .fontSize! - 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//**************************** Start of General Fields: Text Fields || Date & Times || Check Box || Drop Downs || Hybrid/Combined ****************************
//General Fields: Text Fields || Date Times || Check Boxes || Drop Downs || Hybrid/Combined

///Title Only (default, accessoryTypeFields)
class TitleOnly extends StatelessWidget {
  final String fieldType;
  final bool? showField;
  final bool hidden;
  final int id;
  final String? nameAlign;
  final String? acronymTitle;
  final String? previousValue;
  final String? name;
  final String? rowColor;
  final String? defaultValue;

  const TitleOnly({
    super.key,
    required this.fieldType,
    this.showField,
    this.hidden = false,
    required this.id,
    this.nameAlign,
    this.acronymTitle,
    this.previousValue,
    required this.name,
    this.rowColor,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  name ?? "",
                  style: TextStyle(
                    color:
                    rowColor == "" || rowColor == null
                        ? ThemeColorMode.isLight
                        ? ColorConstants.black
                        : ColorConstants.white
                        : rowColor?.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 2,
                    fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                  ),
                ),
                if (acronymTitle != name && acronymTitle != "")
                  Tooltip(
                    message: acronymTitle ?? "",
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), child: Icon(Icons.info_outline, size: 20)),
                      ),
              ],
            ),
                if (defaultValue != null && defaultValue != "" && defaultValue != previousValue && defaultValue != "None")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                    child: Text("($defaultValue)", style: const TextStyle(color: ColorConstants.grey, fontWeight: FontWeight.w100)),
                  ),
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}

///Text Fields (textFieldStandard, textFieldExtended, numberIntegerWholeNumber, numberDecimal_1Place, numberDecimal_2Place, numberDecimal_3Place, numberDecimal_4Place,
///accessoriesSelectorCyclesAugment, accessoriesSelectorCyclesAugment, unknown, hiddenDataField, flightLogFromViaTo)
class FormTextField extends StatelessWidget {
  final String fieldType;
  final bool hidden;
  final int id;
  final bool req;
  final bool? showField;
  final String? nameAlign;
  final String? acronymTitle;
  final String? previousValue;
  final String? name;
  final String? rowColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;
  final String? maxSize;
  final bool showCounter;
  final bool disableUserEditing;
  final TextInputType? keyboardType;
  final bool? numberOnly;
  final TextInputFormatter? inputFormatter;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final String? defaultValue;
  final String? hintText;

  const FormTextField({
    super.key,
    required this.fieldType,
    this.hidden = false,
    required this.id,
    this.req = false,
    this.showField,
    this.nameAlign,
    this.acronymTitle,
    this.previousValue,
    required this.name,
    this.rowColor,
    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.maxSize,
    this.showCounter = false,
    this.disableUserEditing = false,
    this.keyboardType,
    this.numberOnly,
    this.inputFormatter,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.defaultValue,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480 && fieldType != "textFieldExtended"
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                        style: TextStyle(
                          color:
                              rowColor == "" || rowColor == null
                                  ? ThemeColorMode.isLight
                                      ? ColorConstants.black
                                      : ColorConstants.white
                                  : rowColor?.toUpperCase() == "#FFFFFF"
                                  ? ColorConstants.black
                                  : ColorConstants.white,
                          fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                        children: [
                          if (fieldType != "hiddenDataField") TextSpan(text: name ?? ""),
                          TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red)),
                        ],
                  ),
                ),
                if (acronymTitle != name && (acronymTitle ?? "") != "")
                  Tooltip(
                    message: acronymTitle ?? "",
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), child: Icon(Icons.info_outline, size: 20)),
                      ),
              ],
            ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "${name ?? "This"} field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        TextField(
                          controller: controller,
                          focusNode: focusNode,
                          readOnly: disableUserEditing,
                          cursorColor: Colors.black,
                          maxLines: maxLines,
                          maxLength: maxSize != null ? int.parse(maxSize!) : null,
                          keyboardType: keyboardType ?? ((numberOnly ?? false) ? const TextInputType.numberWithOptions(decimal: true, signed: true) : null),
                          inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
                          onTap: !disableUserEditing ? onTap : null,
                          onChanged: (String value) {
                            if (value != "") {
                              field.didChange(value);
                            } else {
                              field.reset();
                            }
                            onChanged != null ? onChanged!(value) : null;
                          },
                          onEditingComplete: onEditingComplete,
                          style: Theme
                              .of(
                            context,
                          )
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: ColorConstants.black, fontSize: (Theme
                              .of(context)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 4),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            counterText: showCounter ? null : "",
                            hintText: hintText,
                            hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                .of(context)
                                .textTheme
                                .displayMedium
                                ?.fontSize)! - 5),
                            helperText: defaultValue == null || defaultValue == "" || defaultValue == previousValue ? null : "($defaultValue)",
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null
                                  : rowColor?.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6,
                            ),
                            errorText: field.errorText,
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}

///Date Times (dateFlightDate, dateOtherDate, timeHHMM)
class FormDateTime extends StatelessWidget {
  final String fieldType;
  final bool hidden;
  final int id;
  final bool req;
  final bool? showField;
  final String? nameAlign;
  final String? acronymTitle;
  final String? previousValue;
  final String? name;
  final String? rowColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool disableUserEditing;
  final bool disableKeyboard;
  final void Function(DateTime)? onConfirm;
  final void Function()? onCancel;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? defaultValue;
  final String? hintText;
  final String? dateType;

  const FormDateTime({
    super.key,
    required this.fieldType,
    this.hidden = false,
    required this.id,
    this.req = false,
    this.showField,
    this.nameAlign,
    this.acronymTitle,
    this.previousValue,
    required this.name,
    this.rowColor,
    this.controller,
    this.focusNode,
    this.disableUserEditing = false,
    this.disableKeyboard = true,
    this.onConfirm,
    this.onCancel,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.defaultValue,
    this.hintText,
    this.dateType,
  });

  @override
  Widget build(BuildContext context) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? ThemeColorMode.isLight
                              ? ColorConstants.black
                              : ColorConstants.white
                              : rowColor?.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontSize: Theme
                              .of(context)
                              .textTheme
                              .displayMedium!
                              .fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                    children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                  ),
                ),
                if (acronymTitle != name && (acronymTitle ?? "") != "")
                  Tooltip(
                    message: acronymTitle ?? "",
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), child: Icon(Icons.info_outline, size: 20)),
                      ),
              ],
            ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "${name ?? "This"} field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    builder:
                        (FormFieldState<dynamic> field) =>
                        TextField(
                          controller: controller,
                          focusNode: focusNode,
                          readOnly: disableUserEditing ? disableUserEditing : disableKeyboard,
                          showCursor: disableUserEditing ? !disableUserEditing : !disableKeyboard,
                          cursorColor: Colors.black,
                          maxLength: fieldType == "timeHHMM" ? 5 : 10,
                          keyboardType: (disableUserEditing ? disableUserEditing : disableKeyboard) ? TextInputType.none : TextInputType.datetime,
                          inputFormatters: [
                            fieldType == "timeHHMM"
                                ? FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?:?(\d{1,2})?'))
                                : FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?/?(\d{1,2})?/?(\d{1,4})?')),
                          ],
                          onTap: () {
                            !disableUserEditing && onTap != null ? onTap!() : null;
                            if (disableKeyboard) {
                              DatePicker.showDatePicker(
                                context,
                                dateFormat: fieldType == "timeHHMM" ? "HH:mm" : "MM/dd/yyyy",
                                pickerMode: fieldType == "timeHHMM" ? DateTimePickerMode.time : DateTimePickerMode.date,
                                minDateTime:
                                fieldType == "dateFlightDate"
                                    ? dateType == "FlightDate_Older"
                                    ? DateTimeHelper.now.subtract(const Duration(days: 1460))
                                    : DateTimeHelper.now.subtract(const Duration(days: 30))
                                    : null,
                                maxDateTime: fieldType == "dateFlightDate" ? DateTimeHelper.now.add(const Duration(days: 1)) : null,
                                onConfirm: (date, list) {
                                  field.didChange(date);
                                  onConfirm != null ? onConfirm!(date) : null;
                                },
                                onCancel: onCancel,
                                initialDateTime: DateTimeHelper.now,
                                locale: DATETIME_PICKER_LOCALE_DEFAULT,
                              );
                            }
                          },
                          onChanged: (String value) {
                            if (value != "") {
                              field.didChange(value);
                            } else {
                              field.reset();
                            }
                            onChanged != null ? onChanged!(value) : null;
                          },
                          onEditingComplete: onEditingComplete,
                          style: Theme
                              .of(
                            context,
                          )
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: ColorConstants.black, fontSize: (Theme
                              .of(context)
                              .textTheme
                              .displayMedium
                              ?.fontSize)! - 4),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            counterText: "",
                            hintText: hintText ?? (fieldType == "timeHHMM" ? "hh:mm" : "mm/dd/yyyy"),
                            hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme
                                .of(context)
                                .textTheme
                                .displayMedium
                                ?.fontSize)! - 5),
                            helperText: defaultValue == null || defaultValue == "" || defaultValue == "1900-01-01" || defaultValue == previousValue ? null : "($defaultValue)",
                            helperStyle: TextStyle(
                              color:
                              rowColor == "" || rowColor == null
                                  ? null
                                  : rowColor?.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .fontSize! - 6,
                            ),
                            errorText: field.errorText,
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 6),
                            border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                        ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}

///Check Boxes (checkBoxYesNo, faaLaserStrikeReporting)
class FormCheckBox extends StatelessWidget {
  final String fieldType;
  final bool hidden;
  final int id;
  final bool req;
  final bool? showField;
  final String? nameAlign;
  final String? acronymTitle;
  final String? previousValue;
  final String? name;
  final String? rowColor;
  final bool disableUserEditing;
  final void Function(bool?)? onChanged;
  final String? defaultValue;
  final bool? currentValue;
  final bool multiple;

  const FormCheckBox({
    super.key,
    required this.fieldType,
    this.hidden = false,
    required this.id,
    this.req = false,
    this.showField,
    this.nameAlign,
    this.acronymTitle,
    this.previousValue,
    required this.name,
    this.rowColor,
    this.disableUserEditing = false,
    this.onChanged,
    this.defaultValue,
    this.currentValue,
    this.multiple = false,
  });

  @override
  Widget build(BuildContext context) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width:
        multiple
            ? Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5
            : Get.width - 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                        textScaler: TextScaler.linear(Get.textScaleFactor),
                        text: TextSpan(
                          style: TextStyle(
                            color:
                            rowColor == "" || rowColor == null
                                    ? ThemeColorMode.isLight
                                        ? ColorConstants.black
                                        : ColorConstants.white
                                    : rowColor?.toUpperCase() == "#FFFFFF"
                                ? ColorConstants.black
                                : ColorConstants.white,
                            fontSize: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .fontSize! - 2,
                            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                          ),
                          children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red)), const TextSpan(text: ":")],
                        ),
                  ),
                ),
                if (acronymTitle != name && (acronymTitle ?? "") != "")
                  Tooltip(
                    message: acronymTitle ?? "",
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), child: Icon(Icons.info_outline, size: 20)),
                  ),
                FormBuilderField(
                  name: "$id",
                  validator: req ? FormBuilderValidators.required(errorText: "${name ?? "This"} field is required.") : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder:
                      (FormFieldState<dynamic> field) =>
                      Checkbox(
                        activeColor: ColorConstants.primary,
                        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return ColorConstants.grey;
                          } else if (states.contains(WidgetState.disabled)) {
                            return Colors.grey.shade300;
                          }
                          return ColorConstants.white;
                        }),
                        side: const BorderSide(color: ColorConstants.grey, width: 1.5),
                        value: disableUserEditing ? defaultValue?.toLowerCase() == "checked" : currentValue,
                        onChanged: !disableUserEditing ? onChanged : null,
                      ),
                ),
              ],
            ),
                defaultValue == null || defaultValue == "" || defaultValue == previousValue
                    ? const SizedBox(height: 2)
                    : Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "($defaultValue)",
                    style: TextStyle(
                      color:
                      rowColor == "" || rowColor == null
                                  ? ColorConstants.grey
                                  : rowColor?.toUpperCase() == "#FFFFFF"
                          ? ColorConstants.black
                          : ColorConstants.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}

///Drop Downs (default, dropDownAccessibleAircraft, dropDownAllUsers, dropDownNumbers0_50, dropDownNumbers0_100, dropDownNumbers0_150, dropDownCustomers, accessoriesSelector,
///dropDownForTriggeredFieldsOnly, dropDownUR, dropDownFormChooser)
class FormDropDown extends StatelessWidget {
  final String fieldType;
  final bool hidden;
  final int id;
  final bool req;
  final bool? showField;
  final String? nameAlign;
  final String? acronymTitle;
  final String? previousValue;
  final String? name;
  final String? rowColor;
  final bool disableUserEditing;
  final String? selectedValue;
  final List? dropDownData;
  final String dropDownKey;
  final void Function(dynamic)? onChanged;
  final String? defaultValue;

  ///Use on element type select
  const FormDropDown({
    super.key,
    required this.fieldType,
    this.hidden = false,
    required this.id,
    this.req = false,
    this.showField,
    this.nameAlign,
    this.acronymTitle,
    this.previousValue,
    required this.name,
    this.rowColor,
    this.disableUserEditing = false,
    this.selectedValue,
    required this.dropDownData,
    required this.dropDownKey,
    this.onChanged,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return showField ?? !hidden
        ? Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 2.0, right: 2.0),
      child: SizedBox(
        width:
        Get.width > 480
            ? Get.width > 980
            ? (Get.width / 3) - ((12 / 3) * 9)
            : (Get.width / 2) - ((12 / 2) * 8)
            : Get.width - 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: nameAlign == "R" ? WrapAlignment.end : WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                        style: TextStyle(
                          color:
                          rowColor == "" || rowColor == null
                              ? ThemeColorMode.isLight
                              ? ColorConstants.black
                              : ColorConstants.white
                              : rowColor?.toUpperCase() == "#FFFFFF"
                              ? ColorConstants.black
                              : ColorConstants.white,
                          fontSize: Theme
                              .of(context)
                              .textTheme
                              .displayMedium!
                              .fontSize! - 2,
                          fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.4),
                        ),
                    children: [TextSpan(text: name ?? ""), TextSpan(text: req ? " *" : "", style: const TextStyle(color: ColorConstants.red))],
                  ),
                ),
                if (acronymTitle != name && (acronymTitle ?? "") != "")
                  Tooltip(
                    message: acronymTitle ?? "",
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), child: Icon(Icons.info_outline, size: 20)),
                      ),
              ],
            ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FormBuilderField(
                    name: "$id",
                    validator: req ? FormBuilderValidators.required(errorText: "${name ?? "This"} field is required.") : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    builder:
                        (FormFieldState<dynamic> field) => DropdownMenu(
                          enableFilter: false,
                          enabled: !disableUserEditing,
                          menuHeight: Get.height - 200,
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries:
                              dropDownData == null
                                  ? []
                                  : dropDownData!.map((value) {
                                    return DropdownMenuEntry<dynamic>(
                                      value: value,
                                      label: "${value[dropDownKey]}",
                                      style: ButtonStyle(
                                        textStyle: WidgetStatePropertyAll(
                                          TextStyle(color: ColorConstants.black, fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 4),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                          onSelected: (value) {
                            field.didChange(value);
                            onChanged != null ? onChanged!(value) : null;
                          },
                          trailingIcon: Icon(Icons.keyboard_arrow_down, size: 30, color: disableUserEditing ? null : ColorConstants.black),
                          textStyle: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 4),
                          hintText:
                              disableUserEditing
                                  ? defaultValue ?? ((dropDownData ?? []).isNotEmpty ? (dropDownData?.first[dropDownKey] ?? "") : "")
                                  : selectedValue ?? ((dropDownData ?? []).isNotEmpty ? (dropDownData?.first[dropDownKey] ?? "") : ""),
                          helperText:
                              defaultValue == null || defaultValue == "" || defaultValue == "0" || defaultValue == "0.0" || defaultValue == "None" || defaultValue == previousValue
                                  ? null
                                  : "($defaultValue)",
                          errorText: field.errorText,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: !disableUserEditing ? Colors.white : Colors.grey[350],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                            hintStyle: TextStyle(color: ColorConstants.black, fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 4),
                            helperStyle: TextStyle(
                              color:
                                  rowColor == "" || rowColor == null
                                      ? null
                                      : rowColor?.toUpperCase() == "#FFFFFF"
                                      ? ColorConstants.black
                                      : ColorConstants.white,
                              fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 6,
                            ),
                            errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 6),
                            border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.black),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: ColorConstants.red),
                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}
