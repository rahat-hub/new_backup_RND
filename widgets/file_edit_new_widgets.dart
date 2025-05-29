import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/date_time_helper.dart';
import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';
import '../shared/services/keyboard.dart';

class EditTextField extends StatelessWidget {
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

  const EditTextField({super.key,
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
    this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (fieldName != null && fieldName != "")
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ),
        Padding(
          padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
          child: FormBuilderField(
            key: validationKey,
            name: validatorKeyName ?? fieldName?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
            validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} field is required.") : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<dynamic> field) =>
                TextField(
                  controller: textFieldController,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  cursorColor: Colors.black,
                  maxLines: maxLines ?? (dataType?.toLowerCase() == "remarks" || dataType?.toLowerCase() == "comments" ? 3 : null),
                  maxLength: maxCharacterLength,
                  keyboardType: textInputType ??
                      (dataType?.toLowerCase() == "remarks" || dataType?.toLowerCase() == "comments"
                          ? TextInputType.multiline
                          : dataType?.toLowerCase() == "number"
                          ? TextInputType.numberWithOptions(decimal: decimalNumber, signed: signedNumber)
                          : null),
                  textInputAction: textInputAction ?? TextInputAction.next,
                  inputFormatters: textInputFormatter != null
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
                      })
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: textFieldWidth ?? double.infinity),
                    isDense: true,
                    filled: true,
                    fillColor: readOnly ? Colors.grey[350] : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.5),
                hintText: hintText ??
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
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                    enabledBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                    focusedBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                    errorBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                  ),
                ),
          ),
        )
      ]),
    );
  }
}

class FileEditNewMaterialButton extends StatelessWidget {
  final String? buttonText;
  final double? buttonTextSize;
  final Color? buttonTextColor;
  final Color? buttonColor;
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final double? lrPadding;
  final void Function()? onPressed;

  const FileEditNewMaterialButton(
      {super.key,
      this.buttonText,
      this.buttonTextSize,
      this.buttonTextColor,
      this.buttonColor,
      this.borderColor,
      this.icon,
      this.iconColor,
      this.lrPadding,
      this.onPressed});

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (icon != null)
              Icon(icon,
                  color: iconColor ?? ((buttonColor == null || buttonColor == ColorConstants.white) ? ColorConstants.primary : ColorConstants.white),
                  size: Theme.of(context).textTheme.displayMedium!.fontSize! + 3),
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

class FileEditNewDateTime extends StatelessWidget {
  final String? fieldType;
  final bool req;
  final GlobalKey<FormFieldState>? validationKey;
  final bool showField;
  final String? fieldName;
  final TextEditingController dateTimeController;
  final bool isDense;
  final RxBool disableKeyboard;
  final String? hintText;
  final String? dateType;
  final bool showCounter;
  final void Function(DateTime dateTime)? onConfirm;
  final void Function()? onCancel;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final String Function(String value)? initialValue;

  ///Use on element type dateTime
  const FileEditNewDateTime(
      {super.key,
      this.fieldType,
      this.req = false,
      this.validationKey,
      this.showField = true,
      this.fieldName,
      required this.dateTimeController,
      this.isDense = false,
      required this.disableKeyboard,
      this.hintText,
      this.dateType,
      this.showCounter = false,
      this.onConfirm,
      this.onCancel,
      this.onTap,
      this.onChanged,
      this.onEditingComplete,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return showField
        ? Padding(
            padding: isDense ? const EdgeInsets.all(5.0) : EdgeInsets.zero,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              if ((fieldName != null && fieldName != "") || req)
                Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              Padding(
                padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
                child: FormBuilderField(
                  key: validationKey,
                  name: fieldName?.toLowerCase().replaceAll(" ", "_") ?? "date_time",
                  validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder: (FormFieldState<dynamic> field) => Obx(() {
                    return TextField(
                      controller: initialValue != null
                          ? (dateTimeController..text = initialValue!.call(DateFormat(fieldType == "Time" ? "HH:mm" : "M/dd/yyyy").format(DateTimeHelper.now)))
                          : dateTimeController,
                      readOnly: disableKeyboard.value,
                      showCursor: !disableKeyboard.value,
                      cursorColor: Colors.black,
                      maxLength: fieldType == "Time" ? 5 : 10,
                      keyboardType: disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                      inputFormatters: [
                        fieldType == "Time"
                            ? FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?:?(\d{1,2})?'))
                            : FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?/?(\d{1,2})?/?(\d{1,4})?'))
                      ],
                      onTap: () {
                        onTap != null ? onTap!() : null;
                        if (disableKeyboard.value) {
                          DatePicker.showDatePicker(
                            context,
                            dateFormat: fieldType == "Time" ? "HH:mm" : "M/dd/yyyy",
                            pickerMode: fieldType == "Time" ? DateTimePickerMode.time : DateTimePickerMode.date,
                            minDateTime: dateType == "OtherDate" ? DateTimeHelper.now : DateTime(2015, 1, 1),
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
                        field.didChange(dateTimeController.text);
                        FocusScope.of(context).unfocus();
                        onEditingComplete != null ? onEditingComplete!() : null;
                      },
                      onTapOutside: (event) {
                        disableKeyboard.value = true;
                        field.didChange(dateTimeController.text);
                        FocusScope.of(context).unfocus();
                        Keyboard.close(context: context);
                      },
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                      decoration: InputDecoration(
                        isDense: isDense,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                        hintText: hintText ?? (fieldType == "Time" ? "hh:mm" : "mm/dd/yyyy"),
                        hintStyle: const TextStyle(color: ColorConstants.grey),
                        counterText: showCounter ? null : "",
                        errorText: field.errorText,
                        errorStyle: const TextStyle(color: ColorConstants.red),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        errorBorder:
                            OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                      ),
                    );
                  }),
                ),
              )
            ]),
          )
        : const SizedBox.shrink();
  }
}

class FileEditNewTextButton extends StatelessWidget {
  final String? fieldName;
  final Color? fieldColor;
  final void Function()? onPressed;

