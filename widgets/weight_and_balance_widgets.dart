import 'dart:ui';

import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';
import '../shared/services/theme_color_mode.dart';
import '../shared/utils/logged_in_data.dart';

class WBMaterialButton extends StatelessWidget {
  final String? buttonText;
  final double? buttonTextSize;
  final Color? buttonTextColor;
  final Color? buttonColor;
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final double? lrPadding;
  final void Function()? onPressed;

  const WBMaterialButton({
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
        disabledColor: buttonColor,
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

class WBDropDown extends StatelessWidget {
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
  final String dropDownKey;
  final double? textFieldWidth;
  final void Function(Map value)? onChanged;
  final void Function(Map value)? initialValue;

  ///Use on element type select
  const WBDropDown({
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
    required this.dropDownData,
    required this.dropDownKey,
    this.textFieldWidth,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    initialValue?.call(dropDownData?.first);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      fillColor: readOnly ? Colors.grey[350] : Colors.white,
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

class WBTextField extends StatelessWidget {
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

  const WBTextField({
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
              child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
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
                      hintText:
                          hintText == "ITEM"
                              ? "ITEM NAME"
                              : hintText ??
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

class WBCustomTable extends StatefulWidget {
  final List<String> headers;
  final List<Map<String, dynamic>> rows;
  final String? totalCellName;
  final bool flexible;
  final void Function(List<Map<String, dynamic>> values)? onChangedEveryField;
  final int? systemId;
  final int fkParentId;
  final int fkOptionId;
  final String? itemName;

  const WBCustomTable({
    super.key,
    required this.headers,
    required this.rows,
    this.totalCellName,
    this.flexible = true,
    this.onChangedEveryField,
    this.systemId,
    required this.fkParentId,
    required this.fkOptionId,
    this.itemName,
  }) : assert(headers.length > 0, "Headers cannot be empty!");

  @override
  State<WBCustomTable> createState() => _WBCustomTableState();
}

class _WBCustomTableState extends State<WBCustomTable> {
  late List<Map<String, String>> dataRows;
  final Map<String, ValueNotifier<TextEditingController>> textController = <String, ValueNotifier<TextEditingController>>{};

  @override
  void initState() {
    super.initState();
    dataRows = List<Map<String, String>>.from(widget.rows.map((row) => row.map((key, value) => MapEntry(key, value.toString()))));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.totalCellName?.isNotEmpty ?? false) {
        calculateAllFieldValues(initial: true);
      }
      addNewRow();
    });
  }

  addNewRow() {
    final Map<String, String> newRowValues = {
      "childId": "0",
      "systemId": (widget.systemId ?? UserSessionInfo.systemId).toString(),
      "fkParentId": widget.fkParentId.toString(),
      "fkOptionId": widget.fkOptionId.toString(),
      "itemName": widget.itemName ?? "",
      "weight": "",
      "arm": "",
      "moment": "",
      "remarks": "",
    };
    setState(() {
      dataRows.add(newRowValues);
    });
  }

  calculateAllFieldValues({bool initial = false, bool momentField = false, bool armField = false}) {
    int totalWeight = 0;
    //double totalArm = 0;
    double totalMoment = 0;

    for (int i = 0; i < dataRows.length; i++) {
      final int weight = (double.tryParse(textController['weight$i']?.value.text ?? '0') ?? 0).toInt();
      final String arm = textController['arm$i']?.value.text ?? '';
      final String moment = textController['moment$i']?.value.text ?? '';
      if (weight != 0 && arm.isNotEmpty && !momentField) {
        if (initial) textController['arm$i']?.value.text = (double.tryParse(arm) ?? 0.00).toStringAsFixed(2);
        textController['moment$i']?.value.text = (weight * (double.tryParse(arm) ?? 0)).toStringAsFixed(2);
      } else if (weight != 0 && moment.isNotEmpty && !armField) {
        if (initial) textController['moment$i']?.value.text = (double.tryParse(moment) ?? 0.00).toStringAsFixed(2);
        textController['arm$i']?.value.text = ((double.tryParse(moment) ?? 0) / weight).toStringAsFixed(2);
      }

      totalWeight += (double.tryParse(textController['weight$i']?.value.text ?? '0') ?? 0).toInt();
      //totalArm += double.tryParse(textController['arm$i']?.value.text ?? '0') ?? 0;
      totalMoment += double.tryParse(textController['moment$i']?.value.text ?? '0') ?? 0;
    }

    textController['total_weight']?.value.text = totalWeight.toString();
    textController['total_arm']?.value.text = (totalMoment / totalWeight).isNaN ? "0.00" : (totalMoment / totalWeight).toStringAsFixed(2);
    textController['total_moment']?.value.text = totalMoment.toStringAsFixed(2);
    /*if (totalWeight != 0 && totalArm != 0) {
      textController['total_arm']?.value.text = totalArm.toStringAsFixed(2);
      textController['total_moment']?.value.text = (totalWeight * totalArm).toStringAsFixed(2);
    } else if (totalWeight != 0 && totalMoment != 0) {
      textController['total_moment']?.value.text = totalMoment.toStringAsFixed(2);
      textController['total_arm']?.value.text = (totalMoment / totalWeight).toStringAsFixed(2);
    } else {
      textController['total_arm']?.value.text = totalArm.toStringAsFixed(2);
      textController['total_moment']?.value.text = totalMoment.toStringAsFixed(2);
    }*/
  }

  List<Map<String, dynamic>> getCurrentFieldValues() {
    final List<Map<String, dynamic>> currentFieldValues = <Map<String, dynamic>>[];

    for (int i = 0; i < dataRows.length; i++) {
      if ((widget.itemName ?? textController['itemName$i']?.value.text ?? "").isNotEmpty &&
          (widget.itemName != null ? (textController['weight$i']?.value.text ?? "").isNotEmpty : true)) {
        final Map<String, dynamic> eachRowValues = <String, dynamic>{};

        eachRowValues.addAll({
          "childId": int.tryParse(dataRows[i]["childId"] ?? "0") ?? 0,
          "systemId": int.tryParse((dataRows[i]["systemId"] ?? widget.systemId).toString()) ?? UserSessionInfo.systemId,
          "fkParentId": int.tryParse(dataRows[i]["fkParentId"] ?? "0") ?? widget.fkParentId,
          "fkOptionId": int.tryParse(dataRows[i]["fkOptionId"] ?? "0") ?? widget.fkOptionId,
          "itemName": widget.itemName ?? textController['itemName$i']?.value.text ?? '',
          "weight": double.tryParse(textController['weight$i']?.value.text ?? '') ?? 0,
          "arm": double.tryParse(textController['arm$i']?.value.text ?? '') ?? 0.0,
          "moment": double.tryParse(textController['moment$i']?.value.text ?? '') ?? 0.0,
          "remarks": textController['remarks$i']?.value.text ?? '',
        });

        /*for (String header in widget.headers) {
          if (header.toLowerCase() == "weight") {
            eachRowValues.addIf(true, header.toLowerCase(), (double.tryParse(textController['${header.toLowerCase()}$i']?.value.text ?? '') ?? 0).toInt());
          } else if (header.toLowerCase() == "arm" || header.toLowerCase() == "moment") {
            eachRowValues.addIf(true, header.toLowerCase(), double.tryParse(textController['${header.toLowerCase()}$i']?.value.text ?? '') ?? 0.0);
          } else {
            eachRowValues.addIf(true, header.toLowerCase(), textController['${header.toLowerCase()}$i']?.value.text ?? '');
          }
        }*/

        currentFieldValues.add(eachRowValues);
      }
    }

    return currentFieldValues;
  }

  Widget buildTableCell(String header, int index) {
    final String headerLower = ["weight", "arm", "moment", "remarks"].contains(header.toLowerCase()) ? header.toLowerCase() : "itemName";
    return WBTextField(
      req: header == widget.headers[0],
      textFieldController:
          textController
              .putIfAbsent(
                '$headerLower$index',
                () => ValueNotifier(
                  TextEditingController(text: headerLower == "weight" ? double.tryParse(dataRows[index][headerLower] ?? "0")?.toInt().toString() : dataRows[index][headerLower]),
                ),
              )
              .value,
      hintText: !["weight", "arm", "moment"].contains(headerLower) ? header : null,
      maxCharacterLength: ["weight", "arm", "moment"].contains(headerLower) ? 9 : null,
      dataType: ["weight", "arm", "moment"].contains(headerLower) ? 'number' : null,
      decimalNumber: ["arm", "moment"].contains(headerLower),
      signedNumber: headerLower == "arm",
      textInputAction: (index == dataRows.length - 1 && header == widget.headers.last) ? TextInputAction.done : TextInputAction.next,
      onChanged: (value) {
        if (index == dataRows.length - 1 && header == widget.headers[0] && value.isNotEmpty) {
          addNewRow();
        } else if (header == widget.headers[0] &&
            (textController["${widget.headers[0].toLowerCase()}$index"]?.value.text.isEmpty ?? false) &&
            (textController["${widget.headers[0].toLowerCase()}${index + 1}"]?.value.text.isEmpty ?? false)) {
          setState(() {
            dataRows.removeAt(index + 1);
          });
        }

        if ((widget.totalCellName?.isNotEmpty ?? false) && (headerLower == 'weight' || headerLower == 'arm' || headerLower == 'moment')) {
          calculateAllFieldValues(armField: headerLower == 'arm', momentField: headerLower == 'moment');
        }

        List<Map<String, dynamic>> newValues = getCurrentFieldValues();
        widget.onChangedEveryField?.call(newValues);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: widget.headers.asMap().map(
        (key, value) => MapEntry(
          key,
          value.toUpperCase() == "WEIGHT" || value.toUpperCase() == "ARM" || value.toUpperCase() == "MOMENT"
              ? (widget.flexible ? const FlexColumnWidth() : const FixedColumnWidth(130))
              : (widget.flexible ? const FlexColumnWidth(2.5) : FixedColumnWidth(Get.width - 100)),
        ),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: const TableBorder(verticalInside: BorderSide(color: ColorConstants.grey), horizontalInside: BorderSide(color: ColorConstants.grey)),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
          children:
              widget.headers
                  .map(
                    (header) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(header, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                    ),
                  )
                  .toList(),
        ),
        ...dataRows.asMap().entries.map((entry) {
          final i = entry.key;
          return TableRow(
            decoration: BoxDecoration(
              color: ColorConstants.primary.withValues(alpha: 0.4),
              borderRadius: (i == dataRows.length - 1 && !(widget.totalCellName ?? "").isNotEmpty) ? const BorderRadius.vertical(bottom: Radius.circular(5.0)) : null,
            ),
            children: widget.headers.map((header) => buildTableCell(header, i)).toList(),
          );
        }),
        if (widget.totalCellName?.isNotEmpty ?? false)
          TableRow(
            decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.0))),
            children:
                widget.headers.map((header) {
                  final headerLower = header.toLowerCase();
                  return ["weight", "arm", "moment"].contains(headerLower)
                      ? WBTextField(readOnly: true, textFieldController: textController.putIfAbsent('total_$headerLower', () => ValueNotifier(TextEditingController())).value)
                      : Text(
                        header == widget.headers[0] ? (widget.totalCellName ?? "") : "",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      );
                }).toList(),
          ),
      ],
    );
  }
}

class WBCustomDialog {
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
                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.headlineLarge!.fontSize! - 3, letterSpacing: 3.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: InkWell(child: const Icon(Icons.cancel, size: 30.0, color: Colors.red), onTap: () => Get.back(closeOverlays: true)),
                    ),
                  ],
                ),
                titlePadding: const EdgeInsets.only(left: 12.0, top: 10.0, right: 5.0, bottom: 5.0),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossAxisAlignment,
                    spacing: 10.0,
                    children: [if (enableWidget && children != null) ...children],
                  ),
                ),
                actions: [Row(mainAxisAlignment: MainAxisAlignment.end, spacing: 10.0, children: actions ?? [])],
              ),
            );
          },
        );
      },
    );
  }
}
