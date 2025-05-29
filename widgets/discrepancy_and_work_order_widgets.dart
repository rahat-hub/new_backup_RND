import 'dart:ui';

import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';
import '../shared/services/theme_color_mode.dart';

class DiscrepancyAndWorkOrdersMaterialButton extends StatelessWidget {
  final String? buttonText;
  final double? buttonTextSize;
  final Color? buttonTextColor;
  final Color? buttonColor;
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final double? lrPadding;
  final bool fixedButtonSizeEnable;
  final double? fixedButtonSize;
  final void Function()? onPressed;

  final double? buttonHeight;

  const DiscrepancyAndWorkOrdersMaterialButton({
    super.key,
    this.buttonText,
    this.buttonTextSize,
    this.buttonTextColor,
    this.buttonColor,
    this.borderColor,
    this.icon,
    this.fixedButtonSizeEnable = false,
    this.fixedButtonSize,
    this.iconColor,
    this.lrPadding,
    this.onPressed,
    this.buttonHeight
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
        disabledColor: buttonColor,
        height: buttonHeight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none),
        child: SizedBox(
          width: fixedButtonSizeEnable ? fixedButtonSize : null,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 3.0,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: iconColor ?? ((buttonColor == null || buttonColor == ColorConstants.white) ? ColorConstants.primary : ColorConstants.white),
                  size: Theme.of(context).textTheme.displayMedium!.fontSize! + 3,
                ),
              TextWidget(
                text: buttonText ?? "",
                color: buttonTextColor ?? ((buttonColor == null || buttonColor == ColorConstants.white) ? ColorConstants.primary : ColorConstants.white),
                weight: FontWeight.w700,
                size: buttonTextSize ?? Theme.of(context).textTheme.headlineMedium?.fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscrepancyAndWorkOrdersDropDown extends StatelessWidget {
  final bool req;
  final String? validatorKeyName;
  final GlobalKey<FormFieldState>? validationKey;
  final String? fieldName;
  final String? hintText;
  final TextEditingController dropDownController;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool expands;
  final List? dropDownData;
  final bool statusEnable;
  final bool? completeColor;
  final String dropDownKey;
  final double? textFieldWidth;
  final void Function(Map value)? onChanged;
  final void Function(Map value)? initialValue;

  ///Use on element type select
  const DiscrepancyAndWorkOrdersDropDown({
    super.key,
    this.req = false,
    this.validatorKeyName,
    this.validationKey,
    this.fieldName,
    this.hintText,
    required this.dropDownController,
    this.focusNode,
    this.readOnly = false,
    this.expands = false,
    this.statusEnable = false,
    this.completeColor = false,
    required this.dropDownData,
    required this.dropDownKey,
    this.textFieldWidth,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    initialValue?.call(dropDownData?.first);

    colorReturn({String? value}) {
      switch (value) {
        case 'AOG / OOS':
          return Colors.red;
        case 'In Service':
          return Colors.lightGreen;
        case 'Parts On Order':
          return Colors.yellowAccent;
        case 'Limited Mission' || 'In Progress':
          return Colors.yellow;
        case 'Completed':
          return Colors.lightGreen;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((fieldName != null && fieldName != "") || req)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              // child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              child: RichText(
                textScaler: TextScaler.linear(Get.textScaleFactor),
                text: TextSpan(
                  text: fieldName ?? "",
                  style: TextStyle(
                    color: ThemeColorMode.isLight ? Colors.black : Colors.white,
                    fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  children: <TextSpan>[req ? const TextSpan(text: " *", style: TextStyle(color: Colors.red)) : const TextSpan()],
                ),
              ),
            ),
          Padding(
            padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
            child: FormBuilderField(
              key: validationKey,
              name: validatorKeyName ?? fieldName?.toLowerCase().replaceAll(" ", "_") ?? "drop_down",
              validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder:
                  (FormFieldState<dynamic> field) => DropdownMenu(
                    controller: dropDownController,
                    focusNode: focusNode,
                    enabled: !readOnly,
                    enableFilter: false,
                    menuHeight: Get.height - 200,
                    expandedInsets: expands ? EdgeInsets.zero : null,
                    dropdownMenuEntries:
                        dropDownData == null
                            ? [const DropdownMenuEntry(value: {}, label: "")]
                            : dropDownData!.map((value) {
                              return DropdownMenuEntry<Map>(
                                value: value,
                                label: "${value[dropDownKey]}".trim(),
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                                  backgroundColor: statusEnable ? WidgetStateProperty.all(colorReturn(value: value[dropDownKey])) : null,
                                ),
                              );
                            }).toList(),
                    onSelected: (value) {
                      if (req && dropDownData?.first[dropDownKey] != value?[dropDownKey]) {
                        field.didChange(value);
                      } else if (!req) {
                        field.didChange(value);
                      } else {
                        field.reset();
                      }
                      onChanged != null ? onChanged!(value ?? {}) : null;
                    },
                    trailingIcon: const Icon(Icons.keyboard_arrow_down, size: 28, color: ColorConstants.black),
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                    hintText: hintText ?? ((dropDownData ?? []).isNotEmpty ? (dropDownData?.first[dropDownKey] ?? "") : ""),
                    errorText: field.errorText,
                    inputDecorationTheme: InputDecorationTheme(
                      constraints: BoxConstraints(maxWidth: textFieldWidth ?? double.infinity),
                      isDense: true,
                      filled: true,
                      fillColor:
                          statusEnable
                              ? completeColor != true
                                  ? ColorConstants.white
                                  : ColorConstants.button
                              : readOnly
                              ? Colors.grey[200]
                              : Colors.white,
                      hintStyle: TextStyle(color: readOnly ? ColorConstants.grey : ColorConstants.black),
                      errorStyle: const TextStyle(color: ColorConstants.red),
                      border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
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

// class DiscrepancyDateTime extends StatelessWidget {
//   final String? fieldType;
//   final bool req;
//   final GlobalKey<FormFieldState>? validationKey;
//   final bool showField;
//   final String? fieldName;
//   final TextEditingController dateTimeController;
//   final bool isDense;
//   final bool readOnly;
//   final RxBool disableKeyboard;
//   final String? hintText;
//   final String? dateType;
//   final bool showCounter;
//   final void Function(DateTime dateTime)? onConfirm;
//   final void Function()? onCancel;
//   final void Function()? onTap;
//   final void Function(String value)? onChanged;
//   final void Function()? onEditingComplete;
//   final String Function(String value)? initialValue;
//
//   ///Use on element type dateTime
//   const DiscrepancyDateTime(
//       {super.key,
//       this.fieldType,
//       this.req = false,
//       this.validationKey,
//       this.showField = true,
//       this.fieldName,
//       this.readOnly = false,
//       required this.dateTimeController,
//       this.isDense = false,
//       required this.disableKeyboard,
//       this.hintText,
//       this.dateType,
//       this.showCounter = false,
//       this.onConfirm,
//       this.onCancel,
//       this.onTap,
//       this.onChanged,
//       this.onEditingComplete,
//       this.initialValue});
//
//   @override
//   Widget build(BuildContext context) {
//     return showField
//         ? Padding(
//             padding: isDense ? const EdgeInsets.all(5.0) : EdgeInsets.zero,
//             child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
//               if ((fieldName != null && fieldName != "") || req)
//                 // Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5.0),
//                   // child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
//                   child: RichText(
//                     textScaler: TextScaler.linear(Get.textScaleFactor),
//                     text: TextSpan(
//                         text: fieldName ?? "",
//                         style: TextStyle(
//                             color: ThemeColorMode.isLight ? Colors.black : Colors.white,
//                             fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.5),
//                         children: <TextSpan>[
//                           req ? TextSpan(text: " *", style: const TextStyle(color: Colors.red)) : TextSpan(),
//                         ]),
//                   ),
//                 ),
//               Padding(
//                 padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
//                 child: FormBuilderField(
//                   key: validationKey,
//                   name: fieldName?.toLowerCase().replaceAll(" ", "_") ?? "date_time",
//                   validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   builder: (FormFieldState<dynamic> field) => Obx(() {
//                     return TextField(
//                       controller: initialValue != null
//                           ? (dateTimeController..text = initialValue!.call(DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").format(DateTimeHelper.now)))
//                           : dateTimeController,
//                       readOnly: readOnly,
//                       showCursor: !disableKeyboard.value,
//                       cursorColor: Colors.black,
//                       maxLength: fieldType == "Time" ? 5 : 10,
//                       keyboardType: disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
//                       inputFormatters: [
//                         fieldType == "Time"
//                             ? FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?:?(\d{1,2})?'))
//                             : FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?/?(\d{1,2})?/?(\d{1,4})?'))
//                       ],
//                       onTap: () {
//                         onTap != null ? onTap!() : null;
//                         if (disableKeyboard.value) {
//                           DatePicker.showDatePicker(
//                             context,
//                             dateFormat: fieldType == "Time" ? "HH:mm" : "M/dd/yyyy",
//                             pickerMode: fieldType == "Time" ? DateTimePickerMode.time : DateTimePickerMode.date,
//                             minDateTime: dateType == "OtherDate" ? DateTimeHelper.now : DateTime(2015, 1, 1),
//                             onConfirm: (date, list) {
//                               dateTimeController.text = DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").format(date);
//                               field.didChange(date);
//                               disableKeyboard.value = true;
//                               onConfirm != null ? onConfirm!(date) : null;
//                             },
//                             onCancel: () {
//                               disableKeyboard.value = false;
//                               onCancel != null ? onCancel!() : null;
//                             },
//                             initialDateTime: DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").parse(dateTimeController.text),
//                             locale: DATETIME_PICKER_LOCALE_DEFAULT,
//                           );
//                         }
//                       },
//                       onChanged: (String value) {
//                         if (value != "") {
//                           field.didChange(value);
//                         } else {
//                           field.reset();
//                         }
//                         onChanged != null ? onChanged!(value) : null;
//                       },
//                       onEditingComplete: () {
//                         disableKeyboard.value = true;
//                         field.didChange(dateTimeController.text);
//                         FocusScope.of(context).unfocus();
//                         onEditingComplete != null ? onEditingComplete!() : null;
//                       },
//                       onTapOutside: (event) {
//                         disableKeyboard.value = true;
//                         field.didChange(dateTimeController.text);
//                         FocusScope.of(context).unfocus();
//                         Keyboard.close(context: context);
//                       },
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),
//                       decoration: InputDecoration(
//                         isDense: isDense,
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
//                         hintText: hintText ?? (fieldType == "Time" ? "hh:mm" : "mm/dd/yyyy"),
//                         hintStyle: const TextStyle(color: ColorConstants.grey),
//                         counterText: showCounter ? null : "",
//                         errorText: field.errorText,
//                         errorStyle: const TextStyle(color: ColorConstants.red),
//                         border: OutlineInputBorder(
//                             borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
//                         errorBorder:
//                             OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
//                       ),
//                     );
//                   }),
//                 ),
//               )
//             ]),
//           )
//         : const SizedBox.shrink();
//   }
// }

class DiscrepancyAndWorkOrdersDateTime extends StatelessWidget {
  final String? fieldType;
  final bool req;
  final GlobalKey<FormFieldState>? validationKey;
  final bool showField;
  final String? fieldName;
  final TextEditingController dateTimeController;
  final bool isDense;
  final bool readOnly;
  final RxBool disableKeyboard;
  final String? hintText;
  final String? dateType;
  final bool showCounter;
  final void Function(DateTime dateTime)? onConfirm;
  final void Function()? onCancel;
  final void Function()? onTap;

  final bool? only2Day;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final String Function(String value)? initialValue;

  const DiscrepancyAndWorkOrdersDateTime({
    super.key,
    this.fieldType,
    this.req = false,
    this.validationKey,
    this.showField = true,
    this.fieldName,
    this.readOnly = false,
    required this.dateTimeController,
    this.isDense = false,
    required this.disableKeyboard,
    this.hintText,
    this.dateType,
    this.showCounter = false,
    this.only2Day = false,
    this.onConfirm,
    this.onCancel,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return showField
        ? Padding(
          padding: isDense ? const EdgeInsets.all(5.0) : EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((fieldName != null && fieldName!.isNotEmpty) || req)
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                      text: fieldName ?? "",
                      style: TextStyle(color: Colors.black, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      children: <TextSpan>[if (req) const TextSpan(text: " *", style: TextStyle(color: Colors.red))],
                    ),
                  ),
                ),
              Padding(
                padding: (fieldName != null && fieldName!.isNotEmpty) ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
                child: FormBuilderField(
                  key: validationKey,
                  name: fieldName?.toLowerCase().replaceAll(" ", "_") ?? "date_time",
                  validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder: (FormFieldState<dynamic> field) {

                    return GestureDetector(
                      onTap:
                          readOnly
                              ? null
                              : () {
                                onTap?.call();
                                if (disableKeyboard.value) {
                                  DatePicker.showDatePicker(
                                    context,
                                    dateFormat: fieldType == "Time" ? "HH:mm" : "M/dd/yyyy",
                                    pickerMode: fieldType == "Time" ? DateTimePickerMode.time : DateTimePickerMode.date,
                                    minDateTime: dateType == "OtherDate" ? DateTimeHelper.now : DateTime(2015, 1, 1),
                                    maxDateTime: only2Day == true ? DateTimeHelper.now.add(Duration(days: 2)) : DateTime(2050, 12, 31),
                                    onConfirm: (date, list) {
                                      dateTimeController.text = DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").format(date);
                                      field.didChange(date);
                                      disableKeyboard.value = true;
                                      onConfirm != null ? onConfirm!(date) : null;
                                    },
                                    onCancel: () {
                                      disableKeyboard.value = false;
                                      onCancel != null ? onCancel!() : null;
                                    },
                                    initialDateTime: DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").parse(dateTimeController.text),
                                    locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                  );
                                }
                              },
                      child: AbsorbPointer(
                        absorbing: true, // Prevents interaction when read-only
                        child: TextField(
                          controller:
                              initialValue != null
                                  ? (dateTimeController..text = initialValue!.call(DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").format(DateTime.now())))
                                  : dateTimeController,
                          readOnly: readOnly,
                          // Enforce read-only behavior
                          showCursor: false,
                          // Hide cursor to avoid confusion
                          keyboardType: TextInputType.none,
                          // Prevent keyboard from appearing
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                          decoration: InputDecoration(
                            isDense: isDense,
                            filled: true,
                            fillColor: readOnly ? Colors.grey[200] : Colors.white,
                            // Light grey to indicate non-editable
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                            hintText: hintText ?? (fieldType == "Time" ? "hh:mm" : "mm/dd/yyyy"),
                            hintStyle: const TextStyle(color: Colors.grey),
                            counterText: showCounter ? null : "",
                            errorText: field.errorText,
                            border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8.0)),
                            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8.0)),
                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(8.0)),
                            errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
        : const SizedBox.shrink();
  }
}

class DiscrepancyAndWorkOrdersTextButton extends StatelessWidget {
  final String? fieldName;
  final Color? fieldColor;
  final void Function()? onPressed;

  const DiscrepancyAndWorkOrdersTextButton({super.key, required this.fieldName, this.fieldColor = Colors.blue, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: onPressed, // style: TextButton.styleFrom(
        //   foregroundColor: Colors.white,
        //   backgroundColor: Colors.blue,
        //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // ),
        child: Text(fieldName!, style: TextStyle(fontWeight: FontWeight.w600, color: fieldColor, fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize)),
      ),
    );
  }
}

class DiscrepancyAndWorkOrdersTextButtonNew extends StatelessWidget {
  final String? fieldName;
  final void Function()? onPressed;
  final bool? underline;

  const DiscrepancyAndWorkOrdersTextButtonNew({super.key, required this.fieldName, required this.onPressed, this.underline = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RichText(
          text: TextSpan(
            text: '[ ',
            style: TextStyle(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, fontWeight: FontWeight.w500, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
            children: [
              TextSpan(
                text: fieldName,
                style: TextStyle(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize, decoration: underline! ? TextDecoration.underline : null, decorationColor: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,),
              ),
              TextSpan(
                text: ' ]',
                style: TextStyle(color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black, fontWeight: FontWeight.w500, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
              ),
            ]
          ),
        ),

      ),
    );
  }
}

class DiscrepancyAndWorkOrdersTextField extends StatelessWidget {
  final bool req;
  final String? validatorKeyName;
  final GlobalKey<FormFieldState>? validationKey;
  final String? fieldName;
  final String? hintText;
  final TextEditingController? textFieldController;
  final FocusNode? focusNode;
  final bool readOnly;
  final int? maxLines;
  final int? maxCharacterLength;
  final bool showCounter;
  final String? dataType;
  final bool decimalNumber;
  final bool signedNumber;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextInputFormatter? textInputFormatter;
  final double? textFieldWidth;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String value)? onSubmitted;

  const DiscrepancyAndWorkOrdersTextField({
    super.key,
    this.req = false,
    this.validatorKeyName,
    this.validationKey,
    this.fieldName,
    this.hintText,
    this.textFieldController,
    this.focusNode,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxCharacterLength,
    this.showCounter = false,
    this.dataType,
    this.decimalNumber = false,
    this.signedNumber = false,
    this.textInputType,
    this.textInputAction,
    this.textInputFormatter,
    this.textFieldWidth,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fieldName != null && fieldName != "")
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              // child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              child: RichText(
                textScaler: TextScaler.linear(Get.textScaleFactor),
                text: TextSpan(
                  text: fieldName ?? "",
                  style: TextStyle(
                    color: ThemeColorMode.isLight ? Colors.black : Colors.white,
                    fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  children: <TextSpan>[req ? const TextSpan(text: " *", style: TextStyle(color: Colors.red)) : const TextSpan()],
                ),
              ),
            ),
          Padding(
            padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
            child: FormBuilderField(
              key: validationKey,
              name: validatorKeyName ?? fieldName?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
              validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} field is required.") : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder:
                  (FormFieldState<dynamic> field) => TextField(
                    controller: textFieldController,
                    focusNode: focusNode,
                    readOnly: readOnly,
                    cursorColor: Colors.black,
                    maxLines: maxLines ?? (dataType?.toLowerCase() == "remarks" || dataType?.toLowerCase() == "comments" ? 3 : null),
                    maxLength: maxCharacterLength,
                    keyboardType:
                        textInputType ??
                        (dataType?.toLowerCase() == "remarks" || dataType?.toLowerCase() == "comments"
                            ? TextInputType.multiline
                            : dataType?.toLowerCase() == "number"
                            ? TextInputType.numberWithOptions(decimal: decimalNumber, signed: signedNumber)
                            : null),
                    textInputAction: textInputAction ?? TextInputAction.next,
                    inputFormatters:
                        textInputFormatter != null
                            ? [textInputFormatter!]
                            : dataType?.toLowerCase() == "number"
                            ? [
                              decimalNumber
                                  ? signedNumber
                                      ? FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d{0,2})?'))
                                      : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                                  : FilteringTextInputFormatter.digitsOnly,
                              if (decimalNumber)
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  if (newValue.text == "-") {
                                    return TextEditingValue(text: newValue.text, selection: newValue.selection);
                                  } else if (oldValue.text == "0.00" || newValue.text == "") {
                                    return const TextEditingValue(text: "");
                                  } else {
                                    if (oldValue.text.contains(".") && !newValue.text.contains(".") && newValue.text.isNotEmpty) {
                                      return TextEditingValue(text: double.tryParse(oldValue.text)?.toStringAsFixed(2) ?? "0.00", selection: newValue.selection);
                                    }
                                    return TextEditingValue(text: double.tryParse(newValue.text)?.toStringAsFixed(2) ?? "0.00", selection: newValue.selection);
                                  }
                                }),
                            ]
                            : null,
                    onTap: onTap,
                    onChanged: (String value) {
                      if (value != "") {
                        field.didChange(value);
                      } else {
                        field.reset();
                      }
                      onChanged?.call(dataType?.toLowerCase() == "number" && decimalNumber ? double.tryParse(value)?.toStringAsFixed(2) ?? "0.00" : value);
                    },
                    onEditingComplete: onEditingComplete,
                    onSubmitted: (value) {
                      if (value != "") {
                        field.didChange(value);
                      } else {
                        field.reset();
                      }
                      onSubmitted?.call(dataType?.toLowerCase() == "number" && decimalNumber ? double.tryParse(value)?.toStringAsFixed(2) ?? "0.00" : value);
                    },
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxWidth: textFieldWidth ?? double.infinity),
                      isDense: true,
                      filled: true,
                      fillColor: readOnly ? Colors.grey[350] : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.5),
                      hintText:
                          hintText ??
                          (dataType?.toLowerCase() == "number"
                              ? decimalNumber
                                  ? signedNumber
                                      ? "±0.00"
                                      : "0.00"
                                  : "0"
                              : null),
                      hintStyle: const TextStyle(color: ColorConstants.grey),
                      counterText: showCounter ? null : "",
                      errorText: field.errorText,
                      errorStyle: const TextStyle(color: ColorConstants.red),
                      border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
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

class DiscrepancyAndWorkOrdersCustomDialog {
  static Future<void> showDialogBox({
    BuildContext? context,
    required String dialogTitle,
    bool enableWidget = false,
    List<Widget>? children,
    String? widgetButtonTitle,
    VoidCallback? onTap,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    List<Widget>? actions,
  }) {
    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: context ?? Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        dialogTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ThemeColorMode.isDark ? ColorConstants.primary : ColorConstants.black, fontSize: Theme.of(Get.context!).textTheme.headlineLarge!.fontSize! + 2, letterSpacing: 1.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: InkWell(child: const Icon(Icons.cancel, size: 30.0, color: Colors.red), onTap: () => Get.back(closeOverlays: true)),
                    ),
                  ],
                ),
                titlePadding: const EdgeInsets.only(left: 12.0, top: 5.0, right: 5.0, bottom: 5.0),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossAxisAlignment,
                    spacing: 5.0,
                    children: [if (enableWidget && children != null) ...children],
                  ),
                ),
                actions: [Wrap(alignment: WrapAlignment.end, spacing: 10.0, children: actions ?? [])],
              ),
            );
          },
        );
      },
    );
  }
}

/// ********* Tayeb **********

class TextWithMultipleTitle extends StatelessWidget {
  final String title1;
  final String title2;
  final Color title1Color;
  final Color title2Color;
  const TextWithMultipleTitle({super.key, required this.title1, required this.title2,this.title1Color = ColorConstants.primary,this.title2Color = ColorConstants.black});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Text("$title1 : ",style: TextStyle(color: title1Color,fontWeight: FontWeight.w500),),
        Text(title2,style: TextStyle(color: title2Color,fontWeight: FontWeight.w500),),
      ],
    );
  }

}

class TextButtonWithMultipleTitle extends StatelessWidget {
  final String title1;
  final String title2;
  final Color title1Color;
  final Color title2Color;
  final Function()? onTap;
  const TextButtonWithMultipleTitle({super.key, required this.title1, required this.title2,this.title1Color = ColorConstants.primary,this.title2Color = ColorConstants.black, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Text("$title1 : ",style: TextStyle(color: title1Color,fontWeight: FontWeight.w500),),
        GestureDetector(onTap: onTap,child: Text(title2,style: TextStyle(color: title2Color,fontWeight: FontWeight.w500),)),
      ],
    );
  }

}
