import 'dart:io';
import 'dart:ui';

import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/shared/services/device_orientation.dart' as orientation;
import 'package:aviation_rnd/shared/shared.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' hide TextSpan, Border;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:permission_handler/permission_handler.dart';

import '../helper/pdf_helper.dart';
import '../helper/permission_helper.dart';
import '../helper/snack_bar_helper.dart';

///*************** START TAYEB BLOCKS **************

class ReportsButtonWithIcon extends StatelessWidget {
  final bool centerTitle;
  final String title;
  final Color? titleColor;
  final bool iconShow;
  final IconData? icon;
  final Color? iconColor;
  final Color buttonBgColor;
  final bool isBorder;
  final bool isLoadingLoggingIn;
  final void Function()? onTap;

  const ReportsButtonWithIcon(
      {super.key,
      this.centerTitle = false,
      required this.title,
      this.titleColor,
      this.iconShow = false,
      this.icon,
      this.iconColor,
      this.buttonBgColor = ColorConstants.primary,
      this.isBorder = true,
      this.isLoadingLoggingIn = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: buttonBgColor,
        elevation: 4.0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeConstants.buttonRadius), borderSide: isBorder ? const BorderSide(color: ColorConstants.black, width: 1.0) : BorderSide.none),
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
                      color: iconColor,
                      size: Theme.of(Get.context!).textTheme.displayMedium!.fontSize,
                    ),
                  ),
                !isLoadingLoggingIn
                    ? Flexible(
                        child: Text(
                          title,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: Theme.of(Get.context!).textTheme.bodyMedium?.fontSize, color: titleColor, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                        ),
                      )
                    : const CupertinoActivityIndicator(
                        color: Colors.white,
                        animating: true,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportsTableText extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final double? decorationThickness;

  const ReportsTableText(
      {super.key,
      required this.title,
      this.titleColor,
      this.textAlign = TextAlign.center,
      this.fontWeight,
      this.textDecoration,
      this.textDecorationStyle,
      this.decorationThickness});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: titleColor,
          fontSize: Theme.of(Get.context!).textTheme.bodyMedium?.fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration,
          decorationStyle: textDecorationStyle,
          decorationThickness: textDecoration != null ? decorationThickness : null),
    );
  }
}

class ReportsText extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final FontWeight fontWeight;

  const ReportsText({super.key, required this.title, this.titleColor, this.fontWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: titleColor, fontWeight: fontWeight),
    );
  }
}

class ReportsDynamicText extends StatelessWidget {
  final String title1;
  final Color? title1Color;
  final FontWeight fontWeight1;
  final String title2;
  final Color? title2Color;
  final FontWeight fontWeight2;

  const ReportsDynamicText(
      {super.key, required this.title1, this.title1Color, this.fontWeight1 = FontWeight.bold, required this.title2, this.title2Color, this.fontWeight2 = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: ReportsText(
            title: title1.toString(),
            titleColor: title1Color,
            fontWeight: fontWeight1,
          )),
          Flexible(
              child: ReportsText(
            title: title2.toString(),
            titleColor: title2Color,
            fontWeight: fontWeight2,
          ))
        ],
      ),
    );
  }
}

class ReportsTextField extends StatelessWidget {
  final bool? req;
  final int? maxLines;
  final bool showField;
  final String? fieldName;
  final bool? fieldEnabled;
  final String? hintText;
  final GlobalKey<FormFieldState>? textFieldValidationKey;
  final String? validatorKeyName;
  final String? helperText;
  final TextStyle? helperTextStyle;
  final TextEditingController textFieldController;
  final int? maxCharacter;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? customErrorTitle;
  final bool showCursor;
  final bool? readOnly;
  final double? textFieldWidth;
  final void Function(String value) onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;

  const ReportsTextField(
      {super.key,
      this.maxLines = 1,
      this.showField = true,
      this.fieldName,
      this.hintText,
      this.textFieldValidationKey,
      this.validatorKeyName,
      this.helperText,
      this.helperTextStyle,
      required this.textFieldController,
      this.maxCharacter,
      this.focusNode,
      this.textInputType,
      this.textInputAction,
      this.customErrorTitle,
      this.showCursor = true,
      this.readOnly,
      this.textFieldWidth,
      this.onEditingComplete,
      this.onTap,
      this.onSubmitted,
      this.onTapOutside,
      this.req,
      required this.onChanged,
      this.fieldEnabled});

  @override
  Widget build(BuildContext context) {
    return showField
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (fieldName != null)
                Padding(padding: const EdgeInsets.only(left: 2.0, bottom: 5.0), child: Text(fieldName ?? "", style: const TextStyle(fontWeight: FontWeight.bold))),
              FormBuilderField(
                key: textFieldValidationKey,
                name: validatorKeyName ?? fieldName?.toLowerCase().replaceAll(" ", "_") ?? "text_field",
                validator: req == true ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "${fieldName ?? ""} $customErrorTitle")]) : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                builder: (field) => TextField(
                  controller: textFieldController,
                  cursorColor: Colors.black,
                  maxLines: maxLines,
                  maxLength: maxCharacter,
                  enabled: fieldEnabled,
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      constraints: BoxConstraints(maxWidth: textFieldWidth ?? double.infinity),
                      fillColor: fieldEnabled == false ? Colors.grey[400] : Colors.white,
                      hintText: hintText,
                      hintStyle: TextStyle(color: ColorConstants.black.withValues(alpha: 0.5)),
                      errorText: field.errorText,
                      helperText: helperText,
                      helperStyle: helperTextStyle,
                      counterText: "",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black))),
                  readOnly: readOnly ?? false,
                  showCursor: showCursor,
                  focusNode: focusNode,
                  keyboardType: !showCursor ? TextInputType.none : textInputType,
                  textInputAction: textInputAction,
                  onChanged: (String value) {
                    if (value != "") {
                      field.didChange(value);
                    } else {
                      field.reset();
                    }
                    onChanged(value);
                  },
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onSubmitted,
                  onTapOutside: onTapOutside,
                  onTap: onTap,
                ),
              ),
            ]),
          )
        : const SizedBox.shrink();
  }
}

class ReportsLargeText extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final FontWeight fontWeight;

  const ReportsLargeText({super.key, required this.title, this.titleColor, this.fontWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: titleColor, fontWeight: fontWeight, fontSize: Theme.of(Get.context!).textTheme.bodyLarge?.fontSize),
    );
  }
}

class ReportsDialogBox extends StatelessWidget {
  final String dialogTitle;
  final Widget child;
  final List<Widget> actionRow;

  const ReportsDialogBox({super.key, required this.dialogTitle, required this.child, required this.actionRow});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
            side: const BorderSide(color: ColorConstants.primary, width: 2),
          ),
          titlePadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 2.5),
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const SizedBox(),
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(right: 6.0), child: ReportsLargeText(title: dialogTitle, fontWeight: FontWeight.bold, titleColor: ColorConstants.black))),
            MaterialButton(
              onPressed: () => Get.back(),
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
              elevation: 5.0,
              color: ColorConstants.white,
              visualDensity: VisualDensity.comfortable,
              height: 40.0,
              minWidth: 50.0,
              child: const Icon(Icons.cancel_rounded, size: 25, color: ColorConstants.red),
            ),
          ]),
          contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.5),
          content: SingleChildScrollView(child: child),
          actionsOverflowButtonSpacing: 8.0,
          actions: actionRow),
    );
  }
}

class ReportsShowItemCountsAndButton extends StatelessWidget {
  final RxList tableDataList;
  final void Function()? onTapForCopy;
  final void Function()? onTapForCSV;
  final void Function()? onTapForExcel;
  final void Function()? onTapForPDF;
  final void Function(String) onChange;
  final TextEditingController textEditingController;
  final GlobalKey<FormFieldState> textFieldValidationKey;

  const ReportsShowItemCountsAndButton(
      {super.key,
      required this.tableDataList,
      required this.onTapForCopy,
      required this.onTapForCSV,
      required this.onTapForExcel,
      required this.onTapForPDF,
      required this.onChange,
      required this.textEditingController,
      required this.textFieldValidationKey});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstants.primary.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Get.width > 480
            ? Obx(() {
                return Row(
                  children: [
                    ReportsText(title: "Showing 1 to ${tableDataList.length} of ${tableDataList.length} entries"),
                    Expanded(
                      flex: 2,
                      child: ReportsTextField(
                        req: false,
                        hintText: "Search data in table",
                        onChanged: onChange,
                        textFieldController: textEditingController,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: HeaderButtonsAction(
                        onTapForCopy: onTapForCopy,
                        onTapForCSV: onTapForCSV,
                        onTapForExcel: onTapForExcel,
                        onTapForPDF: onTapForPDF,
                      ),
                    )),
                  ],
                );
              })
            : Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: ReportsText(title: "Showing 1 to ${tableDataList.length} of ${tableDataList.length} entries"),
                    ),
                    ReportsTextField(
                      req: false,
                      hintText: "Search data in table",
                      onChanged: onChange,
                      textFieldController: textEditingController,
                    ),
                    HeaderButtonsAction(
                      onTapForCopy: onTapForCopy,
                      onTapForCSV: onTapForCSV,
                      onTapForExcel: onTapForExcel,
                      onTapForPDF: onTapForPDF,
                    ),
                  ],
                );
              }),
      ),
    );
  }
}

class HeaderButtonsAction extends StatelessWidget {
  final void Function()? onTapForCopy;
  final void Function()? onTapForCSV;
  final void Function()? onTapForExcel;
  final void Function()? onTapForPDF;

  const HeaderButtonsAction({super.key, required this.onTapForCopy, required this.onTapForCSV, required this.onTapForExcel, required this.onTapForPDF});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          ReportsButtonWithIcon(
            isBorder: false,
            isLoadingLoggingIn: false,
            iconShow: true,
            centerTitle: true,
            title: "Copy",
            titleColor: ColorConstants.white,
            buttonBgColor: ColorConstants.primary,
            icon: Icons.copy,
            iconColor: ColorConstants.white,
            onTap: onTapForCopy,
          ),
          ReportsButtonWithIcon(
            isBorder: false,
            isLoadingLoggingIn: false,
            iconShow: true,
            centerTitle: true,
            title: "CSV",
            titleColor: ColorConstants.white,
            buttonBgColor: ColorConstants.primary,
            icon: MaterialCommunityIcons.file_export,
            iconColor: ColorConstants.white,
            onTap: onTapForCSV,
          ),
          ReportsButtonWithIcon(
            isBorder: false,
            isLoadingLoggingIn: false,
            iconShow: true,
            centerTitle: true,
            title: "Excel",
            titleColor: ColorConstants.white,
            buttonBgColor: ColorConstants.primary,
            icon: MaterialCommunityIcons.file_excel,
            iconColor: ColorConstants.white,
            onTap: onTapForExcel,
          ),
          ReportsButtonWithIcon(
            isBorder: false,
            isLoadingLoggingIn: false,
            iconShow: true,
            centerTitle: true,
            title: "PDF",
            titleColor: ColorConstants.white,
            buttonBgColor: ColorConstants.primary,
            icon: MaterialCommunityIcons.file_pdf,
            iconColor: ColorConstants.white,
            onTap: onTapForPDF,
          ),
        ],
      ),
    );
  }
}

