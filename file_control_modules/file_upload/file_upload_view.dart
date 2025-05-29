// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../shared/services/keyboard.dart';
import 'file_upload/file_upload_mobile.dart';
import 'file_upload/file_upload_tablet.dart';

class FileUploadPage extends StatelessWidget {
  const FileUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Keyboard.close(context: context),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => ScreenTypeLayout.builder(
            mobile: (context) => OrientationLayoutBuilder(
                  portrait: (context) => FileUploadMobilePortrait(),
                  landscape: (context) => DocumentsUploadMobileLandscape(),
                ),
            tablet: (context) => OrientationLayoutBuilder(
                  portrait: (context) => FileUploadTablet(),
                  landscape: (context) => FileUploadTablet(),
                )),
      ),
    );
  }
}
