// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'file_edit_new/file_edit_view.dart';
import 'file_edit_new_logic.dart';

class FileEditNewPage extends StatelessWidget {
  const FileEditNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileEditNewLogic>();
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
          mobile: (context) => OrientationLayoutBuilder(
            portrait: (context) => FileEditNewViewPage(),
            landscape: (context) => FileEditNewViewPage(),
          ),
          tablet: (context) => OrientationLayoutBuilder(
            portrait: (context) => FileEditNewViewPage(),
            landscape: (context) => FileEditNewViewPage(),
          ),
        ),
      ),
    );
  }
}
