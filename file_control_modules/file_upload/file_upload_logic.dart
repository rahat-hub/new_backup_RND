import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_logic.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:aviation_rnd/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../provider/api_provider.dart';
import '../../../widgets/weight_and_balance_widgets.dart';

class FileUploadLogic extends GetxController {
  final Dio api = ApiProvider.api;

  var fileLoadPath = ''.obs;

  var fileName = ''.obs;

  var fileType = ''.obs;

  late File fileImage;

  var fileTypeDropdownData = [
    {"id": 0, "name": "Any Supported Files"}, //{"id": 1, "name": "Media"},
    {"id": 2, "name": "All Supported Images"}, //{"id": 3, "name": "Video"},
    //{"id": 4, "name": "Audio"},
    {"id": 5, "name": "All Supported Documents"},
  ];

  var replaceView = false.obs;

  var uploadIndicatorShow = false.obs;

  var uploadIndicatorProgress = 0.0.obs;

  final paginationController = NumberPaginatorController();
  var pdfController = Completer<PDFViewController>();
  var pages = 0.obs;
  var currentPage = 0.obs;
  var isReady = false.obs;
  var errorMessage = ''.obs;

  Widget documentsUploadMobileView() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: Column(
            children: [
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              TextWidget(text: "Upload New ${uploadTypeName()}", size: SizeConstants.extraMediumText, weight: FontWeight.w600),
              if (Get.arguments == "Flight Ops")
                const Padding(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0, top: 3.0),
                  child: TextWidget(
                    text:
                        "* Please Upload Flight Ops Documents as PDFs To Ensure Users Are Able To View On Any Device.\nMicrosoft Office type documents will require users to have an installed viewer/editor to open these files.",
                    size: SizeConstants.smallText,
                    weight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: SizeConstants.contentSpacing),
              Obx(
                () => InkWell(
                  onTap:
                      replaceView.value == false
                          ? () async {
                            if (Platform.isIOS) {
                              await iosFilePickerDropDownDialog();
                            } else {
                              await filePicker();
                            }
                          }
                          : null,
                  child: Center(
                    child: DottedBorder(
                      options: RectDottedBorderOptions(color: ColorConstants.primary.withValues(alpha: 0.6), strokeWidth: 1),
                      child:
                          replaceView.value == true
                              ? SizedBox(
                                height: fileType.value == "pdf" && (Platform.isAndroid || Platform.isIOS) ? Get.size.longestSide - 230 : null,
                                width: fileType.value == "pdf" && (Platform.isAndroid || Platform.isIOS) ? Get.size.shortestSide - 20 : null,
                                child: openFiles(fileType.value),
                              )
                              : const SizedBox(height: 200, width: double.infinity, child: Center(child: Text("Press or Tap to Upload Files"))),
                    ),
                  ),
                ),
              ),
              Obx(() => SizedBox(height: replaceView.value ? SizeConstants.contentSpacing : 0)),
              Obx(() => Text(replaceView.value ? fileName.value : "")),
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              Obx(() {
                return uploadIndicatorShow.value != true
                    ? validUploadTypeWidget()
                    : SizedBox(
                      height: 50,
                      width: Get.width,
                      child: LiquidLinearProgressIndicator(
                        value: uploadIndicatorProgress.value / 100,
                        // Defaults to 0.5.
                        valueColor: const AlwaysStoppedAnimation(ColorConstants.button),
                        // Defaults to the current Theme's accentColor.
                        backgroundColor: ColorConstants.black.withValues(alpha: 0.1),
                        // Defaults to the current Theme's backgroundColor.
                        borderColor: ColorConstants.primary,
                        borderWidth: 1.0,
                        borderRadius: 12.0,
                        direction: Axis.horizontal,
                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text("Loading... ${uploadIndicatorProgress.value.toStringAsFixed(2)}"),
                      ),
                    );
              }),
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              Obx(() {
                return replaceView.value
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonConstant.buttonWidgetSingleDynamicWidthWithIcon(
                          title: "Cancel",
                          centerTitle: true,
                          isLoadingLoggingIn: false,
                          color: ColorConstants.red,
                          iconShow: false,
                          onTap: () {
                            replaceView.value = false;
                            fileLoadPath.value = '';
                            fileType.value = '';
                            fileImage.delete();
                            currentPage.value = 0;
                            pdfController = Completer<PDFViewController>();
                          },
                        ),
                        const SizedBox(width: SizeConstants.contentSpacing + 10),
                        ButtonConstant.buttonWidgetSingleDynamicWidthWithIcon(
                          icon: Icons.upload_file,
                          title: "Upload to Cloud",
                          centerTitle: true,
                          isLoadingLoggingIn: false,
                          color: ColorConstants.primary,
                          iconShow: true,
                          onTap: () async {
                            RegExp invalidChars = RegExp(
                              r'[!*#\$%\^&*(){}[]|\\/"'
                              ';:<>?]',
                            );

                            if (invalidChars.hasMatch(fileName.value)) {
                              WBCustomDialog.showDialogBox(
                                dialogTitle: 'File Upload Guidelines',
                                enableWidget: true,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: DeviceType.isTablet ? Get.width / 2.2 : (Get.width - 50.0)),
                                  Card(
                                    color: Colors.amber[100], // Light yellow background
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // Rounded corners
                                    ),
                                    elevation: 3, // Soft shadow effect
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 8.0,
                                        children: [
                                          const Icon(Icons.warning, color: Color(0xFF856404), size: 40),
                                          // Warning icon
                                          const Text(
                                            "Warning",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF856404), // Dark brown color
                                            ),
                                          ),
                                          const Text(
                                            "File name contains special characters, upload not allowed!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF856404)),
                                          ),
                                          Text("Please rename your file and try again.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      text: 'Allowed Characters:\t',
                                      style: TextStyle(
                                        color: const Color(0xFF2D6A3E),
                                        fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 4,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.75,
                                      ),
                                      children: <TextSpan>[const TextSpan(text: "A-Z, a-z, 0-9, ., -, _", style: TextStyle(color: Color(0xFF2D6A3E)))],
                                    ),
                                  ),
                                  RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      text: 'Disallowed Characters:\t',
                                      style: TextStyle(
                                        color: const Color(0xFFA94442),
                                        fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 4,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.75,
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text:
                                              r'!*#\$%\^&*(){}[]|\\/"'
                                              ';:<>?',
                                          style: TextStyle(color: Color(0xFFA94442)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                    child: MaterialButton(
                                      onPressed: () => Get.back(closeOverlays: true),
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      color: ColorConstants.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: ColorConstants.red)),
                                      child: TextWidget(
                                        text: 'Cancel',
                                        color: ColorConstants.black,
                                        weight: FontWeight.w700,
                                        size: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              uploadIndicatorShow.value = true;
                              await fileUploadApiCall();
                            }
                          },
                        ),
                      ],
                    )
                    : const SizedBox();
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget documentsUploadTabletView() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: Column(
            children: [
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              TextWidget(text: "Upload New ${uploadTypeName()}", size: SizeConstants.extraMediumText, weight: FontWeight.w600),
              if (Get.arguments == "Flight Ops")
                const Padding(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0, top: 3.0),
                  child: TextWidget(
                    text:
                        "* Please Upload Flight Ops Documents as PDFs To Ensure Users Are Able To View On Any Device.\nMicrosoft Office type documents will require users to have an installed viewer/editor to open these files.",
                    size: SizeConstants.smallText,
                    weight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: SizeConstants.contentSpacing),
              Obx(
                () => InkWell(
                  onTap:
                      replaceView.value == false
                          ? () async {
                            if (Platform.isIOS) {
                              await iosFilePickerDropDownDialog();
                            } else {
                              await filePicker();
                            }
                          }
                          : null,
                  child: DottedBorder(
                    options: RectDottedBorderOptions(color: ColorConstants.primary.withValues(alpha: 0.6), strokeWidth: 1),
                    child:
                        replaceView.value == true
                            ? SizedBox(
                              height: fileType.value == "pdf" && (Platform.isAndroid || Platform.isIOS) ? Get.size.longestSide - 230 : null,
                              width: fileType.value == "pdf" && (Platform.isAndroid || Platform.isIOS) ? Get.size.shortestSide - 20 : null,
                              child: openFiles(fileType.value),
                            )
                            : const SizedBox(height: 200, width: double.infinity, child: Center(child: Text("Press or Tap to Upload Files"))),
                  ),
                ),
              ),
              Obx(() => SizedBox(height: replaceView.value ? SizeConstants.contentSpacing + 10 : 0)),
              Obx(() => Text(replaceView.value ? fileName.value : "")),
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              Obx(() {
                return uploadIndicatorShow.value != true
                    ? validUploadTypeWidget()
                    : SizedBox(
                      height: 50,
                      width: Get.width,
                      child: LiquidLinearProgressIndicator(
                        value: uploadIndicatorProgress.value / 100,
                        // Defaults to 0.5.
                        valueColor: const AlwaysStoppedAnimation(ColorConstants.button),
                        // Defaults to the current Theme's accentColor.
                        backgroundColor: ColorConstants.black.withValues(alpha: 0.1),
                        // Defaults to the current Theme's backgroundColor.
                        borderColor: ColorConstants.primary,
                        borderWidth: 1.0,
                        borderRadius: 12.0,
                        direction: Axis.horizontal,
                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text("Loading... ${uploadIndicatorProgress.value.toStringAsFixed(2)}"),
                      ),
                    );
              }),
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              Obx(() {
                return replaceView.value
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonConstant.buttonWidgetSingleDynamicWidthWithIcon(
                          title: "Cancel",
                          centerTitle: true,
                          isLoadingLoggingIn: false,
                          color: ColorConstants.red,
                          iconShow: false,
                          onTap: () {
                            replaceView.value = false;
                            fileLoadPath.value = '';
                            fileType.value = '';
                            fileImage.delete();
                            currentPage.value = 0;
                            pdfController = Completer<PDFViewController>();
                          },
                        ),
                        const SizedBox(width: SizeConstants.contentSpacing + 10),
                        ButtonConstant.buttonWidgetSingleDynamicWidthWithIcon(
                          icon: Icons.upload_file,
                          title: "Upload to Cloud",
                          centerTitle: true,
                          isLoadingLoggingIn: false,
                          color: ColorConstants.primary,
                          iconShow: true,
                          onTap: () async {
                            RegExp invalidChars = RegExp(
                              r'[!*#\$%\^&*(){}[]|\\/"'
                              ';:<>?]',
                            );

                            if (invalidChars.hasMatch(fileName.value)) {
                              WBCustomDialog.showDialogBox(
                                dialogTitle: 'File Upload Guidelines',
                                enableWidget: true,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: DeviceType.isTablet ? Get.width / 2.2 : (Get.width - 50.0)),
                                  Card(
                                    color: Colors.amber[100], // Light yellow background
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // Rounded corners
                                    ),
                                    elevation: 3, // Soft shadow effect
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 8.0,
                                        children: [
                                          const Icon(Icons.warning, color: Color(0xFF856404), size: 40),
                                          // Warning icon
                                          const Text(
                                            "Warning",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF856404), // Dark brown color
                                            ),
                                          ),
                                          const Text(
                                            "File name contains special characters, upload not allowed!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF856404)),
                                          ),
                                          Text("Please rename your file and try again.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      text: 'Allowed Characters:\t',
                                      style: TextStyle(
                                        color: const Color(0xFF2D6A3E),
                                        fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 4,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.75,
                                      ),
                                      children: <TextSpan>[const TextSpan(text: "A-Z, a-z, 0-9, ., -, _", style: TextStyle(color: Color(0xFF2D6A3E)))],
                                    ),
                                  ),
                                  RichText(
                                    textScaler: TextScaler.linear(Get.textScaleFactor),
                                    text: TextSpan(
                                      text: 'Disallowed Characters:\t',
                                      style: TextStyle(
                                        color: const Color(0xFFA94442),
                                        fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 4,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.75,
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text:
                                              r'!*#\$%\^&*(){}[]|\\/"'
                                              ';:<>?',
                                          style: TextStyle(color: Color(0xFFA94442)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                    child: MaterialButton(
                                      onPressed: () => Get.back(closeOverlays: true),
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      color: ColorConstants.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: ColorConstants.red)),
                                      child: TextWidget(
                                        text: 'Cancel',
                                        color: ColorConstants.black,
                                        weight: FontWeight.w700,
                                        size: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              uploadIndicatorShow.value = true;
                              await fileUploadApiCall();
                            }
                          },
                        ),
                      ],
                    )
                    : const SizedBox();
              }),
            ],
          ),
        ),
      ],
    );
  }

  String uploadTypeName() {
    String strTypeName = "Documents";

    if (Get.arguments == "addAttachment") {
      //FormAttachment
      strTypeName = "Form Attachment";
    } else if (Get.arguments == "Flight Ops") {
      strTypeName = "Flight Ops Document";
    } else if (Get.arguments == "discrepancyAddAttachment") {
      strTypeName = "Discrepancy Document";
    } else if (Get.arguments == "melDetails") {
      strTypeName = "MEL_Extension";
    } else if (Get.arguments == "melAircraftTypes") {
      strTypeName = "MEL_Approved";
    } else if (Get.arguments == "operationalExpense") {
      strTypeName = "Operational Expense Receipt";
    } else if (Get.arguments == "helpDeskAttachment") {
      strTypeName = "Help Desk Attachment";
    } else if (Get.arguments == "workOrderAttachment") {
      strTypeName = "Work Order Attachment";
    } else if (Get.arguments == "WorkOrderJob") {
      strTypeName = "Work Order Jobs Attachment";
    }

    return strTypeName;
  }

  Widget openFiles(String result) {
    switch (result) {
      case 'image':
        return Image.file(
          fileImage,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => frame != null ? child : const Padding(padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()),
        );

      case 'pdf':
        return (Platform.isAndroid || Platform.isIOS)
            ? Obx(() {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 50.0),
                    child: PDFView(
                      filePath: fileLoadPath.value,
                      defaultPage: currentPage.value,
                      fitPolicy: FitPolicy.BOTH,
                      backgroundColor: Theme.of(Get.context!).colorScheme.surface,
                      onRender: (page) {
                        pages.value = page ?? 0;
                        isReady.value = true;
                      },
                      onError: (error) {
                        errorMessage.value = error.toString();
                      },
                      onPageError: (page, error) {
                        errorMessage.value = '$page: ${error.toString()}';
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        if (!pdfController.isCompleted) {
                          pdfController.complete(pdfViewController);
                        }
                      },
                      onPageChanged: (int? page, int? total) {
                        currentPage.value = page ?? 0;
                        paginationController.currentPage = page ?? 0;
                      },
                      swipeHorizontal: true,
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{Factory<OneSequenceGestureRecognizer>(() => HorizontalDragGestureRecognizer())},
                    ),
                  ),
                  errorMessage.isEmpty
                      ? !isReady.value
                          ? const Center(child: CircularProgressIndicator())
                          : Container()
                      : Center(child: Text(errorMessage.value)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 280,
                      constraints: const BoxConstraints(minHeight: 48),
                      decoration: BoxDecoration(color: ColorConstants.yellow, borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 5), child: Text("Page : ", textAlign: TextAlign.center)),
                          Obx(() {
                            return pages.value > 1
                                ? Flexible(
                                  child: NumberPaginator(
                                    controller: paginationController,
                                    numberPages: pages.value,
                                    child: const SizedBox(height: 48, child: Row(children: [PrevButton(), Flexible(child: DropDownContent()), NextButton()])),
                                    onPageChange: (index) async {
                                      if (index != currentPage.value) {
                                        pdfController.future.then((value) => value.setPage(index));
                                      }
                                    },
                                  ),
                                )
                                : const Text("1   of   1  ", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0));
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            })
            : Container(
              height: 300.0,
              width: 300.0,
              color: Colors.blue.withValues(alpha: 0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(documentsViewIconReturns(result), color: ColorConstants.background, size: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 40),
                  Text(
                    result.capitalizeFirst ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstants.background,
                      fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 20,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );

      case 'text':
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height - 250),
          child: FutureBuilder(
            future: fileImage.readAsString(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error Loading Text: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return Card(child: Padding(padding: const EdgeInsets.all(10.0), child: SingleChildScrollView(child: Text(snapshot.data.toString()))));
                }
              } else if (snapshot.connectionState == ConnectionState.none) {
                return const Center(child: Text("Text is not Loaded!"));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );

      default:
        return Container(
          height: 300.0,
          width: 300.0,
          color: Colors.blue.withValues(alpha: 0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(documentsViewIconReturns(result), color: ColorConstants.background, size: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 40),
              Text(
                result.capitalizeFirst ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstants.background,
                  fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 20,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget validUploadTypeWidget() {
    return Center(
      child: Column(
        children: [
          const TextWidget(text: "Valid Upload Types", size: SizeConstants.extraMediumText + 10),
          const SizedBox(height: SizeConstants.contentSpacing + 10),
          uploadTypesWidget(iconName: MaterialCommunityIcons.file_image, documentName: "Images: JPG, JPEG, PNG, GIF, BMP"),
          const SizedBox(height: SizeConstants.contentSpacing + 10),
          uploadTypesWidget(iconName: MaterialCommunityIcons.file_word, documentName: "Documents: PDF, TXT, TEXT, DOC, DOCX"),
          const SizedBox(height: SizeConstants.contentSpacing + 10),
          uploadTypesWidget(iconName: MaterialCommunityIcons.google_spreadsheet, documentName: "Spreadsheets: XLS, XLSX"),
          const SizedBox(height: SizeConstants.contentSpacing + 10),
          uploadTypesWidget(iconName: MaterialCommunityIcons.file_powerpoint, documentName: "Presentations: PPT, PPTX"),
        ],
      ),
    );
  }

  Widget uploadTypesWidget({IconData? iconName, String? documentName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconName, size: 30.0),
        RichText(
          textScaler: TextScaler.linear(Get.textScaleFactor),
          text: TextSpan(
            text: documentName,
            style: TextStyle(color: ThemeColorMode.isLight ? Colors.black : Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1),
          ),
        ),
      ],
    );
  }

  IconData documentsViewIconReturns(String types) {
    switch (types) {
      case 'document':
        return MaterialCommunityIcons.file_word;
      case 'spreadsheet':
        return MaterialCommunityIcons.file_excel;
      case 'presentation':
        return MaterialCommunityIcons.file_powerpoint;
      case 'pdf':
        return MaterialCommunityIcons.file_pdf;
      case 'image':
        return MaterialCommunityIcons.file_image;
      case 'text':
        return MaterialCommunityIcons.text;
      default:
        return MaterialCommunityIcons.file;
    }
  }

  Future<void> fileUploadApiCall() async {
    Response data;

    if (Get.arguments == "addAttachment") {
      data = await uploadFilesAndDocuments(file: fileLoadPath.value, fileName: fileName.value, uploadType: "FormAttachment", uploadTypeId: Get.parameters["formId"]);

      if (data.data["isSuccess"] == true) {
        Get.back(result: true);
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } //Form
    else if (Get.arguments == "discrepancyAddAttachment") {
      data = await uploadFilesAndDocuments(file: fileLoadPath.value, fileName: fileName.value, uploadType: "DiscrepancyReal", uploadTypeId: Get.parameters["discrepancyId"]);

      if (data.data["isSuccess"] == true) {
        Get.offNamedUntil(
          Routes.discrepancyDetailsNew,
          ModalRoute.withName(Routes.discrepancyIndex),
          arguments: Get.arguments,
          parameters: {"routes": 'fileUpload', "discrepancyId": Get.parameters["discrepancyId"].toString()},
        );
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } //Discrepancy
    else if (Get.arguments == "melDetails") {
      data = await uploadFilesAndDocuments(file: fileLoadPath.value, fileName: fileName.value, uploadType: "MEL_Extension", uploadTypeId: Get.parameters["melId"]);

      if (data.data["isSuccess"] == true) {
        Get.offNamed(Routes.melDetails, parameters: {"melId": Get.parameters["melId"].toString(), "melType": "Mel"});
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } // MEl_Details
    else if (Get.arguments == "melAircraftTypes") {
      data = await uploadFilesAndDocuments(
        file: fileLoadPath.value,
        fileName: fileName.value,
        uploadType: "MEL_Approved",
        uploadTypeId: "1",
        aircraftType: Get.parameters["aircraftType"],
      );
      if (data.data["isSuccess"] == true) {
        Get.offNamed(Routes.melAircraftTypes);
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } //MEL_Types
    else if (Get.arguments == "operationalExpense") {
      data = await uploadFilesAndDocuments(
        file: fileLoadPath.value,
        fileName: fileName.value,
        uploadType: "OEChild",
        uploadTypeId: Get.parameters["oeChildId"],
        aircraftType: Get.parameters["oeId"],
      );
      if (data.data["isSuccess"] == true) {
        Get.offNamed(Routes.operationalExpenseEdit, parameters: {"expensesId": Get.parameters["oeId"].toString(), "routesForm": "documentsUpload", "action": "Edit"});
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } // Help Desk
    else if (Get.arguments == "helpDeskAttachment") {
      data = await uploadFilesAndDocuments(file: fileLoadPath.value, fileName: fileName.value, uploadType: "HelpDesk", uploadTypeId: "${Get.parameters["id"]}", aircraftType: "");
      if (data.data["isSuccess"] == true) {
        Get.offNamed(Routes.helpDeskDetails, arguments: Get.parameters as Map<String, String>);
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } else if (Get.arguments == "WorkOrderJob") {
      data = await uploadFilesAndDocuments(
        file: fileLoadPath.value,
        fileName: fileName.value,
        uploadType: "WorkOrderJob",
        uploadTypeId: "${Get.parameters["jobsId"]}",
        aircraftType: "${Get.parameters["workOrderId"]}",
        documentId: "${Get.parameters["documentId"]}",
        flag: "${Get.parameters["flag"]}",
      );
      if (data.data["isSuccess"] == true) {
        Get.back(result: data.data["isSuccess"]);
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } else if (Get.arguments == "workOrderAddAttachment") {
      data = await uploadFilesAndDocuments(file: fileLoadPath.value, fileName: fileName.value, uploadType: "Discrepancy", uploadTypeId: Get.parameters["workOrderId"]);

      if (data.data["isSuccess"] == true) {
        Get.offNamedUntil(
          Routes.workOrderDiscrepancyDetails,
          ModalRoute.withName(Routes.workOrderIndex),
          arguments: Get.parameters['workOrderId'].toString(),
          parameters: {'routeForm': 'fileUpload', 'workOrderId': Get.parameters['workOrderId'].toString(), 'woNumber': Get.parameters['woNumber'].toString()},
        );
        SnackBarHelper.openSnackBar(isError: false, message: "Upload Successful. (ID: ${data.data["data"]["fileId"]})");
      }
    } else {
      data = await uploadFilesAndDocuments(file: fileLoadPath.value, fileName: fileName.value, uploadType: "FlightOps", aircraftType: "", uploadTypeId: "");
      if (data.data["isSuccess"] == true) {
        Get.offNamed(
          Routes.fileEditNew,
          parameters: {"title": "Edit Flight Ops Item", "treeLevel": "", "fileName": "", "fileId": data.data["data"]["fileId"].toString(), "routesForm": "uploadFile"},
        );
      }
    }
  }

  Future<Response> uploadFilesAndDocuments({
    String? documentId,
    String? flag,
    required String file,
    required String fileName,
    String? uploadTypeId,
    required String uploadType,
    String? aircraftType,
  }) async {
    if (InternetCheckerHelperLogic.internetConnected) {
      try {
        var response = await api.post(
          "/fileControl/uploadFiles",
          data: FormData.fromMap({
            "file1": await MultipartFile.fromFile(file, filename: fileName),
            "UploadTypeId": uploadTypeId ?? "",
            "UploadType": uploadType,
            "AircraftType": aircraftType ?? "",
            "DocumentId": documentId ?? "0",
            "Flag": flag ?? "false",
          }),
          options: Options(headers: {"Authorization": "bearer ${await UserSessionInfo.token}", "Content-Type": "multipart/form-data"}),
          onSendProgress: (int sent, int total) {
            var percentage = ((sent / total) * 100);
            uploadIndicatorProgress.value = percentage;
          },
        );

        return response;
      } on DioException catch (e) {
        EasyLoading.dismiss();
        Get.back();
        SnackBarHelper.openSnackBar(isError: true, message: "An error occurred while processing your request.\nTry Again Later or Contact Digital AirWare.");
        if (kDebugMode) {
          print(
            "Error on Flight Operations and Documents while upload a new file(/fileControl/uploadFiles): Error Type: ${e.response?.statusMessage} (${e.response?.statusCode}), Error Info: ${e.response?.data["errorMessage"]}",
          );
        }
        return e.response ?? Response(data: {"message": "Service Unavailable."}, statusCode: 503, statusMessage: "Server Unreachable.", requestOptions: RequestOptions());
      }
    } else {
      EasyLoading.dismiss();
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      return Response(data: {"message": "Internet Connection Unavailable."}, statusCode: 0, statusMessage: "No Internet Connection.", requestOptions: RequestOptions());
    }
  }

  Future<void> filePicker({int selectedFileType = 5}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.values[selectedFileType],
      allowMultiple: false,
      allowedExtensions: selectedFileType == 5 ? ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'pdf', 'txt', 'text', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'] : null,
    );
    if (result != null) {
      final file = result.files.first;
      if (file.path != null) {
        fileName.value = file.name;
        fileType.value = FileControl.fileType(extension: file.extension);
        fileLoadPath.value = file.path!;
        fileImage = await File(fileLoadPath.value).copy("${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}");
        replaceView.value = true;
      } else {
        SnackBarHelper.openSnackBar(isError: true, message: "File Path Error! Unable to Load File.");
      }
    } else {
      SnackBarHelper.openSnackBar(message: "File Picker Operation Cancelled! Unable to Load File.");
    }
  }

  Future<void> iosFilePickerDropDownDialog() {
    RxMap<String, dynamic> selectedFileTypeDropDown = <String, dynamic>{}.obs;

    return showDialog<void>(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Select File Type",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: SizeConstants.contentSpacing + 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                      child: Column(
                        children: [
                          const SizedBox(height: SizeConstants.contentSpacing + 10),
                          ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "file_type",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidget(
                                        showTitle: true,
                                        key: "name",
                                        title: "File Type",
                                        context: context,
                                        hintText: selectedFileTypeDropDown.isNotEmpty ? selectedFileTypeDropDown["name"] : fileTypeDropdownData[0]["name"],
                                        data: fileTypeDropdownData,
                                        onChanged: (fileType) async {
                                          selectedFileTypeDropDown.value = fileType;
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing + 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: SizeConstants.contentSpacing + 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonConstant.dialogButton(
                          title: "Cancel",
                          borderColor: ColorConstants.red,
                          btnColor: ColorConstants.red,
                          onTapMethod: () {
                            Get.back();
                          },
                        ),
                        const SizedBox(width: SizeConstants.contentSpacing + 10),
                        ButtonConstant.dialogButton(
                          title: "Ok",
                          borderColor: ColorConstants.primary,
                          btnColor: ColorConstants.primary,
                          onTapMethod: () async {
                            Get.back();
                            await filePicker(selectedFileType: selectedFileTypeDropDown["id"] ?? 0);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void routeChangeFunction() {
    if (Get.arguments == "melDetails") {
      Get.offNamed(Routes.melDetails, parameters: Get.parameters as Map<String, String>);
    } else if (Get.arguments == "helpDeskAttachment") {
      Get.offNamed(Routes.helpDeskDetails, arguments: Get.parameters as Map<String, String>);
    } else if (Get.arguments == "operationalExpense") {
      Get.offNamed(Routes.operationalExpenseEdit, parameters: {"expensesId": Get.parameters["oeId"].toString(), "routesForm": "documentsUpload", "action": "Edit"});
    } else {
      Get.back();
    }
  }
}