class ReportsTableWidget extends StatefulWidget {
  final List tableHeaderList;
  final List tableFooterList;
  final List tableDataList;
  final TextEditingController searchController;
  final GlobalKey<FormFieldState> searchKey;
  final double headerWidth1;
  final double headerWidth2;
  final double footerWidth1;
  final double footerWidth2;
  final double cellWidth1;
  final double cellWidth2;
  final bool isOnTap0;
  final String? routes0;

  const ReportsTableWidget(
      {super.key,
      required this.isOnTap0,
      this.routes0,
      required this.tableFooterList,
      required this.headerWidth1,
      required this.headerWidth2,
      required this.footerWidth1,
      required this.footerWidth2,
      required this.cellWidth1,
      required this.cellWidth2,
      required this.tableHeaderList,
      required this.tableDataList,
      required this.searchController,
      required this.searchKey});

  @override
  State<ReportsTableWidget> createState() => _ReportsTableWidgetState();
}

class _ReportsTableWidgetState extends State<ReportsTableWidget> {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();

  RxList tableSearchDataList = [].obs;
  RxBool isAscending1 = true.obs;
  RxBool isAscending = true.obs;
  RxInt sortColumnIndex1 = 0.obs;
  RxInt sortColumnIndex = 0.obs;

  ScrollController? c1;
  ScrollController? c2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableSearchDataList.value = widget.tableDataList;

    scrollController1.addListener(
      () {
        if (scrollController1.offset != scrollController2.offset) {
          scrollController2.jumpTo(scrollController1.offset);
          scrollController3.jumpTo(scrollController1.offset);
        }
      },
    );

    scrollController2.addListener(
      () {
        if (scrollController1.offset != scrollController2.offset) {
          scrollController1.jumpTo(scrollController2.offset);
          scrollController3.jumpTo(scrollController2.offset);
        }
      },
    );

    scrollController3.addListener(
      () {
        if (scrollController1.offset != scrollController3.offset) {
          scrollController1.jumpTo(scrollController3.offset);
          scrollController2.jumpTo(scrollController3.offset);
        }
      },
    );

