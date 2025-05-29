import 'dart:ui';

import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';
import '../shared/services/keyboard.dart';
import '../shared/services/theme_color_mode.dart';

abstract class RiskAssessmentWidgets {
  static raDynamicTextField(
      {bool? req,
      int? maxLines,
      bool? fieldEnabled,
      String? title,
      Color? titleColor,
      String? hintText,
      GlobalKey<FormFieldState>? textFieldValidationKey,
      String? validatorKeyName,
      TextEditingController? textFieldController,
      void Function(String value)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null) Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(title, style: TextStyle(color: titleColor))),
        FormBuilderField(
          key: textFieldValidationKey,
          name: validatorKeyName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
          validator: req == true ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "${title ?? ""} Field is Required!")]) : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => TextField(
              controller: textFieldController,
              cursorColor: Colors.black,
              maxLines: maxLines,
              enabled: fieldEnabled,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
              decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: fieldEnabled == false ? Colors.grey[400] : Colors.white,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: field.errorText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black))),
              onChanged: (String value) {
                if (value != "") {
                  field.didChange(value);
                } else {
                  field.reset();
                }
                if (onChanged != null) {
                  onChanged(value);
                }
              }),
        ),
      ]),
    );
  }

  static raDynamicDropDown(
      {bool? req,
      bool? expands,
      String? title,
      Color? titleColor,
      String? hintText,
      String? errorText,
      required RxList? dropDownData,
      required String dropDownKey,
      GlobalKey<FormFieldState>? dropDownValidationKey,
      String? validatorKeyName,
      TextEditingController? dropDownController,
      void Function(dynamic value)? onSelected}) {
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
                initialSelection: (dropDownData ?? []).isNotEmpty
                    ? dropDownData
                        ?.cast<Map<String, dynamic>>()
                        .firstWhere((element) => element[dropDownKey] == (hintText ?? dropDownController?.text), orElse: () => dropDownData.first)
                    : null,
                hintText: hintText,
                errorText: (errorText ?? "").isNotEmpty ? errorText : field.errorText,
                menuHeight: Get.height - 200,
                textStyle: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
                trailingIcon: Icon(Icons.keyboard_arrow_down, size: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize! + 10, color: ColorConstants.black),
                expandedInsets: expands == true ? EdgeInsets.zero : null,
                inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black))),
                dropdownMenuEntries: dropDownData == null
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
                });
          }),
        ),
      ]),
    );
  }

  static raSwitch({String? title, Color? titleColor, required bool switchValue, void Function(bool value)? onChanged}) {
    return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (title != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0), child: Text(title, style: TextStyle(color: titleColor))),
      Switch(value: switchValue, activeTrackColor: ColorConstants.button.withValues(alpha: 0.4), activeColor: ColorConstants.button, onChanged: onChanged),
    ]);
  }

  static raButtonWithIcon(
      {IconData? icon, Color? iconColor, String? title, Color? titleColor, FontWeight? fontWeight, Color? buttonColor, Color? borderColor, void Function()? onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor,
      disabledColor: Colors.grey[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        if (icon != null)
          Padding(padding: title != null ? const EdgeInsets.only(right: 5.0) : const EdgeInsets.all(0.0), child: Icon(icon, color: iconColor ?? ColorConstants.white, size: 20.0)),
        if (title != null)
          Text(title, style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: titleColor ?? ColorConstants.white, fontWeight: fontWeight ?? FontWeight.bold))
      ]),
    );
  }

  static createNewRiskAssessmentDialog(
      {required Widget child,
      void Function()? onConfirmButton,
      String? topDialogTitle,
      void Function()? onCancelButton,
      String cancelButtonTitle = "Cancel",
      Color? cancelButtonTitleColor,
      String? confirmButtonTitle,
      Color cancelButtonColor = ColorConstants.white,
      String? dialogTitle,
      bool centerTitle = false}) {
    return showDialog(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            alignment: Alignment.center,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
              side: const BorderSide(color: ColorConstants.primary, width: 2),
            ),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  Keyboard.close(context: context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                  child: Column(children: [
                    if (topDialogTitle != null) TextWidget(text: topDialogTitle.toString(), color: ColorConstants.primary, weight: FontWeight.bold),
                    if (topDialogTitle != null) const SizedBox(height: 5),
                    if (dialogTitle != null)
                      centerTitle
                          ? Center(child: TextWidget(text: dialogTitle.toString(), color: ColorConstants.primary, weight: FontWeight.bold))
                          : TextWidget(text: dialogTitle.toString(), color: ColorConstants.primary, weight: FontWeight.bold),
                    if (dialogTitle != null) const SizedBox(height: 8),
                    child,
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      RiskAssessmentWidgets.riskAssessmentDialogButton(
                        title: confirmButtonTitle.toString(),
                        btnColor: ColorConstants.primary,
                        onTapMethod: onConfirmButton,
                        titleColor: ColorConstants.white,
                      ),
                      const SizedBox(width: 5.0),
                      RiskAssessmentWidgets.riskAssessmentDialogButton(
                        title: cancelButtonTitle.toString(),
                        btnColor: cancelButtonColor,
                        onTapMethod: onCancelButton,
                        borderColor: ColorConstants.black,
                        titleColor: cancelButtonTitleColor,
                      ),
                    ])
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static riskAssessmentDialog({
    BuildContext? context,
    String? dialogTitle,
    Color? titleColor,
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
    return showDialog(
        context: context ?? Get.context!,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                    side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                  ),
                  title: Text(dialogTitle ?? "", textAlign: TextAlign.center),
                  titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: titleColor ?? ColorConstants.primary, fontWeight: FontWeight.bold),
                  titlePadding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  content: GestureDetector(
                    onTap: () => Keyboard.close(context: context),
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
                    ),
                  ),
                  contentTextStyle: Theme.of(context).textTheme.bodyMedium,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  actions: [
                    if (deleteButtonTitle != null)
                      Obx(() {
                        return raButtonWithIcon(
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
                            });
                      }),
                    if (actionButtonTitle != null)
                      raButtonWithIcon(
                          title: actionButtonTitle,
                          titleColor: actionButtonTitleColor ?? ColorConstants.white,
                          icon: actionButtonIcon ?? Icons.check_circle_outline,
                          iconColor: actionButtonIconColor ?? actionButtonTitleColor ?? ColorConstants.white,
                          buttonColor: actionButtonColor ?? ColorConstants.primary,
                          borderColor: actionButtonBorderColor ?? ColorConstants.primary,
                          onPressed: onActionButton),
                    raButtonWithIcon(
                        title: cancelButtonTitle ?? "Cancel",
                        titleColor: cancelButtonTitleColor ?? ColorConstants.black,
                        icon: cancelButtonIcon ?? Icons.cancel_outlined,
                        iconColor: cancelButtonIconColor ?? cancelButtonTitleColor ?? ColorConstants.black,
                        buttonColor: cancelButtonColor ?? ColorConstants.white,
                        borderColor: cancelButtonBorderColor ?? ColorConstants.black,
                        onPressed: () {
                          Get.back();
                          if (onCancelButton != null) {
                            onCancelButton;
                          }
                        }),
                  ]),
            ));
  }

  static riskAssessmentDialogButton({void Function()? onTapMethod, String? title, Color? titleColor, Color? btnColor, Color borderColor = Colors.transparent}) {
    return Material(
        color: btnColor,
        elevation: 10,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: onTapMethod,
          borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: TextWidget(text: title.toString(), textAlign: TextAlign.center, color: titleColor),
          ),
        ));
  }

  static riskAssessmentIndexTextButton({void Function()? onPressed, String? title, IconData? icon, Color? backgroundColor, Color? iconColor}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, elevation: 4.0, padding: const EdgeInsets.symmetric(horizontal: 5.0)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          TextWidget(
            color: ColorConstants.white,
            text: title.toString(),
            textAlign: TextAlign.center,
            size: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
