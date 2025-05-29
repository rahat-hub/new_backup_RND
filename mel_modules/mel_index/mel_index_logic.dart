import 'dart:io';

import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/permission_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/mel_api_provider.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/text_fields.dart';
import 'package:aviation_rnd/widgets/widgets.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart' hide TextSpan;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../helper/pdf_helper.dart';
import '../../../shared/services/device_orientation.dart' as orientation;

class MelIndexLogic extends GetxController {
  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> manageAircraftDropdownData = <Map<String, dynamic>>[
    {
      "id": 0,
      "name": "-- Filter Status --",
      "selected": true,
      "color": "black",
    },
    {
      "id": 1,
      "name": "Cleared",
      "selected": false,
      "color": "blue",
    },
    {
      "id": 2,
      "name": "Remaining",
      "selected": false,
      "color": "black",
    },
    {
      "id": 3,
      "name": "Expired",
      "selected": false,
      "color": "red",
    },
  ].obs;

  RxMap selectedManageAircraft = {}.obs;

  TextEditingController melDataTableSearchController = TextEditingController();

  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? tableHeaderScrollController;
  ScrollController? tableDataScrollController;
  ScrollController? tableBottomHeaderScrollController;

  RxList melIndexData = [].obs;

  RxBool filterSearchEnable = false.obs;

  RxList itemsNew = [].obs;

  RxList items = [].obs;

  RxList<bool> itemsSort = <bool>[].obs;

  final GlobalKey _topRowSizeKey = GlobalKey();

  Size? topRowSize;

