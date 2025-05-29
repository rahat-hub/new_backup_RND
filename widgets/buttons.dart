import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/constants/constant_colors.dart';

abstract class ButtonConstant {
  static buttonWidgetSingle({void Function()? onTap, String? title, bool isLoadingLoggingIn = false, double height = 45.0}) {
    return SizedBox(
      height: height,
      child: Material(
        elevation: 4.0,
        color: ColorConstants.primary,
        borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
        child: InkWell(
          onTap: onTap,
          child: Center(
              child: !isLoadingLoggingIn
                  ? Text(
                      title ?? "",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.white),
                    )
                  : const CupertinoActivityIndicator(
                      color: Colors.white,
                      animating: true,
                    )),
        ),
      ),
    );
  }

  static buttonWidgetSingleWithIcon({void Function()? onTap, IconData? icon, String? iconImage, double? iconSize, double height = 45.0, bool customImageIcon = false}) {
    return SizedBox(
      height: height,
      width: Get.width,
      child: Material(
        color: ColorConstants.primary,
        borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
        child: InkWell(
          onTap: onTap,
          child: customImageIcon
              ? Center(child: ImageIcon(AssetImage(iconImage ?? ""), color: ColorConstants.white, size: iconSize))
              : Center(child: Icon(icon, color: ColorConstants.white, size: iconSize)),
        ),
      ),
    );
  }

  static buttonWidgetSingleDynamicWidthWithIcon(
      {void Function()? onTap,
      String? title,
      bool isLoadingLoggingIn = false,
      IconData? icon,
      bool iconShow = false,
      bool centerTitle = false,
      Color color = ColorConstants.primary}) {
    return Material(
      color: color,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
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
                    color: ColorConstants.white,
                    size: Theme.of(Get.context!).textTheme.displayMedium!.fontSize,
                  ),
                ),
              !isLoadingLoggingIn
                  ? Text(
                      title ?? "",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.white),
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

  static addButtonWidgetSingleDynamicWidthWithIcon(
      {void Function()? onTap,
      String? title,
      bool isLoadingLoggingIn = false,
      double? width,
      IconData? icon,
      bool iconShow = false,
      bool centerTitle = false,
      Color color = Colors.black54}) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: width!),
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
            if (iconShow) Icon(icon, color: ColorConstants.white, size: 24),
            !isLoadingLoggingIn
                ? Text(title ?? "",
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium!
                        .copyWith(overflow: TextOverflow.ellipsis, fontSize: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize!, color: ColorConstants.white))
                : const CupertinoActivityIndicator(color: Colors.white, animating: true),
          ]),
        ),
      ),
    );
  }

  static dialogButton(
      {void Function()? onTapMethod,
      String? title,
      bool enableIcon = false,
      IconData? iconData,
      Color textColor = ColorConstants.white,
      Color iconColor = ColorConstants.background,
      bool textSizeEnable = false,
      double? textSize,
      Color btnColor = ColorConstants.primary,
      Color borderColor = Colors.transparent}) {
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
            child: enableIcon
                ? Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(iconData, color: iconColor, size: 24),
                    const SizedBox(width: SizeConstants.contentSpacing - 3),
                    Flexible(child: TextWidget(text: title.toString(), color: textColor, size: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize))
                  ])
                : Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: TextWidget(
                  text: title.toString(),
                  textAlign: TextAlign.center,
                  color: textColor,
                  size: textSizeEnable ? textSize : Theme
                      .of(Get.context!)
                      .textTheme
                      .headlineMedium!
                      .fontSize),
            ),
          ),
        ));
  }

  static customMaterialButton(
      {String? buttonText,
      double? buttonTextSize,
      Color? buttonTextColor,
      double? buttonWidth,
      double? buttonHeight,
      Color? buttonColor,
      String? buttonShape,
      Color? borderColor,
      IconData? icon,
      Color? iconColor,
      double? lrPadding,
      double? udPadding,
      double? lrMargin,
      double? udMargin,
      void Function()? onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: lrPadding ?? 0.0, vertical: udPadding ?? 0.0),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: buttonWidth ?? double.minPositive,
          height: buttonHeight,
          padding: EdgeInsets.symmetric(horizontal: lrMargin ?? 10.0, vertical: udMargin ?? 0.0),
          color: buttonColor ?? Colors.white,
          shape: buttonShape?.toLowerCase() == "circle"
              ? const CircleBorder()
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (icon != null)
                Icon(icon,
                    color: iconColor ?? ((buttonColor == null || buttonColor == Colors.white) ? Colors.blue[700] : Colors.white),
                    size: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize! + 3),
              if (buttonText != null)
                Text(buttonText,
                    style: Theme.of(Get.context!).textTheme.headlineMedium?.copyWith(
                        color: buttonTextColor ?? ((buttonColor == null || buttonColor == Colors.white) ? Colors.blue[700] : Colors.white),
                        fontSize: buttonTextSize,
                        letterSpacing: 0.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true),
            ],
          ),
        ),
      ),
    );
  }
}