    scrollController3.addListener(
      () {
        if (scrollController2.offset != scrollController3.offset) {
          scrollController1.jumpTo(scrollController3.offset);
          scrollController2.jumpTo(scrollController3.offset);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        spacing: 20.0,
        children: [
          ReportsShowItemCountsAndButton(
              tableDataList: tableSearchDataList,
              onTapForCopy: () {
                getDefaultReportsCopyView();
              },
              onTapForCSV: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    await getDefaultReportsCsvView();
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  await getDefaultReportsCsvView();
                }
              },
              onTapForExcel: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    await getDefaultReportsExcelView();
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  await getDefaultReportsExcelView();
                }
              },
              onTapForPDF: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    Get.to(() => ViewPrintSavePdf(
                        pdfFile: (pageFormat) => getReportsCustomShowPdfView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  Get.to(() => ViewPrintSavePdf(
                      pdfFile: (pageFormat) => getReportsCustomShowPdfView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
                }
              },
              onChange: (value) {
                getDefaultReportsShowTableFilter(value: value);
              },
              textEditingController: widget.searchController,
              textFieldValidationKey: widget.searchKey),
          Obx(() {
            return tableSearchDataList.isNotEmpty
                ? SizedBox(
                    height: (DeviceType.isMobile && orientation.DeviceOrientation.isPortrait)
                        ? Get.height / 1.9
                        : (DeviceType.isMobile && orientation.DeviceOrientation.isLandscape)
                            ? Get.height / 2.0
                            : (DeviceType.isTablet && orientation.DeviceOrientation.isPortrait)
                                ? Get.height / 1.31
                                : Get.height / 1.51,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                              child: Obx(() {
                                return DataTable(
                                  sortAscending: isAscending1.value,
                                  sortColumnIndex: sortColumnIndex1.value,
                                  showCheckboxColumn: true,
                                  dataRowMaxHeight: 80.0,
                                  headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                  headingTextStyle: const TextStyle(fontSize: 16.0),
                                  border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                                  clipBehavior: Clip.antiAlias,
                                  columns: [
                                    DataColumn(
                                        headingRowAlignment: MainAxisAlignment.center,
                                        onSort: (columnIndex, ascending) {
                                          isAscending1.value = ascending;
                                          sortColumnIndex1.value = columnIndex;
                                          if (columnIndex == 0) {
                                            if (ascending) {
                                              tableSearchDataList.sort(
                                                (a, b) {
                                                  return b[b.keys.elementAt(columnIndex)].compareTo(a[a.keys.elementAt(columnIndex)]);
                                                },
                                              );
                                            } else {
                                              tableSearchDataList.sort((a, b) {
                                                return a[a.keys.elementAt(columnIndex)].compareTo(b[b.keys.elementAt(columnIndex)]);
                                              });
                                            }
                                          }
                                        },
                                        label: SizedBox(width: widget.headerWidth1, child: ReportsText(title: widget.tableHeaderList.first, titleColor: ColorConstants.white)))
                                  ],
                                  rows: [],
                                );
                              }),
                            ),
                            Expanded(child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  controller: scrollController1,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                                    child: Theme(
                                      data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                      child: Obx(() {
                                        return DataTable(
                                            //headingRowHeight: 0,
                                            sortAscending: isAscending.value,
                                            sortColumnIndex: sortColumnIndex.value,
                                            showCheckboxColumn: true,
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              for (int i = 1; i < widget.tableHeaderList.length; i++) ...{
                                                DataColumn(
                                                    headingRowAlignment: MainAxisAlignment.center,
                                                    onSort: (columnIndex, ascending) {
                                                      isAscending.value = ascending;
                                                      sortColumnIndex.value = columnIndex;
                                                      if (columnIndex == 0 || columnIndex <= tableSearchDataList.length) {
                                                        if (ascending) {
                                                          tableSearchDataList.sort(
                                                            (a, b) {
                                                              return b[b.keys.elementAt(columnIndex)].compareTo(a[a.keys.elementAt(columnIndex)]);
                                                            },
                                                          );
                                                        } else {
                                                          tableSearchDataList.sort((a, b) {
                                                            return a[a.keys.elementAt(columnIndex)].compareTo(b[b.keys.elementAt(columnIndex)]);
                                                          });
                                                        }
                                                      }
                                                    },
                                                    label: SizedBox(
                                                      width: widget.headerWidth2,
                                                      child: ReportsText(
                                                        title: widget.tableHeaderList[i].toString(),
                                                        titleColor: ColorConstants.white,
                                                      ),
                                                    ))
                                              }
                                            ],
                                            rows: []);
                                      }),
                                    ),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                        Flexible(
                          child: Obx(() {
                            return tableSearchDataList.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                          child: DataTable(
                                            headingRowHeight: 0,
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(
                                              color: ColorConstants.white,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              DataColumn(
                                                  headingRowAlignment: MainAxisAlignment.center,
                                                  label:
                                                      SizedBox(width: widget.cellWidth1, child: ReportsText(title: widget.tableHeaderList.first, titleColor: ColorConstants.white)))
                                            ],
                                            rows: List.generate(
                                              tableSearchDataList.length,
                                              (index) {
                                                return DataRow(
                                                    color: index != tableSearchDataList.length
                                                        ? WidgetStateProperty.all(
                                                            index % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.6))
                                                        : WidgetStateProperty.all(ColorConstants.background),
                                                    cells: [
                                                      DataCell(SingleChildScrollView(
                                                          child: SizedBox(
                                                              width: 120.0,
                                                              child: widget.isOnTap0 == true
                                                                  ? GestureDetector(
                                                                      onTap: () {
                                                                        Get.toNamed(widget.routes0 ?? "", parameters: {"id": tableSearchDataList[index]["id"].toString()});
                                                                      },
                                                                      child: Material(
                                                                        color: ColorConstants.white,
                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                        elevation: 5.0,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Center(
                                                                            child: ReportsText(title: tableSearchDataList[index].values.first.toString()),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : ReportsText(title: tableSearchDataList[index].values.first.toString())))),
                                                    ]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SingleChildScrollView(
                                              controller: scrollController2,
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(minWidth: constraints.minWidth),
                                                child: Theme(
                                                  data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                                  child: Obx(() {
                                                    return DataTable(
                                                        headingRowHeight: 0,
                                                        dataRowMaxHeight: 80.0,
                                                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                                        headingTextStyle: const TextStyle(fontSize: 16.0),
                                                        border: TableBorder.all(
                                                          color: ColorConstants.white,
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        columns: [
                                                          for (int i = 1; i < widget.tableHeaderList.length; i++) ...{
                                                            DataColumn(
                                                                headingRowAlignment: MainAxisAlignment.center,
                                                                label: SizedBox(
                                                                  width: widget.cellWidth2,
                                                                  child: ReportsText(
                                                                    title: widget.tableHeaderList[i].toString(),
                                                                    titleColor: ColorConstants.white,
                                                                  ),
                                                                ))
                                                          }
                                                        ],
                                                        rows: List.generate(
                                                          tableSearchDataList.length,
                                                          (index) {
                                                            return DataRow(
                                                                color: index != tableSearchDataList.length
                                                                    ? WidgetStateProperty.all(index % 2 == 0
                                                                        ? ColorConstants.primary.withValues(alpha: 0.3)
                                                                        : ColorConstants.primary.withValues(alpha: 0.6))
                                                                    : WidgetStateProperty.all(ColorConstants.background),
                                                                cells: [
                                                                  for (var element in tableSearchDataList[index].entries) ...{
                                                                    if (element.key != "${tableSearchDataList[index].keys.first}")
                                                                      DataCell(SingleChildScrollView(
                                                                          child: SizedBox(width: 120.0, child: buildReportsText(element: element, index: index)))),
                                                                  }
                                                                ]);
                                                          },
                                                        ));
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                      ],
                                    ),
                                  )
                                : const SizedBox();
                          }),
                        ),
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                              child: DataTable(
                                dataRowMaxHeight: 80.0,
                                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                headingTextStyle: const TextStyle(fontSize: 16.0),
                                border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0))),
                                clipBehavior: Clip.antiAlias,
                                columns: [
                                  DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: SizedBox(width: widget.footerWidth1, child: ReportsText(title: widget.tableFooterList.first, titleColor: ColorConstants.white)))
                                ],
                                rows: [],
                              ),
                            ),
                            Expanded(child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  controller: scrollController3,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                                    child: Theme(
                                        data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                        child: DataTable(
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10.0))),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              for (int i = 1; i < widget.tableFooterList.length; i++) ...{
                                                DataColumn(
                                                    headingRowAlignment: MainAxisAlignment.center,
                                                    label: SizedBox(
                                                      width: widget.footerWidth2,
                                                      child: ReportsText(
                                                        title: widget.tableFooterList[i].toString(),
                                                        titleColor: ColorConstants.white,
                                                      ),
                                                    ))
                                              }
                                            ],
                                            rows: [])),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                      ],
                    ))
                : const Center(
                    child: ReportsText(title: "No data available in table"),
                  );
          }),
        ],
      ),
    );
  }

  ReportsText buildReportsText({index, element}) {
    return ReportsText(title: "${element.value}");
  }

  getDefaultReportsShowTableFilter({required String value}) {
    List<dynamic> result = [];
    if (value.toString().isEmpty) {
      result = widget.tableDataList;
    } else {
      result = widget.tableDataList.where(
        (element) {
          return element.values.toString().toLowerCase().contains(value.toString().toLowerCase());
        },
      ).toList();
    }
    return tableSearchDataList.value = result;
  }

  getDefaultReportsCopyView() {
    String data = "";
    data += "Digital AirWare © 2024\t\n\n";
    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      data += "${widget.tableHeaderList[i]}\t";
    }
    data += "\n";
    for (int index = 0; index < widget.tableDataList.length; index++) {
      for (var element in widget.tableDataList[index].entries) {
        data += "${element.value}\t";
      }
      data += "\n";
    }
    CopyIntoClipboard.copyText(text: data, message: "${widget.tableDataList.length} rows");
  }

  getDefaultReportsExcelView() async {
    final Excel workbook = Excel.createExcel();
    final Sheet sheet = workbook['Sheet1'];

    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = TextCellValue(widget.tableHeaderList[i]);
    }

    for (int i = 0; i < widget.tableDataList.length; i++) {
      var a = 0;
      var n = i + 1;
      for (var element in widget.tableDataList[i].entries) {
        sheet.cell(CellIndex.indexByColumnRow(rowIndex: n, columnIndex: a)).value = TextCellValue(element.value.toString());
        a++;
      }
    }
    final List<int>? bytes = workbook.save(fileName: "reports_custom_show_index_view.xlsx");
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    String? file = dir;
    File f = File("$file/reports_custom_show_index_view.xlsx");
    f.writeAsBytes(bytes!, flush: true);
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  getDefaultReportsCsvView() async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      row.add(widget.tableHeaderList[i]);
    }
    rows.add(row);

    for (int i = 0; i < widget.tableDataList.length; i++) {
      List<dynamic> cellData = [];
      for (var element in widget.tableDataList[i].entries) {
        cellData.add(element.value.toString());
        rows.add(cellData);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    String? file = dir;
    File f = File("$file/reports_custom_show_index.csv");
    f.writeAsString(csv);
    f.readAsStringSync();
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  Future<Uint8List> getReportsCustomShowPdfView({PdfPageFormat? pageFormat}) async {
    final doc = pdf.Document();
    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    doc.addPage(pdf.MultiPage(
      pageFormat: pageFormat,
      maxPages: 1000,
      theme: themeData,
      header: (context) {
        return pdf.SizedBox();
      },
      margin: const pdf.EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      build: (context) {
        return [
          pdf.Table(border: const pdf.TableBorder(), children: [
            pdf.TableRow(
              decoration: pdf.BoxDecoration(
                color: PdfColor.fromHex("#4C597F"),
              ),
              children: List.generate(widget.tableHeaderList.length, (index) => getPdfHeaderData(index: index)),
            ),
            ...List.generate(widget.tableDataList.length, (index) => getPdfTableData(index: index))
          ]),
        ];
      },
    ));

    return await doc.save();
  }

  getPdfHeaderData({required int index}) {
    return pdf.Flexible(
        child: pdf.Text("${widget.tableHeaderList[index]}",
            textAlign: pdf.TextAlign.center, style: pdf.TextStyle(color: PdfColors.white, fontSize: 12, fontWeight: pdf.FontWeight.bold)));
  }

  getPdfTableData({required int index}) {
    return pdf.TableRow(decoration: pdf.BoxDecoration(color: index % 2 == 0 ? PdfColor.fromHex("#d3d3d3") : PdfColors.white), children: [
      for (var element in widget.tableDataList[index].entries)
        pdf.Flexible(child: pdf.SizedBox(height: 80.0, width: 70.0, child: pdf.Text("${element.value}", textAlign: pdf.TextAlign.center))),
    ]);
  }
}

class MaintenanceForecast1015TableWidget extends StatefulWidget {
  final List tableHeaderList;
  final List tableFooterList;
  final List tableDataList;
  final TextEditingController searchController;
  final GlobalKey<FormFieldState> searchKey;
  final Function()? onTapCategory;
  final Function()? onTapItem;
  final double headerWidth1;
  final double headerWidth2;
  final double footerWidth1;
  final double footerWidth2;
  final double cellWidth1;
  final double cellWidth2;

  const MaintenanceForecast1015TableWidget({super.key,
    this.onTapCategory,
    this.onTapItem,
    required this.tableFooterList,
    required this.headerWidth1,
    required this.headerWidth2,
    required this.footerWidth1,
    required this.footerWidth2,
    required this.cellWidth1,
    required this.cellWidth2,
    required this.tableHeaderList,
    required this.tableDataList,
    required this.searchController,
    required this.searchKey});

  @override
  State<MaintenanceForecast1015TableWidget> createState() => _MaintenanceForecast1015TableWidgetState();
}

class _MaintenanceForecast1015TableWidgetState extends State<MaintenanceForecast1015TableWidget> {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();

  RxList tableSearchDataList = [].obs;
  RxBool isAscending1 = true.obs;
  RxBool isAscending = true.obs;
  RxInt sortColumnIndex1 = 0.obs;
  RxInt sortColumnIndex = 0.obs;

  ScrollController? c1;
  ScrollController? c2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableSearchDataList.value = widget.tableDataList;

    scrollController1.addListener(
      () {
        if (scrollController1.offset != scrollController2.offset) {
          scrollController2.jumpTo(scrollController1.offset);
          scrollController3.jumpTo(scrollController1.offset);
        }
      },
    );

    scrollController2.addListener(
      () {
        if (scrollController1.offset != scrollController2.offset) {
          scrollController1.jumpTo(scrollController2.offset);
          scrollController3.jumpTo(scrollController2.offset);
        }
      },
    );

    scrollController3.addListener(
      () {
        if (scrollController1.offset != scrollController3.offset) {
          scrollController1.jumpTo(scrollController3.offset);
          scrollController2.jumpTo(scrollController3.offset);
        }
      },
    );

    scrollController3.addListener(
      () {
        if (scrollController2.offset != scrollController3.offset) {
          scrollController1.jumpTo(scrollController3.offset);
          scrollController2.jumpTo(scrollController3.offset);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        spacing: 20.0,
        children: [
          ReportsShowItemCountsAndButton(
              tableDataList: tableSearchDataList,
              onTapForCopy: () {
                getDefaultReportsCopyView();
              },
              onTapForCSV: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    await getDefaultReportsCsvView();
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  await getDefaultReportsCsvView();
                }
              },
              onTapForExcel: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    await getDefaultReportsExcelView();
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  await getDefaultReportsExcelView();
                }
              },
              onTapForPDF: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    Get.to(() => ViewPrintSavePdf(
                        pdfFile: (pageFormat) => getReportsCustomShowPdfView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  Get.to(() => ViewPrintSavePdf(
                      pdfFile: (pageFormat) => getReportsCustomShowPdfView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
                }
              },
              onChange: (value) {
                getDefaultReportsShowTableFilter(value: value);
              },
              textEditingController: widget.searchController,
              textFieldValidationKey: widget.searchKey),
          Obx(() {
            return tableSearchDataList.isNotEmpty
                ? SizedBox(
                    height: (DeviceType.isMobile && orientation.DeviceOrientation.isPortrait)
                        ? Get.height / 1.9
                        : (DeviceType.isMobile && orientation.DeviceOrientation.isLandscape)
                            ? Get.height / 2.0
                            : (DeviceType.isTablet && orientation.DeviceOrientation.isPortrait)
                                ? Get.height / 1.31
                                : Get.height / 1.51,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                              child: Obx(() {
                                return DataTable(
                                  sortAscending: isAscending1.value,
                                  sortColumnIndex: sortColumnIndex1.value,
                                  showCheckboxColumn: true,
                                  dataRowMaxHeight: 80.0,
                                  headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                  headingTextStyle: const TextStyle(fontSize: 16.0),
                                  border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                                  clipBehavior: Clip.antiAlias,
                                  columns: [
                                    DataColumn(
                                        headingRowAlignment: MainAxisAlignment.center,
                                        onSort: (columnIndex, ascending) {
                                          isAscending1.value = ascending;
                                          sortColumnIndex1.value = columnIndex;
                                          if (columnIndex == 0) {
                                            if (ascending) {
                                              tableSearchDataList.sort(
                                                (a, b) {
                                                  return b[b.keys.elementAt(columnIndex)].compareTo(a[a.keys.elementAt(columnIndex)]);
                                                },
                                              );
                                            } else {
                                              tableSearchDataList.sort((a, b) {
                                                return a[a.keys.elementAt(columnIndex)].compareTo(b[b.keys.elementAt(columnIndex)]);
                                              });
                                            }
                                          }
                                        },
                                        label: SizedBox(width: widget.headerWidth1, child: ReportsText(title: widget.tableHeaderList.first, titleColor: ColorConstants.white)))
                                  ],
                                  rows: [],
                                );
                              }),
                            ),
                            Expanded(child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  controller: scrollController1,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                                    child: Theme(
                                      data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                      child: Obx(() {
                                        return DataTable(
                                            //headingRowHeight: 0,
                                            sortAscending: isAscending.value,
                                            sortColumnIndex: sortColumnIndex.value,
                                            showCheckboxColumn: true,
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              for (int i = 1; i < widget.tableHeaderList.length; i++) ...{
                                                DataColumn(
                                                    headingRowAlignment: MainAxisAlignment.center,
                                                    onSort: (columnIndex, ascending) {
                                                      isAscending.value = ascending;
                                                      sortColumnIndex.value = columnIndex;
                                                      if (columnIndex == 0 || columnIndex <= tableSearchDataList.length) {
                                                        if (ascending) {
                                                          tableSearchDataList.sort(
                                                            (a, b) {
                                                              return b[b.keys.elementAt(columnIndex)].compareTo(a[a.keys.elementAt(columnIndex)]);
                                                            },
                                                          );
                                                        } else {
                                                          tableSearchDataList.sort((a, b) {
                                                            return a[a.keys.elementAt(columnIndex)].compareTo(b[b.keys.elementAt(columnIndex)]);
                                                          });
                                                        }
                                                      }
                                                    },
                                                    label: SizedBox(
                                                      width: widget.headerWidth2,
                                                      child: ReportsText(
                                                        title: widget.tableHeaderList[i].toString(),
                                                        titleColor: ColorConstants.white,
                                                      ),
                                                    ))
                                              }
                                            ],
                                            rows: []);
                                      }),
                                    ),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                        Flexible(
                          child: Obx(() {
                            return tableSearchDataList.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                          child: DataTable(
                                            headingRowHeight: 0,
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(
                                              color: ColorConstants.white,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              DataColumn(
                                                  headingRowAlignment: MainAxisAlignment.center,
                                                  label:
                                                      SizedBox(width: widget.cellWidth1, child: ReportsText(title: widget.tableHeaderList.first, titleColor: ColorConstants.white)))
                                            ],
                                            rows: List.generate(
                                              tableSearchDataList.length,
                                              (index) {
                                                return DataRow(
                                                    color: index != tableSearchDataList.length
                                                        ? WidgetStateProperty.all(
                                                            index % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.6))
                                                        : WidgetStateProperty.all(ColorConstants.background),
                                                    cells: [
                                                      DataCell(
                                                          SingleChildScrollView(child: SizedBox(width: 120.0, child: ReportsText(title: tableSearchDataList[index]["aircraft"])))),
                                                    ]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SingleChildScrollView(
                                              controller: scrollController2,
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(minWidth: constraints.minWidth),
                                                child: Theme(
                                                  data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                                  child: Obx(() {
                                                    return DataTable(
                                                        headingRowHeight: 0,
                                                        dataRowMaxHeight: 80.0,
                                                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                                        headingTextStyle: const TextStyle(fontSize: 16.0),
                                                        border: TableBorder.all(
                                                          color: ColorConstants.white,
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        columns: [
                                                          for (int i = 1; i < widget.tableHeaderList.length; i++) ...{
                                                            DataColumn(
                                                                headingRowAlignment: MainAxisAlignment.center,
                                                                label: SizedBox(
                                                                  width: widget.cellWidth2,
                                                                  child: ReportsText(
                                                                    title: widget.tableHeaderList[i].toString(),
                                                                    titleColor: ColorConstants.white,
                                                                  ),
                                                                ))
                                                          }
                                                        ],
                                                        rows: List.generate(
                                                          tableSearchDataList.length,
                                                          (index) {
                                                            var color = tableSearchDataList[index]["color"];
                                                            return DataRow(
                                                                color: index != tableSearchDataList.length
                                                                    ? WidgetStateProperty.all(index % 2 == 0
                                                                        ? ColorConstants.primary.withValues(alpha: 0.3)
                                                                        : ColorConstants.primary.withValues(alpha: 0.6))
                                                                    : WidgetStateProperty.all(ColorConstants.background),
                                                                cells: [
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(
                                                                          width: 120.0,
                                                                          child: GestureDetector(
                                                                            onTap: widget.onTapCategory,
                                                                            child: Material(
                                                                              elevation: 5.0,
                                                                              color: ColorConstants.white,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              child: Center(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: ReportsText(title: "${tableSearchDataList[index]["category"]}"),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )))),
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(
                                                                          width: 120.0,
                                                                          child: GestureDetector(
                                                                            onTap: widget.onTapItem,
                                                                            child: ReportsTableText(
                                                                              title: "${tableSearchDataList[index]["item"]}",
                                                                              fontWeight: FontWeight.bold,
                                                                              textDecoration: TextDecoration.underline,
                                                                            ),
                                                                          )))),
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(width: 120.0, child: ReportsText(title: "${tableSearchDataList[index]["remains"]}")))),
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(
                                                                          width: 120.0,
                                                                          child: Obx(() {
                                                                            return Material(
                                                                                color: color == "Red"
                                                                                    ? ColorConstants.red
                                                                                    : color == "Green"
                                                                                        ? ColorConstants.button
                                                                                        : color == "Yellow"
                                                                                            ? ColorConstants.yellow
                                                                                            : ColorConstants.white,
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: ReportsText(
                                                                                      title: "${tableSearchDataList[index]["color"]}",
                                                                                      titleColor: ColorConstants.white,
                                                                                    ),
                                                                                  ),
                                                                                ));
                                                                          })))),
                                                                ]);
                                                          },
                                                        ));
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                      ],
                                    ),
                                  )
                                : const SizedBox();
                          }),
                        ),
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                              child: DataTable(
                                dataRowMaxHeight: 80.0,
                                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                headingTextStyle: const TextStyle(fontSize: 16.0),
                                border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0))),
                                clipBehavior: Clip.antiAlias,
                                columns: [
                                  DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: SizedBox(width: widget.footerWidth1, child: ReportsText(title: widget.tableFooterList.first, titleColor: ColorConstants.white)))
                                ],
                                rows: [],
                              ),
                            ),
                            Expanded(child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  controller: scrollController3,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                                    child: Theme(
                                        data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                        child: DataTable(
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10.0))),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              for (int i = 1; i < widget.tableFooterList.length; i++) ...{
                                                DataColumn(
                                                    headingRowAlignment: MainAxisAlignment.center,
                                                    label: SizedBox(
                                                      width: widget.footerWidth2,
                                                      child: ReportsText(
                                                        title: widget.tableFooterList[i].toString(),
                                                        titleColor: ColorConstants.white,
                                                      ),
                                                    ))
                                              }
                                            ],
                                            rows: [])),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                      ],
                    ))
                : const Center(
                    child: ReportsText(title: "No data available in table"),
                  );
          }),
        ],
      ),
    );
  }

  getDefaultReportsShowTableFilter({required String value}) {
    List<dynamic> result = [];
    if (value.toString().isEmpty) {
      result = widget.tableDataList;
    } else {
      result = widget.tableDataList.where(
        (element) {
          return element.values.toString().toLowerCase().contains(value.toString().toLowerCase());
        },
      ).toList();
    }
    return tableSearchDataList.value = result;
  }

  getDefaultReportsCopyView() {
    String data = "";
    data += "Digital AirWare © 2024\t\n\n";
    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      data += "${widget.tableHeaderList[i]}\t";
    }
    data += "\n";
    for (int index = 0; index < widget.tableDataList.length; index++) {
      for (var element in widget.tableDataList[index].entries) {
        data += "${element.value}\t";
      }
      data += "\n";
    }
    CopyIntoClipboard.copyText(text: data, message: "${widget.tableDataList.length} rows");
  }

  getDefaultReportsExcelView() async {
    final Excel workbook = Excel.createExcel();
    final Sheet sheet = workbook['Sheet1'];

    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = TextCellValue(widget.tableHeaderList[i]);
    }

    for (int i = 0; i < widget.tableDataList.length; i++) {
      var a = 0;
      var n = i + 1;
      for (var element in widget.tableDataList[i].entries) {
        sheet.cell(CellIndex.indexByColumnRow(rowIndex: n, columnIndex: a)).value = TextCellValue(element.value.toString());
        a++;
      }
    }
    final List<int>? bytes = workbook.save(fileName: "reports_custom_show_index_view.xlsx");
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    String? file = dir;
    File f = File("$file/reports_custom_show_index_view.xlsx");
    f.writeAsBytes(bytes!, flush: true);
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  getDefaultReportsCsvView() async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      row.add(widget.tableHeaderList[i]);
    }
    rows.add(row);

    for (int i = 0; i < widget.tableDataList.length; i++) {
      List<dynamic> cellData = [];
      for (var element in widget.tableDataList[i].entries) {
        cellData.add(element.value.toString());
        rows.add(cellData);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    String? file = dir;
    File f = File("$file/reports_custom_show_index.csv");
    f.writeAsString(csv);
    f.readAsStringSync();
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  Future<Uint8List> getReportsCustomShowPdfView({PdfPageFormat? pageFormat}) async {
    final doc = pdf.Document();
    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    doc.addPage(pdf.MultiPage(
      pageFormat: pageFormat,
      maxPages: 1000,
      theme: themeData,
      header: (context) {
        return pdf.SizedBox();
      },
      margin: const pdf.EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      build: (context) {
        return [
          pdf.Table(border: const pdf.TableBorder(), children: [
            pdf.TableRow(
              decoration: pdf.BoxDecoration(
                color: PdfColor.fromHex("#4C597F"),
              ),
              children: List.generate(widget.tableHeaderList.length, (index) => getPdfHeaderData(index: index)),
            ),
            ...List.generate(widget.tableDataList.length, (index) => getPdfTableData(index: index))
          ]),
        ];
      },
    ));

    return await doc.save();
  }

  getPdfHeaderData({required int index}) {
    return pdf.Flexible(
        child: pdf.Text("${widget.tableHeaderList[index]}",
            textAlign: pdf.TextAlign.center, style: pdf.TextStyle(color: PdfColors.white, fontSize: 12, fontWeight: pdf.FontWeight.bold)));
  }

  getPdfTableData({required int index}) {
    return pdf.TableRow(decoration: pdf.BoxDecoration(color: index % 2 == 0 ? PdfColor.fromHex("#d3d3d3") : PdfColors.white), children: [
      for (var element in widget.tableDataList[index].entries)
        pdf.Flexible(child: pdf.SizedBox(height: 80.0, width: 70.0, child: pdf.Text("${element.value}", textAlign: pdf.TextAlign.center))),
    ]);
  }
}

class OperationalExpenseBudgetTableWidget extends StatefulWidget {
  final List tableHeaderList;
  final List tableFooterList;
  final List tableDataList;
  final TextEditingController searchController;
  final GlobalKey<FormFieldState> searchKey;
  final Function()? onTapCategory;
  final Function()? onTapItem;
  final double headerWidth1;
  final double headerWidth2;
  final double footerWidth1;
  final double footerWidth2;
  final double cellWidth1;
  final double cellWidth2;

  const OperationalExpenseBudgetTableWidget(
      {super.key,
      this.onTapCategory,
      this.onTapItem,
      required this.tableFooterList,
      required this.headerWidth1,
      required this.headerWidth2,
      required this.footerWidth1,
      required this.footerWidth2,
      required this.cellWidth1,
      required this.cellWidth2,
      required this.tableHeaderList,
      required this.tableDataList,
      required this.searchController,
      required this.searchKey});

  @override
  State<OperationalExpenseBudgetTableWidget> createState() => _OperationalExpenseBudgetTableWidgetState();
}

class _OperationalExpenseBudgetTableWidgetState extends State<OperationalExpenseBudgetTableWidget> {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();

  RxList tableSearchDataList = [].obs;
  RxBool isAscending1 = true.obs;
  RxBool isAscending = true.obs;
  RxInt sortColumnIndex1 = 0.obs;
  RxInt sortColumnIndex = 0.obs;

  ScrollController? c1;
  ScrollController? c2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableSearchDataList.value = widget.tableDataList;

    scrollController1.addListener(
      () {
        if (scrollController1.offset != scrollController2.offset) {
          scrollController2.jumpTo(scrollController1.offset);
          scrollController3.jumpTo(scrollController1.offset);
        }
      },
    );

    scrollController2.addListener(
      () {
        if (scrollController1.offset != scrollController2.offset) {
          scrollController1.jumpTo(scrollController2.offset);
          scrollController3.jumpTo(scrollController2.offset);
        }
      },
    );

    scrollController3.addListener(
      () {
        if (scrollController1.offset != scrollController3.offset) {
          scrollController1.jumpTo(scrollController3.offset);
          scrollController2.jumpTo(scrollController3.offset);
        }
      },
    );

    scrollController3.addListener(
      () {
        if (scrollController2.offset != scrollController3.offset) {
          scrollController1.jumpTo(scrollController3.offset);
          scrollController2.jumpTo(scrollController3.offset);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        spacing: 20.0,
        children: [
          ReportsShowItemCountsAndButton(
              tableDataList: tableSearchDataList,
              onTapForCopy: () {
                getDefaultReportsCopyView();
              },
              onTapForCSV: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    await getDefaultReportsCsvView();
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  await getDefaultReportsCsvView();
                }
              },
              onTapForExcel: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    await getDefaultReportsExcelView();
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  await getDefaultReportsExcelView();
                }
              },
              onTapForPDF: () async {
                if (Platform.isAndroid) {
                  if (await Permission.manageExternalStorage.isGranted) {
                    Get.to(() => ViewPrintSavePdf(
                        pdfFile: (pageFormat) => getReportsCustomShowPdfView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
                  } else {
                    PermissionHelper.storagePermissionAccess();
                  }
                } else {
                  Get.to(() => ViewPrintSavePdf(
                      pdfFile: (pageFormat) => getReportsCustomShowPdfView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
                }
              },
              onChange: (value) {
                getDefaultReportsShowTableFilter(value: value);
              },
              textEditingController: widget.searchController,
              textFieldValidationKey: widget.searchKey),
          Obx(() {
            return tableSearchDataList.isNotEmpty
                ? SizedBox(
                    height: (DeviceType.isMobile && orientation.DeviceOrientation.isPortrait)
                        ? Get.height / 1.9
                        : (DeviceType.isMobile && orientation.DeviceOrientation.isLandscape)
                            ? Get.height / 2.0
                            : (DeviceType.isTablet && orientation.DeviceOrientation.isPortrait)
                                ? Get.height / 1.31
                                : Get.height / 1.51,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                              child: Obx(() {
                                return DataTable(
                                  sortAscending: isAscending1.value,
                                  sortColumnIndex: sortColumnIndex1.value,
                                  showCheckboxColumn: true,
                                  dataRowMaxHeight: 80.0,
                                  headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                  headingTextStyle: const TextStyle(fontSize: 16.0),
                                  border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                                  clipBehavior: Clip.antiAlias,
                                  columns: [
                                    DataColumn(
                                        headingRowAlignment: MainAxisAlignment.center,
                                        onSort: (columnIndex, ascending) {
                                          isAscending1.value = ascending;
                                          sortColumnIndex1.value = columnIndex;
                                          if (columnIndex == 0) {
                                            if (ascending) {
                                              tableSearchDataList.sort(
                                                (a, b) {
                                                  return b[b.keys.elementAt(columnIndex)].compareTo(a[a.keys.elementAt(columnIndex)]);
                                                },
                                              );
                                            } else {
                                              tableSearchDataList.sort((a, b) {
                                                return a[a.keys.elementAt(columnIndex)].compareTo(b[b.keys.elementAt(columnIndex)]);
                                              });
                                            }
                                          }
                                        },
                                        label: SizedBox(width: widget.headerWidth1, child: ReportsText(title: widget.tableHeaderList.first, titleColor: ColorConstants.white)))
                                  ],
                                  rows: [],
                                );
                              }),
                            ),
                            Expanded(child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  controller: scrollController1,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                                    child: Theme(
                                      data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                      child: Obx(() {
                                        return DataTable(
                                            //headingRowHeight: 0,
                                            sortAscending: isAscending.value,
                                            sortColumnIndex: sortColumnIndex.value,
                                            showCheckboxColumn: true,
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              for (int i = 1; i < widget.tableHeaderList.length; i++) ...{
                                                DataColumn(
                                                    headingRowAlignment: MainAxisAlignment.center,
                                                    onSort: (columnIndex, ascending) {
                                                      isAscending.value = ascending;
                                                      sortColumnIndex.value = columnIndex;
                                                      if (columnIndex == 0 || columnIndex <= tableSearchDataList.length) {
                                                        if (ascending) {
                                                          tableSearchDataList.sort(
                                                            (a, b) {
                                                              return b[b.keys.elementAt(columnIndex)].compareTo(a[a.keys.elementAt(columnIndex)]);
                                                            },
                                                          );
                                                        } else {
                                                          tableSearchDataList.sort((a, b) {
                                                            return a[a.keys.elementAt(columnIndex)].compareTo(b[b.keys.elementAt(columnIndex)]);
                                                          });
                                                        }
                                                      }
                                                    },
                                                    label: SizedBox(
                                                      width: widget.headerWidth2,
                                                      child: ReportsText(
                                                        title: widget.tableHeaderList[i].toString(),
                                                        titleColor: ColorConstants.white,
                                                      ),
                                                    ))
                                              }
                                            ],
                                            rows: []);
                                      }),
                                    ),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                        Flexible(
                          child: Obx(() {
                            return tableSearchDataList.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                          child: DataTable(
                                            headingRowHeight: 0,
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(
                                              color: ColorConstants.white,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              DataColumn(
                                                  headingRowAlignment: MainAxisAlignment.center,
                                                  label:
                                                      SizedBox(width: widget.cellWidth1, child: ReportsText(title: widget.tableHeaderList.first, titleColor: ColorConstants.white)))
                                            ],
                                            rows: List.generate(
                                              tableSearchDataList.length,
                                              (index) {
                                                return DataRow(
                                                    color: index != tableSearchDataList.length
                                                        ? WidgetStateProperty.all(
                                                            index % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.6))
                                                        : WidgetStateProperty.all(ColorConstants.background),
                                                    cells: [
                                                      DataCell(SingleChildScrollView(
                                                          child: SizedBox(width: 120.0, child: ReportsText(title: tableSearchDataList[index]["expenseType"])))),
                                                    ]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SingleChildScrollView(
                                              controller: scrollController2,
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(minWidth: constraints.minWidth),
                                                child: Theme(
                                                  data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                                  child: Obx(() {
                                                    return DataTable(
                                                        headingRowHeight: 0,
                                                        dataRowMaxHeight: 80.0,
                                                        headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                                        headingTextStyle: const TextStyle(fontSize: 16.0),
                                                        border: TableBorder.all(
                                                          color: ColorConstants.white,
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        columns: [
                                                          for (int i = 1; i < widget.tableHeaderList.length; i++) ...{
                                                            DataColumn(
                                                                headingRowAlignment: MainAxisAlignment.center,
                                                                label: SizedBox(
                                                                  width: widget.cellWidth2,
                                                                  child: ReportsText(
                                                                    title: widget.tableHeaderList[i].toString(),
                                                                    titleColor: ColorConstants.white,
                                                                  ),
                                                                ))
                                                          }
                                                        ],
                                                        rows: List.generate(
                                                          tableSearchDataList.length,
                                                          (index) {
                                                            return DataRow(
                                                                color: index != tableSearchDataList.length
                                                                    ? WidgetStateProperty.all(index % 2 == 0
                                                                        ? ColorConstants.primary.withValues(alpha: 0.3)
                                                                        : ColorConstants.primary.withValues(alpha: 0.6))
                                                                    : WidgetStateProperty.all(ColorConstants.background),
                                                                cells: [
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(width: 120.0, child: ReportsText(title: "${tableSearchDataList[index]["accountTitle"]}")))),
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(
                                                                          width: 120.0,
                                                                          child: GestureDetector(
                                                                            onTap: widget.onTapItem,
                                                                            child: ReportsTableText(
                                                                              title: "${tableSearchDataList[index]["budgetedAmount"]}",
                                                                              fontWeight: FontWeight.bold,
                                                                              titleColor:
                                                                                  tableSearchDataList[index]["budgetedAmount"] < 0 ? ColorConstants.red : ColorConstants.black,
                                                                            ),
                                                                          )))),
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(
                                                                          width: 120.0,
                                                                          child: ReportsText(
                                                                            title: "${tableSearchDataList[index]["expenditures"]}",
                                                                            titleColor: tableSearchDataList[index]["expenditures"] < 0 ? ColorConstants.red : ColorConstants.black,
                                                                          )))),
                                                                  DataCell(SingleChildScrollView(
                                                                      child: SizedBox(
                                                                    width: 120.0,
                                                                    child: ReportsText(
                                                                      title: "${tableSearchDataList[index]["balance"]}",
                                                                      titleColor: tableSearchDataList[index]["balance"] < 0 ? ColorConstants.red : ColorConstants.black,
                                                                    ),
                                                                  ))),
                                                                ]);
                                                          },
                                                        ));
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                      ],
                                    ),
                                  )
                                : const SizedBox();
                          }),
                        ),
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                              child: DataTable(
                                dataRowMaxHeight: 80.0,
                                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                headingTextStyle: const TextStyle(fontSize: 16.0),
                                border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0))),
                                clipBehavior: Clip.antiAlias,
                                columns: [
                                  DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: SizedBox(width: widget.footerWidth1, child: ReportsText(title: widget.tableFooterList.first, titleColor: ColorConstants.white)))
                                ],
                                rows: [],
                              ),
                            ),
                            Expanded(child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  controller: scrollController3,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                                    child: Theme(
                                        data: ThemeData(iconTheme: const IconThemeData(color: ColorConstants.white)),
                                        child: DataTable(
                                            dataRowMaxHeight: 80.0,
                                            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
                                            headingTextStyle: const TextStyle(fontSize: 16.0),
                                            border: TableBorder.all(color: ColorConstants.white, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10.0))),
                                            clipBehavior: Clip.antiAlias,
                                            columns: [
                                              for (int i = 1; i < widget.tableFooterList.length; i++) ...{
                                                DataColumn(
                                                    headingRowAlignment: MainAxisAlignment.center,
                                                    label: SizedBox(
                                                      width: widget.footerWidth2,
                                                      child: ReportsText(
                                                        title: widget.tableFooterList[i].toString(),
                                                        titleColor: ColorConstants.white,
                                                      ),
                                                    ))
                                              }
                                            ],
                                            rows: [])),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                      ],
                    ))
                : const Center(
                    child: ReportsText(title: "No data available in table"),
                  );
          }),
        ],
      ),
    );
  }

  getDefaultReportsShowTableFilter({required String value}) {
    List<dynamic> result = [];
    if (value.toString().isEmpty) {
      result = widget.tableDataList;
    } else {
      result = widget.tableDataList.where(
        (element) {
          return element.values.toString().toLowerCase().contains(value.toString().toLowerCase());
        },
      ).toList();
    }
    return tableSearchDataList.value = result;
  }

  getDefaultReportsCopyView() {
    String data = "";
    data += "Digital AirWare © 2024\t\n\n";
    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      data += "${widget.tableHeaderList[i]}\t";
    }
    data += "\n";
    for (int index = 0; index < widget.tableDataList.length; index++) {
      for (var element in widget.tableDataList[index].entries) {
        data += "${element.value}\t";
      }
      data += "\n";
    }
    CopyIntoClipboard.copyText(text: data, message: "${widget.tableDataList.length} rows");
  }

  getDefaultReportsExcelView() async {
    final Excel workbook = Excel.createExcel();
    final Sheet sheet = workbook['Sheet1'];

    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = TextCellValue(widget.tableHeaderList[i]);
    }

    for (int i = 0; i < widget.tableDataList.length; i++) {
      var a = 0;
      var n = i + 1;
      for (var element in widget.tableDataList[i].entries) {
        sheet.cell(CellIndex.indexByColumnRow(rowIndex: n, columnIndex: a)).value = TextCellValue(element.value.toString());
        a++;
      }
    }
    final List<int>? bytes = workbook.save(fileName: "reports_custom_show_index_view.xlsx");
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    String? file = dir;
    File f = File("$file/reports_custom_show_index_view.xlsx");
    f.writeAsBytes(bytes!, flush: true);
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  getDefaultReportsCsvView() async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    for (int i = 0; i < widget.tableHeaderList.length; i++) {
      row.add(widget.tableHeaderList[i]);
    }
    rows.add(row);

    for (int i = 0; i < widget.tableDataList.length; i++) {
      List<dynamic> cellData = [];
      for (var element in widget.tableDataList[i].entries) {
        cellData.add(element.value.toString());
        rows.add(cellData);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    String? file = dir;
    File f = File("$file/reports_custom_show_index.csv");
    f.writeAsString(csv);
    f.readAsStringSync();
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  Future<Uint8List> getReportsCustomShowPdfView({PdfPageFormat? pageFormat}) async {
    final doc = pdf.Document();
    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    doc.addPage(pdf.MultiPage(
      pageFormat: pageFormat,
      maxPages: 1000,
      theme: themeData,
      header: (context) {
        return pdf.SizedBox();
      },
      margin: const pdf.EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      build: (context) {
        return [
          pdf.Table(border: const pdf.TableBorder(), children: [
            pdf.TableRow(
              decoration: pdf.BoxDecoration(
                color: PdfColor.fromHex("#4C597F"),
              ),
              children: List.generate(widget.tableHeaderList.length, (index) => getPdfHeaderData(index: index)),
            ),
            ...List.generate(widget.tableDataList.length, (index) => getPdfTableData(index: index))
          ]),
        ];
      },
    ));

    return await doc.save();
  }

  getPdfHeaderData({required int index}) {
    return pdf.Flexible(
        child: pdf.Text("${widget.tableHeaderList[index]}",
            textAlign: pdf.TextAlign.center, style: pdf.TextStyle(color: PdfColors.white, fontSize: 12, fontWeight: pdf.FontWeight.bold)));
  }

  getPdfTableData({required int index}) {
    return pdf.TableRow(decoration: pdf.BoxDecoration(color: index % 2 == 0 ? PdfColor.fromHex("#d3d3d3") : PdfColors.white), children: [
      for (var element in widget.tableDataList[index].entries)
        pdf.Flexible(child: pdf.SizedBox(height: 80.0, width: 70.0, child: pdf.Text("${element.value}", textAlign: pdf.TextAlign.center))),
    ]);
  }
}

///*************** END TAYEB BLOCKS **************

///*************** START SURJIT's BLOCKS ***************
class ReportsDropDown extends StatelessWidget {
  final String? fieldType;
  final bool req;
  final bool expands;
  final GlobalKey<FormFieldState>? validationKey;
  final bool showField;
  final String? fieldName;
  final TextEditingController dropDownController;
  final List? dropDownData;
  final String dropDownKey;
  final String? hintText;
  final void Function(Map value)? onChanged;
  final void Function(Map value)? initialValue;

  ///Use on element type select
  const ReportsDropDown(
      {super.key,
      this.fieldType,
      this.req = false,
      this.expands = false,
      this.validationKey,
      this.showField = true,
      this.fieldName,
      required this.dropDownController,
      required this.dropDownData,
      required this.dropDownKey,
      this.hintText,
      this.onChanged,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    initialValue?.call(dropDownData?.first);

    return showField
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              if ((fieldName != null && fieldName != "") || req)
                Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              Padding(
                padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
                child: FormBuilderField(
                  key: validationKey,
                  name: fieldName?.toLowerCase().replaceAll(" ", "_") ?? "drop_down",
                  validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder: (FormFieldState<dynamic> field) => DropdownMenu(
                    controller: dropDownController,
                    enableFilter: false,
                    menuHeight: Get.height - 200,
                    width: Get.width > 1080
                        ? Get.width / 2
                        : Get.width > 540
                            ? 540
                            : Get.width,
                    expandedInsets: expands ? EdgeInsets.zero : null,
                    dropdownMenuEntries: dropDownData == null
                        ? [const DropdownMenuEntry(value: {}, label: "")]
                        : dropDownData!.map((value) {
                            return DropdownMenuEntry<Map>(
                              value: value,
                              label: "${value[dropDownKey]}".trim(),
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                              ),
                            );
                          }).toList(),
                    onSelected: (value) {
                      if (req && dropDownData?.first[dropDownKey] != value?[dropDownKey]) {
                        field.didChange(value);
                      } else if (!req) {
                        field.didChange(value);
                      } else {
                        field.reset();
                      }
                      onChanged != null ? onChanged!(value ?? {}) : null;
                    },
                    trailingIcon: const Icon(Icons.keyboard_arrow_down, size: 28, color: ColorConstants.black),
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    hintText: hintText ?? ((dropDownData ?? []).isNotEmpty ? (dropDownData?.first[dropDownKey] ?? "") : ""),
                    errorText: field.errorText,
                    inputDecorationTheme: InputDecorationTheme(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(color: ColorConstants.black),
                        errorStyle: const TextStyle(color: ColorConstants.red),
                        border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        enabledBorder:
                            OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        focusedBorder:
                            OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius))),
                  ),
                ),
              )
            ]),
          )
        : const SizedBox.shrink();
  }
}

