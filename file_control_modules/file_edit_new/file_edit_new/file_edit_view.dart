import 'package:aviation_rnd/modules/file_control_modules/file_edit_new/file_edit_new/view_page_file_edit_new.dart';
import 'package:aviation_rnd/modules/file_control_modules/file_edit_new/file_edit_new_logic.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/utils/file_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../../helper/loader_helper.dart';
import '../../../../widgets/appbar.dart';
import '../../../../widgets/file_edit_new_widgets.dart';

class FileEditNewViewPage extends GetView<FileEditNewLogic> {
  const FileEditNewViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FileEditNewLogic>();

    return Obx(() {
      return controller.isLoading.isFalse
          ? PopScope(
              onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
              child: Scaffold(
                  appBar: AppbarConstant.customAppBar(context: context, title: controller.appVarTitle, backTap: () => Get.back()),
                  body: SafeArea(
                    child: Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 5.0,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                runSpacing: 5.0,
                                spacing: 10.0,
                                children: [
                                  FileEditNewMaterialButton(
                                    icon: MaterialCommunityIcons.file_pdf,
                                    borderColor: ColorConstants.primary,
                                    buttonText: 'View File',
                                    onPressed: () async {
                                      await FileControl.getPathAndViewFile(fileId: controller.fileId, fileName: Get.parameters['text'].toString());
                                    },
                                  ),
                                  FileEditNewMaterialButton(
                                    icon: MaterialCommunityIcons.chart_pie,
                                    borderColor: ColorConstants.primary,
                                    buttonText: 'View Compliance',
                                    onPressed: () async {
                                      await controller.viewFlightOpsDocumentViewComplianceDialog();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: FileEditNewPageViewCode(controller: controller),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                runSpacing: 5.0,
                                spacing: 10.0,
                                children: [
                                  FileEditNewMaterialButton(
                                    icon: MaterialCommunityIcons.delete,
                                    iconColor: ColorConstants.white,
                                    buttonColor: ColorConstants.red,
                                    buttonText: 'Delete This Item',
                                    buttonTextColor: ColorConstants.white,
                                    onPressed: () async {
                                      controller.fileDeleteDialogView();
                                    },
                                  ),
                                  FileEditNewMaterialButton(
                                    icon: MaterialCommunityIcons.content_save_all,
                                    borderColor: ColorConstants.primary,
                                    buttonText: 'Update Flight Ops Item',
                                    onPressed: () async {
                                      LoaderHelper.loaderWithGif();
                                      await controller.fileEditUpdateApiCall();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            )
          : const SizedBox();
    });
  }
}