  const FileEditNewTextButton({super.key, required this.fieldName, this.fieldColor = Colors.blue, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            //foregroundColor: Colors.white,
            //backgroundColor: Colors.blue,
            padding: EdgeInsets.zero,
          ),
          child: Text(fieldName!, style: TextStyle(fontWeight: FontWeight.w600, color: fieldColor, fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize))),
    );
  }
}

class FileEditNewDropDown extends StatelessWidget {
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
  final bool? completeColor;
  final String dropDownKey;
  final double? textFieldWidth;
  final void Function(Map value)? onChanged;
  final void Function(Map value)? initialValue;

  ///Use on element type select
  const FileEditNewDropDown(
      {super.key,
      this.req = false,
      this.validatorKeyName,
      this.validationKey,
      this.fieldName,
      this.hintText,
      required this.dropDownController,
      this.focusNode,
      this.readOnly = false,
      this.expands = false,
      this.completeColor = false,
      required this.dropDownData,
      required this.dropDownKey,
      this.textFieldWidth,
      this.onChanged,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    initialValue?.call(dropDownData?.first);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if ((fieldName != null && fieldName != "") || req)
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ),
        Padding(
          padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
          child: FormBuilderField(
            key: validationKey,
            name: validatorKeyName ?? fieldName?.toLowerCase().replaceAll(" ", "_") ?? "drop_down",
            validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<dynamic> field) => DropdownMenu(
              controller: dropDownController,
              focusNode: focusNode,
              enabled: !readOnly,
              enableFilter: false,
              menuHeight: Get.height - 200,
              expandedInsets: expands ? EdgeInsets.zero : null,
              dropdownMenuEntries: dropDownData == null
                  ? [const DropdownMenuEntry(value: {}, label: "")]
                  : dropDownData!.map((value) {
                      return DropdownMenuEntry<Map>(
                        value: value,
                        label: "${value[dropDownKey]}".trim(),
                        style: ButtonStyle(
                          textStyle: WidgetStatePropertyAll(
                            Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5),
                          ),
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
                fillColor: completeColor != true
                    ? ColorConstants.white
                    : readOnly
                        ? Colors.grey[350]
                        : Colors.white,
                hintStyle: TextStyle(color: readOnly ? ColorConstants.grey : ColorConstants.black),
                errorStyle: const TextStyle(color: ColorConstants.red),
                border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                enabledBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                focusedBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                errorBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class FileEditNewTextField extends StatelessWidget {
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

  const FileEditNewTextField(
      {super.key,
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
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (fieldName != null && fieldName != "")
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ),
        Padding(
          padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 3.0) : EdgeInsets.zero,
          child: FormBuilderField(
            key: validationKey,
            name: validatorKeyName ?? fieldName?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
            validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} field is required.") : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<dynamic> field) => TextField(
              controller: textFieldController,
              focusNode: focusNode,
              readOnly: readOnly,
              cursorColor: Colors.black,
              maxLines: maxLines ?? (dataType?.toLowerCase() == "remarks" || dataType?.toLowerCase() == "comments" ? 3 : null),
              maxLength: maxCharacterLength,
              keyboardType: textInputType ??
                  (dataType?.toLowerCase() == "remarks" || dataType?.toLowerCase() == "comments"
                      ? TextInputType.multiline
                      : dataType?.toLowerCase() == "number"
                          ? TextInputType.numberWithOptions(decimal: decimalNumber, signed: signedNumber)
                          : null),
              textInputAction: textInputAction ?? TextInputAction.next,
              inputFormatters: textInputFormatter != null
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
                            })
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
                hintText: hintText ??
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
                enabledBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.grey), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                focusedBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                errorBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              ),
            ),
          ),
        )
      ]),
    );
  }
}