class ReportsDateTime extends StatelessWidget {
  final String? fieldType;
  final bool req;
  final GlobalKey<FormFieldState>? validationKey;
  final bool showField;
  final String? fieldName;
  final TextEditingController dateTimeController;
  final bool isDense;
  final RxBool disableKeyboard;
  final String? hintText;
  final String? dateType;
  final void Function(DateTime dateTime)? onConfirm;
  final void Function()? onCancel;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final String Function(String value)? initialValue;

  ///Use on element type dateTime
  const ReportsDateTime(
      {super.key,
      this.fieldType,
      this.req = false,
      this.validationKey,
      this.showField = true,
      this.fieldName,
      required this.dateTimeController,
      this.isDense = false,
      required this.disableKeyboard,
      this.hintText,
      this.dateType,
      this.onConfirm,
      this.onCancel,
      this.onTap,
      this.onChanged,
      this.onEditingComplete,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return showField
        ? Padding(
            padding: isDense ? const EdgeInsets.all(5.0) : EdgeInsets.zero,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              if ((fieldName != null && fieldName != "") || req)
                Text("${fieldName ?? ""}${req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              Padding(
                padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
                child: FormBuilderField(
                  key: validationKey,
                  name: fieldName?.toLowerCase().replaceAll(" ", "_") ?? "date_time",
                  validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder: (FormFieldState<dynamic> field) => Obx(() {
                    return TextField(
                      controller: initialValue != null
                          ? (dateTimeController..text = initialValue!.call(DateFormat(fieldType == "Time" ? "HH:mm" : "MM/dd/yyyy").format(DateTimeHelper.now)))
                          : dateTimeController,
                      readOnly: disableKeyboard.value,
                      showCursor: !disableKeyboard.value,
                      cursorColor: Colors.black,
                      maxLength: fieldType == "Time" ? 5 : 10,
                      keyboardType: disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                      inputFormatters: [
                        fieldType == "Time"
                            ? FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?:?(\d{1,2})?'))
                            : FilteringTextInputFormatter.allow(RegExp(r'^(\d{1,2})?/?(\d{1,2})?/?(\d{1,4})?'))
                      ],
                      onTap: () {
                        onTap != null ? onTap!() : null;
                        if (disableKeyboard.value) {
                          DatePicker.showDatePicker(
                            context,
                            dateFormat: fieldType == "Time" ? "HH:mm" : "MM/dd/yyyy",
                            pickerMode: fieldType == "Time" ? DateTimePickerMode.time : DateTimePickerMode.date,
                            minDateTime: dateType == "OtherDate" ? DateTimeHelper.now : DateTime(2015, 1, 1),
                            onConfirm: (date, list) {
                              dateTimeController.text = DateFormat(fieldType == "Time" ? "HH:mm" : "MM/dd/yyyy").format(date);
                              field.didChange(date);
                              disableKeyboard.value = true;
                              onConfirm != null ? onConfirm!(date) : null;
                            },
                            onCancel: () {
                              disableKeyboard.value = false;
                              onCancel != null ? onCancel!() : null;
                            },
                            initialDateTime: DateFormat(fieldType == "Time" ? "HH:mm" : "MM/dd/yyyy").parse(dateTimeController.text),
                            locale: DATETIME_PICKER_LOCALE_DEFAULT,
                          );
                        }
                      },
                      onChanged: (String value) {
                        if (value != "") {
                          field.didChange(value);
                        } else {
                          field.reset();
                        }
                        onChanged != null ? onChanged!(value) : null;
                      },
                      onEditingComplete: () {
                        disableKeyboard.value = true;
                        field.didChange(dateTimeController.text);
                        FocusScope.of(context).unfocus();
                        onEditingComplete != null ? onEditingComplete!() : null;
                      },
                      onTapOutside: (event) {
                        disableKeyboard.value = true;
                        field.didChange(dateTimeController.text);
                        FocusScope.of(context).unfocus();
                        Keyboard.close(context: context);
                      },
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstants.black, fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 4),
                      decoration: InputDecoration(
                          isDense: isDense,
                          filled: true,
                          fillColor: Colors.white,
                          counterText: "",
                          hintText: hintText ?? (fieldType == "Time" ? "hh:mm" : "mm/dd/yyyy"),
                          hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize)! - 5),
                          errorText: field.errorText,
                          errorStyle: TextStyle(color: ColorConstants.red, fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 6),
                          border: OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                          enabledBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                          focusedBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.black), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                          errorBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius))),
                    );
                  }),
                ),
              )
            ]),
          )
        : const SizedBox.shrink();
  }
}

