import 'dart:ui';

import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class PartsRequestWidgets {
  static customDropDownWidgetNew(
      {bool showTitle = true,
      String? title,
      bool titleStyle = false,
      bool isDiscrepancy = false,
      required BuildContext context,
      bool needValidation = false,
      String? hintText,
      String? helperText,
      Color? helperColor,
      bool borderColor = false,
      bool disableEditing = false,
      required List? data,
      String? key,
      double hintTextFontSize = 3.0,
      double itemTextHeight = 3.0,
      Color? fillColor,
      BoxConstraints? constraints,
      void Function(dynamic value)? onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (showTitle)
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text("$title",
              style: titleStyle
                  ? isDiscrepancy
                      ? TextStyle(fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.bold)
                      : TextStyle(fontSize: Theme.of(context).textTheme.titleLarge!.fontSize, fontWeight: FontWeight.bold)
                  : TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3)),
        ),
      FormField(
        validator: needValidation ? FormBuilderValidators.required(errorText: "$title field is required.") : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<dynamic> field) => DropdownMenu(
            hintText: "$hintText",
            helperText: helperText,
            errorText: field.errorText,
            enabled: !disableEditing,
            menuHeight: Get.height - 200,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - hintTextFontSize,
                  color: ColorConstants.black,
                  fontWeight: FontWeight.w500,
                ),
            trailingIcon: Icon(Icons.keyboard_arrow_down, size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 10, color: ColorConstants.black),
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: disableEditing == false ? fillColor ?? Colors.white : Colors.grey[350],
              contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0, top: 18.0, bottom: 18.0),
              constraints: constraints,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - hintTextFontSize, color: ColorConstants.black, fontWeight: FontWeight.w500),
              helperStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 5, color: helperColor, fontWeight: FontWeight.w100),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor != true ? (ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : ColorConstants.red),
                  borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor != true ? (ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : ColorConstants.red),
                  borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor != true ? (ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : ColorConstants.red),
                  borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
            ),
            dropdownMenuEntries: data == null
                ? []
                : data.map((value) {
                    return DropdownMenuEntry<dynamic>(
                      value: value,
                      label: "${value[key]}",
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(textColorReturn(value: value[key])),
                          textStyle: WidgetStateProperty.all(Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - itemTextHeight, fontWeight: FontWeight.w500))),
                    );
                  }).toList(),
            onSelected: (val) {
              field.didChange(val);
              onChanged != null ? onChanged(val) : null;
            }),
      )

      //Use DropdownButton instead of DropdownMenu, it has some issues regarding animation flicking.
      // Try to avoid DropdownMenu and replace with DropdownButton
      //Make this DropdownButton as Like previous DropdownMenu design
    ]);
  }

  static textWidget({String? title, Color? color, FontWeight fontWeight = FontWeight.bold}) {
    return Text(
      "$title",
      style: TextStyle(color: color, fontWeight: fontWeight),
    );
  }

  static largeTextWidget({String? title, Color? color, FontWeight fontWeight = FontWeight.bold}) {
    return Text(
      "$title",
      style: TextStyle(color: color, fontWeight: fontWeight, fontSize: Theme.of(Get.context!).textTheme.bodyLarge?.fontSize),
    );
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

  static headerText({String? title}) {
    return Text(
      title.toString(),
      style: const TextStyle(color: ColorConstants.white, fontWeight: FontWeight.bold),
    );
  }

  static tableCellText({String? title}) {
    return Text(
      title.toString(),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  static prDynamicTextField(
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
        if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor))),
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

  static prDynamicDropDown(
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
        if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor))),
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
                enableSearch: false,
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

  static prDynamicDropDown1(
      {bool? req,
      bool? expands,
      String? title,
      Color? titleColor = ColorConstants.black,
      String? hintText,
      required RxList? data,
      String? dropDownKey,
      GlobalKey<FormFieldState>? dropDownValidationKey,
      String? validatorKeyName,
      Color? fillColor,
      TextEditingController? dropDownController,
      void Function(dynamic)? onSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor))),
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
                enableSearch: false,
                errorText: field.errorText,
                menuHeight: Get.height - 200,
                textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
                trailingIcon: Icon(Icons.keyboard_arrow_down, size: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize! + 10, color: ColorConstants.black),
                expandedInsets: expands == true ? EdgeInsets.zero : null,
                inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    filled: true,
                    fillColor: fillColor,
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
                            backgroundColor: WidgetStateProperty.all(textColorReturn(value: value[dropDownKey])),
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

  static showSnackBar(
      {required BuildContext context,
      required Widget snackBarContent,
      String? actionLevel,
      required Function onPressed,
      Color? backgroundColor,
      Duration duration = const Duration(milliseconds: 4000)}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: snackBarContent,
      action: SnackBarAction(
        label: "$actionLevel",
        disabledTextColor: ColorConstants.white,
        textColor: ColorConstants.white,
        onPressed: () => onPressed,
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10.0),
    ));
  }

  static SnackbarController openSnackBar({String? title, String? message, bool isError = false}) {
    return Get.rawSnackbar(
      titleText: title != null
          ? Text(
              title,
              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                    fontSize: double.parse(12.toString()),
                    color: ColorConstants.white,
                  ),
            )
          : const SizedBox(),
      messageText: message != null
          ? Text(
              message,
              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                    fontSize: double.parse(17.toString()),
                    color: ColorConstants.white,
                  ),
            )
          : const SizedBox(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? ColorConstants.red : ColorConstants.primary,
    );
  }

  static textColorReturn({String? value}) {
    switch (value) {
      case "User Entry":
        return ColorConstants.primary;
      case "Processing":
        return ColorConstants.yellow;
      case "Obtaining Quotes":
        return ColorConstants.yellow;
      case "Waiting Approval":
        return ColorConstants.yellow;
      case "Waiting PO":
        return ColorConstants.yellow;
      case "Needs Payment":
        return null; //ColorConstants.WHITE;
      case "Part Ordered":
        return ColorConstants.primary;
      case "Awaiting Shipment":
        return ColorConstants.primary.withValues(alpha: 0.6);
      case "Part Received":
        return ColorConstants.primary;
      case "Completed":
        return ColorConstants.button;
      case "Cancelled":
        return ColorConstants.red;
      case "Deleted":
        return null; //ColorConstants.WHITE;
      default:
        return null; //ColorConstants.WHITE;
    }
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
      Color color = ColorConstants.primary,
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

  static partsRequestDialog(
      {String? dialogTitle, Color? titleColor, List<Widget> children = const <Widget>[], List<Widget> actionWidget = const <Widget>[], bool barrierDismissible = true}) {
    return showDialog(
      context: Get.context!,
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
              ),
              title: Text(dialogTitle ?? "", textAlign: TextAlign.center),
              titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: titleColor ?? ColorConstants.primary, fontWeight: FontWeight.bold),
              titlePadding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
              contentTextStyle: Theme.of(context).textTheme.bodyMedium,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              actions: actionWidget,
              scrollable: true,
            ));
      },
    );
  }
}
