import 'dart:ui';

import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/provider/forms_api_provider.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

import '../../../../helper/snack_bar_helper.dart';
import '../../../../widgets/form_widgets.dart';
import '../fill_out_form_logic.dart';

class TopBottomLayers {
  Widget topLayerCard(FillOutFormLogic controller, context) {
    var showMore = false.obs;
    Get.find<FillOutFormLogic>;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: Colors.blue[300],
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child:
              DeviceType.isTablet
                  ? Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("User: ${controller.formEditData["userName"]}", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                      Wrap(
                        children: [
                          Text("Status: ", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                          !(controller.formEditData["completed"] ?? false)
                              ? Material(
                                color: ColorConstants.primary,
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "In Progress",
                                    style: TextStyle(
                                      color: ColorConstants.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                                    ),
                                  ),
                                ),
                              )
                              : Material(
                                color: ColorConstants.text,
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Completed At ${controller.formEditData["completedAt"]}",
                                    style: TextStyle(
                                      color: ColorConstants.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      Text(
                        "Created at: ${controller.formEditData["createdAt"] /*DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now)*/}",
                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                      ),
                      Obx(() {
                        return Text(
                          controller.lastSave.value != "" ? "Last Save: ${controller.lastSave.value}" : "Last Save: --:--",
                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                        );
                      }),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            return Text(
                              controller.lastSave.value != "" ? "Last Save: ${controller.lastSave.value}" : "Last Save: --:--",
                              style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                            );
                          }),
                          Obx(() {
                            return InkWell(
                              onTap: () {
                                showMore.value = !showMore.value;
                              },
                              child:
                                  showMore.value
                                      ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Show Less", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                                          Icon(
                                            Icons.arrow_upward,
                                            color: ThemeColorMode.isLight ? ColorConstants.white : ColorConstants.black,
                                            size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3,
                                          ),
                                        ],
                                      )
                                      : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Show More", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                                          Icon(
                                            Icons.arrow_downward,
                                            color: ThemeColorMode.isLight ? ColorConstants.white : ColorConstants.black,
                                            size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3,
                                          ),
                                        ],
                                      ),
                            );
                          }),
                        ],
                      ),
                      Obx(() {
                        return showMore.value
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("User: ${controller.formEditData["userName"]}", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                                Wrap(
                                  children: [
                                    Text("Status: ", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                                    !(controller.formEditData["completed"] ?? false)
                                        ? Material(
                                          color: ColorConstants.primary,
                                          borderRadius: BorderRadius.circular(5),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                              "In Progress",
                                              style: TextStyle(
                                                color: ColorConstants.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                                              ),
                                            ),
                                          ),
                                        )
                                        : Material(
                                          color: ColorConstants.text,
                                          borderRadius: BorderRadius.circular(5),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                              "Completed At ${controller.formEditData["completedAt"]}",
                                              style: TextStyle(
                                                color: ColorConstants.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                                Text(
                                  "Created at: ${controller.formEditData["createdAt"] /*DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now)*/}",
                                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                                ),
                              ],
                            )
                            : const SizedBox();
                      }),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget formAttachmentCard(FillOutFormLogic controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: Colors.blue[400],
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Text(
                      "Attachments: (${controller.formAttachmentFiles.length})",
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.white),
                    );
                  }),
                  Text("Save Form To Add Attachments", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.white)),
                ],
              ),
              if ((controller.formEditData["allowAttachments"] ?? false) && controller.formAttachmentFiles.isNotEmpty)
                Obx(() {
                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 5.0),
                    shrinkWrap: true,
                    itemCount: controller.formAttachmentFiles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          Get.width > 480
                              ? Get.width > 980
                                  ? 5
                                  : 3
                              : 1,
                      mainAxisExtent: 30.0,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    ),
                    itemBuilder:
                        (context, index) => Row(
                          children: [
                            GeneralMaterialButton(
                              buttonText: "Attachment ${index + 1}",
                              icon:
                                  FileControl.fileType(fileName: controller.formAttachmentFiles[index]["fileName"]) == "image"
                                      ? Icons.image
                                      : FileControl.fileType(fileName: controller.formAttachmentFiles[index]["fileName"]) == "pdf"
                                      ? Icons.picture_as_pdf
                                      : FileControl.fileType(fileName: controller.formAttachmentFiles[index]["fileName"]) == "document"
                                      ? Icons.text_snippet
                                      : Icons.file_present,
                              onPressed: () async {
                                await FileControl.getPathAndViewFile(
                                  fileId: controller.formAttachmentFiles[index]["id"].toString(),
                                  fileName: controller.formAttachmentFiles[index]["id"].toString(),
                                );
                              },
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0.0),
                              splashRadius: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! + 5,
                              icon: Icon(Icons.delete_forever, color: ColorConstants.red, size: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! + 5),
                              onPressed: () async {
                                return showDialog<void>(
                                  useSafeArea: true,
                                  useRootNavigator: false,
                                  barrierDismissible: true,
                                  context: Get.context!,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                          child: AlertDialog(
                                            backgroundColor: Theme.of(context).colorScheme.surface,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                              side:
                                                  ThemeColorMode.isLight
                                                      ? const BorderSide(color: ColorConstants.primary, width: 2)
                                                      : const BorderSide(color: ColorConstants.primary),
                                            ),
                                            title: Center(child: Text("Confirm Form Attachment Delete (Attachment ${index + 1})")),
                                            titleTextStyle: TextStyle(
                                              fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                            ),
                                            content: Row(
                                              children: [
                                                Icon(Icons.delete_forever_outlined, size: Theme.of(context).textTheme.displayMedium!.fontSize! + 3, color: Colors.red),
                                                const SizedBox(width: 10),
                                                const Flexible(child: Text("Are You Sure, Want To Delete?")),
                                              ],
                                            ),
                                            contentTextStyle: TextStyle(
                                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! + 3,
                                              fontWeight: FontWeight.bold,
                                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                            ),
                                            actions: [
                                              Material(
                                                color: ColorConstants.primary,
                                                elevation: 10,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                                  side: const BorderSide(color: ColorConstants.red),
                                                ),
                                                child: InkWell(
                                                  onTap: () => Get.back(),
                                                  borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                                    child: Text(
                                                      "Cancel Delete",
                                                      style: TextStyle(
                                                        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorConstants.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Material(
                                                color: ColorConstants.red,
                                                elevation: 10,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                                  side: const BorderSide(color: Colors.transparent),
                                                ),
                                                child: InkWell(
                                                  onTap: () async {
                                                    LoaderHelper.loaderWithGif();
                                                    Response response = await FormsApiProvider().deleteFormAttachment(
                                                      formId: controller.fillOutFormAllData["formId"].toString(),
                                                      fileId: controller.formAttachmentFiles[index]["id"].toString(),
                                                    );
                                                    Get.back();
                                                    if (response.statusCode == 200 && response.data["isSuccess"] == true) {
                                                      controller.dataModified = true;
                                                      SnackBarHelper.openSnackBar(
                                                        isError: false,
                                                        title: "Success",
                                                        message: "Form Attachment ${index + 1} Deleted From Form (ID: ${controller.fillOutFormAllData["formId"]})",
                                                      );
                                                      controller.formAttachmentFiles.removeWhere((element) => element["id"] == controller.formAttachmentFiles[index]["id"]);
                                                    } else {
                                                      SnackBarHelper.openSnackBar(isError: true, title: "Error", message: "Unable to Delete The File!");
                                                    }
                                                    EasyLoading.dismiss();
                                                  },
                                                  borderRadius: BorderRadius.circular(SizeConstants.buttonRadius),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                                    child: Text(
                                                      "Confirm Delete",
                                                      style: TextStyle(
                                                        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorConstants.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> bottomNavigationBar(FillOutFormLogic controller, context) {
    Get.find<FillOutFormLogic>;
    List<Widget> bottomNavigationBarWidgets = <Widget>[
      GeneralMaterialButton(
        buttonText: "Save Form",
        icon: Icons.save,
        buttonColor: ColorConstants.button,
        lrPadding: DeviceType.isMobile ? 5.0 : 0.0,
        onPressed: () async {
          var emptyFields = [];
          var remainingRequiredFields = controller.requiredFields.where((fieldId) {
            var valueNotFound = false;
            switch (controller.values[fieldId]) {
              case "":
              case "null":
              case null:
                if (controller.showField[fieldId] != false) {
                  valueNotFound = true;
                  emptyFields.add(fieldId);
                }
                break;
              default:
                valueNotFound = false;
                break;
            }
            return valueNotFound;
          });

          if (remainingRequiredFields.isNotEmpty) {
            if (controller.fieldsPositions[emptyFields[0].toString()] != null) {
              FormWidgets.formDialogBox(
                context: context,
                dialogTitle: "The Following Errors Have Been Found",
                titleColor: ColorConstants.red,
                cancelButtonIcon: Icons.check_circle_outline,
                cancelButtonBorderColor: ColorConstants.white,
                onCancelButton: () async {
                  Keyboard.close();
                  await Future.delayed(const Duration(milliseconds: 500));
                  controller.tabController.value.index = controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!;
                  controller.tabController.refresh();
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (DeviceType.isMobile) {
                    controller.itemScrollController[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].jumpTo(
                      index: controller.fieldsPositions[emptyFields[0].toString()]!["row"]!,
                    );
                  } else {
                    controller.itemScrollController[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].scrollTo(
                      index: controller.fieldsPositions[emptyFields[0].toString()]!["row"]!,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                    );
                  }

                  /*for (var eachTab in controller.formValidationKey) {
                        eachTab.currentState?.fields.updateAll((key, value) {
                          if (controller.values[key.toString()] != null) {
                            value.didChange(controller.values[key.toString()]);
                          }
                          return value;
                        });
                        eachTab.currentState?.saveAndValidate();
                      }*/
                  controller.formValidationKey[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].currentState?.fields.updateAll((key, value) {
                    if (controller.values[key.toString()] != null) {
                      value.didChange(controller.values[key.toString()]);
                    }
                    return value;
                  });
                  controller.formValidationKey[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].currentState?.saveAndValidate();
                  await Future.delayed(const Duration(seconds: 1), () {
                    controller.fillOutFocusNodes[emptyFields[0].toString()]?.requestFocus();
                  });
                  await Future.delayed(const Duration(milliseconds: 500), () {
                    controller.update();
                  });
                },
                children: [
                  const Text(
                    "Please Verify That All Required Fields Have Been Completed,\nRequired Fields Are Highlighted With Red Star(*) Mark.",
                    style: TextStyle(color: ColorConstants.primary),
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Remaining Required Fields*:", style: TextStyle(color: ColorConstants.red)),
                  for (var fieldID in remainingRequiredFields) errorFields(controller, fieldID: fieldID.toString()),
                ],
              );
            } else {
              FormWidgets.formDialogBox(
                context: context,
                dialogTitle: "The Following Errors Have Been Found",
                titleColor: ColorConstants.red,
                cancelButtonIcon: Icons.check_circle_outline,
                cancelButtonBorderColor: ColorConstants.white,
                children: [
                  const Text(
                    "Please Verify That All Required Fields Have Been Completed,\nRequired Fields Are Highlighted With Red Star(*) Mark.",
                    style: TextStyle(color: ColorConstants.primary),
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Remaining Required Fields*:", style: TextStyle(color: ColorConstants.red)),
                  for (var fieldID in remainingRequiredFields) errorFields(controller, fieldID: fieldID.toString()),
                ],
              );
            }
          } else {
            controller.values["PerformCloseOut"] = "No";
            await controller.checkForm(doSave: true, fieldId: null);
          }
        },
      ),
      GeneralMaterialButton(
        buttonText: "Delete Form",
        icon: Icons.delete,
        buttonColor: ColorConstants.red,
        lrPadding: DeviceType.isMobile ? 5.0 : 0.0,
        onPressed: () async {
          controller.deleteFillOutForm(id: controller.fillOutFormAllData["formId"], formName: controller.fillOutFormAllData["formName"]);
        },
      ),
      if (controller.formEditData["showSaveAndCompleteButton"] ?? false)
        GeneralMaterialButton(
          buttonText: "Save & Submit ${controller.formName.value}",
          icon: Icons.save,
          buttonColor: ColorConstants.button,
          lrPadding: DeviceType.isMobile ? 5.0 : 0.0,
          onPressed: () async {
            var emptyFields = [];
            var remainingRequiredFields = controller.requiredFields.where((fieldId) {
              var valueNotFound = false;
              switch (controller.values[fieldId]) {
                case "":
                case "null":
                case null:
                  if (controller.showField[fieldId] != false) {
                    valueNotFound = true;
                    emptyFields.add(fieldId);
                  }
                  break;
                default:
                  valueNotFound = false;
                  break;
              }
              return valueNotFound;
            });

            if (remainingRequiredFields.isNotEmpty) {
              if (controller.fieldsPositions[emptyFields[0].toString()] != null) {
                FormWidgets.formDialogBox(
                  context: context,
                  dialogTitle: "The Following Errors Have Been Found",
                  titleColor: ColorConstants.red,
                  cancelButtonIcon: Icons.check_circle_outline,
                  cancelButtonBorderColor: ColorConstants.white,
                  onCancelButton: () async {
                    Keyboard.close();
                    await Future.delayed(const Duration(milliseconds: 500));
                    controller.tabController.value.index = controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!;
                    controller.tabController.refresh();
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (DeviceType.isMobile) {
                      controller.itemScrollController[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].jumpTo(
                        index: controller.fieldsPositions[emptyFields[0].toString()]!["row"]!,
                      );
                    } else {
                      controller.itemScrollController[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].scrollTo(
                        index: controller.fieldsPositions[emptyFields[0].toString()]!["row"]!,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                    controller.formValidationKey[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].currentState?.fields.updateAll((key, value) {
                      if (controller.values[key.toString()] != null) {
                        value.didChange(controller.values[key.toString()]);
                      }
                      return value;
                    });
                    controller.formValidationKey[controller.fieldsPositions[emptyFields[0].toString()]!["tab"]!].currentState?.saveAndValidate();
                    await Future.delayed(const Duration(seconds: 1), () {
                      controller.fillOutFocusNodes[emptyFields[0].toString()]?.requestFocus();
                    });
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      controller.update();
                    });
                  },
                  children: [
                    const Text(
                      "Please Verify That All Required Fields Have Been Completed,\nRequired Fields Are Highlighted With Red Star(*) Mark.",
                      style: TextStyle(color: ColorConstants.primary),
                    ),
                    const SizedBox(height: 10.0),
                    const Text("Remaining Required Fields*:", style: TextStyle(color: ColorConstants.red)),
                    for (var fieldID in remainingRequiredFields) errorFields(controller, fieldID: fieldID.toString()),
                  ],
                );
              } else {
                FormWidgets.formDialogBox(
                  context: context,
                  dialogTitle: "The Following Errors Have Been Found",
                  titleColor: ColorConstants.red,
                  cancelButtonIcon: Icons.check_circle_outline,
                  cancelButtonBorderColor: ColorConstants.white,
                  children: [
                    const Text(
                      "Please Verify That All Required Fields Have Been Completed,\nRequired Fields Are Highlighted With Red Star(*) Mark.",
                      style: TextStyle(color: ColorConstants.primary),
                    ),
                    const SizedBox(height: 10.0),
                    const Text("Remaining Required Fields*:", style: TextStyle(color: ColorConstants.red)),
                    for (var fieldID in remainingRequiredFields) errorFields(controller, fieldID: fieldID.toString()),
                  ],
                );
              }
            } else {
              controller.values["PerformCloseOut"] = "Yes";
              await controller.checkForm(doSave: true, fieldId: null);
            }
          },
        ),
    ];
    return bottomNavigationBarWidgets;
  }

  Widget errorFields(FillOutFormLogic controller, {required String fieldID}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Page Name: ${controller.fieldIDsWithName[fieldID][0] ?? ""}",
          style: TextStyle(
            fontSize: Theme.of(Get.context!).textTheme.bodyMedium?.fontSize,
            fontWeight: FontWeight.w600,
            color: ThemeColorMode.isLight ? ColorConstants.black : ColorConstants.white,
          ),
        ),
        RichText(
          textScaler: TextScaler.linear(Get.textScaleFactor),
          text: TextSpan(
            text: "Field Name: ${controller.fieldIDsWithName[fieldID][1] ?? " "}",
            style: TextStyle(
              fontSize: Theme.of(Get.context!).textTheme.titleLarge?.fontSize,
              fontWeight: FontWeight.w600,
              color: ThemeColorMode.isLight ? ColorConstants.black : ColorConstants.white,
            ),
            children: const [TextSpan(text: "*", style: TextStyle(color: ColorConstants.red))],
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
