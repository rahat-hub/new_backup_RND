import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';

class HelpDeskWidgets {
  static textWidget({String? title, Color? color, FontWeight? fontWeight = FontWeight.bold, TextAlign? textAlign}) {
    return Text("$title", textAlign: textAlign, style: TextStyle(color: color, fontWeight: fontWeight));
  }

  static largeTextWidget({String? title, Color? color, FontWeight fontWeight = FontWeight.bold}) {
    return Text("$title", style: TextStyle(color: color, fontWeight: fontWeight, fontSize: Theme.of(Get.context!).textTheme.bodyLarge?.fontSize));
  }

  static tableText(
      {String? title,
      Color? color,
      TextAlign textAlign = TextAlign.center,
      FontWeight? fontWeight,
      TextDecoration? textDecoration,
      TextDecorationStyle? textDecorationStyle,
      double? decorationThickness}) {
    return Text(
      "$title",
      style: TextStyle(
          color: color,
          fontSize: Theme.of(Get.context!).textTheme.bodyMedium?.fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration,
          decorationStyle: textDecorationStyle,
          decorationThickness: textDecoration != null ? decorationThickness : null),
      textAlign: textAlign,
    );
  }

  static textWithIcon({IconData? icon, Color? iconColor, double? iconSize, String? title, FontWeight? fontWeight, Color? textColor, double? textSize}) {
    return Row(spacing: 5.0, mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...{Icon(icon, color: iconColor, size: iconSize)},
      Flexible(child: Text(title ?? "", style: TextStyle(fontWeight: fontWeight, color: textColor, fontSize: textSize)))
    ]);
  }

  static hpdDynamicText(
      {String? title,
      Color? titleColor,
      IconData? icon1,
      Color? icon1Color,
      FontWeight? titleFontWeight,
      String? text,
      Color? textColor,
      IconData? icon2,
      Color? icon2Color,
      FontWeight? textFontWeight,
      bool expanded = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(spacing: !expanded ? 5.0 : 0.0, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Flexible(
            fit: expanded ? FlexFit.tight : FlexFit.loose,
            child: textWithIcon(title: title, textColor: titleColor, icon: icon1, iconColor: icon1Color, fontWeight: titleFontWeight)),
        Expanded(flex: 2, child: textWithIcon(title: text, textColor: textColor, icon: icon2, iconColor: icon2Color, fontWeight: textFontWeight))
      ]),
    );
  }

  static buttonWidgetSingleDynamicWidthWithIcon(
      {void Function()? onTap,
      String? title,
      bool isLoadingLoggingIn = false,
      IconData? icon,
      bool iconShow = false,
      bool centerTitle = false,
      Color? iconColor,
      Color? titleColor,
      Color? color = ColorConstants.primary,
      bool isBorder = true}) {
    return Material(
      color: color,
      elevation: 4.0,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConstants.buttonRadius), borderSide: isBorder ? const BorderSide(color: ColorConstants.black, width: 1.0) : BorderSide.none),
      child: InkWell(
        borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (iconShow)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: Theme.of(Get.context!).textTheme.displayMedium!.fontSize,
                  ),
                ),
              !isLoadingLoggingIn
                  ? Flexible(
                      child: Text(
                        title ?? "",
                        style: Theme.of(Get.context!)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: Theme.of(Get.context!).textTheme.bodyMedium?.fontSize, color: titleColor, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                      ),
                    )
                  : const CupertinoActivityIndicator(
                      color: Colors.white,
                      animating: true,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  static openDialogBox({String? dialogTitle, Widget? child, List<Widget> row = const <Widget>[]}) {
    return showDialog(
      context: Get.context!,
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                side: const BorderSide(color: ColorConstants.primary, width: 2),
              ),
              titlePadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 2.5),
              title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 6.0), child: largeTextWidget(title: dialogTitle ?? "", fontWeight: FontWeight.bold, color: ColorConstants.black))),
                MaterialButton(
                  onPressed: () => Get.back(),
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                  elevation: 5.0,
                  color: ColorConstants.white,
                  visualDensity: VisualDensity.comfortable,
                  height: 40.0,
                  minWidth: 50.0,
                  child: const Icon(Icons.cancel_rounded, size: 25, color: ColorConstants.red),
                ),
              ]),
              contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.5),
              content: SingleChildScrollView(child: child),
              actionsOverflowButtonSpacing: 8.0,
              actions: row),
        );
      },
    );
  }

  static hpdDynamicTextField(
      {bool? req,
      int? maxLines,
      bool? fieldEnabled,
      String? title,
      Color? titleColor,
      String? hintText,
      GlobalKey<FormFieldState>? textFieldValidationKey,
      String? validatorKeyName,
      String? helperText,
      TextStyle? helperTextStyle,
      TextEditingController? textFieldController,
      void Function()? onEditingComplete,
      void Function(String value)? onSubmitted,
      void Function(PointerDownEvent value)? onTapOutside,
      void Function()? onTap,
      int? maxCharacter,
      FocusNode? focusNode,
      TextInputType? textInputType,
      TextInputAction? textInputAction,
      String customErrorTitle = "Field is Required!",
      bool showCursor = true,
      bool readOnly = false,
      void Function(String value)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold))),
        FormBuilderField(
          key: textFieldValidationKey,
          name: validatorKeyName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
          validator: req == true ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "${title ?? ""} $customErrorTitle")]) : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => TextField(
            controller: textFieldController,
            cursorColor: Colors.black,
            maxLines: maxLines,
            maxLength: maxCharacter,
            enabled: fieldEnabled,
            style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: fieldEnabled == false ? Colors.grey[400] : Colors.white,
                hintText: hintText,
                hintStyle: TextStyle(color: ColorConstants.black.withValues(alpha: 0.5)),
                errorText: field.errorText,
                helperText: helperText,
                helperStyle: helperTextStyle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black))),
            readOnly: readOnly,
            showCursor: showCursor,
            focusNode: focusNode,
            keyboardType: !showCursor ? TextInputType.none : textInputType,
            textInputAction: textInputAction,
            onChanged: (String value) {
              if (value != "") {
                field.didChange(value);
              } else {
                field.reset();
              }
              if (onChanged != null) {
                onChanged(value);
              }
            },
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            onTapOutside: onTapOutside,
            onTap: onTap,
          ),
        ),
      ]),
    );
  }

  static hpdDynamicDropDown(
      {bool? req,
      bool? expands,
      String? title,
      Color? titleColor = ColorConstants.black,
      String? hintText,
      required RxList? data,
      String? dropDownKey,
      GlobalKey<FormFieldState>? dropDownValidationKey,
      String? validatorKeyName,
      TextEditingController? dropDownController,
      void Function(dynamic)? onSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold))),
        FormBuilderField(
          key: dropDownValidationKey,
          name: validatorKeyName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "drop_down",
          validator: req == true ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "${title ?? ""} Field is Required!")]) : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Obx(() {
            return DropdownMenu(
                controller: dropDownController,
                hintText: hintText,
                enableFilter: false,
                errorText: field.errorText,
                menuHeight: Get.height - 200,
                textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
                trailingIcon: Icon(Icons.keyboard_arrow_down, size: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize! + 10, color: ColorConstants.black),
                expandedInsets: expands == true ? EdgeInsets.zero : null,
                inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(color: ColorConstants.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black))),
                dropdownMenuEntries: data == null
                    ? []
                    : data.map((value) {
                        return DropdownMenuEntry<dynamic>(
                          value: value,
                          label: "${value[dropDownKey]}",
                          style: ButtonStyle(
                            textStyle: WidgetStateProperty.all(Theme.of(Get.context!).textTheme.bodyMedium),
                          ),
                        );
                      }).toList(),
                onSelected: (val) {
                  if (data != null && (data[0][dropDownKey] != val[dropDownKey])) {
                    field.didChange(val);
                  } else {
                    field.reset();
                  }
                  if (onSelected != null) {
                    onSelected(val);
                  }
                });
          }),
        ),
      ]),
    );
  }
}
