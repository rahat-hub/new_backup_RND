import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../widgets/appbar.dart';
import '../file_view_logic.dart';

class FileViewMobilePortrait extends GetView<FileViewLogic> {
  const FileViewMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileViewLogic>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: Get.context!,
          title: "View: ${Get.parameters["fileType"]?.toUpperCase()}",
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () => Get.back(),
        ),
        body: SafeArea(
          child: Obx(
            () {
              return controller.isLoading.isFalse ? controller.viewFile() : const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class FileViewerMobileLandscape extends GetView<FileViewLogic> {
  const FileViewerMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileViewLogic>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: Get.context!,
          title: "View: ${Get.parameters["fileType"]?.toUpperCase()}",
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () => Get.back(),
        ),
        body: SafeArea(
          child: Obx(
            () {
              return controller.isLoading.isFalse ? controller.viewFile() : const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