class ReportsCheckBox extends StatelessWidget {
  final String? fieldType;
  final bool req;
  final GlobalKey<FormFieldState>? validationKey;
  final MainAxisSize mainAxisSize;
  final bool showField;
  final String? fieldName;
  final Color? fieldNameColor;
  final void Function()? onTapFieldName;
  final void Function(bool? value)? onChanged;
  final RxBool Function(bool value)? initialValue;

  ///Use on element type checkBox
  const ReportsCheckBox(
      {super.key,
      this.fieldType,
      this.req = false,
      this.validationKey,
      this.mainAxisSize = MainAxisSize.min,
      this.showField = true,
      this.fieldName,
      this.fieldNameColor,
      this.onTapFieldName,
      this.onChanged,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return showField
        ? Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: onTapFieldName,
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(mainAxisSize: mainAxisSize, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  if ((fieldName != null && fieldName != "") || req)
                    Flexible(child: Text("${fieldName ?? ""}${req ? " *" : ""}", style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5, color: fieldNameColor))),
                  Padding(
                    padding: (fieldName != null && fieldName != "") ? const EdgeInsets.only(left: 2.0) : EdgeInsets.zero,
                    child: FormBuilderField(
                      key: validationKey,
                      name: fieldName?.toLowerCase().replaceAll(" ", "_") ?? "check_box",
                      validator: req ? FormBuilderValidators.required(errorText: "${fieldName ?? "This"} Field is Required.") : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      builder: (FormFieldState<dynamic> field) => Obx(() {
                        return Checkbox(
                            activeColor: ColorConstants.primary,
                            fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return ColorConstants.grey;
                              } else if (states.contains(WidgetState.disabled)) {
                                return Colors.grey.shade300;
                              }
                              return ColorConstants.white;
                            }),
                            side: const BorderSide(color: ColorConstants.grey, width: 1.5),
                            value: initialValue?.call(false).value ?? false,
                            onChanged: onChanged);
                      }),
                    ),
                  ),
                ]),
              ),
            )
          ])
        : const SizedBox.shrink();
  }
}

