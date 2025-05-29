// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'file_view/file_view_mobile.dart';
import 'file_view/file_view_tablet.dart';
import 'file_view_logic.dart';

class FileViewPage extends GetView<FileViewLogic> {
  const FileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileViewLogic>();

    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
              portrait: (context) => FileViewMobilePortrait(),
              landscape: (context) => FileViewerMobileLandscape(),
            ),
            tablet: (context) => OrientationLayoutBuilder(
              portrait: (context) => FileViewTablet(),
              landscape: (context) => FileViewTablet(),
            ),
          );
        },
      ),
    );
  }
}
