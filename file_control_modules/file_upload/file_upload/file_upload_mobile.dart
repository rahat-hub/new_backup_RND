import 'package:aviation_rnd/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../file_upload_logic.dart';

class FileUploadMobilePortrait extends GetView<FileUploadLogic> {
  const FileUploadMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileUploadLogic>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop) {
          controller.routeChangeFunction();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: Get.context!,
          title: Get.parameters["headerTitle"] ?? "Documents Upload",
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () {
            controller.routeChangeFunction();
          },
        ),
        body: SafeArea(child: controller.documentsUploadMobileView()),
      ),
    );
  }
}

class DocumentsUploadMobileLandscape extends GetView<FileUploadLogic> {
  const DocumentsUploadMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileUploadLogic>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        EasyLoading.dismiss();
        if (!didPop) {
          controller.routeChangeFunction();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppbarConstant.customAppBar(
          context: Get.context!,
          title: Get.parameters["headerTitle"] ?? "Documents Upload",
          centerTitle: true,
          menuEnable: false,
          actionEnable: false,
          backButtonEnable: true,
          backTap: () {
            controller.routeChangeFunction();
          },
        ),
        body: SafeArea(child: controller.documentsUploadMobileView()),
      ),
    );
  }
}
