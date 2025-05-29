import 'dart:ui';

import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/provider/mel_api_provider.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;

class MelAircraftTypesLogic extends GetxController {
  RxBool isLoading = false.obs;
  RxBool tableViewHide = false.obs;
  RxList tableViewDataAdd = [].obs;
  RxList melAircraftTypesApiData = [].obs;
  RxString buttonId = "".obs;
  RxString buttonAircraftTypes = "".obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    await getApiData();

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  getApiData() async {
    melAircraftTypesApiData.clear();
    tableViewDataAdd.clear();
    tableViewHide.value = false;
    buttonId.value = "";
    buttonAircraftTypes.value = "";

    Response data = await MelApiProvider().melGetAircraftTypesData();
    if (data.statusCode == 200) {
      melAircraftTypesApiData.addAll(data.data["data"]["melAircraftTypes"]["objMELACtypesView"]);
    } else {
      await EasyLoading.dismiss();
      SnackBarHelper.openSnackBar(isError: true, message: "Check Your Internet Connection & Try Again.");
      Get.back();
    }
  }

  getMelAircraftTypesDetails({required String acTypeId, required String acType}) async {
    Response data = await MelApiProvider().melGetAircraftTypesDetailsData(acType: acType, acTypeId: acTypeId);

    if (data.statusCode == 200) {
      tableViewDataAdd.clear();
      tableViewDataAdd.addAll(data.data["data"]["melAircraftTypes"]["objMELACTypesViewDoc"]);
    }
  }

