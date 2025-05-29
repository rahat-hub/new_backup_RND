import 'dart:io';
import 'dart:ui';

import 'package:aviation_rnd/helper/dialog_helper.dart';
import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/pdf_helper.dart';
import 'package:aviation_rnd/helper/permission_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/discrepancy_api_provider.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/services/device_orientation.dart' as orientation;
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:aviation_rnd/widgets/text_fields.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart' hide TextSpan;
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

import '../../../helper/date_time_helper.dart';

class DiscrepancyIndexLogic extends GetxController {
  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? tableHeaderScrollController;
  ScrollController? tableDataScrollController;
  ScrollController? tableBottomHeaderScrollController;

  int maxCharacters = 1;

  RxBool isLoading = false.obs;

  RxBool isIndexDataLoading = false.obs;

  RxList filterDiscrepancyTypeDropDropdownData = [].obs;
  RxMap selectedFilterDiscrepancyTypeDropdown = {}.obs;

  RxList filterAircraftListDropdownData = [].obs;
  RxMap selectedFilterAircraftListDropdown = {}.obs;

  RxList filterScheduledMaintenanceDropdownData = [].obs;
  RxMap selectedFilterScheduledMaintenanceDropdown = {}.obs;

  RxList filterStatusDropdownData = [].obs;
  RxMap selectedFilterStatusDropdown = {}.obs;

  RxList filterDateRangeDropdownData = [].obs;
  RxMap selectedFilterDateRangeDropdown = {}.obs;

  RxList filterAdditionalInspectionDropdownData = [].obs;
  RxMap selectedFilterAdditionalInspectionDropdown = {}.obs;

  RxList discrepancyIndexData = [].obs;

  List<Map<String, dynamic>> items = <Map<String, dynamic>>[];

  RxMap<String, bool> isDescending = <String, bool>{}.obs;

  RxList<bool> ataFieldExpand = <bool>[].obs;

  Map ataCodeData = {}.obs;

  bool createNewDiscrepancy = false; //strAddNew/addNew

  Map<String, TextEditingController> discrepancyIndexTextController = <String, TextEditingController>{};

  Map<String, String> indexFilterApiCallData = {
    "systemId": UserSessionInfo.systemId.toString(),
    "userId": UserSessionInfo.userId.toString(),
    "discrepancyType": "-1",
    "discrepancyStatus": "",
    "aircraftId": "0",
    "accessoryId": "0",
    "airSelector": "0",
    "ataCode": "",
    "scheduleMtnc": "-1",
    "DateRangeType": "30",
    "vendorAccess": "false",
    "startDate": "",
    "endDate": ""
  };

  RxInt start = 0.obs;
  RxInt end = 100.obs;

  RxBool disableKeyboard = true.obs;

  RxBool filterSearchEnable = false.obs;

  RxList<bool> itemsSort = <bool>[].obs;

  @override
  void onInit() async {
    super.onInit();

    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    tableHeaderScrollController = controllerGroup.addAndGet();
    tableDataScrollController = controllerGroup.addAndGet();
    tableBottomHeaderScrollController = controllerGroup.addAndGet();

    if (UserPermission.pilot.value ||
        UserPermission.pilotAdmin.value ||
        UserPermission.mechanic.value ||
        UserPermission.mechanicAdmin.value ||
        UserPermission.discrepanciesWo.value) {
      createNewDiscrepancy = true;
    }

    for (int i = 0; i < 12; i++) {
      itemsSort.add(false);
    }

    await filterDataViewApiCall();

    await ataDataViewAPICall();

    await indexPageDataViewApiCall();

    isLoading.value = false;

    await EasyLoading.dismiss();
  }

  filterDataViewApiCall() async {
    filterDiscrepancyTypeDropDropdownData.clear();
    selectedFilterDiscrepancyTypeDropdown.clear();

    filterScheduledMaintenanceDropdownData.clear();
    selectedFilterScheduledMaintenanceDropdown.clear();

    filterAircraftListDropdownData.clear();
    selectedFilterAircraftListDropdown.clear();

    filterAdditionalInspectionDropdownData.clear();
    selectedFilterAdditionalInspectionDropdown.clear();

    filterDateRangeDropdownData.clear();
    selectedFilterDateRangeDropdown.clear();

    filterStatusDropdownData.clear();
    selectedFilterStatusDropdown.clear();

    Response? filterData = await DiscrepancyNewApiProvider().discrepancyIndexFilterData();
    if (filterData?.statusCode == 200) {
      filterDiscrepancyTypeDropDropdownData.addAll(filterData?.data["data"]["discrepanciesFilterData"]["filterType"]);
      filterDiscrepancyTypeDropDropdownData.replaceRange(0, 1, [
        {"id": "-1", "name": "All", "selected": true}
      ]);
      selectedFilterDiscrepancyTypeDropdown.value = filterDiscrepancyTypeDropDropdownData.firstWhere((element) => element["selected"]);

      filterScheduledMaintenanceDropdownData.addAll(filterData?.data["data"]["discrepanciesFilterData"]["scheduledMaintenance"]);
      selectedFilterScheduledMaintenanceDropdown.value = filterScheduledMaintenanceDropdownData.firstWhere((element) => element["selected"]);

      filterStatusDropdownData.addAll(filterData?.data["data"]["discrepanciesFilterData"]["filterStatus"]);
      selectedFilterStatusDropdown.value = filterStatusDropdownData.firstWhere((element) => element["selected"]);

      filterDateRangeDropdownData.addAll(filterData?.data["data"]["discrepanciesFilterData"]["dateRange"]);
      selectedFilterDateRangeDropdown.value = filterDateRangeDropdownData.firstWhere((element) => element["id"].toString() == "30");
      discrepancyIndexTextController.putIfAbsent(
          "discrepancy_filter_start_date", () => TextEditingController(text: DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now.subtract(const Duration(days: 30)))));
      discrepancyIndexTextController.putIfAbsent("discrepancy_filter_end_date", () => TextEditingController(text: DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now)));

      filterAdditionalInspectionDropdownData.addAll(filterData?.data["data"]["discrepanciesFilterData"]["additionalInspection"]);
      selectedFilterAdditionalInspectionDropdown.value = filterAdditionalInspectionDropdownData.firstWhere((element) => element["selected"]);