class ReportsCustomTextButton extends StatelessWidget {
  final String? buttonText;
  final bool insideBracket;
  final void Function()? onPressed;

  ///Use on element type customText button
  const ReportsCustomTextButton({super.key, this.buttonText, this.insideBracket = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
        onPressed: onPressed,
        child: RichText(
          textScaler: TextScaler.linear(Get.textScaleFactor),
          text: TextSpan(
            text: insideBracket ? "[ " : "",
            style: TextStyle(color: ThemeColorMode.isLight ? ColorConstants.text : null, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            children: [
              TextSpan(text: buttonText ?? "", style: const TextStyle(color: ColorConstants.primary, decoration: TextDecoration.underline)),
              if (insideBracket) const TextSpan(text: " ]")
            ],
          ),
        ));
  }
}

class ReportsSelectionBox extends StatefulWidget {
  final String? fieldType;
  final bool req;
  final bool showField;
  final String? fieldName;
  final List selectionBoxData;
  final String itemsIdKey;
  final String itemsNameKey;
  final String? hintText;
  final void Function(Map value)? onSelectRemove;
  final void Function(List value)? onSelectRemoveAll;
  final void Function(List value)? selectedValues;
  final void Function()? initialValue;

  ///Use on element type multiple select
  const ReportsSelectionBox(
      {super.key,
      this.fieldType,
      this.req = false,
      this.showField = true,
      this.fieldName,
      required this.selectionBoxData,
      required this.itemsIdKey,
      required this.itemsNameKey,
      this.hintText,
      this.onSelectRemove,
      this.onSelectRemoveAll,
      this.selectedValues,
      this.initialValue});

