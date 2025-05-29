import 'dart:ui';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/provider/flight_operation_and_documents_api_provider.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/buttons.dart';

class FileEditNewLogic extends GetxController {
  RxBool isLoading = false.obs;

  String appVarTitle = '';

  Map<String, dynamic> userPermissionData = {};

  String fileId = '';

  RxMap<String, dynamic> fileEditNewApiData = <String, dynamic>{}.obs;

  Map<String, dynamic> documentsEditUpdateApiData = {
    "GivenDate": "",
    "FileName": null,
    "Description": "",
    "CreatedAt": "",
    "CreatedById": 0,
    "CreatedByName": null,
    "LastEditAt": "",
    "LastEditById": null,
    "LastEditByName": null,
    "Required": 1,
    "RequiredByDate": "",
    "RequiredUserRoles": "",
    "RequiredType": 0,
    "DocumentCategoryId": 0,
    "FlightOpsId": 0,
    "UserId": UserSessionInfo.userId.toString(),
    "SystemId": UserSessionInfo.systemId.toString(),
  };

  RxMap<String, TextEditingController> fileEditNewTextEditingController = <String, TextEditingController>{}.obs;

  RxList documentTypeDropdownData = [].obs;
  RxMap selectedDocumentTypeDropdown = {}.obs;

  RxList requiredForStaffDropdownData = [].obs;
  RxMap selectedRequiredForStaffDropdown = {}.obs;

  RxList requiredForTypeDropdownData = [].obs;
  RxMap selectedRequiredForTypeDropdown = {}.obs;

  RxList selectRequiredForItemData = [].obs;

  RxBool disableKeyboard = true.obs;

  RxBool selectAllCheckBox = false.obs;

  RxList selectedUserDataList = [].obs;

  RxList checkBoxStatus = [].obs;

  RxList availableUserRolesDataJson = [].obs;

  RxMap documentsViewComplianceAllUserData = {}.obs;

  RxInt touchedIndex = 0.obs;

  RxString staffId = ''.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    appVarTitle = Get.parameters['title']!;

    if (Get.parameters["routesForm"] == "uploadFile") {
      fileId = Get.parameters["fileId"]!;
    } else {
      fileId = Get.parameters["fileId"]!.substring(1);
    }

    await fileEditNewApiCall();

    await apiCallForFlightOpsEditViewCompliance();

    await initialLoadSelectedMany();

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  fileEditNewApiCall() async {
    Response? data = await FlightOperationAndDocumentsApiProvider().flightOperationAndDocumentsIndexEditFile(fileId: fileId);

    if (data?.statusCode == 200) {
      fileEditNewApiData.addAll(data?.data['data']);

      await fileEditUpdateDataSetFunction();

      await textFileDataSetFunction();

      documentTypeDropdownData.addAll(fileEditNewApiData['documentType']);
      await dropDownDataSetFunction(dropdownData: documentTypeDropdownData, selectedValue: selectedDocumentTypeDropdown);

      requiredForStaffDropdownData.addAll(fileEditNewApiData['requiredForStaff']);
      for (int i = 0; i < requiredForStaffDropdownData.length; i++) {
        if (requiredForStaffDropdownData[i]['id'].toString() == fileEditNewApiData['flightOps']['required'].toString()) {
          selectedRequiredForStaffDropdown.value = requiredForStaffDropdownData[i];
        }
      }

      requiredForTypeDropdownData.addAll(fileEditNewApiData['requiredForType']);
      for (int i = 0; i < requiredForTypeDropdownData.length; i++) {
        if (fileEditNewApiData['flightOps']['requiredType'].toString() == requiredForTypeDropdownData[i]['id'].toString()) {
          selectedRequiredForTypeDropdown.addAll(requiredForTypeDropdownData[i]);
        }
      }

      staffId.value = fileEditNewApiData['flightOps']['requiredUserRoles'];
    }
  }

