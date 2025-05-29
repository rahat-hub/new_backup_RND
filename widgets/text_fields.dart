import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../shared/constants/constant_colors.dart';
import '../shared/constants/constant_sizes.dart';
import '../shared/services/keyboard.dart';
import '../shared/services/theme_color_mode.dart';

abstract class TextFieldConstant {
  static textField(
      {FormFieldState<dynamic>? field,
      String? hintText,
      bool isPassword = false,
      bool obscureTextShow = false,
      void Function()? obscureTextShowFunc,
      TextEditingController? controller,
      FocusNode? focusNode,
      String? autofillHints,
      TextInputAction? textInputAction,
      void Function()? onEditingComplete}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofillHints: autofillHints != null ? [autofillHints] : null,
      cursorColor: Colors.black,
      style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize, color: ColorConstants.black),
      onChanged: (String? value) {
        if (value != "") {
          field.didChange(value);
        } else {
          field.reset();
        }
      },
      inputFormatters: [],
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.grey, fontSize: Theme.of(Get.context!).textTheme.headlineSmall!.fontSize),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
        border: OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
        errorText: field!.errorText,
        suffixIcon: isPassword
            ? IconButton(
                splashRadius: 1, onPressed: obscureTextShowFunc, icon: Icon(obscureTextShow ? Feather.eye : Feather.eye_off, color: ColorConstants.black.withValues(alpha: 0.5)))
            : const SizedBox(),
      ),
      obscureText: obscureTextShow,
    );
  }

  static dynamicTextField(
      {TextEditingController? controller,
      int maxLines = 1,
      int? maxCharacter,
      bool readOnly = false,
      bool showCursor = true,
      FocusNode? focusNode,
      TextInputType? textInputType,
      TextInputAction? textInputAction,
      List<TextInputFormatter>? inputFormatters,
      bool fieldEnable = true,
      bool? isDense,
      String? hintText,
      String? helperText,
      Color? helperColor,
      bool isError = false,
      FormFieldState<dynamic>? field,
      bool hasIcon = false,
      IconData? setIcon,
      void Function()? onPressIcon,
      void Function()? onTap,
      void Function()? onEditingComplete,
      void Function(String value)? onChange}) {
    return TextField(
        controller: controller,
        cursorColor: Colors.black,
        maxLines: maxLines,
        maxLength: maxCharacter,
        readOnly: readOnly,
        showCursor: showCursor,
        focusNode: focusNode,
        keyboardType: !showCursor ? TextInputType.none : textInputType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        style: Theme.of(Get.context!)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4, color: ColorConstants.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            enabled: fieldEnable,
            isDense: isDense,
            filled: true,
            fillColor: (readOnly && inputFormatters == null) ? Colors.grey[350] : Colors.white,
            helperText: helperText,
            helperStyle: TextStyle(color: helperColor, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
            hintText: hintText,
            hintStyle: TextStyle(color: readOnly ? ColorConstants.white : ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent),
                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent),
                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent),
                borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
            errorBorder: isError == true
                ? OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius))
                : OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
            errorText: field?.errorText,
            suffixIcon: hasIcon ? IconButton(splashRadius: 1, icon: Icon(setIcon, color: ColorConstants.black.withValues(alpha: 0.5)), onPressed: onPressIcon) : null),
        onTap: onTap,
        onEditingComplete: onEditingComplete,
        onTapOutside: (event) => Keyboard.close(),
        onChanged: (String value) {
          if (value != "") {
            field?.didChange(value);
          } else {
            field?.reset();
          }

          onChange != null ? onChange(value) : null;
        });
  }

  static discrepancyAdditionalTextFields(
      {FormFieldState<dynamic>? field,
      TextEditingController? controller,
      int? maxLines,
      int? maxCharacter,
      bool counterText = true,
      bool enableTitle = true,
      String? title,
      void Function()? onTap,
      void Function(String value)? onChange,
      void Function()? onPressedPlus,
      void Function()? onPressedMinimized,
      bool borderColor = false,
      TextInputType keyboardType = const TextInputType.numberWithOptions(decimal: true, signed: false),
      bool showSuffixIcon = false,
      bool readOnly = false,
      bool showCursor = true,
      String hintText = "",
      String? helperText,
      bool isPassword = false,
      bool obscureTextShow = false,
      void Function()? obscureTextShowFunc,
      bool fieldEnable = true}) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (enableTitle)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(title ?? "",
                  textAlign: TextAlign.start, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.bold)),
            ),
          if (enableTitle == false) const SizedBox(height: 5),
          TextField(
            controller: controller,
            cursorColor: Colors.black,
            maxLines: isPassword ? 1 : maxLines,
            maxLength: maxCharacter,
            readOnly: readOnly,
            showCursor: showCursor,
            obscureText: obscureTextShow,
            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                  color: ColorConstants.text,
                  fontWeight: FontWeight.normal,
                  fontSize: SizeConstants.fontSizes(type: SizeConstants.button) - 2,
                ),
            keyboardType: keyboardType,
            onChanged: (String value) {
              if (value != "") {
                field!.didChange(value);
              } else {
                field!.reset();
              }
              onChange != null ? onChange(value) : null;
            },
            onTap: onTap,
            decoration: InputDecoration(
              enabled: fieldEnable,
              filled: true,
              fillColor: Colors.white,
              helperText: helperText,
              counterText: counterText != true ? "" : null,
              helperStyle: TextStyle(color: ColorConstants.grey, fontSize: SizeConstants.fontSizes(type: SizeConstants.button) - 2),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor != true ? ColorConstants.black : ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor != true ? ColorConstants.black : ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor != true ? ColorConstants.black : ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
              errorText: field?.errorText,
              hintText: hintText,
              hintStyle: TextStyle(color: ColorConstants.grey, fontSize: SizeConstants.fontSizes(type: SizeConstants.button) - 2),
              suffixIcon: showSuffixIcon
                  ? isPassword
                      ? IconButton(
                          //alignment: Alignment.bottomRight,
                          splashRadius: 5,
                          onPressed: obscureTextShowFunc,
                          icon: Icon(
                            size: 18,
                            obscureTextShow ? Feather.eye : Feather.eye_off,
                            color: ColorConstants.black.withValues(alpha: 0.5),
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                //alignment: Alignment.bottomRight,
                                splashRadius: 5,
                                onPressed: onPressedPlus,
                                icon: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: ColorConstants.black.withValues(alpha: 0.5),
                                )),
                            IconButton(
                                //alignment: Alignment.bottomRight,
                                splashRadius: 5,
                                onPressed: onPressedMinimized,
                                icon: Icon(
                                  Icons.minimize,
                                  size: 18,
                                  color: ColorConstants.black.withValues(alpha: 0.5),
                                )),
                          ],
                        )
                  : null,
            ),
          ),
        ],
      );
    });
  }
}