  @override
  State<ReportsSelectionBox> createState() => _ReportsSelectionBoxState();
}

class _ReportsSelectionBoxState extends State<ReportsSelectionBox> {
  final RxBool allSelected = false.obs;
  final Map<String, RxBool> selectedItem = <String, RxBool>{};

  @override
  void initState() {
    super.initState();
    widget.initialValue?.call();
    //for (var item in widget.selectionBoxData) {
    //  selected[item[widget.itemsIdKey]] ??= false.obs;
    //}
  }

  @override
  Widget build(BuildContext context) {
    return widget.showField
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              if ((widget.fieldName != null && widget.fieldName != "") || widget.req)
                Text("${widget.fieldName ?? ""}${widget.req ? " *" : ""}", style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              if (widget.selectionBoxData.isNotEmpty) ...{
                Obx(() {
                  return ReportsCheckBox(
                      fieldName:
                          "${allSelected.isTrue ? "Remove" : "Select"} All ${(widget.fieldName?.contains("Users") ?? false) ? "Users" : (widget.fieldName?.contains("Mechanics") ?? false) ? "Mechanics" : (widget.fieldName?.contains("Aircraft") ?? false) ? "Aircraft" : "Items"}",
                      initialValue: (value) => allSelected,
                      onTapFieldName: () {
                        allSelected.value = !allSelected.value;
                        if (allSelected.isTrue) {
                          for (var item in widget.selectionBoxData) {
                            selectedItem[item[widget.itemsIdKey]]!.value = true;
                          }
                        } else {
                          for (var item in widget.selectionBoxData) {
                            selectedItem[item[widget.itemsIdKey]]!.value = false;
                          }
                        }
                        widget.onSelectRemoveAll?.call(allSelected.isTrue ? widget.selectionBoxData : []);
                        widget.selectedValues?.call(allSelected.isTrue ? widget.selectionBoxData : []);
                      },
                      onChanged: (value) {
                        allSelected.value = value!;
                        if (allSelected.isTrue) {
                          for (var item in widget.selectionBoxData) {
                            selectedItem[item[widget.itemsIdKey]]!.value = true;
                          }
                        } else {
                          for (var item in widget.selectionBoxData) {
                            selectedItem[item[widget.itemsIdKey]]!.value = false;
                          }
                        }
                        widget.onSelectRemoveAll?.call(allSelected.isTrue ? widget.selectionBoxData : []);
                        widget.selectedValues?.call(allSelected.isTrue ? widget.selectionBoxData : []);
                      });
                }),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      color: ThemeColorMode.isDark ? ColorConstants.primary.withValues(alpha: 0.8) : ColorConstants.primary.withValues(alpha: 0.2),
                      border: Border.all(color: ColorConstants.black),
                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                  constraints: BoxConstraints(
                      maxHeight: context.heightTransformer(dividedBy: 2, reducedBy: 5.0),
                      maxWidth: Get.width > 1080
                          ? Get.width / 2
                          : Get.width > 540
                              ? 540
                              : Get.width),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: widget.selectionBoxData.map((items) {
                        return Obx(() {
                          return ReportsCheckBox(
                              mainAxisSize: MainAxisSize.max,
                              fieldName: items[widget.itemsNameKey] == "" ? " " : items[widget.itemsNameKey],
                              fieldNameColor:
                                  (selectedItem[items[widget.itemsIdKey].toString()] ??= false.obs).isFalse ? ColorConstants.text.withValues(alpha: 0.6) : ColorConstants.black,
                              initialValue: (value) => selectedItem[items[widget.itemsIdKey].toString()] ??= value.obs,
                              onTapFieldName: () {
                                selectedItem[items[widget.itemsIdKey].toString()]!.value = !selectedItem[items[widget.itemsIdKey].toString()]!.value;
                                selectedItem.containsValue(false.obs) ? allSelected.value = false : allSelected.value = true;
                                widget.onSelectRemove?.call(items);
                                widget.selectedValues?.call(widget.selectionBoxData.where((element) => selectedItem[element[widget.itemsIdKey]]!.isTrue).toList());
                              },
                              onChanged: (value) {
                                selectedItem[items[widget.itemsIdKey].toString()]?.value = value!;
                                selectedItem.containsValue(false.obs) ? allSelected.value = false : allSelected.value = true;
                                widget.onSelectRemove?.call(items);
                                widget.selectedValues?.call(widget.selectionBoxData.where((element) => selectedItem[element[widget.itemsIdKey]]!.isTrue).toList());
                              });
                        });
                      }).toList(),
                    ),
                  ),
                )
              } else ...{
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 5.0),
                  constraints: BoxConstraints(
                      maxWidth: Get.width > 1080
                          ? Get.width / 2
                          : Get.width > 540
                              ? 540
                              : Get.width),
                  decoration: BoxDecoration(
                      color: ThemeColorMode.isDark ? ColorConstants.primary.withValues(alpha: 0.8) : ColorConstants.primary.withValues(alpha: 0.2),
                      border: Border.all(color: ColorConstants.black),
                      borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                  child: const Text("No Items Available"),
                )
              },
              if (widget.fieldType == "true")
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5.0),
                    constraints: BoxConstraints(
                        maxWidth: Get.width > 1080
                            ? Get.width / 2
                            : Get.width > 540
                                ? 540
                                : Get.width),
                    child: const Text("(Note: SysOp Access, All Aircraft From Service Shown.)"))
            ]),
          )
        : const SizedBox.shrink();
  }
}

///*************** END SURJIT's BLOCKS ***************

///*************** START RAHAT BLOCKS ****************

class ReportsDynamicDataTable extends StatelessWidget {
  final List? tableMainData;

  final List? tableHeaderData;

  final List? keyName;

  final List? tableBottomHeaderData;

  final List? tableRowWidth;

  final bool? headingRowHeightEnable;
  final double? headingRowHeight;

  final bool? rowDataHeightEnable;

  final bool? differentDataRowViewEnable;

  final RxInt? end;
  final RxInt? start;

  final List? itemOnTap;
  final void Function(int index)? onTapZero;
  final void Function(int index)? onTapMany;

  final ScrollController? tableHeaderScrollController;
  final ScrollController? tableDataScrollController;
  final ScrollController? tableBottomHeaderScrollController;

