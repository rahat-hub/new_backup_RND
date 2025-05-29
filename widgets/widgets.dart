import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';
import '../shared/services/keyboard.dart';
import '../shared/services/theme_color_mode.dart';
import '../shared/utils/device_type.dart';

abstract class WidgetConstant {
  static Size? getSize(GlobalKey key) {
    Size? size;

    final BuildContext? context = key.currentContext;
    if (context != null) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      size = box.hasSize ? box.size : null;
    } else {
      final RenderBox box = Get.context?.findRenderObject()! as RenderBox;
      size = box.hasSize ? box.size : null;
    }

    return size;
  }

  static Future<Size?> widgetSize(GlobalKey key) {
    Size? size;

    WidgetsBinding.instance.addPostFrameCallback((callBackTime) {
      final BuildContext? context = key.currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject()! as RenderBox;
        size = box.hasSize ? box.size : null;
      } else {
        final RenderBox box = Get.context?.findRenderObject()! as RenderBox;
        size = box.hasSize ? box.size : null;
      }
    }, debugLabel: 'WidgetSize');

    return Future.delayed(Duration.zero, () => size);
  }

  static Widget customDropDownWidget({
    String? title,
    List? data,
    String? hintText,
    double itemHeight = 55.0,
    double height = 65.0,
    String? helperText,
    bool titleStyle = false,
    Color? helperColor,
    BuildContext? context,
    String? key,
    bool dropdownTextColorEnable = false,
    bool borderColor = false,
    void Function(dynamic value)? onChanged,
    bool disableEditing = false,
    bool showTitle = true,
    bool isDiscrepancy = false,
    int hintTextFontSize = 3,
    int itemTextHeight = 3,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "$title",
              style:
                  titleStyle
                      ? isDiscrepancy
                          ? TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.bold)
                          : TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize, fontWeight: FontWeight.bold)
                      : TextStyle(fontSize: Theme.of(context!).textTheme.displayMedium!.fontSize! - 3),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
            border: borderColor != true ? Border.all(color: ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : Border.all(color: ColorConstants.red),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DropdownButton<dynamic>(
            icon: const Icon(Icons.keyboard_arrow_down, color: ColorConstants.black, size: 20),
            iconEnabledColor: ColorConstants.black,
            iconDisabledColor: ColorConstants.black,
            hint: Padding(
              padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
              child: Text(
                "$hintText",
                style: Theme.of(context ?? Get.context!).textTheme.bodyMedium!.copyWith(
                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - hintTextFontSize,
                  color: ColorConstants.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            menuMaxHeight: Get.height - 200,
            itemHeight: itemHeight,
            underline: const SizedBox(),
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: ColorConstants.white,
            isDense: false,
            items:
                disableEditing
                    ? null
                    : data?.map((value) {
                      return DropdownMenuItem<dynamic>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
                          child: Text(
                            "${value[key]}",
                            style: Theme.of(context ?? Get.context!).textTheme.bodyMedium!.copyWith(
                              fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - itemTextHeight,
                              color: dropdownTextColorEnable ? textColorReturn(value: value["name"]) : ColorConstants.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 5),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5.0),
            child: Text(
              helperText,
              style: Theme.of(
                Get.context!,
              ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5, color: helperColor, fontWeight: FontWeight.w100),
            ),
          ),
      ],
    );
  }

  static Widget customDropDownWidgetNew({
    TextEditingController? dropDownController,
    bool showTitle = true,
    String? title,
    String? tooltip,
    bool titleStyle = false,
    bool isDiscrepancy = false,
    bool expands = true,
    required BuildContext context,
    bool needValidation = false,
    GlobalKey<FormFieldState>? validationKey,
    String? validationKeyName,
    String? hintText,
    String? helperText,
    Color? helperColor,
    bool borderColor = false,
    bool disableEditing = false,
    bool isRa = false,
    bool contentPaddingEnable = false,
    double? topPadding,
    double? bottomPadding,
    required List? dropDownData,
    String? dropDownKey,
    double hintTextFontSize = 3.0,
    double itemTextHeight = 3.0,
    bool dropdownTextColorEnable = false,
    double? width,
    void Function(Map<String, dynamic> value)? onChanged,
  }) {
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Tooltip(
                message: tooltip ?? "",
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        title ?? "",
                        style:
                            titleStyle
                                ? isDiscrepancy
                                    ? TextStyle(fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.bold)
                                    : TextStyle(fontSize: Theme.of(context).textTheme.titleLarge!.fontSize, fontWeight: FontWeight.bold)
                                : isRa
                                ? const TextStyle()
                                : TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3),
                      ),
                    ),
                    if ((tooltip ?? "") != "") const Padding(padding: EdgeInsets.only(left: 5.0), child: Icon(Icons.info_outline, size: 15, color: ColorConstants.black)),
                  ],
                ),
              ),
            ),
          FormBuilderField(
            key: validationKey,
            name: validationKeyName ?? title?.toLowerCase().replaceAll(" ", "_") ?? "",
            validator: needValidation ? FormBuilderValidators.required(errorText: "*$title Field is Required!") : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder:
                (FormFieldState<dynamic> field) => DropdownMenu(
                  controller: dropDownController,
                  initialSelection:
                      (dropDownData ?? []).isNotEmpty
                          ? dropDownData?.cast<Map<String, dynamic>>().firstWhere(
                            (element) => element[dropDownKey] == (hintText ?? dropDownController?.text),
                            orElse: () => dropDownData.first,
                          )
                          : null,
                  hintText: hintText,
                  helperText: helperText,
                  errorText: field.errorText,
                  enabled: !disableEditing,
                  menuHeight: Get.height - 200,
                  width: width,
                  enableFilter: false,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - hintTextFontSize,
                    color: ColorConstants.black,
                    fontWeight: FontWeight.w500,
                  ),
                  trailingIcon: Icon(Icons.keyboard_arrow_down, size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 10, color: ColorConstants.black),
                  expandedInsets: expands ? EdgeInsets.zero : null,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: disableEditing == false ? Colors.white : Colors.grey[350],
                    contentPadding:
                        contentPaddingEnable
                            ? EdgeInsets.only(left: 10.0, right: 0.0, top: topPadding ?? 0.0, bottom: bottomPadding ?? 0.0)
                            : const EdgeInsets.only(left: 10.0, right: 0.0, top: 18.0, bottom: 18.0),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - hintTextFontSize,
                      color: ColorConstants.black,
                      fontWeight: FontWeight.w500,
                    ),
                    helperStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 5, color: helperColor, fontWeight: FontWeight.w100),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor != true ? (ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : ColorConstants.red),
                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor != true ? (ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : ColorConstants.red),
                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor != true ? (ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : ColorConstants.red),
                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                    ),
                    errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                  ),
                  dropdownMenuEntries:
                      dropDownData == null
                          ? []
                          : dropDownData.map((value) {
                            return DropdownMenuEntry<dynamic>(
                              value: value,
                              label: "${value[dropDownKey]}",
                              style: ButtonStyle(
                                foregroundColor: dropdownTextColorEnable ? WidgetStateProperty.all(textColorReturn(value: value["name"])) : null,
                                textStyle: WidgetStateProperty.all(
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - itemTextHeight, fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          }).toList(),
                  onSelected: (val) {
                    if (dropDownData != null && (dropDownData[0][dropDownKey] != val[dropDownKey])) {
                      field.didChange(val);
                    } else {
                      field.reset();
                    }
                    onChanged != null ? onChanged(val as Map<String, dynamic>) : null;
                  },
                ),
          ),
        ],
      ),
    );
  }

  static Color textColorReturn({String? value}) {
    switch (value) {
      case 'Cleared':
        return Colors.green;
      case 'Expired':
        return Colors.red;
      case '-- Filter Status --':
        return ThemeColorMode.isDark ? Colors.white : Colors.black;
      case 'Remaining':
        return ThemeColorMode.isDark ? Colors.white : Colors.black;
      default:
        return ThemeColorMode.isDark ? Colors.white : Colors.black;
    }
  }

  static Widget customDropDownWidgetForDiscrepancyCreate({
    String? title,
    List? data,
    String? hintText,
    String? helperText,
    bool completeBackGroundColor = false,
    Color? helperColor,
    BuildContext? context,
    String? key,
    bool disableEditing = false,
    void Function(dynamic value)? onChanged,
    bool showTitle = true,
    bool discrepancyEdit = false,
    String fontSizeType = SizeConstants.button,
  }) {
    var completeColor = false.obs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showTitle
            ? Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                "$title",
                style:
                    discrepancyEdit
                        ? TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.bold)
                        : Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal, fontSize: SizeConstants.fontSizes(type: fontSizeType)),
              ),
            )
            : const SizedBox(),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: completeBackGroundColor != true ? ColorConstants.white : ColorConstants.button,
            borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
            border: Border.all(color: ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DropdownButton<dynamic>(
            icon: const Icon(Icons.keyboard_arrow_down, color: ColorConstants.black, size: 20),
            iconEnabledColor: ColorConstants.black,
            iconDisabledColor: ColorConstants.black,
            hint: Padding(
              padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
              child: Text(
                "$hintText",
                style: Theme.of(context ?? Get.context!).textTheme.bodyMedium!.copyWith(
                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                  color: ColorConstants.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            menuMaxHeight: Get.height - 200,
            underline: const SizedBox(),
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: completeColor.value != true ? ColorConstants.white : ColorConstants.green,
            isDense: false,
            items:
                disableEditing
                    ? null
                    : data?.map((value) {
                      return DropdownMenuItem<dynamic>(
                        value: value,
                        child: Container(
                          width: double.infinity,
                          color: colorReturn(value: value["name"]),
                          child: Padding(
                            padding: const EdgeInsets.only(left: SizeConstants.contentSpacing),
                            child: Text(
                              "${value[key]}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context ?? Get.context!).textTheme.bodyMedium!.copyWith(
                                fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                                color: ColorConstants.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
            onChanged: onChanged,
          ),
        ),
        helperText != null
            ? Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text(
                helperText,
                style: Theme.of(
                  Get.context!,
                ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5, color: helperColor, fontWeight: FontWeight.w100),
              ),
            )
            : const SizedBox(),
      ],
    );
  }

  static Color? colorReturn({String? value}) {
    switch (value) {
      case 'AOG / OOS':
        return Colors.red;
      case 'In Service':
        return Colors.lightGreen;
      case 'Parts On Order':
        return Colors.yellowAccent;
      case 'Limited Mission':
        return Colors.yellow;
      case 'Completed':
        return Colors.lightGreen;
      default:
        return null;
    }
  }

  static Widget flightProfileListTile({String? username, String? dutyTime, String? weight, String? manCat, String? manIcon}) {
    return Row(
      children: [
        Row(
          children: [
            Material(
              color: Theme.of(Get.context!).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius)),
              child: SizedBox(
                height: 80,
                width: 80,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius)),
                  elevation: 2,
                  shadowColor: Theme.of(Get.context!).shadowColor,
                  color: Theme.of(Get.context!).cardColor,
                  borderOnForeground: false,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius),
                    onTap: () => true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [Image.asset(manIcon.toString(), color: ColorConstants.primary, height: 60, width: 60)],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: DeviceType.isTablet ? SizeConstants.rootContainerSpacing : SizeConstants.contentSpacing),
            Container(
              width: DeviceType.isTablet ? 85 : 50,
              color: Colors.transparent,
              child: TextWidget(text: manCat.toString(), size: SizeConstants.fontSizes(type: SizeConstants.manCatFont), textAlign: TextAlign.center),
            ),
          ],
        ),
        SizedBox(width: DeviceType.isTablet ? SizeConstants.rootContainerSpacing : SizeConstants.contentSpacing),
        Expanded(
          child: SizedBox(
            height: 80,
            child: Material(
              color: Theme.of(Get.context!).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius)),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.gridItemRadius)),
                elevation: 2,
                shadowColor: Theme.of(Get.context!).shadowColor,
                color: Theme.of(Get.context!).cardColor,
                borderOnForeground: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: SizeConstants.contentSpacing * 1, right: SizeConstants.contentSpacing * 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: TextWidget(
                                text: "Username",
                                textAlign: TextAlign.center,
                                color: Theme.of(Get.context!).textTheme.titleSmall!.color,
                                size: SizeConstants.fontSizes(type: SizeConstants.extraSmallHint),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: TextWidget(
                                text: "Duty Time",
                                textAlign: TextAlign.center,
                                color: Theme.of(Get.context!).textTheme.titleSmall!.color,
                                size: SizeConstants.fontSizes(type: SizeConstants.extraSmallHint),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: TextWidget(
                                text: "Weight",
                                textAlign: TextAlign.center,
                                color: Theme.of(Get.context!).textTheme.titleSmall!.color,
                                size: SizeConstants.fontSizes(type: SizeConstants.extraSmallHint),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: TextWidget(
                                text: username.toString(),
                                textAlign: TextAlign.center,
                                color: ColorConstants.text,
                                size: SizeConstants.fontSizes(type: SizeConstants.smallHint),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: TextWidget(
                                text: dutyTime.toString(),
                                textAlign: TextAlign.center,
                                color: ColorConstants.text,
                                size: SizeConstants.fontSizes(type: SizeConstants.smallHint),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: TextWidget(
                                text: weight.toString(),
                                textAlign: TextAlign.center,
                                color: ColorConstants.text,
                                size: SizeConstants.fontSizes(type: SizeConstants.smallHint),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget customIcon({IconData? iconName, Color? color}) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Icon(iconName, color: color ?? ColorConstants.white, size: 24);
      },
    );
  }

  static Widget customContainer({String? title, String? titleValue}) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Container(
          height: 60.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: ColorConstants.primary), color: ColorConstants.background),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 60.0,
                  child: Material(
                    color: Colors.blue.withValues(alpha: 0.2),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          "$title",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ColorConstants.primary, fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 3, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const DottedLine(direction: Axis.vertical, lineThickness: 1.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Text("$titleValue", textAlign: TextAlign.center, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 3)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget flightOpsDocumentView({
    String? folderTitle,
    FontWeight? folderFontWeight,
    IconData? fileIcon,
    Color? iconColor = ColorConstants.grey,
    bool requiredFile = false,
    required Widget Function() buildLongPressMenu,
    CustomPopupMenuController? popUpController,
    void Function()? onTapOnFileName,
  }) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return CustomPopupMenu(
          controller: popUpController,
          pressType: PressType.longPress,
          menuBuilder: buildLongPressMenu,
          barrierColor: Colors.transparent,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: InkWell(
              onTap: onTapOnFileName,
              child: Row(
                children: [
                  Icon(fileIcon, color: iconColor, size: 24),
                  SearchHighlightText(
                    folderTitle ?? "",
                    style: TextStyle(
                      fontSize: Theme.of(Get.context!).textTheme.bodyLarge!.fontSize! + 1,
                      color:
                          requiredFile
                              ? Colors.red
                              : ThemeColorMode.isLight
                              ? Colors.black
                              : Colors.white,
                      fontWeight: folderFontWeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SwitchWidget extends StatelessWidget {
  final ValueNotifier<bool>? controller;
  final bool initialValue;
  final String? activeText;
  final String? inactiveText;
  final void Function(dynamic value)? onChanged;

  const SwitchWidget({super.key, this.controller, this.initialValue = false, this.activeText, this.inactiveText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.switchBoxRadius), side: const BorderSide(width: 2, color: ColorConstants.primary)),
      child: AdvancedSwitch(
        controller: controller,
        disabledOpacity: 0.5,
        width: Get.width > 480 ? 100 : 90,
        initialValue: initialValue,
        activeColor: ColorConstants.black,
        inactiveColor: ColorConstants.white,
        borderRadius: const BorderRadius.all(Radius.circular(SizeConstants.switchBoxRadius)),
        thumb: Material(color: initialValue ? ColorConstants.white : ColorConstants.black, borderRadius: BorderRadius.circular(3)),
        activeChild: TextWidget(
          text: activeText,
          weight: FontWeight.w600,
          letterSpacing: 1.0,
          size: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize,
          color: ColorConstants.white,
        ),
        inactiveChild: TextWidget(
          text: inactiveText,
          weight: FontWeight.w600,
          letterSpacing: 1.0,
          size: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize,
          color: ColorConstants.primary,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