  fileEditUpdateDataSetFunction() {
    documentsEditUpdateApiData["GivenDate"] = fileEditNewApiData['flightOps']['givenDate'];
    documentsEditUpdateApiData["FileName"] = fileEditNewApiData['flightOps']['fileName'];
    documentsEditUpdateApiData["Description"] = fileEditNewApiData['flightOps']['description'];
    documentsEditUpdateApiData["CreatedAt"] = fileEditNewApiData['flightOps']['createdAt'];
    documentsEditUpdateApiData["CreatedById"] = fileEditNewApiData['flightOps']['createdById'];
    documentsEditUpdateApiData["CreatedByName"] = fileEditNewApiData['flightOps']['createdByName'];
    documentsEditUpdateApiData["LastEditAt"] = fileEditNewApiData['flightOps']['lastEditAt'];
    documentsEditUpdateApiData["LastEditById"] = fileEditNewApiData['flightOps']['lastEditById'];
    documentsEditUpdateApiData["LastEditByName"] = fileEditNewApiData['flightOps']['lastEditByName'];
    documentsEditUpdateApiData["Required"] = fileEditNewApiData['flightOps']['required'];
    documentsEditUpdateApiData["RequiredByDate"] = fileEditNewApiData['flightOps']['requiredByDate'];
    documentsEditUpdateApiData["RequiredUserRoles"] = fileEditNewApiData['flightOps']['requiredUserRoles'];
    documentsEditUpdateApiData["RequiredType"] = fileEditNewApiData['flightOps']['requiredType'];
    documentsEditUpdateApiData["DocumentCategoryId"] = fileEditNewApiData['flightOps']['documentCategoryId'];
    documentsEditUpdateApiData["FlightOpsId"] = fileId;
    documentsEditUpdateApiData["UserId"] = fileEditNewApiData['userId'].toString();
    documentsEditUpdateApiData["SystemId"] = fileEditNewApiData['systemId'].toString();
  }

  textFileDataSetFunction() {
    fileEditNewTextEditingController.putIfAbsent('givenDate', () => TextEditingController());
    fileEditNewTextEditingController['givenDate']!.text = DateFormat("MM/dd/yyyy").format(DateTime.parse(fileEditNewApiData['flightOps']['givenDate']));

    fileEditNewTextEditingController.putIfAbsent('description', () => TextEditingController());
    fileEditNewTextEditingController['description']!.text = fileEditNewApiData['flightOps']['description'];

    fileEditNewTextEditingController.putIfAbsent('requiredByDate', () => TextEditingController());
    fileEditNewTextEditingController['requiredByDate']!.text = DateFormat("MM/dd/yyyy").format(DateTime.parse(fileEditNewApiData['flightOps']['requiredByDate']));
  }

  dropDownDataSetFunction({required List dropdownData, required Map selectedValue}) {
    for (int i = 0; i < dropdownData.length; i++) {
      if (dropdownData[i]['selected'] == true) {
        selectedValue.addAll(dropdownData[i]);
      }
    }
  }

  changeButtonPopUpUpdate() {
    selectedUserDataList.clear();

    List abc = staffId.value.split(',');

    abc.removeWhere((item) => item.isEmpty);

    List<int> intResult = abc.map((item) => int.parse(item)).toList();

    for (Map element in availableUserRolesDataJson) {
      if (intResult.contains(int.parse(element['id'].toString()))) {
        checkBoxStatus.add(true);
        selectedUserDataList.add(element);
      } else {
        checkBoxStatus.add(false);
      }
    }
  }

  selectAllUserCheck() {
    int re = 0;
    for (int i = 0; i < availableUserRolesDataJson.length; i++) {
      if (checkBoxStatus[i] == true) {
        re = re + 1;
      }
    }
    if (re == availableUserRolesDataJson.length) {
      return selectAllCheckBox.value = true;
    } else {
      return selectAllCheckBox.value = false;
    }
  }

  initialLoadSelectedMany() async {
    Response? data = await FlightOperationAndDocumentsApiProvider().flightOperationAndDocumentsIndexEditFileLoadSelectedRequiredType(
      requiredTypeId: fileEditNewApiData['flightOps']['requiredType'].toString(),
      requiredUserRoles: '',
    );
    if (data!.statusCode == 200) {
      List matchData = data.data['data']['requiredForSelectMany'];

      List abc = fileEditNewApiData['flightOps']['requiredUserRoles'].toString().split(',');

      for (int i = 0; i < matchData.length; i++) {
        for (int j = 0; j < abc.length; j++) {
          if (abc[j].toString() == matchData[i]['id']) {
            selectedUserDataList.add(matchData[i]);
          }
        }
      }
    }
  }

  apiCallForLoadSelectedMany() async {
    Response? data = await FlightOperationAndDocumentsApiProvider().flightOperationAndDocumentsIndexEditFileLoadSelectedRequiredType(
      requiredTypeId: selectedRequiredForTypeDropdown['id'],
      requiredUserRoles: fileEditNewApiData['flightOps']['requiredUserRoles'],
    );

    if (data?.statusCode == 200) {
      availableUserRolesDataJson.addAll(data?.data['data']['requiredForSelectMany']);
      await EasyLoading.dismiss();
    }
  }

  apiCallForFlightOpsEditViewCompliance() async {
    Response? data = await FlightOperationAndDocumentsApiProvider().flightOperationAndDocumentsIndexEditFileViewCompliance(fileId: fileId);
    if (data?.statusCode == 200) {
      documentsViewComplianceAllUserData.addAll(data?.data['data']);
    }
  }