  const ReportsDynamicDataTable(
      {super.key,
      required this.tableMainData,
      this.end,
      this.start,
      required this.tableHeaderData,
      required this.keyName,
      required this.tableBottomHeaderData,
      required this.tableRowWidth,
      this.headingRowHeightEnable = false,
      this.headingRowHeight,
      this.rowDataHeightEnable = false,
      this.itemOnTap,
      this.onTapZero,
      this.onTapMany,
      this.differentDataRowViewEnable = false,
      required this.tableHeaderScrollController,
      required this.tableDataScrollController,
      required this.tableBottomHeaderScrollController});

  tableHeaderTextStyleReturn() {
    return TextStyle(
        fontSize: DeviceType.isTablet ? Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 4 : Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    RxList itemsNew = [].obs;

    RxList items = [].obs;

    RxList<bool> itemsSort = <bool>[].obs;

    items.addAll(tableMainData!);
    // itemsNew.addAll(tableMainData!);

    for (int i = 0; i < tableHeaderData!.length; i++) {
      itemsSort.add(false);
    }

    // sortTableDataFunction({required String keyName, required int i}) {
    //   items.clear();
    //
    //   tableMainData!.sort((a, b) {
    //     return (a[keyName]).compareTo(b[keyName]);
    //   });
    //   itemsSort[i] = !itemsSort[i];
    //   for (int i = 0; i < tableMainData!.length; i++) {
    //     items.add(tableMainData![i]);
    //   }
    //   EasyLoading.dismiss();
    //   if (itemsSort[i]) {
    //     itemsNew.clear();
    //     itemsNew.addAll(items);
    //     return itemsNew;
    //   }
    //   else {
    //     itemsNew.clear();
    //     itemsNew.addAll(items.reversed);
    //     return itemsNew;
    //   }
    // }

    sortTableDataFunction({required String keyName, required int i}) {
      items.clear();

      if (keyName.toString().toLowerCase().contains('date')) {
        if (itemsSort[i]) {
          tableMainData!.sort((a, b) => (DateTimeHelper.dateFormatDefault.parse(a[keyName])).compareTo(DateTimeHelper.dateFormatDefault.parse(b[keyName])));
        } else {
          tableMainData!.sort((a, b) => (DateTimeHelper.dateFormatDefault.parse(b[keyName])).compareTo(DateTimeHelper.dateFormatDefault.parse(a[keyName])));
        }
      } else {
        if (itemsSort[i]) {
          tableMainData!.sort((a, b) {
            return (a[keyName]).compareTo(b[keyName]);
          });
        } else {
          tableMainData!.sort((a, b) {
            return (b[keyName]).compareTo(a[keyName]);
          });
        }
      }

      itemsSort[i] = !itemsSort[i];
      for (int i = 0; i < tableMainData!.length; i++) {
        items.add(tableMainData![i]);
      }
      EasyLoading.dismiss();
    }

    differentViewWidgetsReturn({required String keyName, required int abc}) {
      switch (keyName) {
        case 'pdfImage':
          return const Icon(MaterialCommunityIcons.file_pdf, color: ColorConstants.red, size: 25.0);
        default:
          return Text(itemsNew[abc][keyName].toString(), style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2));
      }
    }

    dynamicTableHeaderView() {
      return Row(
        children: [
          DataTable(
            border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
            headingRowHeight: headingRowHeightEnable! ? headingRowHeight : 55.0,
            clipBehavior: Clip.antiAlias,
            columns: List.generate(1, (index) {
              return DataColumn(
                  label: SizedBox(
                width: tableRowWidth![0],
                child: Center(
                  child: TextButton.icon(
                    icon: RotatedBox(
                      quarterTurns: 0,
                      child: Icon(itemsSort[0] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                    ),
                    label: Text(tableHeaderData![0], style: tableHeaderTextStyleReturn()),
                    onPressed: () async {
                      await LoaderHelper.loaderWithGifAndText('Processing');
                      sortTableDataFunction(keyName: keyName![0], i: 0);
                    },
                  ),
                ),
              ));
            }),
            rows: const [],
            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: tableHeaderScrollController,
              child: DataTable(
                border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                clipBehavior: Clip.antiAlias,
                headingRowHeight: headingRowHeightEnable! ? headingRowHeight : 55.0,
                columns: List.generate(tableHeaderData!.length - 1, (index) {
                  return DataColumn(
                      label: SizedBox(
                    width: tableRowWidth![index + 1],
                    child: Center(
                      child: TextButton.icon(
                        icon: RotatedBox(
                          quarterTurns: 0,
                          child: Icon(itemsSort[index + 1] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                        ),
                        label: Text(tableHeaderData![index + 1], style: tableHeaderTextStyleReturn()),
                        onPressed: () async {
                          await LoaderHelper.loaderWithGifAndText('Processing');
                          sortTableDataFunction(keyName: keyName![index + 1], i: (index + 1));
                        },
                      ),
                    ),
                  ));
                }),
                rows: const [],
                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
              ),
            ),
          ),
        ],
      );
    }

    dynamicTableDataView() {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              children: [
                DataTable(
                  border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                  clipBehavior: Clip.antiAlias,
                  headingRowHeight: headingRowHeightEnable! ? headingRowHeight : 55.0,
                  dataRowMinHeight: rowDataHeightEnable! ? 55.0 : null,
                  dataRowMaxHeight: rowDataHeightEnable! ? 110.0 : null,
                  columns: List.generate(1, (index) {
                    return DataColumn(
                        label: SizedBox(
                      width: tableRowWidth![0],
                      child: Center(
                        child: TextButton.icon(
                          icon: RotatedBox(
                            quarterTurns: 0,
                            child: Icon(itemsSort[0] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize),
                          ),
                          label: Text(tableHeaderData?[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! - 2)),
                          onPressed: () async {
                            // await LoaderHelper.loaderWithGif();
                            // sortTableDataFunction(keyName: keyName[0], i: 0);
                          },
                        ),
                      ),
                    ));
                  }),
                  rows: List.generate(itemsNew.length, (abc) {
                    return DataRow(
                        color: abc % 2 == 0
                            ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.3))
                            : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.6)),
                        cells: [
                          DataCell(
                              onTap: () => itemOnTap != null
                                  ? itemOnTap![0]
                                      ? onTapZero?.call(abc)
                                      : null
                                  : null,
                              SizedBox(
                                  width: tableRowWidth![0],
                                  child: Center(
                                      child:
                                          Text(itemsNew[abc][keyName![0]].toString(), style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2)))))
                        ]);
                  }),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: tableDataScrollController,
                    child: DataTable(
                        border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                        clipBehavior: Clip.antiAlias,
                        headingRowHeight: headingRowHeightEnable! ? headingRowHeight : 55.0,
                        dataRowMinHeight: rowDataHeightEnable! ? 55.0 : null,
                        dataRowMaxHeight: rowDataHeightEnable! ? 110.0 : null,
                        columns: List.generate(tableHeaderData!.length - 1, (index) {
                          return DataColumn(
                              label: SizedBox(
                            width: tableRowWidth![index + 1],
                            child: Center(
                              child: TextButton.icon(
                                icon: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(itemsSort[index + 1] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize),
                                ),
                                label: Text(tableHeaderData![index + 1],
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! - 2)),
                                onPressed: () async {
                                  // await LoaderHelper.loaderWithGif();
                                  // sortTableDataFunction(keyName: keyName[index + 1], i: (index + 1));
                                },
                              ),
                            ),
                          ));
                        }),
                        rows: List.generate(itemsNew.length, (abc) {
                          return DataRow(
                              color: abc % 2 == 0
                                  ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.3))
                                  : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.6)),
                              cells: List.generate(tableHeaderData!.length - 1, (index) {
                                return DataCell(
                                    onTap: () => itemOnTap != null
                                        ? itemOnTap![index + 1]
                                            ? onTapMany?.call(abc)
                                            : null
                                        : null,
                                    rowDataHeightEnable!
                                        ? SingleChildScrollView(
                                            child: SizedBox(
                                                width: tableRowWidth![index + 1],
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                                                  child: Center(
                                                      child: Text(itemsNew[abc][keyName![index + 1]].toString(),
                                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))),
                                                )),
                                          )
                                        : SizedBox(
                                            width: tableRowWidth![index + 1],
                                            child: Center(
                                                child: differentDataRowViewEnable!
                                                    ? differentViewWidgetsReturn(keyName: keyName![index + 1], abc: abc)
                                                    : Text(itemsNew[abc][keyName![index + 1]].toString(),
                                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2)))));
                              }));
                        })),
                  ),
                ),
              ],
            ),
          ),
          dynamicTableHeaderView(),
        ],
      );
    }

    dataTableBottomHeaderView() {
      return Row(
        children: [
          DataTable(
            border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0))),
            clipBehavior: Clip.antiAlias,
            headingRowHeight: 55.0,
            columns: [
              DataColumn(
                label: SizedBox(
                  width: tableRowWidth![0],
                  child: Center(
                    child: Text(tableBottomHeaderData![0], style: tableHeaderTextStyleReturn()),
                  ),
                ),
              )
            ],
            rows: const [],
            headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: tableBottomHeaderScrollController,
              child: DataTable(
                border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10.0))),
                clipBehavior: Clip.antiAlias,
                headingRowHeight: 55.0,
                columns: List.generate(tableBottomHeaderData!.length - 1, (index) {
                  return DataColumn(
                      label: SizedBox(
                    width: tableRowWidth![index + 1],
                    child: Center(
                      child: Text(tableBottomHeaderData![index + 1], style: tableHeaderTextStyleReturn()),
                    ),
                  ));
                }),
                rows: const [],
                headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
              ),
            ),
          ),
        ],
      );
    }

    return Material(
      color: tableMainData!.isEmpty ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.transparent,
      borderRadius: BorderRadius.circular(10.0),
      child: Column(
        children: [
          tableMainData!.isNotEmpty
              ? SizedBox(
                  height: tableMainData!.length > 9
                      ? Get.height - 250.0
                      : headingRowHeightEnable!
                          ? ((tableMainData!.length - ((tableMainData!.length - 1) / 2)) * 115)
                          : ((tableMainData!.length - ((tableMainData!.length - 1) / 2)) * 100),
                  child: Obx(() {
                    itemsNew.value = items.length > 100 ? items.getRange(start!.value, end!.value).toList() : items;
                    return dynamicTableDataView();
                  }))
              : dynamicTableHeaderView(),
          if (tableMainData!.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "No Data Available in Table",
                  style: TextStyle(color: ColorConstants.red, fontSize: Theme.of(Get.context!).textTheme.bodyLarge!.fontSize! + 6),
                ),
              ),
            ),
          dataTableBottomHeaderView(),
        ],
      ),
    );
  }
}

///*************** END RAHAT BLOCKS ****************
