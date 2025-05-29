import 'dart:ui';

import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:text_scroll/text_scroll.dart';

import '../shared/services/theme_color_mode.dart';

abstract class MaintenanceWidgetConstant {
  static maintenanceCustomDropdown(
      {bool showTitle = false,
      String? title,
      String hintText = "",
      double height = 65.5,
      double? itemHeight,
      List? data,
      bool? borderColor,
      String? key,
      String? helperText,
      Color? helperColor,
      bool borderHide = true,
      void Function(dynamic value)? onChanged}) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "$title",
                    style: TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3),
                  ),
                )
              : const SizedBox(),
          Container(
            height: height,
            width: Get.width,
            decoration: BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
              border: borderColor != true ? Border.all(color: ThemeColorMode.isLight ? ColorConstants.black : Colors.transparent) : Border.all(color: ColorConstants.red),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DropdownButton<dynamic>(
              icon: Icon(Icons.keyboard_arrow_down, color: ColorConstants.black, size: Theme.of(context).textTheme.displayMedium!.fontSize!),
              iconEnabledColor: ColorConstants.black,
              iconDisabledColor: ColorConstants.black,
              hint: Padding(
                padding: const EdgeInsets.only(
                  left: SizeConstants.contentSpacing,
                ),
                child: hintText.length >= 15
                    ? TextScroll(
                        hintText,
                        velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                        delayBefore: const Duration(milliseconds: 1500),
                        numberOfReps: 5,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 5, color: ColorConstants.black, fontWeight: FontWeight.w500),
                      )
                    : Text(
                        hintText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 5, color: ColorConstants.black, fontWeight: FontWeight.w500),
                      ),
              ),
              menuMaxHeight: Get.height - 200,
              itemHeight: itemHeight,
              underline: const SizedBox(),
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              dropdownColor: ColorConstants.white,
              isDense: false,
              items: data?.map((value) {
                return DropdownMenuItem<dynamic>(
                    value: value,
                    child: Column(
                      children: [
                        const SizedBox(height: SizeConstants.contentSpacing),
                        value[key].length >= 30
                            ? TextScroll(
                                "${value[key]}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.black, fontWeight: FontWeight.w500),
                              )
                            : Text(
                                "${value[key]}",
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.black, fontWeight: FontWeight.w500),
                              ),
                        const SizedBox(height: SizeConstants.contentSpacing),
                        if (borderHide) const DottedLine(direction: Axis.horizontal, lineThickness: 1),
                      ],
                    ));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 5),
          helperText != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text(
                    helperText,
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize, color: helperColor, fontWeight: FontWeight.w100),
                  ),
                )
              : const SizedBox(),
        ],
      );
    });
  }

  static ataCodeDialogView({required Map ataCodeData, required Map ataFieldExpand, required TextEditingController ataCodeTextController}) {
    return showDialog(
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
                    const Center(child: Text("ATA Code", textAlign: TextAlign.center, style: TextStyle(fontSize: 40))),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: ataCodeData["ataChapterData"].length,
                        shrinkWrap: true,
                        itemBuilder: (context, chapterItem) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  ataFieldExpand[chapterItem] = !ataFieldExpand[chapterItem];
                                },
                                child: Column(
                                  children: [
                                    Text(ataCodeData["ataChapterData"][chapterItem]["chapterTitle"],
                                        textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                                    Text(ataCodeData["ataChapterData"][chapterItem]["chapterDescription"],
                                        textAlign: TextAlign.justify, style: const TextStyle(fontSize: 14, letterSpacing: 0.8, fontWeight: FontWeight.w200))
                                  ],
                                ),
                              ),
                              Obx(() {
                                return ataFieldExpand[chapterItem] != false
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: ataCodeData["ataChapterData"][chapterItem]["ataSectionData"].length,
                                        itemBuilder: (context, sectionItem) {
                                          return InkWell(
                                            onTap: () {
                                              ataCodeTextController.text = ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                              //filterDataApiCall["ataCode"] = ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                              Get.back();
                                            },
                                            child: Column(
                                              children: [
                                                Text(ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["sectionTitle"].toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(fontSize: 16, color: Colors.blue, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                                                Text(ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["sectionDescription"].toString(),
                                                    textAlign: TextAlign.justify, style: const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.w200))
                                              ],
                                            ),
                                          );
                                        })
                                    : const SizedBox();
                              })
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ButtonConstant.dialogButton(
                        title: "Cancel",
                        borderColor: ColorConstants.grey,
                        onTapMethod: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        width: SizeConstants.contentSpacing + 10,
                      ),
                    ])
                  ],
                ),
              ),
            ),
          );
        });
  }
}