  viewReturnForMelAircraftTypes() {
    return melAircraftTypesApiData.isNotEmpty
        ? ListView(
            children: [
              SizedBox(
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                    itemCount: melAircraftTypesApiData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: MaterialButton(
                          height: SizeConstants.contentSpacing * 5,
                          color: melAircraftTypesApiData[item]["id"].toString() == buttonId.value ? ColorConstants.button : const Color.fromRGBO(76, 89, 127, 1.0),
                          padding: const EdgeInsets.all(5.0),
                          onPressed: () async {
                            buttonId.value = "";
                            buttonAircraftTypes.value = "";
                            buttonId.value = melAircraftTypesApiData[item]["id"].toString();
                            buttonAircraftTypes.value = melAircraftTypesApiData[item]["aircraftType"].toString().split(' ')[0];

                            await getMelAircraftTypesDetails(
                                acTypeId: melAircraftTypesApiData[item]["id"].toString(), acType: melAircraftTypesApiData[item]["aircraftType"].toString().split(' ')[0]);
                            tableViewHide.value = true;
                          },
                          child: Text(melAircraftTypesApiData[item]["aircraftType"], style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: SizeConstants.contentSpacing - 5),
              tableViewHide.value != false
                  ? Column(
                      children: [
                        tableDataViewForMelAircraftTypes(),
                        if (tableViewDataAdd.isEmpty) const SizedBox(height: SizeConstants.contentSpacing - 5),
                        if (tableViewDataAdd.isEmpty) const Text("No Documents Found"),
                        const SizedBox(height: SizeConstants.contentSpacing - 5),
                        addNewMelDocsButtonView(),
                      ],
                    )
                  : const SizedBox(),
            ],
          )
        : Center(
            child: Text("No Data Available for Aircraft Types",
                style: TextStyle(color: Colors.red, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2, fontWeight: FontWeight.bold, letterSpacing: 1.2)));
  }

  returnTableTitle({title}) {
    return SizedBox(
        height: SizeConstants.contentSpacing * 5,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, letterSpacing: 1.2),
          ),
        )));
  }

  returnTableButtonView({
    Color color = Colors.red,
    required void Function()? onPressed,
    required IconData? icon,
    Color iconColor = Colors.white,
    required String title,
    Color textColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: Colors.black)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, color: iconColor), Text(title, style: TextStyle(color: textColor))],
        ),
      ),
    );
  }

  tableDataViewForMelAircraftTypes() {
    return Row(
      children: [
        Table(
          defaultColumnWidth: const IntrinsicColumnWidth(flex: 5),
          border: TableBorder.all(width: 2, color: ColorConstants.background),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
                decoration: const BoxDecoration(
                  color: ColorConstants.primary,
                ),
                children: [
                  returnTableTitle(title: "#"),
                ]),
            for (int i = 0; i < tableViewDataAdd.length; i++)
              TableRow(
                  decoration: BoxDecoration(color: i % 2 != 0 ? Colors.blueAccent.withValues(alpha: 0.4) : Colors.blueAccent.withValues(alpha: 0.1)),
                  children: [SizedBox(height: SizeConstants.contentSpacing * 6, child: Center(child: Text("${i + 1}", textAlign: TextAlign.center)))]),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: IntrinsicColumnWidth(flex: DeviceOrientation.isLandscape ? 5 : 3),
              border: const TableBorder(
                  horizontalInside: BorderSide(color: ColorConstants.background, width: 2),
                  verticalInside: BorderSide(color: ColorConstants.background, width: 2),
                  bottom: BorderSide(color: ColorConstants.background, width: 2),
                  right: BorderSide(color: ColorConstants.background, width: 2),
                  top: BorderSide(color: ColorConstants.background, width: 2)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                    decoration: const BoxDecoration(
                      color: ColorConstants.primary,
                    ),
                    children: [
                      returnTableTitle(title: "View/Download"),
                      returnTableTitle(title: "Last Updated At"),
                      returnTableTitle(title: "Last Updated By"),
                      returnTableTitle(title: "Remove"),
                    ]),
                for (int i = 0; i < tableViewDataAdd.length; i++)
                  TableRow(decoration: BoxDecoration(color: i % 2 != 0 ? Colors.blueAccent.withValues(alpha: 0.4) : Colors.blueAccent.withValues(alpha: 0.1)), children: [
                    returnTableButtonView(
                        title: "View Doc",
                        onPressed: () async {
                          await FileControl.getPathAndViewFile(fileName: tableViewDataAdd[i]["uId"].toString(), fileLocation: tableViewDataAdd[i]["documentPath"].toString());
                        },
                        color: Colors.white,
                        icon: Icons.book,
                        iconColor: Colors.red,
                        textColor: Colors.blue),
                    SizedBox(height: SizeConstants.contentSpacing * 6, child: Center(child: Text(tableViewDataAdd[i]["dateSubmitted"], textAlign: TextAlign.center))),
                    Text(tableViewDataAdd[i]["submittedBy"], textAlign: TextAlign.center),
                    returnTableButtonView(
                        title: "Delete MEL",
                        onPressed: () async {
                          await deleteMelFileDialogConfirm(i: i);
                        },
                        color: Colors.red,
                        icon: Icons.delete_forever),
                  ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  addNewMelDocsButtonView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MaterialButton(
          color: ColorConstants.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: Colors.blueAccent)),
          onPressed: () {
            Get.toNamed(Routes.fileUpload, arguments: "melAircraftTypes", parameters: {"aircraftType": buttonAircraftTypes.value});
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: ColorConstants.background,
              ),
              Text("New MEL Doc", style: TextStyle(color: ColorConstants.background))
            ],
          ),
        ),
      ],
    );
  }

  fileDeleteApiCall({melId}) async {
    Response data = await MelApiProvider().melAircraftTypesDetailsFileDelete(melId: melId);
    if (data.statusCode == 200) {
      Get.back();
      onInit();
      update();
    }
  }

  deleteMelFileDialogConfirm({i}) async {
    return showDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0)
                      : const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 50.0)
                  : const EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Dialog(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                      side: const BorderSide(color: ColorConstants.primary, width: 2),
                    ),
                    child: Material(
                      color: ColorConstants.primary.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Center(
                            child: Text(
                              "Confirm MEL Delete (ID: ${tableViewDataAdd[i]["uId"].toString()})",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing + 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 10,
                              ),
                              Text("Are You Sure, Want To Delete",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing + 10),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            ButtonConstant.dialogButton(
                              title: "Cancel",
                              btnColor: ColorConstants.red,
                              borderColor: ColorConstants.grey,
                              onTapMethod: () {
                                Get.back();
                              },
                            ),
                            const SizedBox(width: SizeConstants.contentSpacing),
                            ButtonConstant.dialogButton(
                              title: "Confirm",
                              btnColor: ColorConstants.primary,
                              borderColor: ColorConstants.grey,
                              onTapMethod: () async {
                                LoaderHelper.loaderWithGif();
                                await fileDeleteApiCall(melId: tableViewDataAdd[i]["uId"].toString());
                              },
                            ),
                          ])
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