      filterAircraftListDropdownData.add({"id": "0", "name": "All", "selected": true});
      filterAircraftListDropdownData.addAll(filterData?.data["data"]["discrepanciesFilterData"]["aircraftList"]);
      selectedFilterAircraftListDropdown.value = filterAircraftListDropdownData.firstWhere((element) => element["selected"]);
    }
  }

  ataDataViewAPICall() async {
    Response? ataCode = await DiscrepancyNewApiProvider().ataCodeData();
    if (ataCode?.statusCode == 200) {
      ataCodeData.addAll(ataCode?.data["data"]);
      for (int i = 0; i < ataCodeData["ataChapterData"].length; i++) {
        ataFieldExpand.add(false);
      }
    }
  }

  indexPageDataViewApiCall({String? callFrom}) async {
    discrepancyIndexData.clear();

    Response? data = await DiscrepancyNewApiProvider().discrepancyIndexPageViewData(discrepancyFilterApiData: indexFilterApiCallData);
    if (data?.statusCode == 200) {
      discrepancyIndexData.addAll(data?.data["data"]["discrepanciesViewData"]);
    }

    items.clear();
    discrepancyIndexData.sort((a, b) => (b['discrepancyId']).compareTo(a['discrepancyId']));
    isDescending.update("discrepancyId", (value) => true, ifAbsent: () => true);
    for (Map<String, dynamic> element in discrepancyIndexData) {
      items.add(element);
    }
  }

  ataCodeDialogView() {
    return showDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Dialog(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                side: const BorderSide(color: ColorConstants.primary, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text("ATA Code", textAlign: TextAlign.center, style: TextStyle(fontSize: 40))),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: ataCodeData["ataChapterData"].length,
                        shrinkWrap: true,
                        itemBuilder: (context, chapterItem) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  ataFieldExpand[chapterItem] = !ataFieldExpand[chapterItem];
                                },
                                child: Column(
                                  children: [
                                    Text(ataCodeData["ataChapterData"][chapterItem]["chapterTitle"],
                                        textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                                    Text(ataCodeData["ataChapterData"][chapterItem]["chapterDescription"],
                                        textAlign: TextAlign.justify, style: const TextStyle(fontSize: 14, letterSpacing: 0.8, fontWeight: FontWeight.w200))
                                  ],
                                ),
                              ),
                              Obx(() {
                                return ataFieldExpand[chapterItem] != false
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: ataCodeData["ataChapterData"][chapterItem]["ataSectionData"].length,
                                        itemBuilder: (context, sectionItem) {
                                          return InkWell(
                                            onTap: () {
                                              discrepancyIndexTextController["discrepancy_filter_ata_code"]!.text =
                                                  ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                              indexFilterApiCallData["ataCode"] = ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["ataCode"].toString();
                                              Get.back();
                                            },
                                            child: Column(
                                              children: [
                                                Text(ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["sectionTitle"].toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(fontSize: 16, color: Colors.blue, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                                                Text(ataCodeData["ataChapterData"][chapterItem]["ataSectionData"][sectionItem]["sectionDescription"].toString(),
                                                    textAlign: TextAlign.justify, style: const TextStyle(fontSize: 12, letterSpacing: 0.8, fontWeight: FontWeight.w200))
                                              ],
                                            ),
                                          );
                                        })
                                    : const SizedBox();
                              })
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ButtonConstant.dialogButton(
                        title: "Cancel",
                        borderColor: ColorConstants.grey,
                        onTapMethod: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        width: SizeConstants.contentSpacing + 10,
                      ),
                    ])
                  ],
                ),
              ),
            ),
          );
        });
  }

  discrepancyIndexCopyView() {
    String data = "";
    data += "Digital AirWare © 2024\t\n\n";
    data += "ID\tDate\tDiscrepancy Type\tEquipment\tDescription\tStatus\tAir Status\tDiscrepancy\tWork Order\n";
    for (int index = 0; index < discrepancyIndexData.length; index++) {
      data +=
          "${discrepancyIndexData[index]["discrepancyId"].toString()}\t${discrepancyIndexData[index]["date"]}\t${discrepancyIndexData[index]["discrepancyType"]}\t${discrepancyIndexData[index]["equipment"]}\t${discrepancyIndexData[index]["description"]}\t${discrepancyIndexData[index]["status"]}\t${discrepancyIndexData[index]["airStatus"]}\t${discrepancyIndexData[index]["isDiscrepancy"].toString()}\t${discrepancyIndexData[index]["workOrderNumber"].toString()}\t\n";
    }
    CopyIntoClipboard.copyText(text: data, message: "${discrepancyIndexData.length} rows");
  }

  discrepancyIndexCSVView() async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("ID");
    row.add("Date");
    row.add("Discrepancy Type");
    row.add("Equipment");
    row.add("Description");
    row.add("Status");
    row.add("Air Status");
    row.add("Discrepancy");
    row.add("Work Order");
    rows.add(row);
    for (int i = 0; i < discrepancyIndexData.length; i++) {
      List<dynamic> row = [];
      row.add(discrepancyIndexData[i]["discrepancyId"]);
      row.add(discrepancyIndexData[i]["date"]);
      row.add(discrepancyIndexData[i]["discrepancyType"]);
      row.add(discrepancyIndexData[i]["equipment"]);
      row.add(discrepancyIndexData[i]["description"]);
      row.add(discrepancyIndexData[i]["status"]);
      row.add(discrepancyIndexData[i]["airStatus"]);
      row.add("View Discrepancy");
      row.add(discrepancyIndexData[i]["workOrder"] == "True" ? "View W/O ${discrepancyIndexData[i]["workOrderNumber"]}" : "");
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

  discrepancyIndexEXCELView() async {
    final Excel workbook = Excel.createExcel();
    final Sheet sheet = workbook['Sheet1'];

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0))
      ..value = TextCellValue("Discrepancy Index Search")
      ..cellStyle = CellStyle(fontSize: 18, bold: true);

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 0))
      ..value = TextCellValue("ID")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 1))
      ..value = TextCellValue("Date")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 2))
      ..value = TextCellValue("Discrepancy Type")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 3))
      ..value = TextCellValue("Equipment")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 4))
      ..value = TextCellValue("Description")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 5))
      ..value = TextCellValue("Status")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 6))
      ..value = TextCellValue("Air Status")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 7))
      ..value = TextCellValue("Discrepancy")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 8))
      ..value = TextCellValue("Work Order")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);

    for (int i = 0; i < discrepancyIndexData.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 0)).value = TextCellValue(discrepancyIndexData[i]["discrepancyId"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 1)).value = TextCellValue(discrepancyIndexData[i]["date"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 2)).value = TextCellValue(discrepancyIndexData[i]["discrepancyType"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 3)).value = TextCellValue(discrepancyIndexData[i]["equipment"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 4)).value = TextCellValue(discrepancyIndexData[i]["description"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 5)).value = TextCellValue(discrepancyIndexData[i]["status"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 6)).value = TextCellValue(discrepancyIndexData[i]["airStatus"].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 7)).value = TextCellValue("View Discrepancy");
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 3 + i, columnIndex: 8)).value =
          TextCellValue(discrepancyIndexData[i]["workOrder"] == "True" ? "View W/O ${discrepancyIndexData[i]["workOrderNumber"]}" : "");
    }

    int l = discrepancyIndexData.length + 4;

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 0))
      ..value = TextCellValue("ID")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 1))
      ..value = TextCellValue("Date")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 2))
      ..value = TextCellValue("Discrepancy Type")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 3))
      ..value = TextCellValue("Equipment")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 4))
      ..value = TextCellValue("Description")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 5))
      ..value = TextCellValue("Status")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 6))
      ..value = TextCellValue("Air Status")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 7))
      ..value = TextCellValue("Discrepancy")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: l, columnIndex: 8))
      ..value = TextCellValue("Work Order")
      ..cellStyle = CellStyle(fontSize: 14, bold: true);

    final List<int>? bytes = workbook.save(fileName: "DAW_Discrepancy_Index_Table_Data.xlsx");
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
    File f = File("$file/DAW_Discrepancy.xlsx");
    f.writeAsBytes(bytes!, flush: true);
    OpenFile.open(f.path, isIOSAppOpen: Platform.isIOS).then((value) {
      if (value.type.name == "noAppToOpen") {
        SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
      }
    });
  }

  discrepancyIndexDataTableView({required String searchKey}) {
    if (searchKey == "") {
      filterSearchEnable.value = false;
      discrepancyIndexData.sort((a, b) => (a['discrepancyId'].toString()).compareTo(b['discrepancyId'].toString()));
      for (int i = 0; i < discrepancyIndexData.length; i++) {
        items.add(discrepancyIndexData[i]);
      }
    } else {
      for (Map<String, dynamic> element in discrepancyIndexData) {
        if (element["discrepancyId"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          items.add(element);
        } else if (element["date"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          items.add(element);
        } else if (element["discrepancyType"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          items.add(element);
        } else if (element["equipment"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          items.add(element);
        } else if (element["description"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          items.add(element);
        } else if (element["airStatus"].toString().toLowerCase().isCaseInsensitiveContains(searchKey.toLowerCase())) {
          items.add(element);
        }
      }
    }
    update();
  }

  indexDataViewReturn() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: SizeConstants.contentSpacing - 5, children: [
      discrepancyShowAndChildButtonShowNew(
          tableLength: items.length,
          totalNumber: discrepancyIndexData.length,
          onTapMethodCopy: () => discrepancyIndexCopyView(),
          onTapMethodCSV: () async {
            if (Platform.isIOS) {
              discrepancyIndexCSVView();
            } else {
              if (await Permission.manageExternalStorage.isGranted) {
                discrepancyIndexCSVView();
              } else {
                PermissionHelper.storagePermissionAccess();
              }
            }
          },
          onTapMethodPDF: () async {
            Get.to(() =>
                ViewPrintSavePdf(pdfFile: (pageFormat) => discrepancyIndexPDFView(pageFormat: pageFormat), fileName: "strFileName", initialPageFormat: PdfPageFormat.a4.landscape));
          },
          onTapMethodEXCEL: () async {
            if (Platform.isIOS) {
              discrepancyIndexEXCELView();
            } else {
              if (await Permission.manageExternalStorage.isGranted) {
                discrepancyIndexEXCELView();
              } else {
                PermissionHelper.storagePermissionAccess();
              }
            }
          },
          onChange: (value) {
            items.clear();
            filterSearchEnable.value = true;
            discrepancyIndexDataTableView(searchKey: value);
          }),
      Wrap(
        alignment: items.length == 1000 ? WrapAlignment.spaceBetween : WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (items.length == 1000)
            const Text("NOTE: The Maximum Result Set of 1000 Records Show. Narrow Your Search To See Additional Records If Needed.",
                textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
          if (items.length > 100)
            Row(mainAxisSize: Get.width > 540 ? MainAxisSize.min : MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end, children: [
              if (start.value > 0)
                IconButton(
                    splashRadius: 20.0,
                    icon: const Icon(Icons.keyboard_arrow_left, color: Colors.blue, size: 22.0),
                    onPressed: () {
                      if (end.value - start.value == 100) {
                        start.value = start.value - 100;
                        end.value = end.value - 100;
                      } else {
                        start.value = start.value - 100;
                        end.value = start.value + 100;
                      }
                    }),
              Text("Showing ${start.value + 1} - ${end.value}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
              end.value < items.length
                  ? IconButton(
                      splashRadius: 20.0,
                      icon: const Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 22.0),
                      onPressed: () {
                        if (end.value + 100 < items.length) {
                          start.value = start.value + 100;
                          end.value = end.value + 100;
                        } else {
                          start.value = start.value + 100;
                          end.value = items.length;
                        }
                      })
                  : const SizedBox(width: 45.0),
            ])
        ],
      ),
      Obx(() {
        return isIndexDataLoading.isTrue
            ? const SizedBox()
            : SizedBox(
                height: items.length > 8
                    ? (Get.height / 1.5)
                    : maxCharacters > 300
                        ? 110.0 * (items.length + 0.5)
                        : (65.0 * (items.length + 1)),
                child: discrepancyIndexTableDataViewNew());
      }),
      if (discrepancyIndexData.isEmpty)
        const SizedBox(
            height: 100.0,
            child:
                Center(child: Text("No Data Available in Table", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18.0)))),
      //indexPageTableBottomHeaderView(),
      discrepancyIndexDataTableBottomHeaderViewReturn(),

      if (items.length == 1000) const Center(child: Text("The Maximum Of 1,000 Records Has Been Shown", style: TextStyle(color: Colors.red))),
    ]);
  }

  colorReturn({required String statusColor}) {
    switch (statusColor) {
      case "buttonRed":
        return ColorConstants.red;
      case "buttonGreen":
        return ColorConstants.button;
      case "buttonYellow":
        return Colors.yellow.shade900;
      case "buttonBlue":
        return ColorConstants.primary;
    }
  }

  statusButtonReturn({required Map<String, dynamic> items}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DiscrepancyAndWorkOrdersMaterialButton(
        onPressed: null,
        buttonText: items["status"].toString(),
        borderColor: Colors.black.withValues(alpha: 0.4),
        buttonColor: ColorConstants.background.withValues(alpha: 0.6),
        buttonTextColor: colorReturn(statusColor: items["statusColor"]),
        fixedButtonSizeEnable: true,
        fixedButtonSize: 220.0,
      ),
    );
  }

  discrepancyButtonReturn({required Map<String, dynamic> items}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DiscrepancyAndWorkOrdersMaterialButton(
        onPressed: () {
          Get.toNamed(Routes.discrepancyDetailsNew,
              arguments: items["discrepancyId"].toString(), parameters: {"discrepancyId": items["discrepancyId"].toString(), "routeForm": "discrepancyIndex"});
        },
        icon: Icons.search_sharp,
        iconColor: ColorConstants.primary,
        buttonText: 'View Discrepancy',
        borderColor: Colors.black.withValues(alpha: 0.4),
        buttonColor: ColorConstants.background.withValues(alpha: 0.6),
        buttonTextColor: ColorConstants.primary,
        fixedButtonSizeEnable: true,
        fixedButtonSize: 220.0,
      ),
    );
  }

  workOrderButtonReturn({required Map<String, dynamic> items}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DiscrepancyAndWorkOrdersMaterialButton(
        onPressed: () {
          DialogHelper.openCommonDialogBox(message: "Coming Soon....");
        },
        icon: Icons.search_sharp,
        iconColor: ColorConstants.primary,
        buttonText: 'View W/O : ${items["workOrderNumber"]}',
        borderColor: Colors.black.withValues(alpha: 0.4),
        buttonColor: ColorConstants.background.withValues(alpha: 0.6),
        buttonTextColor: ColorConstants.primary,
        fixedButtonSizeEnable: true,
        fixedButtonSize: 220.0,
      ),
    );
  }

  ///-------------DiscrepancyIndexFilterFieldView---------------\\\\

  discrepancyTypeDropdownFieldView() {
    // return WidgetConstant.customDropDownWidgetNew(
    //     context: Get.context!,
    //     contentPaddingEnable: true,
    //     topPadding: 4.0,
    //     bottomPadding: 4.0,
    //     dropDownData: filterDiscrepancyTypeDropDropdownData,
    //     dropDownKey: "name",
    //     title: "Type",
    //     hintText: selectedFilterDiscrepancyTypeDropdown.isNotEmpty ? selectedFilterDiscrepancyTypeDropdown["name"] : filterDiscrepancyTypeDropDropdownData[0]["name"],
    //     onChanged: (value) {
    //       selectedFilterDiscrepancyTypeDropdown.value = value;
    //       indexFilterApiCallData["discrepancyType"] = selectedFilterDiscrepancyTypeDropdown["id"];
    //     });
    return DiscrepancyAndWorkOrdersDropDown(
      expands: true,
      textFieldWidth: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      dropDownController: discrepancyIndexTextController.putIfAbsent('discrepancyType', () => TextEditingController()),
      dropDownKey: 'name',
      dropDownData: filterDiscrepancyTypeDropDropdownData,
      hintText: selectedFilterDiscrepancyTypeDropdown.isNotEmpty
          ? selectedFilterDiscrepancyTypeDropdown['name']
          : filterDiscrepancyTypeDropDropdownData.isNotEmpty
              ? filterDiscrepancyTypeDropDropdownData[0]['name']
              : "-- Not Assigned --",
      fieldName: "Discrepancy Type",
      onChanged: (value) async {
        selectedFilterDiscrepancyTypeDropdown.value = value;
        indexFilterApiCallData["discrepancyType"] = selectedFilterDiscrepancyTypeDropdown["id"];
      },
    );
  }

  scheduledMaintenanceDropdownFieldView() {
    // return WidgetConstant.customDropDownWidgetNew(
    //     context: Get.context!,
    //     contentPaddingEnable: true,
    //     topPadding: 4.0,
    //     bottomPadding: 4.0,
    //     dropDownData: filterScheduledMaintenanceDropdownData,
    //     dropDownKey: "name",
    //     title: "Scheduled Maintenance",
    //     hintText: selectedFilterScheduledMaintenanceDropdown.isNotEmpty ? selectedFilterScheduledMaintenanceDropdown["name"] : filterScheduledMaintenanceDropdownData[0]["name"],
    //     onChanged: (value) {
    //       selectedFilterScheduledMaintenanceDropdown.value = value;
    //       indexFilterApiCallData["scheduleMtnc"] = selectedFilterScheduledMaintenanceDropdown["id"];
    //     });
    return DiscrepancyAndWorkOrdersDropDown(
      expands: true,
      textFieldWidth: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      dropDownController: discrepancyIndexTextController.putIfAbsent('scheduleMtnc', () => TextEditingController()),
      dropDownKey: 'name',
      dropDownData: filterScheduledMaintenanceDropdownData,
      hintText: selectedFilterScheduledMaintenanceDropdown.isNotEmpty
          ? selectedFilterScheduledMaintenanceDropdown['name']
          : filterScheduledMaintenanceDropdownData.isNotEmpty
              ? filterScheduledMaintenanceDropdownData[0]['name']
              : "-- Not Assigned --",
      fieldName: "Scheduled Maintenance",
      onChanged: (value) async {
        selectedFilterScheduledMaintenanceDropdown.value = value;
        indexFilterApiCallData["scheduleMtnc"] = selectedFilterScheduledMaintenanceDropdown["id"];
      },
    );
  }

  statusDropdownFieldView() {
    return DiscrepancyAndWorkOrdersDropDown(
      expands: true,
      textFieldWidth: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      dropDownController: discrepancyIndexTextController.putIfAbsent('discrepancyStatus', () => TextEditingController()),
      dropDownKey: 'name',
      dropDownData: filterStatusDropdownData,
      hintText: selectedFilterStatusDropdown.isNotEmpty
          ? selectedFilterStatusDropdown['name']
          : filterStatusDropdownData.isNotEmpty
              ? filterStatusDropdownData[0]['name']
              : "-- Not Assigned --",
      fieldName: "Status",
      onChanged: (value) async {
        selectedFilterStatusDropdown.value = value;
        indexFilterApiCallData["discrepancyStatus"] = selectedFilterStatusDropdown["id"];
      },
    );
  }

  dateRangeDropdownFiledView() {
    // return WidgetConstant.customDropDownWidgetNew(
    //     context: Get.context!,
    //     contentPaddingEnable: true,
    //     topPadding: 4.0,
    //     bottomPadding: 4.0,
    //     dropDownData: filterDateRangeDropdownData,
    //     dropDownKey: "name",
    //     title: "Date Range",
    //     hintText: selectedFilterDateRangeDropdown.isNotEmpty ? selectedFilterDateRangeDropdown["name"] : "30 Days",
    //     onChanged: (value) {
    //       selectedFilterDateRangeDropdown.value = value;
    //       if (selectedFilterDateRangeDropdown["id"] != "0") {
    //         discrepancyIndexTextController["discrepancy_filter_start_date"]!.text = DateTimeHelper.dateFormatDefault
    //             .format(DateTimeHelper.now.subtract(Duration(days: selectedFilterDateRangeDropdown["id"] == "-1" ? 30 : int.parse(selectedFilterDateRangeDropdown["id"]))));
    //         discrepancyIndexTextController["discrepancy_filter_end_date"]!.text = DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now);
    //       } else {
    //         discrepancyIndexTextController["discrepancy_filter_start_date"]!.clear();
    //         discrepancyIndexTextController["discrepancy_filter_end_date"]!.clear();
    //       }
    //       indexFilterApiCallData["DateRangeType"] = selectedFilterDateRangeDropdown["id"];
    //       disableKeyboard.value = true;
    //     });

    return DiscrepancyAndWorkOrdersDropDown(
      expands: true,
      textFieldWidth: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      dropDownController: discrepancyIndexTextController.putIfAbsent('discrepancyDateRange', () => TextEditingController()),
      dropDownKey: 'name',
      dropDownData: filterDateRangeDropdownData,
      hintText: selectedFilterDateRangeDropdown.isNotEmpty
          ? selectedFilterDateRangeDropdown['name']
          : filterDateRangeDropdownData.isNotEmpty
              ? filterDateRangeDropdownData[0]['name']
              : "30 Days",
      fieldName: "Date Range",
      onChanged: (value) async {
        selectedFilterDateRangeDropdown.value = value;
        if (selectedFilterDateRangeDropdown["id"] != "0") {
          discrepancyIndexTextController["discrepancy_filter_start_date"]!.text = DateTimeHelper.dateFormatDefault
              .format(DateTimeHelper.now.subtract(Duration(days: selectedFilterDateRangeDropdown["id"] == "-1" ? 30 : int.parse(selectedFilterDateRangeDropdown["id"]))));
          discrepancyIndexTextController["discrepancy_filter_end_date"]!.text = DateTimeHelper.dateFormatDefault.format(DateTimeHelper.now);
        } else {
          discrepancyIndexTextController["discrepancy_filter_start_date"]!.clear();
          discrepancyIndexTextController["discrepancy_filter_end_date"]!.clear();
        }
        indexFilterApiCallData["DateRangeType"] = selectedFilterDateRangeDropdown["id"];
        disableKeyboard.value = true;
      },
    );
  }

  aircraftDropdownFiledView() {
    // return WidgetConstant.customDropDownWidgetNew(
    //     context: Get.context!,
    //     contentPaddingEnable: true,
    //     topPadding: 4.0,
    //     bottomPadding: 4.0,
    //     dropDownData: filterAircraftListDropdownData,
    //     dropDownKey: "name",
    //     title: "Aircraft",
    //     disableEditing: selectedFilterDiscrepancyTypeDropdown["id"] == "0" ? false : true,
    //     hintText: selectedFilterAircraftListDropdown.isNotEmpty ? selectedFilterAircraftListDropdown["name"] : filterAircraftListDropdownData[0]["name"],
    //     onChanged: (value) {
    //       selectedFilterAircraftListDropdown.value = value;
    //       indexFilterApiCallData["aircraftId"] = selectedFilterAircraftListDropdown["id"];
    //     });

    return DiscrepancyAndWorkOrdersDropDown(
      expands: true,
      textFieldWidth: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      dropDownController: discrepancyIndexTextController.putIfAbsent('discrepancyAircraft', () => TextEditingController()),
      dropDownKey: 'name',
      readOnly: selectedFilterDiscrepancyTypeDropdown["id"] == "0" ? false : true,
      dropDownData: filterAircraftListDropdownData,
      hintText: selectedFilterAircraftListDropdown.isNotEmpty
          ? selectedFilterAircraftListDropdown['name']
          : filterAircraftListDropdownData.isNotEmpty
              ? filterAircraftListDropdownData[0]['name']
              : "-- Not Assigned --",
      fieldName: "Aircraft",
      onChanged: (value) async {
        selectedFilterAircraftListDropdown.value = value;
        indexFilterApiCallData["aircraftId"] = selectedFilterAircraftListDropdown["id"];
      },
    );
  }

  additionalInspectionRequiredDropdownFiledView() {
    // return WidgetConstant.customDropDownWidgetNew(
    //     context: Get.context!,
    //     contentPaddingEnable: true,
    //     topPadding: 4.0,
    //     bottomPadding: 4.0,
    //     dropDownData: filterAdditionalInspectionDropdownData,
    //     dropDownKey: "name",
    //     title: "Additional Inspection Required",
    //     disableEditing: selectedFilterDiscrepancyTypeDropdown["id"] == "0" || selectedFilterDiscrepancyTypeDropdown["id"] == "-1" ? false : true,
    //     hintText: selectedFilterAdditionalInspectionDropdown.isNotEmpty ? selectedFilterAdditionalInspectionDropdown["name"] : filterAdditionalInspectionDropdownData[0]["name"],
    //     onChanged: (value) {
    //       selectedFilterAdditionalInspectionDropdown.value = value;
    //       indexFilterApiCallData["airSelector"] = selectedFilterAdditionalInspectionDropdown["id"];
    //     });

    return DiscrepancyAndWorkOrdersDropDown(
      expands: true,
      textFieldWidth: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      dropDownController: discrepancyIndexTextController.putIfAbsent('discrepancyAirSelector', () => TextEditingController()),
      dropDownKey: 'name',
      readOnly: selectedFilterDiscrepancyTypeDropdown["id"] == "0" || selectedFilterDiscrepancyTypeDropdown["id"] == "-1" ? false : true,
      dropDownData: filterAdditionalInspectionDropdownData,
      hintText: selectedFilterAdditionalInspectionDropdown.isNotEmpty
          ? selectedFilterAdditionalInspectionDropdown['name']
          : filterAdditionalInspectionDropdownData.isNotEmpty
              ? filterAdditionalInspectionDropdownData[0]['name']
              : "-- Not Assigned --",
      fieldName: "Additional Inspection Required",
      onChanged: (value) async {
        selectedFilterAdditionalInspectionDropdown.value = value;
        indexFilterApiCallData["airSelector"] = selectedFilterAdditionalInspectionDropdown["id"];
      },
    );
  }

  startDateTextFieldView() {
    return SizedBox(
      width: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      child: DiscrepancyAndWorkOrdersDateTime(
        fieldName: "Start Date",
        isDense: true,
        disableKeyboard: disableKeyboard,
        showField: true,
        readOnly: selectedFilterDateRangeDropdown["id"] == "-1" ? false : true,
        dateTimeController: discrepancyIndexTextController.putIfAbsent("discrepancy_filter_start_date", () => TextEditingController()),
        dateType: "date",
        onConfirm: (dateTime) {
          discrepancyIndexTextController["discrepancy_filter_start_date"]!.text = DateTimeHelper.dateFormatDefault.format(dateTime).toString();
          indexFilterApiCallData["startDate"] = DateTimeHelper.dateFormatDefault.format(dateTime).toString();
        },
      ),
    );
  }

  endDateTextFieldView() {
    return SizedBox(
      width: DeviceType.isTablet
          ? orientation.DeviceOrientation.isLandscape
              ? (Get.width / 3) - 80
              : (Get.width / 2) - 80
          : Get.width,
      child: DiscrepancyAndWorkOrdersDateTime(
        fieldName: "End Date",
        isDense: true,
        disableKeyboard: disableKeyboard,
        showField: true,
        readOnly: selectedFilterDateRangeDropdown["id"] == "-1" ? false : true,
        dateTimeController: discrepancyIndexTextController.putIfAbsent("discrepancy_filter_end_date", () => TextEditingController()),
        dateType: "date",
        onConfirm: (dateTime) {
          discrepancyIndexTextController["discrepancy_filter_end_date"]!.text = DateTimeHelper.dateFormatDefault.format(dateTime).toString();
          indexFilterApiCallData["endDate"] = DateTimeHelper.dateFormatDefault.format(dateTime).toString();
        },
      ),
    );
  }

  ataCodeTextFieldView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text("ATA Code",
              style: TextStyle(
                color: Colors.black,
                fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              )),
        ),
        FormBuilderField(
            name: "discrepancy_filter_ata_code",
            builder: (FormFieldState<dynamic> field) {
              return Center(
                child: TextFieldConstant.dynamicTextField(
                    field: field,
                    controller: discrepancyIndexTextController.putIfAbsent("discrepancy_filter_ata_code", () => TextEditingController()),
                    readOnly: false,
                    showCursor: true,
                    hasIcon: false,
                    isDense: true,
                    hintText: "ATA Code",
                    onChange: (value) {
                      indexFilterApiCallData["ataCode"] = value;
                    }),
              );
            }),
      ],
    );
  }

  ataCodeButtonView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Material(
            color: ColorConstants.black.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.blue, width: 2),
            ),
            child: IconButton(
                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                onPressed: () {
                  ataCodeDialogView();
                },
                icon: const Icon(Icons.search, color: Colors.white, size: 30))),
      ],
    );
  }

  filterLayerSearchButtonView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DiscrepancyAndWorkOrdersMaterialButton(
          onPressed: () async {
            isIndexDataLoading.value = true;
            LoaderHelper.loaderWithGif();
            await indexPageDataViewApiCall(callFrom: "filterSearch");
            isIndexDataLoading.value = false;
            update();
            await EasyLoading.dismiss();
          },
          icon: Icons.search_rounded,
          iconColor: ColorConstants.white,
          buttonText: 'View Result\t\t',
          borderColor: ColorConstants.primary.withValues(alpha: 0.2),
          buttonColor: ColorConstants.button,
          buttonTextColor: ColorConstants.white,
        ),
      ],
    );
  }

  discrepancySearchTree({required List data, required String searchKey}) {
    if (searchKey == "") {
      discrepancyIndexData.sort((a, b) => (b['discrepancyId']).compareTo(a['discrepancyId']));
      isDescending.update("discrepancyId", (value) => true, ifAbsent: () => true);
      for (Map<String, dynamic> element in discrepancyIndexData) {
        items.add(element);
      }
    } else {
      for (Map<String, dynamic> element in data) {
        if (element["discrepancyId"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["date"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["discrepancyType"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["equipment"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["description"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["status"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["airStatus"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        } else if (element["workOrderNumber"].toString().isCaseInsensitiveContains(searchKey)) {
          items.add(element);
        }
      }
    }
  }

  ///---------------FilterLayerView------------------------\\\\\\

  commonFilterViewLayer() {
    return GestureDetector(
        onTap: () {
          Keyboard.close();
          disableKeyboard.value = true;
        },
        child: Material(
            color: ColorConstants.grey.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(color: ColorConstants.primary, width: 1),
            ),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: SizeConstants.contentSpacing,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: SizeConstants.contentSpacing,
                      runSpacing: SizeConstants.contentSpacing - 5,
                      children: [discrepancyTypeDropdownFieldView(), aircraftDropdownFiledView(), additionalInspectionRequiredDropdownFiledView()],
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: SizeConstants.contentSpacing,
                      runSpacing: SizeConstants.contentSpacing - 5,
                      children: [dateRangeDropdownFiledView(), statusDropdownFieldView(), scheduledMaintenanceDropdownFieldView()],
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: SizeConstants.contentSpacing,
                      runSpacing: SizeConstants.contentSpacing - 5,
                      children: [
                        startDateTextFieldView(),
                        endDateTextFieldView(),
                        SizedBox(
                          width: DeviceType.isTablet
                              ? orientation.DeviceOrientation.isLandscape
                                  ? (Get.width / 3) - 80
                                  : (Get.width / 2) - 80
                              : Get.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [Flexible(child: ataCodeTextFieldView()), const SizedBox(width: SizeConstants.contentSpacing * 2.5), ataCodeButtonView()],
                          ),
                        ),
                      ],
                    ),
                    filterLayerSearchButtonView()
                  ],
                ))));
  }

  ///---------------PDFViewForDiscrepancy-------------------\\\\\\

  Future<Uint8List> discrepancyIndexPDFView({PdfPageFormat? pageFormat}) async {
    final doc = pdf.Document();

    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    doc.addPage(
      pdf.MultiPage(
          theme: themeData,
          maxPages: 10000,
          margin: const pdf.EdgeInsets.all(10.0),
          pageFormat: pageFormat,
          crossAxisAlignment: pdf.CrossAxisAlignment.center,
          header: (context) {
            return pdf.Center(
                child: pdf.Text("Discrepancy List",
                    textAlign: pdf.TextAlign.center, style: pdf.TextStyle(fontStyle: pdf.FontStyle.italic, letterSpacing: 1.1, fontWeight: pdf.FontWeight.normal, fontSize: 14)));
          },
          footer: (context) {
            return pdf.Row(mainAxisAlignment: pdf.MainAxisAlignment.spaceAround, children: [pdf.Flexible(child: pdf.Text("Page: ${context.pageNumber}/${context.pagesCount}"))]);
          },
          build: (context) {
            return [
              pdf.SizedBox(height: SizeConstants.contentSpacing),
              pdf.Table(children: [
                pdf.TableRow(decoration: pdf.BoxDecoration(color: PdfColor.fromHex("#4c597f")), children: [
                  pdf.Text("ID", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Date", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Discrepancy Type", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Equipment", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Description", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Status", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Air Status", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Discrepancy", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                  pdf.Text("Work Order", textAlign: pdf.TextAlign.center, style: pdfTextHeaderDesignReturn()),
                ]),
                for (int i = 0; i < discrepancyIndexData.length; i++)
                  pdf.TableRow(decoration: pdf.BoxDecoration(color: i % 2 == 0 ? PdfColors.grey300 : PdfColors.white), children: [
                    pdf.Text("${discrepancyIndexData[i]["discrepancyId"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                    pdf.Text("${discrepancyIndexData[i]["date"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                    pdf.Text("${discrepancyIndexData[i]["discrepancyType"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                    pdf.ConstrainedBox(
                        constraints: const pdf.BoxConstraints(maxWidth: 100.0),
                        child: pdf.Text("${discrepancyIndexData[i]["equipment"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn())),
                    pdf.ConstrainedBox(
                        constraints: const pdf.BoxConstraints(maxWidth: 200.0),
                        child: pdf.Text("${discrepancyIndexData[i]["description"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn())),
                    pdf.Text("${discrepancyIndexData[i]["status"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                    pdf.Text("${discrepancyIndexData[i]["airStatus"]}", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                    pdf.Text("View Discrepancy", textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                    pdf.Text(discrepancyIndexData[i]["workOrder"] == "True" ? "View W/O ${discrepancyIndexData[i]["workOrderNumber"]}" : " ",
                        textAlign: pdf.TextAlign.center, style: pdfTextDataDesignReturn()),
                  ]),
              ]),
            ];
          }),
    );
    return await doc.save();
  }

  pdfTextHeaderDesignReturn() {
    return pdf.TextStyle(color: PdfColors.white, fontWeight: pdf.FontWeight.bold, fontSize: 9);
  }

  pdfTextDataDesignReturn() {
    return pdf.TextStyle(fontWeight: pdf.FontWeight.normal, fontSize: 8);
  }

  ///--------------Discrepancy_New_Table_View_with_Search

  showingItemCountViewReturnNew({required int tableSize, required int totalNumber}) {
    return Text("Showing 1 to $tableSize of $totalNumber entries ${filterSearchEnable.value == true ? "(filtered from $totalNumber total entries)" : ""}",
        textAlign: TextAlign.start, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 4, fontWeight: FontWeight.w800));
  }

  reportTableSearchView({void Function(String)? onChange}) {
    return FormBuilderField(
      name: "report_show_table_search",
      validator: null,
      builder: (FormFieldState<dynamic> field) {
        return TextFieldConstant.dynamicTextField(
          field: field,
          controller: discrepancyIndexTextController.putIfAbsent("discrepancy_table_Data_Search", () => TextEditingController()),
          hasIcon: true,
          setIcon: Icons.search_outlined,
          hintText: "Search data in table",
          onChange: onChange,
        );
      },
    );
  }

  viewForPDFCSVEXCELNew({void Function()? onTapMethodCopy, void Function()? onTapMethodPDF, void Function()? onTapMethodCSV, void Function()? onTapMethodEXCEL}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10.0,
        children: [
          ButtonConstant.dialogButton(enableIcon: true, iconData: Icons.copy, title: "Copy", onTapMethod: onTapMethodCopy),
          ButtonConstant.dialogButton(
            enableIcon: true,
            iconData: Icons.picture_as_pdf_rounded,
            title: "PDF",
            onTapMethod: onTapMethodPDF,
          ),
          ButtonConstant.dialogButton(
            enableIcon: true,
            iconData: MaterialCommunityIcons.file_export,
            title: "CSV",
            onTapMethod: onTapMethodCSV,
          ),
          ButtonConstant.dialogButton(
            enableIcon: true,
            iconData: MaterialCommunityIcons.file_excel,
            title: "Excel",
            onTapMethod: onTapMethodEXCEL,
          ),
        ],
      ),
    );
  }

  discrepancyShowAndChildButtonShowNew({
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
                      Flexible(child: showingItemCountViewReturnNew(tableSize: tableLength, totalNumber: totalNumber)),
                      Flexible(child: reportTableSearchView(onChange: onChange)),
                      Flexible(
                        child: viewForPDFCSVEXCELNew(
                            onTapMethodCopy: onTapMethodCopy, onTapMethodPDF: onTapMethodPDF, onTapMethodCSV: onTapMethodCSV, onTapMethodEXCEL: onTapMethodEXCEL),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: viewForPDFCSVEXCELNew(
                            onTapMethodCopy: onTapMethodCopy, onTapMethodPDF: onTapMethodPDF, onTapMethodCSV: onTapMethodCSV, onTapMethodEXCEL: onTapMethodEXCEL),
                      ),
                      const SizedBox(height: SizeConstants.contentSpacing),
                      showingItemCountViewReturnNew(tableSize: tableLength, totalNumber: totalNumber),
                      const SizedBox(height: SizeConstants.contentSpacing),
                      reportTableSearchView(onChange: onChange)
                    ],
                  ),
          ),
        ));
  }

  tableHeaderTextStyleReturn() {
    return TextStyle(
        fontSize: DeviceType.isTablet ? Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 4 : Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 6,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5);
  }

  sortTableDataFunction({required String keyName, required int i}) {
    items.clear();

    if (keyName.toString().toLowerCase().contains('date')) {
      if (itemsSort[i]) {
        discrepancyIndexData.sort((a, b) => (DateFormat('MM/dd/yyyy').parse(a[keyName])).compareTo(DateFormat('MM/dd/yyyy').parse(b[keyName])));
      } else {
        discrepancyIndexData.sort((a, b) => (DateFormat('MM/dd/yyyy').parse(b[keyName])).compareTo(DateFormat('MM/dd/yyyy').parse(a[keyName])));
      }
    } else {
      if (itemsSort[i]) {
        discrepancyIndexData.sort((a, b) {
          return (a[keyName]).compareTo(b[keyName]);
        });
      } else {
        discrepancyIndexData.sort((a, b) {
          return (b[keyName]).compareTo(a[keyName]);
        });
      }
    }

    itemsSort[i] = !itemsSort[i];
    for (int i = 0; i < discrepancyIndexData.length; i++) {
      items.add(discrepancyIndexData[i]);
    }
    EasyLoading.dismiss();
  }

  discrepancyIndexDataTableHeaderViewReturn() {
    return Row(
      children: [
        DataTable(
          border: TableBorder.all(color: Colors.grey, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
          clipBehavior: Clip.antiAlias,
          columns: [
            DataColumn(
                label: SizedBox(
              width: DeviceType.isTablet ? 240.0 : 160.0,
              child: Center(
                child: TextButton.icon(
                  icon: RotatedBox(
                    quarterTurns: 0,
                    child: Icon(itemsSort[0] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                  ),
                  label: Text('ID #', style: tableHeaderTextStyleReturn()),
                  onPressed: () async {
                    await LoaderHelper.loaderWithGifAndText('Processing');
                    sortTableDataFunction(keyName: 'discrepancyId', i: 0);
                  },
                ),
              ),
            ))
          ],
          rows: [],
          headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: tableHeaderScrollController,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
              clipBehavior: Clip.antiAlias,
              columns: [
                DataColumn(
                    label: SizedBox(
                  width: 200.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[1] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Date', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'date', i: 1);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[2] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Discrepancy Type', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'discrepancyType', i: 2);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 320.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[3] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Equipment', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'equipment', i: 3);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 600.0 : 450.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[4] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Description', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'description', i: 4);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[5] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Air Status', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'airStatus', i: 5);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[6] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Status', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'status', i: 6);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[7] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('Discrepancy', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'isDiscrepancy', i: 7);
                      },
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: TextButton.icon(
                      icon: RotatedBox(
                        quarterTurns: 0,
                        child: Icon(itemsSort[8] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                      ),
                      label: Text('W/O View', style: tableHeaderTextStyleReturn()),
                      onPressed: () async {
                        await LoaderHelper.loaderWithGifAndText('Processing');
                        sortTableDataFunction(keyName: 'workOrderNumber', i: 8);
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

  discrepancyIndexTableDataViewNew() {
    List<Map<String, dynamic>> finalTableViewItems = items.length > 100 ? items.getRange(start.value, end.value).toList() : items;

    if (finalTableViewItems.isNotEmpty) {
      String longestName = finalTableViewItems.map((item) => item['description'] as String).reduce((a, b) => a.length > b.length ? a : b);
      maxCharacters = longestName.length;
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Row(
            children: [
              DataTable(
                border: TableBorder.all(color: Colors.grey, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0))),
                clipBehavior: Clip.antiAlias,
                // dataRowMinHeight: 55.0,
                dataRowMaxHeight: maxCharacters > 400 ? 110.0 : 70.0,
                columns: [
                  DataColumn(
                      label: SizedBox(
                    width: DeviceType.isTablet ? 240.0 : 160.0,
                    child: Center(
                      child: TextButton.icon(
                        icon: RotatedBox(
                          quarterTurns: 0,
                          child: Icon(itemsSort[0] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                        ),
                        label: Text('ID #', style: tableHeaderTextStyleReturn()),
                        onPressed: () async {
                          await LoaderHelper.loaderWithGifAndText('Processing');
                          sortTableDataFunction(keyName: 'discrepancyId', i: 0);
                        },
                      ),
                    ),
                  )),
                ],
                rows: List.generate(finalTableViewItems.length, (abc) {
                  return DataRow(
                      color: abc % 2 == 0
                          ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                          : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                      cells: [
                        DataCell(
                            onTap: () {},
                            SizedBox(
                                width: DeviceType.isTablet ? 240.0 : 160.0,
                                child: Center(
                                    child: Text("${finalTableViewItems[abc]['discrepancyId']}",
                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2)))))
                      ]);
                }),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: tableDataScrollController,
                  child: DataTable(
                      border: TableBorder.all(color: Colors.grey, borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0))),
                      clipBehavior: Clip.antiAlias,
                      // dataRowMinHeight: 55.0,
                      dataRowMaxHeight: maxCharacters > 400 ? 110.0 : 70.0,
                      columns: [
                        DataColumn(
                            label: SizedBox(
                          width: 200.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[1] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Date', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'date', i: 1);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: 260.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[2] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Discrepancy Type', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'discrepancyType', i: 2);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: 320.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[3] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Equipment', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'equipment', i: 3);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: DeviceType.isTablet ? 600.0 : 450.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[4] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Description', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'description', i: 4);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: 260.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[5] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Air Status', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'airStatus', i: 5);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: 260.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[6] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Status', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'status', i: 6);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: 260.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[7] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('Discrepancy', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'isDiscrepancy', i: 7);
                              },
                            ),
                          ),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: 260.0,
                          child: Center(
                            child: TextButton.icon(
                              icon: RotatedBox(
                                quarterTurns: 0,
                                child: Icon(itemsSort[8] ? Icons.arrow_downward : Icons.arrow_upward, size: SizeConstants.iconSize, color: Colors.white),
                              ),
                              label: Text('W/O View', style: tableHeaderTextStyleReturn()),
                              onPressed: () async {
                                await LoaderHelper.loaderWithGifAndText('Processing');
                                sortTableDataFunction(keyName: 'workOrderNumber', i: 8);
                              },
                            ),
                          ),
                        )),
                      ],
                      rows: List.generate(finalTableViewItems.length, (abc) {
                        return DataRow(
                            color: abc % 2 == 0
                                ? WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.1))
                                : WidgetStatePropertyAll(ColorConstants.primary.withValues(alpha: 0.4)),
                            cells: [
                              DataCell(SizedBox(
                                  width: 200.0,
                                  child: Center(
                                      child:
                                          Text("${finalTableViewItems[abc]['date']}", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                              DataCell(SizedBox(
                                  width: 260.0,
                                  child: Center(
                                      child: Text("${finalTableViewItems[abc]['discrepancyType']}",
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                              DataCell(SizedBox(
                                  width: 320.0,
                                  child: Center(
                                      child: Text("${finalTableViewItems[abc]['equipment']}",
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                              DataCell(SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: DeviceType.isTablet ? 600.0 : 450.0,
                                      child: Center(
                                          child: Text("${finalTableViewItems[abc]['description']}",
                                              style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2)))),
                                ),
                              )),
                              DataCell(SizedBox(
                                  width: 260.0,
                                  child: Center(
                                      child: Text("${finalTableViewItems[abc]['airStatus']}",
                                          style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displaySmall!.fontSize! - 2))))),
                              DataCell(SizedBox(width: 260.0, height: 65.0, child: Center(child: statusButtonReturn(items: finalTableViewItems[abc])))),
                              DataCell(SizedBox(width: 260.0, child: Center(child: discrepancyButtonReturn(items: finalTableViewItems[abc])))),
                              DataCell(SizedBox(
                                  width: 260.0,
                                  child: Center(child: finalTableViewItems[abc]["workOrder"] == "True" ? workOrderButtonReturn(items: finalTableViewItems[abc]) : const Text("")))),
                            ]);
                      })),
                ),
              ),
            ],
          ),
        ),
        discrepancyIndexDataTableHeaderViewReturn(),
      ],
    );
  }

  discrepancyIndexDataTableBottomHeaderViewReturn() {
    return Row(
      children: [
        DataTable(
          border: TableBorder.all(color: Colors.grey, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0))),
          clipBehavior: Clip.antiAlias,
          columns: [
            DataColumn(
                label: SizedBox(
              width: DeviceType.isTablet ? 240.0 : 160.0,
              child: Center(
                child: Text('ID #', style: tableHeaderTextStyleReturn()),
              ),
            ))
          ],
          rows: [],
          headingRowColor: const WidgetStatePropertyAll(ColorConstants.primary),
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: tableBottomHeaderScrollController,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10.0))),
              clipBehavior: Clip.antiAlias,
              columns: [
                DataColumn(
                    label: SizedBox(
                  width: 200.0,
                  child: Center(
                    child: Text('Date', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: Text('Discrepancy Type', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 320.0,
                  child: Center(
                    child: Text('Equipment', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: DeviceType.isTablet ? 600.0 : 450.0,
                  child: Center(
                    child: Text('Description', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: Text('Air Status', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: Text('Status', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: Text('Discrepancy', style: tableHeaderTextStyleReturn()),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 260.0,
                  child: Center(
                    child: Text('W/O View', style: tableHeaderTextStyleReturn()),
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
}