  viewFlightOpsDocumentViewComplianceDialog() {
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Center(
                    child: Text(
                      "Flight Ops Document Compliance",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      'For ${fileEditNewApiData['flightOps']['description']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Center(
                    child: Text(
                      'As Of ${DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTimeHelper.now)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          fileEditNewApiData['flightOps']['required'].toString() != '0'
                              ? Wrap(alignment: WrapAlignment.spaceBetween, spacing: 10.0, runSpacing: 5.0, children: [complianceReport(), allRequiredUsersList()])
                              : Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 10.0,
                                runSpacing: 5.0,
                                children: [
                                  Column(
                                    children: [
                                      Text('Compliance Report', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.bold)),
                                      Material(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.black)),
                                        child: SizedBox(
                                          height: 200.0,
                                          width:
                                              DeviceType.isTablet
                                                  ? DeviceOrientation.isLandscape
                                                      ? Get.width / 4
                                                      : Get.width / 2.5
                                                  : Get.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              spacing: 10.0,
                                              children: [
                                                RichText(
                                                  textScaler: TextScaler.linear(Get.textScaleFactor),
                                                  text: TextSpan(
                                                    text: '# Compliance Report:\t',
                                                    style: TextStyle(
                                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                                      fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: 'O of O Users.',
                                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  textScaler: TextScaler.linear(Get.textScaleFactor),
                                                  text: TextSpan(
                                                    text: 'Required Compliance:\t',
                                                    style: TextStyle(
                                                      color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                                      fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: 'No By 1/1/1900',
                                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 1, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'All Required Users List',
                                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.bold),
                                      ),
                                      Material(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.black)),
                                        child: SizedBox(
                                          height: 200.0,
                                          width:
                                              DeviceType.isTablet
                                                  ? DeviceOrientation.isLandscape
                                                      ? Get.width / 4
                                                      : Get.width / 2.5
                                                  : Get.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: RichText(
                                              textScaler: TextScaler.linear(Get.textScaleFactor),
                                              text: TextSpan(
                                                text: 'No User Roles Found',
                                                style: TextStyle(
                                                  color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                                                  fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  allRequiredUsersList() {
    return Column(
      spacing: 10.0,
      children: [
        Text('All Required Users List', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.bold)),
        for (int i = 0; i < documentsViewComplianceAllUserData['complianceData'].length; i++) userTableDataView(i: i),
      ],
    );
  }

  userTableDataView({required int i}) {
    return SizedBox(
      width:
          DeviceType.isTablet
              ? DeviceOrientation.isLandscape
                  ? Get.width / 2.8
                  : (Get.width - 100.0)
              : Get.width,
      child: Table(
        border: TableBorder.all(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
        ),
        // Adds a border to the table
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: DeviceType.isTablet ? const FixedColumnWidth(250.0) : const FixedColumnWidth(140.0), // Fixed width for the first column
          1: const FlexColumnWidth(150.0), // Flexible width for the second column
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: ColorConstants.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    documentsViewComplianceAllUserData['complianceData'][i]['categoryName'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Date Viewed', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
          for (int j = 0; j < documentsViewComplianceAllUserData['complianceData'][i]['users'].length; j++)
            TableRow(
              decoration: BoxDecoration(
                color: ColorConstants.primary.withValues(alpha: 0.3),
                borderRadius:
                    j == (documentsViewComplianceAllUserData['complianceData'][i]['users'].length - 1)
                        ? const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))
                        : BorderRadius.zero,
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(documentsViewComplianceAllUserData['complianceData'][i]['users'][j]['userName'], style: TextStyle(color: userNameColorReturn(i: i, j: j))),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(documentsViewComplianceAllUserData['complianceData'][i]['users'][j]['dateViewed'])) ==
                              '01/01/1900 12:00:00 AM'
                          ? ''
                          : DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(documentsViewComplianceAllUserData['complianceData'][i]['users'][j]['dateViewed'])),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  //--------NEED To Check this logic.
  userNameColorReturn({required int i, required int j}) {
    if (DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(documentsViewComplianceAllUserData['complianceData'][i]['users'][j]['dateViewed'])) == '01/01/1900 12:00:00 AM') {
      return Colors.red;
    } else {
      return ThemeColorMode.isDark ? Colors.white : Colors.black;
    }
  }

  complianceReport() {
    DateTime complianceReportDate = DateTimeHelper.now;
    DateTime requiredDate = DateTime.parse(fileEditNewApiData['flightOps']['requiredByDate']);
    int strDaysInThisPeriod = requiredDate.difference(complianceReportDate).inDays;

    return Column(
      spacing: 10.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Compliance Report', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.bold)),
        Material(
          color: ColorConstants.primary.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (DeviceType.isTablet && DeviceOrientation.isPortrait) SizedBox(width: Get.width),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    SizedBox(
                      height: 250.0,
                      width:
                          DeviceType.isTablet
                              ? DeviceOrientation.isLandscape
                                  ? 300.0
                                  : (Get.width / 2.5)
                              : (Get.width),
                      child: PieChart(
                        PieChartData(
                          sections: getSections(),
                          centerSpaceRadius: 0, // Makes it look like a donut chart
                          sectionsSpace: 2,
                          startDegreeOffset: 270.0,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.0,
                      children: [legend(color: Colors.blue, label: 'Viewed'), legend(color: Colors.red, label: 'Not Viewed')],
                    ),
                  ],
                ),
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                    ),
                    children: [
                      TextSpan(
                        text: '# of Compliant Users:\t',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 2),
                      ),
                      TextSpan(
                        text: '${documentsViewComplianceAllUserData['totalViewed']} of ${documentsViewComplianceAllUserData['totalUsers']} Users',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 3),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Required Compliance:\t',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 2),
                      ),
                      TextSpan(
                        text: 'Yes By ${DateFormat("MM/dd/yyyy").format(DateTime.parse(fileEditNewApiData['flightOps']['requiredByDate']))}',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 3),
                      ),
                      TextSpan(
                        text: '\t($strDaysInThisPeriod Days)',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.titleMedium!.fontSize! + 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  legend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Container(width: 15, height: 15, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: color)), const SizedBox(width: 5), Text(label)],
    );
  }

  List<PieChartSectionData> getSections() {
    double viewedPercentage = (documentsViewComplianceAllUserData['totalViewed'] / documentsViewComplianceAllUserData['totalUsers']) * 100;
    double notViewedPercentage = (documentsViewComplianceAllUserData['totalNotViewed'] / documentsViewComplianceAllUserData['totalUsers']) * 100;

    return [
      PieChartSectionData(
        value: documentsViewComplianceAllUserData['totalViewed'].toDouble(),
        // 16 out of 39 users
        color: ColorConstants.primary,
        title: '${viewedPercentage.toStringAsFixed(1)} %',
        radius: 120.0,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        badgePositionPercentageOffset: 10.0,
      ),
      PieChartSectionData(
        value: documentsViewComplianceAllUserData['totalNotViewed'].toDouble(),
        // Remaining users
        color: ColorConstants.red,
        title: '${notViewedPercentage.toStringAsFixed(1)} %',
        radius: 120.0,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        badgePositionPercentageOffset: 10.0,
      ),
    ];
  }

  fileEditUpdateApiCall() async {
    Response? data = await FlightOperationAndDocumentsApiProvider().flightOperationAndDocumentsEditUpdate(data: documentsEditUpdateApiData);
    if (data!.statusCode == 200) {
      if (Get.parameters["routesForm"] == "uploadFile") {
        Get.offNamedUntil(Routes.flightOpsAndDocuments, ModalRoute.withName(Routes.dashBoard));
      } else {
        Get.back(result: true);
      }
    }
  }

  fileDeleteDialogView() {
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  Center(
                    child: Text(
                      "Delete Flight Ops Item",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Confirm Ok To Delete The Flight Ops Item - ${fileEditNewApiData['flightOps']['description']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 5.0,
                    alignment: WrapAlignment.end,
                    children: [
                      ButtonConstant.dialogButton(
                        title: "Cancel",
                        borderColor: ColorConstants.black,
                        btnColor: ColorConstants.primary,
                        onTapMethod: () {
                          Get.back();
                        },
                      ),
                      ButtonConstant.dialogButton(
                        title: "Delete Flight Ops Item ${fileEditNewApiData['flightOps']['description']}",
                        borderColor: ColorConstants.red,
                        btnColor: ColorConstants.red,
                        onTapMethod: () async {
                          LoaderHelper.loaderWithGif();
                          await fileDeleteApiCall();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  fileDeleteApiCall() async {
    Response? data = await FlightOperationAndDocumentsApiProvider().flightOperationAndDocumentsIndexDeleteFile(fileId: fileId);
    if (data!.statusCode == 200) {
      if (data.data['data']['isFileDeleted']) {
        await EasyLoading.dismiss();
        SnackBarHelper.openSnackBar(isError: false, message: 'Flight Ops Item Deleted Successfully! (ID: $fileId)');
        if (Get.parameters["routesForm"] == "uploadFile") {
          Get.offNamedUntil(Routes.flightOpsAndDocuments, ModalRoute.withName(Routes.dashBoard));
        } else {
          Get.back(closeOverlays: true);
          Get.back(result: true);
        }
      }
    }
  }
}