  @override
  void onInit() async {
    super.onInit();
    LoaderHelper.loaderWithGifAndText("MEL Data Loading...");
    isLoading.value = true;

    tableHeaderScrollController = controllerGroup.addAndGet();
    tableDataScrollController = controllerGroup.addAndGet();
    tableBottomHeaderScrollController = controllerGroup.addAndGet();

    await newApiCallForMELIndexData();

    await returnMelIndexView();

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  @override
  void onClose() {
    melDataTableSearchController.clear();
    super.onClose();
  }

  addNewSortItemFilterData({caseData}) async {
    LoaderHelper.loaderWithGifAndText('Processing...');
    switch (caseData) {
      case 0:
        {
          itemsNew.clear();
          for (int i = 0; i < melIndexData.length; i++) {
            itemsNew.add(melIndexData[i]);
          }
          update();
          EasyLoading.dismiss();
          return itemsNew;
        }
      case 1:
        {
          itemsNew.clear();
          for (int i = 0; i < melIndexData.length; i++) {
            if (melIndexData[i]["daysRemainingStatus"] == 'Cleared') {
              itemsNew.add(melIndexData[i]);
            }
          }
          update();
          EasyLoading.dismiss();
          return itemsNew;
        }
      case 2:
        {
          itemsNew.clear();
          for (int i = 0; i < melIndexData.length; i++) {
            if (melIndexData[i]["daysRemainingStatus"].toString().contains('Remaining')) {
              itemsNew.add(melIndexData[i]);
            }
          }
          update();
          EasyLoading.dismiss();
          return itemsNew;
        }
      case 3:
        {
          itemsNew.clear();
          for (int i = 0; i < melIndexData.length; i++) {
            if (melIndexData[i]["daysRemainingStatus"] == 'Expired') {
              itemsNew.add(melIndexData[i]);
            }
          }
          update();
          EasyLoading.dismiss();
          return itemsNew;
        }
      default:
        update();
        EasyLoading.dismiss();
        return itemsNew;
    }
  }

  melIndexCopyView() {
    String data = "";
    data += "Digital AirWare © 2024\t\n\n";
    data += "MEL ID\tAircraft\tMEL Created At\tCreated By\tStatus\t\n";
    for (int index = 0; index < melIndexData.length; index++) {
      data +=
          "${melIndexData[index]["stringMelId"]}\t${melIndexData[index]["aircraft"]}\t${melIndexData[index]["createdAt"]}\t${melIndexData[index]["createdByName"]}\t${melIndexData[index]["statusMessage"]}\t\n";
    }

    data += "Total: ${melIndexData.length}\tAircraft\tMEL Created At\tCreated By\tStatus\t\n";

    CopyIntoClipboard.copyText(text: data, message: "${melIndexData.length} rows");
  }

  melIndexCSVView() async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("MEL ID");
    row.add("Aircraft");
    row.add("MEL Created Date");
    row.add("Created By");
    row.add("Status");
    rows.add(row);
    for (int i = 0; i < melIndexData.length; i++) {
      List<dynamic> row = [];
      row.add(melIndexData[i]["stringMelId"]);
      row.add(melIndexData[i]["aircraft"]);
      row.add(melIndexData[i]["createdAt"]);
      row.add(melIndexData[i]["createdByName"]);
      row.add(melIndexData[i]["statusMessage"]);
      rows.add(row);
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
    File f = File("$file/DAW_Discrepancy.csv");
    f.writeAsString(csv);
    f.readAsStringSync();
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  melIndexExcelViewNew() async {
    final Excel workbook = Excel.createExcel();
    final Sheet sheet = workbook['Sheet1'];

    sheet.appendRow([TextCellValue("MEL ID"), TextCellValue("Aircraft"), TextCellValue("MEL Created Date"), TextCellValue("Created By"), TextCellValue("Status")]);

    for (int i = 0; i < melIndexData.length; i++) {
      sheet.appendRow([
        TextCellValue(melIndexData[i]["stringMelId"].toString()),
        TextCellValue(melIndexData[i]["aircraft"].toString()),
        TextCellValue(melIndexData[i]["createdAt"].toString()),
        TextCellValue(melIndexData[i]["createdByName"].toString()),
        TextCellValue(melIndexData[i]["statusMessage"].toString())
      ]);
    }

    final List<int>? bytes = workbook.save(fileName: "DAW_mel_IndexData.xlsx");
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
    File f = File("$file/DAW_mel_IndexData.xlsx");
    f.writeAsBytes(bytes!, flush: true);
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  melFilterAndManageAircraftViewReturn() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        key: _topRowSizeKey,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MaterialButton(
            color: ColorConstants.primary,
            height: 50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () {
              Get.toNamed(Routes.melAircraftTypes);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.flight_outlined, size: 30, color: Colors.white),
              Text("Manage Aircraft",
                  style: TextStyle(color: Colors.white, fontSize: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize!, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            ]),
          ),
          const SizedBox(width: SizeConstants.contentSpacing),
          ResponsiveBuilder(
            builder: (context, sizingInformation) => FormBuilderField(
                name: "mel_status_maintenance",
                builder: (FormFieldState<dynamic> field) {
                  return Obx(() {
                    return WidgetConstant.customDropDownWidgetNew(
                        dropDownKey: "name",
                        context: context,
                        showTitle: false,
                        expands: false,
                        dropdownTextColorEnable: true,
                        dropDownData: manageAircraftDropdownData,
                        hintText: selectedManageAircraft.isNotEmpty ? selectedManageAircraft["name"] : manageAircraftDropdownData[0]["name"],
                        onChanged: (val) async {
                          selectedManageAircraft.value = val;
                          if (selectedManageAircraft["id"] == 0) {
                            filterSearchEnable.value = false;
                          } else {
                            filterSearchEnable.value = true;
                          }
                          await addNewSortItemFilterData(caseData: selectedManageAircraft["id"]);
                        });
                  });
                }),
          ),
        ],
      ),
    );
  }

  melStatusDataReturn({required Map data}) {
    if (data["daysRemainingStatus"].toString().contains('Cleared') || data["daysRemainingStatus"].toString().contains('Expired')) {
      return "${data["daysRemainingStatus"]}. ${data["statusMessage"]}";
    } else {
      return "${data["statusMessage"]}";
    }
  }

  routesPageAction({required Map itemData}) async {
    await LoaderHelper.loaderWithGifAndText("Loading...");
    Get.toNamed(Routes.melDetails, parameters: {
      "melId": itemData["melId"].toString(),
      "aircraftName": itemData["aircraft"],
      "melType": itemData["melType"],
    });
  }

  statusDataTableColorReturn({required String colorCodeStatus}) {
    switch (colorCodeStatus) {
      case '#4a4a00':
        return ThemeColorMode.isLight ? Colors.black : Colors.white;
      case '#080':
        return const Color.fromRGBO(0, 136, 0, 10.0);
      case '#800':
        return const Color.fromRGBO(136, 0, 0, 10.0);
      default:
        return ThemeColorMode.isLight ? Colors.black : Colors.white;
    }
  }

  Future<Uint8List> pdfViewForMelIndexView({PdfPageFormat? pageFormat}) async {
    final doc = pdf.Document();

    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    doc.addPage(
      pdf.MultiPage(
          theme: themeData,
          maxPages: 700,
          margin: const pdf.EdgeInsets.all(10.0),
          pageFormat: pageFormat,
          crossAxisAlignment: pdf.CrossAxisAlignment.center,
          header: (context) {
            return pdf.Center(
                child: pdf.Text("MEL List",
                    textAlign: pdf.TextAlign.center, style: pdf.TextStyle(fontStyle: pdf.FontStyle.italic, letterSpacing: 1.1, fontWeight: pdf.FontWeight.normal, fontSize: 14)));
          },
          footer: (context) {
            return pdf.Row(mainAxisAlignment: pdf.MainAxisAlignment.spaceAround, children: [
              pdf.Flexible(child: pdf.Text("Page: ${context.pageNumber}/${context.pagesCount}")),
            ]);
          },
          build: (context) {
            return [
              pdf.SizedBox(height: SizeConstants.contentSpacing),
              pdf.Table(children: [
                pdf.TableRow(decoration: pdf.BoxDecoration(color: PdfColor.fromHex("#4c597f")), children: [
                  pdf.Center(
                    child: pdf.Text("MEL ID", style: pdfTextDesignReturn()),
                  ),
                  pdf.Center(
                    child: pdf.Text("Aircraft", style: pdfTextDesignReturn()),
                  ),
                  pdf.Center(
                    child: pdf.Text("MEL Created At", style: pdfTextDesignReturn()),
                  ),
                  pdf.Center(
                    child: pdf.Text("Created By", style: pdfTextDesignReturn()),
                  ),
                  pdf.Center(
                    child: pdf.Text("Status", style: pdfTextDesignReturn()),
                  ),
                ]),
                for (int i = 0; i < melIndexData.length; i++)
                  pdf.TableRow(decoration: pdf.BoxDecoration(color: i % 2 == 0 ? PdfColors.grey300 : PdfColors.white), children: [
                    pdf.Center(
                      child: pdf.Text("${melIndexData[i]["stringMelId"]}"),
                    ),
                    pdf.Center(
                      child: pdf.Text("${melIndexData[i]["aircraft"]}"),
                    ),
                    pdf.Center(
                      child: pdf.Text("${melIndexData[i]["createdAt"]}"),
                    ),
                    pdf.Center(
                      child: pdf.Text("${melIndexData[i]["createdByName"]}"),
                    ),
                    pdf.Center(child: pdf.Text("${melStatusDataReturn(data: melIndexData[i])}")),
                  ]),
              ]),
            ];
          }),
    );
    return await doc.save();
  }

  pdfTextDesignReturn() {
    return pdf.TextStyle(color: PdfColors.white, fontWeight: pdf.FontWeight.bold, letterSpacing: 1.2);
  }

  //---------------------------MEL NEW ___DESIGN

  sortTableDataFunction({required String keyName, required int i}) {
    itemsNew.clear();

    if (keyName == 'createdAt') {
      if (itemsSort[i]) {
        melIndexData.sort((a, b) => (DateFormat('MM/dd/yyyy hh:mm:ss a').parse(a[keyName])).compareTo(DateFormat('MM/dd/yyyy hh:mm:ss a').parse(b[keyName])));
      } else {
        melIndexData.sort((a, b) => (DateFormat('MM/dd/yyyy hh:mm:ss a').parse(b[keyName])).compareTo(DateFormat('MM/dd/yyyy hh:mm:ss a').parse(a[keyName])));
      }
    } else {
      if (itemsSort[i]) {
        melIndexData.sort((a, b) {
          return (a[keyName]).compareTo(b[keyName]);
        });
      } else {
        melIndexData.sort((a, b) {
          return (b[keyName]).compareTo(a[keyName]);
        });
      }
    }

    itemsSort[i] = !itemsSort[i];

    for (int i = 0; i < melIndexData.length; i++) {
      itemsNew.add(melIndexData[i]);
    }

    update();
    EasyLoading.dismiss();
    return itemsNew;
  }

  newApiCallForMELIndexData() async {
    Response? data = await MelApiProvider().melIndexData();

    if (data?.statusCode == 200) {
      melIndexData.addAll(data?.data["data"]);

      for (Map element in melIndexData) {
        element.update(
            "statusMessage",
            (value) => (element["daysRemainingStatus"].toString().contains('Cleared') || element["daysRemainingStatus"].toString().contains('Expired'))
                ? "${element["daysRemainingStatus"]}. $value"
                : value);
      }

      itemsSort.clear();
      items.clear();
      itemsNew.clear();

      items.addAll(melIndexData);
      itemsNew.addAll(melIndexData);

      if (melIndexData.isNotEmpty) {
        for (int i = 0; i < melIndexData[0].keys.length; i++) {
          itemsSort.add(false);
        }
      } else {
        for (int i = 0; i < 20; i++) {
          itemsSort.add(false);
        }
      }

      if (melIndexData.isNotEmpty) {
        sortTableDataFunction(i: 0, keyName: 'stringMelId');
      }

      update();
    }
  }

  showingItemCountViewReturn({required int tableSize, required int totalNumber}) {
    return Text("Showing 1 to $tableSize of $tableSize entries ${filterSearchEnable.value == true ? "(filtered from $totalNumber total entries)" : ""}",
        textAlign: TextAlign.start, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 4, fontWeight: FontWeight.w800));
  }

  viewForPDFCSVEXCEL({void Function()? onTapMethodCopy, void Function()? onTapMethodPDF, void Function()? onTapMethodCSV, void Function()? onTapMethodEXCEL}) {
    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ButtonConstant.dialogButton(enableIcon: true, iconData: Icons.copy, title: "Copy", onTapMethod: onTapMethodCopy),
          const SizedBox(width: SizeConstants.contentSpacing),
          ButtonConstant.dialogButton(
            enableIcon: true,
            iconData: Icons.picture_as_pdf_rounded,
            title: "PDF",
            onTapMethod: onTapMethodPDF,
          ),
          const SizedBox(width: SizeConstants.contentSpacing),
          ButtonConstant.dialogButton(
            enableIcon: true, iconData: MaterialCommunityIcons.file_export, title: "CSV", onTapMethod: onTapMethodCSV,
            // onTapMethod: () async {
            //   // if (Platform.isIOS) {
            //   //   discrepancyIndexCSVView();
            //   // } else {
            //   //   if (await Permission.manageExternalStorage.isGranted) {
            //   //     discrepancyIndexCSVView();
            //   //   } else {
            //   //     permissionAccess();
            //   //   }
            //   // }
            // }
          ),
          const SizedBox(width: SizeConstants.contentSpacing),
          ButtonConstant.dialogButton(
            enableIcon: true, iconData: MaterialCommunityIcons.file_excel, title: "Excel", onTapMethod: onTapMethodEXCEL,
            // onTapMethod: () async {
            //   // if (Platform.isIOS) {
            //   //   discrepancyIndexEXCELView();
            //   // } else {
            //   //   if (await Permission.manageExternalStorage.isGranted) {
            //   //     discrepancyIndexEXCELView();
            //   //   } else {
            //   //     permissionAccess();
            //   //   }
            //   // }
            // }
          ),
        ],
      ),
    );
  }

  melIndexTableSearchView({void Function(String)? onChange}) {
    return FormBuilderField(
      name: "report_show_table_search",
      validator: null,
      builder: (FormFieldState<dynamic> field) {
        return TextFieldConstant.dynamicTextField(
          field: field,
          controller: melDataTableSearchController,
          hasIcon: true,
          setIcon: Icons.search_outlined,
          hintText: "Search data in table",
          onChange: onChange,
        );
      },
    );
  }

  pdfForMelIndexPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        Get.to(() => ViewPrintSavePdf(
            pdfFile: (pageFormat) => pdfViewForMelIndexView(pageFormat: pageFormat), fileName: "str_Accessory_Status_Report_pdf", initialPageFormat: PdfPageFormat.a4.landscape));
      } else {
        PermissionHelper.storagePermissionAccess();
      }
    } else {
      Get.to(() => ViewPrintSavePdf(
          pdfFile: (pageFormat) => pdfViewForMelIndexView(pageFormat: pageFormat), fileName: "str_Accessory_Status_Report_pdf", initialPageFormat: PdfPageFormat.a4.landscape));
    }
  }

  melIndexCSVPermission() async {
    if (Platform.isIOS) {
      melIndexCSVView();
    } else {
      if (await Permission.manageExternalStorage.isGranted) {
        melIndexCSVView();
      } else {
        PermissionHelper.storagePermissionAccess();
      }
    }
  }

  melIndexEXCELPermission() async {
    if (Platform.isIOS) {
      melIndexExcelViewNew();
    } else {
      if (await Permission.manageExternalStorage.isGranted) {
        melIndexExcelViewNew();
      } else {
        PermissionHelper.storagePermissionAccess();
      }
    }
  }

  melIndexSearchDataTableView({required String searchKey}) {
    if (searchKey == "") {
      filterSearchEnable.value = false;
      melIndexData.sort((a, b) => (a['stringMelId'].toString()).compareTo(b['stringMelId'].toString()));
      for (int i = 0; i < melIndexData.length; i++) {
        itemsNew.add(melIndexData[i]);
      }
    } else {
      for (Map element in melIndexData) {
        if (element["aircraft"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          itemsNew.add(element);
        } else if (element["createdAt"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          itemsNew.add(element);
        } else if (element["createdByName"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          itemsNew.add(element);
        } else if (element["statusMessage"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          itemsNew.add(element);
        }
      }
    }
    update();
  }

  tableHeaderTextStyleReturn() {
    return TextStyle(
        fontSize: DeviceType.isTablet ? Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 4 : Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5);
  }

  dynamicTableHeaderView() {
    return Row(
      children: [
        DataTable(
          border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
          headingRowHeight: 55.0,
          clipBehavior: Clip.antiAlias,
          columns: [
            DataColumn(
                label: SizedBox(
              width: DeviceType.isTablet ? 220.0 : 100.0,
              child: Center(
                child: TextButton.icon(
                  icon: RotatedBox(
                    quarterTurns: 0,
                    child: Icon(
                        itemsSort.isNotEmpty
                            ? itemsSort[0]
                                ? Icons.arrow_downward
                                : Icons.arrow_upward
                            : null,
                        size: SizeConstants.iconSize,
                        color: Colors.white),
                  ),
                  label: Text("MEL ID", style: tableHeaderTextStyleReturn()),
                  onPressed: () async {
                    await LoaderHelper.loaderWithGifAndText('Processing');
                    sortTableDataFunction(keyName: 'melId', i: 0);
                  },
                ),
              ),
            )),
          ],
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
              headingRowHeight: 55.0,
              columns: [
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 240.0 : 150.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(
                            itemsSort.isNotEmpty
                                ? itemsSort[1]
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward
                                : null,
                            size: SizeConstants.iconSize,
                            color: Colors.white),
                      ),
                      label: Text("Aircraft", style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'aircraft', i: 1);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 280.0 : 200.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(
                            itemsSort.isNotEmpty
                                ? itemsSort[2]
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward
                                : null,
                            size: SizeConstants.iconSize,
                            color: Colors.white),
                      ),
                      label: Text("MEL Created Date", style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'createdAt', i: 2);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 280.0 : 200.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(
                            itemsSort.isNotEmpty
                                ? itemsSort[3]
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward
                                : null,
                            size: SizeConstants.iconSize,
                            color: Colors.white),
                      ),
                      label: Text("Created By", style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'createdByName', i: 3);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 380.0 : 220.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(
                            itemsSort.isNotEmpty
                                ? itemsSort[4]
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward
                                : null,
                            size: SizeConstants.iconSize,
                            color: Colors.white),
                      ),
                      label: Text("Status", style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'statusMessage', i: 4);
                      },
                    ),
                  ),
                )),
              ],
              rows: const [],
              headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
            ),
          ),
        ),
      ],
    );
  }

  dynamicTableDataView() {
    return Obx(() {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              children: [
                DataTable(
                  border: TableBorder.all(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                  clipBehavior: Clip.antiAlias,
                  headingRowHeight: 55.0,
                  columns: [
                    DataColumn(
                        label: SizedBox(
                      width: DeviceType.isTablet ? 220.0 : 100.0,
                      child: Center(
                        child: TextButton.icon(
                          icon: RotatedBox(
                            quarterTurns: 0,
                            child: Icon(
                                itemsSort.isNotEmpty
                                    ? itemsSort[0]
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward
                                    : null,
                                size: SizeConstants.iconSize,
                                color: Colors.white),
                          ),
                          label: Text("MEL ID", style: tableHeaderTextStyleReturn()),
                          onPressed: () async {
                            await LoaderHelper.loaderWithGifAndText('Processing');
                            sortTableDataFunction(keyName: 'stringMelId', i: 0);
                          },
                        ),
                      ),
                    )),
                  ],
                  rows: List.generate(itemsNew.length, (abc) {
                    return DataRow(
                        color: abc % 2 == 0
                            ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                            : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                        cells: [
                          DataCell(onTap: () {
                            routesPageAction(itemData: itemsNew[abc]);
                          },
                              SizedBox(
                                  width: DeviceType.isTablet ? 220.0 : 100.0,
                                  child: Center(
                                      child:
                                          Text(itemsNew[abc]['stringMelId'].toString(), style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2)))))
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
                        headingRowHeight: 55.0,
                        columns: [
                          DataColumn(
                              label: SizedBox(
                            width: DeviceType.isTablet ? 240.0 : 150.0,
                            child: Center(
                              child: TextButton.icon(
                                icon: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(
                                      itemsSort.isNotEmpty
                                          ? itemsSort[1]
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward
                                          : null,
                                      size: SizeConstants.iconSize,
                                      color: Colors.white),
                                ),
                                label: Text("Aircraft", style: tableHeaderTextStyleReturn()),
                                onPressed: () async {
                                  await LoaderHelper.loaderWithGifAndText('Processing');
                                  sortTableDataFunction(keyName: 'aircraft', i: 1);
                                },
                              ),
                            ),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: DeviceType.isTablet ? 280.0 : 200.0,
                            child: Center(
                              child: TextButton.icon(
                                icon: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(
                                      itemsSort.isNotEmpty
                                          ? itemsSort[2]
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward
                                          : null,
                                      size: SizeConstants.iconSize,
                                      color: Colors.white),
                                ),
                                label: Text("MEL Created Date", style: tableHeaderTextStyleReturn()),
                                onPressed: () async {
                                  await LoaderHelper.loaderWithGifAndText('Processing');
                                  sortTableDataFunction(keyName: 'createdAt', i: 2);
                                },
                              ),
                            ),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: DeviceType.isTablet ? 280.0 : 200.0,
                            child: Center(
                              child: TextButton.icon(
                                icon: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(
                                      itemsSort.isNotEmpty
                                          ? itemsSort[3]
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward
                                          : null,
                                      size: SizeConstants.iconSize,
                                      color: Colors.white),
                                ),
                                label: Text("Created By", style: tableHeaderTextStyleReturn()),
                                onPressed: () async {
                                  await LoaderHelper.loaderWithGifAndText('Processing');
                                  sortTableDataFunction(keyName: 'createdByName', i: 3);
                                },
                              ),
                            ),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: DeviceType.isTablet ? 380.0 : 220.0,
                            child: Center(
                              child: TextButton.icon(
                                icon: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(
                                      itemsSort.isNotEmpty
                                          ? itemsSort[4]
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward
                                          : null,
                                      size: SizeConstants.iconSize,
                                      color: Colors.white),
                                ),
                                label: Text("Status", style: tableHeaderTextStyleReturn()),
                                onPressed: () async {
                                  await LoaderHelper.loaderWithGifAndText('Processing');
                                  sortTableDataFunction(keyName: 'statusMessage', i: 4);
                                },
                              ),
                            ),
                          )),
                        ],
                        rows: List.generate(itemsNew.length, (abc) {
                          return DataRow(
                              color: abc % 2 == 0
                                  ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                  : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                              cells: [
                                DataCell(onTap: () {
                                  routesPageAction(itemData: itemsNew[abc]);
                                },
                                    SizedBox(
                                        width: DeviceType.isTablet ? 240.0 : 150.0,
                                        child: Center(
                                            child: Text(itemsNew[abc]['aircraft'].toString(),
                                                style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                                DataCell(onTap: () {
                                  routesPageAction(itemData: itemsNew[abc]);
                                },
                                    SizedBox(
                                        width: DeviceType.isTablet ? 280.0 : 200.0,
                                        child: Center(
                                            child: Text(itemsNew[abc]['createdAt'].toString(),
                                                style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                                DataCell(onTap: () {
                                  routesPageAction(itemData: itemsNew[abc]);
                                },
                                    SizedBox(
                                        width: DeviceType.isTablet ? 280.0 : 200.0,
                                        child: Center(
                                            child: Text(itemsNew[abc]['createdByName'].toString(),
                                                style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                                DataCell(onTap: () {
                                  routesPageAction(itemData: itemsNew[abc]);
                                },
                                    SizedBox(
                                        width: DeviceType.isTablet ? 380.0 : 220.0,
                                        child: Center(
                                            child: Text(itemsNew[abc]['statusMessage'].toString(),
                                                style: TextStyle(
                                                    fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2,
                                                    color: statusDataTableColorReturn(colorCodeStatus: itemsNew[abc]['color'].toString())))))),
                              ]);
                        })),
                  ),
                ),
              ],
            ),
          ),
          dynamicTableHeaderView(),
        ],
      );
    });
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
              width: DeviceType.isTablet ? 220.0 : 100.0,
              child: Center(
                child: Text("Total: ${melIndexData.length}", style: tableHeaderTextStyleReturn()),
              ),
            )),
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
              columns: [
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 240.0 : 150.0,
                  child: Center(
                    child: Text("Aircraft", style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 280.0 : 200.0,
                  child: Center(
                    child: Text("MEL Created Date", style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 280.0 : 200.0,
                  child: Center(
                    child: Text("Created By", style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 380.0 : 220.0,
                  child: Center(
                    child: Text("Status", style: tableHeaderTextStyleReturn()),
                  ),
                )),
              ],
              rows: const [],
              headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
            ),
          ),
        ),
      ],
    );
  }

  melIndexShowButtonShowNew({
    required int tableLength,
    required int totalNumber,
    void Function()? onTapMethodCopy,
    void Function()? onTapMethodPDF,
    void Function(String)? onChange,
    void Function()? onTapMethodCSV,
    void Function()? onTapMethodEXCEL,
  }) {
    return SizedBox(
        width: Get.width,
        child: Material(
          color: ColorConstants.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DeviceType.isTablet || (DeviceType.isMobile && orientation.DeviceOrientation.isLandscape)
                ? Row(
                    spacing: 10.0,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(child: showingItemCountViewReturn(tableSize: tableLength, totalNumber: totalNumber)),
                      Flexible(child: melIndexTableSearchView(onChange: onChange)),
                      Flexible(
                        child: viewForPDFCSVEXCEL(
                            onTapMethodCopy: onTapMethodCopy, onTapMethodPDF: onTapMethodPDF, onTapMethodCSV: onTapMethodCSV, onTapMethodEXCEL: onTapMethodEXCEL),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: viewForPDFCSVEXCEL(
                            onTapMethodCopy: onTapMethodCopy, onTapMethodPDF: onTapMethodPDF, onTapMethodCSV: onTapMethodCSV, onTapMethodEXCEL: onTapMethodEXCEL),
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing),
                      showingItemCountViewReturn(tableSize: tableLength, totalNumber: totalNumber),
                      const SizedBox(height: SizeConstants.contentSpacing),
                      melIndexTableSearchView(onChange: onChange)
                    ],
                  ),
          ),
        ));
  }

  returnMelIndexView() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0, top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SizeConstants.contentSpacing),
          melFilterAndManageAircraftViewReturn(),
          const SizedBox(height: SizeConstants.contentSpacing),
          melIndexShowButtonShowNew(
              tableLength: itemsNew.length,
              totalNumber: melIndexData.length,
              onTapMethodCopy: () {
                melIndexCopyView();
              },
              onTapMethodPDF: () {
                pdfForMelIndexPermission();
              },
              onTapMethodCSV: () {
                melIndexCSVPermission();
              },
              onTapMethodEXCEL: () {
                melIndexEXCELPermission();
              },
              onChange: (value) {
                itemsNew.clear();
                filterSearchEnable.value = true;
                melIndexSearchDataTableView(searchKey: value);
              }),
          const SizedBox(height: SizeConstants.contentSpacing),
          Material(
            color: ColorConstants.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
              children: [
                melIndexData.isNotEmpty
                    ? SizedBox(height: itemsNew.length > 9 ? Get.height - 200.0 : ((itemsNew.length - ((itemsNew.length - 1) / 2)) * 100.0), child: dynamicTableDataView())
                    : dynamicTableHeaderView(),
                if (itemsNew.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        filterSearchEnable.value ? "No matching records found" : "No Data Available",
                        style: TextStyle(color: ColorConstants.red, fontSize: Theme.of(Get.context!).textTheme.bodyLarge!.fontSize! + 6),
                      ),
                    ),
                  ),
                dataTableBottomHeaderView(),
              ],
            ),
          ),
          const SizedBox(height: SizeConstants.contentSpacing - 5),
        ],
      ),
    );
  }
}
